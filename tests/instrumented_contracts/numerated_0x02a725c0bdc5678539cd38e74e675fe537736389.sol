1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23     function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26     function approve(address spender, uint256 value) public returns (bool);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41      * @dev Multiplies two numbers, throws on overflow.
42      */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         c = a * b;
52         assert(c / a == b);
53         return c;
54     }
55 
56     /**
57      * @dev Integer division of two numbers, truncating the quotient.
58      */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         // uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return a / b;
64     }
65 
66     /**
67      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74     /**
75      * @dev Adds two numbers, throws on overflow.
76      */
77     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
78         c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 }
83 
84 /**
85  * @title SafeERC20
86  * @dev Wrappers around ERC20 operations that throw on failure.
87  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
88  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
89  */
90 library SafeERC20 {
91     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
92         require(token.transfer(to, value));
93     }
94 
95     function safeTransferFrom(
96         ERC20 token,
97         address from,
98         address to,
99         uint256 value
100     ) internal {
101         require(token.transferFrom(from, to, value));
102     }
103 
104     function safeApprove(ERC20 token, address spender, uint256 value) internal {
105         require(token.approve(spender, value));
106     }
107 }
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114     using SafeMath for uint256;
115 
116     mapping(address => uint256) balances;
117 
118     uint256 totalSupply_;
119 
120     /**
121      * @dev Total number of tokens in existence
122      */
123     function totalSupply() public view returns (uint256) {
124         return totalSupply_;
125     }
126 
127     /**
128      * @dev Transfer token for a specified address
129      * @param _to The address to transfer to.
130      * @param _value The amount to be transferred.
131      */
132     function transfer(address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[msg.sender]);
135 
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param _owner The address to query the the balance of.
145      * @return An uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address _owner) public view returns (uint256) {
148         return balances[_owner];
149     }
150 
151 }
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * https://github.com/ethereum/EIPs/issues/20
158  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162     mapping (address => mapping (address => uint256)) internal allowed;
163     /**
164      * @dev Transfer tokens from one address to another
165      * @param _from address The address which you want to send tokens from
166      * @param _to address The address which you want to transfer to
167      * @param _value uint256 the amount of tokens to be transferred
168      */
169     function transferFrom(
170         address _from,
171         address _to,
172         uint256 _value
173     ) public returns (bool) {
174         require(_to != address(0));
175         require(_value <= balances[_from]);
176         require(_value <= allowed[_from][msg.sender]);
177 
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181         emit Transfer(_from, _to, _value);
182         return true;
183     }
184 
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param _spender The address which will spend the funds.
193      * @param _value The amount of tokens to be spent.
194      */
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     /**
202      * @dev Function to check the amount of tokens that an owner allowed to a spender.
203      * @param _owner address The address which owns the funds.
204      * @param _spender address The address which will spend the funds.
205      * @return A uint256 specifying the amount of tokens still available for the spender.
206      */
207     function allowance(
208         address _owner,
209         address _spender
210     )
211     public
212     view
213     returns (uint256)
214     {
215         return allowed[_owner][_spender];
216     }
217 
218     /**
219      * @dev Increase the amount of tokens that an owner allowed to a spender.
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseApproval(
228         address _spender,
229         uint256 _addedValue
230     )
231     public
232     returns (bool)
233     {
234         allowed[msg.sender][_spender] = (
235         allowed[msg.sender][_spender].add(_addedValue));
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Decrease the amount of tokens that an owner allowed to a spender.
242      * approve should be called when allowed[_spender] == 0. To decrement
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      * @param _spender The address which will spend the funds.
247      * @param _subtractedValue The amount of tokens to decrease the allowance by.
248      */
249     function decreaseApproval(
250         address _spender,
251         uint256 _subtractedValue
252     )
253     public
254     returns (bool)
255     {
256         uint256 oldValue = allowed[msg.sender][_spender];
257         if (_subtractedValue > oldValue) {
258             allowed[msg.sender][_spender] = 0;
259         } else {
260             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261         }
262         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263         return true;
264     }
265 
266 }
267 
268 /**
269  * @title Ownable
270  * @dev The Ownable contract has an owner address, and provides basic authorization control
271  * functions, this simplifies the implementation of "user permissions".
272  */
273 contract Ownable {
274     address public owner;
275 
276 
277     event OwnershipRenounced(address indexed previousOwner);
278     event OwnershipTransferred(
279         address indexed previousOwner,
280         address indexed newOwner
281     );
282 
283 
284     /**
285      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
286      * account.
287      */
288     constructor() public {
289         owner = msg.sender;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(msg.sender == owner);
297         _;
298     }
299 
300     /**
301      * @dev Allows the current owner to relinquish control of the contract.
302      * @notice Renouncing to ownership will leave the contract without an owner.
303      * It will not be possible to call the functions with the `onlyOwner`
304      * modifier anymore.
305      */
306     function renounceOwnership() public onlyOwner {
307         emit OwnershipRenounced(owner);
308         owner = address(0);
309     }
310 
311     /**
312      * @dev Allows the current owner to transfer control of the contract to a newOwner.
313      * @param _newOwner The address to transfer ownership to.
314      */
315     function transferOwnership(address _newOwner) public onlyOwner {
316         _transferOwnership(_newOwner);
317     }
318 
319     /**
320      * @dev Transfers control of the contract to a newOwner.
321      * @param _newOwner The address to transfer ownership to.
322      */
323     function _transferOwnership(address _newOwner) internal {
324         require(_newOwner != address(0));
325         emit OwnershipTransferred(owner, _newOwner);
326         owner = _newOwner;
327     }
328 }
329 
330 /**
331  * @title Mintable token
332  * @dev Simple ERC20 Token example, with mintable token creation
333  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
334  */
335 contract MintableToken is StandardToken, Ownable {
336     event Mint(address indexed to, uint256 amount);
337     event MintFinished();
338 
339     bool public mintingFinished = false;
340     address public own_contract;
341 
342 
343     function setCrowdsaleAddress(address _address) onlyOwner public{
344         own_contract = _address;
345     }
346     
347     modifier canMint() {
348         require(!mintingFinished);
349         _;
350     }
351 
352     modifier hasMintPermission() {
353         require(msg.sender == own_contract);
354         _;
355     }
356 
357     /**
358      * @dev Function to mint tokens
359      * @param _to The address that will receive the minted tokens.
360      * @param _amount The amount of tokens to mint.
361      * @return A boolean that indicates if the operation was successful.
362      */
363     function mint(
364         address _to,
365         uint256 _amount
366     )
367     hasMintPermission
368     canMint
369     public
370     returns (bool)
371     {
372         totalSupply_ = totalSupply_.add(_amount);
373         balances[_to] = balances[_to].add(_amount);
374         emit Mint(_to, _amount);
375         emit Transfer(address(0), _to, _amount);
376         emit Transfer(owner, _to, _amount);
377         return true;
378     }
379 
380     /**
381      * @dev Function to stop minting new tokens.
382      * @return True if the operation was successful.
383      */
384     function finishMinting() onlyOwner canMint public returns (bool) {
385         mintingFinished = true;
386         emit MintFinished();
387         return true;
388     }
389 }
390 
391 /**
392  * @title Pausable
393  * @dev Base contract which allows children to implement an emergency stop mechanism.
394  */
395 contract Pausable is Ownable {
396     event Pause();
397     event Unpause();
398 
399     bool public paused = false;
400 
401 
402     /**
403      * @dev Modifier to make a function callable only when the contract is not paused.
404      */
405     modifier whenNotPaused() {
406         require(!paused);
407         _;
408     }
409 
410     /**
411      * @dev Modifier to make a function callable only when the contract is paused.
412      */
413     modifier whenPaused() {
414         require(paused);
415         _;
416     }
417 
418     /**
419      * @dev called by the owner to pause, triggers stopped state
420      */
421     function pause() onlyOwner whenNotPaused public {
422         paused = true;
423         emit Pause();
424     }
425 
426     /**
427      * @dev called by the owner to unpause, returns to normal state
428      */
429     function unpause() onlyOwner whenPaused public {
430         paused = false;
431         emit Unpause();
432     }
433 }
434 
435 /**
436  * @title Crowdsale
437  * @dev Crowdsale is a base contract for managing a token crowdsale,
438  * allowing investors to purchase tokens with ether. This contract implements
439  * such functionality in its most fundamental form and can be extended to provide additional
440  * functionality and/or custom behavior.
441  * The external interface represents the basic interface for purchasing tokens, and conform
442  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
443  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
444  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
445  * behavior.
446  */
447 contract Crowdsale is Pausable {
448     using SafeMath for uint256;
449     using SafeERC20 for IQBankToken;
450 
451     // The token being sold
452     IQBankToken public token;
453 
454     // Address where funds are collected
455     address public wallet;
456 
457     // How many token units a buyer gets per wei.
458     // The rate is the conversion between wei and the smallest and indivisible token unit.
459     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
460     // 1 wei will give you 1 unit, or 0.001 TOK.
461     uint256 public rate;
462 
463     // Ïðîöåíò áîíóñà
464     uint public bonusPercent = 0;
465 
466     // Amount of wei raised
467     uint256 public weiRaised;
468 
469     /**
470      * Event for token purchase logging
471      * @param purchaser who paid for the tokens
472      * @param beneficiary who got the tokens
473      * @param value weis paid for purchase
474      * @param amount amount of tokens purchased
475      */
476     event TokenPurchase(
477         address indexed purchaser,
478         address indexed beneficiary,
479         uint256 value,
480         uint256 amount
481     );
482 
483     /**
484      * @param _rate Number of token units a buyer gets per wei
485      * @param _wallet Address where collected funds will be forwarded to
486      * @param _token Address of the token being sold
487      */
488     constructor(uint256 _rate, address _wallet, IQBankToken _token) public {
489         require(_rate > 0);
490         require(_wallet != address(0));
491         require(_token != address(0));
492 
493         rate = _rate;
494         wallet = _wallet;
495         token = _token;
496     }
497 
498     // -----------------------------------------
499     // Crowdsale external interface
500     // -----------------------------------------
501 
502     /**
503      * @dev fallback function ***DO NOT OVERRIDE***
504      */
505     function () external whenNotPaused payable {
506         buyTokens(msg.sender);
507     }
508 
509     /**
510      * @dev low level token purchase ***DO NOT OVERRIDE***
511      * @param _beneficiary Address performing the token purchase
512      */
513     function buyTokens(address _beneficiary) public whenNotPaused payable {
514 
515         uint256 weiAmount = msg.value;
516         _preValidatePurchase(_beneficiary, weiAmount);
517 
518         // calculate token amount to be created
519         uint256 tokens = _getTokenAmount(weiAmount);
520 
521         // update state
522         weiRaised = weiRaised.add(weiAmount);
523 
524         _processPurchase(_beneficiary, tokens);
525         emit TokenPurchase(
526             msg.sender,
527             _beneficiary,
528             weiAmount,
529             tokens
530         );
531 
532         _updatePurchasingState(_beneficiary, weiAmount);
533 
534         _forwardFunds();
535         _postValidatePurchase(_beneficiary, weiAmount);
536     }
537 
538     // -----------------------------------------
539     // Internal interface (extensible)
540     // -----------------------------------------
541 
542     /**
543      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
544      * @param _beneficiary Address performing the token purchase
545      * @param _weiAmount Value in wei involved in the purchase
546      */
547     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
548         require(_beneficiary != address(0));
549         require(_weiAmount != 0);
550     }
551 
552     /**
553      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
554      * @param _beneficiary Address performing the token purchase
555      * @param _weiAmount Value in wei involved in the purchase
556      */
557     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
558         // optional override
559     }
560 
561     /**
562      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
563      * @param _beneficiary Address performing the token purchase
564      * @param _tokenAmount Number of tokens to be emitted
565      */
566     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
567         token.safeTransfer(_beneficiary, _tokenAmount);
568     }
569 
570     /**
571      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
572      * @param _beneficiary Address receiving the tokens
573      * @param _tokenAmount Number of tokens to be purchased
574      */
575     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
576         _deliverTokens(_beneficiary, _tokenAmount);
577     }
578 
579     /**
580      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
581      * @param _beneficiary Address receiving the tokens
582      * @param _weiAmount Value in wei involved in the purchase
583      */
584     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
585         // optional override
586     }
587 
588     /**
589      * @dev Override to extend the way in which ether is converted to tokens.
590      * @param _weiAmount Value in wei to be converted into tokens
591      * @return Number of tokens that can be purchased with the specified _weiAmount
592      */
593     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
594         return _weiAmount.mul(rate).mul(100 + bonusPercent).div(100);
595     }
596 
597     /**
598      * @dev Determines how ETH is stored/forwarded on purchases.
599      */
600     function _forwardFunds() internal {
601         wallet.transfer(msg.value);
602     }
603 }
604 
605 // Êîíòðàêò òîêåíà (íàñëåäóåòñÿ îò ñòàíäàðòíîãî StandardToken)
606 contract IQBankToken is MintableToken {
607     string public constant name = "IQ Bank token"; // solium-disable-line uppercase
608     string public constant symbol = "IQTK"; // solium-disable-line uppercase
609     uint8 public constant decimals = 18; // solium-disable-line uppercase
610 
611     uint256 public constant LIMIT_SUPPLY = 30 * (10 ** (6 + uint256(decimals))); // max 30 mln IQTK
612 }
613 
614 // Êîíòðàêò ICO (íàñëåäóåòñÿ îò ñòàíäàðòíîãî Crowdlase è Ownable)
615 contract IQTKCrowdsale is Crowdsale {
616 
617     // Ìèíèìàëüíàÿ èíâåñòèöèÿ 0.01 eth
618     uint public constant MIN_INVEST_ETHER = 10 finney;
619 
620     // Íîìåð ýòàïà ICO
621     uint public stage = 0;
622 
623     // ICO ôèíàëèçèðîâàí
624     bool isFinalized = false;
625 
626     // Àäðåñà èíâåñòîðîâ è èõ áàëàíñîâ
627     mapping(address => uint256) public balances;
628 
629     mapping(address => uint) public parts;
630 
631     // Êîëè÷åñòâî òîêåíîâ, êîòîðûå ïðåäñòîèò âûïóñòèòü
632     uint256 public tokensIssued;
633 
634     /**
635      * Event for token withdrawal logging
636      * @param receiver who receive the tokens
637      * @param amount amount of tokens sent
638      */
639     event TokenDelivered(address indexed receiver, uint256 amount);
640 
641     /**
642      * Event for token adding by referral program
643      * @param beneficiary who got the tokens
644      * @param amount amount of tokens added
645      */
646     event TokenAdded(address indexed beneficiary, uint256 amount);
647 
648     // Ìîäèôèêàòîðû äëÿ ôóíêöèé:
649     // Ôóíêöèÿ âûïîëíèòñÿ, åñëè ICO íå çàâåðøåíî
650     modifier NotFinalized() {
651         require(!isFinalized, "Can't process. Crowdsale is finalized");    // Ïðîâåðêà
652         _; // Çàïóñê òåëà ôóíêöèè
653     }
654 
655     // Ôóíêöèÿ âûïîëíèòñÿ, åñëè ICO çàâåðøåíî
656     modifier Finalized() {
657         require(isFinalized, "Can't process. Crowdsale is not finalized"); // Ïðîâåðêà
658         _; // Çàïóñê òåëà ôóíêöèè
659     }
660 
661     /**
662      * Êîíñòðóêòîð ICO
663      * @param _rate Öåíà òîêåíà çà îäèí wei
664      * @param _wallet Àäðåñ êóäà áóäåò ñêëàäûâàòüñÿ ýôèð
665      * @param _token Àäðåñ êîíòðàêòà ñ òîêåíîì
666      */
667     constructor(uint256 _rate, address _wallet, IQBankToken _token) Crowdsale(_rate, _wallet, _token) public {
668         paused = true; // Ïî óìîë÷àíèþ ICO íà ïàóçå
669     }
670 
671     // -----------------------------------------
672     // Ïåðåãðóæåííûå ôóíêöèè èç PausableCrowdsale
673     // -----------------------------------------
674 
675     // Ñòàðòóåì î÷åðåäíîé ýòàï ICO (äëÿ: òîëüêî âëàäåëåö, ICO íà ïàóçå)
676     function unpause(uint _stage, uint _bonusPercent) onlyOwner whenPaused public {
677         super.unpause(); // äåðãàåì ðîäèòåëüñêóþ ôóíêöèþ êîòîðàÿ ñòàâèò ñàì ôëàã ïàóçû â Ëîæü
678         stage = _stage;
679         bonusPercent = _bonusPercent;
680     }
681 
682     /**
683      * @dev Withdraw tokens only after crowdsale ends.
684      */
685     function withdrawTokens() Finalized public {
686         _withdrawTokensFor(msg.sender);
687     }
688 
689     /**
690      * @dev Add tokens for specified beneficiary (referral system tokens, for example).
691      * @param _beneficiary Token purchaser
692      * @param _tokenAmount Amount of tokens added
693      */
694     function addTokens(address _beneficiary, uint256 _tokenAmount) onlyOwner NotFinalized public {
695         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
696         tokensIssued = tokensIssued.add(_tokenAmount);
697         emit TokenAdded(_beneficiary, _tokenAmount);
698     }
699 
700     /**
701      * Çàêðûâàåì ICO, ðàññ÷èòûâàåì ïðîöåíòû äîëüùèêàì
702      * @dev Must be called after crowdsale ends, to do some extra finalization
703      * work. Calls the contract's finalization function.
704      */
705     function finalize() onlyOwner NotFinalized public {
706         isFinalized = true;
707     }
708 
709     // Validation
710     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
711         super._preValidatePurchase(_beneficiary, _weiAmount);
712         require(msg.value >= MIN_INVEST_ETHER, "Minimal invest 0.1 ETH"); // Don't accept funding under a predefined threshold
713     }
714 
715     /**
716      * @dev Withdraw tokens for receiver_ after crowdsale ends.
717      */
718     function _withdrawTokensFor(address receiver_) internal {
719         uint256 amount = balances[receiver_];
720         require(amount > 0);
721         balances[receiver_] = 0;
722         emit TokenDelivered(receiver_, amount);
723         _deliverTokens(receiver_, amount);
724     }
725 
726     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
727         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
728     }
729 
730     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
731         token.mint(_beneficiary, _tokenAmount);
732     }
733 }