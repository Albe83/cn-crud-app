# Resource ID Generation

This document explains how the **Resource ID** service produces unique identifiers using the Snowflake algorithm.

## Overview
The service builds a 64-bit identifier from the current timestamp, a datacenter identifier, a worker identifier and a sequence number that increases when multiple IDs are issued within the same millisecond.

The flowchart in [resourceid_flowchart.mmd](resourceid_flowchart.mmd) shows the main steps involved in the process.

## Steps
1. **Client request** – A client or internal service calls the Resource ID endpoint.
2. **Capture timestamp** – The service reads the current timestamp in milliseconds.
3. **Clock check** – If the timestamp is behind the previous request the service waits for the next millisecond.
4. **Configuration** – It retrieves the datacenter and worker identifiers from its configuration.
5. **Sequence update** – When the timestamp equals the last request the sequence counter is incremented; otherwise it resets to `0`.
6. **Sequence overflow** – If the sequence exceeds its maximum value the service waits for the next millisecond and resets the counter.
7. **ID assembly** – The timestamp, datacenter ID, worker ID and sequence are shifted to compose the 64-bit identifier.
8. **Response** – The generated ID is returned to the caller.
