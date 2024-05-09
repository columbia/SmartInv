1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33   
34 }
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     
44     // Public variable with address of owner
45     address public owner;
46     
47     /**
48      * Log ownership transference
49      */
50     event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner);
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         // Set the contract creator as the owner
60         owner = msg.sender;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         // Check that sender is owner
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner) onlyOwner public {
77         // Check for a non-null owner
78         require(newOwner != address(0));
79         // Log ownership transference
80         OwnershipTransferred(owner, newOwner);
81         // Set new owner
82         owner = newOwner;
83     }
84     
85 }
86 
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94 
95     uint256 public totalSupply = 0;
96     function balanceOf(address who) public constant returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100 }
101 
102 
103 contract MintableToken is ERC20Basic, Ownable {
104 
105     bool public mintingFinished = false;
106 
107     event Mint(address indexed to, uint256 amount);
108     event MintFinished();
109 
110     modifier canMint() {
111         require(!mintingFinished);
112         _;
113     }
114     
115     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool);
116 
117     /**
118      * @dev Function to stop minting new tokens.
119      * @return True if the operation was successful.
120      */
121     function finishMinting() onlyOwner public returns (bool) {
122         mintingFinished = true;
123         MintFinished();
124         return true;
125     }
126   
127 }
128 
129 
130 /**
131  * @title Extended ERC20 Token contract
132  * @dev Custom Token (ERC20 Token) transactions.
133  */
134 contract StyrasToken is MintableToken {
135   
136     using SafeMath for uint256;
137 
138     string public name = "Styras";
139     string public symbol = "STY";
140     uint256 public decimals = 18;
141 
142     uint256 public reservedSupply;
143 
144     uint256 public publicLockEnd = 1516060800; // GMT: Tuesday, January 16, 2018 0:00:00
145     uint256 public partnersLockEnd = 1530230400; // GMT: Friday, June 29, 2018 0:00:00
146     uint256 public partnersMintLockEnd = 1514678400; // GMT: Sunday, December 31, 2017 0:00:00
147 
148     address public partnersWallet;
149     mapping(address => uint256) balances;
150     mapping (address => mapping (address => uint256)) internal allowed;
151 
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153     event Transfer(address indexed from, address indexed to, uint256 value);
154     event Burn(address indexed burner, uint256 value);
155 
156     /**
157      * Initializes contract with initial supply tokens to the creator of the contract
158      */
159     function StyrasToken(address partners, uint256 reserved) public {
160         require(partners != address(0));
161         partnersWallet = partners;
162         reservedSupply = reserved;
163         assert(publicLockEnd <= partnersLockEnd);
164         assert(partnersMintLockEnd < partnersLockEnd);
165     }
166 
167     /**
168      * @dev Gets the balance of the specified address.
169      * @param investor The address to query the the balance of.
170      * @return An uint256 representing the amount owned by the passed address.
171      */
172     function balanceOf(address investor) public constant returns (uint256 balanceOfInvestor) {
173         return balances[investor];
174     }
175 
176     /**
177      * @dev transfer token for a specified address
178      * @param _to The address to transfer to.
179      * @param _amount The amount to be transferred.
180      */
181     function transfer(address _to, uint256 _amount) public returns (bool) {
182         require(_to != address(0));
183         require((msg.sender != partnersWallet && now >= publicLockEnd) || now >= partnersLockEnd);
184         require(_amount > 0 && _amount <= balances[msg.sender]);
185         balances[msg.sender] = balances[msg.sender].sub(_amount);
186         balances[_to] = balances[_to].add(_amount);
187         Transfer(msg.sender, _to, _amount);
188         return true;
189     }
190   
191     /**
192      * @dev Transfer tokens from one address to another
193      * @param _from address The address which you want to send tokens from
194      * @param _to address The address which you want to transfer to
195      * @param _amount uint256 the amount of tokens to be transferred
196      */
197     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
198         require(_to != address(0));
199         require((_from != partnersWallet && now >= publicLockEnd) || now >= partnersLockEnd);
200         require(_amount > 0 && _amount <= balances[_from]);
201         require(_amount <= allowed[_from][msg.sender]);
202         balances[_from] = balances[_from].sub(_amount);
203         balances[_to] = balances[_to].add(_amount);
204         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
205         Transfer(_from, _to, _amount);
206         return true;
207     }
208 
209     /**
210      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211      *
212      * Beware that changing an allowance with this method brings the risk that someone may use both the old
213      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216      * @param _spender The address which will spend the funds.
217      * @param _value The amount of tokens to be spent.
218      */
219     function approve(address _spender, uint256 _value) public returns (bool) {
220         allowed[msg.sender][_spender] = _value;
221         Approval(msg.sender, _spender, _value);
222         return true;
223     }
224 
225     /**
226      * @dev Function to check the amount of tokens that an owner allowed to a spender.
227      * @param _owner address The address which owns the funds.
228      * @param _spender address The address which will spend the funds.
229      * @return A uint256 specifying the amount of tokens still available for the spender.
230      */
231     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
232         return allowed[_owner][_spender];
233     }
234 
235     /**
236      * approve should be called when allowed[_spender] == 0. To increment
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      */
241     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
242         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 
247     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
248         uint oldValue = allowed[msg.sender][_spender];
249         if (_subtractedValue > oldValue) {
250             allowed[msg.sender][_spender] = 0;
251         } else {
252             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253         }
254         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     /**
259      * @dev Burns a specific amount of tokens.
260      * @param _value The amount of token to be burned.
261      */
262     function burn(uint256 _value) public {
263         require((msg.sender != partnersWallet && now >= publicLockEnd) || now >= partnersLockEnd);
264         require(_value > 0 && _value <= balances[msg.sender]);
265         address burner = msg.sender;
266         balances[burner] = balances[burner].sub(_value);
267         totalSupply = totalSupply.sub(_value);
268         Burn(burner, _value);
269     }
270 
271     /**
272      * @dev Function to mint tokens
273      * @param _to The address that will receive the minted tokens.
274      * @param _amount The amount of tokens to mint.
275      * @return A boolean that indicates if the operation was successful.
276      */
277     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
278         require(_to != partnersWallet);
279         totalSupply = totalSupply.add(_amount);
280         balances[_to] = balances[_to].add(_amount);
281         Mint(_to, _amount);
282         Transfer(address(0), _to, _amount);
283         return true;
284     }
285 
286     /**
287      * @dev Function to mint reserved tokens to partners
288      * @return A boolean that indicates if the operation was successful.
289      */
290     function mintPartners(uint256 amount) onlyOwner canMint public returns (bool) {
291         require(now >= partnersMintLockEnd);
292         require(reservedSupply > 0);
293         require(amount <= reservedSupply);
294         totalSupply = totalSupply.add(amount);
295         reservedSupply = reservedSupply.sub(amount);
296         balances[partnersWallet] = balances[partnersWallet].add(amount);
297         Mint(partnersWallet, amount);
298         Transfer(address(0), partnersWallet, amount);
299         return true;
300     }
301   
302 }
303 
304 
305 /**
306  * @title RefundVault
307  * @dev This contract is used for storing funds while a crowdsale
308  * is in progress. Supports refunding the money if crowdsale fails,
309  * and forwarding it if crowdsale is successful.
310  */
311 contract RefundVault is Ownable {
312   
313     using SafeMath for uint256;
314 
315     enum State { Active, Refunding, Closed }
316 
317     mapping (address => uint256) public deposited;
318     address public wallet;
319     State public state;
320 
321     event Closed();
322     event RefundsEnabled();
323     event Refunded(address indexed beneficiary, uint256 weiAmount);
324 
325     function RefundVault(address _to) public {
326         require(_to != address(0));
327         wallet = _to;
328         state = State.Active;
329     }
330 
331     function deposit(address investor) onlyOwner public payable {
332         require(state == State.Active);
333         deposited[investor] = deposited[investor].add(msg.value);
334     }
335 
336     function close() onlyOwner public {
337         require(state == State.Active);
338         state = State.Closed;
339         Closed();
340         wallet.transfer(this.balance);
341     }
342 
343     function enableRefunds() onlyOwner public {
344         require(state == State.Active);
345         state = State.Refunding;
346         RefundsEnabled();
347     }
348 
349     function refund(address investor) public {
350         require(state == State.Refunding);
351         require(deposited[investor] > 0);
352         uint256 depositedValue = deposited[investor];
353         deposited[investor] = 0;
354         investor.transfer(depositedValue);
355         Refunded(investor, depositedValue);
356     }
357   
358 }
359 
360 
361 contract Withdrawable is Ownable {
362 
363     bool public withdrawEnabled = false;
364     address public wallet;
365 
366     event Withdrawed(uint256 weiAmount);
367   
368     function Withdrawable(address _to) public {
369         require(_to != address(0));
370         wallet = _to;
371     }
372 
373     modifier canWithdraw() {
374         require(withdrawEnabled);
375         _;
376     }
377   
378     function enableWithdraw() onlyOwner public {
379         withdrawEnabled = true;
380     }
381   
382     // owner can withdraw ether here
383     function withdraw(uint256 weiAmount) onlyOwner canWithdraw public {
384         require(this.balance >= weiAmount);
385         wallet.transfer(weiAmount);
386         Withdrawed(weiAmount);
387     }
388 
389 }
390 
391 
392 contract StyrasVault is Withdrawable, RefundVault {
393   
394     function StyrasVault(address wallet) public
395         Withdrawable(wallet)
396         RefundVault(wallet) {
397         // NOOP
398     }
399   
400     function balanceOf(address investor) public constant returns (uint256 depositedByInvestor) {
401         return deposited[investor];
402     }
403   
404     function enableWithdraw() onlyOwner public {
405         require(state == State.Active);
406         withdrawEnabled = true;
407     }
408 
409 }
410 
411 
412 /**
413  * @title StyrasCrowdsale
414  * @dev This is a capped and refundable crowdsale.
415  */
416 contract StyrasCrowdsale is Ownable {
417 
418     using SafeMath for uint256;
419   
420     enum State { preSale, publicSale, hasFinalized }
421 
422     // how many token units a buyer gets per ether
423     // minimum amount of funds (soft-cap) to be raised in weis
424     // maximum amount of funds (hard-cap) to be raised in weis
425     // minimum amount of weis to invest per investor
426     uint256 public rate;
427     uint256 public goal;
428     uint256 public cap;
429     uint256 public minInvest = 100000000000000000; // 0.1 ETH
430 
431     // presale treats
432     uint256 public presaleDeadline = 1511827200; // GMT: Tuesday, November 28, 2017 00:00:00
433     uint256 public presaleRate = 4000; // 1 ETH == 4000 STY 33% bonus
434     uint256 public presaleCap = 50000000000000000000000000; // 50 millions STY
435   
436     // pubsale treats
437     uint256 public pubsaleDeadline = 1514678400; // GMT: Sunday, December 31, 2017 0:00:00
438     uint256 public pubsaleRate = 3000; // 1 ETH == 3000 STY
439     uint256 public pubsaleCap = 180000000000000000000000000;
440 
441     // harrd cap = pubsaleCap + reservedSupply -> 200000000 DTY
442     uint256 public reservedSupply = 20000000000000000000000000; // 10% max totalSupply
443 
444     uint256 public softCap = 840000000000000000000000; // 840 thousands STY
445 
446     // start and end timestamps where investments are allowed (both inclusive)
447     // flag for investments finalization
448     uint256 public startTime = 1511276400; // GMT: Tuesday, November 21, 2017 15:00:00
449     uint256 public endTime;
450 
451     // amount of raised money in wei
452     // address where funds are collected
453     uint256 public weiRaised = 0;
454     address public escrowWallet;
455     address public partnersWallet;
456 
457     // contract of the token being sold
458     // contract of the vault used to hold funds while crowdsale is running
459     StyrasToken public token;
460     StyrasVault public vault;
461 
462     State public state;
463 
464     /**
465      * event for token purchase logging
466      * @param purchaser who paid for the tokens
467      * @param beneficiary who got the tokens
468      * @param value weis paid for purchase
469      * @param amount amount of tokens purchased
470      */
471     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
472     event PresaleFinalized();
473     event Finalized();
474 
475     function StyrasCrowdsale(address escrow, address partners) public {
476         require(now < startTime);
477         require(partners != address(0));
478         require(startTime < presaleDeadline);
479         require(presaleDeadline < pubsaleDeadline);
480         require(pubsaleRate < presaleRate);
481         require(presaleCap < pubsaleCap);
482         require(softCap <= pubsaleCap);
483         endTime = presaleDeadline;
484         escrowWallet = escrow;
485         partnersWallet = partners;
486         token = new StyrasToken(partnersWallet, reservedSupply);
487         vault = new StyrasVault(escrowWallet);
488         rate = presaleRate;
489         goal = softCap.div(rate);
490         cap = presaleCap.div(rate);
491         state = State.preSale;
492         assert(goal < cap);
493         assert(startTime < endTime);
494     }
495 
496     // fallback function can be used to buy tokens
497     function () public payable {
498         buyTokens(msg.sender);
499     }
500   
501     // low level token purchase function
502     function buyTokens(address beneficiary) public payable {
503         require(beneficiary != address(0));
504         require(state < State.hasFinalized);
505         require(validPurchase());
506         uint256 weiAmount = msg.value;
507         // calculate token amount to be created
508         uint256 tokenAmount = weiAmount.mul(rate);
509         // update state
510         weiRaised = weiRaised.add(weiAmount);
511         token.mint(beneficiary, tokenAmount);
512         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
513         forwardFunds();
514     }
515 
516     // send ether to the fund collection wallet
517     // override to create custom fund forwarding mechanisms
518     function forwardFunds() internal {
519         vault.deposit.value(msg.value)(msg.sender);
520         assert(vault.balance == weiRaised);
521     }
522 
523     // @return true if the transaction can buy tokens
524     function validPurchase() internal constant returns (bool) {
525         bool withinPeriod = startTime <= now && now <= endTime;
526         bool nonZeroPurchase = msg.value > 0;
527         bool withinCap = weiRaised < cap;
528         bool overMinInvest = msg.value >= minInvest || vault.balanceOf(msg.sender) >= minInvest;
529         return withinPeriod && nonZeroPurchase && withinCap && overMinInvest;
530     }
531 
532     function hardCap() public constant returns (uint256) {
533         return pubsaleCap + reservedSupply;
534     }
535 
536     function goalReached() public constant returns (bool) {
537         return weiRaised >= goal;
538     }
539 
540     // @return true if crowdsale event has ended
541     function hasEnded() public constant returns (bool) {
542         bool afterPeriod = now > endTime;
543         bool capReached = weiRaised >= cap;
544         return afterPeriod || capReached;
545     }
546 
547     // if crowdsale is unsuccessful, investors can claim refunds here
548     function claimRefund() public {
549         require(state == State.hasFinalized);
550         require(!goalReached());
551         vault.refund(msg.sender);
552     }
553 
554     function enableWithdraw() onlyOwner public {
555         require(goalReached());
556         vault.enableWithdraw();
557     }
558   
559     // if crowdsale is successful, owner can withdraw ether here
560     function withdraw(uint256 _weiAmountToWithdraw) onlyOwner public {
561         require(goalReached());
562         vault.withdraw(_weiAmountToWithdraw);
563     }
564 
565     function finalizePresale() onlyOwner public {
566         require(state == State.preSale);
567         require(hasEnded());
568         uint256 weiDiff = 0;
569         uint256 raisedTokens = token.totalSupply();
570         rate = pubsaleRate;
571         if (!goalReached()) {
572             weiDiff = (softCap.sub(raisedTokens)).div(rate);
573             goal = weiRaised.add(weiDiff);
574         }
575         weiDiff = (pubsaleCap.sub(raisedTokens)).div(rate);
576         cap = weiRaised.add(weiDiff);
577         endTime = pubsaleDeadline;
578         state = State.publicSale;
579         assert(goal < cap);
580         assert(startTime < endTime);
581         PresaleFinalized();
582     }
583 
584     /**
585      * @dev Must be called after crowdsale ends, to do some extra finalization
586      * work. Calls the contract's finalization function.
587      */
588     function finalize() onlyOwner public {
589         require(state == State.publicSale);
590         require(hasEnded());
591         finalization();
592         state = State.hasFinalized;
593         Finalized();
594     }
595 
596     // vault finalization task, called when owner calls finalize()
597     function finalization() internal {
598         if (goalReached()) {
599             vault.close();
600             token.mintPartners(reservedSupply);
601         } else {
602             vault.enableRefunds();
603         }
604         vault.transferOwnership(owner);
605         token.transferOwnership(owner);
606     }
607 
608 }