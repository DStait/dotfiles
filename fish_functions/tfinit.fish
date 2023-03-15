function tfinit --description "Init Terraform when backend is S3"
    set -l LINE 'backend \"s3\"'
    # find the file
    set -l BACKEND_FILE (grep -l "$LINE" *)
    # Comment out the line
    sed -i "\|$LINE| s|^#*|#|" $BACKEND_FILE
    # Get correct terraform version
    set -l TF_VERSION (grep "required_version" * | grep -Eo "\d+\.\d+\.\d+")
    tfenv use "$TF_VERSION" > /dev/null
    # Run init
    terraform init
    # Uncomment line
    sed -i "\|$LINE|s|^#||g" $BACKEND_FILE
end
