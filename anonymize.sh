#!/usr/bin/env bash
SED_ARGS=(
    -e 's/public:.*$/public: true/'
    -e 's/birthdate:.*$/birthdate: "-"/'
    -e 's/phone:.*$/phone: "-"/'
    -e 's/location:.*$/location: "-"/'
)

if [[ "$1" == "--git" ]]; then
    shift
    sed "${SED_ARGS[@]}"
else
    sed -i "${SED_ARGS[@]}" "$@"
fi
