# Copilot Instructions

## General Guidelines
- Always refer to the `documentation/requirements-specification.md` for functional and non-functional requirements.
- Log all development activities, key decisions, and errors in `documentation/development-log.md`.
- Ensure compatibility with WebOS 4.0 and above, specifically optimized for LG OLED65C8 TVs.

## Roles and Responsibilities

### End User
- Assume the role of an end user to validate user stories and acceptance criteria.
- Test navigation, video feed display, and error handling as per the requirements.
- Ensure the app is intuitive and meets usability standards.

### Analyst
- Analyze the requirements in `documentation/requirements-specification.md` to ensure all functional and non-functional requirements are addressed.
- Identify any gaps or ambiguities in the requirements and document them in `documentation/development-log.md`.

### Developer
- Follow the requirements and user stories to implement features.
- Use simple HTML, CSS, and JavaScript to maintain maintainability.
- Avoid dependencies on Node.js or other build tools.
- Ensure the app supports both pointer and 5-way navigation modes.
- Implement error logging and dynamic configuration of webcam feeds.

### Tester
- Validate the app against the acceptance criteria in `documentation/requirements-specification.md`.
- Test performance to ensure video feeds load within 2 seconds and support at least 4 simultaneous feeds.
- Test compatibility with WebOS 4.0 and above.
- Log all test results and issues in `documentation/development-log.md`.

## Future Enhancements
- Document any additional feature requests or ideas in `documentation/enhancement-ideas.md`.