1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Read-only ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ReadOnlyToken {
8     uint256 public totalSupply;
9     function balanceOf(address who) public constant returns (uint256);
10     function allowance(address owner, address spender) public constant returns (uint256);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract Token is ReadOnlyToken {
18   function transfer(address to, uint256 value) public returns (bool);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract MintableToken is Token {
26     event Mint(address indexed to, uint256 amount);
27 
28     function mint(address _to, uint256 _amount) public returns (bool);
29 }
30 
31 /**
32  * @title Sale contract for Daonomic platform should implement this
33  */
34 contract Sale {
35     /**
36      * @dev This event should be emitted when user buys something
37      */
38     event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus);
39     /**
40      * @dev Should be emitted if new payment method added
41      */
42     event RateAdd(address token);
43     /**
44      * @dev Should be emitted if payment method removed
45      */
46     event RateRemove(address token);
47 
48     /**
49      * @dev Calculate rate for specified payment method
50      */
51     function getRate(address token) constant public returns (uint256);
52     /**
53      * @dev Calculate current bonus in tokens
54      */
55     function getBonus(uint256 sold) constant public returns (uint256);
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  * @dev this version copied from zeppelin-solidity, constant changed to pure
62  */
63 library SafeMath {
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         assert(c / a == b);
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // assert(b > 0); // Solidity automatically throws when dividing by 0
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 /**
93  * @title Ownable
94  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
95  */
96 contract Ownable {
97     modifier onlyOwner() {
98         checkOwner();
99         _;
100     }
101 
102     function checkOwner() internal;
103 }
104 
105 /**
106  * @title Token represents some external value (for example, BTC)
107  */
108 contract ExternalToken is Token {
109     event Mint(address indexed to, uint256 value, bytes data);
110     event Burn(address indexed burner, uint256 value, bytes data);
111 
112     function burn(uint256 _value, bytes _data) public;
113 }
114 
115 /**
116  * @dev This adapter helps to receive tokens. It has some subcontracts for different tokens:
117  *   ERC20ReceiveAdapter - for receiving simple ERC20 tokens
118  *   ERC223ReceiveAdapter - for receiving ERC223 tokens
119  *   ReceiveApprovalAdapter - for receiving ERC20 tokens when token notifies receiver with receiveApproval
120  *   EtherReceiveAdapter - for receiving ether (onReceive callback will be used). this is needed for handling ether like tokens
121  *   CompatReceiveApproval - implements all these adapters
122  */
123 contract ReceiveAdapter {
124 
125     /**
126      * @dev Receive tokens from someone. Owner of the tokens should approve first
127      */
128     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal;
129 }
130 
131 /**
132  * @dev Helps to receive ERC20-complaint tokens. Owner should call token.approve first
133  */
134 contract ERC20ReceiveAdapter is ReceiveAdapter {
135     function receive(address _token, uint256 _value, bytes _data) public {
136         Token token = Token(_token);
137         token.transferFrom(msg.sender, this, _value);
138         onReceive(_token, msg.sender, _value, _data);
139     }
140 }
141 
142 /**
143  * @title ERC223 TokenReceiver interface
144  * @dev see https://github.com/ethereum/EIPs/issues/223
145  */
146 contract TokenReceiver {
147     function onTokenTransfer(address _from, uint256 _value, bytes _data) public;
148 }
149 
150 /**
151  * @dev Helps to receive ERC223-complaint tokens. ERC223 Token contract should notify receiver.
152  */
153 contract ERC223ReceiveAdapter is TokenReceiver, ReceiveAdapter {
154     function tokenFallback(address _from, uint256 _value, bytes _data) public {
155         onReceive(msg.sender, _from, _value, _data);
156     }
157 
158     function onTokenTransfer(address _from, uint256 _value, bytes _data) public {
159         onReceive(msg.sender, _from, _value, _data);
160     }
161 }
162 
163 contract EtherReceiver {
164 	function receiveWithData(bytes _data) payable public;
165 }
166 
167 contract EtherReceiveAdapter is EtherReceiver, ReceiveAdapter {
168     function () payable public {
169         receiveWithData("");
170     }
171 
172     function receiveWithData(bytes _data) payable public {
173         onReceive(address(0), msg.sender, msg.value, _data);
174     }
175 }
176 
177 /**
178  * @dev This ReceiveAdapter supports all possible tokens
179  */
180 contract CompatReceiveAdapter is ERC20ReceiveAdapter, ERC223ReceiveAdapter, EtherReceiveAdapter {
181 
182 }
183 
184 contract AbstractSale is Sale, CompatReceiveAdapter, Ownable {
185     using SafeMath for uint256;
186 
187     event Withdraw(address token, address to, uint256 value);
188     event Burn(address token, uint256 value, bytes data);
189 
190     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
191         uint256 sold = getSold(_token, _value);
192         require(sold > 0);
193         uint256 bonus = getBonus(sold);
194         address buyer;
195         if (_data.length == 20) {
196             buyer = address(toBytes20(_data, 0));
197         } else {
198             require(_data.length == 0);
199             buyer = _from;
200         }
201         checkPurchaseValid(buyer, sold, bonus);
202         doPurchase(buyer, sold, bonus);
203         Purchase(buyer, _token, _value, sold, bonus);
204         onPurchase(buyer, _token, _value, sold, bonus);
205     }
206 
207     function getSold(address _token, uint256 _value) constant public returns (uint256) {
208         uint256 rate = getRate(_token);
209         require(rate > 0);
210         return _value.mul(rate).div(10**18);
211     }
212 
213     function getBonus(uint256 sold) constant public returns (uint256);
214 
215     function getRate(address _token) constant public returns (uint256);
216 
217     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal;
218 
219     function checkPurchaseValid(address /*buyer*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
220 
221     }
222 
223     function onPurchase(address /*buyer*/, address /*token*/, uint256 /*value*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
224 
225     }
226 
227     function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
228         require(_start + 20 <= b.length);
229         assembly {
230             let from := add(_start, add(b, 0x20))
231             result := mload(from)
232         }
233     }
234 
235     function withdrawEth(address _to, uint256 _value) onlyOwner public {
236         withdraw(address(0), _to, _value);
237     }
238 
239     function withdraw(address _token, address _to, uint256 _value) onlyOwner public {
240         require(_to != address(0));
241         verifyCanWithdraw(_token, _to, _value);
242         if (_token == address(0)) {
243             _to.transfer(_value);
244         } else {
245             Token(_token).transfer(_to, _value);
246         }
247         Withdraw(_token, _to, _value);
248     }
249 
250     function verifyCanWithdraw(address token, address to, uint256 amount) internal;
251 
252     function burnWithData(address _token, uint256 _value, bytes _data) onlyOwner public {
253         ExternalToken(_token).burn(_value, _data);
254         Burn(_token, _value, _data);
255     }
256 }
257 
258 /**
259  * @title This sale mints token when user sends accepted payments
260  */
261 contract MintingSale is AbstractSale {
262     MintableToken public token;
263 
264     function MintingSale(address _token) public {
265         token = MintableToken(_token);
266     }
267 
268     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal {
269         token.mint(buyer, sold.add(bonus));
270     }
271 
272     function verifyCanWithdraw(address, address, uint256) internal {
273 
274     }
275 }
276 
277 /**
278  * @title OwnableImpl
279  * @dev The Ownable contract has an owner address, and provides basic authorization control
280  * functions, this simplifies the implementation of "user permissions".
281  */
282 contract OwnableImpl is Ownable {
283     address public owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289      * account.
290      */
291     function OwnableImpl() public {
292         owner = msg.sender;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     function checkOwner() internal {
299         require(msg.sender == owner);
300     }
301 
302     /**
303      * @dev Allows the current owner to transfer control of the contract to a newOwner.
304      * @param newOwner The address to transfer ownership to.
305      */
306     function transferOwnership(address newOwner) onlyOwner public {
307         require(newOwner != address(0));
308         OwnershipTransferred(owner, newOwner);
309         owner = newOwner;
310     }
311 }
312 
313 contract CappedBonusSale is AbstractSale {
314     uint256 public cap;
315     uint256 public initialCap;
316 
317     function CappedBonusSale(uint256 _cap) public {
318         cap = _cap;
319         initialCap = _cap;
320     }
321 
322     function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
323         super.checkPurchaseValid(buyer, sold, bonus);
324         require(cap >= sold.add(bonus));
325     }
326 
327     function onPurchase(address buyer, address token, uint256 value, uint256 sold, uint256 bonus) internal {
328         super.onPurchase(buyer, token, value, sold, bonus);
329         cap = cap.sub(sold).sub(bonus);
330     }
331 }
332 
333 /**
334  * @title Secured
335  * @dev Adds only(role) modifier. Subcontracts should implement checkRole to check if caller is allowed to do action.
336  */
337 contract Secured {
338     modifier only(string role) {
339         require(msg.sender == getRole(role));
340         _;
341     }
342 
343     function getRole(string role) constant public returns (address);
344 }
345 
346 contract SecuredImpl is Ownable, Secured {
347 	mapping(string => address) users;
348 	event RoleTransferred(address indexed previousUser, address indexed newUser, string role);
349 
350 	function getRole(string role) constant public returns (address) {
351 		return users[role];
352 	}
353 
354 	function transferRole(string role, address to) onlyOwner public {
355 		require(to != address(0));
356 		RoleTransferred(users[role], to, role);
357 		users[role] = to;
358 	}
359 }
360 
361 contract Whitelist is Secured {
362 	mapping(address => bool) whitelist;
363 	event WhitelistChange(address indexed addr, bool allow);
364 
365 	function isInWhitelist(address addr) constant public returns (bool) {
366 		return whitelist[addr];
367 	}
368 
369 	function setWhitelist(address addr, bool allow) only("operator") public {
370 		setWhitelistInternal(addr, allow);
371 	}
372 
373 	function setWhitelistInternal(address addr, bool allow) internal {
374 		whitelist[addr] = allow;
375 		WhitelistChange(addr, allow);
376 	}
377 }
378 
379 contract WhitelistSale is AbstractSale, Whitelist {
380 	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
381 		super.checkPurchaseValid(buyer, sold, bonus);
382 		require(isInWhitelist(buyer));
383 	}
384 }
385 
386 contract DaoxCommissionSale is AbstractSale {
387 	function getSold(address _token, uint256 _value) constant public returns (uint256) {
388 		return super.getSold(_token, _value).div(99).mul(100);
389 	}
390 }
391 
392 contract ReadOnlyTokenImpl is ReadOnlyToken {
393     mapping(address => uint256) balances;
394     mapping(address => mapping(address => uint256)) internal allowed;
395 
396     /**
397     * @dev Gets the balance of the specified address.
398     * @param _owner The address to query the the balance of.
399     * @return An uint256 representing the amount owned by the passed address.
400     */
401     function balanceOf(address _owner) public constant returns (uint256 balance) {
402         return balances[_owner];
403     }
404 
405     /**
406      * @dev Function to check the amount of tokens that an owner allowed to a spender.
407      * @param _owner address The address which owns the funds.
408      * @param _spender address The address which will spend the funds.
409      * @return A uint256 specifying the amount of tokens still available for the spender.
410      */
411     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
412         return allowed[_owner][_spender];
413     }
414 }
415 
416 /**
417  * @title Standard ERC20 token
418  *
419  * @dev Implementation of the basic standard token.
420  * @dev https://github.com/ethereum/EIPs/issues/20
421  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
422  */
423 contract TokenImpl is Token, ReadOnlyTokenImpl {
424   using SafeMath for uint256;
425 
426   /**
427   * @dev transfer token for a specified address
428   * @param _to The address to transfer to.
429   * @param _value The amount to be transferred.
430   */
431   function transfer(address _to, uint256 _value) public returns (bool) {
432     require(_to != address(0));
433     require(_value <= balances[msg.sender]);
434 
435     // SafeMath.sub will throw if there is not enough balance.
436     balances[msg.sender] = balances[msg.sender].sub(_value);
437     balances[_to] = balances[_to].add(_value);
438     emitTransfer(msg.sender, _to, _value);
439     return true;
440   }
441 
442   function emitTransfer(address _from, address _to, uint256 _value) internal {
443     Transfer(_from, _to, _value);
444   }
445 
446   /**
447    * @dev Transfer tokens from one address to another
448    * @param _from address The address which you want to send tokens from
449    * @param _to address The address which you want to transfer to
450    * @param _value uint256 the amount of tokens to be transferred
451    */
452   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
453     require(_to != address(0));
454     require(_value <= balances[_from]);
455     require(_value <= allowed[_from][msg.sender]);
456 
457     balances[_from] = balances[_from].sub(_value);
458     balances[_to] = balances[_to].add(_value);
459     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
460     emitTransfer(_from, _to, _value);
461     return true;
462   }
463 
464   /**
465    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
466    *
467    * Beware that changing an allowance with this method brings the risk that someone may use both the old
468    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
469    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
470    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
471    * @param _spender The address which will spend the funds.
472    * @param _value The amount of tokens to be spent.
473    */
474   function approve(address _spender, uint256 _value) public returns (bool) {
475     allowed[msg.sender][_spender] = _value;
476     Approval(msg.sender, _spender, _value);
477     return true;
478   }
479 
480   /**
481    * approve should be called when allowed[_spender] == 0. To increment
482    * allowed value is better to use this function to avoid 2 calls (and wait until
483    * the first transaction is mined)
484    * From MonolithDAO Token.sol
485    */
486   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
487     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
488     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
489     return true;
490   }
491 
492   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
493     uint oldValue = allowed[msg.sender][_spender];
494     if (_subtractedValue > oldValue) {
495       allowed[msg.sender][_spender] = 0;
496     } else {
497       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
498     }
499     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
500     return true;
501   }
502 
503 }
504 
505 contract BurnableToken is Token {
506 	event Burn(address indexed burner, uint256 value);
507 	function burn(uint256 _value) public;
508 }
509 
510 contract BurnableTokenImpl is TokenImpl, BurnableToken {
511 	/**
512 	 * @dev Burns a specific amount of tokens.
513 	 * @param _value The amount of token to be burned.
514 	 */
515 	function burn(uint256 _value) public {
516 		require(_value <= balances[msg.sender]);
517 		// no need to require value <= totalSupply, since that would imply the
518 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
519 
520 		address burner = msg.sender;
521 		balances[burner] = balances[burner].sub(_value);
522 		totalSupply = totalSupply.sub(_value);
523 		Burn(burner, _value);
524 	}
525 }
526 
527 contract MintableTokenImpl is Ownable, TokenImpl, MintableToken {
528     /**
529      * @dev Function to mint tokens
530      * @param _to The address that will receive the minted tokens.
531      * @param _amount The amount of tokens to mint.
532      * @return A boolean that indicates if the operation was successful.
533      */
534     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
535         totalSupply = totalSupply.add(_amount);
536         balances[_to] = balances[_to].add(_amount);
537         emitMint(_to, _amount);
538         emitTransfer(address(0), _to, _amount);
539         return true;
540     }
541 
542     function emitMint(address _to, uint256 _value) internal {
543         Mint(_to, _value);
544     }
545 }
546 
547 /**
548  * @title Pausable
549  * @dev Base contract which allows children to implement an emergency stop mechanism.
550  */
551 contract Pausable is Ownable {
552     event Pause();
553     event Unpause();
554 
555     bool public paused = false;
556 
557 
558     /**
559      * @dev Modifier to make a function callable only when the contract is not paused.
560      */
561     modifier whenNotPaused() {
562         require(!paused);
563         _;
564     }
565 
566     /**
567      * @dev Modifier to make a function callable only when the contract is paused.
568      */
569     modifier whenPaused() {
570         require(paused);
571         _;
572     }
573 
574     /**
575      * @dev called by the owner to pause, triggers stopped state
576      */
577     function pause() onlyOwner whenNotPaused public {
578         paused = true;
579         Pause();
580     }
581 
582     /**
583      * @dev called by the owner to unpause, returns to normal state
584      */
585     function unpause() onlyOwner whenPaused public {
586         paused = false;
587         Unpause();
588     }
589 }
590 
591 contract PausableToken is Pausable, TokenImpl {
592 
593 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
594 		return super.transfer(_to, _value);
595 	}
596 
597 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
598 		return super.transferFrom(_from, _to, _value);
599 	}
600 
601 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
602 		return super.approve(_spender, _value);
603 	}
604 
605 	function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
606 		return super.increaseApproval(_spender, _addedValue);
607 	}
608 
609 	function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
610 		return super.decreaseApproval(_spender, _subtractedValue);
611 	}
612 }
613 
614 contract ZenomeToken is OwnableImpl, PausableToken, MintableTokenImpl, BurnableTokenImpl {
615 	string public constant name = "Zenome";
616 	string public constant symbol = "sZNA";
617 	uint8 public constant decimals = 18;
618 
619 	function burn(uint256 _value) public whenNotPaused {
620 		super.burn(_value);
621 	}
622 }
623 
624 contract ZenomeSale is OwnableImpl, SecuredImpl, DaoxCommissionSale, MintingSale, CappedBonusSale, WhitelistSale {
625 	address public btcToken;
626 	uint256 public ethRate = 1350 * 10**18;
627 	uint256 public btcEthRate = 10 * 10**10;
628 
629 	function ZenomeSale(
630 		address _mintableToken,
631 		address _btcToken,
632 		uint256 _cap)
633 	MintingSale(_mintableToken)
634 	CappedBonusSale(_cap) {
635 		btcToken = _btcToken;
636 		RateAdd(address(0));
637 		RateAdd(_btcToken);
638 	}
639 
640 	function getRate(address _token) constant public returns (uint256) {
641 		if (_token == btcToken) {
642 			return btcEthRate * ethRate;
643 		} else if (_token == address(0)) {
644 			return ethRate;
645 		} else {
646 			return 0;
647 		}
648 	}
649 
650 	function getBonus(uint256 sold) constant public returns (uint256) {
651 		if (sold > 850000 * 10**18) {
652 			return sold.mul(50).div(100);
653 		} else if (sold > 340000 * 10**18) {
654 			return sold.mul(33).div(100);
655 		} else if (sold > 85000 * 10**18) {
656 			return sold.mul(20).div(100);
657 		} else {
658 			return 0;
659 		}
660 	}
661 
662 	event EthRateChange(uint256 rate);
663 
664 	function setEthRate(uint256 _ethRate) onlyOwner public {
665 		ethRate = _ethRate;
666 		EthRateChange(_ethRate);
667 	}
668 
669 	event BtcEthRateChange(uint256 rate);
670 
671 	function setBtcEthRate(uint256 _btcEthRate) onlyOwner public {
672 		btcEthRate = _btcEthRate;
673 		BtcEthRateChange(_btcEthRate);
674 	}
675 
676 	function withdrawBtc(bytes _to, uint256 _value) onlyOwner public {
677 		burnWithData(btcToken, _value, _to);
678 	}
679 
680 	function transferTokenOwnership(address newOwner) onlyOwner public {
681 		OwnableImpl(token).transferOwnership(newOwner);
682 	}
683 
684 	function pauseToken() onlyOwner public {
685 		Pausable(token).pause();
686 	}
687 
688 	function unpauseToken() onlyOwner public {
689 		Pausable(token).unpause();
690 	}
691 
692 	function transfer(address beneficiary, uint256 amount) onlyOwner public {
693 		emulatePurchase(beneficiary, address(1), 0, amount, 0);
694 	}
695 
696 	function emulatePurchase(address beneficiary, address paymentMethod, uint256 value, uint256 amount, uint256 bonus) onlyOwner public {
697 		setWhitelistInternal(beneficiary, true);
698 		doPurchase(beneficiary, amount, bonus);
699 		Purchase(beneficiary, paymentMethod, value, amount, bonus);
700 		onPurchase(beneficiary, paymentMethod, value, amount, bonus);
701 	}
702 }