import logging
from datetime import datetime
import time
import random
import os

# Configure basic logging to write logs to a file
log_file_path = os.getenv("LOGFILE", '/var/log/loki_dummy.log')
logging.basicConfig(filename=log_file_path, level=logging.INFO, format='%(asctime)s level=%(levelname)s app=myapp component=%(component)s %(message)s')

def generate_log_entries():
    components = ["database", "backend", "UI"]

    while True:
        dice:int = random.randint(0,2)

        match dice:
            case 0:
                log_level = logging.INFO
                log_message = "Information: Application running normally"
            case 1:
                log_level = logging.WARNING
                log_message = "Warning: Resource usage high"
            case 2:
                log_level = logging.ERROR
                log_message = "Critical error: Database connection lost"
        
        component = random.choice(components)

        print(f"Generating log of type {logging.getLevelName(log_level)} with component {component}")

        # Use the extra parameter to dynamically set the 'component' value
        logging.log(log_level, log_message, extra={"component": component})
        time.sleep(1)  # Sleep for 1 second between entries

if __name__ == "__main__":
    generate_log_entries()
    logging.shutdown()