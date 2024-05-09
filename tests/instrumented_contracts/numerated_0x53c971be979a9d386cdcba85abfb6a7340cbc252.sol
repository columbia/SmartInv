1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //////////////////////////////////////////////////
5 //      ____               __  ___     __   __  //
6 //     / __/__  ___  ______\ \/ (_)__ / /__/ /  //
7 //    _\ \/ _ \/ _ \/ __/ -_)  / / -_) / _  /   //
8 //   /___/ .__/\___/_/  \__//_/_/\__/_/\_,_/    //
9 //      /_/                                     //
10 //                        by 0xInuarashi.eth    //
11 //////////////////////////////////////////////////
12 
13 // Open0x ECDSA 
14 library ECDSA {
15 
16     ///// Signer Address Recovery /////
17     
18     // In its pure form, address recovery requires the following parameters
19     // params: hash, v, r ,s
20 
21     // First, we define some standard checks
22     function checkValidityOf_s(bytes32 s) public pure returns (bool) {
23         if (uint256(s) > 
24             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
25             revert("recoverAddressFrom_hash_v_r_s: Invalid s value");
26         }
27         return true;
28     }
29     function checkValidityOf_v(uint8 v) public pure returns (bool) {
30         if (v != 27 && v != 28) {
31             revert("recoverAddressFrom_hash_v_r_s: Invalid v value");
32         }
33         return true;
34     }
35 
36     // Then, we first define the pure form of recovery.
37     function recoverAddressFrom_hash_v_r_s(bytes32 hash, uint8 v, bytes32 r,
38     bytes32 s) public pure returns (address) {
39         // First, we need to make sure that s and v are in correct ranges
40         require(checkValidityOf_s(s) && checkValidityOf_v(v));
41 
42         // call recovery using solidity's built-in ecrecover method
43         address _signer = ecrecover(hash, v, r, s);
44         
45         require(_signer != address(0),
46             "_signer == address(0)");
47 
48         return _signer;
49     }
50 
51     // There are also other ways to receive input without v, r, s values which
52     // you will need to parse the unsupported data to find v, r, s and then
53     // use those to call ecrecover.
54 
55     // For these, there are 2 other methods:
56     // 1. params: hash, r, vs
57     // 2. params: hash, signature
58 
59     // These then return the v, r, s values required to use recoverAddressFrom_hash_v_r_s
60 
61     // So, we will parse the first method to get v, r, s
62     function get_v_r_s_from_r_vs(bytes32 r, bytes32 vs) public pure 
63     returns (uint8, bytes32, bytes32) {
64         bytes32 s = vs & 
65             bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
66         
67         uint8 v = uint8((uint256(vs) >> 255) + 27);
68 
69         return (v, r, s);
70     }
71 
72     function get_v_r_s_from_signature(bytes memory signature) public pure 
73     returns (uint8, bytes32, bytes32) {
74         // signature.length can be 64 and 65. this depends on the method
75         // the standard is 65 bytes1, eip-2098 is 64 bytes1.
76         // so, we need to account for these differences
77 
78         // in the case that it is a standard 65 bytes1 signature
79         if (signature.length == 65) {
80             uint8 v;
81             bytes32 r;
82             bytes32 s;
83 
84             // assembly magic
85             assembly {
86                 r := mload(add(signature, 0x20))
87                 s := mload(add(signature, 0x40))
88                 v := byte(0, mload(add(signature, 0x60)))
89             }
90 
91             // return the v, r, s 
92             return (v, r, s);
93         }
94 
95         // in the case that it is eip-2098 64 bytes1 signature
96         else if (signature.length == 64) {
97             bytes32 r;
98             bytes32 vs;
99 
100             // assembly magic 
101             assembly {
102                 r := mload(add(signature, 0x20))
103                 vs := mload(add(signature, 0x40))
104             }
105 
106             return get_v_r_s_from_r_vs(r, vs);
107         }
108 
109         else {
110             revert("Invalid signature length");
111         }
112     }
113 
114     // ///// Embedded toString /////
115 
116     // // We need this in one of the methods of returning a signed message below.
117 
118     // function _toString(uint256 value_) internal pure returns (string memory) {
119     //     if (value_ == 0) { return "0"; }
120     //     uint256 _iterate = value_; uint256 _digits;
121     //     while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
122     //     bytes memory _buffer = new bytes(_digits);
123     //     while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
124     //         48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
125     //     return string(_buffer); // return string converted bytes of value_
126     // }
127 
128     // ///// Generation of Hashes /////
129     
130     // // We need these methods because these methods are used to compare
131     // // hash generated off-chain to hash generated on-chain to cross-check the
132     // // validity of the signatures
133 
134     // // 1. A bytes32 hash to generate a bytes32 hash embedded with prefix
135     // // 2. A bytes memory s to generate a bytes32 hash embedded with prefix
136     // // 3. A bytes32 domain seperator and bytes32 structhash to generate 
137     // //      a bytes32 hash embedded with prefix
138 
139     // // See: EIP-191
140     // function toEthSignedMessageHashBytes32(bytes32 hash) public pure 
141     // returns (bytes32) {
142     //     return keccak256(abi.encodePacked(
143     //         // Magic prefix determined by the devs
144     //         "\x19Ethereum Signed Message:\n32",
145     //         hash
146     //     ));
147     // }
148 
149     // // See: EIP-191
150     // function toEthSignedMessageHashBytes(bytes memory s) public pure
151     // returns (bytes32) {
152     //     return keccak256(abi.encodePacked(
153     //         // Another magic prefix determined by the devs
154     //         "\x19Ethereum Signed Message:\n", 
155     //         // The bytes length of s
156     //         _toString(s.length),
157     //         // s itself
158     //         s
159     //     ));
160     // }
161 
162     // // See: EIP-712
163     // function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) public
164     // pure returns (bytes32) {
165     //     return keccak256(abi.encodePacked(
166     //         // Yet another magic prefix determined by the devs
167     //         "\x19\x01",
168     //         // The domain seperator (EIP-712)
169     //         domainSeparator,
170     //         // struct hash
171     //         structHash
172     //     ));
173     // }
174 }
175 
176 abstract contract Ownable {
177     address public owner; 
178     constructor() { owner = msg.sender; }
179     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
180     function transferOwnership(address new_) external onlyOwner { owner = new_; }
181 }
182 
183 interface iSpore {
184     function transfer(address to_, uint256 amount_) external;
185     function mintAsController(address to_, uint256 amount_) external;
186 }
187 
188 interface iNFF {
189     function totalSupply() external view returns (uint256);
190     function balanceOf(address address_) external view returns (uint256);
191     function ownerOf(uint256 tokenId_) external view returns (address);
192     function walletOfOwner(address address_) external view returns (uint256[] memory);
193 
194     function transferFrom(address from_, address to_, uint256 tokenId_) external;
195 }
196 
197 
198 contract SporeYield is Ownable {
199 
200     // Events
201     event Claim(address to_, uint256[] indexes_, uint256 totalClaimed);
202 
203     // Interfaces
204     // NOTE: change this address (After spore token deployment)
205     iSpore public Spore = iSpore(0xD5E6d515b18004d0d4b2813078988cD67aDa6D7C); 
206     function setSpore(address address_) external onlyOwner { 
207         Spore = iSpore(address_); 
208     }
209 
210     iNFF public NFFGenerative = iNFF(0x90ee3Cf59FcDe2FE11838b9075Ea4681462362F1);
211     function setNFFGenerative(address address_) external onlyOwner {
212         NFFGenerative = iNFF(address_);
213     }
214 
215     iNFF public NFFGenesis = iNFF(0x5f47079D0E45d95f5d5167A480B695883C4E47D9);
216     function setNFFGenesis(address address_) external onlyOwner {
217         NFFGenesis = iNFF(address_);
218     }
219 
220     // // Constructor to set the contract addresses (optional)
221     // constructor(address spore, address generative, address genesis) Ownable() {
222     //     Spore = iSpore(spore);
223     //     NFFGenerative = iNFF(generative);
224     //     NFFGenesis = iNFF(genesis);
225     // }
226 
227     // Times
228     uint256 public yieldStartTime = 1653264000; // May 23 2022 14:00:00 GMT+0000
229     uint256 public yieldEndTime = 1732060800; // November 20 2024 14:00:00 GMT+0000
230     function setYieldEndTime(uint256 yieldEndTime_) external onlyOwner { 
231         yieldEndTime = yieldEndTime_; }
232 
233     // Yield Info
234     mapping(uint256 => uint256) public indexToYield;
235     
236     // @dev this is a function to override yield setting. use it with caution.
237     function O_setIndexToYields(uint256[] calldata tokenIds_,
238     uint256[] calldata yields_) external onlyOwner {
239         require(tokenIds_.length == yields_.length,
240             "Array lengths mismatch!");
241         
242         for (uint256 i = 0; i < tokenIds_.length; i++) {
243             indexToYield[tokenIds_[i]] = yields_[i];
244         }
245     }
246 
247     // Yield Database
248     mapping(uint256 => uint256) public indexToClaimedTimestamp;
249 
250     // // Timestamp Controller (Optional)
251 
252     // mapping(address => bool) public addressToTimestampControllers;
253 
254     // // Timestamp Controllers can be given externally to other addresses 
255     // // in order to modify the timestamp of mappings. 
256     // // Only use if you know what you are doing. 
257     // modifier onlyTimestampControllers {
258     //     require(addressToTimestampControllers[msg.sender],
259     //         "Invalid timestamp controller!");
260     //     _;
261     // }
262 
263     // function controllerSetClaimTimestamps(uint256[] memory indexes_, 
264     // uint256[] memory timestamps_) public onlyTimestampControllers {
265     //     for (uint256 i = 0; i < indexes_.length; i++) {
266     //         // The timestamp set must never be below the yieldStartTime
267     //         require(yieldStartTime <= timestamps_[i],
268     //             "Timestamp set below yieldStartTime!");
269 
270     //         indexToClaimedTimestamp[indexes_[i]] = timestamps_[i];
271     //     }
272     // }
273     // ////
274 
275     // Internal Calculators
276     function _getCurrentTimeOrEnded() public view returns (uint256) {
277         // Return block.timestamp if it's lower than yieldEndTime, otherwise
278         // return yieldEndTime instead.
279         return block.timestamp < yieldEndTime ?
280             block.timestamp : yieldEndTime;
281     }
282     function _getTimestampOfToken(uint256 index_) public view returns (uint256) {
283         // return indexToClaimedTimestamp[index_] == 0 ?
284 
285         // Adjusted to yieldStartTime and hardcoded to save gas
286         return indexToClaimedTimestamp[index_] < 1653264000 ?
287             yieldStartTime : indexToClaimedTimestamp[index_];
288     }
289 
290     // Yield Accountants
291     function getPendingTokens(uint256 index_) public view returns (uint256) {
292 
293         // First, grab the timestamp of the token
294         uint256 _lastClaimedTimestamp = _getTimestampOfToken(index_);
295 
296         // Then, we grab the current timestamp or ended
297         uint256 _timeCurrentOrEnded = _getCurrentTimeOrEnded();
298 
299         // Lastly, we calculate the time-units in seconds of elapsed time
300         uint256 _timeElapsed = _timeCurrentOrEnded - _lastClaimedTimestamp;
301 
302         // Now, return the calculation of yield
303         require(indexToYield[index_] != 0,
304             "Yield Lookup not Initialized!");
305         
306         return (_timeElapsed * indexToYield[index_]) / 1 days;
307     }
308     function getInitializedTokenYields(uint256[] memory indexes_) public
309     view returns (uint256[] memory) {
310         uint256[] memory _tokenYields = new uint256[](indexes_.length);
311         for (uint256 i = 0; i < indexes_.length; i++) {
312             _tokenYields[i] = indexToYield[indexes_[i]];
313         }
314         // Then, return the final value
315         return _tokenYields;
316     }
317     function getPendingTokensMany(uint256[] memory indexes_) public
318     view returns (uint256) {
319         // First, create an empty MSTORE to store the pending tokens tracker
320         uint256 _pendingTokens;
321         // Now, run a loop through the entire indexes array to add it
322         for (uint256 i = 0; i < indexes_.length; i++) {
323             _pendingTokens += getPendingTokens(indexes_[i]);
324         }
325 
326         // Then, return the final value
327         return _pendingTokens;
328     }
329 
330     function getPendingTokensWithUninitialized(uint256 index_, uint256 yieldRate_) public view returns (uint256) {
331 
332         // First, grab the timestamp of the token
333         uint256 _lastClaimedTimestamp = _getTimestampOfToken(index_);
334 
335         // Then, we grab the current timestamp or ended
336         uint256 _timeCurrentOrEnded = _getCurrentTimeOrEnded();
337 
338         // Lastly, we calculate the time-units in seconds of elapsed time
339         uint256 _timeElapsed = _timeCurrentOrEnded - _lastClaimedTimestamp;
340 
341         // Now, return the calculation of yield
342         return (_timeElapsed * yieldRate_) / 1 days;
343     }
344     function getPendingTokensManyWithUninitialized(uint256[] memory indexes_, uint256[] calldata yieldRates_) public
345     view returns (uint256) {
346         require(indexes_.length == yieldRates_.length);
347 
348         // First, create an empty MSTORE to store the pending tokens tracker
349         uint256 _pendingTokens;
350 
351         // Now, run a loop through the entire indexes array to add it
352         for (uint256 i = 0; i < indexes_.length; i++) {
353             _pendingTokens += getPendingTokensWithUninitialized(indexes_[i], yieldRates_[i]);
354         }
355 
356         // Then, return the final value
357         return _pendingTokens;
358     }
359 
360     // Internal Timekeepers
361     function _updateTimestampOfTokens(uint256[] memory indexes_) internal {
362         // Get the timestamp using internal function
363         uint256 _timeCurrentOrEnded = _getCurrentTimeOrEnded();
364         
365         // Loop through the entire indexes_ array and set the timestamps
366         for (uint256 i = 0; i < indexes_.length; i++) {
367             // Prevents duplicate setting of same token in the same block
368             require(indexToClaimedTimestamp[indexes_[i]] != _timeCurrentOrEnded,
369                 "Unable to set timestamp duplication in the same block!");
370 
371             indexToClaimedTimestamp[indexes_[i]] = _timeCurrentOrEnded;
372         }
373     }
374 
375     function getIndexOfTokens(address[] memory contracts_,
376     uint256[] memory tokenIds_) public view returns (uint256[] memory) {
377 
378         // Make sure the array lengths are equal
379         require(contracts_.length == tokenIds_.length,
380             "getIndexOfTokens(): Array lengths mismatch!");
381         
382         // MSTORE to save GAS
383         uint256 _items = tokenIds_.length;
384         address _NFFGenerativeAddress = address(NFFGenerative);
385         address _NFFGenesisAddress = address(NFFGenesis);
386 
387         // Make sure all items are of supported contracts
388         for (uint256 i = 0; i < _items; i++) {
389             require(contracts_[i] == _NFFGenerativeAddress ||
390                 contracts_[i] == _NFFGenesisAddress,
391                 "getIndexOfTokens(): Unsupported Contract!");
392         }
393         
394         // MSTORE _indexes to return
395         uint256[] memory _indexes = new uint256[](_items);
396 
397         // Generate the index array
398         for (uint256 i = 0; i < _items; i++) {
399             // Generate the offset. If generative, offeset is 10000, else, it's 0.
400             uint256 _offset = contracts_[i] == _NFFGenerativeAddress ? 0 : 10000;
401             _indexes[i] = tokenIds_[i] + _offset;
402         }
403 
404         // Return the _indexes array
405         return _indexes;
406     }
407 
408     function claim(uint256[] calldata tokenIds_) 
409     public returns (uint256) {
410         // Make sure the sender owns all the tokens
411         for (uint256 i = 0; i < tokenIds_.length; i++) {
412             if(tokenIds_[i] < 10000)
413             {
414                 require(msg.sender == NFFGenerative.ownerOf(tokenIds_[i]),
415                     "You do not own this token!");
416             }
417             else
418             {
419                 require(msg.sender == NFFGenesis.ownerOf(tokenIds_[i] - 10000),
420                     "You do not own this token!");
421             }
422         }
423 
424         // Calculate the total pending tokens to be claimed from index array
425         uint256 _pendingTokens = getPendingTokensMany(tokenIds_);
426 
427         // Set the new timestamp of the tokens
428         // @dev: this step will fail if duplicate tokenIds_ are passed in
429         _updateTimestampOfTokens(tokenIds_);
430 
431         // Mint the total tokens for the msg.sender
432         Spore.mintAsController(msg.sender, _pendingTokens);
433 
434         // Emit claim of total tokens
435         emit Claim(msg.sender, tokenIds_, _pendingTokens);
436 
437         // Return the claim amount
438         return _pendingTokens;
439     }
440 
441     // NOTE: change this to the correct spore data signer!
442     address public sporeDataSigner = 0xe4535f8EE9b374BBc2c5A57B35f09A89fe43a657; 
443 
444     function setSporeDataSigner(address address_) public onlyOwner {
445         sporeDataSigner = address_;
446     }
447 
448     // Data initializer controllers
449     mapping(address => bool) public addressToYieldDataInitializers;
450 
451     function setYieldDataInitializers(address[] calldata initializers_,
452     bool bool_) external onlyOwner {
453         for (uint256 i = 0; i < initializers_.length; i++) {
454             addressToYieldDataInitializers[initializers_[i]] = bool_;
455         }
456     }
457 
458     modifier onlyYieldDataInitializer {
459         require(addressToYieldDataInitializers[msg.sender],
460             "Invalid yield data initializer!");
461         _;
462     }
463 
464     function controllerInitializeYieldDatas(uint256[] memory indexes_, 
465     uint256[] memory yieldDatas_, bytes[] memory signatures_) public 
466     onlyYieldDataInitializer {
467         _initializeYieldDatas(indexes_, yieldDatas_, signatures_);
468     }
469     ////
470 
471     // Core initialization logic
472     function _initializeYieldDatas(uint256[] memory indexes_, 
473     uint256[] memory yieldDatas_, bytes[] memory signatures_) internal {
474         
475         // In order to effectively use this function, the index and yielddata
476         // array must be passed in as uninitialized-FIRST with signature
477         // length only in the amount of uninitialized yield datas.
478 
479         // The function itself supports input of both uninitialized and initialized
480         // tokens based on signature length.
481         
482         // Make sure all the indexes to yieldDatas is valid through ECDSA 
483         for (uint256 i = 0; i < signatures_.length; i++) {
484             // make sure the yieldDatas_[i] and signatures_[i] is correct
485             // thus we need to use get_v_r_s_from_signature function before
486             // address recovery
487             (uint8 v, bytes32 r, bytes32 s) = 
488                 ECDSA.get_v_r_s_from_signature(signatures_[i]);
489 
490             // Create the token data hash to use with ecrecover
491             bytes32 _tokenDataHash = keccak256(abi.encodePacked(
492                 indexes_[i],
493                 yieldDatas_[i]
494             ));
495 
496             require(sporeDataSigner == 
497                 ECDSA.recoverAddressFrom_hash_v_r_s(_tokenDataHash, v, r, s),
498                 "Invalid signer");
499 
500             // Initialize them if empty
501             if (indexToYield[indexes_[i]] == 0) { 
502                 // 10 Ether is the maximum per day as yield data is concerned.
503                 // We added leeway for 20 Ether in case any future changes.
504                 // We hardcoded this to save on gas.
505                 require(20 ether >= yieldDatas_[i],
506                     "Yield value not intended!");
507                 
508                 indexToYield[indexes_[i]] = yieldDatas_[i];
509             }
510         }
511     }
512 
513     function claimWithInitializable(  
514     uint256[] calldata tokenIds_, uint256[] calldata yieldDatas_,
515     bytes[] calldata signatures_) external returns (uint256) {
516         require(tokenIds_.length >= yieldDatas_.length &&
517             tokenIds_.length >= signatures_.length,
518             "Array Lengths Mismatch!");
519         for (uint256 i = 0; i < tokenIds_.length; i++) {
520             if(tokenIds_[i] < 10000)
521             {
522                 require(msg.sender == NFFGenerative.ownerOf(tokenIds_[i]),
523                     "You do not own this token!");
524             }
525             else
526             {
527                 require(msg.sender == NFFGenesis.ownerOf(tokenIds_[i] - 10000),
528                     "You do not own this token!");
529             }
530         }
531         // Initialize the Yield Datas
532         _initializeYieldDatas(tokenIds_, yieldDatas_, signatures_);
533 
534         // Calculate the total pending tokens to be claimed from index array
535         // Without _initializeYieldDatas, this function would revert.
536         uint256 _pendingTokens = getPendingTokensMany(tokenIds_);
537 
538         // Set the new timestamp of the tokens
539         // If there are duplicate indexes in the array, this function will revert.
540         _updateTimestampOfTokens(tokenIds_);
541 
542         // Mint the total tokens for the msg.sender
543         Spore.mintAsController(msg.sender, _pendingTokens);
544 
545         // Emit claim of total tokens
546         emit Claim(msg.sender, tokenIds_, _pendingTokens);
547 
548         // Return token amount
549         return _pendingTokens;
550     }
551 
552     // Public View Functions for Helpers
553     function walletOfGenesis(address address_) public view 
554     returns (uint256[] memory) {
555         return NFFGenesis.walletOfOwner(address_);
556     }
557     function walletOfGenerative(address address_) public view 
558     returns (uint256[] memory) {
559         return NFFGenerative.walletOfOwner(address_);
560     }
561 
562     function walletIndexOfOwner(address address_) public view 
563     returns (uint256[] memory) {
564         // For this function, we want to return a unified index 
565         uint256 _genesisBalance = NFFGenesis.balanceOf(address_);
566         uint256 _generativeBalance = NFFGenerative.balanceOf(address_);
567         uint256 _totalBalance = _genesisBalance + _generativeBalance;
568         
569         // Create the indexes based on a combined balance to input datas
570         uint256[] memory _indexes = new uint256[] (_totalBalance);
571 
572         // Call both wallet of owners
573         uint256[] memory _walletOfGenesis = walletOfGenesis(address_);
574         uint256[] memory _walletOfGenerative = walletOfGenerative(address_);
575 
576         // Now start inserting into the index with both wallets with offsets
577         uint256 _currentIndex;
578         for (uint256 i = 0; i < _walletOfGenerative.length; i++) {
579             // Generative has an offset of 0
580             _indexes[_currentIndex++] = _walletOfGenerative[i];
581         }
582         for (uint256 i = 0; i < _walletOfGenesis.length; i++) {
583             // Genesis has an offset of 10000
584             _indexes[_currentIndex++] = _walletOfGenesis[i] + 10000;
585         }
586 
587         return _indexes;
588     }
589 }