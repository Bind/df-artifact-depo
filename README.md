Basic contract for pooling df artifacts outside of the game for shared use.

- Tracks what deposits people have made so they can be rewarded post game.
- Only permissioned users can withdraw.
- Anyone can deposit.
- Anyone can be whitelisted by existing blessed users.

Scaffolded using https://github.com/FrankieIsLost/forge-template

### Testing Utilities

Includes a `Utilities.sol` contract with common testing methods (like creating users with an initial balance), as well as various other utility contracts.

### Preinstalled dependencies

`ds-test` for testing, `forge-std` for better cheatcode UX, and `solmate` for optimized contract implementations.

### Linting

Pre-configured `solhint` and `prettier-plugin-solidity`. Can be run by

```
npm run solhint
npm run prettier
```

### CI with Github Actions

Automatically run linting and tests on pull requests.

### Default Configuration

Including `.gitignore`, `.vscode`, `remappings.txt`

## Acknowledgement

Inspired by great dapptools templates like https://github.com/gakonst/forge-template, https://github.com/gakonst/dapptools-template and https://github.com/transmissions11/dapptools-template
