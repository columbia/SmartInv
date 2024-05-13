1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/AccessControl.sol";
6 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
7 import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
8 import "./interfaces/IRevest.sol";
9 import "./interfaces/IAddressRegistry.sol";
10 import "./interfaces/ILockManager.sol";
11 import "./interfaces/ITokenVault.sol";
12 import "./interfaces/IAddressLock.sol";
13 import "./utils/RevestAccessControl.sol";
14 import "./interfaces/IFNFTHandler.sol";
15 import "./interfaces/IMetadataHandler.sol";
16 
17 contract FNFTHandler is ERC1155, AccessControl, RevestAccessControl, IFNFTHandler {
18 
19     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
20 
21     mapping(uint => uint) public supply;
22     uint public fnftsCreated = 0;
23 
24     /**
25      * @dev Primary constructor to create an instance of NegativeEntropy
26      * Grants ADMIN and MINTER_ROLE to whoever creates the contract
27      */
28     constructor(address provider) ERC1155("") RevestAccessControl(provider) {
29         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
30         _setupRole(PAUSER_ROLE, _msgSender());
31     }
32 
33     /**
34      * @dev See {IERC165-supportsInterface}.
35      */
36     function supportsInterface(bytes4 interfaceId) public view virtual override (AccessControl, ERC1155) returns (bool) {
37         return super.supportsInterface(interfaceId);
38     }
39 
40     function mint(address account, uint id, uint amount, bytes memory data) external override onlyRevestController {
41         supply[id] += amount;
42         fnftsCreated += 1;
43         _mint(account, id, amount, data);
44         
45     }
46 
47     function mintBatchRec(address[] calldata recipients, uint[] calldata quantities, uint id, uint newSupply, bytes memory data) external override onlyRevestController {
48         supply[id] += newSupply;
49         fnftsCreated += 1;
50         for(uint i = 0; i < quantities.length; i++) {
51             _mint(recipients[i], id, quantities[i], data);
52         }
53     }
54 
55     function mintBatch(address to, uint[] memory ids, uint[] memory amounts, bytes memory data) external override onlyRevestController {}
56 
57     function setURI(string memory newuri) external override onlyRevestController {
58         _setURI(newuri);
59     }
60 
61     function burn(address account, uint id, uint amount) external override onlyRevestController {
62         supply[id] -= amount;
63         _burn(account, id, amount);
64     }
65 
66     function burnBatch(address account, uint[] memory ids, uint[] memory amounts) external override onlyRevestController {
67         _burnBatch(account, ids, amounts);
68     }
69 
70     function getBalance(address account, uint id) external view override returns (uint) {
71         return balanceOf(account, id);
72     }
73 
74     function getSupply(uint fnftId) public view override returns (uint) {
75         return supply[fnftId];
76     }
77 
78     function getNextId() public view override returns (uint) {
79         return fnftsCreated;
80     }
81 
82 
83     // OVERIDDEN ERC-1155 METHODS
84 
85     function _beforeTokenTransfer(
86         address operator,
87         address from,
88         address to,
89         uint[] memory ids,
90         uint[] memory amounts,
91         bytes memory data
92     ) internal override {
93         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
94         // Loop because all batch transfers must be checked
95         // Will only execute once on singular transfer
96         if (from != address(0) && to != address(0)) {
97             address vault = addressesProvider.getTokenVault();
98             bool canTransfer = !ITokenVault(vault).getNontransferable(ids[0]);
99             // Only check if not from minter
100             // And not being burned
101             if(ids.length > 1) {
102                 uint iterator = 0;
103                 while (canTransfer && iterator < ids.length) {
104                     canTransfer = !ITokenVault(vault).getNontransferable(ids[iterator]);
105                     iterator += 1;
106                 }
107             }
108             require(canTransfer, "E046");
109         }
110     }
111 
112     function uri(uint fnftId) public view override returns (string memory) {
113         return IMetadataHandler(addressesProvider.getMetadataHandler()).getTokenURI(fnftId);
114     }
115 
116     function renderTokenURI(
117         uint tokenId,
118         address owner
119     ) public view returns (
120         string memory baseRenderURI,
121         string[] memory parameters
122     ) {
123         return IMetadataHandler(addressesProvider.getMetadataHandler()).getRenderTokenURI(tokenId, owner);
124     }
125 
126 }
