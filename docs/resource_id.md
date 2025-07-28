# Resource ID Generation

This document explains how the **Resource ID** service produces unique identifiers using the Snowflake algorithm.

## Overview
The service builds a 64-bit identifier from the current timestamp, a datacenter identifier, a worker identifier and a sequence number that increases when multiple IDs are issued within the same millisecond.

The flowchart in [resourceid_flowchart.mmd](resourceid_flowchart.mmd) shows the main steps involved in the process.

## Steps
1. A client or internal service sends a request to the Resource ID endpoint.
2. The service reads the current timestamp in milliseconds.
3. It retrieves its configured datacenter and worker identifiers.
4. If the timestamp matches the last request the sequence counter is incremented; otherwise the sequence resets.
5. The service composes the ID using the timestamp, datacenter ID, worker ID and sequence counter.
6. The generated ID is returned to the caller.
