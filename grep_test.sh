#!/bin/bash

# if grep -Fxq 'variables_order = "GPCS"' /usr/local/etc/php/5.6/php.ini
if grep -Fxq 'variables_order = "EGPCS"' /usr/local/etc/php/5.6/php.ini
then
    echo 'yup'
else
    echo 'nope'
fi
