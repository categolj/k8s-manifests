#!/bin/bash
set -ex

fly -t lemon sp -c $(dirname $0)/pipeline.yml -p blog-api