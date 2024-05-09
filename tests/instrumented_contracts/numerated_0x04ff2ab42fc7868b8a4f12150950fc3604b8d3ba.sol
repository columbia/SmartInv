1 /**
2  * Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
3  */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8 
9     function mul(uint a, uint b) internal pure returns (uint) {
10         if (a == 0) {
11             return 0;
12         }
13         uint c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint a, uint b) internal pure returns (uint) {
19         return a / b;
20     }
21 
22     function sub(uint a, uint b) internal pure returns (uint) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint a, uint b) internal pure returns (uint) {
28         uint c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract ownable {
35     address public owner;
36 
37     function ownable() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) onlyOwner public {
47         owner = newOwner;
48     }
49 }
50 
51 /**
52  * The signature mechanism to enhance the credibility of the token.
53  * The sign process is asychronous.
54  * After the creation of the contract, one who verifies the contract and
55  * is willing to guarantee for it can sign the contract address.
56  */
57 contract verifiable {
58 
59     struct Signature {
60         uint8 v;
61         bytes32 r;
62         bytes32 s;
63     }
64 
65     /**
66      * signatures
67      * Used to verify that if the contract is protected
68      * By hashworld or other publicly verifiable organizations
69      */
70     mapping(address => Signature) public signatures;
71 
72     /**
73      * sign Token
74      */
75     function sign(uint8 v, bytes32 r, bytes32 s) public {
76         signatures[msg.sender] = Signature(v, r, s);
77     }
78 
79     /**
80      * To verify whether a specific signer has signed this contract's address
81      * @param signer address to verify
82      */
83     function verify(address signer) public constant returns(bool) {
84         bytes32 hash = keccak256(abi.encodePacked(address(this)));
85         Signature storage sig = signatures[signer];
86         return ecrecover(hash, sig.v, sig.r, sig.s) == signer;
87     }
88 }
89 
90 contract AssetHashToken is ownable, verifiable{
91     using SafeMath for uint;
92 
93     //Asset Struct
94     struct data {
95         // link URL of the original information for storing data; null means undisclosed
96         string link;
97         // The hash type of the original data, such as SHA-256
98         string hashType;
99         // Hash value of the agreed content.
100         string hashValue;
101     }
102 
103     data public assetFile;
104     data public legalFile;
105 
106     //The token id
107     uint id;
108 
109     //The validity of the contract
110     bool public isValid;
111 
112     //The splitting status of the asset
113     //Set to true if the asset has been splitted to small tokens
114     bool public isSplitted;
115 
116     // The tradeable status of asset
117     // Leave (together with assetPrice) for auto buy and sell functionality (with Ether).
118     bool public isTradable;
119 
120     /**
121      * The price of asset
122      * if the contract is valid and tradeable,
123      * others can get asset by transfer assetPrice ETH to contract
124      */
125     uint public assetPrice;
126 
127     uint public pledgePrice;
128 
129     //Some addtional notes
130     string public remark1;
131     string public remark2;
132 
133     // Digital Asset Url
134     string private digitalAsset;
135 
136     mapping (address => uint) pendingWithdrawals;
137 
138     /**
139      * The asset update events
140      */
141     event TokenUpdateEvent (
142         uint id,
143         bool isValid,
144         bool isTradable,
145         address owner,
146         uint assetPrice,
147         string assetFileLink,
148         string legalFileLink
149     );
150 
151     modifier onlyUnsplitted {
152         require(isSplitted == false, "This function can be called only under unsplitted status");
153         _;
154     }
155 
156     modifier onlyValid {
157         require(isValid == true, "Contract is invaild!");
158         _;
159     }
160 
161     /**
162      * constructor
163      * @param _id Token id
164      * @param _owner initial owner
165      * @param _assetPrice The price of asset
166      * @param _assetFileUrl The url of asset file
167      * @param _assetFileHashType The hash type of asset file
168      * @param _assetFileHashValue The hash value of asset file
169      * @param _legalFileUrl The url of legal file
170      * @param _legalFileHashType The hash type of legal file
171      * @param _legalFileHashValue The hash value of legal file
172      */
173     constructor(
174         uint _id,
175         address _owner,
176         uint _assetPrice,
177         uint _pledgePrice,
178         string _assetFileUrl,
179         string _assetFileHashType,
180         string _assetFileHashValue,
181         string _legalFileUrl,
182         string _legalFileHashType,
183         string _legalFileHashValue,
184         string _digitalAsset
185         ) public {
186 
187         id = _id;
188         owner = _owner;
189 
190         assetPrice = _assetPrice;
191         pledgePrice = _pledgePrice;
192         digitalAsset = _digitalAsset;
193 
194         initAssetFile(
195             _assetFileUrl, _assetFileHashType, _assetFileHashValue, _legalFileUrl, _legalFileHashType, _legalFileHashValue);
196 
197         isValid = true;
198         isSplitted = false;
199         isTradable = false;
200     }
201 
202     /**
203      * Initialize asset file and legal file
204      * @param _assetFileUrl The url of asset file
205      * @param _assetFileHashType The hash type of asset file
206      * @param _assetFileHashValue The hash value of asset file
207      * @param _legalFileUrl The url of legal file
208      * @param _legalFileHashType The hash type of legal file
209      * @param _legalFileHashValue The hash value of legal file
210      */
211     function initAssetFile(
212         string _assetFileUrl,
213         string _assetFileHashType,
214         string _assetFileHashValue,
215         string _legalFileUrl,
216         string _legalFileHashType,
217         string _legalFileHashValue
218         ) internal {
219         assetFile = data(
220             _assetFileUrl, _assetFileHashType, _assetFileHashValue);
221         legalFile = data(
222             _legalFileUrl, _legalFileHashType, _legalFileHashValue);
223     }
224 
225      /**
226      * Get base asset info
227      */
228     function getAssetBaseInfo() public view onlyValid
229         returns (
230             uint _id,
231             uint _assetPrice,
232             bool _isTradable,
233             string _remark1,
234             string _remark2
235         )
236     {
237         _id = id;
238         _assetPrice = assetPrice;
239         _isTradable = isTradable;
240 
241         _remark1 = remark1;
242         _remark2 = remark2;
243     }
244 
245     /**
246      * set the price of asset
247      * @param newAssetPrice new price of asset
248      * Only can be called by owner
249      */
250     function setassetPrice(uint newAssetPrice)
251         public
252         onlyOwner
253         onlyValid
254         onlyUnsplitted
255     {
256         assetPrice = newAssetPrice;
257         emit TokenUpdateEvent (
258             id,
259             isValid,
260             isTradable,
261             owner,
262             assetPrice,
263             assetFile.link,
264             legalFile.link
265         );
266     }
267 
268     /**
269      * set the tradeable status of asset
270      * @param status status of isTradable
271      * Only can be called by owner
272      */
273     function setTradeable(bool status) public onlyOwner onlyValid onlyUnsplitted {
274         isTradable = status;
275         emit TokenUpdateEvent (
276             id,
277             isValid,
278             isTradable,
279             owner,
280             assetPrice,
281             assetFile.link,
282             legalFile.link
283         );
284     }
285 
286     /**
287      * set the remark1
288      * @param content new content of remark1
289      * Only can be called by owner
290      */
291     function setRemark1(string content) public onlyOwner onlyValid onlyUnsplitted {
292         remark1 = content;
293     }
294 
295     /**
296      * set the remark2
297      * @param content new content of remark2
298      * Only can be called by owner
299      */
300     function setRemark2(string content) public onlyOwner onlyValid onlyUnsplitted {
301         remark2 = content;
302     }
303 
304     /**
305      * get the digitalAsset
306      * Only can be called by owner
307      */
308     function getDigitalAsset() public view onlyOwner onlyValid onlyUnsplitted
309         returns (string _digitalAsset)
310     {
311         _digitalAsset = digitalAsset;
312     }
313 
314     /**
315      * Modify the link of the asset file
316      * @param url new link
317      * Only can be called by owner
318      */
319     function setAssetFileLink(string url) public
320         onlyOwner
321         onlyValid
322         onlyUnsplitted
323     {
324         assetFile.link = url;
325         emit TokenUpdateEvent (
326             id,
327             isValid,
328             isTradable,
329             owner,
330             assetPrice,
331             assetFile.link,
332             legalFile.link
333         );
334     }
335 
336     /**
337      * Modify the link of the legal file
338      * @param url new link
339      * Only can be called by owner
340      */
341     function setLegalFileLink(string url)
342         public
343         onlyOwner
344         onlyValid
345         onlyUnsplitted
346     {
347         legalFile.link = url;
348         emit TokenUpdateEvent (
349             id,
350             isValid,
351             isTradable,
352             owner,
353             assetPrice,
354             assetFile.link,
355             legalFile.link
356         );
357     }
358 
359     /**
360      * cancel contract
361      * Only can be called by owner
362      */
363     function cancelContract() public onlyOwner onlyValid onlyUnsplitted {
364         isValid = false;
365         emit TokenUpdateEvent (
366             id,
367             isValid,
368             isTradable,
369             owner,
370             assetPrice,
371             assetFile.link,
372             legalFile.link
373         );
374     }
375 
376     /**
377      * overwrite the transferOwnership interface in ownable.
378      * Only can transfer when the token is not splitted into small keys.
379      * After transfer, the token should be set in "no trading" status.
380      */
381     function transferOwnership(address newowner) public onlyOwner onlyValid onlyUnsplitted {
382         owner = newowner;
383         isTradable = false;  // set to false for new owner
384 
385         emit TokenUpdateEvent (
386             id,
387             isValid,
388             isTradable,
389             owner,
390             assetPrice,
391             assetFile.link,
392             legalFile.link
393         );
394     }
395 
396 
397     /**
398      * Buy asset
399      */
400     function buy() public payable onlyValid onlyUnsplitted {
401         require(isTradable == true, "contract is tradeable");
402         require(msg.value >= assetPrice, "assetPrice not match");
403         address origin_owner = owner;
404 
405         owner = msg.sender;
406         isTradable = false;  // set to false for new owner
407 
408         emit TokenUpdateEvent (
409             id,
410             isValid,
411             isTradable,
412             owner,
413             assetPrice,
414             assetFile.link,
415             legalFile.link
416         );
417 
418         uint priviousBalance = pendingWithdrawals[origin_owner];
419         pendingWithdrawals[origin_owner] = priviousBalance.add(assetPrice);
420     }
421 
422     function withdraw() public {
423         uint amount = pendingWithdrawals[msg.sender];
424 
425         // Remember to zero the pending refund before sending to prevent re-entrancy attacks
426         pendingWithdrawals[msg.sender] = 0;
427         msg.sender.transfer(amount);
428     }
429 }
430 
431 /**
432  * Standard ERC 20 interface.
433  */
434 contract ERC20Interface {
435     function totalSupply() public constant returns (uint);
436     function balanceOf(address tokenOwner) public constant returns (uint balance);
437     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
438     function transfer(address to, uint tokens) public returns (bool success);
439     function approve(address spender, uint tokens) public returns (bool success);
440     function transferFrom(address from, address to, uint tokens) public returns (bool success);
441 
442     event Transfer(address indexed from, address indexed to, uint tokens);
443     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
444 }
445 
446 contract DividableAsset is AssetHashToken, ERC20Interface {
447     using SafeMath for uint;
448 
449     ERC20Interface stableToken;
450 
451     string public name;
452     string public symbol;
453     uint8 public decimals;
454     uint public _totalSupply;
455 
456     address public operator;
457 
458     uint collectPrice;
459 
460     address[] internal allowners;
461     mapping (address => uint) public indexOfowner;
462 
463     mapping (address => uint) public balances;
464     mapping (address => mapping (address => uint)) public allowed;
465 
466     modifier onlySplitted {
467         require(isSplitted == true, "Splitted status required");
468         _;
469     }
470 
471     modifier onlyOperator {
472         require(operator == msg.sender, "Operation only permited by operator");
473         _;
474     }
475 
476     /**
477      * The force collect event
478      */
479     event ForceCollectEvent (
480         uint id,
481         uint price,
482         address operator
483     );
484 
485     /**
486      * The token split event
487      */
488     event TokenSplitEvent (
489         uint id,
490         uint supply,
491         uint8 decim,
492         uint price,
493         address owner
494     );
495 
496     constructor(
497         string _name,
498         string _symbol,
499         address _tokenAddress,
500         uint _id,
501         address _owner,
502         uint _assetPrice,
503         uint _pledgePrice,
504         string _assetFileUrl,
505         string _assetFileHashType,
506         string _assetFileHashValue,
507         string _legalFileUrl,
508         string _legalFileHashType,
509         string _legalFileHashValue,
510         string _digitalAsset
511         ) public
512         AssetHashToken(
513             _id,
514             _owner,
515             _assetPrice,
516             _pledgePrice,
517             _assetFileUrl,
518             _assetFileHashType,
519             _assetFileHashValue,
520             _legalFileUrl,
521             _legalFileHashType,
522             _legalFileHashValue,
523             _digitalAsset
524         )
525     {
526         name = _name;
527         symbol = _symbol;
528         operator = msg.sender; // TODO set to HashFuture owned address
529         stableToken = ERC20Interface(_tokenAddress);
530     }
531 
532     // ERC 20 Basic Functionality
533 
534     /**
535      * Total supply
536      */
537     function totalSupply() public view returns (uint) {
538         return _totalSupply.sub(balances[address(0)]);
539     }
540 
541     /**
542      * Get the token balance for account `tokenOwner`
543      */
544     function balanceOf(address tokenOwner) public view returns (uint balance) {
545         return balances[tokenOwner];
546     }
547 
548     /**
549      * Returns the amount of tokens approved by the owner that can be
550      * transferred to the spender's account
551      */
552     function allowance(address tokenOwner, address spender)
553         public view
554         returns (uint remaining)
555     {
556         return allowed[tokenOwner][spender];
557     }
558 
559     /**
560      * Transfer the balance from token owner's account to `to` account
561      * - Owner's account must have sufficient balance to transfer
562      * - 0 value transfers are allowed
563      */
564     function transfer(address to, uint tokens)
565         public
566         onlySplitted
567         returns (bool success)
568     {
569         require(tokens > 0);
570         balances[msg.sender] = balances[msg.sender].sub(tokens);
571         balances[to] = balances[to].add(tokens);
572 
573 
574         // ensure that each address appears only once in allowners list
575         // so that distribute divident or force collect only pays one time
576         if (indexOfowner[to] == 0) {
577             allowners.push(to);
578             indexOfowner[to] = allowners.length;
579         }
580         // could be removed? no
581         if (balances[msg.sender] == 0) {
582             uint index = indexOfowner[msg.sender].sub(1);
583             indexOfowner[msg.sender] = 0;
584 
585             if (index != allowners.length.sub(1)) {
586                 allowners[index] = allowners[allowners.length.sub(1)];
587                 indexOfowner[allowners[index]] = index.add(1);
588             }
589 
590             //delete allowners[allowners.length.sub(1)];
591             allowners.length = allowners.length.sub(1);
592         }
593         emit Transfer(msg.sender, to, tokens);
594         return true;
595     }
596 
597     /**
598      * Token owner can approve for `spender` to transferFrom(...) `tokens`
599      * from the token owner's account
600      */
601     function approve(address spender, uint tokens)
602         public
603         onlySplitted
604         returns (bool success)
605     {
606         allowed[msg.sender][spender] = tokens;
607         emit Approval(msg.sender, spender, tokens);
608         return true;
609     }
610 
611     /**
612      * Transfer `tokens` from the `from` account to the `to` account
613      */
614     function transferFrom(address from, address to, uint tokens)
615         public
616         onlySplitted
617         returns (bool success)
618     {
619         require(tokens > 0);
620         balances[from] = balances[from].sub(tokens);
621         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
622         balances[to] = balances[to].add(tokens);
623 
624         // ensure that each address appears only once in allowners list
625         // so that distribute divident or force collect only pays one time
626         if (indexOfowner[to] == 0) {
627             allowners.push(to);
628             indexOfowner[to] = allowners.length;
629         }
630 
631         // could be removed? no
632         if (balances[from] == 0) {
633             uint index = indexOfowner[from].sub(1);
634             indexOfowner[from] = 0;
635 
636             if (index != allowners.length.sub(1)) {
637                 allowners[index] = allowners[allowners.length.sub(1)];
638                 indexOfowner[allowners[index]] = index.add(1);
639             }
640             //delete allowners[allowners.length.sub(1)];
641             allowners.length = allowners.length.sub(1);
642         }
643 
644         emit Transfer(from, to, tokens);
645         return true;
646     }
647 
648     /**
649      * 
650      * Warning: may fail when number of owners exceeds 100 due to gas limit of a block in Ethereum.
651      */
652     function distributeDivident(uint amount) public {
653         // stableToken.approve(address(this), amount)
654         // should be called by the caller to the token contract in previous
655         uint value = 0;
656         uint length = allowners.length;
657         require(stableToken.balanceOf(msg.sender) >= amount, "Insufficient balance for sender");
658         require(stableToken.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance for contract");
659         for (uint i = 0; i < length; i++) {
660             //value = amount * balances[allowners[i]] / _totalSupply;
661             value = amount.mul(balances[allowners[i]]);
662             value = value.div(_totalSupply);
663 
664             // Always use a require when doing token transfer!
665             // Do not think it works like the transfer method for ether,
666             // which handles failure and will throw for you.
667             require(stableToken.transferFrom(msg.sender, allowners[i], value));
668         }
669     }
670 
671     /**
672      * partially distribute divident to given address list
673      */
674     function partialDistributeDivident(uint amount, address[] _address) public {
675         // stableToken.approve(address(this), amount)
676         // should be called by the caller to the token contract in previous
677         uint value = 0;
678         uint length = _address.length;
679         require(stableToken.balanceOf(msg.sender) >= amount, "Insufficient balance for sender");
680         require(stableToken.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance for contract");
681 
682         uint totalAmount = 0;
683         for (uint j = 0; j < length; j++) {
684             totalAmount = totalAmount.add(balances[_address[j]]);
685         }
686 
687         for (uint i = 0; i < length; i++) {
688             value = amount.mul(balances[_address[i]]);
689             value = value.div(totalAmount);
690 
691             // Always use a require when doing token transfer!
692             // Do not think it works like the transfer method for ether,
693             // which handles failure and will throw for you.
694             require(stableToken.transferFrom(msg.sender, _address[i], value));
695         }
696     }
697 
698     /**
699      * Collect all small keys in batches.
700      * Anyone can force collect all keys if he provides with sufficient stable tokens.
701      * However, due to the gas limitation of Ethereum, he can not collect all keys
702      * with only one call. Hence an agent that can be trusted is need.
703      * The operator is such an agent who will first receive a request to collect all keys,
704      * and then collect them with the stable tokens provided by the claimer.
705      * @param _address each address in the array means a target address to be collected from.
706      */
707     function collectAllForce(address[] _address) public onlyOperator {
708         // stableToken.approve(address(this), amount)
709         // should be called by the caller to the token contract in previous
710         uint value = 0;
711         uint length = _address.length;
712 
713         uint total_amount = 0;
714 
715         for (uint j = 0; j < length; j++) {
716             if (indexOfowner[_address[j]] == 0) {
717                 continue;
718             }
719 
720             total_amount = total_amount.add(collectPrice.mul(balances[_address[j]]));
721         }
722 
723         require(stableToken.balanceOf(msg.sender) >= total_amount, "Insufficient balance for sender");
724         require(stableToken.allowance(msg.sender, address(this)) >= total_amount, "Insufficient allowance for contract");
725 
726         for (uint i = 0; i < length; i++) {
727             // Always use a require when doing token transfer!
728             // Do not think it works like the transfer method for ether,
729             // which handles failure and will throw for you.
730             if (indexOfowner[_address[i]] == 0) {
731                 continue;
732             }
733 
734             value = collectPrice.mul(balances[_address[i]]);
735 
736             require(stableToken.transferFrom(msg.sender, _address[i], value));
737             balances[msg.sender] = balances[msg.sender].add(balances[_address[i]]);
738             emit Transfer(_address[i], msg.sender, balances[_address[i]]);
739 
740             balances[_address[i]] = 0;
741 
742             uint index = indexOfowner[_address[i]].sub(1);
743             indexOfowner[_address[i]] = 0;
744 
745             if (index != allowners.length.sub(1)) {
746                 allowners[index] = allowners[allowners.length.sub(1)];
747                 indexOfowner[allowners[index]] = index.add(1);
748             }
749             allowners.length = allowners.length.sub(1);
750         }
751 
752         emit ForceCollectEvent(id, collectPrice, operator);
753     }
754 
755     /**
756      * key inssurance. Split the whole token into small keys.
757      * Only the owner can perform this when the token is still valid and unsplitted.
758      * @param _supply Totol supply in ERC20 standard
759      * @param _decim  Decimal parameter in ERC20 standard
760      * @param _price The force acquisition price. If a claimer is willing to pay more than this value, he can
761      * buy the keys forcibly. Notice: the claimer can only buy all keys at one time or buy nothing and the
762      * buying process is delegated into a trusted agent. i.e. the operator.
763      * @param _address The initial distribution plan for the keys. This parameter contains the addresses.
764      * @param _amount  The amount corresponding to the initial distribution addresses.
765      */
766     function split(uint _supply, uint8 _decim, uint _price, address[] _address, uint[] _amount)
767         public
768         onlyValid
769         onlyOperator
770         onlyUnsplitted
771     {
772         require(_address.length == _amount.length);
773 
774         isSplitted = true;
775         _totalSupply = _supply * 10 ** uint(_decim);
776         decimals = _decim;
777         collectPrice = _price;
778 
779         uint amount = 0;
780         uint length = _address.length;
781 
782         balances[msg.sender] = _totalSupply;
783         if (indexOfowner[msg.sender] == 0) {
784             allowners.push(msg.sender);
785             indexOfowner[msg.sender] = allowners.length;
786         }
787         emit Transfer(address(0), msg.sender, _totalSupply);
788 
789         for (uint i = 0; i < length; i++) {
790             amount = _amount[i]; // * 10 ** uint(_decim);
791             balances[_address[i]] = amount;
792             balances[msg.sender] = balances[msg.sender].sub(amount);
793 
794             // ensure that each address appears only once in allowners list
795             // so that distribute divident or force collect only pays one time
796             if (indexOfowner[_address[i]] == 0) {
797                 allowners.push(_address[i]);
798                 indexOfowner[_address[i]] = allowners.length;
799             }
800             emit Transfer(msg.sender, _address[i], amount);
801         }
802 
803         emit TokenSplitEvent(id, _supply, _decim, _price, owner);
804     }
805 
806     /**
807      * Token conversion. Turn the keys to a whole token.
808      * Only the sender with all keys in hand can perform this and he will be the new owner.
809      */
810     function merge() public onlyValid onlySplitted {
811         require(balances[msg.sender] == _totalSupply);
812         _totalSupply = 0;
813         balances[msg.sender] = 0;
814         owner = msg.sender;
815         isTradable = false;
816         isSplitted = false;
817         emit Transfer(msg.sender, address(0), _totalSupply);
818         emit TokenSplitEvent(id, 0, 0, 0, msg.sender);
819     }
820 }