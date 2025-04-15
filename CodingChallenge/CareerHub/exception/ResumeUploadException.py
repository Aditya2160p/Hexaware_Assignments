class ResumeUploadException(Exception):
    def __init__(self, message="Error while uploading resume"):
        super().__init__(message)