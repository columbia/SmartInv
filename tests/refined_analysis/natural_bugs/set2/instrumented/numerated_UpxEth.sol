1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/presets/ERC1155PresetMinterPauser.sol)
3 
4 pragma solidity 0.8.19;
5 
6 import {ERC1155} from "solmate/tokens/ERC1155.sol";
7 import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
8 
9 /**
10  * @title UpxEth
11  * @notice Semi Fungible token contract used as an IOU by user 
12  * @dev ERC1155 token contract with minting and burning capabilities, using AccessControl for role-based access.
13  *
14  * UpxEth contract includes:
15  * - Total supply tracking for each token ID
16  * - Token burning functionality for holders
17  * - Minter role for token creation
18  *
19  * The contract deploys with the default admin role, allowing it to grant minter and burner roles to other accounts.
20  * The contract uses AccessControl for role-based access control.
21  *
22  * Deprecated in favor of [Contracts Wizard](https://wizard.openzeppelin.com/).
23  * @author redactedcartel.finance
24  */
25 contract UpxEth is AccessControlDefaultAdminRules, ERC1155 {
26     /**
27      * @dev Bytes32 constant representing the role to mint new tokens.
28      */
29     bytes32 internal constant MINTER_ROLE = keccak256("MINTER_ROLE");
30 
31     /**
32      * @dev Bytes32 constant representing the role to burn (destroy) tokens.
33      */
34     bytes32 internal constant BURNER_ROLE = keccak256("BURNER_ROLE");
35 
36     /**
37      * @dev Constructor to initialize the UpxEth contract.
38      * @param _initialDelay uint48 Initial delay for AccessControl's admin lock, set by the contract deployer.
39      */
40     constructor(
41         uint48 _initialDelay
42     ) AccessControlDefaultAdminRules(_initialDelay, msg.sender) {}
43 
44     /**
45      * @notice Mints new tokens for a specific address.
46      * @dev Restricted to accounts with the MINTER_ROLE.
47      * @param to     address Address to receive the minted tokens.
48      * @param id     uint256 Token ID to mint.
49      * @param amount uint256 Amount of tokens to mint.
50      * @param data   bytes   Additional data to include in the minting transaction.
51      */
52     function mint(
53         address to,
54         uint256 id,
55         uint256 amount,
56         bytes calldata data
57     ) external onlyRole(MINTER_ROLE) {
58         _mint(to, id, amount, data);
59     }
60 
61     /**
62      * @notice Mints a batch of new tokens for a specific address.
63      * @dev Restricted to accounts with the MINTER_ROLE.
64      * @param to      address   Address to receive the minted tokens.
65      * @param ids     uint256[] Array of token IDs to mint.
66      * @param amounts uint256[] Array of amounts of tokens to mint.
67      * @param data    bytes     Additional data to include in the minting transaction.
68      */
69     function mintBatch(
70         address to,
71         uint256[] calldata ids,
72         uint256[] calldata amounts,
73         bytes calldata data
74     ) external onlyRole(MINTER_ROLE) {
75         _batchMint(to, ids, amounts, data);
76     }
77 
78     /**
79      * @notice Burns a batch of tokens from a specific address.
80      * @dev Restricted to accounts with the BURNER_ROLE.
81      * @param from    address   Address from which to burn tokens.
82      * @param ids     uint256[] Array of token IDs to burn.
83      * @param amounts uint256[] Array of amounts of tokens to burn.
84      */
85     function burnBatch(
86         address from,
87         uint256[] calldata ids,
88         uint256[] calldata amounts
89     ) external onlyRole(BURNER_ROLE) {
90         _batchBurn(from, ids, amounts);
91     }
92 
93     /**
94      * @notice Burns a specific amount of tokens from a specific address.
95      * @dev Restricted to accounts with the BURNER_ROLE.
96      * @param from   address Address from which to burn tokens.
97      * @param id     uint256 Token ID to burn.
98      * @param amount uint256 Amount of tokens to burn.
99      */
100     function burn(
101         address from,
102         uint256 id,
103         uint256 amount
104     ) external onlyRole(BURNER_ROLE) {
105         _burn(from, id, amount);
106     }
107 
108     /**
109      * @inheritdoc ERC1155
110      * @dev Not implemented due to semi-fungible only requirement
111      */
112     function uri(uint256 id) public view override returns (string memory) {}
113 
114     /**
115      * @inheritdoc ERC1155
116      */
117     function supportsInterface(
118         bytes4 interfaceId
119     )
120         public
121         view
122         override(AccessControlDefaultAdminRules, ERC1155)
123         returns (bool)
124     {
125         return super.supportsInterface(interfaceId);
126     }
127 }
