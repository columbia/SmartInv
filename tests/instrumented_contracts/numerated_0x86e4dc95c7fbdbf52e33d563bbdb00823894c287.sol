1 // File: contracts/common/governance/IGovernance.sol
2 
3 pragma solidity ^0.5.2;
4 
5 
6 interface IGovernance {
7     function update(address target, bytes calldata data) external;
8 }
9 
10 // File: contracts/common/governance/Governable.sol
11 
12 pragma solidity ^0.5.2;
13 
14 
15 contract Governable {
16     IGovernance public governance;
17 
18     constructor(address _governance) public {
19         governance = IGovernance(_governance);
20     }
21 
22     modifier onlyGovernance() {
23         require(msg.sender == address(governance), "Only governance contract is authorized");
24         _;
25     }
26 }
27 
28 // File: contracts/root/withdrawManager/IWithdrawManager.sol
29 
30 pragma solidity ^0.5.2;
31 
32 
33 contract IWithdrawManager {
34     function createExitQueue(address token) external;
35 
36     function verifyInclusion(
37         bytes calldata data,
38         uint8 offset,
39         bool verifyTxInclusion
40     ) external view returns (uint256 age);
41 
42     function addExitToQueue(
43         address exitor,
44         address childToken,
45         address rootToken,
46         uint256 exitAmountOrTokenId,
47         bytes32 txHash,
48         bool isRegularExit,
49         uint256 priority
50     ) external;
51 
52     function addInput(
53         uint256 exitId,
54         uint256 age,
55         address utxoOwner,
56         address token
57     ) external;
58 
59     function challengeExit(
60         uint256 exitId,
61         uint256 inputId,
62         bytes calldata challengeData,
63         address adjudicatorPredicate
64     ) external;
65 }
66 
67 // File: contracts/common/Registry.sol
68 
69 pragma solidity ^0.5.2;
70 
71 
72 contract Registry is Governable {
73     // @todo hardcode constants
74     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
75     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
76     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
77     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
78     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
79     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
80     bytes32 private constant STATE_SENDER = keccak256("stateSender");
81     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
82 
83     address public erc20Predicate;
84     address public erc721Predicate;
85 
86     mapping(bytes32 => address) public contractMap;
87     mapping(address => address) public rootToChildToken;
88     mapping(address => address) public childToRootToken;
89     mapping(address => bool) public proofValidatorContracts;
90     mapping(address => bool) public isERC721;
91 
92     enum Type {Invalid, ERC20, ERC721, Custom}
93     struct Predicate {
94         Type _type;
95     }
96     mapping(address => Predicate) public predicates;
97 
98     event TokenMapped(address indexed rootToken, address indexed childToken);
99     event ProofValidatorAdded(address indexed validator, address indexed from);
100     event ProofValidatorRemoved(address indexed validator, address indexed from);
101     event PredicateAdded(address indexed predicate, address indexed from);
102     event PredicateRemoved(address indexed predicate, address indexed from);
103     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
104 
105     constructor(address _governance) public Governable(_governance) {}
106 
107     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
108         emit ContractMapUpdated(_key, contractMap[_key], _address);
109         contractMap[_key] = _address;
110     }
111 
112     /**
113      * @dev Map root token to child token
114      * @param _rootToken Token address on the root chain
115      * @param _childToken Token address on the child chain
116      * @param _isERC721 Is the token being mapped ERC721
117      */
118     function mapToken(
119         address _rootToken,
120         address _childToken,
121         bool _isERC721
122     ) external onlyGovernance {
123         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
124         rootToChildToken[_rootToken] = _childToken;
125         childToRootToken[_childToken] = _rootToken;
126         isERC721[_rootToken] = _isERC721;
127         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
128         emit TokenMapped(_rootToken, _childToken);
129     }
130 
131     function addErc20Predicate(address predicate) public onlyGovernance {
132         require(predicate != address(0x0), "Can not add null address as predicate");
133         erc20Predicate = predicate;
134         addPredicate(predicate, Type.ERC20);
135     }
136 
137     function addErc721Predicate(address predicate) public onlyGovernance {
138         erc721Predicate = predicate;
139         addPredicate(predicate, Type.ERC721);
140     }
141 
142     function addPredicate(address predicate, Type _type) public onlyGovernance {
143         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
144         predicates[predicate]._type = _type;
145         emit PredicateAdded(predicate, msg.sender);
146     }
147 
148     function removePredicate(address predicate) public onlyGovernance {
149         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
150         delete predicates[predicate];
151         emit PredicateRemoved(predicate, msg.sender);
152     }
153 
154     function getValidatorShareAddress() public view returns (address) {
155         return contractMap[VALIDATOR_SHARE];
156     }
157 
158     function getWethTokenAddress() public view returns (address) {
159         return contractMap[WETH_TOKEN];
160     }
161 
162     function getDepositManagerAddress() public view returns (address) {
163         return contractMap[DEPOSIT_MANAGER];
164     }
165 
166     function getStakeManagerAddress() public view returns (address) {
167         return contractMap[STAKE_MANAGER];
168     }
169 
170     function getSlashingManagerAddress() public view returns (address) {
171         return contractMap[SLASHING_MANAGER];
172     }
173 
174     function getWithdrawManagerAddress() public view returns (address) {
175         return contractMap[WITHDRAW_MANAGER];
176     }
177 
178     function getChildChainAndStateSender() public view returns (address, address) {
179         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
180     }
181 
182     function isTokenMapped(address _token) public view returns (bool) {
183         return rootToChildToken[_token] != address(0x0);
184     }
185 
186     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
187         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
188         return isERC721[_token];
189     }
190 
191     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
192         if (isTokenMappedAndIsErc721(_token)) {
193             return erc721Predicate;
194         }
195         return erc20Predicate;
196     }
197 
198     function isChildTokenErc721(address childToken) public view returns (bool) {
199         address rootToken = childToRootToken[childToken];
200         require(rootToken != address(0x0), "Child token is not mapped");
201         return isERC721[rootToken];
202     }
203 }
204 
205 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
206 
207 pragma solidity ^0.5.2;
208 
209 
210 /**
211  * @title Ownable
212  * @dev The Ownable contract has an owner address, and provides basic authorization control
213  * functions, this simplifies the implementation of "user permissions".
214  */
215 contract Ownable {
216     address private _owner;
217 
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     /**
221      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
222      * account.
223      */
224     constructor() internal {
225         _owner = msg.sender;
226         emit OwnershipTransferred(address(0), _owner);
227     }
228 
229     /**
230      * @return the address of the owner.
231      */
232     function owner() public view returns (address) {
233         return _owner;
234     }
235 
236     /**
237      * @dev Throws if called by any account other than the owner.
238      */
239     modifier onlyOwner() {
240         require(isOwner());
241         _;
242     }
243 
244     /**
245      * @return true if `msg.sender` is the owner of the contract.
246      */
247     function isOwner() public view returns (bool) {
248         return msg.sender == _owner;
249     }
250 
251     /**
252      * @dev Allows the current owner to relinquish control of the contract.
253      * It will not be possible to call the functions with the `onlyOwner`
254      * modifier anymore.
255      * @notice Renouncing ownership will leave the contract without an owner,
256      * thereby removing any functionality that is only available to the owner.
257      */
258     function renounceOwnership() public onlyOwner {
259         emit OwnershipTransferred(_owner, address(0));
260         _owner = address(0);
261     }
262 
263     /**
264      * @dev Allows the current owner to transfer control of the contract to a newOwner.
265      * @param newOwner The address to transfer ownership to.
266      */
267     function transferOwnership(address newOwner) public onlyOwner {
268         _transferOwnership(newOwner);
269     }
270 
271     /**
272      * @dev Transfers control of the contract to a newOwner.
273      * @param newOwner The address to transfer ownership to.
274      */
275     function _transferOwnership(address newOwner) internal {
276         require(newOwner != address(0));
277         emit OwnershipTransferred(_owner, newOwner);
278         _owner = newOwner;
279     }
280 }
281 
282 // File: contracts/common/misc/ProxyStorage.sol
283 
284 pragma solidity ^0.5.2;
285 
286 
287 contract ProxyStorage is Ownable {
288     address internal proxyTo;
289 }
290 
291 // File: contracts/common/mixin/ChainIdMixin.sol
292 
293 pragma solidity ^0.5.2;
294 
295 
296 contract ChainIdMixin {
297     bytes public constant networkId = hex"89";
298     uint256 public constant CHAINID = 137;
299 }
300 
301 // File: contracts/root/RootChainStorage.sol
302 
303 pragma solidity ^0.5.2;
304 
305 
306 contract RootChainHeader {
307     event NewHeaderBlock(
308         address indexed proposer,
309         uint256 indexed headerBlockId,
310         uint256 indexed reward,
311         uint256 start,
312         uint256 end,
313         bytes32 root
314     );
315     // housekeeping event
316     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
317     struct HeaderBlock {
318         bytes32 root;
319         uint256 start;
320         uint256 end;
321         uint256 createdAt;
322         address proposer;
323     }
324 }
325 
326 
327 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
328     bytes32 public heimdallId;
329     uint8 public constant VOTE_TYPE = 2;
330 
331     uint16 internal constant MAX_DEPOSITS = 10000;
332     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
333     uint256 internal _blockDepositId = 1;
334     mapping(uint256 => HeaderBlock) public headerBlocks;
335     Registry internal registry;
336 }
337 
338 // File: contracts/common/misc/ERCProxy.sol
339 
340 /*
341  * SPDX-License-Identitifer:    MIT
342  */
343 
344 pragma solidity ^0.5.2;
345 
346 
347 // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-897.md
348 
349 interface ERCProxy {
350     function proxyType() external pure returns (uint256 proxyTypeId);
351 
352     function implementation() external view returns (address codeAddr);
353 }
354 
355 // File: contracts/common/misc/DelegateProxy.sol
356 
357 pragma solidity ^0.5.2;
358 
359 
360 contract DelegateProxy is ERCProxy {
361     function proxyType() external pure returns (uint256 proxyTypeId) {
362         // Upgradeable proxy
363         proxyTypeId = 2;
364     }
365 
366     function implementation() external view returns (address);
367 
368     function delegatedFwd(address _dst, bytes memory _calldata) internal {
369         // solium-disable-next-line security/no-inline-assembly
370         assembly {
371             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
372             let size := returndatasize
373 
374             let ptr := mload(0x40)
375             returndatacopy(ptr, 0, size)
376 
377             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
378             // if the call returned error data, forward it
379             switch result
380                 case 0 {
381                     revert(ptr, size)
382                 }
383                 default {
384                     return(ptr, size)
385                 }
386         }
387     }
388 }
389 
390 // File: contracts/common/misc/Proxy.sol
391 
392 pragma solidity ^0.5.2;
393 
394 
395 contract Proxy is ProxyStorage, DelegateProxy {
396     event ProxyUpdated(address indexed _new, address indexed _old);
397     event OwnerUpdate(address _prevOwner, address _newOwner);
398 
399     constructor(address _proxyTo) public {
400         updateImplementation(_proxyTo);
401     }
402 
403     function() external payable {
404         // require(currentContract != 0, "If app code has not been set yet, do not call");
405         // Todo: filter out some calls or handle in the end fallback
406         delegatedFwd(proxyTo, msg.data);
407     }
408 
409     function implementation() external view returns (address) {
410         return proxyTo;
411     }
412 
413     function updateImplementation(address _newProxyTo) public onlyOwner {
414         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
415         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
416         emit ProxyUpdated(_newProxyTo, proxyTo);
417         proxyTo = _newProxyTo;
418     }
419 
420     function isContract(address _target) internal view returns (bool) {
421         if (_target == address(0)) {
422             return false;
423         }
424 
425         uint256 size;
426         assembly {
427             size := extcodesize(_target)
428         }
429         return size > 0;
430     }
431 }
432 
433 // File: contracts/root/RootChainProxy.sol
434 
435 pragma solidity ^0.5.2;
436 
437 
438 contract RootChainProxy is Proxy, RootChainStorage {
439     constructor(
440         address _proxyTo,
441         address _registry,
442         string memory _heimdallId
443     ) public Proxy(_proxyTo) {
444         registry = Registry(_registry);
445         heimdallId = keccak256(abi.encodePacked(_heimdallId));
446     }
447 }