# JWT, JWS and OIDC

A JSON Web Token (JWT) is a compact, URL-safe way to transfer claims between parties. A JWT typically consists of a header, payload and signature.

When the signature is created using the JSON Web Signature (JWS) standard, recipients can verify the token's integrity and origin. JWTs are commonly used for authentication and authorization in web services.

OpenID Connect (OIDC) builds on OAuth 2.0 and uses JWTs to represent identity information. With OIDC, a client application can obtain an ID token containing details about the authenticated user.

In this repository, requests are authenticated by an OIDC-compliant gateway. After successful login, clients receive a signed JWT that can be verified by downstream services.
