1 // our mirrors:
2 // ftec.io
3 // ftec.ai 
4 // our official Telegram group:
5 // t.me/FTECofficial
6 
7 pragma solidity ^0.4.18;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract MultiOwnable {
41 
42     mapping (address => bool) public isOwner;
43     address[] public ownerHistory;
44 
45     event OwnerAddedEvent(address indexed _newOwner);
46     event OwnerRemovedEvent(address indexed _oldOwner);
47 
48     function MultiOwnable() public {
49         // Add default owner
50         address owner = msg.sender;
51         ownerHistory.push(owner);
52         isOwner[owner] = true;
53     }
54 
55     modifier onlyOwner() {
56         require(isOwner[msg.sender]);
57         _;
58     }
59     
60     function ownerHistoryCount() public view returns (uint) {
61         return ownerHistory.length;
62     }
63 
64     /** Add extra owner. */
65     function addOwner(address owner) onlyOwner public {
66         require(owner != address(0));
67         require(!isOwner[owner]);
68         ownerHistory.push(owner);
69         isOwner[owner] = true;
70         OwnerAddedEvent(owner);
71     }
72 
73     /** Remove extra owner. */
74     function removeOwner(address owner) onlyOwner public {
75         require(isOwner[owner]);
76         isOwner[owner] = false;
77         OwnerRemovedEvent(owner);
78     }
79 }
80 
81 contract Pausable is MultiOwnable {
82 
83     bool public paused;
84 
85     modifier ifNotPaused {
86         require(!paused);
87         _;
88     }
89 
90     modifier ifPaused {
91         require(paused);
92         _;
93     }
94 
95     // Called by the owner on emergency, triggers paused state
96     function pause() external onlyOwner ifNotPaused {
97         paused = true;
98     }
99 
100     // Called by the owner on end of emergency, returns to normal state
101     function resume() external onlyOwner ifPaused {
102         paused = false;
103     }
104 }
105 
106 contract ERC20 {
107 
108     uint256 public totalSupply;
109 
110     function balanceOf(address _owner) public view returns (uint256 balance);
111 
112     function transfer(address _to, uint256 _value) public returns (bool success);
113 
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
115 
116     function approve(address _spender, uint256 _value) public returns (bool success);
117 
118     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
119 
120     event Transfer(address indexed _from, address indexed _to, uint256 _value);
121     
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }
124 
125 contract StandardToken is ERC20 {
126     
127     using SafeMath for uint;
128 
129     mapping(address => uint256) balances;
130     
131     mapping(address => mapping(address => uint256)) allowed;
132 
133     function balanceOf(address _owner) public view returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
147     /// @param _from Address from where tokens are withdrawn.
148     /// @param _to Address to where tokens are sent.
149     /// @param _value Number of tokens to transfer.
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152         
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /// @dev Sets approved amount of tokens for spender. Returns success.
161     /// @param _spender Address of allowed account.
162     /// @param _value Number of approved tokens.
163     function approve(address _spender, uint256 _value) public returns (bool) {
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     /// @dev Returns number of allowed tokens for given address.
170     /// @param _owner Address of token owner.
171     /// @param _spender Address of token spender.
172     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
173         return allowed[_owner][_spender];
174     }
175 }
176 
177 contract CommonToken is StandardToken, MultiOwnable {
178     
179     string public constant name   = 'FTEC';
180     string public constant symbol = 'FTEC';
181     uint8 public constant decimals = 18;
182     
183     uint256 public saleLimit;   // 85% of tokens for sale.
184     uint256 public teamTokens;  // 7% of tokens goes to the team and will be locked for 1 year.
185     // 8% of the rest tokens will be used for bounty, advisors, and airdrops.
186     
187     // 7% of team tokens will be locked at this address for 1 year.
188     address public teamWallet; // Team address.
189     
190     uint public unlockTeamTokensTime = now + 1 years;
191 
192     // The main account that holds all tokens at the beginning and during tokensale.
193     address public seller; // Seller address (main holder of tokens)
194 
195     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
196     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
197 
198     // Lock the transfer functions during tokensales to prevent price speculations.
199     bool public locked = true;
200     
201     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
202     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
203     event Burn(address indexed _burner, uint256 _value);
204     event Unlock();
205 
206     function CommonToken(
207         address _seller,
208         address _teamWallet
209     ) MultiOwnable() public {
210         
211         totalSupply = 998400000 ether;
212         saleLimit   = 848640000 ether;
213         teamTokens  =  69888000 ether;
214 
215         seller = _seller;
216         teamWallet = _teamWallet;
217 
218         uint sellerTokens = totalSupply - teamTokens;
219         balances[seller] = sellerTokens;
220         Transfer(0x0, seller, sellerTokens);
221         
222         balances[teamWallet] = teamTokens;
223         Transfer(0x0, teamWallet, teamTokens);
224     }
225     
226     modifier ifUnlocked(address _from) {
227         require(!locked);
228         
229         // If requested a transfer from the team wallet:
230         if (_from == teamWallet) {
231             require(now >= unlockTeamTokensTime);
232         }
233         
234         _;
235     }
236     
237     /** Can be called once by super owner. */
238     function unlock() onlyOwner public {
239         require(locked);
240         locked = false;
241         Unlock();
242     }
243 
244     /**
245      * An address can become a new seller only in case it has no tokens.
246      * This is required to prevent stealing of tokens  from newSeller via 
247      * 2 calls of this function.
248      */
249     function changeSeller(address newSeller) onlyOwner public returns (bool) {
250         require(newSeller != address(0));
251         require(seller != newSeller);
252         
253         // To prevent stealing of tokens from newSeller via 2 calls of changeSeller:
254         require(balances[newSeller] == 0);
255 
256         address oldSeller = seller;
257         uint256 unsoldTokens = balances[oldSeller];
258         balances[oldSeller] = 0;
259         balances[newSeller] = unsoldTokens;
260         Transfer(oldSeller, newSeller, unsoldTokens);
261 
262         seller = newSeller;
263         ChangeSellerEvent(oldSeller, newSeller);
264         return true;
265     }
266 
267     /**
268      * User-friendly alternative to sell() function.
269      */
270     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
271         return sell(_to, _value * 1e18);
272     }
273 
274     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
275 
276         // Check that we are not out of limit and still can sell tokens:
277         require(tokensSold.add(_value) <= saleLimit);
278 
279         require(_to != address(0));
280         require(_value > 0);
281         require(_value <= balances[seller]);
282 
283         balances[seller] = balances[seller].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         Transfer(seller, _to, _value);
286 
287         totalSales++;
288         tokensSold = tokensSold.add(_value);
289         SellEvent(seller, _to, _value);
290         return true;
291     }
292     
293     /**
294      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
295      */
296     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender) public returns (bool) {
297         return super.transfer(_to, _value);
298     }
299 
300     /**
301      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
302      */
303     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from) public returns (bool) {
304         return super.transferFrom(_from, _to, _value);
305     }
306 
307     function burn(uint256 _value) public returns (bool) {
308         require(_value > 0);
309 
310         balances[msg.sender] = balances[msg.sender].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312         Transfer(msg.sender, 0x0, _value);
313         Burn(msg.sender, _value);
314         return true;
315     }
316 }
317 
318 contract CommonTokensale is MultiOwnable, Pausable {
319     
320     using SafeMath for uint;
321     
322     address public beneficiary1;
323     address public beneficiary2;
324     address public beneficiary3;
325     
326     // Balances of beneficiaries:
327     uint public balance1;
328     uint public balance2;
329     uint public balance3;
330     
331     // Token contract reference.
332     CommonToken public token;
333 
334     uint public minPaymentWei = 0.1 ether;
335     
336     uint public minCapWei;
337     uint public maxCapWei;
338 
339     uint public startTime;
340     uint public endTime;
341     
342     // Stats for current tokensale:
343     
344     uint public totalTokensSold;  // Total amount of tokens sold during this tokensale.
345     uint public totalWeiReceived; // Total amount of wei received during this tokensale.
346     
347     // This mapping stores info on how many ETH (wei) have been sent to this tokensale from specific address.
348     mapping (address => uint256) public buyerToSentWei;
349     
350     event ReceiveEthEvent(address indexed _buyer, uint256 _amountWei);
351     
352     function CommonTokensale(
353         address _token,
354         address _beneficiary1,
355         address _beneficiary2,
356         address _beneficiary3,
357         uint _startTime,
358         uint _endTime
359     ) MultiOwnable() public {
360 
361         require(_token != address(0));
362         token = CommonToken(_token);
363 
364         beneficiary1 = _beneficiary1;
365         beneficiary2 = _beneficiary2;
366         beneficiary3 = _beneficiary3;
367 
368         startTime = _startTime;
369         endTime   = _endTime;
370     }
371 
372     /** The fallback function corresponds to a donation in ETH. */
373     function() public payable {
374         sellTokensForEth(msg.sender, msg.value);
375     }
376     
377     function sellTokensForEth(
378         address _buyer, 
379         uint256 _amountWei
380     ) ifNotPaused internal {
381         
382         require(startTime <= now && now <= endTime);
383         require(_amountWei >= minPaymentWei);
384         require(totalWeiReceived.add(_amountWei) <= maxCapWei);
385 
386         uint tokensE18 = weiToTokens(_amountWei);
387         // Transfer tokens to buyer.
388         require(token.sell(_buyer, tokensE18));
389         
390         // Update total stats:
391         totalTokensSold = totalTokensSold.add(tokensE18);
392         totalWeiReceived = totalWeiReceived.add(_amountWei);
393         buyerToSentWei[_buyer] = buyerToSentWei[_buyer].add(_amountWei);
394         ReceiveEthEvent(_buyer, _amountWei);
395         
396         // Split received amount between balances of three beneficiaries.
397         uint part = _amountWei / 3;
398         balance1 = balance1.add(_amountWei - part * 2);
399         balance2 = balance2.add(part);
400         balance3 = balance3.add(part);
401     }
402     
403     /** Calc how much tokens you can buy at current time. */
404     function weiToTokens(uint _amountWei) public view returns (uint) {
405         return _amountWei.mul(tokensPerWei(_amountWei));
406     }
407     
408     function tokensPerWei(uint _amountWei) public view returns (uint256) {
409         uint expectedTotal = totalWeiReceived.add(_amountWei);
410         
411         // Presale pricing rules:
412         if (expectedTotal <  1000 ether) return 39960;
413         if (expectedTotal <  2000 ether) return 37480;
414         if (expectedTotal <  4000 ether) return 35270;
415         
416         // Public sale pricing rules:
417         if (expectedTotal <  6000 ether) return 33300; 
418         if (expectedTotal <  8000 ether) return 32580;
419         if (expectedTotal < 11000 ether) return 31880;
420         if (expectedTotal < 15500 ether) return 31220;
421         if (expectedTotal < 20500 ether) return 30590;
422         if (expectedTotal < 26500 ether) return 29970;
423         
424         return 29970; // Default token price with no bonuses.
425     }
426     
427     function canWithdraw() public view returns (bool);
428     
429     function withdraw1(address _to) public {
430         require(canWithdraw());
431         require(msg.sender == beneficiary1);
432         require(balance1 > 0);
433         
434         uint bal = balance1;
435         balance1 = 0;
436         _to.transfer(bal);
437     }
438     
439     function withdraw2(address _to) public {
440         require(canWithdraw());
441         require(msg.sender == beneficiary2);
442         require(balance2 > 0);
443         
444         uint bal = balance2;
445         balance2 = 0;
446         _to.transfer(bal);
447     }
448     
449     function withdraw3(address _to) public {
450         require(canWithdraw());
451         require(msg.sender == beneficiary3);
452         require(balance3 > 0);
453         
454         uint bal = balance3;
455         balance3 = 0;
456         _to.transfer(bal);
457     }
458 }
459 
460 contract Presale is CommonTokensale {
461     
462     // In case min (soft) cap is not reached, token buyers will be able to 
463     // refund their contributions during 3 months after presale is finished.
464     uint public refundDeadlineTime;
465 
466     // Total amount of wei refunded if min (soft) cap is not reached.
467     uint public totalWeiRefunded;
468     
469     event RefundEthEvent(address indexed _buyer, uint256 _amountWei);
470     
471     function Presale(
472         address _token,
473         address _beneficiary1,
474         address _beneficiary2,
475         address _beneficiary3,
476         uint _startTime,
477         uint _endTime
478     ) CommonTokensale(
479         _token,
480         _beneficiary1,
481         _beneficiary2,
482         _beneficiary3,
483         _startTime,
484         _endTime
485     ) public {
486         minCapWei = 2000 ether;
487         maxCapWei = 4000 ether;
488         refundDeadlineTime = _endTime + 3 * 30 days;
489     }
490 
491     /** 
492      * During presale it will be possible to withdraw only in two cases:
493      * min cap reached OR refund period expired.
494      */
495     function canWithdraw() public view returns (bool) {
496         return totalWeiReceived >= minCapWei || now > refundDeadlineTime;
497     }
498     
499     /** 
500      * It will be possible to refund only if min (soft) cap is not reached and 
501      * refund requested during 3 months after presale finished.
502      */
503     function canRefund() public view returns (bool) {
504         return totalWeiReceived < minCapWei && endTime < now && now <= refundDeadlineTime;
505     }
506 
507     function refund() public {
508         require(canRefund());
509         
510         address buyer = msg.sender;
511         uint amount = buyerToSentWei[buyer];
512         require(amount > 0);
513         
514         // Redistribute left balance between three beneficiaries.
515         uint newBal = this.balance.sub(amount);
516         uint part = newBal / 3;
517         balance1 = newBal - part * 2;
518         balance2 = part;
519         balance3 = part;
520         
521         RefundEthEvent(buyer, amount);
522         buyerToSentWei[buyer] = 0;
523         totalWeiRefunded = totalWeiRefunded.add(amount);
524         buyer.transfer(amount);
525     }
526 }
527 
528 contract ProdPresale is Presale {
529     function ProdPresale() Presale(
530         0x6BeC54E4fEa5d541fB14de96993b8E11d81159b2,
531         0x5cAEDf960efC2F586B0260B8B4B3C5738067c3af, 
532         0xec6014B7FF9E510D43889f49AE019BAD6EA35039, 
533         0x234066EEa7B0E9539Ef1f6281f3Ca8aC5e922363, 
534         1524578400, 
535         1526997600 
536     ) public {}
537 }