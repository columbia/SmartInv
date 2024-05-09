1 pragma solidity ^0.5.4;
2 
3 /**
4  * ERC20 contract interface.
5  */
6 contract ERC20 {
7     function totalSupply() public view returns (uint);
8     function decimals() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 }
15 
16 /**
17  * @title Module
18  * @dev Interface for a module. 
19  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
20  * can never end up in a "frozen" state.
21  * @author Julien Niset - <julien@argent.xyz>
22  */
23 interface Module {
24     function init(BaseWallet _wallet) external;
25     function addModule(BaseWallet _wallet, Module _module) external;
26     function recoverToken(address _token) external;
27 }
28 
29 /**
30  * @title BaseWallet
31  * @dev Simple modular wallet that authorises modules to call its invoke() method.
32  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
33  * @author Julien Niset - <julien@argent.xyz>
34  */
35 contract BaseWallet {
36     address public implementation;
37     address public owner;
38     mapping (address => bool) public authorised;
39     mapping (bytes4 => address) public enabled;
40     uint public modules;
41     function init(address _owner, address[] calldata _modules) external;
42     function authoriseModule(address _module, bool _value) external;
43     function enableStaticCall(address _module, bytes4 _method) external;
44     function setOwner(address _newOwner) external;
45     function invoke(address _target, uint _value, bytes calldata _data) external;
46     function() external payable;
47 }
48 
49 /**
50  * @title ModuleRegistry
51  * @dev Registry of authorised modules. 
52  * Modules must be registered before they can be authorised on a wallet.
53  * @author Julien Niset - <julien@argent.xyz>
54  */
55 contract ModuleRegistry {
56     function registerModule(address _module, bytes32 _name) external;
57     function deregisterModule(address _module) external;
58     function registerUpgrader(address _upgrader, bytes32 _name) external;
59     function deregisterUpgrader(address _upgrader) external;
60     function recoverToken(address _token) external;
61     function moduleInfo(address _module) external view returns (bytes32);
62     function upgraderInfo(address _upgrader) external view returns (bytes32);
63     function isRegisteredModule(address _module) external view returns (bool);
64     function isRegisteredModule(address[] calldata _modules) external view returns (bool);
65     function isRegisteredUpgrader(address _upgrader) external view returns (bool);
66 }
67 
68 /**
69  * @title GuardianStorage
70  * @dev Contract storing the state of wallets related to guardians and lock.
71  * The contract only defines basic setters and getters with no logic. Only modules authorised
72  * for a wallet can modify its state.
73  * @author Julien Niset - <julien@argent.xyz>
74  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
75  */
76 contract GuardianStorage {
77     function addGuardian(BaseWallet _wallet, address _guardian) external;
78     function revokeGuardian(BaseWallet _wallet, address _guardian) external;
79     function guardianCount(BaseWallet _wallet) external view returns (uint256);
80     function getGuardians(BaseWallet _wallet) external view returns (address[] memory);
81     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
82     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external;
83     function isLocked(BaseWallet _wallet) external view returns (bool);
84     function getLock(BaseWallet _wallet) external view returns (uint256);
85     function getLocker(BaseWallet _wallet) external view returns (address);
86 }
87 
88 /**
89  * @title BaseModule
90  * @dev Basic module that contains some methods common to all modules.
91  * @author Julien Niset - <julien@argent.im>
92  */
93 contract BaseModule is Module {
94 
95     // The adddress of the module registry.
96     ModuleRegistry internal registry;
97 
98     event ModuleCreated(bytes32 name);
99     event ModuleInitialised(address wallet);
100 
101     constructor(ModuleRegistry _registry, bytes32 _name) public {
102         registry = _registry;
103         emit ModuleCreated(_name);
104     }
105 
106     /**
107      * @dev Throws if the sender is not the target wallet of the call.
108      */
109     modifier onlyWallet(BaseWallet _wallet) {
110         require(msg.sender == address(_wallet), "BM: caller must be wallet");
111         _;
112     }
113 
114     /**
115      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
116      */
117     modifier onlyWalletOwner(BaseWallet _wallet) {
118         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
119         _;
120     }
121 
122     /**
123      * @dev Throws if the sender is not the owner of the target wallet.
124      */
125     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
126         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
127         _;
128     }
129 
130     /**
131      * @dev Inits the module for a wallet by logging an event.
132      * The method can only be called by the wallet itself.
133      * @param _wallet The wallet.
134      */
135     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
136         emit ModuleInitialised(address(_wallet));
137     }
138 
139     /**
140      * @dev Adds a module to a wallet. First checks that the module is registered.
141      * @param _wallet The target wallet.
142      * @param _module The modules to authorise.
143      */
144     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
145         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
146         _wallet.authoriseModule(address(_module), true);
147     }
148 
149     /**
150     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
151     * module by mistake and transfer them to the Module Registry. 
152     * @param _token The token to recover.
153     */
154     function recoverToken(address _token) external {
155         uint total = ERC20(_token).balanceOf(address(this));
156         ERC20(_token).transfer(address(registry), total);
157     }
158 
159     /**
160      * @dev Helper method to check if an address is the owner of a target wallet.
161      * @param _wallet The target wallet.
162      * @param _addr The address.
163      */
164     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
165         return _wallet.owner() == _addr;
166     }
167 }
168 
169 /**
170  * @title RelayerModule
171  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
172  * @author Julien Niset - <julien@argent.im>
173  */
174 contract RelayerModule is Module {
175 
176     uint256 constant internal BLOCKBOUND = 10000;
177 
178     mapping (address => RelayerConfig) public relayer; 
179 
180     struct RelayerConfig {
181         uint256 nonce;
182         mapping (bytes32 => bool) executedTx;
183     }
184 
185     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
186 
187     /**
188      * @dev Throws if the call did not go through the execute() method.
189      */
190     modifier onlyExecute {
191         require(msg.sender == address(this), "RM: must be called via execute()");
192         _;
193     }
194 
195     /* ***************** Abstract method ************************* */
196 
197     /**
198     * @dev Gets the number of valid signatures that must be provided to execute a
199     * specific relayed transaction.
200     * @param _wallet The target wallet.
201     * @param _data The data of the relayed transaction.
202     * @return The number of required signatures.
203     */
204     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
205 
206     /**
207     * @dev Validates the signatures provided with a relayed transaction.
208     * The method MUST throw if one or more signatures are not valid.
209     * @param _wallet The target wallet.
210     * @param _data The data of the relayed transaction.
211     * @param _signHash The signed hash representing the relayed transaction.
212     * @param _signatures The signatures as a concatenated byte array.
213     */
214     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
215 
216     /* ************************************************************ */
217 
218     /**
219     * @dev Executes a relayed transaction.
220     * @param _wallet The target wallet.
221     * @param _data The data for the relayed transaction
222     * @param _nonce The nonce used to prevent replay attacks.
223     * @param _signatures The signatures as a concatenated byte array.
224     * @param _gasPrice The gas price to use for the gas refund.
225     * @param _gasLimit The gas limit to use for the gas refund.
226     */
227     function execute(
228         BaseWallet _wallet,
229         bytes calldata _data, 
230         uint256 _nonce, 
231         bytes calldata _signatures, 
232         uint256 _gasPrice,
233         uint256 _gasLimit
234     )
235         external
236         returns (bool success)
237     {
238         uint startGas = gasleft();
239         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
240         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
241         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
242         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
243         if((requiredSignatures * 65) == _signatures.length) {
244             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
245                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
246                     // solium-disable-next-line security/no-call-value
247                     (success,) = address(this).call(_data);
248                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
249                 }
250             }
251         }
252         emit TransactionExecuted(address(_wallet), success, signHash); 
253     }
254 
255     /**
256     * @dev Gets the current nonce for a wallet.
257     * @param _wallet The target wallet.
258     */
259     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
260         return relayer[address(_wallet)].nonce;
261     }
262 
263     /**
264     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
265     * @param _from The starting address for the relayed transaction (should be the module)
266     * @param _to The destination address for the relayed transaction (should be the wallet)
267     * @param _value The value for the relayed transaction
268     * @param _data The data for the relayed transaction
269     * @param _nonce The nonce used to prevent replay attacks.
270     * @param _gasPrice The gas price to use for the gas refund.
271     * @param _gasLimit The gas limit to use for the gas refund.
272     */
273     function getSignHash(
274         address _from,
275         address _to, 
276         uint256 _value, 
277         bytes memory _data, 
278         uint256 _nonce,
279         uint256 _gasPrice,
280         uint256 _gasLimit
281     ) 
282         internal 
283         pure
284         returns (bytes32) 
285     {
286         return keccak256(
287             abi.encodePacked(
288                 "\x19Ethereum Signed Message:\n32",
289                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
290         ));
291     }
292 
293     /**
294     * @dev Checks if the relayed transaction is unique.
295     * @param _wallet The target wallet.
296     * @param _nonce The nonce
297     * @param _signHash The signed hash of the transaction
298     */
299     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
300         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
301             return false;
302         }
303         relayer[address(_wallet)].executedTx[_signHash] = true;
304         return true;
305     }
306 
307     /**
308     * @dev Checks that a nonce has the correct format and is valid. 
309     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
310     * @param _wallet The target wallet.
311     * @param _nonce The nonce
312     */
313     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
314         if(_nonce <= relayer[address(_wallet)].nonce) {
315             return false;
316         }   
317         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
318         if(nonceBlock > block.number + BLOCKBOUND) {
319             return false;
320         }
321         relayer[address(_wallet)].nonce = _nonce;
322         return true;    
323     }
324 
325     /**
326     * @dev Recovers the signer at a given position from a list of concatenated signatures.
327     * @param _signedHash The signed hash
328     * @param _signatures The concatenated signatures.
329     * @param _index The index of the signature to recover.
330     */
331     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
332         uint8 v;
333         bytes32 r;
334         bytes32 s;
335         // we jump 32 (0x20) as the first slot of bytes contains the length
336         // we jump 65 (0x41) per signature
337         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
338         // solium-disable-next-line security/no-inline-assembly
339         assembly {
340             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
341             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
342             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
343         }
344         require(v == 27 || v == 28); 
345         return ecrecover(_signedHash, v, r, s);
346     }
347 
348     /**
349     * @dev Refunds the gas used to the Relayer. 
350     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
351     * @param _wallet The target wallet.
352     * @param _gasUsed The gas used.
353     * @param _gasPrice The gas price for the refund.
354     * @param _gasLimit The gas limit for the refund.
355     * @param _signatures The number of signatures used in the call.
356     * @param _relayer The address of the Relayer.
357     */
358     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
359         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
360         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
361         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
362             if(_gasPrice > tx.gasprice) {
363                 amount = amount * tx.gasprice;
364             }
365             else {
366                 amount = amount * _gasPrice;
367             }
368             _wallet.invoke(_relayer, amount, "");
369         }
370     }
371 
372     /**
373     * @dev Returns false if the refund is expected to fail.
374     * @param _wallet The target wallet.
375     * @param _gasUsed The expected gas used.
376     * @param _gasPrice The expected gas price for the refund.
377     */
378     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
379         if(_gasPrice > 0 
380             && _signatures > 1 
381             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
382             return false;
383         }
384         return true;
385     }
386 
387     /**
388     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
389     * as the wallet passed as the input of the execute() method. 
390     @return false if the addresses are different.
391     */
392     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
393         require(_data.length >= 36, "RM: Invalid dataWallet");
394         address dataWallet;
395         // solium-disable-next-line security/no-inline-assembly
396         assembly {
397             //_data = {length:32}{sig:4}{_wallet:32}{...}
398             dataWallet := mload(add(_data, 0x24))
399         }
400         return dataWallet == _wallet;
401     }
402 
403     /**
404     * @dev Parses the data to extract the method signature. 
405     */
406     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
407         require(_data.length >= 4, "RM: Invalid functionPrefix");
408         // solium-disable-next-line security/no-inline-assembly
409         assembly {
410             prefix := mload(add(_data, 0x20))
411         }
412     }
413 }
414 
415 /**
416  * @title OnlyOwnerModule
417  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
418  * must be called with one signature frm the owner.
419  * @author Julien Niset - <julien@argent.im>
420  */
421 contract OnlyOwnerModule is BaseModule, RelayerModule {
422 
423     // *************** Implementation of RelayerModule methods ********************* //
424 
425     // Overrides to use the incremental nonce and save some gas
426     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
427         return checkAndUpdateNonce(_wallet, _nonce);
428     }
429 
430     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool) {
431         address signer = recoverSigner(_signHash, _signatures, 0);
432         return isOwner(_wallet, signer); // "OOM: signer must be owner"
433     }
434 
435     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256) {
436         return 1;
437     }
438 }
439 
440 /**
441  * @title NftTransfer
442  * @dev Module to transfer NFTs (ERC721),
443  * @author Olivier VDB - <olivier@argent.xyz>
444  */
445 contract NftTransfer is BaseModule, RelayerModule, OnlyOwnerModule {
446 
447     bytes32 constant NAME = "NftTransfer";
448 
449     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
450     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
451 
452     // The Guardian storage 
453     GuardianStorage public guardianStorage;
454     // The address of the CryptoKitties contract
455     address public ckAddress;
456 
457     // *************** Events *************************** //
458 
459     event NonFungibleTransfer(address indexed wallet, address indexed nftContract, uint256 indexed tokenId, address to, bytes data);    
460 
461     // *************** Modifiers *************************** //
462 
463     /**
464      * @dev Throws if the wallet is locked.
465      */
466     modifier onlyWhenUnlocked(BaseWallet _wallet) {
467         // solium-disable-next-line security/no-block-members
468         require(!guardianStorage.isLocked(_wallet), "NT: wallet must be unlocked");
469         _;
470     }
471 
472     // *************** Constructor ********************** //
473 
474     constructor(
475         ModuleRegistry _registry,
476         GuardianStorage _guardianStorage,
477         address _ckAddress
478     )
479         BaseModule(_registry, NAME)
480         public
481     {
482         guardianStorage = _guardianStorage;
483         ckAddress = _ckAddress;
484     }
485 
486     // *************** External/Public Functions ********************* //
487 
488     /**
489      * @dev Inits the module for a wallet by setting up the onERC721Received
490      * static call redirection from the wallet to the module.
491      * @param _wallet The target wallet.
492      */
493     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
494         _wallet.enableStaticCall(address(this), ERC721_RECEIVED);
495     }
496 
497     /**
498      * @notice Handle the receipt of an NFT
499      * @dev An ERC721 smart contract calls this function on the recipient contract
500      * after a `safeTransfer`. If the recipient is a BaseWallet, the call to onERC721Received 
501      * will be forwarded to the method onERC721Received of the present module. 
502      * @param operator The address which called `safeTransferFrom` function
503      * @param from The address which previously owned the token
504      * @param tokenId The NFT identifier which is being transferred
505      * @param data Additional data with no specified format
506      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
507      */
508     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
509         external 
510         returns (bytes4)
511     {
512         return ERC721_RECEIVED;
513     }
514 
515     /**
516     * @dev lets the owner transfer NFTs from a wallet.
517     * @param _wallet The target wallet.
518     * @param _nftContract The ERC721 address.
519     * @param _to The recipient.
520     * @param _tokenId The NFT id
521     * @param _safe Whether to execute a safe transfer or not
522     * @param _data The data to pass with the transfer.
523     */
524 function transferNFT(
525         BaseWallet _wallet,
526         address _nftContract,
527         address _to,
528         uint256 _tokenId,
529         bool _safe,
530         bytes calldata _data
531     )
532         external
533         onlyWalletOwner(_wallet)
534         onlyWhenUnlocked(_wallet)
535     {
536         bytes memory methodData;
537         if(_nftContract == ckAddress) {
538             methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _tokenId);
539         } else {
540            if(_safe) {
541                methodData = abi.encodeWithSignature(
542                    "safeTransferFrom(address,address,uint256,bytes)", address(_wallet), _to, _tokenId, _data);
543            } else {
544                require(isERC721(_nftContract, _tokenId), "NT: Non-compliant NFT contract");
545                methodData = abi.encodeWithSignature(
546                    "transferFrom(address,address,uint256)", address(_wallet), _to, _tokenId);
547            }
548         }
549         _wallet.invoke(_nftContract, 0, methodData);
550         emit NonFungibleTransfer(address(_wallet), _nftContract, _tokenId, _to, _data);
551     }
552 
553     // *************** Internal Functions ********************* //
554 
555     /**
556     * @dev Check whether a given contract complies with ERC721.
557     * @param _nftContract The contract to check.
558     * @param _tokenId The tokenId to use for the check.
559     * @return true if the contract is an ERC721, false otherwise.
560     */
561     function isERC721(address _nftContract, uint256 _tokenId) internal returns (bool) {
562         // solium-disable-next-line security/no-low-level-calls
563         (bool success, bytes memory result) = _nftContract.call(abi.encodeWithSignature('supportsInterface(bytes4)', 0x80ac58cd));
564         if(success && result[0] != 0x0) return true;
565 
566         // solium-disable-next-line security/no-low-level-calls
567         (success, result) = _nftContract.call(abi.encodeWithSignature('supportsInterface(bytes4)', 0x6466353c));
568         if(success && result[0] != 0x0) return true;
569 
570         // solium-disable-next-line security/no-low-level-calls
571         (success,) = _nftContract.call(abi.encodeWithSignature('ownerOf(uint256)', _tokenId));
572         return success;
573     }
574 
575 }