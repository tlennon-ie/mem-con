## Memory PR Checklist

**Area:** <!-- e.g. backend, product-delivery -->
**Type of change:** <!-- new content / update existing / fix frontmatter -->

### Before merging, verify:

- [ ] Frontmatter is complete (`name`, `description`, `metadata.type`, `metadata.area`, `metadata.last_updated`)
- [ ] `last_updated` date is today's date
- [ ] Content is factual — claims cite a source (meeting notes, Jira, Slack, configured source)
- [ ] No sensitive information included (credentials, PII, internal-only links)
- [ ] Any YAML blocks in reference.md are valid YAML
- [ ] `validate-memory` CI check passes (auto-runs on PR open)

### For seeded areas:
- [ ] `seeded: true` set in frontmatter
- [ ] `manifest.yaml` area entry updated to `seeded: true`
