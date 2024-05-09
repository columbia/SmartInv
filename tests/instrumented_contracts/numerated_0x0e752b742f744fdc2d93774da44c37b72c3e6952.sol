1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b > 0);
20         uint256 c = a / b;
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
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/ownership/Ownable.sol
41  */
42 contract Ownable {
43     address public owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     function Ownable() public {
60         owner = msg.sender;
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/lifecycle/Pausable.sol
79  */
80 contract Pausable is Ownable {
81     event Pause();
82     event Unpause();
83 
84     bool public paused = false;
85 
86     /**
87      * @dev Modifier to make a function callable only when the contract is not paused.
88      */
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     /**
95      * @dev Modifier to make a function callable only when the contract is paused.
96      */
97     modifier whenPaused() {
98         require(paused);
99         _;
100     }
101 
102     /**
103      * @dev called by the owner to pause, triggers stopped state
104      */
105     function pause() public onlyOwner whenNotPaused {
106         paused = true;
107         Pause();
108     }
109 
110     /**
111      * @dev called by the owner to unpause, returns to normal state
112      */
113     function unpause() public onlyOwner whenPaused {
114         paused = false;
115         Unpause();
116     }
117 }
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/ERC20Basic.sol
124  */
125 contract ERC20Basic {
126     uint256 public totalSupply;
127 
128     function balanceOf(address who) public view returns (uint256);
129     function transfer(address to, uint256 value) public returns (bool);
130     
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/BasicToken.sol
138  */
139 contract BasicToken is ERC20Basic {
140     using SafeMath for uint256;
141 
142     mapping(address => uint256) balances;
143 
144     /**
145     * @dev Transfer token for a specified address
146     * @param _to The address to transfer to.
147     * @param _value The amount to be transferred.
148     */
149     function transfer(address _to, uint256 _value) public returns (bool) {
150         require(_to != address(0));
151         require(_value <= balances[msg.sender]);
152 
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     /**
160     * @dev Gets the balance of the specified address.
161     * @param _owner The address to query the the balance of.
162     * @return An uint256 representing the amount owned by the passed address.
163     */
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return balances[_owner];
166     }
167 
168 }
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/ERC20.sol
174  */
175 contract ERC20 is ERC20Basic {
176     function allowance(address owner, address spender) public view returns (uint256);
177     function transferFrom(address from, address to, uint256 value) public returns (bool);
178     function approve(address spender, uint256 value) public returns (bool);
179     
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/StandardToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191     mapping (address => mapping (address => uint256)) internal allowed;
192 
193     /**
194      * @dev Transfer tokens from one address to another
195      * @param _from address The address which you want to send tokens from
196      * @param _to address The address which you want to transfer to
197      * @param _value uint256 the amount of tokens to be transferred
198      * @return A boolean that indicates if the operation was successful.
199      */
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         require(_value <= balances[_from]);
203         require(_value <= allowed[_from][msg.sender]);
204 
205         uint256 _allowance = allowed[_from][msg.sender];
206 
207         balances[_from] = balances[_from].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         allowed[_from][msg.sender] = _allowance.sub(_value);
210         Transfer(_from, _to, _value);
211         return true;
212     }
213 
214     /**
215      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216      *
217      * Beware that changing an allowance with this method brings the risk that someone may use both the old
218      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      * @param _spender The address which will spend the funds.
222      * @param _value The amount of tokens to be spent.
223      * @return A boolean that indicates if the operation was successful.
224      */
225     function approve(address _spender, uint256 _value) public returns (bool) {
226         allowed[msg.sender][_spender] = _value;
227         Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address _owner, address _spender) public view returns (uint256) {
238         return allowed[_owner][_spender];
239     }
240 }
241 
242 /**
243  * @title Mintable token
244  * @dev Simple ERC20 Token example, with mintable token creation
245  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/MintableToken.sol
246  */
247 
248 contract MintableToken is StandardToken, Ownable {
249     event Mint(address indexed to, uint256 amount);
250     event MintFinished();
251 
252     bool public mintingFinished = false;
253 
254     address public mintAddress;
255 
256     modifier canMint() {
257         require(!mintingFinished);
258         _;
259     }
260 
261     modifier onlyMint() {
262         require(msg.sender == mintAddress);
263         _;
264     }
265 
266     /**
267      * @dev Function to change address that is allowed to do emission.
268      * @param _mintAddress Address of the emission contract.
269      */
270     function setMintAddress(address _mintAddress) public onlyOwner {
271         require(_mintAddress != address(0));
272         mintAddress = _mintAddress;
273     }
274 
275     /**
276      * @dev Function to mint tokens
277      * @param _to The address that will receive the minted tokens.
278      * @param _amount The amount of tokens to mint.
279      * @return A boolean that indicates if the operation was successful.
280      */
281     function mint(address _to, uint256 _amount) public onlyMint canMint returns (bool) {
282         totalSupply = totalSupply.add(_amount);
283         balances[_to] = balances[_to].add(_amount);
284         Mint(_to, _amount);
285         Transfer(address(0), _to, _amount);
286         return true;
287     }
288 
289     /**
290      * @dev Function to stop minting new tokens.
291      * @return True if the operation was successful.
292      */
293     function finishMinting() public onlyMint canMint returns (bool) {
294         mintingFinished = true;
295         MintFinished();
296         return true;
297     }
298 }
299 
300 /**
301  * @title TokenTimelock
302  * @dev TokenTimelock is a token holder contract that will allow a
303  * beneficiary to extract the tokens after a given release time
304  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/TokenTimelock.sol
305  */
306 contract TokenTimelock {
307     // ERC20 basic token contract being held
308     ERC20Basic public token;
309 
310     // beneficiary of tokens after they are released
311     address public beneficiary;
312 
313     // timestamp when token release is enabled
314     uint256 public releaseTime;
315 
316     /**
317      * @dev The TokenTimelock constructor sets token address, beneficiary and time to release.
318      * @param _token Address of the token
319      * @param _beneficiary Address that will receive the tokens after release
320      * @param _releaseTime Time that will allow release the tokens
321      */
322     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
323         require(_releaseTime > now);
324         token = _token;
325         beneficiary = _beneficiary;
326         releaseTime = _releaseTime;
327     }
328 
329     /**
330      * @dev Transfers tokens held by timelock to beneficiary.
331      */
332     function release() public {
333         require(now >= releaseTime);
334 
335         uint256 amount = token.balanceOf(this);
336         require(amount > 0);
337 
338         token.transfer(beneficiary, amount);
339     }
340 }
341 
342 /**
343  * @title CraftyCrowdsale
344  * @dev CraftyCrowdsale is a contract for managing a Crafty token crowdsale.
345  */
346 contract CraftyCrowdsale is Pausable {
347     using SafeMath for uint256;
348 
349     // Amount received from each address
350     mapping(address => uint256) received;
351 
352     // The token being sold
353     MintableToken public token;
354 
355     // start and end timestamps where investments are allowed (both inclusive)
356     uint256 public preSaleStart;
357     uint256 public preSaleEnd;
358     uint256 public saleStart;
359     uint256 public saleEnd;
360 
361     // amount of tokens sold
362     uint256 public issuedTokens = 0;
363 
364     // token cap
365     uint256 public constant hardCap = 5000000000 * 10**8; // 50%
366 
367     // token wallets
368     uint256 constant teamCap = 1450000000 * 10**8; // 14.5%
369     uint256 constant advisorCap = 450000000 * 10**8; // 4.5%
370     uint256 constant bountyCap = 100000000 * 10**8; // 1%
371     uint256 constant fundCap = 3000000000 * 10**8; // 30%
372 
373     // Number of days the tokens will be locked
374     uint256 constant lockTime = 180 days;
375 
376     // wallets
377     address public etherWallet;
378     address public teamWallet;
379     address public advisorWallet;
380     address public fundWallet;
381     address public bountyWallet;
382 
383     // timelocked tokens
384     TokenTimelock teamTokens;
385 
386     uint256 public rate;
387 
388     enum State { BEFORE_START, SALE, REFUND, CLOSED }
389     State currentState = State.BEFORE_START;
390 
391     /**
392      * @dev Event for token purchase logging
393      * @param purchaser who paid for the tokens
394      * @param beneficiary who got the tokens
395      * @param amount amount of tokens purchased
396      */
397     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
398 
399     /**
400      * @dev Event for refund
401      * @param to who sent wei
402      * @param amount amount of wei refunded
403      */
404     event Refund(address indexed to, uint256 amount);
405 
406     /**
407      * @dev modifier to allow token creation only when the sale is on
408      */
409     modifier saleIsOn() {
410         require(
411             (
412                 (now >= preSaleStart && now < preSaleEnd) || 
413                 (now >= saleStart && now < saleEnd)
414             ) && 
415             issuedTokens < hardCap && 
416             currentState == State.SALE
417         );
418         _;
419     }
420 
421     /**
422      * @dev modifier to allow action only before sale
423      */
424     modifier beforeSale() {
425         require( now < preSaleStart);
426         _;
427     }
428 
429     /**
430      * @dev modifier that fails if state doesn't match
431      */
432     modifier inState(State _state) {
433         require(currentState == _state);
434         _;
435     }
436 
437     /**
438      * @dev CraftyCrowdsale constructor sets the token, period and exchange rate
439      * @param _token The address of Crafty Token.
440      * @param _preSaleStart The start time of pre-sale.
441      * @param _preSaleEnd The end time of pre-sale.
442      * @param _saleStart The start time of sale.
443      * @param _saleEnd The end time of sale.
444      * @param _rate The exchange rate of tokens.
445      */
446     function CraftyCrowdsale(address _token, uint256 _preSaleStart, uint256 _preSaleEnd, uint256 _saleStart, uint256 _saleEnd, uint256 _rate) public {
447         require(_token != address(0));
448         require(_preSaleStart < _preSaleEnd && _preSaleEnd < _saleStart && _saleStart < _saleEnd);
449         require(_rate > 0);
450 
451         token = MintableToken(_token);
452         preSaleStart = _preSaleStart;
453         preSaleEnd = _preSaleEnd;
454         saleStart = _saleStart;
455         saleEnd = _saleEnd;
456         rate = _rate;
457     }
458 
459     /**
460      * @dev Fallback function can be used to buy tokens
461      */
462     function () public payable {
463         if(msg.sender != owner)
464             buyTokens();
465     }
466 
467     /**
468      * @dev Function used to buy tokens
469      */
470     function buyTokens() public saleIsOn whenNotPaused payable {
471         require(msg.sender != address(0));
472         require(msg.value >= 20 finney);
473 
474         uint256 weiAmount = msg.value;
475         uint256 currentRate = getRate(weiAmount);
476 
477         // calculate token amount to be created
478         uint256 newTokens = weiAmount.mul(currentRate).div(10**18);
479 
480         require(issuedTokens.add(newTokens) <= hardCap);
481         
482         issuedTokens = issuedTokens.add(newTokens);
483         received[msg.sender] = received[msg.sender].add(weiAmount);
484         token.mint(msg.sender, newTokens);
485         TokenPurchase(msg.sender, msg.sender, newTokens);
486 
487         etherWallet.transfer(msg.value);
488     }
489 
490     /**
491      * @dev Function used to change the exchange rate.
492      * @param _rate The new rate.
493      */
494     function setRate(uint256 _rate) public onlyOwner beforeSale {
495         require(_rate > 0);
496 
497         rate = _rate;
498     }
499 
500     /**
501      * @dev Function used to set wallets and enable the sale.
502      * @param _etherWallet Address of ether wallet.
503      * @param _teamWallet Address of team wallet.
504      * @param _advisorWallet Address of advisors wallet.
505      * @param _bountyWallet Address of bounty wallet.
506      * @param _fundWallet Address of fund wallet.
507      */
508     function setWallets(address _etherWallet, address _teamWallet, address _advisorWallet, address _bountyWallet, address _fundWallet) public onlyOwner inState(State.BEFORE_START) {
509         require(_etherWallet != address(0));
510         require(_teamWallet != address(0));
511         require(_advisorWallet != address(0));
512         require(_bountyWallet != address(0));
513         require(_fundWallet != address(0));
514 
515         etherWallet = _etherWallet;
516         teamWallet = _teamWallet;
517         advisorWallet = _advisorWallet;
518         bountyWallet = _bountyWallet;
519         fundWallet = _fundWallet;
520 
521         uint256 releaseTime = saleEnd + lockTime;
522 
523         // Mint locked tokens
524         teamTokens = new TokenTimelock(token, teamWallet, releaseTime);
525         token.mint(teamTokens, teamCap);
526 
527         // Mint released tokens
528         token.mint(advisorWallet, advisorCap);
529         token.mint(bountyWallet, bountyCap);
530         token.mint(fundWallet, fundCap);
531 
532         currentState = State.SALE;
533     }
534 
535     /**
536      * @dev Generate tokens to specific address, necessary to accept other cryptos.
537      * @param beneficiary Address of the beneficiary.
538      * @param newTokens Amount of tokens to be minted.
539      */
540     function generateTokens(address beneficiary, uint256 newTokens) public onlyOwner {
541         require(beneficiary != address(0));
542         require(newTokens > 0);
543         require(issuedTokens.add(newTokens) <= hardCap);
544 
545         issuedTokens = issuedTokens.add(newTokens);
546         token.mint(beneficiary, newTokens);
547         TokenPurchase(msg.sender, beneficiary, newTokens);
548     }
549 
550     /**
551      * @dev Finish crowdsale and token minting.
552      */
553     function finishCrowdsale() public onlyOwner inState(State.SALE) {
554         require(now > saleEnd);
555         // tokens not sold to fund
556         uint256 unspentTokens = hardCap.sub(issuedTokens);
557         token.mint(fundWallet, unspentTokens);
558 
559         currentState = State.CLOSED;
560 
561         token.finishMinting();
562     }
563 
564     /**
565      * @dev Enable refund after sale.
566      */
567     function enableRefund() public onlyOwner inState(State.CLOSED) {
568         currentState = State.REFUND;
569     }
570 
571     /**
572      * @dev Check the amount of wei received by beneficiary.
573      * @param beneficiary Address of beneficiary.
574      */
575     function receivedFrom(address beneficiary) public view returns (uint256) {
576         return received[beneficiary];
577     }
578 
579     /**
580      * @dev Function used to claim wei if refund is enabled.
581      */
582     function claimRefund() public whenNotPaused inState(State.REFUND) {
583         require(received[msg.sender] > 0);
584 
585         uint256 amount = received[msg.sender];
586         received[msg.sender] = 0;
587         msg.sender.transfer(amount);
588         Refund(msg.sender, amount);
589     }
590 
591     /**
592      * @dev Function used to release token of team wallet.
593      */
594     function releaseTeamTokens() public {
595         teamTokens.release();
596     }
597 
598     /**
599      * @dev Function used to reclaim ether by owner.
600      */
601     function reclaimEther() public onlyOwner {
602         owner.transfer(this.balance);
603     }
604 
605     /**
606      * @dev Get exchange rate based on time and amount.
607      * @param amount Amount received.
608      * @return An uint256 representing the exchange rate.
609      */
610     function getRate(uint256 amount) internal view returns (uint256) {
611         if(now < preSaleEnd) {
612             require(amount >= 6797 finney);
613 
614             if(amount <= 8156 finney)
615                 return rate.mul(105).div(100);
616             if(amount <= 9515 finney)
617                 return rate.mul(1055).div(1000);
618             if(amount <= 10874 finney)
619                 return rate.mul(1065).div(1000);
620             if(amount <= 12234 finney)
621                 return rate.mul(108).div(100);
622             if(amount <= 13593 finney)
623                 return rate.mul(110).div(100);
624             if(amount <= 27185 finney)
625                 return rate.mul(113).div(100);
626             if(amount > 27185 finney)
627                 return rate.mul(120).div(100);
628         }
629 
630         return rate;
631     }
632 }