import os
from exception.ResumeUploadException import ResumeUploadException

def upload_resume(file_path):
    try:
        if not os.path.exists(file_path):
            raise ResumeUploadException("Resume file not found.")
        if not file_path.endswith(('.pdf', '.docx')):
            raise ResumeUploadException("Only .pdf or .docx formats are supported.")
        if os.path.getsize(file_path) > 5 * 1024 * 1024:
            raise ResumeUploadException("Resume file size exceeds 5MB.")
        return file_path
    except ResumeUploadException as e:
        print("Resume Error:", e)
        return None
