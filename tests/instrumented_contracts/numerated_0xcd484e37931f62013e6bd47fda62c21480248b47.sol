1 // File: IDelegationRegistry.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 /**
7  * @title An immutable registry contract to be deployed as a standalone primitive
8  * @dev See EIP-5639, new project launches can read previous cold wallet -> hot wallet delegations
9  *      from here and integrate those permissions into their flow
10  */
11 interface IDelegationRegistry {
12     /// @notice Delegation type
13     enum DelegationType {
14         NONE,
15         ALL,
16         CONTRACT,
17         TOKEN
18     }
19 
20     /// @notice Info about a single delegation, used for onchain enumeration
21     struct DelegationInfo {
22         DelegationType type_;
23         address vault;
24         address delegate;
25         address contract_;
26         uint256 tokenId;
27     }
28 
29     /// @notice Info about a single contract-level delegation
30     struct ContractDelegation {
31         address contract_;
32         address delegate;
33     }
34 
35     /// @notice Info about a single token-level delegation
36     struct TokenDelegation {
37         address contract_;
38         uint256 tokenId;
39         address delegate;
40     }
41 
42     /// @notice Emitted when a user delegates their entire wallet
43     event DelegateForAll(address vault, address delegate, bool value);
44 
45     /// @notice Emitted when a user delegates a specific contract
46     event DelegateForContract(address vault, address delegate, address contract_, bool value);
47 
48     /// @notice Emitted when a user delegates a specific token
49     event DelegateForToken(address vault, address delegate, address contract_, uint256 tokenId, bool value);
50 
51     /// @notice Emitted when a user revokes all delegations
52     event RevokeAllDelegates(address vault);
53 
54     /// @notice Emitted when a user revoes all delegations for a given delegate
55     event RevokeDelegate(address vault, address delegate);
56 
57     /**
58      * -----------  WRITE -----------
59      */
60 
61     /**
62      * @notice Allow the delegate to act on your behalf for all contracts
63      * @param delegate The hotwallet to act on your behalf
64      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
65      */
66     function delegateForAll(address delegate, bool value) external;
67 
68     /**
69      * @notice Allow the delegate to act on your behalf for a specific contract
70      * @param delegate The hotwallet to act on your behalf
71      * @param contract_ The address for the contract you're delegating
72      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
73      */
74     function delegateForContract(address delegate, address contract_, bool value) external;
75 
76     /**
77      * @notice Allow the delegate to act on your behalf for a specific token
78      * @param delegate The hotwallet to act on your behalf
79      * @param contract_ The address for the contract you're delegating
80      * @param tokenId The token id for the token you're delegating
81      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
82      */
83     function delegateForToken(address delegate, address contract_, uint256 tokenId, bool value) external;
84 
85     /**
86      * @notice Revoke all delegates
87      */
88     function revokeAllDelegates() external;
89 
90     /**
91      * @notice Revoke a specific delegate for all their permissions
92      * @param delegate The hotwallet to revoke
93      */
94     function revokeDelegate(address delegate) external;
95 
96     /**
97      * @notice Remove yourself as a delegate for a specific vault
98      * @param vault The vault which delegated to the msg.sender, and should be removed
99      */
100     function revokeSelf(address vault) external;
101 
102     /**
103      * -----------  READ -----------
104      */
105 
106     /**
107      * @notice Returns all active delegations a given delegate is able to claim on behalf of
108      * @param delegate The delegate that you would like to retrieve delegations for
109      * @return info Array of DelegationInfo structs
110      */
111     function getDelegationsByDelegate(address delegate) external view returns (DelegationInfo[] memory);
112 
113     /**
114      * @notice Returns an array of wallet-level delegates for a given vault
115      * @param vault The cold wallet who issued the delegation
116      * @return addresses Array of wallet-level delegates for a given vault
117      */
118     function getDelegatesForAll(address vault) external view returns (address[] memory);
119 
120     /**
121      * @notice Returns an array of contract-level delegates for a given vault and contract
122      * @param vault The cold wallet who issued the delegation
123      * @param contract_ The address for the contract you're delegating
124      * @return addresses Array of contract-level delegates for a given vault and contract
125      */
126     function getDelegatesForContract(address vault, address contract_) external view returns (address[] memory);
127 
128     /**
129      * @notice Returns an array of contract-level delegates for a given vault's token
130      * @param vault The cold wallet who issued the delegation
131      * @param contract_ The address for the contract holding the token
132      * @param tokenId The token id for the token you're delegating
133      * @return addresses Array of contract-level delegates for a given vault's token
134      */
135     function getDelegatesForToken(address vault, address contract_, uint256 tokenId)
136         external
137         view
138         returns (address[] memory);
139 
140     /**
141      * @notice Returns all contract-level delegations for a given vault
142      * @param vault The cold wallet who issued the delegations
143      * @return delegations Array of ContractDelegation structs
144      */
145     function getContractLevelDelegations(address vault)
146         external
147         view
148         returns (ContractDelegation[] memory delegations);
149 
150     /**
151      * @notice Returns all token-level delegations for a given vault
152      * @param vault The cold wallet who issued the delegations
153      * @return delegations Array of TokenDelegation structs
154      */
155     function getTokenLevelDelegations(address vault) external view returns (TokenDelegation[] memory delegations);
156 
157     /**
158      * @notice Returns true if the address is delegated to act on the entire vault
159      * @param delegate The hotwallet to act on your behalf
160      * @param vault The cold wallet who issued the delegation
161      */
162     function checkDelegateForAll(address delegate, address vault) external view returns (bool);
163 
164     /**
165      * @notice Returns true if the address is delegated to act on your behalf for a token contract or an entire vault
166      * @param delegate The hotwallet to act on your behalf
167      * @param contract_ The address for the contract you're delegating
168      * @param vault The cold wallet who issued the delegation
169      */
170     function checkDelegateForContract(address delegate, address vault, address contract_)
171         external
172         view
173         returns (bool);
174 
175     /**
176      * @notice Returns true if the address is delegated to act on your behalf for a specific token, the token's contract or an entire vault
177      * @param delegate The hotwallet to act on your behalf
178      * @param contract_ The address for the contract you're delegating
179      * @param tokenId The token id for the token you're delegating
180      * @param vault The cold wallet who issued the delegation
181      */
182     function checkDelegateForToken(address delegate, address vault, address contract_, uint256 tokenId)
183         external
184         view
185         returns (bool);
186 }
187 
188 // File: @openzeppelin/contracts/utils/Context.sol
189 
190 
191 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Provides information about the current execution context, including the
197  * sender of the transaction and its data. While these are generally available
198  * via msg.sender and msg.data, they should not be accessed in such a direct
199  * manner, since when dealing with meta-transactions the account sending and
200  * paying for execution may not be the actual sender (as far as an application
201  * is concerned).
202  *
203  * This contract is only required for intermediate, library-like contracts.
204  */
205 abstract contract Context {
206     function _msgSender() internal view virtual returns (address) {
207         return msg.sender;
208     }
209 
210     function _msgData() internal view virtual returns (bytes calldata) {
211         return msg.data;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/access/Ownable.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 
223 /**
224  * @dev Contract module which provides a basic access control mechanism, where
225  * there is an account (an owner) that can be granted exclusive access to
226  * specific functions.
227  *
228  * By default, the owner account will be the one that deploys the contract. This
229  * can later be changed with {transferOwnership}.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 abstract contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor() {
244         _transferOwnership(_msgSender());
245     }
246 
247     /**
248      * @dev Throws if called by any account other than the owner.
249      */
250     modifier onlyOwner() {
251         _checkOwner();
252         _;
253     }
254 
255     /**
256      * @dev Returns the address of the current owner.
257      */
258     function owner() public view virtual returns (address) {
259         return _owner;
260     }
261 
262     /**
263      * @dev Throws if the sender is not the owner.
264      */
265     function _checkOwner() internal view virtual {
266         require(owner() == _msgSender(), "Ownable: caller is not the owner");
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public virtual onlyOwner {
277         _transferOwnership(address(0));
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Internal function without access restriction.
292      */
293     function _transferOwnership(address newOwner) internal virtual {
294         address oldOwner = _owner;
295         _owner = newOwner;
296         emit OwnershipTransferred(oldOwner, newOwner);
297     }
298 }
299 
300 // File: curatedMinterV3.sol
301 
302 /*
303 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
304 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
305 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
306 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
307 MMMMMMMMMMMMMMMMNOOXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXO0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
308 MMMMMMMMMMMMMMMMk,'lKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc.,kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
309 MMMMMMMMMMMMMMMNo...cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc...lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
310 MMMMMMMMMMMMMMMK:....cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc....:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
311 MMMMMMMMMMMMMMMk,.....cKMMMMMMMMMMMMMMMMMMMMMMMMMMWKc.....,kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
312 MMMMMMMMMMMMMMNd.......cKWMMMMMMMMMMMMMMMMMMMMMMMKkc.......oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
313 MMMMMMMMMMMMMMKc........cKMMMMMMMMMMMMMMMMMMMMMMKc'........cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
314 MMMMMMMMMMMMMMO,.........cKMMMMMMMMMMMMMMMMMMMMKc..........,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
315 MMMMMMMMMMMMMWd'..........cKWMMMMMMMMMMMMMMMMMKl............dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
316 MMMMMMMMMMMMMXc...;;.......cKMMMMMMMMMMMMMMMMKc...'co,......cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
317 MMMMMMMMMMMMMO;..,x0:.......cKMMMMMMMMMMMMMMKl...cxKKc......;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
318 MMMMMMMMMMMMWd'..;0W0:.......cKWMMMMMMMMMMMKc...cKWMNo......'xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
319 MMMMMMMMMMMMXl...lXMW0:.......c0WMMMMMMMMMKl...cKMMMWx'......lXXkxxddddoddddxxxkO0KXXNWWWMMMMMMMMMMM
320 MMMMMMMMMMMM0;...dWMMW0:.......c0WMMMMMMMKl...cKMMMMMO;......;0k,.'''',,''.......'',;::cxXMMMMMMMMMM
321 MMMMMMMMMMMWx'..,kMMMMW0:.......c0WMMMMMKl...cKMMMMWWKc......'xXOO00KKKKK00Okdoc,'......cKMMMMMMMMMM
322 MMMMMMMMMMMXl...:0MMMMMW0:.......:0WMMMKl...cKMMWKkdxKd.......oNMMMMMMMMMMMMMMMWXOd:'...lXMMMMMMMMMM
323 MMMMMMMMMMM0:...lXMMMMMMWO:.......:0MMKl...cKMWKo,..;0k,......:KMMMMMMMMMMMMMMMMMMWNOc'.oNMMMMMMMMMM
324 MMMMMMMMMMWx'..'dWMMMMMMMW0:.......:0Kl...cKMNk;....,k0:......,kMMMMMMMMMMMMMMMMMMMMMXl'oNMMMMMMMMMM
325 MMMMMMMMMMNl...,OMMMMMMMMMW0:.......;;...cKWXo'......dKl.......oNMMMMMMMMMMMMMMMMMMMMM0:dWMMMMMMMMMM
326 MMMMMMMMMM0:...:KMMMMMMMMMMW0c..........lKMNo'.......oXd'......cKMMMMMMMMMMMMMMMMMMMMMNKXMMMMMMMMMMM
327 MMMMMMMMMWk,...lXMMMMMMMMMMMWKc........cKMWx,.......,kWk,......,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
328 MMMMMMMMMNo...'dWMMMMMMMMMMMMMKl......lKMMK:........:KMK:.......dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
329 MMMMMMMMWO;...'xWMMMMMMMMMMMMMMXl'...lKMMWx'........lXMXl.......;OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
330 MMMMNKOOd;.....;dkO0NMMMMMMMMMMMXo''lXMMMNo.........lNW0:........,lxkO0XWMMMMMMMMMMMMMMMMMMMMMMMMMMM
331 MMMMN0kkkkkkkkkkxxkOXWMMMMMMMMMMMN0ONMMMMNo.........lXWXOkkkkxxxxxxxxxk0WMXOkkkkkkkkkkkkkkkkkOXMMMMM
332 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo.........:0MMMMMMMMMMMMMMMMMMMMN0OOxl,........,lxO0NMMMMM
333 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx'........'xWMMMMMMMMMMMMMMMMMMMMMMMMNd'......'dNMMMMMMMMM
334 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0:.........:KMMMMMMMMMMMMMMMMMMMMMMMMMk,......'xWMMMMMMMMM
335 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNd'.........oXMMMMMMMMMMMMMMMMMMMMMMMMO,......'kWMMMMMMMMM
336 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo.........'oXMMMMMMMMMMMMMMMMMMMMMMMO,......'kMMMMMMMMMM
337 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo'.........c0WMMMMMMMMMMMMMMMMMMMMMO,......'kMMMMMMMMMM
338 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx;.........,dXWMMMMMMMMMMMMMMMMMMMO,......'kMMMMMMMMMM
339 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKo;'........;d0NMMMMMMMMMMMMMMMMMO,......'kWMMMMMMMMM
340 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKOxc'.......':dOKNWMMMMMMMMMMMWk,......'kWMMMMMMMMM
341 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xl;'.......,:ldxkO00KK00Od:.......;OMMMMMMMMMM
342 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kdl:;''.......''''''....',;cox0NMMMMMMMMMM
343 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OkxxddddddddxxkkO0XNWMMMMMMMMMMMMMM
344 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
345 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
346 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
347 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
348 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
349 */
350 
351 // Contract authored by August Rosedale (@augustfr)
352 // https://miragegallery.ai
353  
354 pragma solidity ^0.8.19;
355 
356 
357 
358 
359 interface curatedContract {
360     function projectIdToArtistAddress(uint256 _projectId) external view returns (address payable);
361     function projectIdToPricePerTokenInWei(uint256 _projectId) external view returns (uint256);
362     function projectIdToAdditionalPayee(uint256 _projectId) external view returns (address payable);
363     function projectIdToAdditionalPayeePercentage(uint256 _projectId) external view returns (uint256);
364     function mirageAddress() external view returns (address payable);
365     function miragePercentage() external view returns (uint256);
366     function mint(address _to, uint256 _projectId, address _by) external returns (uint256 tokenId);
367     function earlyMint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId);
368     function balanceOf(address owner) external view returns (uint256);
369 }
370 
371 interface membershipContracts {
372     function balanceOf(address owner, uint256 _id) external view returns (uint256);
373 }
374 
375 contract curatedMinterV3 is Ownable {
376 
377     curatedContract public mirageContract;
378     address private curatedAddress;
379     membershipContracts public membershipContract;
380     address private membershipAddress;
381     IDelegationRegistry public immutable registry;
382 
383     mapping(uint256 => uint256) public maxPubMint; // per transaction per drop
384     uint256 public maxPreMint = 1; //per intelligent membership
385     uint256 public maxPreMintSentient = 1; //per sentient membership
386     uint256 public maxSecondPhase = 1; //per transaction
387     uint256 public curatedHolderReq = 5;
388 
389     mapping(uint256 => bool) public excluded;
390     mapping(uint256 => mapping(uint256 => uint256)) public tokensMinted;
391 
392     mapping(uint256 => bool) public secondPresalePhase;
393 
394     struct intelAllotment {
395         uint256 allotment;
396     }
397 
398     mapping(uint256 => bool) public usingCoupons;
399 
400     struct Coupon {
401         bytes32 r;
402         bytes32 s;
403         uint8 v;
404     }
405 
406     mapping(address => mapping(uint256 => intelAllotment)) public intelQuantity; // when using coupons, allotments are only needed to be set for members with more than 1 intel membership. When not using coupons, allotments are set for how many mints each address gets
407 
408     address private immutable adminSigner;
409 
410     constructor(address _curatedAddress, address _membershipAddress, address _registry, address _adminSigner) {
411         mirageContract = curatedContract(_curatedAddress);
412         membershipContract = membershipContracts(_membershipAddress);
413         curatedAddress = _curatedAddress;
414         membershipAddress = _membershipAddress;
415         registry = IDelegationRegistry(_registry);
416         adminSigner = _adminSigner;
417         for (uint256 i = 0; i < 100; i++) {
418             maxPubMint[i] = 10;
419         }
420     }
421 
422     function setLimits(uint256 _projectId, uint256 pubLimit, uint256 preLimit, uint256 preSentient) public onlyOwner {
423         maxPubMint[_projectId] = pubLimit;
424         maxPreMint = preLimit;
425         maxPreMintSentient = preSentient;
426     }
427 
428     function enableSecondPresalePhase(uint256 _projectId) public onlyOwner {
429         secondPresalePhase[_projectId] = true;
430     }
431 
432     function updateHolderReq(uint256 newLimit) public onlyOwner {
433         curatedHolderReq = newLimit;
434     }
435 
436     function updateContracts(address _curatedAddress, address _membershipAddress) public onlyOwner {
437         mirageContract = curatedContract(_curatedAddress);
438         membershipContract = membershipContracts(_membershipAddress);
439     }
440 
441     function _isVerifiedCoupon(bytes32 digest, Coupon memory coupon) internal view returns (bool) {
442         address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s);
443         require(signer != address(0), "ECDSA: invalid signature");
444         return signer == adminSigner;
445     }
446 
447     function setIntelAllotment(uint256 _projectID, address[] memory _addresses, uint256[] memory allotments) public onlyOwner {
448         for(uint i = 0; i < _addresses.length; i++) {
449             intelQuantity[_addresses[i]][_projectID].allotment = allotments[i];
450         }
451     }
452 
453     function viewAllotment(address _address, uint256 _projectID) public view returns (uint256) {
454         if (intelQuantity[_address][_projectID].allotment == 99) {
455             return 0;
456         } else {
457             return intelQuantity[_address][_projectID].allotment;
458         }
459     }
460     
461     function purchase(uint256 _projectId, uint256 numberOfTokens) public payable {
462         require(!excluded[_projectId], "Project cannot be minted through this contract");
463         require(numberOfTokens <= maxPubMint[_projectId], "Can't mint this many in a single transaction");
464         require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens, "Must send minimum value to mint!");
465         require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
466 
467         _splitFundsETH(_projectId, numberOfTokens);
468         for(uint i = 0; i < numberOfTokens; i++) {
469             mirageContract.mint(msg.sender, _projectId, msg.sender);
470         }
471     }
472 
473     function earlySentientPurchase(uint256 _projectId, uint256 _membershipId, uint256 numberOfTokens, address _vault) public payable {
474         require(!excluded[_projectId], "Project cannot be minted through this contract");
475         require(_membershipId < 50, "Not a valid sentient ID");
476         require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens, "Must send minimum value to mint!");
477         require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
478 
479         address requester = msg.sender;
480   
481         if (_vault != msg.sender) { 
482             bool isDelegateValid = registry.checkDelegateForContract(requester, _vault, membershipAddress);
483             require(isDelegateValid, "invalid delegate-vault pairing");
484             require(membershipContract.balanceOf(_vault,_membershipId) > 0, "No membership tokens in this wallet");
485             requester = _vault;
486         } else {
487             require(membershipContract.balanceOf(requester,_membershipId) > 0, "No membership tokens in this wallet");
488         }
489 
490         if (secondPresalePhase[_projectId]) {
491             require(numberOfTokens <= maxSecondPhase, "Can't mint this many in one transaction");
492         } else {
493             require(tokensMinted[_projectId][_membershipId] + numberOfTokens <= maxPreMintSentient, "Would exceed mint allotment");
494         }
495 
496         _splitFundsETH(_projectId, numberOfTokens);
497         for(uint i = 0; i < numberOfTokens; i++) {
498             tokensMinted[_projectId][_membershipId]++;
499             mirageContract.earlyMint(requester, _projectId, msg.sender);
500         }
501     }
502 
503     function earlyCuratedHolderPurchase(uint256 _projectId, uint256 numberOfTokens, address _vault) public payable {
504         require(!excluded[_projectId], "Project cannot be minted through this contract");
505         require(secondPresalePhase[_projectId], "Not in second presale phase");
506         require(mirageContract.balanceOf(_vault) >= curatedHolderReq, "Address does not hold enough curated artworks");
507         require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens, "Must send minimum value to mint!");
508         require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
509         require(numberOfTokens <= maxSecondPhase, "Can't mint this many in one transaction");
510         
511         address requester = msg.sender;
512 
513         if (_vault != msg.sender) { 
514             bool isDelegateValid = registry.checkDelegateForContract(requester, _vault, curatedAddress);
515             require(isDelegateValid, "invalid delegate-vault pairing");
516             requester = _vault;
517         }
518 
519         _splitFundsETH(_projectId, numberOfTokens);
520         for(uint i = 0; i < numberOfTokens; i++) {
521             mirageContract.earlyMint(requester, _projectId, msg.sender);
522         }
523     }
524 
525     function enableCoupons(uint256 _projectId) public onlyOwner {
526         usingCoupons[_projectId] = !usingCoupons[_projectId];
527     }
528 
529     function earlyIntelligentPurchase(uint256 _projectId, uint256 numberOfTokens, address _vault) public payable {
530         require(!excluded[_projectId], "Project cannot be minted through this contract");
531         require(!usingCoupons[_projectId], "Not a valid minting function for this drop");
532         require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens, "Must send minimum value to mint!");
533         require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
534 
535         address requester = msg.sender;
536     
537         if (_vault != msg.sender) { 
538             bool isDelegateValid = registry.checkDelegateForContract(requester, _vault, membershipAddress);
539             require(isDelegateValid, "invalid delegate-vault pairing");
540             requester = _vault;
541         }
542 
543         uint256 allot = intelQuantity[requester][_projectId].allotment;
544         require(allot > 0, "No available mints for this address");
545         
546         if (secondPresalePhase[_projectId]) {
547             require(numberOfTokens <= maxSecondPhase, "Can't mint this many in one transaction");
548         } else {
549             require(numberOfTokens <= allot, "Would exceed mint allotment");
550             require(allot != 99, "Already minted total allotment");
551             uint256 updatedAllot = allot - numberOfTokens;
552             intelQuantity[requester][_projectId].allotment = updatedAllot;
553             if (updatedAllot == 0) {
554                 intelQuantity[requester][_projectId].allotment = 99;
555             }
556         }
557         _splitFundsETH(_projectId, numberOfTokens);
558         for(uint i = 0; i < numberOfTokens; i++) {
559             mirageContract.earlyMint(requester, _projectId, msg.sender);
560         }
561     }
562 
563     function earlyIntelligentCouponPurchase(uint256 _projectId, Coupon memory coupon, address _vault, uint256 numberOfTokens) public payable {
564         require(!excluded[_projectId], "Project cannot be minted through this contract");
565         require(usingCoupons[_projectId], "Not a valid minting function for this drop");
566         require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId), "Must send minimum value to mint!");
567         require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
568 
569         address requester = msg.sender;
570 
571         if (_vault != msg.sender) { 
572             bool isDelegateValid = registry.checkDelegateForContract(requester, _vault, membershipAddress);
573             require(isDelegateValid, "invalid delegate-vault pairing");
574             requester = _vault;
575         }
576 
577         bytes32 digest = keccak256(abi.encode(requester,"member"));
578         require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
579     
580         if (secondPresalePhase[_projectId]) {
581             require(numberOfTokens <= maxSecondPhase, "Can't mint this many in one transaction");
582         } else {
583             uint256 allot = intelQuantity[msg.sender][_projectId].allotment;
584             if (allot > 0) {
585                 require(numberOfTokens <= allot, "Would exceed mint allotment");
586                 require(allot != 99, "Already minted total allotment");
587                 uint256 updatedAllot = allot - numberOfTokens;
588                 intelQuantity[msg.sender][_projectId].allotment = updatedAllot;
589                 if (updatedAllot == 0) {
590                     intelQuantity[msg.sender][_projectId].allotment = 99;
591                 }
592             } else if (allot == 0) {
593                 require(numberOfTokens <= 1, "Would exceed mint allotment");
594                 intelQuantity[msg.sender][_projectId].allotment = 99;
595             }
596         }
597         _splitFundsETH(_projectId, numberOfTokens);
598         for(uint i = 0; i < numberOfTokens; i++) {
599             mirageContract.earlyMint(requester, _projectId, msg.sender);
600         }
601     }
602 
603     function toggleProject(uint256 _projectId) public onlyOwner {
604         excluded[_projectId] = !excluded[_projectId];
605     }
606 
607     function _splitFundsETH(uint256 _projectId, uint256 numberOfTokens) internal {
608         if (msg.value > 0) {
609             uint256 mintCost = mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens;
610             uint256 refund = msg.value - (mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens);
611             if (refund > 0) {
612                 payable(msg.sender).transfer(refund);
613             }
614             uint256 mirageAmount = mintCost / 100 * mirageContract.miragePercentage();
615             if (mirageAmount > 0) {
616                 payable(mirageContract.mirageAddress()).transfer(mirageAmount);
617             }
618             uint256 projectFunds = mintCost - mirageAmount;
619             uint256 additionalPayeeAmount;
620             if (mirageContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
621                 additionalPayeeAmount = projectFunds / 100 * mirageContract.projectIdToAdditionalPayeePercentage(_projectId);
622                 if (additionalPayeeAmount > 0) {
623                 payable(mirageContract.projectIdToAdditionalPayee(_projectId)).transfer(additionalPayeeAmount);
624                 }
625             }
626             uint256 creatorFunds = projectFunds - additionalPayeeAmount;
627             if (creatorFunds > 0) {
628                 payable(mirageContract.projectIdToArtistAddress(_projectId)).transfer(creatorFunds);
629             }
630         }
631     }
632 }