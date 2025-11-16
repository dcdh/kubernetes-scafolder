#!/bin/bash
# necessary when vm has been paused ... and will fix X509 issue when pulling image (ImagePullBackOff)
sudo systemctl restart chronyd
sudo chronyc makestep
date
