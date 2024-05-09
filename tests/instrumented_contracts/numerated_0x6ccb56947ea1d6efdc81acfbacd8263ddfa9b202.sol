1 // Royal Kingdom Coin Token
2 // www.royalkingdomcoin.com
3 //
4 // RKC token is a virtual token, governed by ERC20-compatible Ethereum Smart Contract and secured by Ethereum Blockchain
5 // The official website is https://www.royalkingdomcoin.com/
6 //
7 // The uints are all in wei and atto tokens (*10^-18)
8 
9 // The contract code itself, as usual, is at the end, after all the connected libraries
10 
11 pragma solidity ^0.4.11;
12 
13 /**
14  * Math operations with safety checks
15  */
16 library SafeMath {
17   function mul(uint a, uint b) internal returns (uint) {
18     uint c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function div(uint a, uint b) internal returns (uint) {
24     assert(b > 0);
25     uint c = a / b;
26     assert(a == b * c + a % b);
27     return c;
28   }
29 
30   function sub(uint a, uint b) internal returns (uint) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint a, uint b) internal returns (uint) {
36     uint c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 
41   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a >= b ? a : b;
43   }
44 
45   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a < b ? a : b;
47   }
48 
49   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a >= b ? a : b;
51   }
52 
53   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a < b ? a : b;
55   }
56 
57   function assert(bool assertion) internal {
58     if (!assertion) {
59       throw;
60     }
61   }
62 }
63 
64 
65 /*
66  * ERC20Basic
67  * Simpler version of ERC20 interface
68  * see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20Basic {
71   uint public totalSupply;
72   function balanceOf(address who) constant returns (uint);
73   function transfer(address to, uint value);
74   event Transfer(address indexed from, address indexed to, uint value);
75 }
76 
77 
78 
79 
80 /*
81  * Basic token
82  * Basic version of StandardToken, with no allowances
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint;
86 
87   mapping(address => uint) balances;
88 
89   /*
90    * Fix for the ERC20 short address attack  
91    */
92   modifier onlyPayloadSize(uint size) {
93      if(msg.data.length < size + 4) {
94        throw;
95      }
96      _;
97   }
98 
99   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103   }
104 
105   function balanceOf(address _owner) constant returns (uint balance) {
106     return balances[_owner];
107   }
108   
109 }
110 
111 
112 
113 
114 /*
115  * ERC20 interface
116  * see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) constant returns (uint);
120   function transferFrom(address from, address to, uint value);
121   function approve(address spender, uint value);
122   event Approval(address indexed owner, address indexed spender, uint value);
123 }
124 
125 
126 
127 
128 /**
129  * Standard ERC20 token
130  *
131  * https://github.com/ethereum/EIPs/issues/20
132  * Based on code by FirstBlood:
133  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is BasicToken, ERC20 {
136 
137   mapping (address => mapping (address => uint)) allowed;
138 
139   function transferFrom(address _from, address _to, uint _value) {
140     var _allowance = allowed[_from][msg.sender];
141 
142     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143     // if (_value > _allowance) throw;
144 
145     balances[_to] = balances[_to].add(_value);
146     balances[_from] = balances[_from].sub(_value);
147     allowed[_from][msg.sender] = _allowance.sub(_value);
148     Transfer(_from, _to, _value);
149   }
150 
151   function approve(address _spender, uint _value) {
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154   }
155 
156   function allowance(address _owner, address _spender) constant returns (uint remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160 }
161 
162 
163 /*
164  * Ownable
165  *
166  * Base contract with an owner.
167  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
168  */
169 contract Ownable {
170   address public owner;
171 
172   function Ownable() {
173     owner = msg.sender;
174   }
175 
176   modifier onlyOwner() {
177     if (msg.sender != owner) {
178       throw;
179     }
180     _;
181   }
182 
183   function transferOwnership(address newOwner) onlyOwner {
184     if (newOwner != address(0)) {
185       owner = newOwner;
186     }
187   }
188 
189 }
190 
191 
192 contract RKCToken is StandardToken, Ownable {
193     using SafeMath for uint;
194 
195     //--------------   Info for ERC20 explorers  -----------------//
196     string public name = "Royal Kingdom Coin";
197     string public symbol = "RKC";
198     uint public decimals = 18;
199 
200     //---------------------   Constants   ------------------------//
201     bool public constant TEST_MODE = false;
202     uint public constant atto = 1000000000000000000;
203     uint public constant INITIAL_SUPPLY = 15000000 * atto; // 15 mln RKC. Impossible to mint more than this
204     address public teamWallet = 0xb79F963f200f85D0e3dD60C82ABB8F80b5869CB9;
205     // Made up ICO address (designating the token pool reserved for ICO, no one has access to it)
206     address public ico_address = 0x1c01C01C01C01c01C01c01c01c01C01c01c01c01;
207     uint public constant ICO_START_TIME = 1499810400;
208 
209     //----------------------  Variables  -------------------------//
210     uint public current_supply = 0; // Holding the number of all the coins in existence
211     uint public ico_starting_supply = 0; // How many atto tokens *were* available for sale at the beginning of the ICO
212     uint public current_price_atto_tokens_per_wei = 0; // Holding current price (determined by the algorithm in buy())
213 
214     //-------------   Flags describing ICO stages   --------------//
215     bool public preSoldSharesDistributed = false; // Prevents accidental re-distribution of shares
216     bool public isICOOpened = false;
217     bool public isICOClosed = false;
218     // 3 stages:
219     // Contract has just been deployed and initialized. isICOOpened == false, isICOClosed == false
220     // ICO has started, now anybody can buy(). isICOOpened == true, isICOClosed == false
221     // ICO has finished, now the team can receive the ether. isICOOpened == false, isICOClosed == true
222 
223     //---------------------   Premiums   -------------------------//
224     uint[] public premiumPacks;
225     mapping(address => uint) premiumPacksPaid;
226 
227     //----------------------   Events  ---------------------------//
228     event ICOOpened();
229     event ICOClosed();
230     event PriceChanged(uint old_price, uint new_price);
231     event SupplyChanged(uint supply, uint old_supply);
232     event RKCAcquired(address account, uint amount_in_wei, uint amount_in_rkc);
233 
234     // ***************************************************************************
235 
236     // Constructor
237     function RKCToken() {
238         // Some percentage of the tokens is already reserved by early employees and investors
239         // Here we're initializing their balances
240         distributePreSoldShares();
241 
242         // Starting price
243         current_price_atto_tokens_per_wei = calculateCurrentPrice(1);
244 
245         // Some other initializations
246         premiumPacks.length = 0;
247     }
248 
249     // Sending ether directly to the contract invokes buy() and assigns tokens to the sender
250     function () payable {
251         buy();
252     }
253 
254     // ***************************************************************************
255 
256     // Buy token by sending ether here
257     //
258     // Price is being determined by the algorithm in recalculatePrice()
259     // You can also send the ether directly to the contract address
260     function buy() payable {
261         if (msg.value == 0) throw; // no tokens for you
262 
263         // Only works in the ICO stage, after that the token is going to be traded on the exchanges
264         if (!isICOOpened) throw;
265         if (isICOClosed) throw;
266 
267         // Deciding how many tokens can be bought with the ether received
268         uint tokens = getAttoTokensAmountPerWeiInternal(msg.value);
269 
270         // Don't allow to buy more than 1% per transaction (secures from huge investors swalling the whole thing in 1 second)
271         uint allowedInOneTransaction = current_supply / 100;
272         if (tokens > allowedInOneTransaction) throw;
273 
274         // Just in case
275         if (tokens > balances[ico_address]) throw;
276 
277         // Transfer from the ICO pool
278         balances[ico_address] = balances[ico_address].sub(tokens); // if not enough, will throw
279         balances[msg.sender] = balances[msg.sender].add(tokens);
280 
281         // Kick the price changing algo
282         uint old_price = current_price_atto_tokens_per_wei;
283         current_price_atto_tokens_per_wei = calculateCurrentPrice(getAttoTokensBoughtInICO());
284         if (current_price_atto_tokens_per_wei == 0) current_price_atto_tokens_per_wei = 1; // in case it is too small that it gets rounded to zero
285         if (current_price_atto_tokens_per_wei > old_price) current_price_atto_tokens_per_wei = old_price; // in case some weird overflow happens
286 
287         // Broadcasting price change event
288         if (old_price != current_price_atto_tokens_per_wei) PriceChanged(old_price, current_price_atto_tokens_per_wei);
289 
290         // Broadcasting the buying event
291         RKCAcquired(msg.sender, msg.value, tokens);
292     }
293 
294     // Formula for the dynamic price change algorithm
295     function calculateCurrentPrice(uint attoTokensBought) constant returns (uint result) {
296         // see http://www.wolframalpha.com/input/?i=f(x)+%3D+395500000+%2F+(x+%2B+150000)+-+136
297         return (395500000 / ((attoTokensBought / atto) + 150000)).sub(136); // mixing safe and usual math here because the division will throw on inconsistency
298     }
299 
300     // ***************************************************************************
301 
302     // Functions for the contract owner
303 
304     function openICO() onlyOwner {
305         if (isICOOpened) throw;
306         if (isICOClosed) throw;
307         isICOOpened = true;
308 
309         ICOOpened();
310     }
311     function closeICO() onlyOwner {
312         if (isICOClosed) throw;
313         if (!isICOOpened) throw;
314 
315         isICOOpened = false;
316         isICOClosed = true;
317 
318         // Redistribute ICO Tokens that were not bought as the first premiums
319         premiumPacks.length = 1;
320         premiumPacks[0] = balances[ico_address];
321         balances[ico_address] = 0;
322 
323         ICOClosed();
324     }
325     function pullEtherFromContract() onlyOwner {
326         // Only when ICO is closed
327         if (!isICOClosed) throw;
328 
329         if (!teamWallet.send(this.balance)) {
330             throw;
331         }
332     }
333 
334     // ***************************************************************************
335 
336     // Some percentage of the tokens is already reserved by early employees and investors
337     // Here we're initializing their balances
338     function distributePreSoldShares() onlyOwner {
339         // Making it impossible to call this function twice
340         if (preSoldSharesDistributed) throw;
341         preSoldSharesDistributed = true;
342 
343         // Values are in atto tokens
344         balances[0x7A3c869603E28b0242c129440c9dD97F8A5bEe80] = 7508811 * atto;
345         balances[0x24a541dEAe0Fc87C990A208DE28a293fb2A982d9] = 4025712 * atto;
346         balances[0xEcF843458e76052E6363fFb78C7535Cd87AA3AB2] = 300275 * atto;
347         balances[0x947963ED2da750a0712AE0BF96E08C798813F277] = 150000 * atto;
348         balances[0x82Bc8452Ab76fBA446e16b57C080F5258F557734] = 150000 * atto;
349         balances[0x0959Ed48d55e580BB58df6E5ee01BAa787d80848] = 90000 * atto;
350         balances[0x530A8016fB5B3d7A0F92910b4814e383835Bd51E] = 75000 * atto;
351         balances[0xC3e934D3ADE0Ab9F61F824a9a824462c790e47B0] = 202 * atto;
352         current_supply = (7508811 + 4025712 + 300275 + 150000 + 150000 + 90000 + 75000 + 202) * atto;
353 
354         // Sending the rest to ICO pool
355         balances[ico_address] = INITIAL_SUPPLY.sub(current_supply);
356 
357         // Initializing the supply variables
358         ico_starting_supply = balances[ico_address];
359         current_supply = INITIAL_SUPPLY;
360         SupplyChanged(0, current_supply);
361     }
362 
363     // ***************************************************************************
364 
365     // Some useful getters (although you can just query the public variables)
366 
367     function getCurrentPriceAttoTokensPerWei() constant returns (uint result) {
368         return current_price_atto_tokens_per_wei;
369     }
370     function getAttoTokensAmountPerWeiInternal(uint value) payable returns (uint result) {
371         return value * current_price_atto_tokens_per_wei;
372     }
373     function getAttoTokensAmountPerWei(uint value) constant returns (uint result) {
374         return value * current_price_atto_tokens_per_wei;
375     }
376     function getSupply() constant returns (uint result) {
377         return current_supply;
378     }
379     function getAttoTokensLeftForICO() constant returns (uint result) {
380         return balances[ico_address];
381     }
382     function getAttoTokensBoughtInICO() constant returns (uint result) {
383         return ico_starting_supply - getAttoTokensLeftForICO();
384     }
385     function getBalance(address addr) constant returns (uint balance) {
386         return balances[addr];
387     }
388     function getPremiumPack(uint index) constant returns (uint premium) {
389         return premiumPacks[index];
390     }
391     function getPremiumCount() constant returns (uint length) {
392         return premiumPacks.length;
393     }
394     function getBalancePremiumsPaid(address account) constant returns (uint result) {
395         return premiumPacksPaid[account];
396     }
397 
398     // ***************************************************************************
399 
400     // Premiums
401 
402     function sendPremiumPack(uint amount) onlyOwner allowedPayments(msg.sender, amount) {
403         premiumPacks.length += 1;
404         premiumPacks[premiumPacks.length-1] = amount;
405         balances[msg.sender] = balances[msg.sender].sub(amount); // will throw and revert the whole thing if doesn't have this amount
406     }
407 
408     function updatePremiums(address account) private {
409         if (premiumPacks.length > premiumPacksPaid[account]) {
410             uint startPackIndex = premiumPacksPaid[account];
411             uint finishPackIndex = premiumPacks.length - 1;
412             for(uint i = startPackIndex; i <= finishPackIndex; i++) {
413                 if (current_supply != 0) { // just in case
414                     uint owing = balances[account] * premiumPacks[i] / current_supply;
415                     balances[account] = balances[account].add(owing);
416                 }
417             }
418             premiumPacksPaid[account] = premiumPacks.length;
419         }
420     }
421 
422     // ***************************************************************************
423 
424     // Overriding payment functions to take control over the logic
425 
426     modifier allowedPayments(address payer, uint value) {
427         // Don't allow to transfer coins until the ICO ends
428         if (isICOOpened) throw;
429         if (!isICOClosed) throw;
430 
431         // Limit the quick dump possibility
432         uint diff = 0;
433         uint allowed = 0;
434         if (balances[payer] > current_supply / 100) { // for balances > 1% of total supply
435             if (block.timestamp > ICO_START_TIME) {
436                 diff = block.timestamp - ICO_START_TIME;
437             } else {
438                 diff = ICO_START_TIME - block.timestamp;
439             }
440 
441             allowed = (current_supply / 20) * (diff / (60 * 60 * 24 * 30)); // 5% unlocked every month
442 
443             if (value > allowed) throw;
444         }
445 
446         _;
447     }
448 
449     function transferFrom(address _from, address _to, uint _value) allowedPayments(_from, _value) {
450         updatePremiums(_from);
451         updatePremiums(_to);
452         super.transferFrom(_from, _to, _value);
453     }
454     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) allowedPayments(msg.sender, _value) {
455         updatePremiums(msg.sender);
456         updatePremiums(_to);
457         super.transfer(_to, _value);
458     }
459 
460 }