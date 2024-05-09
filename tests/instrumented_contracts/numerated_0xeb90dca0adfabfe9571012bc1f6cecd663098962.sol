1 // Royal Kingdom Coin Token
2 // www.royalkingdomcoin.com
3 //
4 // RKC token is a virtual token, governed by ERC20-compatible Ethereum Smart Contract and secured by Ethereum Blockchain
5 // The official website is https://www.royalkingdomcoin.com/
6 //
7 // The uints are all in wei and atto tokens (*10^-18)
8 
9 pragma solidity ^0.4.11;
10 
11 /**
12  * Math operations with safety checks
13  */
14 library SafeMath {
15   function mul(uint a, uint b) internal returns (uint) {
16     uint c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal returns (uint) {
22     assert(b > 0);
23     uint c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 
39   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
40     return a >= b ? a : b;
41   }
42 
43   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a < b ? a : b;
45   }
46 
47   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a >= b ? a : b;
49   }
50 
51   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a < b ? a : b;
53   }
54 
55   function assert(bool assertion) internal {
56     if (!assertion) {
57       throw;
58     }
59   }
60 }
61 
62 
63 /*
64  * ERC20Basic
65  * Simpler version of ERC20 interface
66  * see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20Basic {
69   uint public totalSupply;
70   function balanceOf(address who) constant returns (uint);
71   function transfer(address to, uint value);
72   event Transfer(address indexed from, address indexed to, uint value);
73 }
74 
75 
76 
77 
78 /*
79  * Basic token
80  * Basic version of StandardToken, with no allowances
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint;
84 
85   mapping(address => uint) balances;
86 
87   /*
88    * Fix for the ERC20 short address attack  
89    */
90   modifier onlyPayloadSize(uint size) {
91      if(msg.data.length < size + 4) {
92        throw;
93      }
94      _;
95   }
96 
97   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101   }
102 
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106   
107 }
108 
109 
110 
111 
112 /*
113  * ERC20 interface
114  * see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) constant returns (uint);
118   function transferFrom(address from, address to, uint value);
119   function approve(address spender, uint value);
120   event Approval(address indexed owner, address indexed spender, uint value);
121 }
122 
123 
124 
125 
126 /**
127  * Standard ERC20 token
128  *
129  * https://github.com/ethereum/EIPs/issues/20
130  * Based on code by FirstBlood:
131  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is BasicToken, ERC20 {
134 
135   mapping (address => mapping (address => uint)) allowed;
136 
137   function transferFrom(address _from, address _to, uint _value) {
138     var _allowance = allowed[_from][msg.sender];
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // if (_value > _allowance) throw;
142 
143     balances[_to] = balances[_to].add(_value);
144     balances[_from] = balances[_from].sub(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146     Transfer(_from, _to, _value);
147   }
148 
149   function approve(address _spender, uint _value) {
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152   }
153 
154   function allowance(address _owner, address _spender) constant returns (uint remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 
161 /*
162  * Ownable
163  *
164  * Base contract with an owner.
165  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
166  */
167 contract Ownable {
168   address public owner;
169 
170   function Ownable() {
171     owner = msg.sender;
172   }
173 
174   modifier onlyOwner() {
175     if (msg.sender != owner) {
176       throw;
177     }
178     _;
179   }
180 
181   function transferOwnership(address newOwner) onlyOwner {
182     if (newOwner != address(0)) {
183       owner = newOwner;
184     }
185   }
186 
187 }
188 
189 
190 contract RKCToken is StandardToken, Ownable {
191     using SafeMath for uint;
192 
193     //--------------   Info for ERC20 explorers  -----------------//
194     string public name = "Royal Kingdom Coin";
195     string public symbol = "RKC";
196     uint public decimals = 18;
197 
198     //---------------------   Constants   ------------------------//
199     bool public constant TEST_MODE = false;
200     uint public constant atto = 1000000000000000000;
201     uint public constant INITIAL_SUPPLY = 15000000 * atto; // 15 mln RKC. Impossible to mint more than this
202     address public teamWallet = 0xb79F963f200f85D0e3dD60C82ABB8F80b5869CB9;
203     // Made up ICO address (designating the token pool reserved for ICO, no one has access to it)
204     address public ico_address = 0x1c01C01C01C01c01C01c01c01c01C01c01c01c01;
205     uint public constant ICO_START_TIME = 1499810400;
206 
207     //----------------------  Variables  -------------------------//
208     uint public current_supply = 0; // Holding the number of all the coins in existence
209     uint public ico_starting_supply = 0; // How many atto tokens *were* available for sale at the beginning of the ICO
210     uint public current_price_atto_tokens_per_wei = 0; // Holding current price (determined by the algorithm in buy())
211 
212     //-------------   Flags describing ICO stages   --------------//
213     bool public preSoldSharesDistributed = false; // Prevents accidental re-distribution of shares
214     bool public isICOOpened = false;
215     bool public isICOClosed = false;
216     // 3 stages:
217     // Contract has just been deployed and initialized. isICOOpened == false, isICOClosed == false
218     // ICO has started, now anybody can buy(). isICOOpened == true, isICOClosed == false
219     // ICO has finished, now the team can receive the ether. isICOOpened == false, isICOClosed == true
220 
221     //---------------------   Premiums   -------------------------//
222     uint[] public premiumPacks;
223     mapping(address => uint) premiumPacksPaid;
224 
225     //----------------------   Events  ---------------------------//
226     event ICOOpened();
227     event ICOClosed();
228     event PriceChanged(uint old_price, uint new_price);
229     event SupplyChanged(uint supply, uint old_supply);
230     event RKCAcquired(address account, uint amount_in_wei, uint amount_in_rkc);
231 
232     // ***************************************************************************
233 
234     // Constructor
235     function RKCToken() {
236         // Some percentage of the tokens is already reserved by early employees and investors
237         // Here we're initializing their balances
238         distributePreSoldShares();
239 
240         // Starting price
241         current_price_atto_tokens_per_wei = calculateCurrentPrice(1);
242 
243         // Some other initializations
244         premiumPacks.length = 0;
245     }
246 
247     // Sending ether directly to the contract invokes buy() and assigns tokens to the sender
248     function () payable {
249         buy();
250     }
251 
252     // ***************************************************************************
253 
254     // Buy token by sending ether here
255     //
256     // Price is being determined by the algorithm in recalculatePrice()
257     // You can also send the ether directly to the contract address
258     function buy() payable {
259         if (msg.value == 0) throw; // no tokens for you
260 
261         // Only works in the ICO stage, after that the token is going to be traded on the exchanges
262         if (!isICOOpened) throw;
263         if (isICOClosed) throw;
264 
265         // Deciding how many tokens can be bought with the ether received
266         uint tokens = getAttoTokensAmountPerWeiInternal(msg.value);
267 
268         // Don't allow to buy more than 1% per transaction (secures from huge investors swalling the whole thing in 1 second)
269         uint allowedInOneTransaction = current_supply / 100;
270         if (tokens > allowedInOneTransaction) throw;
271 
272         // Just in case
273         if (tokens > balances[ico_address]) throw;
274 
275         // Transfer from the ICO pool
276         balances[ico_address] = balances[ico_address].sub(tokens); // if not enough, will throw
277         balances[msg.sender] = balances[msg.sender].add(tokens);
278 
279         // Kick the price changing algo
280         uint old_price = current_price_atto_tokens_per_wei;
281         current_price_atto_tokens_per_wei = calculateCurrentPrice(getAttoTokensBoughtInICO());
282         if (current_price_atto_tokens_per_wei == 0) current_price_atto_tokens_per_wei = 1; // in case it is too small that it gets rounded to zero
283         if (current_price_atto_tokens_per_wei > old_price) current_price_atto_tokens_per_wei = old_price; // in case some weird overflow happens
284 
285         // Broadcasting price change event
286         if (old_price != current_price_atto_tokens_per_wei) PriceChanged(old_price, current_price_atto_tokens_per_wei);
287 
288         // Broadcasting the buying event
289         RKCAcquired(msg.sender, msg.value, tokens);
290     }
291 
292     // Formula for the dynamic price change algorithm
293     function calculateCurrentPrice(uint attoTokensBought) constant returns (uint result) {
294         // see http://www.wolframalpha.com/input/?i=f(x)+%3D+395500000+%2F+(x+%2B+150000)+-+136
295         return (395500000 / ((attoTokensBought / atto) + 150000)).sub(136); // mixing safe and usual math here because the division will throw on inconsistency
296     }
297 
298     // ***************************************************************************
299 
300     // Functions for the contract owner
301 
302     function openICO() onlyOwner {
303         if (isICOOpened) throw;
304         if (isICOClosed) throw;
305         isICOOpened = true;
306 
307         ICOOpened();
308     }
309     function closeICO() onlyOwner {
310         if (isICOClosed) throw;
311         if (!isICOOpened) throw;
312 
313         isICOOpened = false;
314         isICOClosed = true;
315 
316         // Redistribute ICO Tokens that were not bought as the first premiums
317         premiumPacks.length = 1;
318         premiumPacks[0] = balances[ico_address];
319         balances[ico_address] = 0;
320 
321         ICOClosed();
322     }
323     function pullEtherFromContract() onlyOwner {
324         // Only when ICO is closed
325         if (!isICOClosed) throw;
326 
327         if (!teamWallet.send(this.balance)) {
328             throw;
329         }
330     }
331 
332     // ***************************************************************************
333 
334     // Some percentage of the tokens is already reserved by early employees and investors
335     // Here we're initializing their balances
336     function distributePreSoldShares() onlyOwner {
337         // Making it impossible to call this function twice
338         if (preSoldSharesDistributed) throw;
339         preSoldSharesDistributed = true;
340 
341         // Values are in atto tokens
342         balances[0x7A3c869603E28b0242c129440c9dD97F8A5bEe80] = 7508811 * atto;
343         balances[0x24a541dEAe0Fc87C990A208DE28a293fb2A982d9] = 4025712 * atto;
344         balances[0xEcF843458e76052E6363fFb78C7535Cd87AA3AB2] = 300275 * atto;
345         balances[0x947963ED2da750a0712AE0BF96E08C798813F277] = 150000 * atto;
346         balances[0x82Bc8452Ab76fBA446e16b57C080F5258F557734] = 150000 * atto;
347         balances[0x0959Ed48d55e580BB58df6E5ee01BAa787d80848] = 90000 * atto;
348         balances[0x530A8016fB5B3d7A0F92910b4814e383835Bd51E] = 75000 * atto;
349         balances[0xC3e934D3ADE0Ab9F61F824a9a824462c790e47B0] = 202 * atto;
350         current_supply = (7508811 + 4025712 + 300275 + 150000 + 150000 + 90000 + 75000 + 202) * atto;
351 
352         // Sending the rest to ICO pool
353         balances[ico_address] = INITIAL_SUPPLY.sub(current_supply);
354 
355         // Initializing the supply variables
356         ico_starting_supply = balances[ico_address];
357         current_supply = INITIAL_SUPPLY;
358         SupplyChanged(0, current_supply);
359     }
360 
361     // ***************************************************************************
362 
363     // Some useful getters (although you can just query the public variables)
364 
365     function getCurrentPriceAttoTokensPerWei() constant returns (uint result) {
366         return current_price_atto_tokens_per_wei;
367     }
368     function getAttoTokensAmountPerWeiInternal(uint value) payable returns (uint result) {
369         return value * current_price_atto_tokens_per_wei;
370     }
371     function getAttoTokensAmountPerWei(uint value) constant returns (uint result) {
372         return value * current_price_atto_tokens_per_wei;
373     }
374     function getSupply() constant returns (uint result) {
375         return current_supply;
376     }
377     function getAttoTokensLeftForICO() constant returns (uint result) {
378         return balances[ico_address];
379     }
380     function getAttoTokensBoughtInICO() constant returns (uint result) {
381         return ico_starting_supply - getAttoTokensLeftForICO();
382     }
383     function getBalance(address addr) constant returns (uint balance) {
384         return balances[addr];
385     }
386     function getPremiumPack(uint index) constant returns (uint premium) {
387         return premiumPacks[index];
388     }
389     function getPremiumCount() constant returns (uint length) {
390         return premiumPacks.length;
391     }
392     function getBalancePremiumsPaid(address account) constant returns (uint result) {
393         return premiumPacksPaid[account];
394     }
395 
396     // ***************************************************************************
397 
398     // Premiums
399 
400     function sendPremiumPack(uint amount) onlyOwner allowedPayments(msg.sender, amount) {
401         premiumPacks.length += 1;
402         premiumPacks[premiumPacks.length-1] = amount;
403         balances[msg.sender] = balances[msg.sender].sub(amount); // will throw and revert the whole thing if doesn't have this amount
404     }
405 
406     function updatePremiums(address account) private {
407         if (premiumPacks.length > premiumPacksPaid[account]) {
408             uint startPackIndex = premiumPacksPaid[account];
409             uint finishPackIndex = premiumPacks.length - 1;
410             for(uint i = startPackIndex; i <= finishPackIndex; i++) {
411                 if (current_supply != 0) { // just in case
412                     uint owing = balances[account] * premiumPacks[i] / current_supply;
413                     balances[account] = balances[account].add(owing);
414                 }
415             }
416             premiumPacksPaid[account] = premiumPacks.length;
417         }
418     }
419 
420     // ***************************************************************************
421 
422     // Overriding payment functions to take control over the logic
423 
424     modifier allowedPayments(address payer, uint value) {
425         // Don't allow to transfer coins until the ICO ends
426         if (isICOOpened) throw;
427         if (!isICOClosed) throw;
428 
429         // Limit the quick dump possibility
430         uint diff = 0;
431         uint allowed = 0;
432         if (balances[payer] > current_supply / 100) { // for balances > 1% of total supply
433             if (block.timestamp > ICO_START_TIME) {
434                 diff = block.timestamp - ICO_START_TIME;
435             } else {
436                 diff = ICO_START_TIME - block.timestamp;
437             }
438 
439             allowed = (current_supply / 20) * (diff / (60 * 60 * 24 * 30)); // 5% unlocked every month
440 
441             if (value > allowed) throw;
442         }
443 
444         _;
445     }
446 
447     function transferFrom(address _from, address _to, uint _value) allowedPayments(_from, _value) {
448         updatePremiums(_from);
449         updatePremiums(_to);
450         super.transferFrom(_from, _to, _value);
451     }
452     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) allowedPayments(msg.sender, _value) {
453         updatePremiums(msg.sender);
454         updatePremiums(_to);
455         super.transfer(_to, _value);
456     }
457 
458 }