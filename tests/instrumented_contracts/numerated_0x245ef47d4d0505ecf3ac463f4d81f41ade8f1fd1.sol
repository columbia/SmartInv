1 /*
2  * Nuggets Token Smart Contract.
3  */
4 pragma solidity ^0.4.16;
5 
6 /*
7  * Abstract Token Smart Contract.
8  */
9 pragma solidity ^0.4.16;
10 
11 
12 /*
13  * ERC-20 Standard Token Smart Contract Interface.
14  */
15 pragma solidity ^0.4.16;
16 
17 /**
18  * ERC-20 standard token interface, as defined
19  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
20  */
21 contract Token {
22   /**
23    * Get total number of tokens in circulation.
24    *
25    * @return total number of tokens in circulation
26    */
27   function totalSupply () constant returns (uint256 supply);
28 
29   /**
30    * Get number of tokens currently belonging to given owner.
31    *
32    * @param _owner address to get number of tokens currently belonging to the
33    *        owner of
34    * @return number of tokens currently belonging to the owner of given address
35    */
36   function balanceOf (address _owner) constant returns (uint256 balance);
37 
38   /**
39    * Transfer given number of tokens from message sender to given recipient.
40    *
41    * @param _to address to transfer tokens to the owner of
42    * @param _value number of tokens to transfer to the owner of given address
43    * @return true if tokens were transferred successfully, false otherwise
44    */
45   function transfer (address _to, uint256 _value) returns (bool success);
46 
47   /**
48    * Transfer given number of tokens from given owner to given recipient.
49    *
50    * @param _from address to transfer tokens from the owner of
51    * @param _to address to transfer tokens to the owner of
52    * @param _value number of tokens to transfer from given owner to given
53    *        recipient
54    * @return true if tokens were transferred successfully, false otherwise
55    */
56   function transferFrom (address _from, address _to, uint256 _value)
57   returns (bool success);
58 
59   /**
60    * Allow given spender to transfer given number of tokens from message sender.
61    *
62    * @param _spender address to allow the owner of to transfer tokens from
63    *        message sender
64    * @param _value number of tokens to allow to transfer
65    * @return true if token transfer was successfully approved, false otherwise
66    */
67   function approve (address _spender, uint256 _value) returns (bool success);
68 
69   /**
70    * Tell how many tokens given spender is currently allowed to transfer from
71    * given owner.
72    *
73    * @param _owner address to get number of tokens allowed to be transferred
74    *        from the owner of
75    * @param _spender address to get number of tokens allowed to be transferred
76    *        by the owner of
77    * @return number of tokens given spender is currently allowed to transfer
78    *         from given owner
79    */
80   function allowance (address _owner, address _spender) constant
81   returns (uint256 remaining);
82 
83   /**
84    * Logged when tokens were transferred from one owner to another.
85    *
86    * @param _from address of the owner, tokens were transferred from
87    * @param _to address of the owner, tokens were transferred to
88    * @param _value number of tokens transferred
89    */
90   event Transfer (address indexed _from, address indexed _to, uint256 _value);
91 
92   /**
93    * Logged when owner approved his tokens to be transferred by some spender.
94    *
95    * @param _owner owner who approved his tokens to be transferred
96    * @param _spender spender who were allowed to transfer the tokens belonging
97    *        to the owner
98    * @param _value number of tokens belonging to the owner, approved to be
99    *        transferred by the spender
100    */
101   event Approval (
102     address indexed _owner, address indexed _spender, uint256 _value);
103 }
104 
105 /*
106  * Safe Math Smart Contract.
107  */
108 pragma solidity ^0.4.16;
109 
110 /**
111  * Provides methods to safely add, subtract and multiply uint256 numbers.
112  */
113 contract SafeMath {
114   uint256 constant private MAX_UINT256 =
115     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
116 
117   /**
118    * Add two uint256 values, throw in case of overflow.
119    *
120    * @param x first value to add
121    * @param y second value to add
122    * @return x + y
123    */
124   function safeAdd (uint256 x, uint256 y)
125   constant internal
126   returns (uint256 z) {
127     assert (x <= MAX_UINT256 - y);
128     return x + y;
129   }
130 
131   /**
132    * Subtract one uint256 value from another, throw in case of underflow.
133    *
134    * @param x value to subtract from
135    * @param y value to subtract
136    * @return x - y
137    */
138   function safeSub (uint256 x, uint256 y)
139   constant internal
140   returns (uint256 z) {
141     assert (x >= y);
142     return x - y;
143   }
144 
145   /**
146    * Multiply two uint256 values, throw in case of overflow.
147    *
148    * @param x first value to multiply
149    * @param y second value to multiply
150    * @return x * y
151    */
152   function safeMul (uint256 x, uint256 y)
153   constant internal
154   returns (uint256 z) {
155     if (y == 0) return 0; // Prevent division by zero at the next line
156     assert (x <= MAX_UINT256 / y);
157     return x * y;
158   }
159 }
160 
161 
162 /**
163  * Abstract Token Smart Contract that could be used as a base contract for
164  * ERC-20 token contracts.
165  */
166 contract AbstractToken is Token, SafeMath {
167   /**
168    * Create new Abstract Token contract.
169    */
170   function AbstractToken () {
171     // Do nothing
172   }
173 
174   /**
175    * Get number of tokens currently belonging to given owner.
176    *
177    * @param _owner address to get number of tokens currently belonging to the
178    *        owner of
179    * @return number of tokens currently belonging to the owner of given address
180    */
181   function balanceOf (address _owner) constant returns (uint256 balance) {
182     return accounts [_owner];
183   }
184 
185   /**
186    * Transfer given number of tokens from message sender to given recipient.
187    *
188    * @param _to address to transfer tokens to the owner of
189    * @param _value number of tokens to transfer to the owner of given address
190    * @return true if tokens were transferred successfully, false otherwise
191    */
192   function transfer (address _to, uint256 _value) returns (bool success) {
193     uint256 fromBalance = accounts [msg.sender];
194     if (fromBalance < _value) return false;
195     if (_value > 0 && msg.sender != _to) {
196       accounts [msg.sender] = safeSub (fromBalance, _value);
197       accounts [_to] = safeAdd (accounts [_to], _value);
198     }
199     Transfer (msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204    * Transfer given number of tokens from given owner to given recipient.
205    *
206    * @param _from address to transfer tokens from the owner of
207    * @param _to address to transfer tokens to the owner of
208    * @param _value number of tokens to transfer from given owner to given
209    *        recipient
210    * @return true if tokens were transferred successfully, false otherwise
211    */
212   function transferFrom (address _from, address _to, uint256 _value)
213   returns (bool success) {
214     uint256 spenderAllowance = allowances [_from][msg.sender];
215     if (spenderAllowance < _value) return false;
216     uint256 fromBalance = accounts [_from];
217     if (fromBalance < _value) return false;
218 
219     allowances [_from][msg.sender] =
220       safeSub (spenderAllowance, _value);
221 
222     if (_value > 0 && _from != _to) {
223       accounts [_from] = safeSub (fromBalance, _value);
224       accounts [_to] = safeAdd (accounts [_to], _value);
225     }
226     Transfer (_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * Allow given spender to transfer given number of tokens from message sender.
232    *
233    * @param _spender address to allow the owner of to transfer tokens from
234    *        message sender
235    * @param _value number of tokens to allow to transfer
236    * @return true if token transfer was successfully approved, false otherwise
237    */
238   function approve (address _spender, uint256 _value) returns (bool success) {
239     allowances [msg.sender][_spender] = _value;
240     Approval (msg.sender, _spender, _value);
241 
242     return true;
243   }
244 
245   /**
246    * Tell how many tokens given spender is currently allowed to transfer from
247    * given owner.
248    *
249    * @param _owner address to get number of tokens allowed to be transferred
250    *        from the owner of
251    * @param _spender address to get number of tokens allowed to be transferred
252    *        by the owner of
253    * @return number of tokens given spender is currently allowed to transfer
254    *         from given owner
255    */
256   function allowance (address _owner, address _spender) constant
257   returns (uint256 remaining) {
258     return allowances [_owner][_spender];
259   }
260 
261   /**
262    * Mapping from addresses of token holders to the numbers of tokens belonging
263    * to these token holders.
264    */
265   mapping (address => uint256) accounts;
266 
267   /**
268    * Mapping from addresses of token holders to the mapping of addresses of
269    * spenders to the allowances set by these token holders to these spenders.
270    */
271   mapping (address => mapping (address => uint256)) private allowances;
272 }
273 
274 /**
275  * Nuggets Token Smart Contract: EIP-20 compatible token smart contract with
276  * fixed supply, token burning and transfer freezing.
277  */
278 contract NuggetsToken is AbstractToken {
279   /**
280    * Initial supply of Nuggets Tokens.
281    */
282   uint constant INITIAL_SUPPLY = 10000000000e18;
283 
284   /**
285    * Create new Nuggets Token contract.
286    */
287   function NuggetsToken () {
288     owner = msg.sender;
289     accounts [owner] = INITIAL_SUPPLY;
290     tokensCount = INITIAL_SUPPLY;
291   }
292 
293   /**
294    * Get name of this token.
295    *
296    * @return name of this token
297    */
298   function name () constant returns (string result) {
299     return "Nuggets";
300   }
301 
302   /**
303    * Get symbol of this token.
304    *
305    * @return symbol of this token
306    */
307   function symbol () constant returns (string result) {
308     return "NUG";
309   }
310 
311   /**
312    * Get number of decimals for this token.
313    *
314    * @return number of decimals for this token
315    */
316   function decimals () constant returns (uint8 result) {
317     return 18;
318   }
319 
320   /**
321    * Get total number of tokens in circulation.
322    *
323    * @return total number of tokens in circulation
324    */
325   function totalSupply () constant returns (uint256 supply) {
326     return tokensCount;
327   }
328 
329   /**
330    * Transfer given number of tokens from message sender to given recipient.
331    *
332    * @param _to address to transfer tokens to the owner of
333    * @param _value number of tokens to transfer to the owner of given address
334    * @return true if tokens were transferred successfully, false otherwise
335    */
336   function transfer (address _to, uint256 _value) returns (bool success) {
337     return frozen ? false : AbstractToken.transfer (_to, _value);
338   }
339 
340   /**
341    * Transfer given number of tokens from given owner to given recipient.
342    *
343    * @param _from address to transfer tokens from the owner of
344    * @param _to address to transfer tokens to the owner of
345    * @param _value number of tokens to transfer from given owner to given
346    *        recipient
347    * @return true if tokens were transferred successfully, false otherwise
348    */
349   function transferFrom (address _from, address _to, uint256 _value)
350   returns (bool success) {
351     return frozen ? false : AbstractToken.transferFrom (_from, _to, _value);
352   }
353 
354   /**
355    * Change how many tokens given spender is allowed to transfer from message
356    * spender.  In order to prevent double spending of allowance, this method
357    * receives assumed current allowance value as an argument.  If actual
358    * allowance differs from an assumed one, this method just returns false.
359    *
360    * @param _spender address to allow the owner of to transfer tokens from
361    *        message sender
362    * @param _currentValue assumed number of tokens currently allowed to be
363    *        transferred
364    * @param _newValue number of tokens to allow to transfer
365    * @return true if token transfer was successfully approved, false otherwise
366    */
367   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
368   returns (bool success) {
369     if (allowance (msg.sender, _spender) == _currentValue)
370       return approve (_spender, _newValue);
371     else return false;
372   }
373 
374   /**
375    * Burn given number of tokens belonging to message sender.
376    *
377    * @param _value number of tokens to burn
378    * @return true on success, false on error
379    */
380   function burnTokens (uint256 _value) returns (bool success) {
381     uint256 ownerBalance = accounts [msg.sender];
382     if (_value > ownerBalance) return false;
383     else if (_value > 0) {
384       accounts [msg.sender] = safeSub (ownerBalance, _value);
385       tokensCount = safeSub (tokensCount, _value);
386       return true;
387     } else return true;
388   }
389 
390   /**
391    * Set new owner for the smart contract.
392    * May only be called by smart contract owner.
393    *
394    * @param _newOwner address of new owner of the smart contract
395    */
396   function setOwner (address _newOwner) {
397     require (msg.sender == owner);
398 
399     owner = _newOwner;
400   }
401 
402   /**
403    * Freeze token transfers.
404    * May only be called by smart contract owner.
405    */
406   function freezeTransfers () {
407     require (msg.sender == owner);
408 
409     if (!frozen) {
410       frozen = true;
411       Freeze ();
412     }
413   }
414 
415   /**
416    * Unfreeze token transfers.
417    * May only be called by smart contract owner.
418    */
419   function unfreezeTransfers () {
420     require (msg.sender == owner);
421 
422     if (frozen) {
423       frozen = false;
424       Unfreeze ();
425     }
426   }
427 
428   /**
429    * Logged when token transfers were frozen.
430    */
431   event Freeze ();
432 
433   /**
434    * Logged when token transfers were unfrozen.
435    */
436   event Unfreeze ();
437 
438   /**
439    * Number of tokens in circulation.
440    */
441   uint256 tokensCount;
442 
443   /**
444    * Owner of the smart contract.
445    */
446   address owner;
447 
448   /**
449    * Whether token transfers are currently frozen.
450    */
451   bool frozen;
452 }