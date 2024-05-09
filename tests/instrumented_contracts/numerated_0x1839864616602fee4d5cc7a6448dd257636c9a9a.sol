1 pragma solidity ^0.4.11;
2 
3 /**
4  * Provides methods to safely add, subtract and multiply uint256 numbers.
5  */
6 contract SafeMath {
7   uint256 constant private MAX_UINT256 =
8     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
9 
10   /**
11    * Add two uint256 values, revert in case of overflow.
12    *
13    * @param x first value to add
14    * @param y second value to add
15    * @return x + y
16    */
17   function safeAdd (uint256 x, uint256 y) 
18  internal pure returns (uint256 z) {
19     require (x <= MAX_UINT256 - y);
20     return x + y;
21   }
22 
23   /**
24    * Subtract one uint256 value from another, throw in case of underflow.
25    *
26    * @param x value to subtract from
27    * @param y value to subtract
28    * @return x - y
29    */
30   function safeSub (uint256 x, uint256 y)
31    internal pure
32   returns (uint256 z) {
33     require(x >= y);
34     return x - y;
35   }
36 
37   /**
38    * Multiply two uint256 values, throw in case of overflow.
39    *
40    * @param x first value to multiply
41    * @param y second value to multiply
42    * @return x * y
43    */
44   function safeMul (uint256 x, uint256 y)
45 internal pure returns (uint256 z) {
46     if (y == 0) return 0; // Prevent division by zero at the next line
47     require (x <= MAX_UINT256 / y);
48     return x * y;
49   }
50 }
51 
52 /**
53  * ERC-20 standard token interface, as defined
54  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
55  */
56 contract Token {
57   /**
58    * Get total number of tokens in circulation.
59    *
60    * @return total number of tokens in circulation
61    */
62   function totalSupply() public constant returns (uint256 supply);
63 
64   /**
65    * Get number of tokens currently belonging to given owner.
66    *
67    * @param _owner address to get number of tokens currently belonging to the
68    *        owner of
69    * @return number of tokens currently belonging to the owner of given address
70    */
71   function balanceOf (address _owner) public constant returns (uint256 balance);
72 
73   /**
74    * Transfer given number of tokens from message sender to given recipient.
75    *
76    * @param _to address to transfer tokens to the owner of
77    * @param _value number of tokens to transfer to the owner of given address
78    * @return true if tokens were transferred successfully, false otherwise
79    */
80   function transfer (address _to, uint256 _value) public  returns (bool success);
81 
82   /**
83    * Transfer given number of tokens from given owner to given recipient.
84    *
85    * @param _from address to transfer tokens from the owner of
86    * @param _to address to transfer tokens to the owner of
87    * @param _value number of tokens to transfer from given owner to given
88    *        recipient
89    * @return true if tokens were transferred successfully, false otherwise
90    */
91   function transferFrom (address _from, address _to, uint256 _value) public 
92   returns (bool success);
93 
94   /**
95    * Allow given spender to transfer given number of tokens from message sender.
96    *
97    * @param _spender address to allow the owner of to transfer tokens from
98    *        message sender
99    * @param _value number of tokens to allow to transfer
100    * @return true if token transfer was successfully approved, false otherwise
101    */
102   function approve (address _spender, uint256 _value) public  returns (bool success);
103 
104   /**
105    * Tell how many tokens given spender is currently allowed to transfer from
106    * given owner.
107    *
108    * @param _owner address to get number of tokens allowed to be transferred
109    *        from the owner of
110    * @param _spender address to get number of tokens allowed to be transferred
111    *        by the owner of
112    * @return number of tokens given spender is currently allowed to transfer
113    *         from given owner
114    */
115   function allowance (address _owner, address _spender) public constant
116   returns (uint256 remaining);
117 
118   /**
119    * Logged when tokens were transferred from one owner to another.
120    *
121    * @param _from address of the owner, tokens were transferred from
122    * @param _to address of the owner, tokens were transferred to
123    * @param _value number of tokens transferred
124    */
125   event Transfer (address indexed _from, address indexed _to, uint256 _value);
126 
127   /**
128    * Logged when owner approved his tokens to be transferred by some spender.
129    *
130    * @param _owner owner who approved his tokens to be transferred
131    * @param _spender spender who were allowed to transfer the tokens belonging
132    *        to the owner
133    * @param _value number of tokens belonging to the owner, approved to be
134    *        transferred by the spender
135    */
136   event Approval (
137     address indexed _owner, address indexed _spender, uint256 _value);
138 }
139 
140 /**
141  * Abstract Token Smart Contract that could be used as a base contract for
142  * ERC-20 token contracts.
143  */
144 contract AbstractToken is Token, SafeMath {
145 
146   /**
147    * Address of the fund of this smart contract.
148    */
149   address fund;
150 
151   /**
152    * Create new Abstract Token contract.
153    */
154   function AbstractToken () public  {
155     // Do nothing
156   }
157 
158 
159   /**
160    * Get number of tokens currently belonging to given owner.
161    *
162    * @param _owner address to get number of tokens currently belonging to the
163    *        owner of
164    * @return number of tokens currently belonging to the owner of given address
165    */
166    function balanceOf (address _owner) public constant returns (uint256 balance) {
167     return accounts [_owner];
168   }
169 
170   /**
171    * Transfer given number of tokens from message sender to given recipient.
172    *
173    * @param _to address to transfer tokens to the owner of
174    * @param _value number of tokens to transfer to the owner of given address
175    * @return true if tokens were transferred successfully, false otherwise
176    */
177   function transfer (address _to, uint256 _value) public returns (bool success) {
178     uint256 feeTotal = fee();
179 
180     if (accounts [msg.sender] < _value) return false;
181     if (_value > feeTotal && msg.sender != _to) {
182       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
183       
184       accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));
185 
186       processFee(feeTotal);
187 
188       Transfer (msg.sender, _to, safeSub(_value, feeTotal));
189       
190     }
191     return true;
192   }
193 
194   /**
195    * Transfer given number of tokens from given owner to given recipient.
196    *
197    * @param _from address to transfer tokens from the owner of
198    * @param _to address to transfer tokens to the owner of
199    * @param _value number of tokens to transfer from given owner to given
200    *        recipient
201    * @return true if tokens were transferred successfully, false otherwise
202    */
203   function transferFrom (address _from, address _to, uint256 _value) public
204   returns (bool success) {
205     uint256 feeTotal = fee();
206 
207     if (allowances [_from][msg.sender] < _value) return false;
208     if (accounts [_from] < _value) return false;
209 
210     allowances [_from][msg.sender] =
211       safeSub (allowances [_from][msg.sender], _value);
212 
213     if (_value > feeTotal && _from != _to) {
214       accounts [_from] = safeSub (accounts [_from], _value);
215 
216       
217       accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));
218 
219       processFee(feeTotal);
220 
221       Transfer (_from, _to, safeSub(_value, feeTotal));
222     }
223 
224     return true;
225   }
226 
227   function fee () public  constant returns (uint256);
228 
229   function processFee(uint256 feeTotal) internal returns (bool);
230 
231   /**
232    * Allow given spender to transfer given number of tokens from message sender.
233    *
234    * @param _spender address to allow the owner of to transfer tokens from
235    *        message sender
236    * @param _value number of tokens to allow to transfer
237    * @return true if token transfer was successfully approved, false otherwise
238    */
239   function approve (address _spender, uint256 _value) public  returns (bool success) {
240     allowances [msg.sender][_spender] = _value;
241     Approval (msg.sender, _spender, _value);
242 
243     return true;
244   }
245 
246   /**
247    * Tell how many tokens given spender is currently allowed to transfer from
248    * given owner.
249    *
250    * @param _owner address to get number of tokens allowed to be transferred
251    *        from the owner of
252    * @param _spender address to get number of tokens allowed to be transferred
253    *        by the owner of
254    * @return number of tokens given spender is currently allowed to transfer
255    *         from given owner
256    */
257   function allowance (address _owner, address _spender) public constant
258   returns (uint256 remaining) {
259     return allowances [_owner][_spender];
260   }
261 
262   /**
263    * Mapping from addresses of token holders to the numbers of tokens belonging
264    * to these token holders.
265    */
266   mapping (address => uint256) accounts;
267 
268   /**
269    * Mapping from addresses of token holders to the mapping of addresses of
270    * spenders to the allowances set by these token holders to these spenders.
271    */
272   mapping (address => mapping (address => uint256)) allowances;
273 }
274 
275 contract TradeBTC is AbstractToken {
276   /**
277    * Initial number of tokens.
278    */
279   uint256 constant INITIAL_TOKENS_COUNT = 210000000e6;
280 
281   /**
282    * Address of the owner of this smart contract.
283    */
284   address owner;
285 
286  
287 
288   /**
289    * Total number of tokens ins circulation.
290    */
291   uint256 tokensCount;
292 
293   /**
294    * Create new TradeBTC Token Smart Contract, make message sender to be the
295    * owner of smart contract, issue given number of tokens and give them to
296    * message sender.
297    */
298   function TradeBTC (address fundAddress) public  {
299     tokensCount = INITIAL_TOKENS_COUNT;
300     accounts [msg.sender] = INITIAL_TOKENS_COUNT;
301     owner = msg.sender;
302     fund = fundAddress;
303   }
304 
305   /**
306    * Get name of this token.
307    *
308    * @return name of this token
309    */
310   function name () public pure returns (string) {
311     return "TradeBTC";
312   }
313 
314   /**
315    * Get symbol of this token.
316    *
317    * @return symbol of this token
318    */
319   function symbol ()  public pure returns (string) {
320     return "tBTC";
321   }
322 
323 
324   /**
325    * Get number of decimals for this token.
326    *
327    * @return number of decimals for this token
328    */
329   function decimals () public pure returns (uint8) {
330     return 6;
331   }
332 
333   /**
334    * Get total number of tokens in circulation.
335    *
336    * @return total number of tokens in circulation
337    */
338   function totalSupply () public constant returns (uint256 supply) {
339     return tokensCount;
340   }
341 
342   
343 
344   /**
345    * Transfer given number of tokens from message sender to given recipient.
346    *
347    * @param _to address to transfer tokens to the owner of
348    * @param _value number of tokens to transfer to the owner of given address
349    * @return true if tokens were transferred successfully, false otherwise
350    */
351   function transfer (address _to, uint256 _value) public returns (bool success) {
352     return AbstractToken.transfer (_to, _value);
353   }
354 
355   /**
356    * Transfer given number of tokens from given owner to given recipient.
357    *
358    * @param _from address to transfer tokens from the owner of
359    * @param _to address to transfer tokens to the owner of
360    * @param _value number of tokens to transfer from given owner to given
361    *        recipient
362    * @return true if tokens were transferred successfully, false otherwise
363    */
364   function transferFrom (address _from, address _to, uint256 _value) public
365   returns (bool success) {
366     return AbstractToken.transferFrom (_from, _to, _value);
367   }
368 
369   function fee ()public constant returns (uint256)  {
370     return safeAdd(safeMul(tokensCount, 5)/1e11, 25000);
371   }
372 
373   function processFee(uint256 feeTotal) internal returns (bool) {
374       uint256 burnFee = feeTotal/2;
375       uint256 fundFee = safeSub(feeTotal, burnFee);
376 
377       accounts [fund] = safeAdd (accounts [fund], fundFee);
378       tokensCount = safeSub (tokensCount, burnFee); // ledger burned toke
379 
380       Transfer (msg.sender, fund, fundFee);
381 
382       return true;
383   }
384 
385   /**
386    * Change how many tokens given spender is allowed to transfer from message
387    * spender.  In order to prevent double spending of allowance, this method
388    * receives assumed current allowance value as an argument.  If actual
389    * allowance differs from an assumed one, this method just returns false.
390    *
391    * @param _spender address to allow the owner of to transfer tokens from
392    *        message sender
393    * @param _currentValue assumed number of tokens currently allowed to be
394    *        transferred
395    * @param _newValue number of tokens to allow to transfer
396    * @return true if token transfer was successfully approved, false otherwise
397    */
398   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
399   public returns (bool success) {
400     if (allowance (msg.sender, _spender) == _currentValue)
401       return approve (_spender, _newValue);
402     else return false;
403   }
404 
405   /**
406    * Burn given number of tokens belonging to message sender.
407    *
408    * @param _value number of tokens to burn
409    * @return true on success, false on error
410    */
411   function burnTokens (uint256 _value) public returns (bool success) {
412     if (_value > accounts [msg.sender]) return false;
413     else if (_value > 0) {
414       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
415       tokensCount = safeSub (tokensCount, _value);
416       return true;
417     } else return true;
418   }
419 
420   /**
421    * Set new owner for the smart contract.
422    * May only be called by smart contract owner.
423    *
424    * @param _newOwner address of new owner of the smart contract
425    */
426   function setOwner (address _newOwner) public {
427     require (msg.sender == owner);
428 
429     owner = _newOwner;
430   }
431 
432   
433   /**
434    * Set new fund address for the smart contract.
435    * May only be called by smart contract owner.
436    *
437    * @param _newFund new fund address of the smart contract
438    */
439   function setFundAddress (address _newFund) public {
440     require (msg.sender == owner);
441 
442     fund = _newFund;
443   }
444 
445 }