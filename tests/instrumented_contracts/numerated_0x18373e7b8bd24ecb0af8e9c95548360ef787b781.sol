1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4 
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7 
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address _owner) public view returns (uint256);
10     function transfer(address _to, uint256 _value) public returns (bool);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
12     function approve(address _spender, uint256 _value) public returns (bool);
13     function allowance(address _owner, address _spender) public view returns (uint256);
14 }
15 
16 contract ERC20Token is ERC20Interface {
17 
18     using SafeMath for uint256;
19 
20     // Total amount of tokens issued
21     uint256 internal totalTokenIssued;
22 
23     mapping(address => uint256) balances;
24     mapping(address => mapping (address => uint256)) internal allowed;
25 
26     function totalSupply() public view returns (uint256) {
27         return totalTokenIssued;
28     }
29 
30     /* Get the account balance for an address */
31     function balanceOf(address _owner) public view returns (uint256) {
32         return balances[_owner];
33     }
34 
35     /* Check whether an address is a contract address */
36     function isContract(address addr) internal view returns (bool) {
37         uint256 size;
38         assembly { size := extcodesize(addr) }
39         return (size > 0);
40     }
41 
42 
43     /* Transfer the balance from owner's account to another account */
44     function transfer(address _to, uint256 _amount) public returns (bool) {
45 
46         require(_to != address(0x0));
47 
48         // Do not allow to transfer token to contract address to avoid tokens getting stuck
49         require(isContract(_to) == false);
50 
51         // amount sent cannot exceed balance
52         require(balances[msg.sender] >= _amount);
53 
54 
55         // update balances
56         balances[msg.sender] = balances[msg.sender].sub(_amount);
57         balances[_to]        = balances[_to].add(_amount);
58 
59         // log event
60         emit Transfer(msg.sender, _to, _amount);
61         return true;
62     }
63 
64 
65     /* Allow _spender to withdraw from your account up to _amount */
66     function approve(address _spender, uint256 _amount) public returns (bool) {
67 
68         require(_spender != address(0x0));
69 
70         // update allowed amount
71         allowed[msg.sender][_spender] = _amount;
72 
73         // log event
74         emit Approval(msg.sender, _spender, _amount);
75         return true;
76     }
77 
78     /* Spender of tokens transfers tokens from the owner's balance */
79     /* Must be pre-approved by owner */
80     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
81 
82         require(_to != address(0x0));
83 
84         // Do not allow to transfer token to contract address to avoid tokens getting stuck
85         require(isContract(_to) == false);
86 
87         // balance checks
88         require(balances[_from] >= _amount);
89         require(allowed[_from][msg.sender] >= _amount);
90 
91         // update balances and allowed amount
92         balances[_from]            = balances[_from].sub(_amount);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
94         balances[_to]              = balances[_to].add(_amount);
95 
96         // log event
97         emit Transfer(_from, _to, _amount);
98         return true;
99     }
100 
101     /* Returns the amount of tokens approved by the owner */
102     /* that can be transferred by spender */
103     function allowance(address _owner, address _spender) public view returns (uint256) {
104         return allowed[_owner][_spender];
105     }
106 }
107 
108 contract Ownable {
109     address public owner;
110 
111     event OwnershipRenounced(address indexed previousOwner);
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116     * account.
117     */
118     function Ownable() public {
119         owner = msg.sender;
120     }
121 
122     /**
123     * @dev Throws if called by any account other than the owner.
124     */
125     modifier onlyOwner() {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     /**
131     * @dev Allows the current owner to transfer control of the contract to a newOwner.
132     * @param newOwner The address to transfer ownership to.
133     */
134     function transferOwnership(address newOwner) public onlyOwner {
135         require(newOwner != address(0));
136         emit OwnershipTransferred(owner, newOwner);
137         owner = newOwner;
138     }
139 
140     /**
141     * @dev Allows the current owner to relinquish control of the contract.
142     */
143     function renounceOwnership() public onlyOwner {
144         emit OwnershipRenounced(owner);
145         owner = address(0);
146     }
147 }
148 
149 contract MainSale is Ownable {
150 
151     using SafeMath for uint256;
152 
153     ShareToken public shrToken;
154 
155     bool public isIcoRunning = false;
156 
157     uint256 public tokenPriceInCent = 2; // cent or $0.02
158     uint256 public ethUsdRateInCent = 0;// cent
159 
160     // Any token amount must be multiplied by this const to reflect decimals
161     uint256 constant E2 = 10**2;
162 
163     /* Allow whitelisted users to send ETH to token contract for buying tokens */
164     function () external payable {
165         require (isIcoRunning);
166         require (ethUsdRateInCent != 0);
167 
168         // Only whitelisted address can buy tokens. Otherwise, refund
169         require (shrToken.isWhitelisted(msg.sender));
170 
171         // Calculate the amount of tokens based on the received ETH
172         uint256 tokens = msg.value.mul(ethUsdRateInCent).mul(E2).div(tokenPriceInCent).div(10**18);
173 
174         uint256 totalIssuedTokens = shrToken.totalMainSaleTokenIssued();
175         uint256 totalMainSaleLimit = shrToken.totalMainSaleTokenLimit();
176 
177         // If the allocated tokens exceed the limit, must refund to user
178         if (totalIssuedTokens.add(tokens) > totalMainSaleLimit) {
179 
180             uint256 tokensAvailable = totalMainSaleLimit.sub(totalIssuedTokens);
181             uint256 tokensToRefund = tokens.sub(tokensAvailable);
182             uint256 ethToRefundInWei = tokensToRefund.mul(tokenPriceInCent).mul(10**18).div(E2).div(ethUsdRateInCent);
183 
184             // Refund
185             msg.sender.transfer(ethToRefundInWei);
186 
187             // Update actual tokens to be sold
188             tokens = tokensAvailable;
189 
190             // Stop ICO
191             isIcoRunning = false;
192         }
193 
194         shrToken.sell(msg.sender, tokens);
195     }
196 
197     function withdrawTo(address _to) public onlyOwner {
198 
199         require(_to != address(0));
200         _to.transfer(address(this).balance);
201     }
202 
203     function withdrawToOwner() public onlyOwner {
204 
205         withdrawTo(owner);
206     }
207 
208     function setEthUsdRateInCent(uint256 _ethUsdRateInCent) public onlyOwner {
209 
210         ethUsdRateInCent = _ethUsdRateInCent; // "_ethUsdRateInCent"
211     }
212 
213     function setTokenPriceInCent(uint256 _tokenPriceInCent) public onlyOwner {
214 
215         tokenPriceInCent = _tokenPriceInCent;
216     }
217 
218     function stopICO() public onlyOwner {
219 
220         isIcoRunning = false;
221     }
222 
223     function startICO(uint256 _ethUsdRateInCent, address _tokenAddress) public onlyOwner {
224 
225         require(_ethUsdRateInCent > 0);
226         require( _tokenAddress != address(0x0) );
227 
228         ethUsdRateInCent = _ethUsdRateInCent;
229         shrToken = ShareToken(_tokenAddress);
230 
231         isIcoRunning = true;
232     }
233 
234     function remainingTokensForSale() public view returns (uint256) {
235 
236         uint256 totalMainSaleLimit = shrToken.totalMainSaleTokenLimit();
237         return totalMainSaleLimit.sub(shrToken.totalMainSaleTokenIssued());
238     }
239 }
240 
241 library SafeMath {
242 
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         uint256 c = a * b;
245         assert(a == 0 || c / a == b);
246         return c;
247     }
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         return (a / b);
251     }
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         assert(b <= a);
254         return (a - b);
255     }
256     function add(uint256 a, uint256 b) internal pure returns (uint256) {
257         uint256 c = a + b;
258         assert(c >= a);
259         return c;
260     }
261 }
262 
263 contract WhiteListManager is Ownable {
264 
265     // The list here will be updated by multiple separate WhiteList contracts
266     mapping (address => bool) public list;
267 
268     function unset(address addr) public onlyOwner {
269 
270         list[addr] = false;
271     }
272 
273     function unsetMany(address[] addrList) public onlyOwner {
274 
275         for (uint256 i = 0; i < addrList.length; i++) {
276 
277             unset(addrList[i]);
278         }
279     }
280 
281     function set(address addr) public onlyOwner {
282 
283         list[addr] = true;
284     }
285 
286     function setMany(address[] addrList) public onlyOwner {
287 
288         for (uint256 i = 0; i < addrList.length; i++) {
289 
290             set(addrList[i]);
291         }
292     }
293 
294     function isWhitelisted(address addr) public view returns (bool) {
295 
296         return list[addr];
297     }
298 }
299 
300 contract ShareToken is ERC20Token, WhiteListManager {
301 
302     using SafeMath for uint256;
303 
304     string public constant name = "ShareToken";
305     string public constant symbol = "SHR";
306     uint8  public constant decimals = 2;
307 
308     address public icoContract;
309 
310     // Any token amount must be multiplied by this const to reflect decimals
311     uint256 constant E2 = 10**2;
312 
313     mapping(address => bool) public rewardTokenLocked;
314     bool public mainSaleTokenLocked = true;
315 
316     uint256 public constant TOKEN_SUPPLY_MAINSALE_LIMIT = 1000000000 * E2; // 1,000,000,000 tokens (1 billion)
317     uint256 public constant TOKEN_SUPPLY_AIRDROP_LIMIT  = 6666666667; // 66,666,666.67 tokens (0.066 billion)
318     uint256 public constant TOKEN_SUPPLY_BOUNTY_LIMIT   = 33333333333; // 333,333,333.33 tokens (0.333 billion)
319 
320     uint256 public airDropTokenIssuedTotal;
321     uint256 public bountyTokenIssuedTotal;
322 
323     uint256 public constant TOKEN_SUPPLY_SEED_LIMIT      = 500000000 * E2; // 500,000,000 tokens (0.5 billion)
324     uint256 public constant TOKEN_SUPPLY_PRESALE_LIMIT   = 2500000000 * E2; // 2,500,000,000.00 tokens (2.5 billion)
325     uint256 public constant TOKEN_SUPPLY_SEED_PRESALE_LIMIT = TOKEN_SUPPLY_SEED_LIMIT + TOKEN_SUPPLY_PRESALE_LIMIT;
326 
327     uint256 public seedAndPresaleTokenIssuedTotal;
328 
329     uint8 private constant PRESALE_EVENT    = 0;
330     uint8 private constant MAINSALE_EVENT   = 1;
331     uint8 private constant BOUNTY_EVENT     = 2;
332     uint8 private constant AIRDROP_EVENT    = 3;
333 
334     function ShareToken() public {
335 
336         totalTokenIssued = 0;
337         airDropTokenIssuedTotal = 0;
338         bountyTokenIssuedTotal = 0;
339         seedAndPresaleTokenIssuedTotal = 0;
340         mainSaleTokenLocked = true;
341     }
342 
343     function unlockMainSaleToken() public onlyOwner {
344 
345         mainSaleTokenLocked = false;
346     }
347 
348     function lockMainSaleToken() public onlyOwner {
349 
350         mainSaleTokenLocked = true;
351     }
352 
353     function unlockRewardToken(address addr) public onlyOwner {
354 
355         rewardTokenLocked[addr] = false;
356     }
357 
358     function unlockRewardTokenMany(address[] addrList) public onlyOwner {
359 
360         for (uint256 i = 0; i < addrList.length; i++) {
361 
362             unlockRewardToken(addrList[i]);
363         }
364     }
365 
366     function lockRewardToken(address addr) public onlyOwner {
367 
368         rewardTokenLocked[addr] = true;
369     }
370 
371     function lockRewardTokenMany(address[] addrList) public onlyOwner {
372 
373         for (uint256 i = 0; i < addrList.length; i++) {
374 
375             lockRewardToken(addrList[i]);
376         }
377     }
378 
379     // Check if a given address is locked. The address can be in the whitelist or in the reward
380     function isLocked(address addr) public view returns (bool) {
381 
382         // Main sale is running, any addr is locked
383         if (mainSaleTokenLocked) {
384             return true;
385         } else {
386 
387             // Main sale is ended and thus any whitelist addr is unlocked
388             if (isWhitelisted(addr)) {
389                 return false;
390             } else {
391                 // If the addr is in the reward, it must be checked if locked
392                 // If the addr is not in the reward, it is considered unlocked
393                 return rewardTokenLocked[addr];
394             }
395         }
396     }
397 
398     function totalSupply() public view returns (uint256) {
399 
400         return totalTokenIssued.add(seedAndPresaleTokenIssuedTotal).add(airDropTokenIssuedTotal).add(bountyTokenIssuedTotal);
401     }
402 
403     function totalMainSaleTokenIssued() public view returns (uint256) {
404 
405         return totalTokenIssued;
406     }
407 
408     function totalMainSaleTokenLimit() public view returns (uint256) {
409 
410         return TOKEN_SUPPLY_MAINSALE_LIMIT;
411     }
412 
413     function totalPreSaleTokenIssued() public view returns (uint256) {
414 
415         return seedAndPresaleTokenIssuedTotal;
416     }
417 
418     function transfer(address _to, uint256 _amount) public returns (bool success) {
419 
420         require(isLocked(msg.sender) == false);
421         require(isLocked(_to) == false);
422 
423         return super.transfer(_to, _amount);
424     }
425 
426     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
427 
428         require(isLocked(_from) == false);
429         require(isLocked(_to) == false);
430 
431         return super.transferFrom(_from, _to, _amount);
432     }
433 
434     function setIcoContract(address _icoContract) public onlyOwner {
435 
436         // Allow to set the ICO contract only once
437         require(icoContract == address(0));
438         require(_icoContract != address(0));
439 
440         icoContract = _icoContract;
441     }
442 
443     function sell(address buyer, uint256 tokens) public returns (bool success) {
444 
445         require (icoContract != address(0));
446         // The sell() method can only be called by the fixedly-set ICO contract
447         require (msg.sender == icoContract);
448         require (tokens > 0);
449         require (buyer != address(0));
450 
451         // Only whitelisted address can buy tokens. Otherwise, refund
452         require (isWhitelisted(buyer));
453 
454         require (totalTokenIssued.add(tokens) <= TOKEN_SUPPLY_MAINSALE_LIMIT);
455 
456         // Register tokens issued to the buyer
457         balances[buyer] = balances[buyer].add(tokens);
458 
459         // Update total amount of tokens issued
460         totalTokenIssued = totalTokenIssued.add(tokens);
461 
462         emit Transfer(address(MAINSALE_EVENT), buyer, tokens);
463 
464         return true;
465     }
466 
467     function rewardAirdrop(address _to, uint256 _amount) public onlyOwner {
468 
469         // this check also ascertains _amount is positive
470         require(_amount <= TOKEN_SUPPLY_AIRDROP_LIMIT);
471 
472         require(airDropTokenIssuedTotal < TOKEN_SUPPLY_AIRDROP_LIMIT);
473 
474         uint256 remainingTokens = TOKEN_SUPPLY_AIRDROP_LIMIT.sub(airDropTokenIssuedTotal);
475         if (_amount > remainingTokens) {
476             _amount = remainingTokens;
477         }
478 
479         // Register tokens to the receiver
480         balances[_to] = balances[_to].add(_amount);
481 
482         // Update total amount of tokens issued
483         airDropTokenIssuedTotal = airDropTokenIssuedTotal.add(_amount);
484 
485         // Lock the receiver
486         rewardTokenLocked[_to] = true;
487 
488         emit Transfer(address(AIRDROP_EVENT), _to, _amount);
489     }
490 
491     function rewardBounty(address _to, uint256 _amount) public onlyOwner {
492 
493         // this check also ascertains _amount is positive
494         require(_amount <= TOKEN_SUPPLY_BOUNTY_LIMIT);
495 
496         require(bountyTokenIssuedTotal < TOKEN_SUPPLY_BOUNTY_LIMIT);
497 
498         uint256 remainingTokens = TOKEN_SUPPLY_BOUNTY_LIMIT.sub(bountyTokenIssuedTotal);
499         if (_amount > remainingTokens) {
500             _amount = remainingTokens;
501         }
502 
503         // Register tokens to the receiver
504         balances[_to] = balances[_to].add(_amount);
505 
506         // Update total amount of tokens issued
507         bountyTokenIssuedTotal = bountyTokenIssuedTotal.add(_amount);
508 
509         // Lock the receiver
510         rewardTokenLocked[_to] = true;
511 
512         emit Transfer(address(BOUNTY_EVENT), _to, _amount);
513     }
514 
515     function rewardBountyMany(address[] addrList, uint256[] amountList) public onlyOwner {
516 
517         require(addrList.length == amountList.length);
518 
519         for (uint256 i = 0; i < addrList.length; i++) {
520 
521             rewardBounty(addrList[i], amountList[i]);
522         }
523     }
524 
525     function rewardAirdropMany(address[] addrList, uint256[] amountList) public onlyOwner {
526 
527         require(addrList.length == amountList.length);
528 
529         for (uint256 i = 0; i < addrList.length; i++) {
530 
531             rewardAirdrop(addrList[i], amountList[i]);
532         }
533     }
534 
535     function handlePresaleToken(address _to, uint256 _amount) public onlyOwner {
536 
537         require(_amount <= TOKEN_SUPPLY_SEED_PRESALE_LIMIT);
538 
539         require(seedAndPresaleTokenIssuedTotal < TOKEN_SUPPLY_SEED_PRESALE_LIMIT);
540 
541         uint256 remainingTokens = TOKEN_SUPPLY_SEED_PRESALE_LIMIT.sub(seedAndPresaleTokenIssuedTotal);
542         require (_amount <= remainingTokens);
543 
544         // Register tokens to the receiver
545         balances[_to] = balances[_to].add(_amount);
546 
547         // Update total amount of tokens issued
548         seedAndPresaleTokenIssuedTotal = seedAndPresaleTokenIssuedTotal.add(_amount);
549 
550         emit Transfer(address(PRESALE_EVENT), _to, _amount);
551 
552         // Also add to whitelist
553         set(_to);
554     }
555 
556     function handlePresaleTokenMany(address[] addrList, uint256[] amountList) public onlyOwner {
557 
558         require(addrList.length == amountList.length);
559 
560         for (uint256 i = 0; i < addrList.length; i++) {
561 
562             handlePresaleToken(addrList[i], amountList[i]);
563         }
564     }
565 }