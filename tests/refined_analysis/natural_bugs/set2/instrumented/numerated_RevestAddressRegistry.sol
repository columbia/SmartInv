1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/access/AccessControl.sol";
7 import "./interfaces/IAddressRegistryV2.sol";
8 import "./RevestToken.sol";
9 
10 contract RevestAddressRegistry is Ownable, IAddressRegistryV2, AccessControl {
11     bytes32 public constant ADMIN = "ADMIN";
12     bytes32 public constant LOCK_MANAGER = "LOCK_MANAGER";
13     bytes32 public constant REVEST_TOKEN = "REVEST_TOKEN";
14     bytes32 public constant TOKEN_VAULT = "TOKEN_VAULT";
15     bytes32 public constant REVEST = "REVEST";
16     bytes32 public constant FNFT = "FNFT";
17     bytes32 public constant METADATA = "METADATA";
18     bytes32 public constant ESCROW = 'ESCROW';
19     bytes32 public constant LIQUIDITY_TOKENS = "LIQUIDITY_TOKENS";
20     bytes32 public constant BREAKER = 'BREAKER';    
21     bytes32 public constant PAUSER = 'PAUSER';
22     bytes32 public constant LEGACY_VAULT = 'LEGACY_VAULT';
23 
24     uint public next_dex = 0;
25 
26     mapping(bytes32 => address) public _addresses;
27     mapping(uint => address) public _dex;
28 
29 
30     constructor() Ownable() {
31         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
32     }
33 
34     // Set up all addresses for the registry.
35     function initialize_with_legacy(
36         address lock_manager_,
37         address liquidity_,
38         address revest_token_,
39         address token_vault_,
40         address legacy_vault_,
41         address revest_,
42         address fnft_,
43         address metadata_,
44         address admin_,
45         address rewards_
46     ) external override onlyOwner {
47         _addresses[ADMIN] = admin_;
48         _addresses[LOCK_MANAGER] = lock_manager_;
49         _addresses[REVEST_TOKEN] = revest_token_;
50         _addresses[TOKEN_VAULT] = token_vault_;
51         _addresses[LEGACY_VAULT] = legacy_vault_;
52         _addresses[REVEST] = revest_;
53         _addresses[FNFT] = fnft_;
54         _addresses[METADATA] = metadata_;
55         _addresses[LIQUIDITY_TOKENS] = liquidity_;
56         _addresses[ESCROW]=rewards_;
57     }
58 
59     function initialize(
60         address lock_manager_,
61         address liquidity_,
62         address revest_token_,
63         address token_vault_,
64         address revest_,
65         address fnft_,
66         address metadata_,
67         address admin_,
68         address rewards_
69     ) external override onlyOwner {
70         _addresses[ADMIN] = admin_;
71         _addresses[LOCK_MANAGER] = lock_manager_;
72         _addresses[REVEST_TOKEN] = revest_token_;
73         _addresses[TOKEN_VAULT] = token_vault_;
74         _addresses[REVEST] = revest_;
75         _addresses[FNFT] = fnft_;
76         _addresses[METADATA] = metadata_;
77         _addresses[LIQUIDITY_TOKENS] = liquidity_;
78         _addresses[ESCROW]=rewards_;
79     }
80 
81     ///
82     /// EMERGENCY FUNCTIONS
83     ///
84 
85     /// This function breaks the Revest Protocol, temporarily
86     /// For use in emergency situations to offline deposits and withdrawals
87     /// While making all value stored within totally inaccessible 
88     /// Only requires one person to 'throw the switch' to disable entire protocol
89     function breakGlass() external override {
90         require(hasRole(BREAKER, _msgSender()), 'E042');
91         _addresses[REVEST] = address(0x000000000000000000000000000000000000dEaD);
92     }
93 
94     /// This method will allow the token to paused once this contract is granted the pauser role
95     /// Only requires one person to 'throw the switch'
96     function pauseToken() external override {
97         require(hasRole(PAUSER, _msgSender()), 'E043');
98         //TODO: Implement in interface form
99         RevestToken(_addresses[REVEST_TOKEN]).pause();
100     }
101 
102     /// Unpauses the token when the danger has passed
103     /// Requires multisig governance system to agree to unpause
104     function unpauseToken() external override onlyOwner {
105         //TODO: Implement in interface form
106         RevestToken(_addresses[REVEST_TOKEN]).unpause();
107     }
108     
109     /// Admin function for adding or removing breakers
110     function modifyBreaker(address breaker, bool grant) external override onlyOwner {
111         if(grant) {
112             // Add to list
113             grantRole(BREAKER, breaker);
114         } else {
115             // Remove from list
116             revokeRole(BREAKER, breaker);
117         }
118     }
119 
120     /// Admin function for adding or removing pausers
121     function modifyPauser(address pauser, bool grant) external override onlyOwner {
122         if(grant) {
123             // Add to list
124             grantRole(PAUSER, pauser);
125         } else {
126             // Remove from list
127             revokeRole(PAUSER, pauser);
128         }
129     }
130 
131 
132     ///
133     /// SETTERS
134     ///
135 
136     function setAdmin(address admin) external override onlyOwner {
137         _addresses[ADMIN] = admin;
138     }
139 
140     function setLockManager(address manager) external override onlyOwner {
141         _addresses[LOCK_MANAGER] = manager;
142     }
143 
144     function setTokenVault(address vault) external override onlyOwner {
145         _addresses[TOKEN_VAULT] = vault;
146     }
147    
148     function setRevest(address revest) external override onlyOwner {
149         _addresses[REVEST] = revest;
150     }
151 
152     function setRevestFNFT(address fnft) external override onlyOwner {
153         _addresses[FNFT] = fnft;
154     }
155 
156     function setMetadataHandler(address metadata) external override onlyOwner {
157         _addresses[METADATA] = metadata;
158     }
159 
160     function setDex(address dex) external override onlyOwner {
161         _dex[next_dex] = dex;
162         next_dex = next_dex + 1;
163     }
164 
165     function setRevestToken(address token) external override onlyOwner {
166         _addresses[REVEST_TOKEN] = token;
167     }
168 
169     function setRewardsHandler(address esc) external override onlyOwner {
170         _addresses[ESCROW] = esc;
171     }
172 
173     function setLPs(address liquidToken) external override onlyOwner {
174         _addresses[LIQUIDITY_TOKENS] = liquidToken;
175     }
176 
177     function setLegacyTokenVault(address legacyVault) external override onlyOwner {
178         _addresses[LEGACY_VAULT] = legacyVault;
179     }
180 
181     ///
182     /// GETTERS
183     ///
184 
185     function getAdmin() external view override returns (address) {
186         return _addresses[ADMIN];
187     }
188 
189     function getLockManager() external view override returns (address) {
190         return getAddress(LOCK_MANAGER);
191     }
192 
193     function getTokenVault() external view override returns (address) {
194         return getAddress(TOKEN_VAULT);
195     }
196 
197     function getLegacyTokenVault() external view override returns (address legacy) {
198         legacy = getAddress(LEGACY_VAULT);
199     }
200 
201     function getRevest() external view override returns (address) {
202         return getAddress(REVEST);
203     }
204 
205     function getRevestFNFT() external view override returns (address) {
206         return _addresses[FNFT];
207     }
208 
209     function getMetadataHandler() external view override returns (address) {
210         return _addresses[METADATA];
211     }
212 
213     function getRevestToken() external view override returns (address) {
214         return _addresses[REVEST_TOKEN];
215     }
216 
217     function getDEX(uint index) external view override returns (address) {
218         return _dex[index];
219     }
220 
221     function getRewardsHandler() external view override returns(address) {
222         return _addresses[ESCROW];
223     }
224 
225     function getLPs() external view override returns (address) {
226         return _addresses[LIQUIDITY_TOKENS];
227     }
228 
229     /**
230      * @dev Returns an address by id
231      * @return The address
232      */
233     function getAddress(bytes32 id) public view override returns (address) {
234         return _addresses[id];
235     }
236 
237 
238 
239 }
