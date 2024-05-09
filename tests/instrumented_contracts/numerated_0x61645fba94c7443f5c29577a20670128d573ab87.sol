1 pragma solidity ^0.4.11;
2 
3 /*
4 * 'LOOK' token sale contract
5 *
6 * Refer to https://lookscoin.com/ for more information.
7 * 
8 * Developer: LookRev
9 *
10 */
11 
12 /*
13  * ERC20 Token Standard
14  */
15 contract ERC20 {
16     function totalSupply() constant returns (uint256 supply);
17     function balanceOf(address _who) constant returns (uint256 balance);
18 
19     function transfer(address _to, uint256 _value) returns (bool ok);
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool ok);
21     function approve(address _spender, uint256 _value) returns (bool ok);
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27   /**
28    * Provides methods to safely add, subtract and multiply uint256 numbers.
29    */
30 contract SafeMath {
31     uint256 constant private MAX_UINT256 =
32     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
33 
34     /**
35      * Add two uint256 values, revert in case of overflow.
36      *
37      * @param a first value to add
38      * @param b second value to add
39      * @return a + b
40      */
41     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
42         require (a <= MAX_UINT256 - b);
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 
48     /**
49      * Subtract one uint256 value from another, throw in case of underflow.
50      *
51      * @param a value to subtract from
52      * @param b value to subtract
53      * @return a - b
54      */
55     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
56         assert(a >= b);
57         return a - b;
58     }
59 
60     /**
61      * Multiply two uint256 values, throw in case of overflow.
62      *
63      * @param a first value to multiply
64      * @param b second value to multiply
65      * @return a * b
66      */
67     function safeMul(uint256 a, uint256 b) internal returns (uint256) {
68         if (a == 0 || b == 0) return 0;
69         require (a <= MAX_UINT256 / b);
70         return a * b;
71     }
72 }
73 
74 /*
75     Provides support and utilities for contract ownership
76 */
77 contract Ownable {
78     address owner;
79     address newOwner;
80 
81     function Ownable() {
82         owner = msg.sender;
83     }
84 
85     /**
86      * Allows execution by the owner only.
87      */
88     modifier onlyOwner {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     /**
94      * Transferring the contract ownership to the new owner.
95      *
96      * @param _newOwner new contractor owner
97      */
98     function transferOwnership(address _newOwner) onlyOwner {
99         if (_newOwner != address(0)) {
100           newOwner = _newOwner;
101         }
102     }
103 
104     /**
105      * Accept the contract ownership by the new owner.
106      *
107      */
108     function acceptOwnership() {
109         require(msg.sender == newOwner);
110         OwnershipTransferred(owner, newOwner);
111         owner = newOwner;
112         newOwner = 0x0;
113     }
114     event OwnershipTransferred(address indexed _from, address indexed _to);
115 }
116 
117 /**
118 * Standard Token Smart Contract that could be used as a base contract for
119 * ERC-20 token contracts.
120 */
121 contract StandardToken is ERC20, Ownable, SafeMath {
122 
123     /**
124      * Mapping from addresses of token holders to the numbers of tokens belonging
125      * to these token holders.
126      */
127     mapping (address => uint256) balances;
128 
129     /**
130      * Mapping from addresses of token holders to the mapping of addresses of
131      * spenders to the allowances set by these token holders to these spenders.
132      */
133     mapping (address => mapping (address => uint256)) allowed;
134 
135     /**
136      * Create new Standard Token contract.
137      */
138     function StandardToken() {
139       // Do nothing
140     }
141 
142     /**
143      * Get number of tokens currently belonging to given owner.
144      *
145      * @param _owner address to get number of tokens currently belonging to the
146      *        owner of
147      * @return number of tokens currently belonging to the owner of given address
148      */
149     function balanceOf(address _owner) constant returns (uint256 balance) {
150         return balances[_owner];
151     }
152 
153     /**
154      * Transfer given number of tokens from message sender to given recipient.
155      *
156      * @param _to address to transfer tokens to the owner of
157      * @param _amount number of tokens to transfer to the owner of given address
158      * @return true if tokens were transferred successfully, false otherwise
159      */
160     function transfer(address _to, uint256 _amount) returns (bool success) {
161         // avoid wasting gas on 0 token transfers
162         if(_amount <= 0) return false;
163         if (msg.sender == _to) return false;
164         if (balances[msg.sender] < _amount) return false;
165         if (balances[_to] + _amount > balances[_to]) {
166             balances[msg.sender] = safeSub(balances[msg.sender],_amount);
167             balances[_to] = safeAdd(balances[_to],_amount);
168             Transfer(msg.sender, _to, _amount);
169             return true;
170         }
171         return false;
172     }
173 
174     /**
175      * Transfer given number of tokens from given owner to given recipient.
176      *
177      * @param _from address to transfer tokens from the owner of
178      * @param _to address to transfer tokens to the owner of
179      * @param _amount number of tokens to transfer from given owner to given
180      *        recipient
181      * @return true if tokens were transferred successfully, false otherwise
182      */
183     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
184         // avoid wasting gas on 0 token transfers
185         if(_amount <= 0) return false;
186         if(_from == _to) return false;
187         if (balances[_from] < _amount) return false;
188         if (_amount > allowed[_from][msg.sender]) return false;
189 
190         balances[_from] = safeSub(balances[_from],_amount);
191         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
192         balances[_to] = safeAdd(balances[_to],_amount);
193         Transfer(_from, _to, _amount);
194 
195         return false;
196     }
197 
198     /**
199      * Allow given spender to transfer given number of tokens from message sender.
200      *
201      * @param _spender address to allow the owner of to transfer tokens from
202      *        message sender
203      * @param _amount number of tokens to allow to transfer
204      * @return true if token transfer was successfully approved, false otherwise
205      */
206     function approve(address _spender, uint256 _amount) returns (bool success) {
207 
208         // To change the approve amount you first have to reduce the addresses`
209         //  allowance to zero by calling `approve(_spender, 0)` if it is not
210         //  already 0 to mitigate the race condition described here:
211         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212         if ((_amount != 0) && (allowed[msg.sender][_spender] != 0)) {
213            return false;
214         }
215         if (balances[msg.sender] < _amount) {
216             return false;
217         }
218         allowed[msg.sender][_spender] = _amount;
219         Approval(msg.sender, _spender, _amount);
220         return true;
221      }
222 
223     /**
224      * Tell how many tokens given spender is currently allowed to transfer from
225      * given owner.
226      *
227      * @param _owner address to get number of tokens allowed to be transferred
228      *        from the owner of
229      * @param _spender address to get number of tokens allowed to be transferred
230      *        by the owner of
231      * @return number of tokens given spender is currently allowed to transfer
232      *         from given owner
233      */
234      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
235        return allowed[_owner][_spender];
236      }
237 }
238 
239 /**
240  * LOOK Token Sale Contract
241  *
242  * The token sale controller, allows contributing ether in exchange for LOOK coins.
243  * The price (exchange rate with ETH) remains fixed for the entire duration of the token sale.
244  * VIP ranking is recorded at the time when the token holding address first meet VIP holding level.
245  * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets VIP holding level.
246  * VIP ranking is used to calculate priority when competing with other bids for the
247  * same product or service on the platform. 
248  * Higher VIP ranking (with earlier timestamp) has higher priority.
249  * Higher VIP ranking address can outbid other lower ranking addresses once per selling window or promotion period.
250  * Usage of the LOOK token, VIP ranking and bid priority will be described on token website.
251  *
252  */
253 contract LooksCoin is StandardToken {
254 
255     /**
256      * Address of the owner of this smart contract.
257      */
258     address wallet = 0x0;
259 
260     /**
261     * Mapping for VIP rank for qualified token holders
262     * Higher VIP ranking (with earlier timestamp) has higher bidding priority when competing 
263     * for the same item on platform. 
264     * Higher VIP ranking address can outbid other lower ranking addresses once per selling window or promotion period.
265     * Usage of the VIP ranking and bid priority will be described on token website.
266     */
267     mapping (address => uint256) viprank;
268 
269     /**
270      * Minimium contribution to record a VIP block
271      * Token holding address needs at least 10 ETH worth of LOOK tokens to be ranked as VIP
272     */
273     uint256 public VIP_MINIMUM = 1000000;
274 
275     /**
276      * Initial number of tokens.
277      */
278     uint256 constant INITIAL_TOKENS_COUNT = 20000000000;
279 
280     /**
281      * Total number of tokens ins circulation.
282      */
283     uint256 tokensCount;
284 
285     // initial price in wei (numerator)
286     uint256 public constant TOKEN_PRICE_N = 1e13;
287     // initial price in wei (denominator)
288     uint256 public constant TOKEN_PRICE_D = 1;
289     // 1 ETH = 100000 LOOK coins
290 
291     /**
292      * Create new LOOK token Smart Contract, make message sender to be the
293      * owner of smart contract, issue given number of tokens and give them to
294      * message sender.
295      */
296     function LooksCoin() payable {
297         owner = msg.sender;
298         wallet = msg.sender;
299         tokensCount = INITIAL_TOKENS_COUNT;
300         balances[owner] = tokensCount;
301     }
302 
303     /**
304      * Get name of this token.
305      *
306      * @return name of this token
307      */
308     function name() constant returns (string name) {
309       return "LOOK";
310     }
311 
312     /**
313      * Get symbol of this token.
314      *
315      * @return symbol of this token
316      */
317     function symbol() constant returns (string symbol) {
318       return "LOOK";
319     }
320 
321     /**
322      * Get number of decimals for this token.
323      *
324      * @return number of decimals for this token
325      */
326     function decimals() constant returns (uint8 decimals) {
327       return 0;
328     }
329 
330     /**
331      * Get total number of tokens in circulation.
332      *
333      * @return total number of tokens in circulation
334      */
335     function totalSupply() constant returns (uint256 supply) {
336       return tokensCount;
337     }
338 
339     /**
340      * Set new wallet address for the smart contract.
341      * May only be called by smart contract owner.
342      *
343      * @param _wallet new wallet address of the smart contract
344      */
345     function setWallet(address _wallet) onlyOwner {
346         wallet = _wallet;
347         WalletUpdated(wallet);
348     }
349     event WalletUpdated(address newWallet);
350 
351     /**
352      * Get VIP rank of a given owner.
353      * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets VIP holding level.
354      *
355      * @param participant address to get the vip rank
356      * @return vip rank of the owner of given address
357      */
358     function getVIPRank(address participant) constant returns (uint256 rank) {
359         if (balances[participant] < VIP_MINIMUM) {
360             return 0;
361         }
362         return viprank[participant];
363     }
364 
365     // fallback
366     function() payable {
367         buyToken();
368     }
369 
370     /**
371      * Accept ethers and other currencies to buy tokens during the token sale
372      */
373     function buyToken() public payable returns (uint256 amount)
374     {
375         // Calculate number of tokens for contributed ETH
376         uint256 tokens = safeMul(msg.value, TOKEN_PRICE_D) / TOKEN_PRICE_N;
377 
378         // Add tokens purchased to account's balance and total supply
379         balances[msg.sender] = safeAdd(balances[msg.sender],tokens);
380         tokensCount = safeAdd(tokensCount,tokens);
381 
382         // Log the tokens purchased 
383         Transfer(0x0, msg.sender, tokens);
384         // - buyer = participant
385         // - ethers = msg.value
386         // - participantTokenBalance = balances[participant]
387         // - tokens = tokens
388         // - totalTokensCount = tokensCount
389         TokensBought(msg.sender, msg.value, balances[msg.sender], tokens, tokensCount);
390 
391         // Contribution timestamp is recorded for VIP rank
392         // Recorded timestamp for VIP ranking should always be earlier than the current time
393         if (balances[msg.sender] >= VIP_MINIMUM && viprank[msg.sender] == 0) {
394             viprank[msg.sender] = now;
395         }
396 
397         // Transfer the contributed ethers to the crowdsale wallet
398         assert(wallet.send(msg.value));
399         return tokens;
400     }
401 
402     event TokensBought(address indexed buyer, uint256 ethers, 
403         uint256 participantTokenBalance, uint256 tokens, uint256 totalTokensCount);
404 
405     /**
406      * Transfer given number of tokens from message sender to given recipient.
407      *
408      * @param _to address to transfer tokens to the owner of
409      * @param _amount number of tokens to transfer to the owner of given address
410      * @return true if tokens were transferred successfully, false otherwise
411      */
412     function transfer(address _to, uint256 _amount) returns (bool success) {
413         return StandardToken.transfer(_to, _amount);
414     }
415 
416     /**
417      * Transfer given number of tokens from given owner to given recipient.
418      *
419      * @param _from address to transfer tokens from the owner of
420      * @param _to address to transfer tokens to the owner of
421      * @param _amount number of tokens to transfer from given owner to given
422      *        recipient
423      * @return true if tokens were transferred successfully, false otherwise
424      */
425     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success)
426     {
427         return StandardToken.transferFrom(_from, _to, _amount);
428     }
429 
430     /**
431      * Burn given number of tokens belonging to message sender.
432      *
433      * @param _amount number of tokens to burn
434      * @return true on success, false on error
435      */
436     function burnTokens(uint256 _amount) returns (bool success) {
437         if (_amount <= 0) return false;
438         if (_amount > tokensCount) return false;
439         if (_amount > balances[msg.sender]) return false;
440         balances[msg.sender] = safeSub(balances[msg.sender],_amount);
441         tokensCount = safeSub(tokensCount,_amount);
442         Transfer(msg.sender, 0x0, _amount);
443         return true;
444     }
445 }