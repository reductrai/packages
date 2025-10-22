Standalone tarballs will be published here as GitHub releases.

## Smoke Test

After building a tarball with `reductrai-docker/package-standalone.sh` (output is placed in
`reductrai-docker/dist/`), you can validate the package locally:

```bash
./reductrai-packages/standalone/smoke-test.sh reductrai-docker/dist/reductrai-standalone-v*.tar.gz
```

The script extracts the tarball into a temporary directory, seeds a minimal `.env`, starts the
services via `bin/start.sh`, probes the proxy, dashboard, and AI query endpoints, then stops
everything and removes the temp files. Pass a tarball path explicitly if you keep artifacts
elsewhere.
