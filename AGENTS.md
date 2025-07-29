# Guidelines for AI developers

This document defines the main guidelines for contributing to this repository.

## Repository structure
- Analyze the project structure before modifying files.
- Check the README and any other documentation for specific instructions.
- Store all project documentation inside the `docs` directory.
- Document architecture using diagram-as-code approaches so that diagrams render in GitHub.
- Keep all architectural artifacts consistent whenever they are created or updated.
- Ensure that documentation artifacts (e.g., PlantUML and Mermaid files) are syntactically valid.
  You can lint them with the following commands:
  
  ```bash
  docker run --rm -v $(pwd)/docs:/docs plantuml/plantuml -check docs/puml/*.puml
  docker run --rm -v $(pwd)/docs:/docs ghcr.io/mermaid-js/mermaid-cli mmdc -i docs/commander_sequence.mmd -o /tmp/diagram.svg
  ```

## Architecture and Diagram Guidelines
- Use Mermaid charts for all architectural artifacts stored in `docs`.
- Represent architecture using the C4 model.
- Describe workflows with sequence diagrams.
- Show internal operations with flowcharts or pseudocode.

## Modifying This File
- Modify `AGENTS.md` only when an explicit request is provided.

## Contributions
- Write commit messages in English, clearly and concisely.
- Briefly describe the changes in the commit body.
- Summarize the tests performed and results in the pull request message, if possible.

## Code
- Follow the best practices of the programming language used.
- Avoid unnecessary dependencies.
- Document any added or modified code.
- All code comments and project documentation must be in English.

## Testing
- Run automatic tests, if present, before submitting the pull request.
- Report any errors or issues encountered during execution.

## Pull Request
- Provide a summary of the changes made and the test results.
- Ensure the pull request complies with these guidelines.
