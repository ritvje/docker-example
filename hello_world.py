"""Hello world example for running Python inside a container."""
import numpy as np
from pathlib import Path
import argparse


if __name__ == "__main__":
   argparser = argparse.ArgumentParser(
       description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
   )
   args = argparser.parse_args()

   print("Hello world!")