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
127     //Some addtional notes
128     string public remark1;
129     string public remark2;
130 
131     mapping (address => uint) pendingWithdrawals;
132 
133     /**
134      * The asset update events
135      */
136     event TokenUpdateEvent (
137         uint id,
138         bool isValid,
139         bool isTradable,
140         address owner,
141         uint assetPrice,
142         string assetFileLink,
143         string legalFileLink
144     );
145 
146     modifier onlyUnsplitted {
147         require(isSplitted == false, "This function can be called only under unsplitted status");
148         _;
149     }
150 
151     modifier onlyValid {
152         require(isValid == true, "Contract is invaild!");
153         _;
154     }
155 
156     /**
157      * constructor
158      * @param _id Token id
159      * @param _owner initial owner
160      * @param _assetPrice The price of asset
161      * @param _assetFileUrl The url of asset file
162      * @param _assetFileHashType The hash type of asset file
163      * @param _assetFileHashValue The hash value of asset file
164      * @param _legalFileUrl The url of legal file
165      * @param _legalFileHashType The hash type of legal file
166      * @param _legalFileHashValue The hash value of legal file
167      */
168     constructor(
169         uint _id,
170         address _owner,
171         uint _assetPrice,
172         string _assetFileUrl,
173         string _assetFileHashType,
174         string _assetFileHashValue,
175         string _legalFileUrl,
176         string _legalFileHashType,
177         string _legalFileHashValue
178         ) public {
179 
180         id = _id;
181         owner = _owner;
182 
183         assetPrice = _assetPrice;
184 
185         initAssetFile(
186             _assetFileUrl, _assetFileHashType, _assetFileHashValue, _legalFileUrl, _legalFileHashType, _legalFileHashValue);
187 
188         isValid = true;
189         isSplitted = false;
190         isTradable = false;
191     }
192 
193     /**
194      * Initialize asset file and legal file
195      * @param _assetFileUrl The url of asset file
196      * @param _assetFileHashType The hash type of asset file
197      * @param _assetFileHashValue The hash value of asset file
198      * @param _legalFileUrl The url of legal file
199      * @param _legalFileHashType The hash type of legal file
200      * @param _legalFileHashValue The hash value of legal file
201      */
202     function initAssetFile(
203         string _assetFileUrl,
204         string _assetFileHashType,
205         string _assetFileHashValue,
206         string _legalFileUrl,
207         string _legalFileHashType,
208         string _legalFileHashValue
209         ) internal {
210         assetFile = data(
211             _assetFileUrl, _assetFileHashType, _assetFileHashValue);
212         legalFile = data(
213             _legalFileUrl, _legalFileHashType, _legalFileHashValue);
214     }
215 
216      /**
217      * Get base asset info
218      */
219     function getAssetBaseInfo() public view onlyValid
220         returns (
221             uint _id,
222             uint _assetPrice,
223             bool _isTradable,
224             string _remark1,
225             string _remark2
226         )
227     {
228         _id = id;
229         _assetPrice = assetPrice;
230         _isTradable = isTradable;
231 
232         _remark1 = remark1;
233         _remark2 = remark2;
234     }
235 
236     /**
237      * set the price of asset
238      * @param newAssetPrice new price of asset
239      * Only can be called by owner
240      */
241     function setassetPrice(uint newAssetPrice)
242         public
243         onlyOwner
244         onlyValid
245         onlyUnsplitted
246     {
247         assetPrice = newAssetPrice;
248         emit TokenUpdateEvent (
249             id,
250             isValid,
251             isTradable,
252             owner,
253             assetPrice,
254             assetFile.link,
255             legalFile.link
256         );
257     }
258 
259     /**
260      * set the tradeable status of asset
261      * @param status status of isTradable
262      * Only can be called by owner
263      */
264     function setTradeable(bool status) public onlyOwner onlyValid onlyUnsplitted {
265         isTradable = status;
266         emit TokenUpdateEvent (
267             id,
268             isValid,
269             isTradable,
270             owner,
271             assetPrice,
272             assetFile.link,
273             legalFile.link
274         );
275     }
276 
277     /**
278      * set the remark1
279      * @param content new content of remark1
280      * Only can be called by owner
281      */
282     function setRemark1(string content) public onlyOwner onlyValid onlyUnsplitted {
283         remark1 = content;
284     }
285 
286     /**
287      * set the remark2
288      * @param content new content of remark2
289      * Only can be called by owner
290      */
291     function setRemark2(string content) public onlyOwner onlyValid onlyUnsplitted {
292         remark2 = content;
293     }
294 
295     /**
296      * Modify the link of the asset file
297      * @param url new link
298      * Only can be called by owner
299      */
300     function setAssetFileLink(string url) public
301         onlyOwner
302         onlyValid
303         onlyUnsplitted
304     {
305         assetFile.link = url;
306         emit TokenUpdateEvent (
307             id,
308             isValid,
309             isTradable,
310             owner,
311             assetPrice,
312             assetFile.link,
313             legalFile.link
314         );
315     }
316 
317     /**
318      * Modify the link of the legal file
319      * @param url new link
320      * Only can be called by owner
321      */
322     function setLegalFileLink(string url)
323         public
324         onlyOwner
325         onlyValid
326         onlyUnsplitted
327     {
328         legalFile.link = url;
329         emit TokenUpdateEvent (
330             id,
331             isValid,
332             isTradable,
333             owner,
334             assetPrice,
335             assetFile.link,
336             legalFile.link
337         );
338     }
339 
340     /**
341      * cancel contract
342      * Only can be called by owner
343      */
344     function cancelContract() public onlyOwner onlyValid onlyUnsplitted {
345         isValid = false;
346         emit TokenUpdateEvent (
347             id,
348             isValid,
349             isTradable,
350             owner,
351             assetPrice,
352             assetFile.link,
353             legalFile.link
354         );
355     }
356 
357     /**
358      * overwrite the transferOwnership interface in ownable.
359      * Only can transfer when the token is not splitted into small keys.
360      * After transfer, the token should be set in "no trading" status.
361      */
362     function transferOwnership(address newowner) public onlyOwner onlyValid onlyUnsplitted {
363         owner = newowner;
364         isTradable = false;  // set to false for new owner
365 
366         emit TokenUpdateEvent (
367             id,
368             isValid,
369             isTradable,
370             owner,
371             assetPrice,
372             assetFile.link,
373             legalFile.link
374         );
375     }
376 
377 
378     /**
379      * Buy asset
380      */
381     function buy() public payable onlyValid onlyUnsplitted {
382         require(isTradable == true, "contract is tradeable");
383         require(msg.value >= assetPrice, "assetPrice not match");
384         address origin_owner = owner;
385 
386         owner = msg.sender;
387         isTradable = false;  // set to false for new owner
388 
389         emit TokenUpdateEvent (
390             id,
391             isValid,
392             isTradable,
393             owner,
394             assetPrice,
395             assetFile.link,
396             legalFile.link
397         );
398 
399         uint priviousBalance = pendingWithdrawals[origin_owner];
400         pendingWithdrawals[origin_owner] = priviousBalance.add(assetPrice);
401     }
402 
403     function withdraw() public {
404         uint amount = pendingWithdrawals[msg.sender];
405 
406         // Remember to zero the pending refund before sending to prevent re-entrancy attacks
407         pendingWithdrawals[msg.sender] = 0;
408         msg.sender.transfer(amount);
409     }
410 }
411 
412 /**
413  * Standard ERC 20 interface.
414  */
415 contract ERC20Interface {
416     function totalSupply() public constant returns (uint);
417     function balanceOf(address tokenOwner) public constant returns (uint balance);
418     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
419     function transfer(address to, uint tokens) public returns (bool success);
420     function approve(address spender, uint tokens) public returns (bool success);
421     function transferFrom(address from, address to, uint tokens) public returns (bool success);
422 
423     event Transfer(address indexed from, address indexed to, uint tokens);
424     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
425 }
426 
427 contract DividableAsset is AssetHashToken, ERC20Interface {
428     using SafeMath for uint;
429 
430     ERC20Interface stableToken;
431 
432     string public name;
433     string public symbol;
434     uint8 public decimals;
435     uint public _totalSupply;
436 
437     address operator;
438 
439     uint collectPrice;
440 
441     address[] internal allowners;
442     mapping (address => uint) public indexOfowner;
443 
444     mapping (address => uint) public balances;
445     mapping (address => mapping (address => uint)) public allowed;
446 
447     modifier onlySplitted {
448         require(isSplitted == true, "Splitted status required");
449         _;
450     }
451 
452     modifier onlyOperator {
453         require(operator == msg.sender, "Operation only permited by operator");
454         _;
455     }
456 
457     /**
458      * The force collect event
459      */
460     event ForceCollectEvent (
461         uint id,
462         uint price,
463         address operator
464     );
465 
466     /**
467      * The token split event
468      */
469     event TokenSplitEvent (
470         uint id,
471         uint supply,
472         uint8 decim,
473         uint price
474     );
475 
476     /**
477      * The merge event
478      */
479     event TokenMergeEvent (
480         uint id,
481         address owner
482     );
483 
484     constructor(
485         string _name,
486         string _symbol,
487         address _tokenAddress,
488         uint _id,
489         address _owner,
490         uint _assetPrice,
491         string _assetFileUrl,
492         string _assetFileHashType,
493         string _assetFileHashValue,
494         string _legalFileUrl,
495         string _legalFileHashType,
496         string _legalFileHashValue
497         ) public
498         AssetHashToken(
499             _id,
500             _owner,
501             _assetPrice,
502             _assetFileUrl,
503             _assetFileHashType,
504             _assetFileHashValue,
505             _legalFileUrl,
506             _legalFileHashType,
507             _legalFileHashValue
508         )
509     {
510         name = _name;
511         symbol = _symbol;
512         operator = msg.sender; // TODO set to HashFuture owned address
513         stableToken = ERC20Interface(_tokenAddress);
514     }
515 
516     // ERC 20 Basic Functionality
517 
518     /**
519      * Total supply
520      */
521     function totalSupply() public view returns (uint) {
522         return _totalSupply.sub(balances[address(0)]);
523     }
524 
525     /**
526      * Get the token balance for account `tokenOwner`
527      */
528     function balanceOf(address tokenOwner) public view returns (uint balance) {
529         return balances[tokenOwner];
530     }
531 
532     /**
533      * Returns the amount of tokens approved by the owner that can be
534      * transferred to the spender's account
535      */
536     function allowance(address tokenOwner, address spender)
537         public view
538         returns (uint remaining)
539     {
540         return allowed[tokenOwner][spender];
541     }
542 
543     /**
544      * Transfer the balance from token owner's account to `to` account
545      * - Owner's account must have sufficient balance to transfer
546      * - 0 value transfers are allowed
547      */
548     function transfer(address to, uint tokens)
549         public
550         onlySplitted
551         returns (bool success)
552     {
553         require(tokens > 0);
554         balances[msg.sender] = balances[msg.sender].sub(tokens);
555         balances[to] = balances[to].add(tokens);
556 
557 
558         // ensure that each address appears only once in allowners list
559         // so that distribute divident or force collect only pays one time
560         if (indexOfowner[to] == 0) {
561             allowners.push(to);
562             indexOfowner[to] = allowners.length;
563         }
564         // could be removed? no
565         if (balances[msg.sender] == 0) {
566             uint index = indexOfowner[msg.sender].sub(1);
567             indexOfowner[msg.sender] = 0;
568 
569             if (index != allowners.length.sub(1)) {
570                 allowners[index] = allowners[allowners.length.sub(1)];
571                 indexOfowner[allowners[index]] = index.add(1);
572             }
573 
574             //delete allowners[allowners.length.sub(1)];
575             allowners.length = allowners.length.sub(1);
576         }
577         emit Transfer(msg.sender, to, tokens);
578         return true;
579     }
580 
581     /**
582      * Token owner can approve for `spender` to transferFrom(...) `tokens`
583      * from the token owner's account
584      */
585     function approve(address spender, uint tokens)
586         public
587         onlySplitted
588         returns (bool success)
589     {
590         allowed[msg.sender][spender] = tokens;
591         emit Approval(msg.sender, spender, tokens);
592         return true;
593     }
594 
595     /**
596      * Transfer `tokens` from the `from` account to the `to` account
597      */
598     function transferFrom(address from, address to, uint tokens)
599         public
600         onlySplitted
601         returns (bool success)
602     {
603         require(tokens > 0);
604         balances[from] = balances[from].sub(tokens);
605         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
606         balances[to] = balances[to].add(tokens);
607 
608         // ensure that each address appears only once in allowners list
609         // so that distribute divident or force collect only pays one time
610         if (indexOfowner[to] == 0) {
611             allowners.push(to);
612             indexOfowner[to] = allowners.length;
613         }
614 
615         // could be removed? no
616         if (balances[from] == 0) {
617             uint index = indexOfowner[from].sub(1);
618             indexOfowner[from] = 0;
619 
620             if (index != allowners.length.sub(1)) {
621                 allowners[index] = allowners[allowners.length.sub(1)];
622                 indexOfowner[allowners[index]] = index.add(1);
623             }
624             //delete allowners[allowners.length.sub(1)];
625             allowners.length = allowners.length.sub(1);
626         }
627 
628         emit Transfer(from, to, tokens);
629         return true;
630     }
631 
632     /**
633      * 
634      * Warning: may fail when number of owners exceeds 100 due to gas limit of a block in Ethereum.
635      */
636     function distributeDivident(uint amount) public {
637         // stableToken.approve(address(this), amount)
638         // should be called by the caller to the token contract in previous
639         uint value = 0;
640         uint length = allowners.length;
641         require(stableToken.balanceOf(msg.sender) >= amount, "Insufficient balance for sender");
642         require(stableToken.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance for contract");
643         for (uint i = 0; i < length; i++) {
644             //value = amount * balances[allowners[i]] / _totalSupply;
645             value = amount.mul(balances[allowners[i]]);
646             value = value.div(_totalSupply);
647 
648             // Always use a require when doing token transfer!
649             // Do not think it works like the transfer method for ether,
650             // which handles failure and will throw for you.
651             require(stableToken.transferFrom(msg.sender, allowners[i], value));
652         }
653     }
654     
655     /**
656      * Collect all small keys in batches.
657      * Anyone can force collect all keys if he provides with sufficient stable tokens.
658      * However, due to the gas limitation of Ethereum, he can not collect all keys
659      * with only one call. Hence an agent that can be trusted is need.
660      * The operator is such an agent who will first receive a request to collect all keys,
661      * and then collect them with the stable tokens provided by the claimer.
662      * @param _address each address in the array means a target address to be collected from.
663      */
664     function collectAllForce(address[] _address) public onlyOperator {
665         // stableToken.approve(address(this), amount)
666         // should be called by the caller to the token contract in previous
667         uint value = 0;
668         uint length = _address.length;
669 
670         uint total_amount = 0;
671 
672         for (uint j = 0; j < length; j++) {
673             if (indexOfowner[_address[j]] == 0) {
674                 continue;
675             }
676 
677             total_amount = total_amount.add(collectPrice.mul(balances[_address[j]]));
678         }
679 
680         require(stableToken.balanceOf(msg.sender) >= total_amount, "Insufficient balance for sender");
681         require(stableToken.allowance(msg.sender, address(this)) >= total_amount, "Insufficient allowance for contract");
682 
683         for (uint i = 0; i < length; i++) {
684             // Always use a require when doing token transfer!
685             // Do not think it works like the transfer method for ether,
686             // which handles failure and will throw for you.
687             if (indexOfowner[_address[i]] == 0) {
688                 continue;
689             }
690 
691             value = collectPrice.mul(balances[_address[i]]);
692 
693             require(stableToken.transferFrom(msg.sender, _address[i], value));
694             balances[msg.sender] = balances[msg.sender].add(balances[_address[i]]);
695             emit Transfer(_address[i], msg.sender, balances[_address[i]]);
696 
697             balances[_address[i]] = 0;
698 
699             uint index = indexOfowner[_address[i]].sub(1);
700             indexOfowner[_address[i]] = 0;
701 
702             if (index != allowners.length.sub(1)) {
703                 allowners[index] = allowners[allowners.length.sub(1)];
704                 indexOfowner[allowners[index]] = index.add(1);
705             }
706             allowners.length = allowners.length.sub(1);
707         }
708 
709         emit ForceCollectEvent(id, collectPrice, operator);
710     }
711     
712     /**
713      * key inssurance. Split the whole token into small keys.
714      * Only the owner can perform this when the token is still valid and unsplitted.
715      * @param _supply Totol supply in ERC20 standard
716      * @param _decim  Decimal parameter in ERC20 standard
717      * @param _price The force acquisition price. If a claimer is willing to pay more than this value, he can
718      * buy the keys forcibly. Notice: the claimer can only buy all keys at one time or buy nothing and the
719      * buying process is delegated into a trusted agent. i.e. the operator.
720      * @param _address The initial distribution plan for the keys. This parameter contains the addresses.
721      * @param _amount  The amount corresponding to the initial distribution addresses.
722      */
723     function split(uint _supply, uint8 _decim, uint _price, address[] _address, uint[] _amount)
724         public
725         onlyOwner
726         onlyValid
727         onlyUnsplitted
728     {
729         require(_address.length == _amount.length);
730 
731         isSplitted = true;
732         _totalSupply = _supply * 10 ** uint(_decim);
733         decimals = _decim;
734         collectPrice = _price;
735 
736         uint amount = 0;
737         uint length = _address.length;
738 
739         balances[msg.sender] = _totalSupply;
740         if (indexOfowner[msg.sender] == 0) {
741             allowners.push(msg.sender);
742             indexOfowner[msg.sender] = allowners.length;
743         }
744         emit Transfer(address(0), msg.sender, _totalSupply);
745 
746         for (uint i = 0; i < length; i++) {
747             amount = _amount[i]; // * 10 ** uint(_decim);
748             balances[_address[i]] = amount;
749             balances[msg.sender] = balances[msg.sender].sub(amount);
750 
751             // ensure that each address appears only once in allowners list
752             // so that distribute divident or force collect only pays one time
753             if (indexOfowner[_address[i]] == 0) {
754                 allowners.push(_address[i]);
755                 indexOfowner[_address[i]] = allowners.length;
756             }
757             emit Transfer(msg.sender, _address[i], amount);
758         }
759 
760         emit TokenSplitEvent(id, _supply, _decim, _price);
761     }
762     
763     /**
764      * Token conversion. Turn the keys to a whole token.
765      * Only the sender with all keys in hand can perform this and he will be the new owner.
766      */
767     function merge() public onlyValid onlySplitted {
768         require(balances[msg.sender] == _totalSupply);
769         _totalSupply = 0;
770         balances[msg.sender] = 0;
771         owner = msg.sender;
772         isTradable = false;
773         isSplitted = false;
774         emit Transfer(msg.sender, address(0), _totalSupply);
775         emit TokenMergeEvent(id, msg.sender);
776     }
777 }