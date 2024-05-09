1 pragma solidity ^0.4.26;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Contract function to receive approval and execute function in one call
21 //
22 // ----------------------------------------------------------------------------
23 contract ApproveAndCallFallBack {
24     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Owned contract
29 // ----------------------------------------------------------------------------
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner,"Owner incorrect!");
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner,"Owner incorrect!");
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 // ----------------------------------------------------------------------------
57 // Lucky Code contract
58 // ----------------------------------------------------------------------------
59 contract LuckyCode is ERC20Interface, Owned{
60     using SafeMath for uint;
61 
62     /*=================================
63     =            MODIFIERS            =
64     =================================*/
65     modifier onlyBagholders() {
66         require(myTokens() > 0,"Please check my tokens!");
67         _;
68     }
69 
70     modifier onlyAdministrator(){
71         address _customerAddress = msg.sender;
72         require(administrators[keccak256(abi.encodePacked(_customerAddress))], "Please check permission admin!");
73         _;
74     }
75 
76     modifier onlyValidAddress(address _to){
77         require(_to != address(0x0000000000000000000000000000000000000000), "Please check address!");
78         _;
79     }
80 
81     modifier onlyValidBlock(){
82         address _customerAddress = msg.sender;
83         require(blockCustomer_[_customerAddress] > 0, "Block number invalid!");
84         _;
85     }
86 
87     /*==============================
88     =            EVENTS            =
89     ==============================*/
90     event onTokenPurchase(
91         address indexed customerAddress,
92         uint256 incomingEthereum,
93         uint256 tokensMinted
94     );
95 
96     event onTokenSell(
97         address indexed customerAddress,
98         uint256 tokensBurned,
99         uint256 ethereumEarned
100     );
101 
102     /*=====================================
103     =            CONFIGURABLES            =
104     =====================================*/
105     string public symbol = "ECT";
106     string public name = "EtherCenter";
107     uint8 constant public decimals = 18;
108     uint256 constant public _maxSupply = 1000000 * 10**uint(decimals);
109     uint256 constant public _ECTAllocation = 800000 * 10**uint(decimals);
110     uint256 internal totalSupply_;
111 
112     bytes32 internal luckyBlockHash_;
113     uint256 constant internal adminETH_ = 200 ether;
114     uint256 constant internal defaultECT_ = 10**uint(decimals);
115     uint256 constant internal defaultValue_ = 10**uint(decimals-1);
116     uint256 constant internal defaultAd_ = 10**uint(decimals-3);
117 
118     address internal admin_;
119 
120     mapping(address => uint) balances; // ECT
121     mapping(address => mapping(address => uint)) allowed;
122     mapping(bytes32 => bool) public administrators;
123     mapping(address => uint256) blockCustomer_;
124 
125     /*=====================================
126     =             CONSTRUCTOR             =
127     =====================================*/
128     constructor (address _admin)
129     public
130     {
131         // add administrators here
132         administrators[keccak256(abi.encode(_admin))] = true;
133         admin_ = _admin;
134         luckyBlockHash_ = bytes32(_admin);
135     }
136 
137     // ------------------------------------------------------------------------
138     // Buy lucky code and receive ECT
139     // ------------------------------------------------------------------------
140     function buyECT()
141     public
142     payable
143     {
144         if (address(this).balance <= adminETH_ &&
145             administrators[keccak256(abi.encode(msg.sender))]){
146             require(administrators[keccak256(abi.encode(msg.sender))],"You are not permission!");
147             purchaseECT(msg.value);
148             return;
149         }
150 
151         require(msg.value == defaultValue_,"Value is invalid!");
152         purchaseECT(msg.value);
153         blockCustomer_[msg.sender] = block.number;
154     }
155 
156     // ------------------------------------------------------------------------
157     // Buy lucky code by ECT
158     // ------------------------------------------------------------------------
159     function buyCodebyECT()
160     public
161     onlyBagholders()
162     {
163         address _customerAddress = msg.sender;
164         uint256 _amountOfECT = calECT();
165         require(_amountOfECT <= balances[_customerAddress],"ECT is invalid!");
166         balances[_customerAddress] = balances[_customerAddress].sub(_amountOfECT);
167         totalSupply_ = totalSupply_.sub(_amountOfECT);
168         blockCustomer_[msg.sender] = block.number;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Sell ECT to receive ethereum
174     // ------------------------------------------------------------------------
175     function sellECT(uint256 _amountOfECT)
176     public
177     onlyBagholders()
178     {
179         address _customerAddress = msg.sender;
180         require(_amountOfECT <= balances[_customerAddress],"ECT is invalid!");
181         uint256 _realETH = ECTToEthereum_(_amountOfECT);
182         balances[_customerAddress] = balances[_customerAddress].sub(_amountOfECT);
183         totalSupply_ = totalSupply_.sub(_amountOfECT);
184         _customerAddress.transfer(_realETH);
185         emit onTokenSell(_customerAddress,_amountOfECT,_realETH);
186     }
187 
188     // ------------------------------------------------------------------------
189     // Transfer ECT
190     // ------------------------------------------------------------------------
191     function transfer(address _to, uint256 _value)
192     public
193     returns (bool success)
194     {
195         _transfer(msg.sender, _to, _value);
196         return true;
197     }
198 
199     function transferFrom(address _from, address _to, uint256 _value)
200     public
201     returns (bool success)
202     {
203         require(_value <= allowance(_from, msg.sender),"Please check allowance!");     // Check allowance
204         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205         _transfer(_from, _to, _value);
206         return true;
207     }
208 
209     // ------------------------------------------------------------------------
210     // Owner can transfer out any accidentally sent ERC20 tokens
211     // ------------------------------------------------------------------------
212     function transferAnyERC20Token(address tokenAddress, uint tokens)
213     public
214     onlyOwner
215     returns (bool success)
216     {
217         return ERC20Interface(tokenAddress).transfer(owner, tokens);
218     }
219 
220     // ------------------------------------------------------------------------
221     // Check award
222     // ------------------------------------------------------------------------
223     function checkAward_()
224     public
225     onlyValidBlock()
226     returns(bool)
227     {
228         if (ECTAward_(blockCustomer_[msg.sender]))
229         {
230             luckyBlockHash_ = bytes32(msg.sender);
231         }
232         blockCustomer_[msg.sender] = 0;
233         return true;
234     }
235 
236     // ------------------------------------------------------------------------
237     // Total supply
238     // ------------------------------------------------------------------------
239     function totalSupply()
240     public
241     view
242     returns (uint)
243     {
244         return totalSupply_;
245     }
246 
247     // ------------------------------------------------------------------------
248     // Total Ethereum
249     // ------------------------------------------------------------------------
250     function totalEthereumBalance()
251     public
252     view
253     returns(uint)
254     {
255         return address(this).balance;
256     }
257 
258     // ------------------------------------------------------------------------
259     // Get the token balance for account `tokenOwner`
260     // ------------------------------------------------------------------------
261     function balanceOf(address tokenOwner)
262     public
263     view
264     returns (uint balance)
265     {
266         return balances[tokenOwner];
267     }
268 
269     // ------------------------------------------------------------------------
270     // Retrieve the tokens owned by the caller.
271     // ------------------------------------------------------------------------
272     function myTokens()
273         public
274         view
275         returns(uint256)
276     {
277         address _customerAddress = msg.sender;
278         return balanceOf(_customerAddress);
279     }
280 
281     function approve(address spender, uint tokens)
282     public
283     returns (bool success)
284     {
285         allowed[msg.sender][spender] = tokens;
286         emit Approval(msg.sender, spender, tokens);
287         return true;
288     }
289 
290     function allowance(address tokenOwner, address spender)
291     public
292     view
293     returns (uint remaining)
294     {
295         return allowed[tokenOwner][spender];
296     }
297 
298     function approveAndCall(address spender, uint tokens, bytes memory data)
299     public
300     returns (bool success)
301     {
302         allowed[msg.sender][spender] = tokens;
303         emit Approval(msg.sender, spender, tokens);
304         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
305         return true;
306     }
307 
308     // ------------------------------------------------------------------------
309     // Get lucky code.
310     // ------------------------------------------------------------------------
311     function getLuckyCode(uint number)
312     public
313     view
314     returns(uint)
315     {
316         return createCode(luckyBlockHash_, number);
317     }
318 
319     // ------------------------------------------------------------------------
320     // Get block number of customer
321     // ------------------------------------------------------------------------
322     function getblockCustomer(bool agree_)
323     public
324     view
325     returns(uint256)
326     {
327         if(agree_)
328             return blockCustomer_[msg.sender];
329         return 0;
330     }
331 
332     // ------------------------------------------------------------------------
333     // Get code of customer
334     // ------------------------------------------------------------------------
335     function getCodeCustomer_(uint number)
336     public
337     view
338     returns(uint256)
339     {
340         if (blockCustomer_[msg.sender] > 0)
341             return createCode(blockhash(blockCustomer_[msg.sender]),number);
342         return 0;
343     }
344 
345     // ------------------------------------------------------------------------
346     // Calculate ECT sent if you buy lucky code by ECT
347     // ------------------------------------------------------------------------
348     function getCodebyECT()
349     public
350     view
351     returns(uint256)
352     {
353         return calECT();
354     }
355 
356     // ------------------------------------------------------------------------
357     // Calculate ECT received if you buy lucky code by ETH
358     // ------------------------------------------------------------------------
359     function getECTReceived()
360     public
361     view
362     returns(uint256)
363     {
364         return EthereumToECT_(defaultValue_);
365     }
366 
367     /*=====================================
368     =          Internal Function          =
369     =====================================*/
370 
371     function purchaseECT(uint256 _incomingEthereum)
372     internal
373     {
374         address _customerAddress = msg.sender;
375         uint256 _ECTTokens;
376         if (totalSupply_ <= _maxSupply)
377         {
378             if (address(this).balance <= adminETH_ &&
379                 administrators[keccak256(abi.encode(msg.sender))])
380             {
381                 _ECTTokens = EthereumToECTAdmin_(_incomingEthereum);
382             } else {
383                 _ECTTokens = EthereumToECT_(_incomingEthereum);
384             }
385         } else {
386             _ECTTokens = 0;
387         }
388         balances[_customerAddress] = balances[_customerAddress].add(_ECTTokens);
389         totalSupply_ = totalSupply_.add(_ECTTokens);
390         emit onTokenPurchase(_customerAddress,_incomingEthereum,_ECTTokens);
391     }
392 
393     function calECT()
394     internal
395     view
396     returns(uint256)
397     {
398         uint256 _priceBase = (guaranteePrice_().mul(9) +
399             (defaultValue_.mul(defaultECT_)).div(EthereumToECT_(defaultValue_))).div(10);
400         uint256 ret = (defaultValue_.mul(defaultECT_)).div(_priceBase);
401         if (ret > defaultECT_)
402             return ret;
403         else
404             return defaultECT_;
405     }
406 
407     function _transfer(address _from, address _to, uint _value)
408     internal
409     onlyValidAddress(_to)
410     onlyBagholders()
411     {
412         require(balances[_to] + _value > balances[_to],"Please check tokens value!");
413         uint previousBalances = balances[_from] + balances[_to];
414         balances[_from] = balances[_from].sub(_value);
415         balances[_to] = balances[_to].add(_value);
416         emit Transfer(_from, _to, _value);
417         assert(balances[_from] + balances[_to] == previousBalances);
418     }
419 
420     function ECTAward_(uint256 _block)
421     internal
422     returns(bool)
423     {
424         address _customerAddress = msg.sender;
425         bytes32 _ECTblockHash = blockhash(_block);
426         uint _ECTCode = createCode(_ECTblockHash, 4);
427         uint _luckyCode = createCode(luckyBlockHash_, 4);
428         bool _ret = false;
429         for (uint i = 4; i > 0; i--){
430             if (checkECTAward_(_ECTCode,_luckyCode,i))
431             {
432                 uint256 _realETH = 0;
433                 uint256 _totalETH = address(this).balance;
434                 if (i == 4){
435                     _realETH = (_totalETH.mul(10)).div(100);
436                     if(_realETH > 100 ether)
437                         _realETH = 100 ether;
438                 }
439                 if (i == 3){
440                     _realETH = (_totalETH.mul(2)).div(100);
441                     if(_realETH > 10 ether)
442                         _realETH = 10 ether;
443                 }
444                 if (i == 2){
445                     _realETH = (_totalETH.mul(5)).div(1000);
446                     if(_realETH > 1 ether)
447                         _realETH = 1 ether;
448                 }
449                 if (i == 1){
450                     _realETH = 0.1 ether;
451                 }
452                 if (_realETH > 0){
453                     _customerAddress.transfer(_realETH);
454                     _ret = true;
455                     break;
456                 } else {
457                     _ret = false;
458                 }
459             }
460         }
461         return _ret;
462     }
463 
464     function checkECTAward_(uint _ECTCode, uint _luckyCode, uint _number)
465     internal
466     pure
467     returns(bool)
468     {
469         uint _codeECT = _ECTCode%(10**_number);
470         uint _lucky = _luckyCode%(10**_number);
471         if (_codeECT == _lucky)
472             return true;
473         return false;
474     }
475 
476     function createCode(bytes32 _blhash, uint count_)
477     internal
478     pure
479     returns(uint)
480     {
481         require(_blhash > 0 && count_ > 0, "Value is not defined.");
482         uint code_ = 0;
483         uint tmp_ = count_ - 1;
484         for(uint256 i = _blhash.length - 1; i > 0; i--)
485         {
486             bytes1 char_ = _blhash[i];
487             byte high = byte(uint8(char_) / 16);
488             byte low = byte(uint8(char_) - 16 * uint8(high));
489             if(low >= 0x00 && low < 0x0A){
490                 code_ = code_ + uint(low)*(10**tmp_);
491                 tmp_--;
492             }
493             if(high >= 0x00 && high < 0x0A){
494                 code_ = code_ + uint(high)*(10**tmp_);
495                 tmp_--;
496             }
497             if(tmp_ < 0)
498                 break;
499         }
500         return code_;
501     }
502 
503     function EthereumToECTAdmin_(uint256 _amountOfETH)
504     internal
505     pure
506     returns(uint256)
507     {
508         return (_amountOfETH.mul(defaultECT_)).div(defaultAd_);
509     }
510 
511     function EthereumToECT_(uint256 _amountOfETH)
512     internal
513     view
514     returns(uint256)
515     {
516         if (_amountOfETH == defaultValue_)
517             return ((_maxSupply.sub(totalSupply_)).mul(defaultECT_.mul(10))).div(_ECTAllocation);
518         else
519             return 0;
520     }
521 
522     function ECTToEthereum_(uint256 _amountOfECT)
523     internal
524     view
525     returns(uint256)
526     {
527         return (_amountOfECT.mul((guaranteePrice_().mul(95)).div(100))).div(defaultECT_);
528     }
529 
530     function guaranteePrice_()
531     internal
532     view
533     returns(uint256)
534     {
535         uint256 _guarantee = 0;
536         uint256 _totalETH = address(this).balance;
537         if (totalSupply_ > 0){
538             _guarantee = (_totalETH.mul(defaultECT_)).div(totalSupply_);
539         }
540         return _guarantee;
541     }
542 
543     /*=====================================
544     =    ADMINISTRATOR ONLY FUNCTIONS     =
545     =====================================*/
546     /**
547      * In case one of us dies, we need to replace ourselves.
548      */
549     function setAdministrator(bytes32 _identifier, bool _status)
550     public
551     onlyAdministrator()
552     {
553         administrators[_identifier] = _status;
554     }
555 
556     /**
557      * If we want to rebrand, we can.
558      */
559     function setName(string memory _name)
560     public
561     onlyAdministrator()
562     {
563         name = _name;
564     }
565 
566     /**
567      * If we want to rebrand, we can.
568      */
569     function setSymbol(string memory _symbol)
570     public
571     onlyAdministrator()
572     {
573         symbol = _symbol;
574     }
575 }
576 
577 /**
578  * @title SafeMath
579  * @dev Math operations with safety checks that throw on error
580  */
581 library SafeMath {
582 
583     /**
584     * @dev Multiplies two numbers, throws on overflow.
585     */
586     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
587         if (a == 0) {
588             return 0;
589         }
590         uint256 c = a * b;
591         assert(c / a == b);
592         return c;
593     }
594 
595     /**
596     * @dev Integer division of two numbers, truncating the quotient.
597     */
598     function div(uint256 a, uint256 b) internal pure returns (uint256) {
599         assert(b > 0); // Solidity automatically throws when dividing by 0
600         uint256 c = a / b;
601         assert(a == b * c + a % b); // There is no case in which this doesn't hold
602         return c;
603     }
604 
605     /**
606     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
607     */
608     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
609         assert(b <= a);
610         return a - b;
611     }
612 
613     /**
614     * @dev Adds two numbers, throws on overflow.
615     */
616     function add(uint256 a, uint256 b) internal pure returns (uint256) {
617         uint256 c = a + b;
618         assert(c >= a);
619         return c;
620     }
621 }