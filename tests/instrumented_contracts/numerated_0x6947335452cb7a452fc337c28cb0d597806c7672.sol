1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SmartWeddingContract
6  * @dev The contract has both addresses of the husband and the wife. It is capable of handling assets, funds and
7  * divorce. A multisig variant is used to consider the decision of both parties.
8  */
9 contract SmartWeddingContract {
10 	event WrittenContractProposed(uint timestamp, string ipfsHash, address wallet);
11 	event Signed(uint timestamp, address wallet);
12 	event ContractSigned(uint timestamp);
13 	event AssetProposed(uint timestamp, string asset, address wallet);
14 	event AssetAddApproved(uint timestamp, string asset, address wallet);
15 	event AssetAdded(uint timestamp, string asset);
16 	event AssetRemoveApproved(uint timestamp, string asset, address wallet);
17 	event AssetRemoved(uint timestamp, string asset);
18 	event DivorceApproved(uint timestamp, address wallet);
19 	event Divorced(uint timestamp);
20 	event FundsSent(uint timestamp, address wallet, uint amount);
21 	event FundsReceived(uint timestamp, address wallet, uint amount);
22 
23 	bool public signed = false;
24 	bool public divorced = false;
25 
26 	mapping (address => bool) private hasSigned;
27 	mapping (address => bool) private hasDivorced;
28 
29 	address public husbandAddress;
30 	address public wifeAddress;
31 	string public writtenContractIpfsHash;
32 
33 	struct Asset {
34 		string data;
35 		uint husbandAllocation;
36 		uint wifeAllocation;
37 		bool added;
38 		bool removed;
39 		mapping (address => bool) hasApprovedAdd;
40 		mapping (address => bool) hasApprovedRemove;
41 	}
42 
43 	Asset[] public assets;
44 
45 	/**
46 	 * @dev Modifier that only allows spouse execution.
47  	 */
48 	modifier onlySpouse() {
49 		require(msg.sender == husbandAddress || msg.sender == wifeAddress, "Sender is not a spouse!");
50 		_;
51 	}
52 
53 	/**
54 	 * @dev Modifier that checks if the contract has been signed by both spouses.
55  	 */
56 	modifier isSigned() {
57 		require(signed == true, "Contract has not been signed by both spouses yet!");
58 		_;
59 	}
60 
61 	/**
62 	 * @dev Modifier that only allows execution if the spouses have not been divorced.
63  	 */
64 	modifier isNotDivorced() {
65 		require(divorced == false, "Can not be called after spouses agreed to divorce!");
66 		_;
67 	}
68 
69 	/**
70 	 * @dev Private helper function to check if a string is the same as another.
71 	 */
72 	function isSameString(string memory string1, string memory string2) private pure returns (bool) {
73 		return keccak256(abi.encodePacked(string1)) != keccak256(abi.encodePacked(string2));
74 	}
75 
76 	/**
77 	 * @dev Constructor: Set the wallet addresses of both spouses.
78 	 * @param _husbandAddress Wallet address of the husband.
79 	 * @param _wifeAddress Wallet address of the wife.
80 	 */
81 	constructor(address _husbandAddress, address _wifeAddress) public {
82 		require(_husbandAddress != address(0), "Husband address must not be zero!");
83 		require(_wifeAddress != address(0), "Wife address must not be zero!");
84 		require(_husbandAddress != _wifeAddress, "Husband address must not equal wife address!");
85 
86 		husbandAddress = _husbandAddress;
87 		wifeAddress = _wifeAddress;
88 	}
89 
90 	/**
91 	 * @dev Default function to enable the contract to receive funds.
92  	 */
93 	function() external payable isSigned isNotDivorced {
94 		emit FundsReceived(now, msg.sender, msg.value);
95 	}
96 
97 	/**
98 	 * @dev Propose a written contract (update).
99 	 * @param _writtenContractIpfsHash IPFS hash of the written contract PDF.
100 	 */
101 	function proposeWrittenContract(string _writtenContractIpfsHash) external onlySpouse {
102 		require(signed == false, "Written contract ipfs hash can not be changed. Both spouses have already signed it!");
103 
104 		// Update written contract ipfs hash
105 		writtenContractIpfsHash = _writtenContractIpfsHash;
106 
107 		emit WrittenContractProposed(now, _writtenContractIpfsHash, msg.sender);
108 
109 		// Revoke previous signatures
110 		if (hasSigned[husbandAddress] == true) {
111 			hasSigned[husbandAddress] = false;
112 		}
113 		if (hasSigned[wifeAddress] == true) {
114 			hasSigned[wifeAddress] = false;
115 		}
116 	}
117 
118 	/**
119 	 * @dev Sign the contract.
120 	 */
121 	function signContract() external onlySpouse {
122 		require(isSameString(writtenContractIpfsHash, ""), "Written contract ipfs hash has been proposed yet!");
123 		require(hasSigned[msg.sender] == false, "Spouse has already signed the contract!");
124 
125 		// Sender signed
126 		hasSigned[msg.sender] = true;
127 
128 		emit Signed(now, msg.sender);
129 
130 		// Check if both spouses have signed
131 		if (hasSigned[husbandAddress] && hasSigned[wifeAddress]) {
132 			signed = true;
133 			emit ContractSigned(now);
134 		}
135 	}
136 
137 	/**
138 	 * @dev Send ETH to a target address.
139 	 * @param _to Destination wallet address.
140 	 * @param _amount Amount of ETH to send.
141 	 */
142 	function pay(address _to, uint _amount) external onlySpouse isSigned isNotDivorced {
143 		require(_to != address(0), "Sending funds to address zero is prohibited!");
144 		require(_amount <= address(this).balance, "Not enough balance available!");
145 
146 		// Send funds to the destination address
147 		_to.transfer(_amount);
148 
149 		emit FundsSent(now, _to, _amount);
150 	}
151 
152 	/**
153 	 * @dev Propose an asset to add. The other spouse needs to approve this action.
154 	 * @param _data The asset represented as a string.
155 	 * @param _husbandAllocation Allocation of the husband.
156 	 * @param _wifeAllocation Allocation of the wife.
157 	 */
158 	function proposeAsset(string _data, uint _husbandAllocation, uint _wifeAllocation) external onlySpouse isSigned isNotDivorced {
159 		require(isSameString(_data, ""), "No asset data provided!");
160 		require(_husbandAllocation >= 0, "Husband allocation invalid!");
161 		require(_wifeAllocation >= 0, "Wife allocation invalid!");
162 		require((_husbandAllocation + _wifeAllocation) == 100, "Total allocation must be equal to 100%!");
163 
164 		// Add new asset
165 		Asset memory newAsset = Asset({
166 			data: _data,
167 			husbandAllocation: _husbandAllocation,
168 			wifeAllocation: _wifeAllocation,
169 			added: false,
170 			removed: false
171 		});
172 		uint newAssetId = assets.push(newAsset);
173 
174 		emit AssetProposed(now, _data, msg.sender);
175 
176 		// Map to a storage object (otherwise mappings could not be accessed)
177 		Asset storage asset = assets[newAssetId - 1];
178 
179 		// Instantly approve it by the sender
180 		asset.hasApprovedAdd[msg.sender] = true;
181 
182 		emit AssetAddApproved(now, _data, msg.sender);
183 	}
184 
185 	/**
186 	 * @dev Approve the addition of a prior proposed asset. The other spouse needs to approve this action.
187 	 * @param _assetId The id of the asset that should be approved.
188 	 */
189 	function approveAsset(uint _assetId) external onlySpouse isSigned isNotDivorced {
190 		require(_assetId > 0 && _assetId <= assets.length, "Invalid asset id!");
191 
192 		Asset storage asset = assets[_assetId - 1];
193 
194 		require(asset.added == false, "Asset has already been added!");
195 		require(asset.removed == false, "Asset has already been removed!");
196 		require(asset.hasApprovedAdd[msg.sender] == false, "Asset has already approved by sender!");
197 
198 		// Sender approved
199 		asset.hasApprovedAdd[msg.sender] = true;
200 
201 		emit AssetAddApproved(now, asset.data, msg.sender);
202 
203 		// Check if both spouses have approved
204 		if (asset.hasApprovedAdd[husbandAddress] && asset.hasApprovedAdd[wifeAddress]) {
205 			asset.added = true;
206 			emit AssetAdded(now, asset.data);
207 		}
208 	}
209 
210 	/**
211 	 * @dev Approve the removal of a prior proposed/already added asset. The other spouse needs to approve this action.
212 	 * @param _assetId The id of the asset that should be removed.
213 	 */
214 	function removeAsset(uint _assetId) external onlySpouse isSigned isNotDivorced {
215 		require(_assetId > 0 && _assetId <= assets.length, "Invalid asset id!");
216 
217 		Asset storage asset = assets[_assetId - 1];
218 
219 		require(asset.added, "Asset has not been added yet!");
220 		require(asset.removed == false, "Asset has already been removed!");
221 		require(asset.hasApprovedRemove[msg.sender] == false, "Removing the asset has already been approved by the sender!");
222 
223 		// Approve removal by the sender
224 		asset.hasApprovedRemove[msg.sender] = true;
225 
226 		emit AssetRemoveApproved(now, asset.data, msg.sender);
227 
228 		// Check if both spouses have approved the removal of the asset
229 		if (asset.hasApprovedRemove[husbandAddress] && asset.hasApprovedRemove[wifeAddress]) {
230 			asset.removed = true;
231 			emit AssetRemoved(now, asset.data);
232 		}
233 	}
234 
235 	/**
236 	 * @dev Request to divorce. The other spouse needs to approve this action.
237 	 */
238 	function divorce() external onlySpouse isSigned isNotDivorced {
239 		require(hasDivorced[msg.sender] == false, "Sender has already approved to divorce!");
240 
241 		// Sender approved
242 		hasDivorced[msg.sender] = true;
243 
244 		emit DivorceApproved(now, msg.sender);
245 
246 		// Check if both spouses have approved to divorce
247 		if (hasDivorced[husbandAddress] && hasDivorced[wifeAddress]) {
248 			divorced = true;
249 			emit Divorced(now);
250 
251 			// Get the contracts balance
252 			uint balance = address(this).balance;
253 
254 			// Split the remaining balance half-half
255 			if (balance != 0) {
256 				uint balancePerSpouse = balance / 2;
257 
258 				// Send transfer to the husband
259 				husbandAddress.transfer(balancePerSpouse);
260 				emit FundsSent(now, husbandAddress, balancePerSpouse);
261 
262 				// Send transfer to the wife
263 				wifeAddress.transfer(balancePerSpouse);
264 				emit FundsSent(now, wifeAddress, balancePerSpouse);
265 			}
266 		}
267 	}
268 
269 	/**
270 	 * @dev Return a list of all asset ids.
271 	 */
272 	function getAssetIds() external view returns (uint[]) {
273 		uint assetCount = assets.length;
274 		uint[] memory assetIds = new uint[](assetCount);
275 
276 		// Get all asset ids
277 		for (uint i = 1; i <= assetCount; i++) { assetIds[i - 1] = i; }
278 
279 		return assetIds;
280 	}
281 }