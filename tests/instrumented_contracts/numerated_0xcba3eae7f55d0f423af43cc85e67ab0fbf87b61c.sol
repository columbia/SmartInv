1 pragma solidity ^0.7.1;
2 //SPDX-License-Identifier: UNLICENSED
3 
4 /* New ERC23 contract interface */
5 
6 interface IErc223 {
7     function totalSupply() external view returns (uint);
8 
9     function balanceOf(address who) external view returns (uint);
10 
11     function transfer(address to, uint value) external returns (bool ok);
12     function transfer(address to, uint value, bytes memory data) external returns (bool ok);
13     
14     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
15 }
16 
17 /**
18 * @title Contract that will work with ERC223 tokens.
19 */
20 
21 interface IErc223ReceivingContract {
22     /**
23      * @dev Standard ERC223 function that will handle incoming token transfers.
24      *
25      * @param _from  Token sender address.
26      * @param _value Amount of tokens.
27      * @param _data  Transaction metadata.
28      */
29     function tokenFallback(address _from, uint _value, bytes memory _data) external returns (bool ok);
30 }
31 
32 
33 interface IErc20 {
34     function totalSupply() external view returns (uint);
35     function balanceOf(address tokenOwner) external view returns (uint balance);
36     function transfer(address to, uint tokens) external returns (bool success);
37 
38     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
39     function approve(address spender, uint tokens) external returns (bool success);
40     function transferFrom(address from, address to, uint tokens) external returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 
48 interface IShyftCacheGraph {
49     function compileCacheGraph(address _identifiedAddress, uint16 _idx) external;
50 
51     function getKycCanSend( address _senderIdentifiedAddress,
52                             address _receiverIdentifiedAddress,
53                             uint256 _amount,
54                             uint256 _bip32X_type,
55                             bool _requiredConsentFromAllParties,
56                             bool _payForDirty) external returns (uint8 result);
57 
58     function getActiveConsentedTrustChannelBitFieldForPair( address _senderIdentifiedAddress,
59                                                             address _receiverIdentifiedAddress) external returns (uint32 result);
60 
61     function getActiveTrustChannelBitFieldForPair(  address _senderIdentifiedAddress,
62                                                     address _receiverIdentifiedAddress) external returns (uint32 result);
63 
64     function getActiveConsentedTrustChannelRoutePossible(   address _firstAddress,
65                                                             address _secondAddress,
66                                                             address _trustChannelAddress) external view returns (bool result);
67 
68     function getActiveTrustChannelRoutePossible(address _firstAddress,
69                                                 address _secondAddress,
70                                                 address _trustChannelAddress) external view returns (bool result);
71 
72     function getRelativeTrustLevelOnlyClean(address _senderIdentifiedAddress,
73                                             address _receiverIdentifiedAddress,
74                                             uint256 _amount,
75                                             uint256 _bip32X_type,
76                                             bool _requiredConsentFromAllParties,
77                                             bool _requiredActive) external returns (int16 relativeTrustLevel, int16 externalTrustLevel);
78 
79     function calculateRelativeTrustLevel(   uint32 _trustChannelIndex,
80                                             uint256 _foundChannelRulesBitField,
81                                             address _senderIdentifiedAddress,
82                                             address _receiverIdentifiedAddress,
83                                             uint256 _amount,
84                                             uint256 _bip32X_type,
85                                             bool _requiredConsentFromAllParties,
86                                             bool _requiredActive) external returns(int16 relativeTrustLevel, int16 externalTrustLevel);
87 }
88 
89 
90 
91 interface IShyftKycContractRegistry  {
92     function isShyftKycContract(address _addr) external view returns (bool result);
93     function getCurrentContractAddress() external view returns (address);
94     function getContractAddressOfVersion(uint _version) external view returns (address);
95     function getContractVersionOfAddress(address _address) external view returns (uint256 result);
96 
97     function getAllTokenLocations(address _addr, uint256 _bip32X_type) external view returns (bool[] memory resultLocations, uint256 resultNumFound);
98     function getAllTokenLocationsAndBalances(address _addr, uint256 _bip32X_type) external view returns (bool[] memory resultLocations, uint256[] memory resultBalances, uint256 resultNumFound, uint256 resultTotalBalance);
99 }
100 
101 
102 
103 /// @dev Inheritable constants for token types
104 
105 contract TokenConstants {
106 
107     //@note: reference from https://github.com/satoshilabs/slips/blob/master/slip-0044.md
108     // hd chaincodes are 31 bits (max integer value = 2147483647)
109 
110     //@note: reference from https://chainid.network/
111     // ethereum-compatible chaincodes are 32 bits
112 
113     // given these, the final "nativeType" needs to be a mix of both.
114 
115     uint256 constant TestNetTokenOffset = 2**128;
116     uint256 constant PrivateNetTokenOffset = 2**192;
117 
118     uint256 constant ShyftTokenType = 7341;
119     uint256 constant EtherTokenType = 60;
120     uint256 constant EtherClassicTokenType = 61;
121     uint256 constant RootstockTokenType = 137;
122 
123     //Shyft Testnets
124     uint256 constant BridgeTownTokenType = TestNetTokenOffset + 0;
125 
126     //Ethereum Testnets
127     uint256 constant GoerliTokenType = TestNetTokenOffset + 1;
128     uint256 constant KovanTokenType = TestNetTokenOffset + 2;
129     uint256 constant RinkebyTokenType = TestNetTokenOffset + 3;
130     uint256 constant RopstenTokenType = TestNetTokenOffset + 4;
131 
132     //Ethereum Classic Testnets
133     uint256 constant KottiTokenType = TestNetTokenOffset + 5;
134 
135     //Rootstock Testnets
136     uint256 constant RootstockTestnetTokenType = TestNetTokenOffset + 6;
137 
138     //@note:@here:@deploy: need to hardcode test and/or privatenet for deploy on various blockchains
139     bool constant IsTestnet = false;
140     bool constant IsPrivatenet = false;
141 
142     //@note:@here:@deploy: need to hardcode NativeTokenType for deploy on various blockchains
143 //    uint256 constant NativeTokenType = ShyftTokenType;
144 }
145 // pragma experimental ABIEncoderV2;
146 
147 
148 
149 
150 
151 
152 
153 
154 /**
155  * @title SafeMath
156  * @dev Unsigned math operations with safety checks that revert on error
157  */
158 library SafeMath {
159   /**
160    * @dev Multiplies two unsigned integers, reverts on overflow.
161    */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164     // benefit is lost if 'b' is also tested.
165     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
166     if (a == 0) {
167       return 0;
168     }
169 
170     uint256 c = a * b;
171     require(c / a == b);
172 
173     return c;
174   }
175 
176   /**
177    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
178    */
179   function div(uint256 a, uint256 b) internal pure returns (uint256) {
180     // Solidity only automatically asserts when dividing by 0
181     require(b > 0);
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184 
185     return c;
186   }
187 
188   /**
189    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
190    */
191   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192     require(b <= a);
193     uint256 c = a - b;
194 
195     return c;
196   }
197 
198   /**
199    * @dev Adds two unsigned integers, reverts on overflow.
200    */
201   function add(uint256 a, uint256 b) internal pure returns (uint256) {
202     uint256 c = a + b;
203     require(c >= a);
204 
205     return c;
206   }
207 
208   /**
209    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
210    * reverts when dividing by zero.
211    */
212   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213     require(b != 0);
214     return a % b;
215   }
216 }
217 
218 
219 
220 
221 
222 
223 
224 
225 interface IShyftKycContract is IErc20, IErc223, IErc223ReceivingContract {
226     function balanceOf(address tokenOwner) external view override(IErc20, IErc223) returns (uint balance);
227     function totalSupply() external view override(IErc20, IErc223) returns (uint);
228     function transfer(address to, uint tokens) external override(IErc20, IErc223) returns (bool success);
229 
230     function getNativeTokenType() external view returns (uint256 result);
231 
232     function withdrawNative(address payable _to, uint256 _value) external returns (bool ok);
233     function withdrawToExternalContract(address _to, uint256 _value) external returns (bool ok);
234     function withdrawToShyftKycContract(address _shyftKycContractAddress, address _to, uint256 _value) external returns (bool ok);
235 
236     function migrateFromKycContract(address _to) external payable returns(bool result);
237     function updateContract(address _addr) external returns (bool);
238 
239     function getBalanceBip32X(address _identifiedAddress, uint256 _bip32X_type) external view returns (uint256 balance);
240 
241     function getOnlyAcceptsKycInput(address _identifiedAddress) external view returns (bool result);
242     function getOnlyAcceptsKycInputPermanently(address _identifiedAddress) external view returns (bool result);
243 }
244 
245 
246 
247 /// @dev | Shyft Core :: Shyft Kyc Contract
248 ///      |
249 ///      | This contract is the nucleus of all of the Shyft stack. This current v1 version has basic functionality for upgrading and connects to the Shyft Cache Graph via Routing for further system expansion.
250 ///      |
251 ///      | It should be noted that all payable functions should utilize revert, as they are dealing with assets.
252 ///      |
253 ///      | "Bip32X" & Synthetics - Here we're using an extension of the Bip32 standard that effectively uses a hash of contract address & "chainId" to allow any erc20/erc223 contract to allow assets to move through Shyft's opt-in compliance rails.
254 ///      | Ex. Ethereum = 60
255 ///      | Shyft Network = 7341
256 ///      |
257 ///      | This contract is built so that when the totalSupply is asked for, much like transfer et al., it only references the ShyftTokenType. For getting the native balance of any specific Bip32X token, you'd call "getTotalSupplyBip32X" with the proper contract address.
258 ///      |
259 ///      | "Auto Migration"
260 ///      | This contract was built with the philosophy that while there needs to be *some* upgrade path, unilaterally changing the existing contract address for Users is a bad idea in practice. Instead, we use a versioning system with the ability for users to set flags to automatically upgrade their liquidity on send into this particular contract, to any other contracts that have been updated so far (in a recursive manner).
261 ///      |
262 ///      | Auto-Migration of assets flow:
263 ///      | 1. registry contract is set up
264 ///      | 2. upgrade is called by registry contract
265 ///      | 3. calls to fallback looks to see if upgrade is set
266 ///      | 4. if so it asks the registry for the current contract address
267 ///      | 5. it then uses the "migrateFromKycContract", which on the receiver's end will update the _to address passed in with the progression and now has the value from the "migrateFromKycContract"'s payable and thus the native fuel, to back the token increase to the _to's account.
268 ///      |
269 ///      |
270 ///      | What's Next (V2 notes):
271 ///      |
272 ///      | "Shyft Safe" - timelocked assets that will work with Byfrost
273 ///      | "Shyft Byfrost" - economic finality bridge infrastructure
274 ///      |
275 ///      | Compliance Channels:
276 ///      | Addresses that only accept kyc input should be able to receive packages by the bridge that are only kyc'd across byfrost.
277 ///      | Ultimate accountability chain could be difficult, though a hash map of critical ipfs resources of chain data could suffice.
278 ///      | This would be the same issue as data accountability by trying to leverage multiple chains for data sales as well.
279 
280 contract ShyftKycContract is IShyftKycContract, TokenConstants {
281     /// @dev Event for migration to another shyft kyc contract (of higher or equal version).
282     event EVT_migrateToKycContract(address indexed updatedShyftKycContractAddress, uint256 updatedContractBalance, address indexed kycContractAddress, address indexed to, uint256 _amount);
283     /// @dev Event for migration to another shyft kyc contract (from lower or equal version).
284     event EVT_migrateFromContract(address indexed sendingKycContract, uint256 totalSupplyBip32X, uint256 msgValue, uint256 thisBalance);
285 
286     /// @dev Event for receipt of native assets.
287     event EVT_receivedNativeBalance(address indexed _from, uint256 _value);
288 
289     /// @dev Event for withdraw to address.
290     event EVT_WithdrawToAddress(address _from, address _to, uint256 _value);
291     /// @dev Event for withdraw to a specific shyft smart contract.
292     event EVT_WithdrawToShyftKycContract(address _from, address _to, uint256 _value);
293     /// @dev Event for withdraw to external contract (w/ Erc223 fallbacks).
294     event EVT_WithdrawToExternalContract(address _from, address _to, uint256 _value);
295 
296     /// @dev Event for getting an erc223 asset inbound to this contract.
297     event EVT_Bip32X_TypeTokenFallback(address msgSender, address _from, uint256 value, uint256 nativeTokenType, uint256 bip32X_type);
298 
299     event EVT_TransferAndMintBip32X_type(address contractAddress, address msgSender, uint256 value, uint256 bip32X_type);
300     event EVT_TransferAndBurnBip32X_type(address contractAddress, address msgSender, address to, uint256 value, uint256 bip32X_type);
301 
302     event EVT_TransferBip32X_type(address msgSender, address to, uint256 value, uint256 bip32X_type);
303 
304     /* ERC223 events */
305     event EVT_Erc223TokenFallback(address _from, uint256 _value, bytes _data);
306 
307     using SafeMath for uint256;
308 
309     /// @dev Mapping of total supply specific bip32x assets.
310     mapping(uint256 => uint256) totalSupplyBip32X;
311     /// @dev Mapping of users to their balances of specific bip32x assets.
312     mapping(address => mapping(uint256 => uint256)) balances;
313     /// @dev Mapping of users to users with amount of allowance set for specific bip32x assets.
314     mapping(address => mapping(address => mapping(uint256 => uint256))) allowed;
315 
316     /// @dev Mapping of users to whether they have set auto-upgrade enabled.
317     mapping(address => bool) autoUpgradeEnabled;
318     /// @dev Mapping of users to whether they Accepts Kyc Input only.
319     mapping(address => bool) onlyAcceptsKycInput;
320     /// @dev Mapping of users to whether their Accepts Kyc Input option is locked permanently.
321     mapping(address => bool) lockOnlyAcceptsKycInputPermanently;
322 
323     /// @dev mutex lock, prevent recursion in functions that use external function calls
324     bool locked;
325 
326     /// @dev Whether there has been an upgrade from this contract.
327     bool public hasBeenUpdated;
328     /// @dev The address of the next upgraded Shyft Kyc Contract.
329     address public updatedShyftKycContractAddress;
330     /// @dev The address of the Shyft Kyc Registry contract.
331     address public shyftKycContractRegistryAddress;
332 
333     /// @dev The address of the Shyft Cache Graph contract.
334     address public shyftCacheGraphAddress = address(0);
335 
336     /// @dev The signature for triggering 'tokenFallback' in erc223 receiver contracts.
337     bytes4 constant shyftKycContractSig = bytes4(keccak256("fromShyftKycContract(address,address,uint256,uint256)")); // function signature
338 
339     /// @dev The signature for the upgrade event.
340     bytes4 shyftKycContractTokenUpgradeSig = bytes4(keccak256("updateShyftToken(address,uint256,uint256)")); // function signature
341 
342     /// @dev The origin of the Byfrost link, if this contract is used as such. follows chainId.
343     bool public byfrostOrigin;
344     /// @dev Flag for whether the Byfrost state has been set.
345     bool public setByfrostOrigin;
346 
347     /// @dev The owner of this contract.
348     address public owner;
349     /// @dev The native Bip32X type of this network. Ethereum is 60, Shyft is 7341, etc.
350     uint256 nativeBip32X_type;
351 
352     /// @param _nativeBip32X_type The native Bip32X type of this network. Ethereum is 60, Shyft is 7341, etc.
353     /// @dev Invoke the constructor for ShyftSafe, which sets the owner and nativeBip32X_type class variables
354     constructor(uint256 _nativeBip32X_type) {
355         owner = msg.sender;
356 
357         nativeBip32X_type = _nativeBip32X_type;
358     }
359 
360     /// @dev Gets the native bip32x token (should correspond to "chainid")
361     /// @return result the native bip32x token (should correspond to "chainid")
362 
363     function getNativeTokenType() public override view returns (uint256 result) {
364         return nativeBip32X_type;
365     }
366 
367     /// @param _tokenAmount The amount of tokens to be allocated.
368     /// @param _bip32X_type The Bip32X type that represents the synthetic tokens that will be allocated.
369     /// @param _distributionContract The public address of the distribution contract, that the tokens are allocated for.
370     /// @dev Set by the owner, this functions sets it such that this contract was deployed on a Byfrost arm of the Shyft Network (on Ethereum for example). With this is a token grant that this contract should make to a specific distribution contract (ie. in the case of the initial Shyft Network launch, we have a small allocation originating on the Ethereum network).
371     /// @notice | for created kyc contracts on other chains, they can be instantiated with specific bip32X_type amounts
372     ///         | (for example, the shyft distribution contract on eth vs. shyft native)
373     ///         |  '  uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc20ContractAddress)));
374     ///         |  '  bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, msg.sender)));
375     ///         | the bip32X_type is formed by the hash of the native bip32x type (which is unique per-platform, as it depends on
376     ///         | the deployed contract address) - byfrost only touches non-replay networks.
377     ///         | so the formula for the bip32X_type would be HASH [ byfrost main chain bip32X_type ] & [ byfrost main chain kyc contract address ]
378     ///         | these minted tokens are given to the distribution contract for further distribution. This is all this contract
379     ///         | needs to know about the distribution contract.
380     /// @return result
381     ///    | 2 = set byfrost as origin
382     ///    | 1 = already set byfrost origin
383     ///    | 0 = not owner
384 
385     function setByfrostNetwork(uint256 _tokenAmount, uint256 _bip32X_type, address _distributionContract) public returns (uint8 result) {
386         if (msg.sender == owner) {
387             if (setByfrostOrigin == false) {
388                 byfrostOrigin = true;
389                 setByfrostOrigin = true;
390 
391                 balances[_distributionContract][_bip32X_type] = _tokenAmount;
392 
393                 //set byfrost as origin
394                 return 2;
395             } else {
396                 //already set
397                 return 1;
398             }
399         } else {
400             //not owner
401             return 0;
402         }
403     }
404 
405     /// @dev Set by the owner, this function sets it such that this contract was deployed on the primary Shyft Network. No further calls to setByfrostNetwork may be made.
406     /// @return result
407     ///    | 2 = set primary network
408     ///    | 1 = already set byfrost origin
409     ///    | 0 = not owner
410 
411     function setPrimaryNetwork() public returns (uint8 result) {
412         if (msg.sender == owner) {
413             if (setByfrostOrigin == false) {
414                 setByfrostOrigin = true;
415 
416                 //set primary network
417                 return 2;
418             } else {
419                 //already set byfrost origin
420                 return 1;
421             }
422         } else {
423             //not owner
424             return 0;
425         }
426     }
427 
428     /// @dev Removes the owner (creator of this contract)'s control completely. Functions such as linking the registry & cachegraph (& shyftSafe's setBridge), and importantly initializing this as a byfrost contract, are triggered by the owner, and as such a setting phase and afterwards triggering this function could be seen as a completely appropriate workflow.
429     /// @return true if the owner is removed successfully
430     function removeOwner() public returns (bool) {
431         require(msg.sender == owner);
432 
433         owner = address(0);
434         return true;
435     }
436 
437     /// @param _shyftCacheGraphAddress The smart contract address for the Shyft CacheGraph that should be linked.
438     /// @dev Links Shyft CacheGraph to this contract's function flow.
439     /// @return result
440     ///    | 0: not owner
441     ///    | 1: set shyft cache graph address
442 
443     function setShyftCacheGraphAddress(address _shyftCacheGraphAddress) public returns (uint8 result) {
444         require(_shyftCacheGraphAddress != address(0));
445         if (owner == msg.sender) {
446             shyftCacheGraphAddress = _shyftCacheGraphAddress;
447 
448             //cacheGraph contract address set
449             return 1;
450         } else {
451             //not owner
452             return 0;
453         }
454     }
455 
456     //---------------- Cache Graph Utilization ----------------//
457 
458     /// @param _identifiedAddress The public address for the recipient to send assets (tokens) to.
459     /// @param _amount The amount of assets that will be sent.
460     /// @param _bip32X_type The bip32X type of the assets that will be sent. These are synthetic (wrapped) assets, based on atomic locking.
461     /// @param _requiredConsentFromAllParties Whether to match the routing algorithm on the "consented" layer which indicates 2 way buy in of counterparty's attestation(s)
462     /// @param _payForDirty Whether the sender will pay the additional cost to unify a cachegraph's relationships (if not, it will not complete).
463     /// @dev | Performs a "kyc send", which is an automatic search between addresses for counterparty relationships within Trust Channels (whos rules dictate accessibility for auditing/enforcement/jurisdiction/etc.). If there is a match, the designated amount of assets is sent to the recipient.
464     ///      | As there are accessor methods to check whether or not the counterparty's cachegraph is "dirty", there is little need to pass a "true" unless the transaction is critical (eg. DeFi atomic flash wrap) and there is a chance that there will need to be a unification pass before the transaction can pass with full assurety.
465     /// @notice | If the recipient has flags set to indicate that they *only* want to receive assets from kyc sources, *all* of the regular transfer functions will block except this one, and this one only passes on success.
466     /// @return result
467     ///    | 0 = not enough balance to send
468     ///    | 1 = consent required
469     ///    | 2 = transfer cannot be processed due to transfer rules
470     ///    | 3 = successful transfer
471 
472     function kycSend(address _identifiedAddress, uint256 _amount, uint256 _bip32X_type, bool _requiredConsentFromAllParties, bool _payForDirty) public returns (uint8 result) {
473         if (balances[msg.sender][_bip32X_type] >= _amount) {
474             if (onlyAcceptsKycInput[_identifiedAddress] == false || (onlyAcceptsKycInput[_identifiedAddress] == true && _requiredConsentFromAllParties == true)) {
475                 IShyftCacheGraph shyftCacheGraph = IShyftCacheGraph(shyftCacheGraphAddress);
476 
477                 uint8 kycCanSendResult = shyftCacheGraph.getKycCanSend(msg.sender, _identifiedAddress, _amount, _bip32X_type, _requiredConsentFromAllParties, _payForDirty);
478 
479                 //getKycCanSend return 3 = can transfer successfully
480                 if (kycCanSendResult == 3) {
481                     balances[msg.sender][_bip32X_type] = balances[msg.sender][_bip32X_type].sub(_amount);
482                     balances[_identifiedAddress][_bip32X_type] = balances[_identifiedAddress][_bip32X_type].add(_amount);
483 
484                     //successful transfer
485                     return 3;
486                 } else {
487                     //transfer cannot be processed due to transfer rules
488                     return 2;
489                 }
490             } else {
491                 //consent required
492                 return 1;
493             }
494         } else {
495             //not enough balance to send
496             return 0;
497         }
498     }
499 
500     //---------------- Shyft KYC balances, fallback, send, receive, and withdrawal ----------------//
501 
502 
503     /// @dev mutex locks transactions ordering so that multiple chained calls cannot complete out of order.
504 
505     modifier mutex() {
506         if (locked) revert();
507         locked = true;
508         _;
509         locked = false;
510     }
511 
512     /// @param _addr The Shyft Kyc Contract Registry address to set to.
513     /// @dev Upgrades the contract. Can only be called by a pre-set Shyft Kyc Contract Registry contract. Can only be called once.
514     /// @return returns true if the function passes, otherwise reverts if the message sender is not the shyft kyc registry contract.
515 
516     function updateContract(address _addr) public override returns (bool) {
517         require(msg.sender == shyftKycContractRegistryAddress);
518         require(hasBeenUpdated == false);
519 
520         hasBeenUpdated = true;
521         updatedShyftKycContractAddress = _addr;
522         return true;
523     }
524 
525     /// @param _addr The Shyft Kyc Contract Registry address to set to.
526     /// @dev Sets the Shyft Kyc Contract Registry address, so this contract can be upgraded.
527     /// @return returns true if the function passes, otherwise reverts if the message sender is not the owner (deployer) of this contract.
528 
529     function setShyftKycContractRegistryAddress(address _addr) public returns (bool) {
530         require(msg.sender == owner);
531 
532         shyftKycContractRegistryAddress = _addr;
533         return true;
534     }
535 
536     /// @param _to The destination address to withdraw to.
537     /// @dev Withdraws all assets of this User to a specific address (only native assets, ie. Ether on Ethereum, Shyft on Shyft Network).
538     /// @return balance the number of tokens of that specific bip32x type in the user's account
539 
540     function withdrawAllNative(address payable _to) public returns (uint) {
541         uint _bal = balances[msg.sender][ShyftTokenType];
542         withdrawNative(_to, _bal);
543         return _bal;
544     }
545 
546     /// @param _identifiedAddress The address of the User.
547     /// @param _bip32X_type The Bip32X type to check.
548     /// @dev Gets balance for Shyft KYC token type & synthetics for a specfic user.
549     /// @return balance the number of tokens of that specific bip32x type in the user's account
550 
551     function getBalanceBip32X(address _identifiedAddress, uint256 _bip32X_type) public view override returns (uint256 balance) {
552         return balances[_identifiedAddress][_bip32X_type];
553     }
554 
555     /// @param _bip32X_type The Bip32X type to check.
556     /// @dev Gets the total supply for a specific bip32x token.
557     /// @return balance the number of tokens of that specific bip32x type in this contract
558 
559     function getTotalSupplyBip32X(uint256 _bip32X_type) public view returns (uint256 balance) {
560         return totalSupplyBip32X[_bip32X_type];
561     }
562 
563     /// @dev This fallback function applies value to nativeBip32X_type Token (Ether on Ethereum, Shyft on Shyft Network, etc). It also uses auto-upgrade logic so that users can automatically have their coins in the latest wallet (if everything is opted in across all contracts by the user).
564 
565     receive() external payable {
566         //@note: this is the auto-upgrade path, which is an opt-in service to the users to be able to send any or all tokens
567         // to an upgraded kycContract.
568         if (hasBeenUpdated && autoUpgradeEnabled[msg.sender]) {
569             //@note: to prevent tokens from ever getting "stuck", this contract can only send to itself in a very
570             // specific manner.
571             //
572             // for example, the "withdrawNative" function will output native fuel to a destination.
573             // If it was sent to this contract, this function will trigger and know that the msg.sender is
574             // the originating kycContract.
575 
576             if (msg.sender != address(this)) {
577                 // stop the process if the message sender has set a flag that only allows kyc input
578                 require(onlyAcceptsKycInput[msg.sender] == false);
579 
580                 // burn tokens in this contract
581                 uint256 existingSenderBalance = balances[msg.sender][nativeBip32X_type];
582 
583                 balances[msg.sender][nativeBip32X_type] = 0;
584                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(existingSenderBalance);
585 
586                 //~70k gas for the contract "call"
587                 //and 90k gas for the value transfer within this.
588                 // total = ~160k+checks gas to perform this transaction.
589                 bool didTransferSender = migrateToKycContract(updatedShyftKycContractAddress, msg.sender, existingSenderBalance.add(msg.value));
590 
591                 if (didTransferSender == true) {
592 
593                 } else {
594                     //@note: reverts since a transactional event has occurred.
595                     revert();
596                 }
597             } else {
598                 //****************************************************************************************************//
599                 //@note: This *must* be the only route where tx.origin has to matter.
600                 //****************************************************************************************************//
601 
602                 // duplicating the logic here for higher deploy cost vs. lower transactional costs (consider user costs
603                 // where all users would want to migrate)
604 
605                 // burn tokens in this contract
606                 uint256 existingOriginBalance = balances[tx.origin][nativeBip32X_type];
607 
608                 balances[tx.origin][nativeBip32X_type] = 0;
609                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(existingOriginBalance);
610 
611                 //~70k gas for the contract "call"
612                 //and 90k gas for the value transfer within this.
613                 // total = ~160k+checks gas to perform this transaction.
614 
615                 bool didTransferOrigin = migrateToKycContract(updatedShyftKycContractAddress, tx.origin, existingOriginBalance.add(msg.value));
616 
617                 if (didTransferOrigin == true) {
618 
619                 } else {
620                     //@note: reverts since a transactional event has occurred.
621                     revert();
622                 }
623             }
624         } else {
625             //@note: never accept this contract sending raw value to this fallback function, unless explicit cases
626             // have been met.
627             //@note: public addresses do not count as kyc'd addresses
628             if (msg.sender != address(this) && onlyAcceptsKycInput[msg.sender] == true) {
629                 revert();
630             }
631 
632             balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].add(msg.value);
633             totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].add(msg.value);
634 
635             emit EVT_receivedNativeBalance(msg.sender, msg.value);
636         }
637     }
638 
639     /// @param _kycContractAddress The Shyft Kyc Contract to migrate to.
640     /// @param _to The user's address to migrate to
641     /// @param _amount The amount of tokens to migrate.
642     /// @dev Internal function to migrates the user's assets to another Shyft Kyc Contract. This function is called from the fallback to allocate tokens properly to the upgraded contract.
643     /// @return result
644     ///    | true = transfer complete
645     ///    | false = transfer did not complete
646 
647     function migrateToKycContract(address _kycContractAddress, address _to, uint256 _amount) internal returns (bool result) {
648         // call upgraded contract so that tokens are forwarded to the new contract under _to's account.
649         IShyftKycContract updatedKycContract = IShyftKycContract(updatedShyftKycContractAddress);
650 
651         emit EVT_migrateToKycContract(updatedShyftKycContractAddress, address(updatedShyftKycContractAddress).balance, _kycContractAddress, _to, _amount);
652 
653         // sending to ShyftKycContracts only; migrateFromKycContract uses ~75830 - 21000 gas to execute,
654         // with a registry lookup, so adding in a bit more for future contracts.
655         bool transferResult = updatedKycContract.migrateFromKycContract{value: _amount, gas: 100000}(_to);
656 
657         if (transferResult == true) {
658             //transfer complete
659             return true;
660         } else {
661             //transfer did not complete
662             return false;
663         }
664     }
665 
666     /// @param _to The user's address to migrate to.
667     /// @dev | Migrates the user's assets from another Shyft Kyc Contract. The following conditions have to pass:
668     ///      | a) message sender is a shyft kyc contract,
669     ///      | b) sending shyft kyc contract is not of a later version than this one
670     ///      | c) user on this shyft kyc contract have no restrictions on only accepting KYC input (will ease in v2)
671     /// @return result
672     ///    | true = migration completed successfully
673     ///    | [revert] = reverts on any situation that fails on the above parameters
674 
675     function migrateFromKycContract(address _to) public payable override returns (bool result) {
676         //@note: doing a very strict check to make sure no unwanted additional tokens can be created.
677         // the way this work is that this.balance is updated *before* this code runs.
678         // thus, as long as we've always updated totalSupplyBip32X when we've created or destroyed tokens, we'll
679         // always be able to check against this.balance.
680 
681         //regarding an issue found:
682         //"Smart contracts, though they may not expect it, can receive ether forcibly, or could be deployed at an
683         // address that already received some ether."
684         // from:
685         // "require(totalSupplyBip32X[nativeBip32X_type].add(msg.value) == address(this).balance);"
686         //
687         // the worst case scenario in some non-atomic calls (without going through withdrawToShyftKycContract for example)
688         // is that someone self-destructs a contract and forcibly sends ether to this address, before this is triggered by
689         // someone using it.
690 
691         // solution:
692         // we cannot do a simple equality check for address(this).balance. instead, we use an less-than-or-equal-to, as
693         // when the worst case above occurs, the total supply of this synthetic will be less than the balance within this
694         // contract.
695 
696         require(totalSupplyBip32X[nativeBip32X_type].add(msg.value) <= address(this).balance);
697 
698         bool doContinue = true;
699 
700         IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
701 
702         // check if only using a known kyc contract communication cycle, then verify the message sender is a kyc contract.
703         if (contractRegistry.isShyftKycContract(address(msg.sender)) == false) {
704             doContinue = false;
705         } else {
706             // only allow migration from equal or older versions of Shyft Kyc Contracts, via registry lookup.
707             if (contractRegistry.getContractVersionOfAddress(address(msg.sender)) > contractRegistry.getContractVersionOfAddress(address(this))) {
708                 doContinue = false;
709             }
710         }
711 
712         // block transfers if the recipient only allows kyc input
713         if (onlyAcceptsKycInput[_to] == true) {
714             doContinue = false;
715         }
716 
717         if (doContinue == true) {
718             emit EVT_migrateFromContract(msg.sender, totalSupplyBip32X[nativeBip32X_type], msg.value, address(this).balance);
719 
720             balances[_to][nativeBip32X_type] = balances[_to][nativeBip32X_type].add(msg.value);
721             totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].add(msg.value);
722 
723             //transfer complete
724             return true;
725         } else {
726             //kyc contract not in registry
727             //@note: transactional event has occurred, so revert() is necessary
728             revert();
729             //return false;
730         }
731     }
732 
733     /// @param _onlyAcceptsKycInputValue Whether to accept only Kyc Input.
734     /// @dev Sets whether to accept only Kyc Input in the future.
735     /// @return result
736     ///    | true = updated onlyAcceptsKycInput
737     ///    | false = cannot modify onlyAcceptsKycInput, as it is locked permanently by user
738 
739     function setOnlyAcceptsKycInput(bool _onlyAcceptsKycInputValue) public returns (bool result) {
740         if (lockOnlyAcceptsKycInputPermanently[msg.sender] == false) {
741             onlyAcceptsKycInput[msg.sender] = _onlyAcceptsKycInputValue;
742 
743             //updated onlyAcceptsKycInput
744             return true;
745         } else {
746 
747             //cannot modify onlyAcceptsKycInput, as it is locked permanently by user
748             return false;
749         }
750     }
751 
752     /// @dev Gets whether the user has set Accepts Kyc Input.
753     /// @return result
754     ///    | true = set lock for onlyAcceptsKycInput
755     ///    | false = already set lock for onlyAcceptsKycInput
756 
757     function setLockOnlyAcceptsKycInputPermanently() public returns (bool result) {
758         if (lockOnlyAcceptsKycInputPermanently[msg.sender] == false) {
759             lockOnlyAcceptsKycInputPermanently[msg.sender] = true;
760             //set lock for onlyAcceptsKycInput
761             return true;
762         } else {
763             //already set lock for onlyAcceptsKycInput
764             return false;
765         }
766     }
767 
768     /// @param _identifiedAddress The public address to check.
769     /// @dev Gets whether the user has set Accepts Kyc Input.
770     /// @return result whether the user has set Accepts Kyc Input
771 
772     function getOnlyAcceptsKycInput(address _identifiedAddress) public view override returns (bool result) {
773         return onlyAcceptsKycInput[_identifiedAddress];
774     }
775 
776     /// @param _identifiedAddress The public address to check.
777     /// @dev Gets whether the user has set Accepts Kyc Input permanently (whether on or off).
778     /// @return result whether the user has set Accepts Kyc Input permanently (whether on or off)
779 
780     function getOnlyAcceptsKycInputPermanently(address _identifiedAddress) public view override returns (bool result) {
781         return lockOnlyAcceptsKycInputPermanently[_identifiedAddress];
782     }
783 
784     //---------------- Token Upgrades ----------------//
785 
786 
787     //****************************************************************************************************************//
788     //@note: instead of explicitly returning, assign return value to variable  allows the code after the _;
789     // in the mutex modifier to be run!
790     //****************************************************************************************************************//
791 
792     /// @param _value The amount of tokens to upgrade.
793     /// @dev Upgrades the user's tokens by sending them to the next contract (which will do the same). Sets auto upgrade for the user as well.
794     /// @return result
795     ///    | 3 = withdrew correctly
796     ///    | 2 = could not withdraw
797     ///    | 1 = not enough balance
798     ///    | 0 = contract has not been updated
799 
800     function upgradeNativeTokens(uint256 _value) mutex public returns (uint256 result) {
801         //check if it's been updated
802         if (hasBeenUpdated == true) {
803             //make sure the msg.sender has enough synthetic fuel to transfer
804             if (balances[msg.sender][nativeBip32X_type] >= _value) {
805                 autoUpgradeEnabled[msg.sender] = true;
806 
807                 //then proceed to send to address(this) to initiate the autoUpgrade
808                 // to the new contract.
809                 bool withdrawResult = withdrawToShyftKycContract(address(this), msg.sender, _value);
810                 if (withdrawResult == true) {
811                     //withdrew correctly
812                     result = 3;
813                 } else {
814                     //could not withdraw
815                     result = 2;
816                 }
817             } else {
818                 //not enough balance
819                 result = 1;
820             }
821         } else {
822             //contract has not been updated
823             result = 0;
824         }
825     }
826 
827     /// @param _autoUpgrade Whether the tokens should be automatically upgraded when sent to this contract.
828     /// @dev Sets auto upgrade for the message sender, for fallback functionality to upgrade tokens on receipt. The only reason a user would want to call this function is to modify behaviour *after* this contract has been updated, thus allowing choice.
829 
830     function setAutoUpgrade(bool _autoUpgrade) public {
831         autoUpgradeEnabled[msg.sender] = _autoUpgrade;
832     }
833 
834     //---------------- Native withdrawal / transfer functions ----------------//
835 
836     /// @param _to The destination payable address to send to.
837     /// @param _value The amount of tokens to transfer.
838     /// @dev Transfers native tokens (based on the current native Bip32X type, ex Shyft = 7341, Ethereum = 60) to the user's wallet.
839     /// @notice 30k gas limit for transfers.
840     /// @return ok
841     ///    | true = tokens withdrawn properly to another erc223 contract
842     ///    | false = the user does not have enough balance, or found a smart contract address instead of a payable address.
843 
844     function withdrawNative(address payable _to, uint256 _value) mutex public override returns (bool ok) {
845         if (balances[msg.sender][nativeBip32X_type] >= _value) {
846             uint codeLength;
847 
848             //retrieve the size of the code on target address, this needs assembly
849             assembly {
850                 codeLength := extcodesize(_to)
851             }
852 
853             //makes sure it's sending to a native (non-contract) address
854             if (codeLength == 0) {
855                 balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].sub(_value);
856                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(_value);
857 
858                 //@note: this is going to a regular account. the existing balance has already been reduced,
859                 // and as such the only thing to do is to send the actual Shyft fuel (or Ether, etc) to the
860                 // target address.
861 
862                 _to.transfer(_value);
863 
864                 emit EVT_WithdrawToAddress(msg.sender, _to, _value);
865                 ok = true;
866             } else {
867                 ok = false;
868             }
869         } else {
870             ok = false;
871         }
872     }
873 
874     /// @param _to The destination smart contract address to send to.
875     /// @param _value The amount of tokens to transfer.
876     /// @dev Transfers SHFT tokens to another external contract, using Erc223 mechanisms.
877     /// @notice 30k gas limit for transfers.
878     /// @return ok
879     ///    | true = tokens withdrawn properly to another erc223 contract
880     ///    | false = the user does not have enough balance, or not a smart contract address
881 
882     function withdrawToExternalContract(address _to, uint256 _value) mutex public override returns (bool ok) {
883         if (balances[msg.sender][nativeBip32X_type] >= _value) {
884             uint codeLength;
885 //            bytes memory empty;
886 
887             //retrieve the size of the code on target address, this needs assembly
888             assembly {
889                 codeLength := extcodesize(_to)
890             }
891 
892             //makes sure it's sending to a contract address
893             if (codeLength == 0) {
894                 ok = false;
895             } else {
896                 balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].sub(_value);
897                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(_value);
898 
899                 //this will fail when sending to contracts with fallback functions that consume more than 20000 gas
900 
901                 (bool success, ) = _to.call{value: _value, gas: 30000}("");
902 
903                 IErc223ReceivingContract receiver = IErc223ReceivingContract(_to);
904                 bool fallbackSuccess = receiver.tokenFallback(msg.sender, _value, abi.encodePacked(shyftKycContractSig));
905 
906                 if (success == true && fallbackSuccess == true) {
907                     emit EVT_WithdrawToExternalContract(msg.sender, _to, _value);
908 
909                     ok = true;
910                 } else {
911                     //@note:@here: needs revert() due to asset transactions already having occurred
912                     revert();
913                     //ok = false;
914                 }
915 
916             }
917         } else {
918             ok = false;
919         }
920     }
921 
922     /// @param _shyftKycContractAddress The address of the Shyft Kyc Contract that is being send to.
923     /// @param _to The destination address to send to.
924     /// @param _value The amount of tokens to transfer.
925     /// @dev Transfers SHFT tokens to another Shyft Kyc contract.
926     /// @notice 120k gas limit for transfers.
927     /// @return ok
928     ///    | true = tokens withdrawn properly to another Kyc Contract.
929     ///    | false = the user does not have enough balance, or not a correct shyft contract address, or receiver only accepts kyc input.
930 
931     function withdrawToShyftKycContract(address _shyftKycContractAddress, address _to, uint256 _value) mutex public override returns (bool ok) {
932         if (balances[msg.sender][nativeBip32X_type] >= _value) {
933             uint codeLength;
934 
935             //retrieve the size of the code on target address, this needs assembly
936             assembly {
937                 codeLength := extcodesize(_shyftKycContractAddress)
938             }
939 
940             //makes sure it's sending to a contract address
941             if (codeLength == 0) {
942                 // not a smart contract
943                 ok = false;
944             } else {
945                 balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].sub(_value);
946                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(_value);
947 
948                 IShyftKycContract receivingShyftKycContract = IShyftKycContract(_shyftKycContractAddress);
949 
950                 if (receivingShyftKycContract.getOnlyAcceptsKycInput(_to) == false) {
951                     // sending to ShyftKycContracts only; migrateFromKycContract uses ~75830 - 21000 gas to execute,
952                     // with a registry lookup. Adding 50k more just in case there are other checks in the v2.
953                     if (receivingShyftKycContract.migrateFromKycContract{gas: 120000, value: _value}(_to) == false) {
954                         revert();
955                     }
956 
957                     emit EVT_WithdrawToShyftKycContract(msg.sender, _to, _value);
958 
959                     ok = true;
960                 } else {
961                     // receiver only accepts kyc input
962                     ok = false;
963                 }
964             }
965         } else {
966             ok = false;
967         }
968     }
969 
970     //---------------- ERC 223 receiver ----------------//
971 
972     /// @param _from The address of the origin.
973     /// @param _value The address of the recipient.
974     /// @param _data The bytes data of any ERC223 transfer function.
975     /// @dev Transfers assets to destination, with ERC20 functionality. (basic ERC20 functionality, but blocks transactions if Only Accepts Kyc Input is set to true.)
976     /// @return ok returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
977 
978     function tokenFallback(address _from, uint _value, bytes memory _data) mutex public override returns (bool ok) {
979         // block transfers if the recipient only allows kyc input, check other factors
980         require(onlyAcceptsKycInput[_from] == false);
981 
982 
983         IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
984 
985         // if kyc registry exists, check if only using a known kyc contract communication cycle, then verify the message
986         // sender is a kyc contract.
987         if (shyftKycContractRegistryAddress != address(0) && contractRegistry.isShyftKycContract(address(msg.sender)) == true) {
988             revert("cannot process fallback from Shyft Kyc Contract in this version of Shyft Core");
989         }
990 
991         uint256 bip32X_type;
992 
993         bytes4 tokenSig;
994 
995         //make sure we have enough bytes to determine a signature
996         if (_data.length >= 4) {
997             tokenSig = bytes4(uint32(bytes4(bytes1(_data[3])) >> 24) + uint32(bytes4(bytes1(_data[2])) >> 16) + uint32(bytes4(bytes1(_data[1])) >> 8) + uint32(bytes4(bytes1(_data[0]))));
998         }
999 
1000         //@note: for token indexing, we use higher range addressable space (256 bit integer).
1001         // this guarantees practically infinite indexes.
1002         //@note: using msg.sender in the keccak hash since msg.sender in this case (should) be the
1003         // contract itself (and allowing this to be passed in, instead of using msg.sender, does not
1004         // suffice as any contract could then call this fallback.)
1005         //
1006         // thus, this fallback will not function properly with abstracted synthetics.
1007         bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, msg.sender)));
1008         balances[_from][bip32X_type] = balances[_from][bip32X_type].add(_value);
1009 
1010         emit EVT_Bip32X_TypeTokenFallback(msg.sender, _from, _value, nativeBip32X_type, bip32X_type);
1011         emit EVT_TransferAndMintBip32X_type(msg.sender, _from, _value, bip32X_type);
1012 
1013         ok = true;
1014 
1015         if (ok == true) {
1016             emit EVT_Erc223TokenFallback(_from, _value, _data);
1017         }
1018     }
1019 
1020     //---------------- ERC 223/20 ----------------//
1021 
1022     /// @param _who The address of the user.
1023     /// @dev Gets the balance for the SHFT token type for a specific user.
1024     /// @return the balance of the SHFT token type for the user
1025 
1026     function balanceOf(address _who) public view override returns (uint) {
1027         return balances[_who][ShyftTokenType];
1028     }
1029 
1030     /// @dev Gets the name of the token.
1031     /// @return _name of the token.
1032 
1033     function name() public pure returns (string memory _name) {
1034         return "Shyft [ Byfrost ]";
1035     }
1036 
1037     /// @dev Gets the symbol of the token.
1038     /// @return _symbol the symbol of the token
1039 
1040     function symbol() public pure returns (string memory _symbol) {
1041         //@note: "SFT" is the 3 letter variant
1042         return "SHFT";
1043     }
1044 
1045     /// @dev Gets the number of decimals of the token.
1046     /// @return _decimals number of decimals of the token.
1047 
1048     function decimals() public pure returns (uint8 _decimals) {
1049         return 18;
1050     }
1051 
1052     /// @dev Gets the number of SHFT tokens available.
1053     /// @return result total supply of SHFT tokens
1054 
1055     function totalSupply() public view override returns (uint256 result) {
1056         return getTotalSupplyBip32X(ShyftTokenType);
1057     }
1058 
1059     /// @param _to The address of the origin.
1060     /// @param _value The address of the recipient.
1061     /// @dev Transfers assets to destination, with ERC20 functionality. (basic ERC20 functionality, but blocks transactions if Only Accepts Kyc Input is set to true.)
1062     /// @return ok returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
1063 
1064     function transfer(address _to, uint256 _value) public override returns (bool ok) {
1065         // block transfers if the recipient only allows kyc input, check other factors
1066         if (onlyAcceptsKycInput[_to] == false && balances[msg.sender][ShyftTokenType] >= _value) {
1067             balances[msg.sender][ShyftTokenType] = balances[msg.sender][ShyftTokenType].sub(_value);
1068 
1069             balances[_to][ShyftTokenType] = balances[_to][ShyftTokenType].add(_value);
1070 
1071             emit Transfer(msg.sender, _to, _value);
1072 
1073             return true;
1074         } else {
1075             return false;
1076         }
1077     }
1078 
1079     /// @param _to The address of the origin.
1080     /// @param _value The address of the recipient.
1081     /// @param _data The bytes data of any ERC223 transfer function.
1082     /// @dev Transfers assets to destination, with ERC223 functionality. (basic ERC223 functionality, but blocks transactions if Only Accepts Kyc Input is set to true.)
1083     /// @return ok returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
1084 
1085     function transfer(address _to, uint _value, bytes memory _data) mutex public override returns (bool ok) {
1086         // block transfers if the recipient only allows kyc input, check other factors
1087         if (onlyAcceptsKycInput[_to] == false && balances[msg.sender][ShyftTokenType] >= _value) {
1088             uint codeLength;
1089 
1090             //retrieve the size of the code on target address, this needs assembly
1091             assembly {
1092                 codeLength := extcodesize(_to)
1093             }
1094 
1095             balances[msg.sender][ShyftTokenType] = balances[msg.sender][ShyftTokenType].sub(_value);
1096 
1097             balances[_to][ShyftTokenType] = balances[_to][ShyftTokenType].add(_value);
1098 
1099 
1100             if (codeLength > 0) {
1101                 IErc223ReceivingContract receiver = IErc223ReceivingContract(_to);
1102                 if (receiver.tokenFallback(msg.sender, _value, _data) == true) {
1103                     ok = true;
1104                 } else {
1105                     //@note: must revert() due to asset transactions already having occurred.
1106                     revert();
1107                 }
1108             } else {
1109                 ok = true;
1110             }
1111         }
1112 
1113         if (ok == true) {
1114             emit Transfer(msg.sender, _to, _value, _data);
1115         }
1116     }
1117 
1118     /// @param _tokenOwner The address of the origin.
1119     /// @param _spender The address of the recipient.
1120     /// @dev Get the current allowance for the basic Shyft token type. (basic ERC20 functionality)
1121     /// @return remaining the current allowance for the basic Shyft token type for a specific user
1122 
1123     function allowance(address _tokenOwner, address _spender) public view override returns (uint remaining) {
1124        return allowed[_tokenOwner][_spender][ShyftTokenType];
1125     }
1126 
1127 
1128     /// @param _spender The address of the recipient.
1129     /// @param _tokens The amount of tokens to transfer.
1130     /// @dev Allows pre-approving assets to be sent to a participant. (basic ERC20 functionality)
1131     /// @notice This (standard) function known to have an issue.
1132     /// @return success whether the approve function completed successfully
1133 
1134     function approve(address _spender, uint _tokens) public override returns (bool success) {
1135         allowed[msg.sender][_spender][ShyftTokenType] = _tokens;
1136 
1137         //example of issue:
1138         //user a has 20 tokens allowed from zero :: no incentive to frontrun
1139         //user a has +2 tokens allowed from 20 :: frontrunning would deplete 20 and add 2 :: incentive there.
1140 
1141         emit Approval(msg.sender, _spender, _tokens);
1142 
1143         return true;
1144     }
1145 
1146     /// @param _from The address of the origin.
1147     /// @param _to The address of the recipient.
1148     /// @param _tokens The amount of tokens to transfer.
1149     /// @dev Performs the withdrawal of pre-approved assets. (basic ERC20 functionality, but blocks transactions if Only Accepts Kyc Input is set to true.)
1150     /// @return success returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
1151 
1152     function transferFrom(address _from, address _to, uint _tokens) public override returns (bool success) {
1153         // block transfers if the recipient only allows kyc input, check other factors
1154         if (onlyAcceptsKycInput[_to] == false && allowed[_from][msg.sender][ShyftTokenType] >= _tokens && balances[_from][ShyftTokenType] >= _tokens) {
1155             allowed[_from][msg.sender][ShyftTokenType] = allowed[_from][msg.sender][ShyftTokenType].sub(_tokens);
1156 
1157             balances[_from][ShyftTokenType] = balances[_from][ShyftTokenType].sub(_tokens);
1158             balances[_to][ShyftTokenType] = balances[_to][ShyftTokenType].add(_tokens);
1159 
1160             emit Transfer(_from, _to, _tokens);
1161 
1162             return true;
1163         } else {
1164             return false;
1165         }
1166     }
1167 
1168     //---------------- Shyft Token Transfer [KycContract] ----------------//
1169 
1170     /// @param _to The address of the recipient.
1171     /// @param _value The amount of tokens to transfer.
1172     /// @param _bip32X_type The Bip32X type of the asset to transfer.
1173     /// @dev | Transfers assets from one Shyft user to another, with restrictions on the transfer if the recipient has enabled Only Accept KYC Input.
1174     /// @return result returns true if the transaction completes, reverts if it does not.
1175 
1176     function transferBip32X_type(address _to, uint256 _value, uint256 _bip32X_type) public returns (bool result) {
1177         // block transfers if the recipient only allows kyc input
1178         require(onlyAcceptsKycInput[_to] == false);
1179         require(balances[msg.sender][_bip32X_type] >= _value);
1180 
1181         balances[msg.sender][_bip32X_type] = balances[msg.sender][_bip32X_type].sub(_value);
1182         balances[_to][_bip32X_type] = balances[_to][_bip32X_type].add(_value);
1183 
1184         emit EVT_TransferBip32X_type(msg.sender, _to, _value, _bip32X_type);
1185         return true;
1186     }
1187 
1188     //---------------- Shyft Token Transfer [Erc223] ----------------//
1189 
1190     /// @param _erc223ContractAddress The address of the ERC223 contract that
1191     /// @param _to The address of the recipient.
1192     /// @param _value The amount of tokens to transfer.
1193     /// @dev | Withdraws a Bip32X type Shyft synthetic asset into its origin ERC223 contract. Burns the current synthetic balance.
1194     ///      | Cannot withdraw Bip32X type into an incorrect destination contract (as the hash will not match).
1195     /// @return ok returns true if the transaction completes, reverts if it does not
1196 
1197     function withdrawTokenBip32X_typeToErc223(address _erc223ContractAddress, address _to, uint256 _value) mutex public returns (bool ok) {
1198         uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc223ContractAddress)));
1199 
1200         require(balances[msg.sender][bip32X_type] >= _value);
1201 
1202         bytes memory empty;
1203 
1204         balances[msg.sender][bip32X_type] = balances[msg.sender][bip32X_type].sub(_value);
1205 
1206         bytes4 sig = bytes4(keccak256(abi.encodePacked("transfer(address,uint256,bytes)")));
1207         (bool success, ) = _erc223ContractAddress.call(abi.encodeWithSelector(sig, _to, _value, empty));
1208 
1209         IErc223ReceivingContract receiver = IErc223ReceivingContract(_erc223ContractAddress);
1210         bool fallbackSuccess = receiver.tokenFallback(msg.sender, _value, empty);
1211 
1212         if (fallbackSuccess == true && success == true) {
1213             emit EVT_TransferAndBurnBip32X_type(_erc223ContractAddress, msg.sender, _to, _value, bip32X_type);
1214 
1215             ok = true;
1216         } else {
1217             //@note: reverts since a transactional event has occurred.
1218             revert();
1219         }
1220     }
1221 
1222     //---------------- Shyft Token Transfer [Erc20] ----------------//
1223 
1224     /// @param _erc20ContractAddress The address of the ERC20 contract that
1225     /// @param _value The amount of tokens to transfer.
1226     /// @dev | Transfers assets from any Erc20 contract to a Bip32X type Shyft synthetic asset. Mints the current synthetic balance.
1227     /// @return ok returns true if the transaction completes, reverts if it does not
1228 
1229     function transferFromErc20Token(address _erc20ContractAddress, uint256 _value) mutex public returns (bool ok) {
1230         require(_erc20ContractAddress != address(this));
1231 
1232         // block transfers if the recipient only allows kyc input, check other factors
1233         require(onlyAcceptsKycInput[msg.sender] == false);
1234 
1235         IErc20 erc20Contract = IErc20(_erc20ContractAddress);
1236 
1237         if (erc20Contract.allowance(msg.sender, address(this)) >= _value) {
1238             bool transferFromResult = erc20Contract.transferFrom(msg.sender, address(this), _value);
1239 
1240             if (transferFromResult == true) {
1241                 //@note: using _erc20ContractAddress in the keccak hash since _erc20ContractAddress will be where
1242                 // the tokens are created and managed.
1243                 //
1244                 // thus, this fallback will not function properly with abstracted synthetics (including this contract)
1245                 // hence the initial require() check above to prevent this behaviour.
1246 
1247                 uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc20ContractAddress)));
1248                 balances[msg.sender][bip32X_type] = balances[msg.sender][bip32X_type].add(_value);
1249 
1250                 emit EVT_TransferAndMintBip32X_type(_erc20ContractAddress, msg.sender, _value, bip32X_type);
1251 
1252                 //transfer successful
1253                 ok = true;
1254             } else {
1255                 //@note: reverts since a transactional event has occurred.
1256                 revert();
1257             }
1258         } else {
1259             //not enough allowance
1260         }
1261     }
1262 
1263     /// @param _erc20ContractAddress The address of the ERC20 contract that
1264     /// @param _to The address of the recipient.
1265     /// @param _value The amount of tokens to transfer.
1266     /// @dev | Withdraws a Bip32X type Shyft synthetic asset into its origin ERC20 contract. Burns the current synthetic balance.
1267     ///      | Cannot withdraw Bip32X type into an incorrect destination contract (as the hash will not match).
1268     /// @return ok returns true if the transaction completes, reverts if it does not
1269 
1270     function withdrawTokenBip32X_typeToErc20(address _erc20ContractAddress, address _to, uint256 _value) mutex public returns (bool ok) {
1271         uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc20ContractAddress)));
1272 
1273         require(balances[msg.sender][bip32X_type] >= _value);
1274 
1275         balances[msg.sender][bip32X_type] = balances[msg.sender][bip32X_type].sub(_value);
1276 
1277         bytes4 sig = bytes4(keccak256(abi.encodePacked("transfer(address,uint256)")));
1278         (bool success, ) = _erc20ContractAddress.call(abi.encodeWithSelector(sig, _to, _value));
1279 
1280         if (success == true) {
1281             emit EVT_TransferAndBurnBip32X_type(_erc20ContractAddress, msg.sender, _to, _value, bip32X_type);
1282 
1283             ok = true;
1284         } else {
1285             //@note: reverts since a transactional event has occurred.
1286             revert();
1287         }
1288     }
1289 }