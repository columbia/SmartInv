1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // krypteum public sale contract
6 //
7 // ----------------------------------------------------------------------------
8 
9 
10 // ----------------------------------------------------------------------------
11 //
12 // Owned contract
13 //
14 // ----------------------------------------------------------------------------
15 
16 contract Owned {
17 
18   address public owner;
19   address public newOwner;
20 
21   // Events ---------------------------
22 
23   event OwnershipTransferProposed(address indexed _from, address indexed _to);
24   event OwnershipTransferred(address indexed _from, address indexed _to);
25 
26   // Modifier -------------------------
27 
28   modifier onlyOwner {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   // Functions ------------------------
34 
35   function Owned() public {
36     owner = msg.sender;
37   }
38 
39   function transferOwnership(address _newOwner) public onlyOwner {
40     require(_newOwner != owner);
41     require(_newOwner != address(0x0));
42     OwnershipTransferProposed(owner, _newOwner);
43     newOwner = _newOwner;
44   }
45 
46   function acceptOwnership() public {
47     require(msg.sender == newOwner);
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     if (a == 0) {
62       return 0;
63     }
64     uint256 c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 // ----------------------------------------------------------------------------
89 //
90 // ERC Token Standard #20 Interface
91 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
92 //
93 // ----------------------------------------------------------------------------
94 
95 contract ERC20Interface {
96 
97   // Events ---------------------------
98 
99   event Transfer(address indexed _from, address indexed _to, uint _value);
100   event Approval(address indexed _owner, address indexed _spender, uint _value);
101 
102   // Functions ------------------------
103 
104   function totalSupply() public constant returns (uint);
105   function balanceOf(address _owner) public constant returns (uint balance);
106   function transfer(address _to, uint _value) public returns (bool success);
107   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
108   function approve(address _spender, uint _value) public returns (bool success);
109   function allowance(address _owner, address _spender) public constant returns (uint remaining);
110 
111 }
112 
113 // ----------------------------------------------------------------------------
114 //
115 // ERC Coin Standard #20
116 //
117 // ----------------------------------------------------------------------------
118 
119 contract ERC20Coin is ERC20Interface, Owned {
120   
121   using SafeMath for uint;
122 
123   uint public coinsIssuedTotal = 0;
124   mapping(address => uint) public balances;
125   mapping(address => mapping (address => uint)) public allowed;
126 
127   // Functions ------------------------
128 
129   /* Total coin supply */
130 
131   function totalSupply() public constant returns (uint) {
132     return coinsIssuedTotal;
133   }
134 
135   /* Get the account balance for an address */
136 
137   function balanceOf(address _owner) public constant returns (uint balance) {
138     return balances[_owner];
139   }
140 
141   /* Transfer the balance from owner's account to another account */
142 
143   function transfer(address _to, uint _amount) public returns (bool success) {
144     // amount sent cannot exceed balance
145     require(balances[msg.sender] >= _amount);
146 
147     // update balances
148     balances[msg.sender] = balances[msg.sender].sub(_amount);
149     balances[_to] = balances[_to].add(_amount);
150 
151     // log event
152     Transfer(msg.sender, _to, _amount);
153     return true;
154   }
155 
156   /* Allow _spender to withdraw from your account up to _amount */
157 
158   function approve(address _spender, uint _amount) public returns (bool success) {
159     // approval amount cannot exceed the balance
160     require (balances[msg.sender] >= _amount);
161       
162     // update allowed amount
163     allowed[msg.sender][_spender] = _amount;
164     
165     // log event
166     Approval(msg.sender, _spender, _amount);
167     return true;
168   }
169 
170   /* Spender of coins transfers coins from the owner's balance */
171   /* Must be pre-approved by owner */
172 
173   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
174     // balance checks
175     require(balances[_from] >= _amount);
176     require(allowed[_from][msg.sender] >= _amount);
177 
178     // update balances and allowed amount
179     balances[_from] = balances[_from].sub(_amount);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181     balances[_to] = balances[_to].add(_amount);
182 
183     // log event
184     Transfer(_from, _to, _amount);
185     return true;
186   }
187 
188   /* Returns the amount of coins approved by the owner */
189   /* that can be transferred by spender */
190 
191   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
192     return allowed[_owner][_spender];
193   }
194 
195 }
196 
197 contract krypteum is ERC20Coin {
198 
199   /* Basic coin data */
200 
201   string public constant name = "krypteum";
202   string public constant symbol = "KTM";
203   uint8  public constant decimals = 2;
204 
205   /* Wallet and Admin addresses - initially set to owner at deployment */
206 
207   address public wallet;
208   address public administrator;
209 
210   /* ICO dates */
211 
212   uint public constant DATE_ICO_START = 1518480000; // 13-Feb-2018 00:00 GMT
213   uint public constant DATE_ICO_END   = 1522713540; // 2-Apr-2018 23:59 GMT
214 
215   /* ICO coins per ETH */
216   uint public constant COIN_COST_ICO_TIER_1 = 110 finney; // 0.11 ETH
217   uint public constant COIN_COST_ICO_TIER_2 = 120 finney; // 0.12 ETH
218   uint public constant COIN_COST_ICO_TIER_3 = 130 finney; // 0.13 ETH
219 
220   /* ICO and other coin supply parameters */
221 
222   uint public constant COIN_SUPPLY_ICO_TIER_1 = 50000; // 50K coins
223   uint public constant COIN_SUPPLY_ICO_TIER_2 = 25000; // 25K coins
224   uint public constant COIN_SUPPLY_ICO_TIER_3 = 25000; // 25K coins
225   uint public constant COIN_SUPPLY_ICO_TOTAL =         // 100K coins
226     COIN_SUPPLY_ICO_TIER_1 + COIN_SUPPLY_ICO_TIER_2 + COIN_SUPPLY_ICO_TIER_3;
227 
228   uint public constant COIN_SUPPLY_MARKETING_TOTAL =   200000; // 200K coins
229 
230   /* Other ICO parameters */
231 
232   uint public constant COOLDOWN_PERIOD =  24 hours;
233 
234   /* Crowdsale variables */
235 
236   uint public icoEtherReceived = 0; // Ether actually received by the contract
237   uint public coinsIssuedMkt = 0;
238   uint public coinsIssuedIco  = 0;
239   uint[] public numberOfCoinsAvailableInIcoTier;
240   uint[] public costOfACoinInWeiForTier;
241 
242   /* Keep track of Ether contributed and coins received during Crowdsale */
243 
244   mapping(address => uint) public icoEtherContributed;
245   mapping(address => uint) public icoCoinsReceived;
246 
247   /* Keep track of participants who
248   /* - have reclaimed their contributions in case of failed Crowdsale */
249   /* - are locked */
250 
251   mapping(address => bool) public locked;
252 
253   // Events ---------------------------
254 
255   event WalletUpdated(address _newWallet);
256   event AdministratorUpdated(address _newAdministrator);
257   event CoinsMinted(address indexed _owner, uint _coins, uint _balance);
258   event CoinsIssued(address indexed _owner, uint _coins, uint _balance, uint _etherContributed);
259   event LockRemoved(address indexed _participant);
260 
261   // Basic Functions ------------------
262 
263   /* Initialize (owner is set to msg.sender by Owned.Owned() */
264 
265   function krypteum() public {
266     wallet = owner;
267     administrator = owner;
268 
269     numberOfCoinsAvailableInIcoTier.length = 3;
270     numberOfCoinsAvailableInIcoTier[0] = COIN_SUPPLY_ICO_TIER_1;
271     numberOfCoinsAvailableInIcoTier[1] = COIN_SUPPLY_ICO_TIER_2;
272     numberOfCoinsAvailableInIcoTier[2] = COIN_SUPPLY_ICO_TIER_3;
273 
274     costOfACoinInWeiForTier.length = 3;
275     costOfACoinInWeiForTier[0] = COIN_COST_ICO_TIER_1;
276     costOfACoinInWeiForTier[1] = COIN_COST_ICO_TIER_2;
277     costOfACoinInWeiForTier[2] = COIN_COST_ICO_TIER_3;
278   }
279 
280   /* Fallback */
281 
282   function () public payable {
283     buyCoins();
284   }
285 
286   // Information functions ------------
287 
288   /* What time is it? */
289 
290   function atNow() public constant returns (uint) {
291     return now;
292   }
293 
294     /* Are coins transferable? */
295 
296   function isTransferable() public constant returns (bool transferable) {
297       return atNow() >= DATE_ICO_END + COOLDOWN_PERIOD;
298   }
299 
300   // Lock functions -------------------
301 
302   /* Manage locked */
303 
304   function removeLock(address _participant) public {
305     require(msg.sender == administrator || msg.sender == owner);
306 
307     locked[_participant] = false;
308     LockRemoved(_participant);
309   }
310 
311   function removeLockMultiple(address[] _participants) public {
312     require(msg.sender == administrator || msg.sender == owner);
313 
314     for (uint i = 0; i < _participants.length; i++) {
315       locked[_participants[i]] = false;
316       LockRemoved(_participants[i]);
317     }
318   }
319 
320   // Owner Functions ------------------
321 
322   /* Change the crowdsale wallet address */
323 
324   function setWallet(address _wallet) public onlyOwner {
325     require(_wallet != address(0x0));
326     wallet = _wallet;
327     WalletUpdated(wallet);
328   }
329 
330   /* Change the administrator address */
331 
332   function setAdministrator(address _admin) public onlyOwner {
333     require(_admin != address(0x0));
334     administrator = _admin;
335     AdministratorUpdated(administrator);
336   }
337 
338   /* Granting / minting of marketing coins by owner */
339 
340   function grantCoins(address _participant, uint _coins) public onlyOwner {
341     // check amount
342     require(_coins <= COIN_SUPPLY_MARKETING_TOTAL.sub(coinsIssuedMkt));
343 
344     // update balances
345     balances[_participant] = balances[_participant].add(_coins);
346     coinsIssuedMkt = coinsIssuedMkt.add(_coins);
347     coinsIssuedTotal = coinsIssuedTotal.add(_coins);
348 
349     // locked
350     locked[_participant] = true;
351 
352     // log the minting
353     Transfer(0x0, _participant, _coins);
354     CoinsMinted(_participant, _coins, balances[_participant]);
355   }
356 
357   /* Transfer out any accidentally sent ERC20 tokens */
358 
359   function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
360       return ERC20Interface(tokenAddress).transfer(owner, amount);
361   }
362 
363   // Private functions ----------------
364 
365   /* Accept ETH during crowdsale (called by default function) */
366 
367   function buyCoins() private {
368     uint ts = atNow();
369     uint coins = 0;
370     uint change = 0;
371 
372     // check dates for ICO
373     require(DATE_ICO_START < ts && ts < DATE_ICO_END);
374 
375     (coins, change) = calculateCoinsPerWeiAndUpdateAvailableIcoCoins(msg.value);
376 
377     // ICO coins are available to be sold.
378     require(coins > 0);
379 
380     // ICO coin volume cap
381     require(coinsIssuedIco.add(coins).add(sumOfAvailableIcoCoins()) == COIN_SUPPLY_ICO_TOTAL);
382 
383     // change is not given back unless we're selling the last available ICO coins.
384     require(change == 0 || coinsIssuedIco.add(coins) == COIN_SUPPLY_ICO_TOTAL);
385 
386     // register coins
387     balances[msg.sender] = balances[msg.sender].add(coins);
388     icoCoinsReceived[msg.sender] = icoCoinsReceived[msg.sender].add(coins);
389     coinsIssuedIco = coinsIssuedIco.add(coins);
390     coinsIssuedTotal = coinsIssuedTotal.add(coins);
391 
392     // register Ether
393     icoEtherReceived = icoEtherReceived.add(msg.value).sub(change);
394     icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value).sub(change);
395 
396     // locked
397     locked[msg.sender] = true;
398 
399     // log coin issuance
400     Transfer(0x0, msg.sender, coins);
401     CoinsIssued(msg.sender, coins, balances[msg.sender], msg.value.sub(change));
402 
403     // return a change if not enough ICO coins left
404     if (change > 0)
405        msg.sender.transfer(change);
406 
407     wallet.transfer(this.balance);
408   }
409 
410   function sumOfAvailableIcoCoins() internal constant returns (uint totalAvailableIcoCoins) {
411     totalAvailableIcoCoins = 0;
412     for (uint8 i = 0; i < numberOfCoinsAvailableInIcoTier.length; i++) {
413       totalAvailableIcoCoins = totalAvailableIcoCoins.add(numberOfCoinsAvailableInIcoTier[i]);
414     }
415   }
416 
417   function calculateCoinsPerWeiAndUpdateAvailableIcoCoins(uint value) internal returns (uint coins, uint change) {
418     coins = 0;
419     change = value;
420 
421     for (uint8 i = 0; i < numberOfCoinsAvailableInIcoTier.length; i++) {
422       uint costOfAvailableCoinsInCurrentTier = numberOfCoinsAvailableInIcoTier[i].mul(costOfACoinInWeiForTier[i]);
423 
424       if (change <= costOfAvailableCoinsInCurrentTier) {
425         uint coinsInCurrentTierToBuy = change.div(costOfACoinInWeiForTier[i]);
426         coins = coins.add(coinsInCurrentTierToBuy);
427         numberOfCoinsAvailableInIcoTier[i] = numberOfCoinsAvailableInIcoTier[i].sub(coinsInCurrentTierToBuy);
428         change = 0;
429         break;
430       }
431 
432       coins = coins.add(numberOfCoinsAvailableInIcoTier[i]);
433       change = change.sub(costOfAvailableCoinsInCurrentTier);
434       numberOfCoinsAvailableInIcoTier[i] = 0;
435     }
436   }
437 
438   // ERC20 functions ------------------
439 
440   /* Override "transfer" (ERC20) */
441 
442   function transfer(address _to, uint _amount) public returns (bool success) {
443     require(isTransferable());
444     require(locked[msg.sender] == false);
445     require(locked[_to] == false);
446 
447     return super.transfer(_to, _amount);
448   }
449 
450   /* Override "transferFrom" (ERC20) */
451 
452   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
453     require(isTransferable());
454     require(locked[_from] == false);
455     require(locked[_to] == false);
456 
457     return super.transferFrom(_from, _to, _amount);
458   }
459 
460   // External functions ---------------
461 
462   /* Multiple coin transfers from one address to save gas */
463   /* (longer _amounts array not accepted = sanity check) */
464 
465   function transferMultiple(address[] _addresses, uint[] _amounts) external {
466     require(isTransferable());
467     require(locked[msg.sender] == false);
468     require(_addresses.length == _amounts.length);
469 
470     for (uint i = 0; i < _addresses.length; i++) {
471       if (locked[_addresses[i]] == false)
472          super.transfer(_addresses[i], _amounts[i]);
473     }
474   }
475 }