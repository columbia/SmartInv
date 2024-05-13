1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "../interfaces/IAddressRegistry.sol";
7 import "../interfaces/IFNFTHandler.sol";
8 
9 contract TokenVaultMigrator is Ownable, IAddressRegistry, IFNFTHandler {
10 
11     /// The active address registry
12     address private provider;
13 
14     constructor(address _provider) Ownable() {
15         provider = _provider;
16     }
17 
18     function initialize(
19         address lock_manager_,
20         address liquidity_,
21         address revest_token_,
22         address token_vault_,
23         address revest_,
24         address fnft_,
25         address metadata_,
26         address admin_,
27         address rewards_
28     ) external override {}
29 
30     ///
31     /// SETTERS
32     ///
33 
34     function setAdmin(address admin) external override onlyOwner {}
35 
36     function setLockManager(address manager) external override onlyOwner {}
37 
38     function setTokenVault(address vault) external override onlyOwner {}
39    
40     function setRevest(address revest) external override onlyOwner {}
41 
42     function setRevestFNFT(address fnft) external override onlyOwner {}
43 
44     function setMetadataHandler(address metadata) external override onlyOwner {}
45 
46     function setDex(address dex) external override onlyOwner {}
47 
48     function setRevestToken(address token) external override onlyOwner {}
49 
50     function setRewardsHandler(address esc) external override onlyOwner {}
51 
52     function setLPs(address liquidToken) external override onlyOwner {}
53 
54     function setProvider(address _provider) external onlyOwner {
55         provider = _provider;
56     }
57 
58     ///
59     /// GETTERS
60     ///
61 
62     function getAdmin() external view override returns (address) {
63         return IAddressRegistry(provider).getAdmin();
64     }
65 
66     function getLockManager() external view override returns (address) {
67         return IAddressRegistry(provider).getLockManager();
68     }
69 
70     function getTokenVault() external view override returns (address) {
71         return IAddressRegistry(provider).getTokenVault();
72     }
73 
74     // Fools the old TokenVault into believing the new token vault can control it
75     function getRevest() external view override returns (address) {
76         return IAddressRegistry(provider).getTokenVault();
77     }
78 
79     /// Fools the old TokenVault into believeing this contract is the FNFTHandler
80     function getRevestFNFT() external view override returns (address) {
81         return address(this);
82     }
83 
84     function getMetadataHandler() external view override returns (address) {
85         return IAddressRegistry(provider).getMetadataHandler();
86     }
87 
88     function getRevestToken() external view override returns (address) {
89         return IAddressRegistry(provider).getRevestToken();
90     }
91 
92     function getDEX(uint index) external view override returns (address) {
93         return IAddressRegistry(provider).getDEX(index);
94     }
95 
96     function getRewardsHandler() external view override returns(address) {
97         return IAddressRegistry(provider).getRewardsHandler();
98     }
99 
100     function getLPs() external view override returns (address) {
101         return IAddressRegistry(provider).getLPs();
102     }
103 
104     function getAddress(bytes32 id) public view override returns (address) {
105         return IAddressRegistry(provider).getAddress(id);
106     }
107 
108 
109     ///
110     /// FNFTHandler mock methods
111     ///
112 
113     function mint(address account, uint id, uint amount, bytes memory data) external override {}
114 
115     function mintBatchRec(address[] memory recipients, uint[] memory quantities, uint id, uint newSupply, bytes memory data) external override {}
116 
117     function mintBatch(address to, uint[] memory ids, uint[] memory amounts, bytes memory data) external override {}
118 
119     function setURI(string memory newuri) external override {}
120 
121     function burn(address account, uint id, uint amount) external override {}
122 
123     function burnBatch(address account, uint[] memory ids, uint[] memory amounts) external override {}
124 
125     function getBalance(address tokenHolder, uint id) external view override returns (uint) {
126         return IFNFTHandler(IAddressRegistry(provider).getRevestFNFT()).getBalance(tokenHolder, id);
127     }
128 
129     function getSupply(uint fnftId) external view override returns (uint supply) {
130         supply = IFNFTHandler(IAddressRegistry(provider).getRevestFNFT()).getSupply(fnftId);
131         supply = supply == 0 ? 1 : supply;
132     }
133 
134     function getNextId() external view override returns (uint nextId) {
135         nextId = IFNFTHandler(IAddressRegistry(provider).getRevestFNFT()).getNextId();
136     }
137 
138 }
