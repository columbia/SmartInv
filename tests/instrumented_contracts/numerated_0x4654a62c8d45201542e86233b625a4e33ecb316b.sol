1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract Ownable {
37 
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66     }
67 }
68 
69 /**
70  * @title Finalizable
71  * @dev Base contract to finalize some features
72  */
73 contract Finalizable is Ownable {
74     event Finish();
75 
76     bool public finalized = false;
77 
78     function finalize() public onlyOwner {
79         finalized = true;
80     }
81 
82     modifier notFinalized() {
83         require(!finalized);
84         _;
85     }
86 }
87 
88 /**
89  * @title Part of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract IToken {
93     function balanceOf(address who) public view returns (uint256);
94 
95     function transfer(address to, uint256 value) public returns (bool);
96 }
97 
98 /**
99  * @title Token Receivable
100  * @dev Support transfer of ERC20 tokens out of this contract's address
101  * @dev Even if we don't intend for people to send them here, somebody will
102  */
103 contract TokenReceivable is Ownable {
104     event logTokenTransfer(address token, address to, uint256 amount);
105 
106     function claimTokens(address _token, address _to) public onlyOwner returns (bool) {
107         IToken token = IToken(_token);
108         uint256 balance = token.balanceOf(this);
109         if (token.transfer(_to, balance)) {
110             emit logTokenTransfer(_token, _to, balance);
111             return true;
112         }
113         return false;
114     }
115 }
116 
117 contract EventDefinitions {
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120     event Mint(address indexed to, uint256 amount);
121     event Burn(address indexed burner, uint256 value);
122 }
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract Token is Finalizable, TokenReceivable, EventDefinitions {
132     using SafeMath for uint256;
133 
134     string public name = "FairWin Token";
135     uint8 public decimals = 8;
136     string public symbol = "FWIN";
137 
138     Controller controller;
139 
140     // message of the day
141     string public motd;
142 
143     function setController(address _controller) public onlyOwner notFinalized {
144         controller = Controller(_controller);
145     }
146 
147     modifier onlyController() {
148         require(msg.sender == address(controller));
149         _;
150     }
151 
152     modifier onlyPayloadSize(uint256 numwords) {
153         assert(msg.data.length >= numwords * 32 + 4);
154         _;
155     }
156 
157     /**
158      * @dev Gets the balance of the specified address.
159      * @param _owner The address to query the the balance of.
160      * @return An uint256 representing the amount owned by the passed address.
161      */
162     function balanceOf(address _owner) public view returns (uint256) {
163         return controller.balanceOf(_owner);
164     }
165 
166     function totalSupply() public view returns (uint256) {
167         return controller.totalSupply();
168     }
169 
170     /**
171      * @dev transfer token for a specified address
172      * @param _to The address to transfer to.
173      * @param _value The amount to be transferred.
174      */
175     function transfer(address _to, uint256 _value) public
176     onlyPayloadSize(2)
177     returns (bool success) {
178         success = controller.transfer(msg.sender, _to, _value);
179         if (success) {
180             emit Transfer(msg.sender, _to, _value);
181         }
182     }
183 
184     /**
185      * @dev Transfer tokens from one address to another
186      * @param _from address The address which you want to send tokens from
187      * @param _to address The address which you want to transfer to
188      * @param _value uint256 the amount of tokens to be transferred
189      */
190     function transferFrom(address _from, address _to, uint256 _value) public
191     onlyPayloadSize(3)
192     returns (bool success) {
193         success = controller.transferFrom(msg.sender, _from, _to, _value);
194         if (success) {
195             emit Transfer(_from, _to, _value);
196         }
197     }
198 
199     /**
200      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201      *
202      * Beware that changing an allowance with this method brings the risk that someone may use both the old
203      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      * @param _spender The address which will spend the funds.
207      * @param _value The amount of tokens to be spent.
208      */
209     function approve(address _spender, uint256 _value) public
210     onlyPayloadSize(2)
211     returns (bool success) {
212         //promote safe user behavior
213         require(controller.allowance(msg.sender, _spender) == 0);
214 
215         success = controller.approve(msg.sender, _spender, _value);
216         if (success) {
217             emit Approval(msg.sender, _spender, _value);
218         }
219         return true;
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      *
225      * approve should be called when allowed[_spender] == 0. To increment
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * @param _spender The address which will spend the funds.
230      * @param _addedValue The amount of tokens to increase the allowance by.
231      */
232     function increaseApproval(address _spender, uint256 _addedValue) public
233     onlyPayloadSize(2)
234     returns (bool success) {
235         success = controller.increaseApproval(msg.sender, _spender, _addedValue);
236         if (success) {
237             uint256 newValue = controller.allowance(msg.sender, _spender);
238             emit Approval(msg.sender, _spender, newValue);
239         }
240     }
241 
242     /**
243      * @dev Decrease the amount of tokens that an owner allowed to a spender.
244      *
245      * approve should be called when allowed[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * @param _spender The address which will spend the funds.
250      * @param _subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseApproval(address _spender, uint _subtractedValue) public
253     onlyPayloadSize(2)
254     returns (bool success) {
255         success = controller.decreaseApproval(msg.sender, _spender, _subtractedValue);
256         if (success) {
257             uint newValue = controller.allowance(msg.sender, _spender);
258             emit Approval(msg.sender, _spender, newValue);
259         }
260     }
261 
262     /**
263      * @dev Function to check the amount of tokens that an owner allowed to a spender.
264      * @param _owner address The address which owns the funds.
265      * @param _spender address The address which will spend the funds.
266      * @return A uint256 specifying the amount of tokens still available for the spender.
267      */
268     function allowance(address _owner, address _spender) public view returns (uint256) {
269         return controller.allowance(_owner, _spender);
270     }
271 
272     /**
273      * @dev Burns a specific amount of tokens.
274      * @param _amount The amount of token to be burned.
275      */
276     function burn(uint256 _amount) public
277     onlyPayloadSize(1)
278     {
279         bool success = controller.burn(msg.sender, _amount);
280         if (success) {
281             emit Burn(msg.sender, _amount);
282         }
283     }
284 
285     function controllerTransfer(address _from, address _to, uint256 _value) public onlyController {
286         emit Transfer(_from, _to, _value);
287     }
288 
289     function controllerApprove(address _owner, address _spender, uint256 _value) public onlyController {
290         emit Approval(_owner, _spender, _value);
291     }
292 
293     function controllerBurn(address _burner, uint256 _value) public onlyController {
294         emit Burn(_burner, _value);
295     }
296 
297     function controllerMint(address _to, uint256 _value) public onlyController {
298         emit Mint(_to, _value);
299     }
300 
301     event Motd(string message);
302 
303     function setMotd(string _motd) public onlyOwner {
304         motd = _motd;
305         emit Motd(_motd);
306     }
307 }
308 
309 contract Controller is Finalizable {
310 
311     Ledger public ledger;
312     Token public token;
313     address public sale;
314 
315     constructor (address _token, address _ledger) public {
316         require(_token != 0);
317         require(_ledger != 0);
318 
319         ledger = Ledger(_ledger);
320         token = Token(_token);
321     }
322 
323     function setToken(address _token) public onlyOwner {
324         token = Token(_token);
325     }
326 
327     function setLedger(address _ledger) public onlyOwner {
328         ledger = Ledger(_ledger);
329     }
330 
331     function setSale(address _sale) public onlyOwner {
332         sale = _sale;
333     }
334 
335     modifier onlyToken() {
336         require(msg.sender == address(token));
337         _;
338     }
339 
340     modifier onlyLedger() {
341         require(msg.sender == address(ledger));
342         _;
343     }
344 
345     modifier onlySale() {
346         require(msg.sender == sale);
347         _;
348     }
349 
350     function totalSupply() public onlyToken view returns (uint256) {
351         return ledger.totalSupply();
352     }
353 
354     function balanceOf(address _a) public onlyToken view returns (uint256) {
355         return ledger.balanceOf(_a);
356     }
357 
358     function allowance(address _owner, address _spender) public onlyToken view returns (uint256) {
359         return ledger.allowance(_owner, _spender);
360     }
361 
362     function transfer(address _from, address _to, uint256 _value) public
363     onlyToken
364     returns (bool) {
365         return ledger.transfer(_from, _to, _value);
366     }
367 
368     function transferFrom(address _spender, address _from, address _to, uint256 _value) public
369     onlyToken
370     returns (bool) {
371         return ledger.transferFrom(_spender, _from, _to, _value);
372     }
373 
374     function burn(address _owner, uint256 _amount) public
375     onlyToken
376     returns (bool) {
377         return ledger.burn(_owner, _amount);
378     }
379 
380     function approve(address _owner, address _spender, uint256 _value) public
381     onlyToken
382     returns (bool) {
383         return ledger.approve(_owner, _spender, _value);
384     }
385 
386     function increaseApproval(address _owner, address _spender, uint256 _addedValue) public
387     onlyToken
388     returns (bool) {
389         return ledger.increaseApproval(_owner, _spender, _addedValue);
390     }
391 
392     function decreaseApproval(address _owner, address _spender, uint256 _subtractedValue) public
393     onlyToken
394     returns (bool) {
395         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
396     }
397 
398     function proxyMint(address _to, uint256 _value) public onlySale {
399         token.controllerMint(_to, _value);
400     }
401 
402     function proxyTransfer(address _from, address _to, uint256 _value) public onlySale {
403         token.controllerTransfer(_from, _to, _value);
404     }
405 }
406 
407 contract PreSale is Finalizable {
408     using SafeMath for uint256;
409 
410     Ledger public ledger;
411     Controller public controller;
412 
413     // Address where funds are collected
414     address public wallet;
415 
416     // How many token units a buyer gets per wei.
417     // The rate is the conversion between wei and the smallest and indivisible token unit.
418     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
419     // 1 wei will give you 1 unit, or 0.001 TOK.
420     uint256 public rate;
421 
422     // Amount of wei raised
423     uint256 public weiRaised;
424 
425     /**
426      * Event for token purchase logging
427      * @param purchaser who paid for the tokens
428      * @param beneficiary who got the tokens
429      * @param value weis paid for purchase
430      * @param amount amount of tokens purchased
431      */
432     event TokenPurchase(
433         address indexed purchaser,
434         address indexed beneficiary,
435         uint256 value,
436         uint256 amount
437     );
438 
439     /**
440      * @param _rate Number of token units a buyer gets per wei
441      * @param _wallet Address where collected funds will be forwarded to
442      */
443     constructor(uint256 _rate, address _wallet, address _ledger, address _controller) public {
444         require(_rate > 0);
445         require(_wallet != address(0));
446         require(_ledger != address(0));
447         require(_controller != address(0));
448 
449         rate = _rate;
450         wallet = _wallet;
451         ledger = Ledger(_ledger);
452         controller = Controller(_controller);
453     }
454 
455     function setRate(uint256 _rate) public notFinalized onlyOwner {
456         require(_rate > 0);
457         rate = _rate;
458     }
459 
460     function () external payable {
461         buyTokens(msg.sender);
462     }
463 
464     function buyTokens(address _beneficiary) public notFinalized payable {
465 
466         uint256 weiAmount = msg.value;
467         require(_beneficiary != address(0));
468         require(weiAmount != 0);
469 
470         // calculate token amount to be created
471         uint256 tokens = weiAmount.mul(rate).div(10 ** 10);
472 
473         // update state
474         weiRaised = weiRaised.add(weiAmount);
475 
476         // mint tokens
477         ledger.mint(_beneficiary, tokens);
478 
479         // emit token event
480         controller.proxyMint(_beneficiary, tokens);
481         controller.proxyTransfer(0, _beneficiary, tokens);
482 
483         emit TokenPurchase(
484             msg.sender,
485             _beneficiary,
486             weiAmount,
487             tokens
488         );
489 
490         _forwardFunds();
491     }
492 
493     function _forwardFunds() internal {
494         wallet.transfer(msg.value);
495     }
496 }
497 
498 contract Ledger is Finalizable {
499     using SafeMath for uint256;
500 
501     address public controller;
502     address public sale;
503 
504     mapping(address => uint256) internal balances;
505     mapping(address => mapping(address => uint256)) internal allowed;
506     uint256 internal totalSupply_;
507     bool public mintFinished = false;
508 
509     event Mint(address indexed to, uint256 amount);
510     event MintFinished();
511 
512     function setController(address _controller) public onlyOwner notFinalized {
513         controller = _controller;
514     }
515 
516     function setSale(address _sale) public onlyOwner notFinalized {
517         sale = _sale;
518     }
519 
520     modifier onlyController() {
521         require(msg.sender == controller);
522         _;
523     }
524 
525     modifier canMint() {
526         require(!mintFinished);
527         _;
528     }
529 
530     function finishMint() public onlyOwner canMint {
531         mintFinished = true;
532         emit MintFinished();
533     }
534 
535     /**
536      * @dev Gets the balance of the specified address.
537      * @param _owner The address to query the the balance of.
538      * @return An uint256 representing the amount owned by the passed address.
539      */
540     function balanceOf(address _owner) public view returns (uint256) {
541         return balances[_owner];
542     }
543 
544     /**
545      * @dev total number of tokens in existence
546      */
547     function totalSupply() public view returns (uint256) {
548         return totalSupply_;
549     }
550 
551     /**
552      * @dev Function to check the amount of tokens that an owner allowed to a spender.
553      * @param _owner address The address which owns the funds.
554      * @param _spender address The address which will spend the funds.
555      * @return A uint256 specifying the amount of tokens still available for the spender.
556      */
557     function allowance(address _owner, address _spender) public view returns (uint256) {
558         return allowed[_owner][_spender];
559     }
560 
561     /**
562      * @dev transfer token for a specified address
563      * @param _from msg.sender from controller.
564      * @param _to The address to transfer to.
565      * @param _value The amount to be transferred.
566      */
567     function transfer(address _from, address _to, uint256 _value) public onlyController returns (bool) {
568         require(_to != address(0));
569         require(_value <= balances[_from]);
570 
571         // SafeMath.sub will throw if there is not enough balance.
572         balances[_from] = balances[_from].sub(_value);
573         balances[_to] = balances[_to].add(_value);
574         return true;
575     }
576 
577     /**
578      * @dev Transfer tokens from one address to another
579      * @param _from address The address which you want to send tokens from
580      * @param _to address The address which you want to transfer to
581      * @param _value uint256 the amount of tokens to be transferred
582      */
583     function transferFrom(address _spender, address _from, address _to, uint256 _value) public onlyController returns (bool) {
584         uint256 allow = allowed[_from][_spender];
585         require(_to != address(0));
586         require(_value <= balances[_from]);
587         require(_value <= allow);
588 
589         balances[_from] = balances[_from].sub(_value);
590         balances[_to] = balances[_to].add(_value);
591         allowed[_from][_spender] = allow.sub(_value);
592         return true;
593     }
594 
595     /**
596      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
597      *
598      * Beware that changing an allowance with this method brings the risk that someone may use both the old
599      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
600      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
601      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
602      * @param _spender The address which will spend the funds.
603      * @param _value The amount of tokens to be spent.
604      */
605     function approve(address _owner, address _spender, uint256 _value) public onlyController returns (bool) {
606         //require user to set to zero before resetting to nonzero
607         if ((_value != 0) && (allowed[_owner][_spender] != 0)) {
608             return false;
609         }
610 
611         allowed[_owner][_spender] = _value;
612         return true;
613     }
614 
615     /**
616      * @dev Increase the amount of tokens that an owner allowed to a spender.
617      *
618      * approve should be called when allowed[_spender] == 0. To increment
619      * allowed value is better to use this function to avoid 2 calls (and wait until
620      * the first transaction is mined)
621      * From MonolithDAO Token.sol
622      * @param _spender The address which will spend the funds.
623      * @param _addedValue The amount of tokens to increase the allowance by.
624      */
625     function increaseApproval(address _owner, address _spender, uint256 _addedValue) public onlyController returns (bool) {
626         allowed[_owner][_spender] = allowed[_owner][_spender].add(_addedValue);
627         return true;
628     }
629 
630     /**
631      * @dev Decrease the amount of tokens that an owner allowed to a spender.
632      *
633      * approve should be called when allowed[_spender] == 0. To decrement
634      * allowed value is better to use this function to avoid 2 calls (and wait until
635      * the first transaction is mined)
636      * From MonolithDAO Token.sol
637      * @param _spender The address which will spend the funds.
638      * @param _subtractedValue The amount of tokens to decrease the allowance by.
639      */
640     function decreaseApproval(address _owner, address _spender, uint256 _subtractedValue) public onlyController returns (bool) {
641         uint256 oldValue = allowed[_owner][_spender];
642         if (_subtractedValue > oldValue) {
643             allowed[_owner][_spender] = 0;
644         } else {
645             allowed[_owner][_spender] = oldValue.sub(_subtractedValue);
646         }
647         return true;
648     }
649 
650     /**
651      * @dev Burns a specific amount of tokens.
652      * @param _amount The amount of token to be burned.
653      */
654     function burn(address _burner, uint256 _amount) public onlyController returns (bool) {
655         require(balances[_burner] >= _amount);
656         // no need to require _amount <= totalSupply, since that would imply the
657         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
658 
659         balances[_burner] = balances[_burner].sub(_amount);
660         totalSupply_ = totalSupply_.sub(_amount);
661         return true;
662     }
663 
664     /**
665      * @dev Function to mint tokens
666      * @param _to The address that will receive the minted tokens.
667      * @param _amount The amount of tokens to mint.
668      * @return A boolean that indicates if the operation was successful.
669      */
670     function mint(address _to, uint256 _amount) public canMint returns (bool) {
671         require(msg.sender == controller || msg.sender == sale || msg.sender == owner);
672         totalSupply_ = totalSupply_.add(_amount);
673         balances[_to] = balances[_to].add(_amount);
674         emit Mint(_to, _amount);
675         return true;
676     }
677 }