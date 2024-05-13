1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/presets/ERC1155PresetMinterPauser.sol)
3 
4 pragma solidity 0.8.19;
5 
6 import {ERC1155} from "solmate/tokens/ERC1155.sol";
7 import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
8 import {Context} from "openzeppelin-contracts/contracts/utils/Context.sol";
9 import {Errors} from "../libraries/Errors.sol";
10 
11 /**
12  * @dev {ERC1155} token, including:
13  *
14  *  - ability to check the total supply for a token id
15  *  - ability for holders to burn (destroy) their tokens
16  *  - a minter role that allows for token minting (creation)
17  *
18  * This contract uses {AccessControl} to lock permissioned functions using the
19  * different roles - head to its documentation for details.
20  *
21  * The account that deploys the contract will be granted the default admin role, 
22  * which will let it grant both minter and burner roles to other accounts.
23  *
24  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
25  */
26 contract ERC1155Solmate is AccessControlDefaultAdminRules, ERC1155 {
27     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
28     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
29 
30     constructor(
31         uint48 _initialDelay
32     ) AccessControlDefaultAdminRules(_initialDelay, msg.sender) {}
33 
34     /**
35         @notice Grant the minter role to an address
36         @param  minter  address  Address to grant the minter role
37      */
38     function grantMinterRole(
39         address minter
40     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
41         if (minter == address(0)) revert Errors.ZeroAddress();
42 
43         _grantRole(MINTER_ROLE, minter);
44     }
45 
46     /**
47      @notice Revoke the minter role from an address
48      @param  minter  address  Address to revoke the minter role
49   */
50     function revokeMinterRole(
51         address minter
52     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
53         if (hasRole(MINTER_ROLE, minter) == false) revert Errors.NotMinter();
54 
55         _revokeRole(MINTER_ROLE, minter);
56     }
57 
58     /**
59         @notice Grant the burner role to an address
60         @param  burner  address  Address to grant the burner role
61      */
62     function grantBurnerRole(address burner)
63         external
64         onlyRole(DEFAULT_ADMIN_ROLE)
65     {
66         if (burner == address(0)) revert Errors.ZeroAddress();
67 
68         _grantRole(BURNER_ROLE, burner);
69     }
70 
71     /**
72      @notice Revoke the burner role from an address
73      @param  burner  address  Address to revoke the burner role
74   */
75     function revokeBurnerRole(address burner)
76         external
77         onlyRole(DEFAULT_ADMIN_ROLE)
78     {
79         if (hasRole(BURNER_ROLE, burner) == false) revert Errors.NotBurner();
80 
81         _revokeRole(BURNER_ROLE, burner);
82     }
83 
84     /**
85      * @dev Creates `amount` new tokens for `to`, of token type `id`.
86      *
87      * See {ERC1155-_mint}.
88      *
89      * Requirements:
90      *
91      * - the caller must have the `MINTER_ROLE`.
92      */
93     function mint(
94         address to,
95         uint256 id,
96         uint256 amount,
97         bytes calldata data
98     ) external onlyRole(MINTER_ROLE) {
99         _mint(to, id, amount, data);
100     }
101 
102     function mintBatch(
103         address to,
104         uint256[] calldata ids,
105         uint256[] calldata amounts,
106         bytes calldata data
107     ) external onlyRole(MINTER_ROLE) {
108         _batchMint(to, ids, amounts, data);
109     }
110 
111     function burnBatch(
112         address from,
113         uint256[] calldata ids,
114         uint256[] calldata amounts
115     ) external onlyRole(BURNER_ROLE) {
116         _batchBurn(from, ids, amounts);
117     }
118 
119     function burn(
120         address from,
121         uint256 id,
122         uint256 amount
123     ) external onlyRole(BURNER_ROLE) {
124         _burn(from, id, amount);
125     }
126 
127     function uri(uint256 id) public view override returns (string memory) {}
128 
129     // Necessary override due to AccessControlDefaultAdminRules having the same method
130     function supportsInterface(
131         bytes4 interfaceId
132     )
133         public
134         pure
135         override(AccessControlDefaultAdminRules, ERC1155)
136         returns (bool)
137     {
138         return
139             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
140             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
141             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
142     }
143 }
