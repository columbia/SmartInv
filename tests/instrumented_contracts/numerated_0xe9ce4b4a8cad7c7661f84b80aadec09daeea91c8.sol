1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/common/misc/ProxyStorage.sol
78 
79 pragma solidity ^0.5.2;
80 
81 
82 contract ProxyStorage is Ownable {
83     address internal proxyTo;
84 }
85 
86 // File: contracts/common/misc/ERCProxy.sol
87 
88 /*
89  * SPDX-License-Identitifer:    MIT
90  */
91 
92 pragma solidity ^0.5.2;
93 
94 // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-897.md
95 
96 interface ERCProxy {
97     function proxyType() external pure returns (uint256 proxyTypeId);
98     function implementation() external view returns (address codeAddr);
99 }
100 
101 // File: contracts/common/misc/DelegateProxy.sol
102 
103 pragma solidity ^0.5.2;
104 
105 
106 
107 contract DelegateProxy is ERCProxy {
108     function proxyType() external pure returns (uint256 proxyTypeId) {
109         // Upgradeable proxy
110         proxyTypeId = 2;
111     }
112 
113     function implementation() external view returns (address);
114 
115     function delegatedFwd(address _dst, bytes memory _calldata) internal {
116         // solium-disable-next-line security/no-inline-assembly
117         assembly {
118             let result := delegatecall(
119                 sub(gas, 10000),
120                 _dst,
121                 add(_calldata, 0x20),
122                 mload(_calldata),
123                 0,
124                 0
125             )
126             let size := returndatasize
127 
128             let ptr := mload(0x40)
129             returndatacopy(ptr, 0, size)
130 
131             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
132             // if the call returned error data, forward it
133             switch result
134                 case 0 {
135                     revert(ptr, size)
136                 }
137                 default {
138                     return(ptr, size)
139                 }
140         }
141     }
142 }
143 
144 // File: contracts/common/misc/UpgradableProxy.sol
145 
146 pragma solidity ^0.5.2;
147 
148 
149 contract UpgradableProxy is DelegateProxy {
150     event ProxyUpdated(address indexed _new, address indexed _old);
151     event OwnerUpdate(address _new, address _old);
152 
153     bytes32 constant IMPLEMENTATION_SLOT = keccak256("matic.network.proxy.implementation");
154     bytes32 constant OWNER_SLOT = keccak256("matic.network.proxy.owner");
155 
156     constructor(address _proxyTo) public {
157         setOwner(msg.sender);
158         setImplementation(_proxyTo);
159     }
160 
161     function() external payable {
162         // require(currentContract != 0, "If app code has not been set yet, do not call");
163         // Todo: filter out some calls or handle in the end fallback
164         delegatedFwd(loadImplementation(), msg.data);
165     }
166 
167     modifier onlyProxyOwner() {
168         require(loadOwner() == msg.sender, "NOT_OWNER");
169         _;
170     }
171 
172     function owner() external view returns(address) {
173         return loadOwner();
174     }
175 
176     function loadOwner() internal view returns(address) {
177         address _owner;
178         bytes32 position = OWNER_SLOT;
179         assembly {
180             _owner := sload(position)
181         }
182         return _owner;
183     }
184 
185     function implementation() external view returns (address) {
186         return loadImplementation();
187     }
188 
189     function loadImplementation() internal view returns(address) {
190         address _impl;
191         bytes32 position = IMPLEMENTATION_SLOT;
192         assembly {
193             _impl := sload(position)
194         }
195         return _impl;
196     }
197 
198     function transferOwnership(address newOwner) public onlyProxyOwner {
199         require(newOwner != address(0), "ZERO_ADDRESS");
200         emit OwnerUpdate(newOwner, loadOwner());
201         setOwner(newOwner);
202     }
203 
204     function setOwner(address newOwner) private {
205         bytes32 position = OWNER_SLOT;
206         assembly {
207             sstore(position, newOwner)
208         }
209     }
210 
211     function updateImplementation(address _newProxyTo) public onlyProxyOwner {
212         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
213         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
214 
215         emit ProxyUpdated(_newProxyTo, loadImplementation());
216         
217         setImplementation(_newProxyTo);
218     }
219 
220     function updateAndCall(address _newProxyTo, bytes memory data) payable public onlyProxyOwner {
221         updateImplementation(_newProxyTo);
222 
223         (bool success, bytes memory returnData) = address(this).call.value(msg.value)(data);
224         require(success, string(returnData));
225     }
226 
227     function setImplementation(address _newProxyTo) private {
228         bytes32 position = IMPLEMENTATION_SLOT;
229         assembly {
230             sstore(position, _newProxyTo)
231         }
232     }
233     
234     function isContract(address _target) internal view returns (bool) {
235         if (_target == address(0)) {
236             return false;
237         }
238 
239         uint256 size;
240         assembly {
241             size := extcodesize(_target)
242         }
243         return size > 0;
244     }
245 }
246 
247 // File: contracts/common/governance/IGovernance.sol
248 
249 pragma solidity ^0.5.2;
250 
251 interface IGovernance {
252     function update(address target, bytes calldata data) external;
253 }
254 
255 // File: contracts/common/governance/Governable.sol
256 
257 pragma solidity ^0.5.2;
258 
259 
260 contract Governable {
261     IGovernance public governance;
262 
263     constructor(address _governance) public {
264         governance = IGovernance(_governance);
265     }
266 
267     modifier onlyGovernance() {
268         require(
269             msg.sender == address(governance),
270             "Only governance contract is authorized"
271         );
272         _;
273     }
274 }
275 
276 // File: contracts/root/withdrawManager/IWithdrawManager.sol
277 
278 pragma solidity ^0.5.2;
279 
280 contract IWithdrawManager {
281     function createExitQueue(address token) external;
282 
283     function verifyInclusion(
284         bytes calldata data,
285         uint8 offset,
286         bool verifyTxInclusion
287     ) external view returns (uint256 age);
288 
289     function addExitToQueue(
290         address exitor,
291         address childToken,
292         address rootToken,
293         uint256 exitAmountOrTokenId,
294         bytes32 txHash,
295         bool isRegularExit,
296         uint256 priority
297     ) external;
298 
299     function addInput(
300         uint256 exitId,
301         uint256 age,
302         address utxoOwner,
303         address token
304     ) external;
305 
306     function challengeExit(
307         uint256 exitId,
308         uint256 inputId,
309         bytes calldata challengeData,
310         address adjudicatorPredicate
311     ) external;
312 }
313 
314 // File: contracts/common/Registry.sol
315 
316 pragma solidity ^0.5.2;
317 
318 
319 
320 
321 contract Registry is Governable {
322     // @todo hardcode constants
323     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
324     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
325     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
326     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
327     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
328     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
329     bytes32 private constant STATE_SENDER = keccak256("stateSender");
330     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
331 
332     address public erc20Predicate;
333     address public erc721Predicate;
334 
335     mapping(bytes32 => address) public contractMap;
336     mapping(address => address) public rootToChildToken;
337     mapping(address => address) public childToRootToken;
338     mapping(address => bool) public proofValidatorContracts;
339     mapping(address => bool) public isERC721;
340 
341     enum Type {Invalid, ERC20, ERC721, Custom}
342     struct Predicate {
343         Type _type;
344     }
345     mapping(address => Predicate) public predicates;
346 
347     event TokenMapped(address indexed rootToken, address indexed childToken);
348     event ProofValidatorAdded(address indexed validator, address indexed from);
349     event ProofValidatorRemoved(address indexed validator, address indexed from);
350     event PredicateAdded(address indexed predicate, address indexed from);
351     event PredicateRemoved(address indexed predicate, address indexed from);
352     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
353 
354     constructor(address _governance) public Governable(_governance) {}
355 
356     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
357         emit ContractMapUpdated(_key, contractMap[_key], _address);
358         contractMap[_key] = _address;
359     }
360 
361     /**
362      * @dev Map root token to child token
363      * @param _rootToken Token address on the root chain
364      * @param _childToken Token address on the child chain
365      * @param _isERC721 Is the token being mapped ERC721
366      */
367     function mapToken(
368         address _rootToken,
369         address _childToken,
370         bool _isERC721
371     ) external onlyGovernance {
372         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
373         rootToChildToken[_rootToken] = _childToken;
374         childToRootToken[_childToken] = _rootToken;
375         isERC721[_rootToken] = _isERC721;
376         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
377         emit TokenMapped(_rootToken, _childToken);
378     }
379 
380     function addErc20Predicate(address predicate) public onlyGovernance {
381         require(predicate != address(0x0), "Can not add null address as predicate");
382         erc20Predicate = predicate;
383         addPredicate(predicate, Type.ERC20);
384     }
385 
386     function addErc721Predicate(address predicate) public onlyGovernance {
387         erc721Predicate = predicate;
388         addPredicate(predicate, Type.ERC721);
389     }
390 
391     function addPredicate(address predicate, Type _type) public onlyGovernance {
392         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
393         predicates[predicate]._type = _type;
394         emit PredicateAdded(predicate, msg.sender);
395     }
396 
397     function removePredicate(address predicate) public onlyGovernance {
398         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
399         delete predicates[predicate];
400         emit PredicateRemoved(predicate, msg.sender);
401     }
402 
403     function getValidatorShareAddress() public view returns (address) {
404         return contractMap[VALIDATOR_SHARE];
405     }
406 
407     function getWethTokenAddress() public view returns (address) {
408         return contractMap[WETH_TOKEN];
409     }
410 
411     function getDepositManagerAddress() public view returns (address) {
412         return contractMap[DEPOSIT_MANAGER];
413     }
414 
415     function getStakeManagerAddress() public view returns (address) {
416         return contractMap[STAKE_MANAGER];
417     }
418 
419     function getSlashingManagerAddress() public view returns (address) {
420         return contractMap[SLASHING_MANAGER];
421     }
422 
423     function getWithdrawManagerAddress() public view returns (address) {
424         return contractMap[WITHDRAW_MANAGER];
425     }
426 
427     function getChildChainAndStateSender() public view returns (address, address) {
428         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
429     }
430 
431     function isTokenMapped(address _token) public view returns (bool) {
432         return rootToChildToken[_token] != address(0x0);
433     }
434 
435     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
436         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
437         return isERC721[_token];
438     }
439 
440     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
441         if (isTokenMappedAndIsErc721(_token)) {
442             return erc721Predicate;
443         }
444         return erc20Predicate;
445     }
446 
447     function isChildTokenErc721(address childToken) public view returns (bool) {
448         address rootToken = childToRootToken[childToken];
449         require(rootToken != address(0x0), "Child token is not mapped");
450         return isERC721[rootToken];
451     }
452 }
453 
454 // File: contracts/staking/validatorShare/ValidatorShareProxy.sol
455 
456 pragma solidity ^0.5.2;
457 
458 
459 
460 contract ValidatorShareProxy is UpgradableProxy {
461     constructor(address _registry) public UpgradableProxy(_registry) {}
462 
463     function loadImplementation() internal view returns (address) {
464         return Registry(super.loadImplementation()).getValidatorShareAddress();
465     }
466 }