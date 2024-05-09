1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: mirage_minter_2.sol
107 
108 /*
109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
110 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWWWWWWWW+++++++++++++++++++++++++++++
112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWWWWWWWW+++++++++++++++++++++++++++++
113 +++++++++++++++++++##++++++++++++++++##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWW  WWWWWWWW+++++++++++++++++++++++++++
114 +++++++++++++++++++##++++++++++++++++##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWW  WWWWWWWW+++++++++++++++++++++++++++
115 +++++++++++++++++++###++++++++++++++###+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWWWWWW  WWWWWWWW+++++++++++++++++++++++++
116 +++++++++++++++++++###++++++++++++++###+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWWWWWW  WWWWWWWW+++++++++++++++++++++++++
117 +++++++++++++++++++####++++++++++++####+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWWWWWWWWWWWWWWWW+++++++++++++++++++++++++
118 ++++++++++++++++++#####++++++++++++####+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WWWWWWWWWWWWWWWWWWWW+++++++++++++++++++++++++
119 ++++++++++++++++++######++++++++++#####*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++....................+++++++++++++++++++++++++
120 ++++++++++++++++++######++++++++++######++++++++++++++++++++++++++++++++++++++++++++++++++++++++++....................+++++++++++++++++++++++++
121 ++++++++++++++++++#######++++++++#######++++++++++++++++++++++++++++++++++++++++++++++++++++++++......::::......::::....+++++++++++++++++++++++
122 ++++++++++++++++++##+####++++++++##+####++++++++++++++++++++++++++++++++++++++++++++++++++++++++......::::......::::....+++++++++++++++++++++++
123 ++++++++++++++++++##+#####++++++###+####++++++++++++++++++++++++++++++++++++++++++++++++++++++++....::****::..::****....+++++++++++++++++++++++
124 +++++++++++++++++*##++####++++++##++####+########*++++++++++++++++++++++++++++++++++++++++++++++....::****::..::****....+++++++++++++++++++++++
125 +++++++++++++++++###++#####++++###+++###+############++++++++++++++++WW++WW+++++++++++++++++++....::::WW::::::::WW::......+++++++++++++++++++++
126 +++++++++++++++++###+++####++++##++++####++++++++####++++++++++++++++WW+#W++++++++++++++++++++....::::WW::::::::WW::......+++++++++++++++++++++
127 +++++++++++++++++##++++#####++###++#+####++++++++++##+++++++++++++++++WWWW++++++++++++++++++++......::::::::::::::::......+++++++++++++++++++++
128 +++++++++++++++++##+++++####++##++##+####+++++++++++#+++++++++++++++++*WW+++++++++++++++++++++......::::::::::::::::......+++++++++++++++++++++
129 +++++++++++++++++##+++++########+###+####+++++++++++#+++++++++++++++++WWW+++++++++++++++++++++......::::::::::::::::......+++++++++++++++++++++
130 +++++++++++++++++##++++++######++###+####+++++++++++#+++++++++++++++++W*WW++++++++++++++++++++......::::::::::::::::......+++++++++++++++++++++
131 ++++++++++++++++###++++++######+####+####++++++++++++++++++++++++++++WW++W#+++++++++++++++++++......::::::::WW::::::......+++++++++++++++++++++
132 ++++++++++++++++###+++++++####++####+####+++++++++++++++++++++++++++#W+++WW+++++++++++++++++++......::::::::WW::::::......+++++++++++++++++++++
133 ++++++++++++++++###+++++++*###++####++####++++++++++++++++++++++++++++++++++++++++++++++++++++......::::::::::::::::......+++++++++++++++++++++
134 ++++++++++++++++###++++++++##+++####++####++++++++++++++++++++++++++++++++++++++++++++++++++++......::::::::::::::::......+++++++++++++++++++++
135 ++++++++++++++#######++++++++++#####+*#######+++++++++++++++++++++++++++++++++++++++++++++++++++....::::::WWWWWW::::....+++++++++++++++++++++++
136 +++++++++++++++++++++++++++++++*####++++++++++++#######+++++++++++++++++++++++++++++++++++++++++....::::::WWWWWW::::....+++++++++++++++++++++++
137 ++++++++++++++++++++++++++++++++####+++++++++++++#####++++++++++++++++++++++++++++++++++++++++++......::::::::::::......+++++++++++++++++++++++
138 ++++++++++++++++++++++++++++++++#####++++++++++++####*++++++++++++++++++++++++++++++++++++++++++......::::::::::::......+++++++++++++++++++++++
139 ++++++++++++++++++++++++++++++++#####++++++++++++####*++++++++++++++++++++++++++++++++++++++++++++....::WW::::::WW....+++++++++++++++++++++++++
140 ++++++++++++++++++++++++++++++++#####++++++++++++####+++++++++++++++++++++++++++++++++++++++++++++....::WW::::::WW....+++++++++++++++++++++++++
141 +++++++++++++++++++++++++++++++++#####+++++++++++####+++++++++++++++++++++++++++++++++++++++++++++++WW::::WWWWWW+++++++++++++++++++++++++++++++
142 ++++++++++++++++++++++++++++++++++#####++++++++++####+++++++++++++++++++++++++++++++++++++++++++++++WW::::WWWWWW+++++++++++++++++++++++++++++++
143 ++++++++++++++++++++++++++++++++++######+++++++++####+++++++++++++++++++++++++++++++++++++++++++++++WW::::::WW+++++++++++++++++++++++++++++++++
144 ++++++++++++++++++++++++++++++++++++######+++++++####+++++++++++++++++++++++++++++++++++++++++++++++WW::::::WW+++++++++++++++++++++++++++++++++
145 +++++++++++++++++++++++++++++++++++++########+++#####+++++++++++++++++++++++++++++++++++++++++++++++WW::::::WW+++++++++++++++++++++++++++++++++
146 ++++++++++++++++++++++++++++++++++++++++############++++++++++++++++++++++++++++++++++++++++++++++++WW::::::WW+++++++++++++++++++++++++++++++++
147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
148 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                                                                                                                         
149 */
150 
151 // Contract authored by August Rosedale (@augustfr)
152 // Originally writen for Mirage Gallery Curated drop with Claire Silver (@clairesilver12)
153 // https://miragegallery.ai
154 
155 pragma solidity ^0.8.15;
156 
157 
158 interface curatedContract {
159   function projectIdToArtistAddress(uint256 _projectId) external view returns (address payable);
160   function projectIdToPricePerTokenInWei(uint256 _projectId) external view returns (uint256);
161   function projectIdToAdditionalPayee(uint256 _projectId) external view returns (address payable);
162   function projectIdToAdditionalPayeePercentage(uint256 _projectId) external view returns (uint256);
163   function mirageAddress() external view returns (address payable);
164   function miragePercentage() external view returns (uint256);
165   function mint(address _to, uint256 _projectId, address _by) external returns (uint256 tokenId);
166   function earlyMint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId);
167   function balanceOf(address owner) external view returns (uint256);
168 }
169 
170 interface membershipContracts {
171   function balanceOf(address owner, uint256 _id) external view returns (uint256);
172 }
173 
174 contract mirageExclusiveMinter is Ownable {
175 
176   curatedContract public mirageContract;
177   membershipContracts public membershipContract;
178 
179   mapping(uint256 => bool) public includedProjectId;
180   mapping(uint256 => bool) public mintedID;
181   mapping(address => bool) public mintedWalletStandard;
182   mapping(address => bool) public mintedWalletSecondary;
183   mapping(address => intelAllotment) intelQuantity;
184 
185   address private immutable adminSigner;
186 
187   struct intelAllotment {
188     uint256 allotment;
189   }
190 
191   struct Coupon {
192     bytes32 r;
193     bytes32 s;
194     uint8 v;
195   }
196 
197   constructor(address _curatedAddress, address _membershipAddress, address _adminSigner) {
198     mirageContract = curatedContract(_curatedAddress);
199     membershipContract = membershipContracts(_membershipAddress);
200     adminSigner = _adminSigner;
201   }
202 
203   function purchase(uint256 _projectId) public payable {
204     require(includedProjectId[_projectId], "This project cannot be minted through this contract");
205     require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId), "Must send minimum value to mint!");
206     require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
207     _splitFundsETH(_projectId, 1);
208     mirageContract.mint(msg.sender, _projectId, msg.sender);
209   }
210 
211   function toggleIncludedIds(uint256 _id) public onlyOwner {
212     includedProjectId[_id] = !includedProjectId[_id];
213   }
214 
215   function setIntelAllotment(address[] memory _addresses, uint256[] memory allotments) public onlyOwner {
216     for(uint i = 0; i < _addresses.length; i++) {
217       intelQuantity[_addresses[i]].allotment = allotments[i];
218     }
219   }
220 
221   function _isVerifiedCoupon(bytes32 digest, Coupon memory coupon) internal view returns (bool) {
222     address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s);
223     require(signer != address(0), "ECDSA: invalid signature");
224     return signer == adminSigner;
225   }
226 
227   function viewAllotment(address _address) public view returns (uint256) {
228     if (intelQuantity[_address].allotment == 99) {
229       return 0;
230     } else {
231       return intelQuantity[_address].allotment;
232     }
233   }
234 
235   function sentientPurchase(uint256 _membershipId, uint256 _projectId) public payable {
236     require(_membershipId < 50, "Enter a valid Sentient membership ID (0-49)");
237     require(includedProjectId[_projectId], "This project cannot be minted through this contract");
238     require(membershipContract.balanceOf(msg.sender,_membershipId) > 0, "No membership tokens in this wallet");
239     require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId), "Must send minimum value to mint!");
240     require(!mintedID[_membershipId], "Already minted");
241     mintedID[_membershipId] = true;
242     _splitFundsETH(_projectId, 1);
243     mirageContract.earlyMint(msg.sender, _projectId, msg.sender);
244   }
245 
246   function intelligentPurchase(uint256 _projectId, Coupon memory coupon) public payable {
247     require(includedProjectId[_projectId], "This project cannot be minted through this contract");
248     require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId), "Must send minimum value to mint!");
249     require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
250     uint256 allot = intelQuantity[msg.sender].allotment;
251   
252     bytes32 digest = keccak256(abi.encode(msg.sender,"member"));
253       require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
254   
255     if (allot > 0) {
256       require(allot != 99, "Already minted total allotment");
257       uint256 updatedAllot = allot - 1;
258       intelQuantity[msg.sender].allotment = updatedAllot;
259       if (updatedAllot == 0) {
260         intelQuantity[msg.sender].allotment = 99;
261       }
262     } else if (allot == 0) {
263       intelQuantity[msg.sender].allotment = 99;
264     }
265     _splitFundsETH(_projectId, 1);
266     mirageContract.earlyMint(msg.sender, _projectId, msg.sender);
267   }
268 
269   function standardPresalePurchase(Coupon memory coupon, uint256 _projectId) public payable {
270     require(msg.value >= (mirageContract.projectIdToPricePerTokenInWei(_projectId)), "Must send minimum value to mint!");
271     require(includedProjectId[_projectId], "This project cannot be minted through this contract");
272     require(!mintedWalletStandard[msg.sender], "Already minted");
273     require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
274     bytes32 digest = keccak256(abi.encode(msg.sender,"standard"));
275       require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
276     _splitFundsETH(_projectId, 1);
277     mintedWalletStandard[msg.sender] = true;
278     mirageContract.earlyMint(msg.sender, _projectId, msg.sender);
279   }
280 
281   function secondaryPresalePurchase(Coupon memory coupon, uint256 _projectId) public payable {
282     require(msg.value >= (mirageContract.projectIdToPricePerTokenInWei(_projectId)), "Must send minimum value to mint!");
283     require(includedProjectId[_projectId], "This project cannot be minted through this contract");
284     require(!mintedWalletSecondary[msg.sender], "Already minted");
285     require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
286     bytes32 digest = keccak256(abi.encode(msg.sender,"secondary"));
287       require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
288     _splitFundsETH(_projectId, 1);
289     mintedWalletSecondary[msg.sender] = true;
290     mirageContract.earlyMint(msg.sender, _projectId, msg.sender);
291   }
292 
293   function _splitFundsETH(uint256 _projectId, uint256 numberOfTokens) internal {
294     if (msg.value > 0) {
295       uint256 mintCost = mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens;
296       uint256 refund = msg.value - (mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens);
297       if (refund > 0) {
298         payable(msg.sender).transfer(refund);
299       }
300       uint256 mirageAmount = mintCost / 100 * mirageContract.miragePercentage();
301       if (mirageAmount > 0) {
302         payable(mirageContract.mirageAddress()).transfer(mirageAmount);
303       }
304       uint256 projectFunds = mintCost - mirageAmount;
305       uint256 additionalPayeeAmount;
306       if (mirageContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
307         additionalPayeeAmount = projectFunds / 100 * mirageContract.projectIdToAdditionalPayeePercentage(_projectId);
308         if (additionalPayeeAmount > 0) {
309           payable(mirageContract.projectIdToAdditionalPayee(_projectId)).transfer(additionalPayeeAmount);
310         }
311       }
312       uint256 creatorFunds = projectFunds - additionalPayeeAmount;
313       if (creatorFunds > 0) {
314         payable(mirageContract.projectIdToArtistAddress(_projectId)).transfer(creatorFunds);
315       }
316     }
317   }
318 }