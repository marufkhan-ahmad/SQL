import logging

# Configure the basic logging settings
import logging
logging.basicConfig(
    filename='bash.logs',
    filemode='w',
    level=logging.DEBUG, 
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S')