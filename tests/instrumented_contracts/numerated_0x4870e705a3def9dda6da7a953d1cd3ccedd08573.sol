1 pragma solidity ^0.4.11;
2 
3 /**
4  * Copyright (c) 2016 Smart Contract Solutions, Inc.
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 /*
56  * Copyright (c) 2016 Smart Contract Solutions, Inc.
57  * ERC20 interface
58  * see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function allowance(address owner, address spender) constant returns (uint);
64 
65   function transfer(address to, uint value) returns (bool ok);
66   function transferFrom(address from, address to, uint value) returns (bool ok);
67   function approve(address spender, uint value) returns (bool ok);
68   event Transfer(address indexed from, address indexed to, uint value);
69   event Approval(address indexed owner, address indexed spender, uint value);
70 }
71 
72 /**
73  * Copyright (c) 2016 Smart Contract Solutions, Inc.
74  * Standard ERC20 token
75  *
76  * https://github.com/ethereum/EIPs/issues/20
77  * Based on code by FirstBlood:
78  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
79  */
80 contract StandardToken is ERC20, SafeMath {
81 
82   mapping (address => uint) balances;
83   mapping (address => mapping (address => uint)) allowed;
84 
85   function transfer(address _to, uint _value) returns (bool success) {
86     balances[msg.sender] = safeSub(balances[msg.sender], _value);
87     balances[_to] = safeAdd(balances[_to], _value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
93     var _allowance = allowed[_from][msg.sender];
94 
95     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
96     // if (_value > _allowance) throw;
97 
98     balances[_to] = safeAdd(balances[_to], _value);
99     balances[_from] = safeSub(balances[_from], _value);
100     allowed[_from][msg.sender] = safeSub(_allowance, _value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function balanceOf(address _owner) constant returns (uint balance) {
106     return balances[_owner];
107   }
108 
109   function approve(address _spender, uint _value) returns (bool success) {
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   function allowance(address _owner, address _spender) constant returns (uint remaining) {
116     return allowed[_owner][_spender];
117   }
118 
119 }
120 
121 /*
122  * Copyright (c) 2016 Smart Contract Solutions, Inc.
123  * Ownable
124  *
125  * Base contract with an owner.
126  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
127  */
128 contract Ownable {
129   address public owner;
130 
131   function Ownable() {
132     owner = msg.sender;
133   }
134 
135   modifier onlyOwner() {
136     if (msg.sender != owner) {
137       throw;
138     }
139     _;
140   }
141 
142   function transferOwnership(address newOwner) onlyOwner {
143     if (newOwner != address(0)) {
144       owner = newOwner;
145     }
146   }
147 
148 }
149 
150 /// @title Moeda Loaylty Points token contract
151 contract MoedaToken is StandardToken, Ownable {
152     string public constant name = "Moeda Loyalty Points";
153     string public constant symbol = "MDA";
154     uint8 public constant decimals = 18;
155 
156     // don't allow creation of more than this number of tokens
157     uint public constant MAX_TOKENS = 20000000 ether;
158     
159     // transfers are locked during the sale
160     bool public saleActive;
161 
162     // only emitted during the crowdsale
163     event Created(address indexed donor, uint256 tokensReceived);
164 
165     // determine whether transfers can be made
166     modifier onlyAfterSale() {
167         if (saleActive) {
168             throw;
169         }
170         _;
171     }
172 
173     modifier onlyDuringSale() {
174         if (!saleActive) {
175             throw;
176         }
177         _;
178     }
179 
180     /// @dev Create moeda token and lock transfers
181     function MoedaToken() {
182         saleActive = true;
183     }
184 
185     /// @dev unlock transfers
186     function unlock() onlyOwner {
187         saleActive = false;
188     }
189 
190     /// @dev create tokens, only usable while saleActive
191     /// @param recipient address that will receive the created tokens
192     /// @param amount the number of tokens to create
193     function create(address recipient, uint256 amount)
194     onlyOwner onlyDuringSale {
195         if (amount == 0) throw;
196         if (safeAdd(totalSupply, amount) > MAX_TOKENS) throw;
197 
198         balances[recipient] = safeAdd(balances[recipient], amount);
199         totalSupply = safeAdd(totalSupply, amount);
200 
201         Created(recipient, amount);
202     }
203 
204     // transfer tokens
205     // only allowed after sale has ended
206     function transfer(address _to, uint _value) onlyAfterSale returns (bool) {
207         return super.transfer(_to, _value);
208     }
209 
210     // transfer tokens
211     // only allowed after sale has ended
212     function transferFrom(address from, address to, uint value) onlyAfterSale 
213     returns (bool)
214     {
215         return super.transferFrom(from, to, value);
216     }
217 }
218 
219 /// @title Moeda crowdsale
220 contract Crowdsale is Ownable, SafeMath {
221     bool public crowdsaleClosed;        // whether the crowdsale has been closed 
222                                         // manually
223     address public wallet;              // recipient of all crowdsale funds
224     MoedaToken public moedaToken;       // token that will be sold during sale
225     uint256 public etherReceived;       // total ether received
226     uint256 public totalTokensSold;     // number of tokens sold
227     uint256 public startBlock;          // block where sale starts
228     uint256 public endBlock;            // block where sale ends
229 
230     // used to scale token amounts to 18 decimals
231     uint256 public constant TOKEN_MULTIPLIER = 10 ** 18;
232 
233     // number of tokens allocated to presale (prior to crowdsale)
234     uint256 public constant PRESALE_TOKEN_ALLOCATION = 5000000 * TOKEN_MULTIPLIER;
235 
236     // recipient of presale tokens
237     address public PRESALE_WALLET = "0x30B3C64d43e7A1E8965D934Fa96a3bFB33Eee0d2";
238     
239     // smallest possible donation
240     uint256 public constant DUST_LIMIT = 1 finney;
241 
242     // token generation rates (tokens per eth)
243     uint256 public constant TIER1_RATE = 160;
244     uint256 public constant TIER2_RATE = 125;
245     uint256 public constant TIER3_RATE = 80;
246 
247     // limits for each pricing tier (how much can be bought)
248     uint256 public constant TIER1_CAP =  31250 ether;
249     uint256 public constant TIER2_CAP =  71250 ether;
250     uint256 public constant TIER3_CAP = 133750 ether; // Total ether cap
251 
252     // Log a purchase
253     event Purchase(address indexed donor, uint256 amount, uint256 tokenAmount);
254 
255     // Log transfer of tokens that were sent to this contract by mistake
256     event TokenDrain(address token, address to, uint256 amount);
257 
258     modifier onlyDuringSale() {
259         if (crowdsaleClosed) {
260             throw;
261         }
262 
263         if (block.number < startBlock) {
264             throw;
265         }
266 
267         if (block.number >= endBlock) {
268             throw;
269         }
270         _;
271     }
272 
273     /// @dev Initialize a new Crowdsale contract
274     /// @param _wallet address of multisig wallet that will store received ether
275     /// @param _startBlock block at which to start the sale
276     /// @param _endBlock block at which to end the sale
277     function Crowdsale(address _wallet, uint _startBlock, uint _endBlock) {
278         if (_wallet == address(0)) throw;
279         if (_startBlock <= block.number) throw;
280         if (_endBlock <= _startBlock) throw;
281         
282         crowdsaleClosed = false;
283         wallet = _wallet;
284         moedaToken = new MoedaToken();
285         startBlock = _startBlock;
286         endBlock = _endBlock;
287     }
288 
289     /// @dev Determine the lowest rate to acquire tokens given an amount of 
290     /// donated ethers
291     /// @param totalReceived amount of ether that has been received
292     /// @return pair of the current tier's donation limit and a token creation rate
293     function getLimitAndPrice(uint256 totalReceived)
294     constant returns (uint256, uint256) {
295         uint256 limit = 0;
296         uint256 price = 0;
297 
298         if (totalReceived < TIER1_CAP) {
299             limit = TIER1_CAP;
300             price = TIER1_RATE;
301         }
302         else if (totalReceived < TIER2_CAP) {
303             limit = TIER2_CAP;
304             price = TIER2_RATE;
305         }
306         else if (totalReceived < TIER3_CAP) {
307             limit = TIER3_CAP;
308             price = TIER3_RATE;
309         } else {
310             throw; // this shouldn't happen
311         }
312 
313         return (limit, price);
314     }
315 
316     /// @dev Determine how many tokens we can get from each pricing tier, in
317     /// case a donation's amount overlaps multiple pricing tiers.
318     ///
319     /// @param totalReceived ether received by contract plus spent by this donation
320     /// @param requestedAmount total ether to spend on tokens in a donation
321     /// @return amount of tokens to get for the requested ether donation
322     function getTokenAmount(uint256 totalReceived, uint256 requestedAmount) 
323     constant returns (uint256) {
324 
325         // base case, we've spent the entire donation and can stop
326         if (requestedAmount == 0) return 0;
327         uint256 limit = 0;
328         uint256 price = 0;
329         
330         // 1. Determine cheapest token price
331         (limit, price) = getLimitAndPrice(totalReceived);
332 
333         // 2. Since there are multiple pricing levels based on how much has been
334         // received so far, we need to determine how much can be spent at
335         // any given tier. This in case a donation will overlap more than one 
336         // tier
337         uint256 maxETHSpendableInTier = safeSub(limit, totalReceived);
338         uint256 amountToSpend = min256(maxETHSpendableInTier, requestedAmount);
339 
340         // 3. Given a price determine how many tokens the unspent ether in this 
341         // donation will get you
342         uint256 tokensToReceiveAtCurrentPrice = safeMul(amountToSpend, price);
343 
344         // You've spent everything you could at this level, continue to the next
345         // one, in case there is some ETH left unspent in this donation.
346         uint256 additionalTokens = getTokenAmount(
347             safeAdd(totalReceived, amountToSpend),
348             safeSub(requestedAmount, amountToSpend));
349 
350         return safeAdd(tokensToReceiveAtCurrentPrice, additionalTokens);
351     }
352 
353     /// grant tokens to buyer when we receive ether
354     /// @dev buy tokens, only usable while crowdsale is active
355     function () payable onlyDuringSale {
356         if (msg.value < DUST_LIMIT) throw;
357         if (safeAdd(etherReceived, msg.value) > TIER3_CAP) throw;
358 
359         uint256 tokenAmount = getTokenAmount(etherReceived, msg.value);
360 
361         moedaToken.create(msg.sender, tokenAmount);
362         etherReceived = safeAdd(etherReceived, msg.value);
363         totalTokensSold = safeAdd(totalTokensSold, tokenAmount);
364         Purchase(msg.sender, msg.value, tokenAmount);
365 
366         if (!wallet.send(msg.value)) throw;
367     }
368 
369     /// @dev close the crowdsale manually and unlock the tokens
370     /// this will only be successful if not already executed,
371     /// if endBlock has been reached, or if the cap has been reached
372     function finalize() onlyOwner {
373         if (block.number < startBlock) throw;
374         if (crowdsaleClosed) throw;
375 
376         // if amount remaining is too small we can allow sale to end earlier
377         uint256 amountRemaining = safeSub(TIER3_CAP, etherReceived);
378         if (block.number < endBlock && amountRemaining >= DUST_LIMIT) throw;
379 
380         // create and assign presale tokens to presale wallet
381         moedaToken.create(PRESALE_WALLET, PRESALE_TOKEN_ALLOCATION);
382 
383         // unlock tokens for spending
384         moedaToken.unlock();
385         crowdsaleClosed = true;
386     }
387 
388     /// @dev Drain tokens that were sent here by mistake
389     /// because people will.
390     /// @param _token address of token to transfer
391     /// @param _to address where tokens will be transferred
392     function drainToken(address _token, address _to) onlyOwner {
393         if (_token == address(0)) throw;
394         if (_to == address(0)) throw;
395         ERC20 token = ERC20(_token);
396         uint256 balance = token.balanceOf(this);
397         token.transfer(_to, balance);
398         TokenDrain(_token, _to, balance);
399     }
400 }