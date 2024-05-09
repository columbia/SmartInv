1 pragma solidity ^0.4.25;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2019 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * ZeroCache - AmTrust (First Edition)
9  * 
10  *             -----------------------------------------------------------------
11  * 
12  *             !!! WARNING WARNING WARNING !!!
13  *             !!! THIS IS HIGHLY EXPERIMENTAL SOFTWARE !!!
14  *             !!! USE AT YOUR OWN RISK !!!
15  *             
16  *             -----------------------------------------------------------------
17  *             
18  *             Our team at D14na has been hard at work over the Crypto Winter;
19  *             and we are very proud to announce the premier release of a still
20  *             experimental, but really fun and social new way to "Do Crypto!"
21  * 
22  *             TL;DR
23  *             -----
24  * 
25  *             A meta-currency / smart wallet built for the purpose of promoting 
26  *             and supporting the core economic needs of the Zeronet community:
27  *                 1. Electronic Commerce
28  *                 2. Zite Monetization
29  *                 3. Wealth Management
30  * 
31  *             ALL transactions are guaranteed by Solidty contracts managed by a 
32  *             growing community of federated nodes.
33  * 
34  *             For more information, please visit: 
35  *             https://0net.io/zerocache.bit
36  *
37  * Version 19.2.21
38  *
39  * https://d14na.org
40  * support@d14na.org
41  */
42 
43 
44 /*******************************************************************************
45  *
46  * SafeMath
47  */
48 library SafeMath {
49     function add(uint a, uint b) internal pure returns (uint c) {
50         c = a + b;
51         require(c >= a);
52     }
53     function sub(uint a, uint b) internal pure returns (uint c) {
54         require(b <= a);
55         c = a - b;
56     }
57     function mul(uint a, uint b) internal pure returns (uint c) {
58         c = a * b;
59         require(a == 0 || c / a == b);
60     }
61     function div(uint a, uint b) internal pure returns (uint c) {
62         require(b > 0);
63         c = a / b;
64     }
65 }
66 
67 
68 /*******************************************************************************
69  *
70  * ECRecovery
71  *
72  * Contract function to validate signature of pre-approved token transfers.
73  * (borrowed from LavaWallet)
74  */
75 contract ECRecovery {
76     function recover(bytes32 hash, bytes sig) public pure returns (address);
77 }
78 
79 
80 /*******************************************************************************
81  *
82  * ERC Token Standard #20 Interface
83  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
84  */
85 contract ERC20Interface {
86     function totalSupply() public constant returns (uint);
87     function balanceOf(address tokenOwner) public constant returns (uint balance);
88     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
89     function transfer(address to, uint tokens) public returns (bool success);
90     function approve(address spender, uint tokens) public returns (bool success);
91     function transferFrom(address from, address to, uint tokens) public returns (bool success);
92 
93     event Transfer(address indexed from, address indexed to, uint tokens);
94     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
95 }
96 
97 
98 /*******************************************************************************
99  *
100  * ApproveAndCallFallBack
101  *
102  * Contract function to receive approval and execute function in one call
103  * (borrowed from MiniMeToken)
104  */
105 contract ApproveAndCallFallBack {
106     function approveAndCall(address spender, uint tokens, bytes data) public;
107     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
108 }
109 
110 
111 /*******************************************************************************
112  *
113  * Owned contract
114  */
115 contract Owned {
116     address public owner;
117     address public newOwner;
118 
119     event OwnershipTransferred(address indexed _from, address indexed _to);
120 
121     constructor() public {
122         owner = msg.sender;
123     }
124 
125     modifier onlyOwner {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     function transferOwnership(address _newOwner) public onlyOwner {
131         newOwner = _newOwner;
132     }
133 
134     function acceptOwnership() public {
135         require(msg.sender == newOwner);
136 
137         emit OwnershipTransferred(owner, newOwner);
138 
139         owner = newOwner;
140 
141         newOwner = address(0);
142     }
143 }
144 
145 
146 /*******************************************************************************
147  * 
148  * Zer0netDb Interface
149  */
150 contract Zer0netDbInterface {
151     /* Interface getters. */
152     function getAddress(bytes32 _key) external view returns (address);
153     function getBool(bytes32 _key)    external view returns (bool);
154     function getBytes(bytes32 _key)   external view returns (bytes);
155     function getInt(bytes32 _key)     external view returns (int);
156     function getString(bytes32 _key)  external view returns (string);
157     function getUint(bytes32 _key)    external view returns (uint);
158 
159     /* Interface setters. */
160     function setAddress(bytes32 _key, address _value) external;
161     function setBool(bytes32 _key, bool _value) external;
162     function setBytes(bytes32 _key, bytes _value) external;
163     function setInt(bytes32 _key, int _value) external;
164     function setString(bytes32 _key, string _value) external;
165     function setUint(bytes32 _key, uint _value) external;
166 
167     /* Interface deletes. */
168     function deleteAddress(bytes32 _key) external;
169     function deleteBool(bytes32 _key) external;
170     function deleteBytes(bytes32 _key) external;
171     function deleteInt(bytes32 _key) external;
172     function deleteString(bytes32 _key) external;
173     function deleteUint(bytes32 _key) external;
174 }
175 
176 
177 /*******************************************************************************
178  *
179  * Wrapped ETH (WETH) Interface
180  */
181 contract WETHInterface {
182     function() public payable;
183     function deposit() public payable ;
184     function withdraw(uint wad) public;
185     function totalSupply() public view returns (uint);
186     function approve(address guy, uint wad) public returns (bool);
187     function transfer(address dst, uint wad) public returns (bool);
188     function transferFrom(address src, address dst, uint wad) public returns (bool);
189 
190     event Approval(address indexed src, address indexed guy, uint wad);
191     event Transfer(address indexed src, address indexed dst, uint wad);
192     event Deposit(address indexed dst, uint wad);
193     event Withdrawal(address indexed src, uint wad);
194 }
195 
196 
197 /*******************************************************************************
198  *
199  * ERC-165 Interface
200  */
201 contract ERC165 {
202     function supportsInterface(bytes4 interfaceID) external view returns (bool);
203 }
204 
205 
206 /*******************************************************************************
207  *
208  * ERC-1155 Interface
209  */
210 // TODO Add interface functions
211 //      (see https://github.com/enjin/erc-1155/blob/master/contracts/IERC1155.sol)
212 //      (and https://blog.enjincoin.io/erc-1155-the-crypto-item-standard-ac9cf1c5a226)
213 
214 
215 /*******************************************************************************
216  *
217  * @notice ZeroCache DOES NOT HOLD ANY "OFFICIAL" AFFILIATION with ZeroNet Core,
218  *         ZeroNet.io nor any of its brands and affiliates.
219  *
220  *         ZeroCache IS THE "OFFICIAL" META-CURRENCY OF THE GROWING COMMUNITY
221  *         OF ZER0NET-SPONSORED PRODUCTS AND SERVICES.
222  *
223  * @dev In conjunction with the ZeroCache Daemon, this contract manages the
224  *      ability to dynamically allocate the assets of a "smart" crypto wallet,
225  *      in real-time, based on a user's pre-selected financial profile.
226  *
227  *      Initial support for the following cryptos:
228  *          - Ethereum (WETH)   : HODL as a long-term growth investment.
229  *          - MakerDAO (DAI)    : SPEDN on digital goods and services.
230  *          - ZeroGold (0GOLD)  : STAEK to access premium features and services.
231  */
232 contract ZeroCache is Owned {
233     using SafeMath for uint;
234 
235     /* Initialize predecessor contract. */
236     address private _predecessor;
237 
238     /* Initialize successor contract. */
239     address private _successor;
240     
241     /* Initialize revision number. */
242     uint private _revision;
243 
244     /* Initialize Zer0net Db contract. */
245     Zer0netDbInterface private _zer0netDb;
246 
247     /* Initialize account balances. */
248     mapping(address => mapping (address => uint)) private _balances;
249 
250     /* Initialize expired signature flags. */
251     mapping(bytes32 => bool) private _expiredSignatures;
252     
253     /* Initialize revision depth. */
254     // NOTE: Allows for balance and transaction aggregation
255     //       from legacy ZeroCache contract instance(s).
256     // FIXME Determine the MAXIMUM depth and set here.
257     //       Estimated to be between 100-200
258     uint private _MAX_REVISION_DEPTH = 0;
259     
260     event Deposit(
261         address indexed token, 
262         address owner, 
263         uint tokens,
264         bytes data
265     );
266 
267     event Migrate(
268         address indexed token, 
269         address owner, 
270         uint tokens
271     );
272 
273     event Skipped(
274         address sender, 
275         address receiver, 
276         address token,
277         uint tokens
278     );
279 
280     event Staek(
281         address sender, 
282         address staekholder, 
283         uint tokens
284     );
285 
286     event Transfer(
287         address indexed token, 
288         address sender, 
289         address receiver, 
290         uint tokens
291     );
292 
293     event Withdraw(
294         address indexed token, 
295         address owner, 
296         uint tokens
297     );
298     
299     /***************************************************************************
300      *
301      * Constructor
302      */
303     constructor() public {
304         /* Set predecessor address. */
305         _predecessor = 0x0;
306 
307         /* Verify predecessor address. */
308         if (_predecessor != 0x0) {
309             /* Retrieve the last revision number (if available). */
310             uint lastRevision = ZeroCache(_predecessor).getRevision();
311             
312             /* Set (current) revision number. */
313             _revision = lastRevision + 1;
314         }
315         
316         /* Initialize Zer0netDb (eternal) storage database contract. */
317         // NOTE We hard-code the address here, since it should never change.
318         _zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
319     }
320 
321     /**
322      * @dev Only allow access to an authorized Zer0net administrator.
323      */
324     modifier onlyAuthBy0Admin() {
325         /* Verify write access is only permitted to authorized accounts. */
326         require(_zer0netDb.getBool(keccak256(
327             abi.encodePacked(msg.sender, '.has.auth.for.zerocache'))) == true);
328 
329         _;      // function code is inserted here
330     }
331 
332     /**
333      * Fallback (default)
334      * 
335      * Accepts direct ETH transfers to be wrapped for owner into one of the
336      * canonical Wrapped ETH (WETH) contracts:
337      *     - Mainnet : 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
338      *     - Ropsten : 0xc778417E063141139Fce010982780140Aa0cD5Ab
339      *     - Kovan   : 0xd0A1E359811322d97991E03f863a0C30C2cF029C
340      *     - Rinkeby : 0xc778417E063141139Fce010982780140Aa0cD5Ab
341      * (source https://blog.0xproject.com/canonical-weth-a9aa7d0279dd)
342      * 
343      * NOTE: We are forced to hard-code all possible network contract
344      *       (addresses) into this fallback since the WETH contract 
345      *       DOES NOT provide enough gas for us to lookup the 
346      *       specific address for our network.
347      * 
348      * NOTE: This contract requires ~50k gas to wrap ETH using the 
349      *       fallback/wrap functions. However, it will require ~80k 
350      *       to initialize on first-use.
351      */
352     function () public payable {
353         /* Initialize WETH contract flag. */
354         bool isWethContract = false;
355         
356         /* Initialize WETH contracts array. */
357         address[4] memory contracts;
358         
359         /* Set Mainnet. */
360         contracts[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
361 
362         /* Set Ropsten. */
363         contracts[1] = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
364 
365         /* Set Kovan. */
366         contracts[2] = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
367 
368         /* Set Rinkeby. */
369         contracts[3] = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
370         
371         /* Loop through all network contracts. */
372         for (uint i = 0; i < contracts.length; i++) {
373             /* Validate sender. */
374             if (msg.sender == contracts[i]) {
375                 /* Set flag. */
376                 isWethContract = true;
377             }
378         }
379 
380         /* DO NOT (re-)wrap incoming ETH from Wrapped ETH contract. */
381         if (!isWethContract) {
382             _wrap(msg.sender);
383         }
384     }
385 
386 
387     /***************************************************************************
388      * 
389      * ACTIONS
390      * 
391      */
392 
393     /**
394      * Wrap
395      */
396     function wrap() external payable returns (bool success) {
397         /* Return wrap success. */
398         return _wrap(msg.sender);
399     }
400     
401     /**
402      * Wrap
403      * 
404      * NOTE: This function is primarily used to support instance 
405      *       migration(s) of WETH.
406      */
407     function wrap(
408         address _owner
409     ) external payable returns (bool success) {
410         return _wrap(_owner);
411     }
412 
413     /**
414      * Wrap
415      * 
416      * Send Ether into this method. It gets wrapped and then deposited 
417      * in this contract as a token balance assigned to the sender.
418      */
419     function _wrap(
420         address _owner
421     ) private returns (bool success) {
422         /* Set WETH address. */
423         address wethAddress = _weth();
424 
425         /* Forward this payable ether into the wrapping contract. */
426         // NOTE: Transfer ETH before balance credit to prevent re-entry attack.
427         success = wethAddress.call
428             .gas(200000)
429             .value(msg.value)
430             (abi.encodeWithSignature("deposit()"));
431             
432         /* Validate transfer. */
433         if (success) {
434             /* Increase WETH balance by sent value. */
435             _balances[wethAddress][_owner] = 
436                 _balances[wethAddress][_owner].add(msg.value);
437             
438             /* Initialize empty data (for event log). */
439             bytes memory data;
440     
441             /* Broadcast event. */
442             emit Deposit(
443                 wethAddress, 
444                 _owner, 
445                 msg.value, 
446                 data
447             );
448         } else {
449             /* Report error. */
450             revert('An error occurred while wrapping your ETH.');
451         }
452     }
453 
454     /**
455      * Unwrap
456      */
457     function unwrap(
458         uint _tokens
459     ) public returns (bool success) {
460         return _unwrap(msg.sender, _tokens);
461     }
462 
463     /**
464      * Unwrap
465      * 
466      * We allow administrative unwrapping of WETH held
467      * in the ZeroCache, FOR COMPLIANCE PURPOSES ONLY.
468      * 
469      * NOTE: This function is reserved for exclusive use by
470      *       Zer0net Administration ONLY.
471      * 
472      *       Tokens unwrapped by an administrator can
473      *       ONLY be transferred to the ORIGINAL owner.
474      */
475     function unwrap(
476         address _owner, 
477         uint _tokens
478     ) onlyAuthBy0Admin external returns (bool success) {
479         return _unwrap(_owner, _tokens);
480     }
481 
482     /**
483      * Unwrap
484      * 
485      * Allows an owner to unwrap their Ether from the 
486      * canonical WETH contract.
487      */
488     function _unwrap(
489         address _owner, 
490         uint _tokens
491     ) private returns (bool success) {
492         /* Set WETH address. */
493         address wethAddress = _weth();
494 
495         /* Validate balance. */
496         if (_balances[wethAddress][_owner] < _tokens) {
497             revert('Oops! You DO NOT have enough WETH.');
498         }
499 
500         /* Decrease WETH balance by sent value. */
501         // NOTE: Decrease balance before transfer to prevent re-entry attack.
502         _balances[wethAddress][_owner] = 
503             _balances[wethAddress][_owner].sub(_tokens);
504 
505         /* Withdraw ETH from Wrapper contract. */
506         success = wethAddress.call
507             .gas(200000)
508             (abi.encodeWithSignature("withdraw(uint256)", _tokens));
509 
510         /* Validate withdrawal. */
511         if (success) {
512             /* Transfer "unwrapped" Ether (ETH) back to owner. */
513             _owner.transfer(_tokens);
514     
515             /* Broadcast event. */
516             emit Withdraw(
517                 wethAddress,
518                 _owner,
519                 _tokens
520             );
521         } else {
522             /* Report error. */
523             revert('An error occurred while unwrapping your ETH.');
524         }
525     }
526     
527     /**
528      * Deposit
529      * 
530      * Provides support for "pre-approved" token deposits.
531      * 
532      * NOTE: Required pre-allowance/approval is required in order
533      *       to successfully complete the transfer.
534      */
535     function deposit(
536         address _token, 
537         address _from, 
538         uint _tokens, 
539         bytes _data
540     ) external returns (bool success) {
541         /* Make deposit. */
542         return _deposit(_token, _from, _tokens, _data);
543     }
544 
545     /**
546      * Receive Approval
547      * 
548      * Will typically be called from `approveAndCall`.
549      * 
550      * NOTE: Owner can assign ANY address to receive the deposit 
551      *       (including their own). By default, owner will be used.
552      */
553     function receiveApproval(
554         address _from, 
555         uint _tokens, 
556         address _token, 
557         bytes _data
558     ) public returns (bool success) {
559         /* Make deposit. */
560         return _deposit(_token, _from, _tokens, _data);
561     }
562 
563     /**
564      * Deposit
565      * 
566      * Deposits ANY ERC20-compatible token into this contract;
567      * to be managed as ZeroCache. 
568      * 
569      * NOTE: Owners maintain 100% control* of their token(s) 
570      *       at all times.
571      * 
572      *       * Administrators have the ability to return tokens
573      *         back to their ORIGINAL owners AT ANY TIME.
574      *         FOR COMPLIANCE PURPOSES ONLY
575      */
576     function _deposit(
577         address _token,
578         address _from, 
579         uint _tokens,
580         bytes _data
581     ) private returns (bool success) {
582         /* Transfer the ERC-20 tokens into Cache. */
583         // NOTE: Transfer tokens before credit to prevent re-entry attack.
584         ERC20Interface(_token).transferFrom(
585             _from, address(this), _tokens);
586         
587         /* Initialize receiver (address). */
588         address receiver = 0x0;
589         
590         /**
591          * If `_data` is an `address`, then set the value to `receiver`.
592          * e.g. when `approveAndCall` is made from a contract 
593          * (representing the owner).
594          */
595         if (_data.length == 20) {
596             /* Retrieve the receiver's address from `data` payload. */
597             receiver = _bytesToAddress(_data);
598         } else {
599             /* Set receiver to `from` (also the token owner). */
600             receiver = _from;
601         }
602 
603         /* Increase receiver balance. */
604         _balances[_token][receiver] = 
605             _balances[_token][receiver].add(_tokens);
606 
607         /* Broadcast event. */
608         emit Deposit(_token, receiver, _tokens, _data);
609 
610         /* Return success. */
611         return true;
612     }
613 
614     /**
615      * Withdraw
616      */
617     function withdraw(
618         address _token, 
619         uint _tokens
620     ) public returns (bool success) {
621         return _withdraw(msg.sender, _token, _tokens);
622     }
623     
624     /**
625      * Withdraw
626      * 
627      * We allow administrative withdrawls of tokens held
628      * in the ZeroCache, FOR COMPLIANCE PURPOSES ONLY.
629      * 
630      * NOTE: This function is reserved for exclusive use by
631      *       Zer0net Administration ONLY.
632      * 
633      *       Tokens withdrawn by an administrator can
634      *       ONLY be transferred to the ORIGINAL owner.
635      */
636     function withdraw(
637         address _owner, 
638         address _token, 
639         uint _tokens
640     ) onlyAuthBy0Admin external returns (bool success) {
641         return _withdraw(_owner, _token, _tokens);
642     }
643 
644     /**
645      * Withdraw
646      * 
647      * Allows the withdrawl of tokens held in the ZeroCache
648      * back to the ORIGINAL owner.
649      */
650     function _withdraw(
651         address _owner, 
652         address _token, 
653         uint _tokens
654     ) private returns (bool success) {
655         /* Validate balance. */
656         if (_balances[_token][_owner] < _tokens) {
657             revert('Oops! You DO NOT have enough tokens.');
658         }
659 
660         /* Decrease owner balance by token amount. */
661         // NOTE: Decrease balance before transfer to prevent re-entry attack.
662         _balances[_token][_owner] = 
663             _balances[_token][_owner].sub(_tokens);
664 
665         /* Transfer requested tokens to owner. */
666         ERC20Interface(_token).transfer(_owner, _tokens);
667 
668         /* Broadcast event. */
669         emit Withdraw(_token, _owner, _tokens);
670     
671         /* Return success. */
672         return true;
673     }
674 
675     /**
676      * Transfer
677      *
678      * Transfers the "specified" ERC-20 tokens held by the sender
679      * to the receiver's account.
680      */
681     function transfer(
682         address _to,
683         address _token,
684         uint _tokens
685     ) external returns (bool success) {
686         return _transfer(
687             msg.sender, _to, _token, _tokens);
688     }
689 
690     /**
691      * (Relayed) Transfer
692      * 
693      * This transfer requires an off-chain (EC) signature, from the 
694      * account holder, detailing the transaction.
695      * 
696      * Staekholder
697      * -----------
698      * 
699      * Users may choose to boost the speed of execution for their 
700      * transfer request, decreasing the delivery time to near instant 
701      * (highest priority for miners to process) confirmation. 
702      * 
703      * A staek of ZeroGold is required to be added to the request, 
704      * in an amount specified by your preferred staekholder.
705      * 
706      * This staek is 100% optional, as Standard Delivery will be 
707      * FREE FOREVER!
708      * 
709      * TODO: Let's implement GasToken to provide staekholders an opportunity
710      *       to hedge against the volatility of future gas prices.
711      *       (source: https://gastoken.io/)
712      */
713     function transfer(
714         address _token,       // contract address
715         address _from,        // sender's address
716         address _to,          // receiver's address
717         uint _tokens,         // quantity of tokens
718         address _staekholder, // staekholder
719         uint _staek,          // staek amount
720         uint _expires,        // expiration time
721         uint _nonce,          // unique integer
722         bytes _signature      // signed message
723     ) external returns (bool success) {
724         /* Calculate transfer hash. */
725         bytes32 transferHash = keccak256(abi.encodePacked(
726             address(this), 
727             _token, 
728             _from,
729             _to,
730             _tokens,
731             _staekholder,
732             _staek,
733             _expires,
734             _nonce
735         ));
736 
737         /* Validate request has authorized signature. */
738         bool requestHasAuthSig = _requestHasAuthSig(
739             _from,
740             transferHash,
741             _expires,
742             _signature
743         );
744         
745         /* Validate authorization. */
746         if (!requestHasAuthSig) {
747             revert('Oops! This relay request is NOT valid.');
748         }
749         
750         /* Validate boost fee and pay (if necessary). */
751         if (_staekholder != 0x0 && _staek > 0) {
752             _addStaek(_from, _staekholder, _staek);
753         }
754 
755         /* Request token transfer. */
756         return _transfer(
757             _from, _to, _token, _tokens);
758     }
759 
760     /**
761      * Transfer
762      *
763      * Transfers the "specified" ERC-20 token(s) held by the sender
764      * to the receiver's account.
765      */
766     function _transfer(
767         address _from,
768         address _to,
769         address _token,
770         uint _tokens
771     ) private returns (bool success) {
772         /* Validate balance. */
773         if (_balances[_token][_from] < _tokens) {
774             revert('Oops! You DO NOT have enough tokens.');
775         }
776 
777         /* Remove the transfer value from sender's balance. */
778         // NOTE: We decrease balance before adding to prevent re-entry attack.
779         _balances[_token][_from] = _balances[_token][_from].sub(_tokens);
780 
781         /* Add the transfer value to the receiver's balance. */
782         _balances[_token][_to] = _balances[_token][_to].add(_tokens);
783 
784         /* Broadcast event. */
785         emit Transfer(
786             _token, 
787             _from, 
788             _to, 
789             _tokens
790         );
791 
792         /* Return success. */
793         return true;
794     }
795     
796     /**
797      * Multi Transfer
798      *
799      * Transfers multiple ERC-20 tokens held by the sender
800      * to multiple receiver accounts.
801      */
802     function multiTransfer(
803         address[] _to,
804         address[] _token,
805         uint[] _tokens
806     ) external returns (bool success) {
807         return _multiTransfer(msg.sender, _to, _token, _tokens);
808     }
809     
810     //----------------------------------------------------------------
811     //----------------------------------------------------------------
812     // NOTE: We DO NOT yet offer support for RELAYED Multi Transfers.
813     //----------------------------------------------------------------
814     //----------------------------------------------------------------
815 
816     /**
817      * Transfer Multiple Tokens (w/ Single Transaction)
818      * 
819      * WARNING: Sending to multiple receipients is very risky,
820      *          as there is NO way to control the gas costs per
821      *          transaction (ie. contract addresses are limitless).
822      * 
823      *          For this reason, we SKIP ALL transfers to contract
824      *          addresses. You can monitor the `Skipped` event.
825      */
826     function _multiTransfer(
827         address _from,
828         address[] _to,
829         address[] _token,
830         uint[] _tokens
831     ) private returns (bool success) {
832         /* Loop through all receivers. */
833         for (uint i = 0; i < _to.length; i++) {
834             /* Set token. */
835             address token = _token[i];
836            
837             /* Set token value. */
838             uint tokens = _tokens[i];
839            
840             /* Set receiver. */
841             address to = _to[i];
842             
843             /* Validate receiver address. */
844             if (_ownerIsContract(to)) {
845                 /* Broadcast event. */
846                 emit Skipped(_from, to, token, tokens);
847             } else {
848                 /* Transfer tokens. */
849                 _transfer(
850                     _from, to, token, tokens);
851             }
852         }
853         
854         /* Return success. */
855         return true;
856     }
857 
858     /**
859      * Add Staek (to Relay Transfer)
860      *
861      * This is an (optional) staek provided by the sender, which 
862      * transfers ZeroGold from the sender's account to the specified 
863      * staekholder account.
864      * 
865      * NOTE: Staek is only a temporary hold, until fees are collected
866      *       by the sender's preferred staekholder.
867      */
868     function _addStaek(
869         address _owner,
870         address _staekholder,
871         uint _tokens
872     ) private returns (bool success) {
873         /* Set ZeroGold address. */
874         address zgAddress = _zeroGold();
875 
876         /* Validate available balance. */
877         if (_balances[zgAddress][_owner] < _tokens) {
878             revert('Oops! You DO NOT have enough ZeroGold to staek.');
879         }
880 
881         /* Decrease owner balance by token amount. */
882         // NOTE: Decrease balance before transfer to prevent re-entry attack.
883         _balances[zgAddress][_owner] = 
884             _balances[zgAddress][_owner].sub(_tokens);
885 
886         /* Transfer specified tokens to staekholder account. */
887         _zeroGold().transfer(_staekholder, _tokens);
888 
889         /* Broadcast event. */
890         emit Staek(
891             _owner, 
892             _staekholder, 
893             _tokens
894         );
895 
896         /* Return success. */
897         return true;
898     }
899 
900     /**
901      * Cancel
902      *
903      * Cancels a previously authorized/signed transfer request, 
904      * by invalidating the signature on-chain.
905      */
906     function cancel(
907         address _token,       // contract address
908         address _from,        // sender's address
909         address _to,          // receiver's address
910         uint _tokens,         // quantity of tokens
911         address _staekholder, // staekholder
912         uint _staek,          // staek amount
913         uint _expires,        // expiration time
914         uint _nonce,          // unique integer
915         bytes _signature      // signed message
916     ) external returns (bool success) {
917         /* Calculate cancel hash. */
918         bytes32 cancelHash = keccak256(abi.encodePacked(
919             address(this), 
920             _token, 
921             _from,
922             _to,
923             _tokens,
924             _staekholder,
925             _staek,
926             _expires,
927             _nonce
928         ));
929 
930         /* Validate request has authorized signature. */
931         bool requestHasAuthSig = _requestHasAuthSig(
932             _from,
933             cancelHash,
934             _expires,
935             _signature
936         );
937         
938         /* Validate authorization. */
939         if (!requestHasAuthSig) {
940             revert('Oops! This cancel request is NOT valid.');
941         }
942         
943         /* Return success. */
944         return true;
945     }
946 
947     /**
948      * Migrate
949      */
950     function migrate(
951         address[] _tokens
952     ) external returns (bool success) {
953         return _migrate(msg.sender, _tokens);
954     }
955     
956     /**
957      * Migrate
958      * 
959      * THIS FUNCTION IS UN-IMPLMENTED
960      * 
961      * NOTE: There is no ADMIN migration function available
962      *       as a protection against UNAUTHORIZED transfer(s) to 
963      *       possible rogue instance(s) of ZeroCache.
964      */
965 
966     /**
967      * Migrate
968      * 
969      * Allows for the full balance transfer of a multiple token(s)
970      * from legacy instance(s) to the LATEST instance of ZeroCache.
971      */
972     function _migrate(
973         address _owner, 
974         address[] _tokens
975     ) private returns (bool success) {
976         /* Set hash. */
977         bytes32 hash = keccak256('aname.zerocache');
978 
979         /* Retrieve value from Zer0net Db. */
980         address latestCache = _zer0netDb.getAddress(hash);
981 
982         /* Loop through all tokens. */
983         for (uint i = 0; i < _tokens.length; i++) {
984             /* Set token. */
985             address token = _tokens[i];
986             
987             /* Retrieve balance. */
988             // NOTE: Explicitly set depth to `0`, to retrieve the
989             //       balance for ONLY this instance.
990             uint balance = balanceOf(token, _owner, 0);
991             
992             /* Decrease owner balance to ZERO. */
993             // NOTE: Balance is ZEROED here to prevent re-entry attack.
994             _balances[token][_owner] = 0;
995 
996             /* Validate WETH contract (requires `unwrap`). */
997             if (token == address(_weth())) {
998                 /* Set WETH address. */
999                 address wethAddress = _weth();
1000         
1001                 /* Withdraw ETH from Wrapper contract. */
1002                 success = wethAddress.call
1003                     .gas(100000)
1004                     (abi.encodeWithSignature("withdraw(uint256)", balance));
1005         
1006                 /* (Re-)Wrap ETH into LATEST instance. */
1007                 // NOTE: ETH will be wrapped on `_owner` behalf.
1008                 success = latestCache.call
1009                     .gas(100000)
1010                     .value(balance)
1011                     (abi.encodeWithSignature("wrap(address)", _owner));
1012             } else {
1013                 /* Set data to owner (address). */
1014                 // NOTE: Required to assign tokens after being received
1015                 //       by the new contract instance.
1016                 bytes memory data = abi.encodePacked(_owner);
1017 
1018                 /* (Re-)Deposit tokens into LATEST instance. */
1019                 // NOTE: Tokens will be credited to `_owner` (aka `data`).
1020                 ApproveAndCallFallBack(token)
1021                     .approveAndCall(latestCache, balance, data);
1022 
1023                 /* Set success. */
1024                 success = true;
1025             }
1026 
1027             /* Broadcast event. */
1028             emit Migrate(token, _owner, balance);
1029         }
1030     }
1031     
1032 
1033     /***************************************************************************
1034      * 
1035      * GETTERS
1036      * 
1037      */
1038 
1039     /**
1040      * Get Revision (Number)
1041      */
1042     function getRevision() public view returns (uint) {
1043         return _revision;
1044     }
1045     
1046     /**
1047      * Get Predecessor (Address)
1048      */
1049     function getPredecessor() public view returns (address) {
1050         return _predecessor;
1051     }
1052     
1053     /**
1054      * Get Successor (Address)
1055      */
1056     function getSuccessor() public view returns (address) {
1057         return _successor;
1058     }
1059     
1060     /**
1061      * Get the token balance for account `tokenOwner`
1062      */
1063     function balanceOf(
1064         address _token,
1065         address _owner
1066     ) external constant returns (uint balance) {
1067         /* Return balance. */
1068         return balanceOf(
1069             _token, _owner, _MAX_REVISION_DEPTH);
1070     }
1071 
1072     /**
1073      * Get the token balance for account `tokenOwner`
1074      * 
1075      * NOTE: Supports a virtually unlimited depth, 
1076      *       limited ONLY by the supplied gas amount.
1077      */
1078     function balanceOf(
1079         address _token,
1080         address _owner,
1081         uint _depth
1082     ) public constant returns (uint balance) {
1083         /* Retrieve (current) balance. */
1084         balance = _balances[_token][_owner];
1085         
1086         /* Initialize legacy instance (to current predecessor). */
1087         address legacyInstance = getPredecessor();
1088         
1089         /* Validate legacy instance. */
1090         if (legacyInstance != 0x0) {
1091             /* Initialize total legacy balance. */
1092             uint totalLegacyBalance = 0;
1093             
1094             /* Loop through legacy instances for balance. */
1095             for (uint i = 0; i < _depth; i++) {
1096                 /* Retrieve balance. */
1097                 uint legacyBalance = ZeroCache(legacyInstance)
1098                     .balanceOf(_token, _owner);
1099                     
1100                 /* Add to legacy balance total. */
1101                 totalLegacyBalance = totalLegacyBalance.add(legacyBalance);
1102     
1103                 /* Set the next legacy instance / predecessor (if available). */
1104                 legacyInstance = ZeroCache(legacyInstance).getPredecessor();
1105                 
1106                 /* Validate legacy instance. */
1107                 if (legacyInstance == 0x0) {
1108                     /* Break the loop. */
1109                     break;
1110                 }
1111             }
1112             
1113             /* Add total legacy balance. */
1114             balance = balance.add(totalLegacyBalance);
1115         }
1116     }
1117 
1118     
1119     /***************************************************************************
1120      * 
1121      * SETTERS
1122      * 
1123      */
1124 
1125     /**
1126      * Set Successor
1127      * 
1128      * This is the contract address that replaced this current instnace.
1129      */
1130     function setSuccessor(
1131         address _newSuccessor
1132     ) onlyAuthBy0Admin external returns (bool success) {
1133         /* Set successor contract. */
1134         _successor = _newSuccessor;
1135         
1136         /* Return success. */
1137         return true;
1138     }
1139 
1140 
1141     /***************************************************************************
1142      * 
1143      * INTERFACES
1144      * 
1145      */
1146 
1147     /**
1148      * Supports Interface (EIP-165)
1149      * 
1150      * (see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md)
1151      * 
1152      * NOTE: Must support the following conditions:
1153      *       1. (true) when interfaceID is 0x01ffc9a7 (EIP165 interface)
1154      *       2. (false) when interfaceID is 0xffffffff
1155      *       3. (true) for any other interfaceID this contract implements
1156      *       4. (false) for any other interfaceID
1157      */
1158     function supportsInterface(
1159         bytes4 _interfaceID
1160     ) external pure returns (bool) {
1161         /* Initialize constants. */
1162         bytes4 InvalidId = 0xffffffff;
1163         bytes4 ERC165Id = 0x01ffc9a7;
1164 
1165         /* Validate condition #2. */
1166         if (_interfaceID == InvalidId) {
1167             return false;
1168         }
1169 
1170         /* Validate condition #1. */
1171         if (_interfaceID == ERC165Id) {
1172             return true;
1173         }
1174         
1175         // TODO Add additional interfaces here.
1176         
1177         /* Return false (for condition #4). */
1178         return false;
1179     }
1180 
1181     /**
1182      * ECRecovery Interface
1183      */
1184     function _ecRecovery() private view returns (
1185         ECRecovery ecrecovery
1186     ) {
1187         /* Initailze hash. */
1188         bytes32 hash = keccak256('aname.ecrecovery');
1189         
1190         /* Retrieve value from Zer0net Db. */
1191         address aname = _zer0netDb.getAddress(hash);
1192         
1193         /* Initialize interface. */
1194         ecrecovery = ECRecovery(aname);
1195     }
1196 
1197     /**
1198      * Wrapped Ether (WETH) Interface
1199      * 
1200      * Retrieves the current WETH interface,
1201      * using the aname record from Zer0netDb.
1202      */
1203     function _weth() private view returns (
1204         WETHInterface weth
1205     ) {
1206         /* Initailze hash. */
1207         // NOTE: ERC tokens are case-sensitive.
1208         bytes32 hash = keccak256('aname.WETH');
1209         
1210         /* Retrieve value from Zer0net Db. */
1211         address aname = _zer0netDb.getAddress(hash);
1212         
1213         /* Initialize interface. */
1214         weth = WETHInterface(aname);
1215     }
1216 
1217     /**
1218      * MakerDAO DAI Interface
1219      * 
1220      * Retrieves the current DAI interface,
1221      * using the aname record from Zer0netDb.
1222      */
1223     function _dai() private view returns (
1224         ERC20Interface dai
1225     ) {
1226         /* Initailze hash. */
1227         // NOTE: ERC tokens are case-sensitive.
1228         bytes32 hash = keccak256('aname.DAI');
1229         
1230         /* Retrieve value from Zer0net Db. */
1231         address aname = _zer0netDb.getAddress(hash);
1232         
1233         /* Initialize interface. */
1234         dai = ERC20Interface(aname);
1235     }
1236 
1237     /**
1238      * ZeroGold Interface
1239      * 
1240      * Retrieves the current ZeroGold interface,
1241      * using the aname record from Zer0netDb.
1242      */
1243     function _zeroGold() private view returns (
1244         ERC20Interface zeroGold
1245     ) {
1246         /* Initailze hash. */
1247         // NOTE: ERC tokens are case-sensitive.
1248         bytes32 hash = keccak256('aname.0GOLD');
1249         
1250         /* Retrieve value from Zer0net Db. */
1251         address aname = _zer0netDb.getAddress(hash);
1252         
1253         /* Initialize interface. */
1254         zeroGold = ERC20Interface(aname);
1255     }
1256 
1257 
1258     /***************************************************************************
1259      * 
1260      * UTILITIES
1261      * 
1262      */
1263 
1264     /**
1265      * Request Hash Authorized Signature
1266      * 
1267      * Validates ALL signature requests by:
1268      *     1. Uses ECRecovery to validate the signature.
1269      *     2. Verify expiration against the current block number.
1270      *     3. Sets a flag to block re-use of signature.
1271      */
1272     function _requestHasAuthSig(
1273         address _from,
1274         bytes32 _authHash,
1275         uint _expires,
1276         bytes _signature
1277     ) private returns (bool success) {
1278         /* Calculate signature hash. */
1279         bytes32 sigHash = keccak256(abi.encodePacked(
1280             '\x19Ethereum Signed Message:\n32', _authHash));
1281 
1282         /* Validate signature expiration. */
1283         if (_expiredSignatures[sigHash]) {
1284             return false;
1285         }
1286 
1287         /* Set expiration flag. */
1288         // NOTE: Set a flag here to prevent double-spending.
1289         _expiredSignatures[sigHash] = true;
1290         
1291         /* Validate the expiration time. */
1292         if (block.number > _expires) {
1293             return false;
1294         }
1295         
1296         /* Retrieve the authorized account (address). */
1297         address authorizedAccount = 
1298             _ecRecovery().recover(sigHash, _signature);
1299 
1300         /* Validate the signer matches owner of the tokens. */
1301         if (_from != authorizedAccount) {
1302             return false;
1303         }
1304 
1305         /* Return success. */    
1306         return true;
1307     }
1308 
1309     /**
1310      * Is (Owner) Contract
1311      * 
1312      * Tests if a specified account / address is a contract.
1313      */
1314     function _ownerIsContract(
1315         address _owner
1316     ) private view returns (bool isContract) {
1317         /* Initialize code length. */
1318         uint codeLength;
1319 
1320         /* Run assembly. */
1321         assembly {
1322             /* Retrieve the size of the code on target address. */
1323             codeLength := extcodesize(_owner)
1324         }
1325         
1326         /* Set test result. */
1327         isContract = (codeLength > 0);
1328     }
1329 
1330     /**
1331      * Bytes-to-Address
1332      * 
1333      * Converts bytes into type address.
1334      */
1335     function _bytesToAddress(bytes _address) private pure returns (address) {
1336         uint160 m = 0;
1337         uint160 b = 0;
1338 
1339         for (uint8 i = 0; i < 20; i++) {
1340             m *= 256;
1341             b = uint160(_address[i]);
1342             m += (b);
1343         }
1344 
1345         return address(m);
1346     }
1347 
1348     /**
1349      * Transfer Any ERC20 Token
1350      *
1351      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
1352      *
1353      * @dev Provides an ERC20 interface, which allows for the recover
1354      *      of any accidentally sent ERC20 tokens.
1355      */
1356     function transferAnyERC20Token(
1357         address _tokenAddress, 
1358         uint _tokens
1359     ) public onlyOwner returns (bool success) {
1360         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
1361     }
1362 }