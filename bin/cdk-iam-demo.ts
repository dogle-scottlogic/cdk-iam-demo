#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { CdkIamDemoStack } from '../lib/cdk-iam-demo-stack';

const app = new cdk.App();
new CdkIamDemoStack(app, 'CdkIamDemoStack');
