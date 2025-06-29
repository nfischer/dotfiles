#!/usr/bin/env python3

import argparse
import datetime
import os
import re
import subprocess
import time


exif_metadata_pattern = re.compile(r'^([^:]*)\s*: (.*)$')


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
        if '.' in exif_string:
            return datetime.datetime.strptime(exif_string, '%Y:%m:%d %H:%M:%S.%f')
        return datetime.datetime.strptime(exif_string, '%Y:%m:%d %H:%M:%S')

    @classmethod
    def to_unix_timestamp(cls, my_datetime):
        unix_timestamp = time.mktime(my_datetime.timetuple())
        return unix_timestamp

    @classmethod
    def to_exif(cls, my_datetime):
        if my_datetime.microsecond:
            return my_datetime.strftime('%Y:%m:%d %H:%M:%S.%f')
        return my_datetime.strftime('%Y:%m:%d %H:%M:%S')



def SetTimestamp(fname, my_datetime):
    exif_date = DateTimeHelper.to_exif(my_datetime)

    ExifTool(['-DateTimeOriginal=' + exif_date, fname])
    ExifTool(['-CreateDate=' + exif_date, fname])

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
    parser.add_argument(
            'filenames',
            type=os.path.realpath,
            nargs='*',
            help=('The image files to operate on.'))
    args = parser.parse_args()

    for fname in args.filenames:
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
        else:
            raise Exception('Unimplemented')


if __name__ == '__main__':
    main()
