#!/bin/sh
mkdir -p postgres_data
minikube mount $(pwd)/postgres_data:/postgres_data