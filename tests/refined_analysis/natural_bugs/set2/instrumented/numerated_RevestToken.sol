1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
6 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
7 import "./interfaces/IRevest.sol";
8 import "./interfaces/IAddressRegistry.sol";
9 import "./interfaces/ILockManager.sol";
10 import "./interfaces/ITokenVault.sol";
11 import "./interfaces/IRevestToken.sol";
12 import "./utils/RevestAccessControl.sol";
13 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
14 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
15 
16 
17 contract RevestToken is AccessControlEnumerable, ReentrancyGuard, RevestAccessControl, ERC20Burnable, ERC20Pausable, IRevestToken {
18     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
19 
20     /**
21      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
22      *
23      * See {ERC20-constructor}.
24      */
25     constructor(
26         string memory name,
27         string memory symbol,
28         uint initialSupply,
29         address owner,
30         address provider
31     ) ERC20(name, symbol) RevestAccessControl(provider) {
32         _mint(owner, initialSupply);
33         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
34         _setupRole(PAUSER_ROLE, _msgSender());
35     }
36 
37     /**
38      * @dev Pauses all token transfers.
39      *
40      * See {ERC20Pausable} and {Pausable-_pause}.
41      *
42      * Requirements:
43      *
44      * - the caller must have the `PAUSER_ROLE`.
45      */
46     function pause() external {
47         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
48         _pause();
49     }
50 
51     /**
52      * @dev Unpauses all token transfers.
53      *
54      * See {ERC20Pausable} and {Pausable-_unpause}.
55      *
56      * Requirements:
57      *
58      * - the caller must have the `PAUSER_ROLE`.
59      */
60     function unpause() external {
61         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
62         _unpause();
63     }
64 
65     function _beforeTokenTransfer(
66         address from,
67         address to,
68         uint amount
69     ) internal virtual override(ERC20, ERC20Pausable) {
70         super._beforeTokenTransfer(from, to, amount);
71     }
72 }
