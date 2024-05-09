1 pragma solidity ^0.4.11;
2 
3 /*
4 * 'LOOK' token sale contract
5 *
6 * Refer to https://lookscoin.com/ for further information.
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
43         return a + b;
44     }
45 
46     /**
47      * Subtract one uint256 value from another, throw in case of underflow.
48      *
49      * @param a value to subtract from
50      * @param b value to subtract
51      * @return a - b
52      */
53     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
54         assert(a >= b);
55         return a - b;
56     }
57 
58     /**
59      * Multiply two uint256 values, throw in case of overflow.
60      *
61      * @param a first value to multiply
62      * @param b second value to multiply
63      * @return a * b
64      */
65     function safeMul(uint256 a, uint256 b) internal returns (uint256) {
66         if (a == 0 || b == 0) return 0;
67         require (a <= MAX_UINT256 / b);
68         return a * b;
69     }
70 }
71 
72 /*
73     Provides support and utilities for contract ownership
74 */
75 contract Ownable {
76     address owner;
77     address newOwner;
78 
79     function Ownable() {
80         owner = msg.sender;
81     }
82 
83     /**
84      * Allows execution by the owner only.
85      */
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     /**
92      * Transferring the contract ownership to the new owner.
93      *
94      * @param _newOwner new contractor owner
95      */
96     function transferOwnership(address _newOwner) onlyOwner {
97         if (_newOwner != address(0)) {
98           newOwner = _newOwner;
99         }
100     }
101 
102     /**
103      * Accept the contract ownership by the new owner.
104      *
105      */
106     function acceptOwnership() {
107         require(msg.sender == newOwner);
108         OwnershipTransferred(owner, newOwner);
109         owner = newOwner;
110         newOwner = 0x0;
111     }
112     event OwnershipTransferred(address indexed _from, address indexed _to);
113 }
114 
115 /**
116 * Standard Token Smart Contract that could be used as a base contract for
117 * ERC-20 token contracts.
118 */
119 contract StandardToken is ERC20, Ownable, SafeMath {
120 
121     /**
122      * Mapping from addresses of token holders to the numbers of tokens belonging
123      * to these token holders.
124      */
125     mapping (address => uint256) balances;
126 
127     /**
128      * Mapping from addresses of token holders to the mapping of addresses of
129      * spenders to the allowances set by these token holders to these spenders.
130      */
131     mapping (address => mapping (address => uint256)) allowed;
132 
133     /**
134      * Create new Standard Token contract.
135      */
136     function StandardToken() {
137       // Do nothing
138     }
139 
140     /**
141      * Get number of tokens currently belonging to given owner.
142      *
143      * @param _owner address to get number of tokens currently belonging to the
144      *        owner of
145      * @return number of tokens currently belonging to the owner of given address
146      */
147     function balanceOf(address _owner) constant returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151     /**
152      * Transfer given number of tokens from message sender to given recipient.
153      *
154      * @param _to address to transfer tokens to the owner of
155      * @param _amount number of tokens to transfer to the owner of given address
156      * @return true if tokens were transferred successfully, false otherwise
157      */
158     function transfer(address _to, uint256 _amount) returns (bool success) {
159         // avoid wasting gas on 0 token transfers
160         if(_amount <= 0) return false;
161         if (msg.sender == _to) return false;
162         if (balances[msg.sender] < _amount) return false;
163         if (balances[_to] + _amount > balances[_to]) {
164             balances[msg.sender] = safeSub(balances[msg.sender],_amount);
165             balances[_to] = safeAdd(balances[_to],_amount);
166             Transfer(msg.sender, _to, _amount);
167             return true;
168         }
169         return false;
170     }
171 
172     /**
173      * Transfer given number of tokens from given owner to given recipient.
174      *
175      * @param _from address to transfer tokens from the owner of
176      * @param _to address to transfer tokens to the owner of
177      * @param _amount number of tokens to transfer from given owner to given
178      *        recipient
179      * @return true if tokens were transferred successfully, false otherwise
180      */
181     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
182         // avoid wasting gas on 0 token transfers
183         if(_amount <= 0) return false;
184         if(_from == _to) return false;
185         if (balances[_from] < _amount) return false;
186         if (_amount > allowed[_from][msg.sender]) return false;
187 
188         balances[_from] = safeSub(balances[_from],_amount);
189         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
190         balances[_to] = safeAdd(balances[_to],_amount);
191         Transfer(_from, _to, _amount);
192 
193         return false;
194     }
195 
196     /**
197      * Allow given spender to transfer given number of tokens from message sender.
198      *
199      * @param _spender address to allow the owner of to transfer tokens from
200      *        message sender
201      * @param _amount number of tokens to allow to transfer
202      * @return true if token transfer was successfully approved, false otherwise
203      */
204     function approve(address _spender, uint256 _amount) returns (bool success) {
205 
206         // To change the approve amount you first have to reduce the addresses`
207         //  allowance to zero by calling `approve(_spender, 0)` if it is not
208         //  already 0 to mitigate the race condition described here:
209         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210         if ((_amount != 0) && (allowed[msg.sender][_spender] != 0)) {
211            return false;
212         }
213         if (balances[msg.sender] < _amount) {
214             return false;
215         }
216         allowed[msg.sender][_spender] = _amount;
217         Approval(msg.sender, _spender, _amount);
218         return true;
219      }
220 
221     /**
222      * Tell how many tokens given spender is currently allowed to transfer from
223      * given owner.
224      *
225      * @param _owner address to get number of tokens allowed to be transferred
226      *        from the owner of
227      * @param _spender address to get number of tokens allowed to be transferred
228      *        by the owner of
229      * @return number of tokens given spender is currently allowed to transfer
230      *         from given owner
231      */
232      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
233        return allowed[_owner][_spender];
234      }
235 }
236 
237 /**
238  * LOOK Token Sale Contract
239  *
240  * The token sale controller, allows contributing ether in exchange for LOOK coins.
241  * The price (exchange rate with ETH) remains fixed for the entire duration of the token sale.
242  * VIP ranking is recorded at the time when the token holding address first meet VIP holding level.
243  * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets VIP holding level.
244  * VIP ranking is used to calculate priority when competing with other bids for the
245  * same product or service on the platform. 
246  * Higher VIP ranking (with earlier timestamp) has higher priority.
247  * Higher VIP ranking address can outbid other lower ranking addresses once per selling window or promotion period.
248  * Usage of the LOOK token, VIP ranking and bid priority will be described on token website.
249  *
250  */
251 contract LooksCoin is StandardToken {
252 
253     /**
254      * Address of the owner of this smart contract.
255      */
256     address wallet = 0x0;
257 
258     /**
259     * Mapping for VIP rank for qualified token holders
260     * Higher VIP ranking (with earlier timestamp) has higher bidding priority when competing 
261     * for the same item on platform. 
262     * Higher VIP ranking address can outbid other lower ranking addresses once per selling window or promotion period.
263     * Usage of the VIP ranking and bid priority will be described on token website.
264     */
265     mapping (address => uint256) viprank;
266 
267     /**
268      * Minimium contribution to record a VIP block
269      * Token holding address needs at least 10 ETH worth of LOOK tokens to be ranked as VIP
270     */
271     uint256 public VIP_MINIMUM = 1000000;
272 
273     /**
274      * Initial number of tokens.
275      */
276     uint256 constant INITIAL_TOKENS_COUNT = 20000000000;
277 
278     /**
279      * Total number of tokens ins circulation.
280      */
281     uint256 tokensCount;
282 
283     // initial price in wei (numerator)
284     uint256 public constant TOKEN_PRICE_N = 1e13;
285     // initial price in wei (denominator)
286     uint256 public constant TOKEN_PRICE_D = 1;
287     // 1 ETH = 100000 LOOK tokens
288     // 200000 ETH = 20000000000 LOOK tokens
289 
290     /**
291      * Create new LOOK token Smart Contract, make message sender to be the
292      * owner of smart contract, issue given number of tokens and give them to
293      * message sender.
294      */
295     function LooksCoin() payable {
296         owner = msg.sender;
297         wallet = msg.sender;
298         tokensCount = INITIAL_TOKENS_COUNT;
299         balances[owner] = tokensCount;
300     }
301 
302     /**
303      * Get name of this token.
304      *
305      * @return name of this token
306      */
307     function name() constant returns (string name) {
308       return "LOOK";
309     }
310 
311     /**
312      * Get symbol of this token.
313      *
314      * @return symbol of this token
315      */
316     function symbol() constant returns (string symbol) {
317       return "LOOK";
318     }
319 
320     /**
321      * Get number of decimals for this token.
322      *
323      * @return number of decimals for this token
324      */
325     function decimals () constant returns (uint8 decimals) {
326       return 6;
327     }
328 
329     /**
330      * Get total number of tokens in circulation.
331      *
332      * @return total number of tokens in circulation
333      */
334     function totalSupply() constant returns (uint256 supply) {
335       return tokensCount;
336     }
337 
338     /**
339      * Set new wallet address for the smart contract.
340      * May only be called by smart contract owner.
341      *
342      * @param _wallet new wallet address of the smart contract
343      */
344     function setWallet(address _wallet) onlyOwner {
345         wallet = _wallet;
346         WalletUpdated(wallet);
347     }
348     event WalletUpdated(address newWallet);
349 
350     /**
351      * Get VIP rank of a given owner.
352      * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets VIP holding level.
353      *
354      * @param participant address to get the vip rank
355      * @return vip rank of the owner of given address
356      */
357     function getVIPRank(address participant) constant returns (uint256 rank) {
358         if (balances[participant] < VIP_MINIMUM) {
359             return 0;
360         }
361         return viprank[participant];
362     }
363 
364     // fallback
365     function() payable {
366         buyToken();
367     }
368 
369     /**
370      * Accept ethers and other currencies to buy tokens during the token sale
371      */
372     function buyToken() public payable returns (uint256 amount)
373     {
374         // Calculate number of tokens for contributed ETH
375         uint256 tokens = safeMul(msg.value, TOKEN_PRICE_D) / TOKEN_PRICE_N;
376 
377         // Add tokens purchased to account's balance and total supply
378         balances[msg.sender] = safeAdd(balances[msg.sender],tokens);
379         tokensCount = safeAdd(tokensCount,tokens);
380 
381         // Log the tokens purchased 
382         Transfer(0x0, msg.sender, tokens);
383         // - buyer = participant
384         // - ethers = msg.value
385         // - participantTokenBalance = balances[participant]
386         // - tokens = tokens
387         // - totalTokensCount = tokensCount
388         TokensBought(msg.sender, msg.value, balances[msg.sender], tokens, tokensCount);
389 
390         // Contribution timestamp is recorded for VIP rank
391         // Recorded timestamp for VIP ranking should always be earlier than the current time
392         if (balances[msg.sender] >= VIP_MINIMUM && viprank[msg.sender] == 0) {
393             viprank[msg.sender] = now;
394         }
395 
396         // Transfer the contributed ethers to the crowdsale wallet
397         assert(wallet.send(msg.value));
398         return tokens;
399     }
400 
401     event TokensBought(address indexed buyer, uint256 ethers, 
402         uint256 participantTokenBalance, uint256 tokens, uint256 totalTokensCount);
403 
404     /**
405      * Transfer given number of tokens from message sender to given recipient.
406      *
407      * @param _to address to transfer tokens to the owner of
408      * @param _amount number of tokens to transfer to the owner of given address
409      * @return true if tokens were transferred successfully, false otherwise
410      */
411     function transfer(address _to, uint256 _amount) returns (bool success) {
412         return StandardToken.transfer(_to, _amount);
413     }
414 
415     /**
416      * Transfer given number of tokens from given owner to given recipient.
417      *
418      * @param _from address to transfer tokens from the owner of
419      * @param _to address to transfer tokens to the owner of
420      * @param _amount number of tokens to transfer from given owner to given
421      *        recipient
422      * @return true if tokens were transferred successfully, false otherwise
423      */
424     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success)
425     {
426         return StandardToken.transferFrom(_from, _to, _amount);
427     }
428 
429     /**
430      * Burn given number of tokens belonging to message sender.
431      *
432      * @param _amount number of tokens to burn
433      * @return true on success, false on error
434      */
435     function burnTokens(uint256 _amount) returns (bool success) {
436         if (_amount <= 0) return false;
437         if (_amount > tokensCount) return false;
438         if (_amount > balances[msg.sender]) return false;
439         balances[msg.sender] = safeSub(balances[msg.sender],_amount);
440         tokensCount = safeSub(tokensCount,_amount);
441         Transfer(msg.sender, 0x0, _amount);
442         return true;
443     }
444 }