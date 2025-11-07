# Contributing to UniverseGuide

Thank you for your interest in contributing to UniverseGuide! This document provides guidelines and instructions for contributing.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
   ```bash
   git clone https://github.com/yourusername/UniverseGuide.git
   cd UniverseGuide
   ```
3. **Set up upstream remote**
   ```bash
   git remote add upstream https://github.com/originalowner/UniverseGuide.git
   ```
4. **Create a feature branch**
   ```bash
   git checkout develop
   git pull upstream develop
   ./scripts/dev/git-create-feature.sh my-feature-name
   ```

## 📋 Development Workflow

### Branch Strategy

We follow a Git Flow-inspired workflow:

- **`main`** - Production-ready code
- **`develop`** - Integration branch for features
- **`feature/*`** - New features (branch from `develop`)
- **`bugfix/*`** - Bug fixes (branch from `develop`)
- **`hotfix/*`** - Critical production fixes (branch from `main`)
- **`release/*`** - Release preparation (branch from `develop`)

See [Git Workflow Documentation](docs/GIT_WORKFLOW.md) for details.

### Creating a Feature Branch

```bash
# Using helper script
./scripts/dev/git-create-feature.sh my-feature client

# Or manually
git checkout develop
git pull origin develop
git checkout -b feature/client/my-feature
```

### Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Tests
- `chore`: Maintenance

**Examples:**
```bash
git commit -m "feat(client): add EarthOps globe component"
git commit -m "fix(api): resolve memory leak in Celery worker"
git commit -m "docs: update API documentation"
```

### Syncing Your Branch

Keep your branch up to date with `develop`:

```bash
# Using helper script
./scripts/dev/git-sync-branch.sh

# Or manually
git checkout feature/my-feature
git fetch origin
git merge origin/develop
# or
git rebase origin/develop
```

## 🧪 Testing

### Before Submitting

1. **Run linters**
   ```bash
   make lint
   ```

2. **Run tests**
   ```bash
   make test
   ```

3. **Check TypeScript types** (if working on client)
   ```bash
   cd apps/client && npm run type-check
   ```

4. **Test locally**
   ```bash
   make dev-up
   # Test your changes at http://localhost:3000
   ```

## 📝 Pull Request Process

1. **Ensure your branch is up to date**
   ```bash
   ./scripts/dev/git-sync-branch.sh
   ```

2. **Push your branch**
   ```bash
   git push -u origin feature/my-feature
   ```

3. **Create Pull Request**
   - Use the PR template
   - Link related issues
   - Add screenshots if applicable
   - Ensure CI passes

4. **Address review feedback**
   - Make requested changes
   - Push updates to your branch
   - PR will update automatically

5. **After merge**
   - Delete your feature branch
   - Update your local `develop`
   ```bash
   git checkout develop
   git pull upstream develop
   ./scripts/dev/git-cleanup-branches.sh
   ```

## 📐 Code Style

### Python

- Follow PEP 8
- Use `ruff` for linting
- Use `black` for formatting
- Maximum line length: 100 characters
- Type hints encouraged

```bash
# Format code
ruff check --fix apps/api apps/ingestion
black apps/api apps/ingestion
```

### TypeScript/JavaScript

- Follow ESLint rules
- Use Prettier for formatting
- Use TypeScript for new code
- Prefer functional components

```bash
# Format code
cd apps/client && npm run lint -- --fix
```

## 🏗️ Project Structure

This is a monorepo with multiple services:

- **`apps/client`** - Next.js frontend
- **`apps/api`** - Django API gateway
- **`apps/ingestion`** - Celery workers
- **`packages/`** - Shared libraries
- **`infra/`** - Infrastructure code
- **`docs/`** - Documentation

See [Directory Map](docs/org.md) for details.

## 🐛 Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md):

1. Check if bug already exists
2. Create new issue with template
3. Provide clear reproduction steps
4. Include environment details
5. Add screenshots/logs if applicable

## 💡 Suggesting Features

Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md):

1. Check if feature already requested
2. Create new issue with template
3. Describe problem and solution
4. Add mockups/examples if possible

## 📚 Documentation

- Update relevant docs when adding features
- Add code comments for complex logic
- Update API documentation if changing endpoints
- Keep README current

## ✅ Checklist Before PR

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass locally
- [ ] No new warnings
- [ ] Commit messages follow convention
- [ ] Branch synced with develop
- [ ] PR description filled out

## 🤝 Code Review Guidelines

### For Authors

- Keep PRs focused and small
- Respond to feedback promptly
- Be open to suggestions
- Explain complex decisions

### For Reviewers

- Be constructive and respectful
- Focus on code, not person
- Suggest improvements clearly
- Approve when ready

## 📞 Getting Help

- **Documentation**: Check `docs/` directory
- **Issues**: Search existing issues
- **Discussions**: Use GitHub Discussions
- **Email**: [Your contact email]

## 🙏 Thank You!

Your contributions make UniverseGuide better. Thank you for taking the time to contribute!

---

**Last updated**: November 2025

