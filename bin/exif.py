#!/usr/bin/env python3

import argparse
import datetime
import os
import re
import subprocess
import time
import readline


exif_metadata_pattern = re.compile(r'^([^:]*)\s*: (.*)$')

IMAGE_VIEWER = 'eog'


def rlinput(prompt, prefill=''):
    readline.set_startup_hook(lambda: readline.insert_text(prefill))
    try:
        return input(prompt)
    finally:
        readline.set_startup_hook()


def ExifTool(exifArgs):
    new_args = ['exiftool'] + exifArgs
    output = subprocess.check_output(new_args, encoding='utf-8')
    if 'image files updated' in output:
        return dict()
    else:
        d = dict()
        for line in output.splitlines():
            m = exif_metadata_pattern.match(line)
            if not m:
                print('Unable to parse line')
                continue
            key = m.group(1).strip()
            value = m.group(2).strip()
            d[key] = value
        return d


class DateTimeHelper:
    @classmethod
    def from_str(cls, datetime_string):
        iso_date = datetime_string.replace(' ', 'T')
        return datetime.datetime.fromisoformat(iso_date)

    @classmethod
    def from_exif(cls, exif_string):
        if exif_string is None:
            return None
        template_str = '%Y:%m:%d %H:%M:%S'
        if '.' in exif_string:
            template_str += '.%f'
        has_timezone = re.compile(r'.*[+\-]\d\d:\d\d')
        if has_timezone.match(exif_string):
            template_str += '%z'
        return datetime.datetime.strptime(exif_string, template_str)

    @classmethod
    def to_unix_timestamp(cls, my_datetime):
        unix_timestamp = time.mktime(my_datetime.timetuple())
        return unix_timestamp

    @classmethod
    def to_exif(cls, my_datetime):
        template_str = '%Y:%m:%d %H:%M:%S'
        if my_datetime.microsecond:
            template_str += '.%f'
        # TODO(nfischer): for some reason the timezone field doesn't seem to
        # work correctly.
        template_str += '%:z'
        return my_datetime.strftime(template_str)


def SetTimestamp(fname, my_datetime):
    exif_date = DateTimeHelper.to_exif(my_datetime)

    ExifTool(['-DateTimeOriginal=' + exif_date, '-CreateDate=' + exif_date, fname])

    unix_timestamp = DateTimeHelper.to_unix_timestamp(my_datetime)
    os.utime(fname, (unix_timestamp, unix_timestamp))


def main():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
            '--date',
            type=str,
            default=None,
            help=('A date and timestamp string. Should be in the '
                  'YYYY-MM-DD HH:MM:SS format.'))
    group.add_argument(
            '--timeshift',
            type=str,
            default=None,
            help=('How many hours to shift by. Can be in the format of '
                  '+1 or -1.'))
    group.add_argument(
            '--timezone',
            type=str,
            default=None,
            help=('Force an exact timezone. This is useful if someone has the '
                  'correct time but forgot to switch from standard time to '
                  'daylight time.'))
    group.add_argument(
            '--fixtimestamp',
            action='store_true',
            help=('Fix the file timestamp. Make it match the CreateDate from '
                  'the exif metadata.'))
    group.add_argument(
            '--crawl',
            action='store_true',
            help=(f'Crawl over all image files in the current folder. If they '
                  f'have a metadata timestamp, skip the file. If the file is '
                  f'missing a metadata timestamp, then it opens the file '
                  f'(using "{IMAGE_VIEWER}") and prompts the user to input a '
                  f'new proper timestamp.'))
    parser.add_argument(
            'filenames',
            type=os.path.realpath,
            nargs='*',
            help=('The image files to operate on.'))
    args = parser.parse_args()

    if args.crawl:
        if args.filenames:
            raise Exception('The --crawl option does not support providing any file names. This automatically crawls all image files in this folder.')
        print('Timestamp format: YYYY-MM-DD HH:MM:SS')
        print('-------------------------------------')
        previous_timestamp = ''
        for fname in os.listdir('.'):
            if not os.path.isfile(fname):
                continue
            if '.' not in fname:
                continue
            extension = fname.split('.')[-1]
            supported_filetypes = set(['HEIC', 'JPG', 'JPEG', 'PNG', 'MOV'])
            if extension.upper() not in supported_filetypes:
                continue
            metadata = ExifTool([fname])
            exif_date = DateTimeHelper.from_exif(metadata.get('Create Date', None))
            exif_date2 = DateTimeHelper.from_exif(metadata.get('Date Time Original', None))
            if not exif_date and not exif_date2:
                print(f'{fname} is missing an EXIF timestamp.')
                proc = subprocess.Popen([IMAGE_VIEWER, fname], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                new_timestamp = rlinput('Give this a new timestamp (or press Enter to skip): ', prefill=previous_timestamp)
                previous_timestamp = new_timestamp
                if new_timestamp:
                    print(f'Setting exact time: {new_timestamp}')
                    my_datetime = DateTimeHelper.from_str(new_timestamp)
                    SetTimestamp(fname, my_datetime)
                else:
                    print(f'Skipping {fname}')
                if proc.poll() is None:
                    proc.terminate()


        return

    if not args.filenames:
        raise Exception('Did not receive a list of file names')

    for fname in args.filenames:
        if not os.path.exists(fname):
            print('Unable to find any files matching ' + fname)
            continue
        if args.date:
            print(f'Setting exact time: {args.date}')
            my_datetime = DateTimeHelper.from_str(args.date)
            SetTimestamp(fname, my_datetime)
        elif args.timeshift:
            metadata = ExifTool([fname])

            original_date = DateTimeHelper.from_exif(metadata['Create Date'])
            offset = int(args.timeshift[1:])
            if args.timeshift[0] == '-':
                new_date = original_date - datetime.timedelta(hours=offset)
            elif args.timeshift[0] == '+':
                new_date = original_date + datetime.timedelta(hours=offset)
            else:
                raise Exception('Unable to parse timeshift. It needs to start '
                                "with a '+' or a '-' character, ex. '+2'.")
            print(f'Shifting time: {original_date} -> {new_date}')
            SetTimestamp(fname, new_date)
        elif args.fixtimestamp:
            metadata = ExifTool([fname])
            exif_date = DateTimeHelper.from_exif(metadata['Create Date'])
            print(f'Setting timestamp to match exif data: {exif_date}')
            SetTimestamp(fname, exif_date)
        elif args.timezone:
            metadata = ExifTool([fname])
            original_date = DateTimeHelper.from_exif(metadata['Create Date'])
            hours = int(args.timezone.split(':')[0])
            minutes = int(args.timezone.split(':')[1])
            new_date = datetime.datetime(
                    year=original_date.year,
                    month=original_date.month,
                    day=original_date.day,
                    hour=original_date.hour,
                    minute=original_date.minute,
                    second=original_date.second,
                    microsecond=original_date.microsecond,
                    tzinfo=datetime.timezone(datetime.timedelta(hours=hours, minutes=minutes)))
            print(f'Changing only the timezone: {original_date} -> {new_date}')
            SetTimestamp(fname, new_date)
        else:
            raise Exception('Unimplemented')


if __name__ == '__main__':
    main()
