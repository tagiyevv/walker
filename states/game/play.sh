#!/bin/bash
zip -r "walker2.zip" * -x play.sh walker2.love

echo "Finished"

mv walker2.zip walker2.love

echo ".love file created"

love walker2.love