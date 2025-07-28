# Resource ID Generation

This document explains how the **Resource ID** service produces unique identifiers using a stateless variant of the Snowflake algorithm.

## Overview
The service builds a 64-bit identifier from the current timestamp, a datacenter identifier, a worker identifier and a random sequence number.

The flowchart in [resourceid_flowchart.mmd](resourceid_flowchart.mmd) shows the main steps involved in the process.

## Steps
1. **Client request** – A client or internal service calls the Resource ID endpoint.
2. **Capture timestamp** – The service reads the current timestamp in milliseconds.
3. **Configuration** – It retrieves the datacenter and worker identifiers from its configuration.
4. **Generate sequence** – A random sequence number is generated for this request.
5. **ID assembly** – The timestamp, datacenter ID, worker ID and sequence are shifted to compose the 64-bit identifier.
6. **Response** – The generated ID is returned to the caller.
