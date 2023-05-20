#!/bin/bash

# This file generates hashes from the available Dockerfile(s).
# It also signs the Dockerfile and the hash files with the git ops key.
# Please verify all of the images published ANYWHERE.
# Please check the Dockerfile code before build.

extract_key() {
	if [[ "$1" == "" ]]; then

		# magic
		clear
		cat <<EOF>key.txt
-----BEGIN PGP PUBLIC KEY BLOCK-----

mDMEZGSX0RYJKwYBBAHaRw8BAQdAaVkpJLzr7VZRhK6Dgso6eHONv0+AsbVf3kTY
F4ySB5S0JlZlbm9tIEdpdCBPcHMgPGZiaXdhc3Rha2VuQHJpc2V1cC5uZXQ+iJkE
ExYKAEEWIQRBpEzYqu81pI0Y1Mjaq241SouvUQUCZGSX0QIbAwUJA8QarwULCQgH
AgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCRDaq241SouvUfIVAQDPnJdbPdgg2jxw
dzxKYcwztP4lFZW7ph7scwpCIQ2c6QD/ZLopSV1Dq1Gobc/YXPRW9XInYgtaL7Tp
6rnsEqcl3wq4OARkZJfREgorBgEEAZdVAQUBAQdA0js6lemnM5p0aBuUEwMyV+yb
B3guv9vMaVvFIm/fHx4DAQgHiH4EGBYKACYWIQRBpEzYqu81pI0Y1Mjaq241Souv
UQUCZGSX0QIbDAUJA8QarwAKCRDaq241SouvURGcAQCSPnG1CgKV3W91sCokSFFt
yuCi8uBQVJmSN5svg6zeKgD/dsofebtzfMzUsHP/wlBi5sb+QDfLpyXGHmFwqOUn
JQU=
=Yrkr
-----END PGP PUBLIC KEY BLOCK-----
EOF
		echo "Importing key"
		gpg --import key.txt # import KEY
	  		# display key
	  		gpg --list-keys --keyid-format LONG 0xDAAB6E354A8BAF51
	  	  	# remove artifacts
			rm -r ./*.asc ./*.txt ./*.sig &> /dev/null

		# hash Dockerfile & sign FILE
		# ssh-keygen -Y verify -f allowed_signers -I fbiwastaken@riseup.net -n file -s Dockerfile.sig < Dockerfile
		ssh-keygen -Y sign -f ~/.ssh/vittring -n file Dockerfile
		echo ""
		gpg --default-key 41A44CD8AAEF35A48D18D4C8DAAB6E354A8BAF51 --armor --detach-sign --sign Dockerfile >/dev/null 2>&1
		# verify with
		echo "Signing hash file"
		gpg --default-key 41A44CD8AAEF35A48D18D4C8DAAB6E354A8BAF51 --armor --detach-sign --sign ./*sum* >/dev/null 2>&1
		echo "Done"
		exit
	fi
}


main() {
	extract_key
}

main