import configparser

class DBPropertyUtil:
    @staticmethod
    def getPropertyString(filename):
        config = configparser.ConfigParser()
        config.read(filename)
        return (
            f"DRIVER={config['DEFAULT']['driver']};"
            f"SERVER={config['DEFAULT']['server']};"
            f"DATABASE={config['DEFAULT']['database']};"
            f"Trusted_Connection={config['DEFAULT']['trusted_connection']};"
        )