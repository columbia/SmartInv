1 pragma solidity ^0.4.25;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2019 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * ZeroPriceIndex - Management system for maintaining the trade prices of
9  *                  ERC tokens & collectibles listed within ZeroCache.
10  *
11  * Version 19.3.12
12  *
13  * https://d14na.org
14  * support@d14na.org
15  */
16 
17 
18 /*******************************************************************************
19  *
20  * SafeMath
21  */
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 /*******************************************************************************
43  *
44  * ERC Token Standard #20 Interface
45  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
46  */
47 contract ERC20Interface {
48     function totalSupply() public constant returns (uint);
49     function balanceOf(address tokenOwner) public constant returns (uint balance);
50     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
51     function transfer(address to, uint tokens) public returns (bool success);
52     function approve(address spender, uint tokens) public returns (bool success);
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 }
58 
59 
60 /*******************************************************************************
61  *
62  * ApproveAndCallFallBack
63  *
64  * Contract function to receive approval and execute function in one call
65  * (borrowed from MiniMeToken)
66  */
67 contract ApproveAndCallFallBack {
68     function approveAndCall(address spender, uint tokens, bytes data) public;
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 /*******************************************************************************
74  *
75  * Owned contract
76  */
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95 
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98 
99         emit OwnershipTransferred(owner, newOwner);
100 
101         owner = newOwner;
102 
103         newOwner = address(0);
104     }
105 }
106 
107 
108 /*******************************************************************************
109  * 
110  * Zer0netDb Interface
111  */
112 contract Zer0netDbInterface {
113     /* Interface getters. */
114     function getAddress(bytes32 _key) external view returns (address);
115     function getBool(bytes32 _key)    external view returns (bool);
116     function getBytes(bytes32 _key)   external view returns (bytes);
117     function getInt(bytes32 _key)     external view returns (int);
118     function getString(bytes32 _key)  external view returns (string);
119     function getUint(bytes32 _key)    external view returns (uint);
120 
121     /* Interface setters. */
122     function setAddress(bytes32 _key, address _value) external;
123     function setBool(bytes32 _key, bool _value) external;
124     function setBytes(bytes32 _key, bytes _value) external;
125     function setInt(bytes32 _key, int _value) external;
126     function setString(bytes32 _key, string _value) external;
127     function setUint(bytes32 _key, uint _value) external;
128 
129     /* Interface deletes. */
130     function deleteAddress(bytes32 _key) external;
131     function deleteBool(bytes32 _key) external;
132     function deleteBytes(bytes32 _key) external;
133     function deleteInt(bytes32 _key) external;
134     function deleteString(bytes32 _key) external;
135     function deleteUint(bytes32 _key) external;
136 }
137 
138 
139 /*******************************************************************************
140  *
141  * @notice Zero(Cache) Price Index
142  *
143  * @dev Manages the current trade prices of ZeroCache tokens.
144  */
145 contract ZeroPriceIndex is Owned {
146     using SafeMath for uint;
147 
148     /* Initialize predecessor contract. */
149     address private _predecessor;
150 
151     /* Initialize successor contract. */
152     address private _successor;
153     
154     /* Initialize revision number. */
155     uint private _revision;
156 
157     /* Initialize Zer0net Db contract. */
158     Zer0netDbInterface private _zer0netDb;
159 
160     /* Initialize price update notifications. */
161     event PriceUpdate(
162         bytes32 indexed dataId, 
163         uint value
164     );
165 
166     /* Initialize price list update notifications. */
167     event PriceListUpdate(
168         bytes32 indexed listId, 
169         bytes ipfsHash
170     );
171 
172     /**
173      * Set Zero(Cache) Price Index namespaces
174      * 
175      * NOTE: Keep all namespaces lowercase.
176      */
177     string private _NAMESPACE = 'zpi';
178 
179     /* Set Dai Stablecoin (trade pair) base. */
180     string private _TRADE_PAIR_BASE = 'DAI';
181 
182     /**
183      * Initialize Core Tokens
184      * 
185      * NOTE: All tokens are traded against DAI Stablecoin.
186      */
187     string[4] _CORE_TOKENS = [
188         '0GOLD',    // ZeroGold
189         '0xBTC',    // 0xBitcoin Token
190         'WBTC',     // Wrapped Bitcoin
191         'WETH'      // Wrapped Ether
192     ];
193 
194     /***************************************************************************
195      *
196      * Constructor
197      */
198     constructor() public {
199         /* Set predecessor address. */
200         _predecessor = 0x0;
201 
202         /* Verify predecessor address. */
203         if (_predecessor != 0x0) {
204             /* Retrieve the last revision number (if available). */
205             uint lastRevision = ZeroPriceIndex(_predecessor).getRevision();
206             
207             /* Set (current) revision number. */
208             _revision = lastRevision + 1;
209         }
210         
211         /* Initialize Zer0netDb (eternal) storage database contract. */
212         // NOTE We hard-code the address here, since it should never change.
213         _zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
214     }
215 
216     /**
217      * @dev Only allow access to an authorized Zer0net administrator.
218      */
219     modifier onlyAuthBy0Admin() {
220         /* Verify write access is only permitted to authorized accounts. */
221         require(_zer0netDb.getBool(keccak256(
222             abi.encodePacked(msg.sender, '.has.auth.for.zero.price.index'))) == true);
223 
224         _;      // function code is inserted here
225     }
226     
227     /**
228      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
229      */
230     function () public payable {
231         /* Cancel this transaction. */
232         revert('Oops! Direct payments are NOT permitted here.');
233     }
234 
235 
236     /***************************************************************************
237      * 
238      * GETTERS
239      * 
240      */
241 
242     /**
243      * Get Trade Price (Token)
244      * 
245      * NOTE: All trades are made against DAI stablecoin.
246      */
247     function tradePriceOf(
248         string _token
249     ) external view returns (uint price) {
250         /* Initailze hash. */
251         bytes32 hash = 0x0;
252         
253         /* Set hash. */
254         hash = keccak256(abi.encodePacked(
255             _NAMESPACE, '.', _token, '.', _TRADE_PAIR_BASE
256         ));
257 
258         /* Retrieve value from Zer0net Db. */
259         price = _zer0netDb.getUint(hash);
260     }
261 
262     /**
263      * Get Trade Price (Collectible)
264      * 
265      * NOTE: All trades are made against DAI stablecoin.
266      * 
267      * An up-to-date trade price index of the TOP 100 collectibles 
268      * listed in the ZeroCache.
269      * (the complete listing is available via IPFS, see below)
270      */
271     function tradePriceOf(
272         address _token,
273         uint _tokenId
274     ) external view returns (uint price) {
275         /* Initailze hash. */
276         bytes32 hash = 0x0;
277         
278         /* Set hash. */
279         hash = keccak256(abi.encodePacked(
280             _NAMESPACE, '.', _token, '.', _tokenId
281         ));
282 
283         /* Retrieve value from Zer0net Db. */
284         price = _zer0netDb.getUint(hash);
285     }
286 
287     /**
288      * Get Trade Price List(s)
289      * 
290      * An real-time trade price index of the ZeroCache TOP tokens:
291      *     1. ERC-20
292      *     2. ERC-721 (Collectible)
293      * 
294      * Also, returns the IPFS address(es) to complete 
295      * ERC-721 (Collectible) trade price histories.
296      * 
297      * Available Price List Ids [sha3 db keys]:
298      * (prefix = `zpi.ipfs.`)
299      *     1. ...total          [0xd7ea7671063c5fb2c6913499e32dc9fa57ebeaeaea57318fb1c5d85fc2b7bd9a]
300      *     2. ...erc20.total    [0xe2a4d3615b13317181f86cf96dd85e05c8b88398081afe4c28bb7a614cb15d0f]
301      *     3. ...erc20.top100   [0x6e06845611588cbefd856f969d489fd79dfc0f11bdd8b6c033a386ba5629c7e8]
302      *     4. ...erc20.top1000  [0xa591401b1b623d8a9e8e5807dbd9a79cd4ede4270274bbabc20b15415a9386e7]
303      *     5. ...erc721.total   [0xe6685143353a7b4ee6f59925a757017f2638c0ed4cb9376ec8e6e37b4995aed2]
304      *     6. ...erc721.top100  [0xe75054ff8b05a4e8ebaeca5b43579e9f59fb910b50615bd3f225a8fe8c8aea49]
305      *     7. ...erc721.top1000 [0xdae2a49474830953c576849e09151b23c15dd3f8c4e98fbcd27c13b9f5739930]
306      * 
307      * NOTE: All trades are made against DAI stablecoin.
308      */
309     function tradePriceList(
310         string _listId
311     ) external view returns (bytes ipfsHash) {
312         /* Initailze data id. */
313         bytes32 dataId = 0x0;
314         
315         /* Set hash. */
316         dataId = keccak256(abi.encodePacked(_NAMESPACE, '.ipfs.', _listId));
317 
318         /* Validate data id. */
319         if (dataId == 0x0) {
320             /* Default to `...total`. */
321             dataId = 0xd7ea7671063c5fb2c6913499e32dc9fa57ebeaeaea57318fb1c5d85fc2b7bd9a;
322         }
323         
324         /* Retrun IPFS hash. */
325         ipfsHash = _zer0netDb.getBytes(dataId);
326     }
327 
328     /**
329      * Trade Price Summary
330      * 
331      * Retrieves the trade prices for the TOP 100 tokens and collectibles.
332      * 
333      * NOTE: All trades are made against DAI stablecoin.
334      */
335     function tradePriceSummary(
336     ) external view returns (uint[4] summary) {
337         /* Initailze hash. */
338         bytes32 hash = 0x0;
339         
340         /* Set hash. */
341         hash = keccak256(abi.encodePacked(
342             _NAMESPACE, '.0GOLD.', _TRADE_PAIR_BASE
343         ));
344 
345         /* Retrieve value from Zer0net Db. */
346         summary[0] = _zer0netDb.getUint(hash);
347 
348         /* Set hash. */
349         hash = keccak256(abi.encodePacked(
350             _NAMESPACE, '.0xBTC.', _TRADE_PAIR_BASE
351         ));
352 
353         /* Retrieve value from Zer0net Db. */
354         summary[1] = _zer0netDb.getUint(hash);
355 
356         /* Set hash. */
357         hash = keccak256(abi.encodePacked(
358             _NAMESPACE, '.WBTC.', _TRADE_PAIR_BASE
359         ));
360 
361         /* Retrieve value from Zer0net Db. */
362         summary[2] = _zer0netDb.getUint(hash);
363 
364         /* Set hash. */
365         hash = keccak256(abi.encodePacked(
366             _NAMESPACE, '.WETH.', _TRADE_PAIR_BASE
367         ));
368 
369         /* Retrieve value from Zer0net Db. */
370         summary[3] = _zer0netDb.getUint(hash);
371     }
372 
373     /**
374      * Get Revision (Number)
375      */
376     function getRevision() public view returns (uint) {
377         return _revision;
378     }
379 
380     /**
381      * Get Predecessor (Address)
382      */
383     function getPredecessor() public view returns (address) {
384         return _predecessor;
385     }
386     
387     /**
388      * Get Successor (Address)
389      */
390     function getSuccessor() public view returns (address) {
391         return _successor;
392     }
393     
394 
395     /***************************************************************************
396      * 
397      * SETTERS
398      * 
399      */
400 
401     /**
402      * Set Trade Price (Token)
403      * 
404      * Keys for trade pairs are encoded using the 'exact' symbol,
405      * as listed in their respective contract:
406      * 
407      *     ZeroGold `zpi.0GOLD.DAI`
408      *     0x3cf0b17677519ce01176e2dde0338a4d8962be5853b2d83217cc99c527d5629a
409      * 
410      *     0xBitcoin Token `zpi.0xBTC.DAI`
411      *     0x9b7396ba7848459ddbaa41b35e502a95d1df654913a5b67c4e7870bd40064612
412      * 
413      *     Wrapped Ether `zpi.WBTC.DAI`
414      *     0x03f90c9c29c9a65eabac4ea5eb624068469de88b5b8557eae0c8778367e8dfae
415      * 
416      *     Wrapped Ether `zpi.WETH.DAI`
417      *     0xf2349fd68dcc221f5a12142038d2619c9f73c8e7e95afcd8e0bd5bcd33b291bb
418      * 
419      * NOTE: All trades are made against DAI stablecoin.
420      */
421     function setTradePrice(
422         string _token,
423         uint _value
424     ) onlyAuthBy0Admin external returns (bool success) {
425         /* Calculate data id. */
426         bytes32 dataId = keccak256(abi.encodePacked(
427             _NAMESPACE, '.', _token, '.', _TRADE_PAIR_BASE
428         ));
429 
430         /* Set value in Zer0net Db. */
431         _zer0netDb.setUint(dataId, _value);
432         
433         /* Broadcast event. */
434         emit PriceUpdate(dataId, _value);
435         
436         /* Return success. */
437         return true;
438     }
439     
440     /**
441      * Set Trade Price (Collectible)
442      * 
443      * NOTE: All trades are made against DAI stablecoin.
444      */
445     function setTradePrice(
446         address _token,
447         uint _tokenId,
448         uint _value
449     ) onlyAuthBy0Admin external returns (bool success) {
450         /* Calculate data id. */
451         bytes32 dataId = keccak256(abi.encodePacked(
452             _NAMESPACE, '.', _token, '.', _tokenId
453         ));
454 
455         /* Set value in Zer0net Db. */
456         _zer0netDb.setUint(dataId, _value);
457         
458         /* Broadcast event. */
459         emit PriceUpdate(dataId, _value);
460         
461         /* Return success. */
462         return true;
463     }
464     
465     /**
466      * Set Trade Price (IPFS) List
467      * 
468      * NOTE: All trades are made against DAI stablecoin.
469      */
470     function setTradePriceList(
471         string _listId,
472         bytes _ipfsHash
473     ) onlyAuthBy0Admin external returns (bool success) {
474         /* Initailze hash. */
475         bytes32 hash = 0x0;
476         
477         /* Set hash. */
478         hash = keccak256(abi.encodePacked(_NAMESPACE, '.ipfs.', _listId));
479         
480         /* Set value in Zer0net Db. */
481         _zer0netDb.setBytes(hash, _ipfsHash);
482         
483         /* Broadcast event. */
484         emit PriceListUpdate(hash, _ipfsHash);
485         
486         /* Return success. */
487         return true;
488     }
489     
490     /**
491      * Set Core Trade Prices
492      * 
493      * NOTE: All trades are made against DAI stablecoin.
494      * 
495      * NOTE: Use of `string[]` is still experimental, 
496      *       so we are required to `setCorePrices` by sending
497      *       `_values` in the proper format.
498      */
499     function setAllCoreTradePrices(
500         uint[] _values
501     ) onlyAuthBy0Admin external returns (bool success) {
502         /* Iterate Core Tokens for updating. */    
503         for (uint8 i = 0; i < _CORE_TOKENS.length; i++) {
504             /* Set data id. */
505             bytes32 dataId = keccak256(abi.encodePacked(
506                 _NAMESPACE, '.', _CORE_TOKENS[i], '.', _TRADE_PAIR_BASE
507             ));
508     
509             /* Set value in Zer0net Db. */
510             _zer0netDb.setUint(dataId, _values[i]);
511             
512             /* Broadcast event. */
513             emit PriceUpdate(dataId, _values[i]);
514         }
515         
516         /* Return success. */
517         return true;
518     }
519     
520     /**
521      * Set (Multiple) Trade Prices
522      * 
523      * This will be used for ERC-721 Collectible tokens.
524      * 
525      * NOTE: All trades are made against DAI stablecoin.
526      */
527     function setTokenTradePrices(
528         address[] _tokens,
529         uint[] _tokenIds,
530         uint[] _values
531     ) onlyAuthBy0Admin external returns (bool success) {
532         /* Iterate Core Tokens for updating. */    
533         for (uint i = 0; i < _tokens.length; i++) {
534             /* Set data id. */
535             bytes32 dataId = keccak256(abi.encodePacked(
536                 _NAMESPACE, '.', _tokens[i], '.', _tokenIds[i]
537             ));
538     
539             /* Set value in Zer0net Db. */
540             _zer0netDb.setUint(dataId, _values[i]);
541             
542             /* Broadcast event. */
543             emit PriceUpdate(dataId, _values[i]);
544         }
545         
546         /* Return success. */
547         return true;
548     }
549 
550     /**
551      * Set Successor
552      * 
553      * This is the contract address that replaced this current instnace.
554      */
555     function setSuccessor(
556         address _newSuccessor
557     ) onlyAuthBy0Admin external returns (bool success) {
558         /* Set successor contract. */
559         _successor = _newSuccessor;
560         
561         /* Return success. */
562         return true;
563     }
564 
565 
566     /***************************************************************************
567      * 
568      * INTERFACES
569      * 
570      */
571 
572     /**
573      * Supports Interface (EIP-165)
574      * 
575      * (see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md)
576      * 
577      * NOTE: Must support the following conditions:
578      *       1. (true) when interfaceID is 0x01ffc9a7 (EIP165 interface)
579      *       2. (false) when interfaceID is 0xffffffff
580      *       3. (true) for any other interfaceID this contract implements
581      *       4. (false) for any other interfaceID
582      */
583     function supportsInterface(
584         bytes4 _interfaceID
585     ) external pure returns (bool) {
586         /* Initialize constants. */
587         bytes4 InvalidId = 0xffffffff;
588         bytes4 ERC165Id = 0x01ffc9a7;
589 
590         /* Validate condition #2. */
591         if (_interfaceID == InvalidId) {
592             return false;
593         }
594 
595         /* Validate condition #1. */
596         if (_interfaceID == ERC165Id) {
597             return true;
598         }
599         
600         // TODO Add additional interfaces here.
601         
602         /* Return false (for condition #4). */
603         return false;
604     }
605 
606 
607     /***************************************************************************
608      * 
609      * UTILITIES
610      * 
611      */
612 
613     /**
614      * Transfer Any ERC20 Token
615      *
616      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
617      *
618      * @dev Provides an ERC20 interface, which allows for the recover
619      *      of any accidentally sent ERC20 tokens.
620      */
621     function transferAnyERC20Token(
622         address _tokenAddress, 
623         uint _tokens
624     ) public onlyOwner returns (bool success) {
625         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
626     }
627 }