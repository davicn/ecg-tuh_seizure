import os
from os.path import join, dirname
from dotenv import load_dotenv

dotenv_path = join(dirname('__file__'), '.env')

load_dotenv(dotenv_path)

def load_env():
    return {
        'ROOT_PATH' : os.environ.get("ROOT_PATH"),
        'SOURCE_PATH' : os.environ.get("SOURCE_PATH")
    }

if __name__ == '__main__':
    load_env()