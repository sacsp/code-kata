import unittest
from main import *

class MyTest(unittest.TestCase):

    def test_split_line(self):
        line = "Sachin Patil        028 Data Engineer"
        offsets = [20, 3, 15]
        expected = ['Sachin Patil', '028', 'Data Engineer']
        self.assertEqual(split_line_by_fixed_widths(line, offsets), expected)

    def test_split_line_with_empty_value(self):
        line = "John Doe            030Software Engineer"
        offsets = [20, 3, 15]
        expected = ['John Doe', '030', 'Software Engineer']
        self.assertEqual(split_line_by_fixed_widths(line, offsets), expected)

    def test_split_line_with_empty_value(self):
        line = "0123456789abcdefghijklmnopqrstuvwxyz"
        offsets = [4, 9, 12, 17]
        expected = ['0123', '456789abc', 'defghijklmno', 'pqrstuvwxyz']
        self.assertEqual(split_line_by_fixed_widths(line, offsets), expected)

if __name__ == '__main__':
    unittest.main()
