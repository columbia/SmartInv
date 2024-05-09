1 pragma solidity ^0.4.20;
2 
3 /*
4  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
5  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
6  */
7 
8 /*
9  * EIP-20 Standard Token Smart Contract Interface.
10  * Copyright © 2016–2018 by ABDK Consulting.
11  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
12  */
13 
14 /**
15  * ERC-20 standard token interface, as defined
16  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
17  */
18 contract Token {
19   /**
20    * Get total number of tokens in circulation.
21    *
22    * @return total number of tokens in circulation
23    */
24   function totalSupply () public view returns (uint256 supply);
25 
26   /**
27    * Get number of tokens currently belonging to given owner.
28    *
29    * @param _owner address to get number of tokens currently belonging to the
30    *        owner of
31    * @return number of tokens currently belonging to the owner of given address
32    */
33   function balanceOf (address _owner) public view returns (uint256 balance);
34 
35   /**
36    * Transfer given number of tokens from message sender to given recipient.
37    *
38    * @param _to address to transfer tokens to the owner of
39    * @param _value number of tokens to transfer to the owner of given address
40    * @return true if tokens were transferred successfully, false otherwise
41    */
42   function transfer (address _to, uint256 _value)
43   public returns (bool success);
44 
45   /**
46    * Transfer given number of tokens from given owner to given recipient.
47    *
48    * @param _from address to transfer tokens from the owner of
49    * @param _to address to transfer tokens to the owner of
50    * @param _value number of tokens to transfer from given owner to given
51    *        recipient
52    * @return true if tokens were transferred successfully, false otherwise
53    */
54   function transferFrom (address _from, address _to, uint256 _value)
55   public returns (bool success);
56 
57   /**
58    * Allow given spender to transfer given number of tokens from message sender.
59    *
60    * @param _spender address to allow the owner of to transfer tokens from
61    *        message sender
62    * @param _value number of tokens to allow to transfer
63    * @return true if token transfer was successfully approved, false otherwise
64    */
65   function approve (address _spender, uint256 _value)
66   public returns (bool success);
67 
68   /**
69    * Tell how many tokens given spender is currently allowed to transfer from
70    * given owner.
71    *
72    * @param _owner address to get number of tokens allowed to be transferred
73    *        from the owner of
74    * @param _spender address to get number of tokens allowed to be transferred
75    *        by the owner of
76    * @return number of tokens given spender is currently allowed to transfer
77    *         from given owner
78    */
79   function allowance (address _owner, address _spender)
80   public view returns (uint256 remaining);
81 
82   /**
83    * Logged when tokens were transferred from one owner to another.
84    *
85    * @param _from address of the owner, tokens were transferred from
86    * @param _to address of the owner, tokens were transferred to
87    * @param _value number of tokens transferred
88    */
89   event Transfer (address indexed _from, address indexed _to, uint256 _value);
90 
91   /**
92    * Logged when owner approved his tokens to be transferred by some spender.
93    *
94    * @param _owner owner who approved his tokens to be transferred
95    * @param _spender spender who were allowed to transfer the tokens belonging
96    *        to the owner
97    * @param _value number of tokens belonging to the owner, approved to be
98    *        transferred by the spender
99    */
100   event Approval (
101     address indexed _owner, address indexed _spender, uint256 _value);
102 }
103 /*
104  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
105  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
106  */
107 pragma solidity ^0.4.20;
108 
109 /**
110  * Provides methods to safely add, subtract and multiply uint256 numbers.
111  */
112 contract SafeMath {
113   uint256 constant private MAX_UINT256 =
114     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
115 
116   /**
117    * Add two uint256 values, throw in case of overflow.
118    *
119    * @param x first value to add
120    * @param y second value to add
121    * @return x + y
122    */
123   function safeAdd (uint256 x, uint256 y)
124   pure internal
125   returns (uint256 z) {
126     assert (x <= MAX_UINT256 - y);
127     return x + y;
128   }
129 
130   /**
131    * Subtract one uint256 value from another, throw in case of underflow.
132    *
133    * @param x value to subtract from
134    * @param y value to subtract
135    * @return x - y
136    */
137   function safeSub (uint256 x, uint256 y)
138   pure internal
139   returns (uint256 z) {
140     assert (x >= y);
141     return x - y;
142   }
143 
144   /**
145    * Multiply two uint256 values, throw in case of overflow.
146    *
147    * @param x first value to multiply
148    * @param y second value to multiply
149    * @return x * y
150    */
151   function safeMul (uint256 x, uint256 y)
152   pure internal
153   returns (uint256 z) {
154     if (y == 0) return 0; // Prevent division by zero at the next line
155     assert (x <= MAX_UINT256 / y);
156     return x * y;
157   }
158 }
159 
160 
161 /**
162  * Abstract Token Smart Contract that could be used as a base contract for
163  * ERC-20 token contracts.
164  */
165 contract AbstractToken is Token, SafeMath {
166   /**
167    * Create new Abstract Token contract.
168    */
169   function AbstractToken () public {
170     // Do nothing
171   }
172 
173   /**
174    * Get number of tokens currently belonging to given owner.
175    *
176    * @param _owner address to get number of tokens currently belonging to the
177    *        owner of
178    * @return number of tokens currently belonging to the owner of given address
179    */
180   function balanceOf (address _owner) public view returns (uint256 balance) {
181     return accounts [_owner];
182   }
183 
184   /**
185    * Transfer given number of tokens from message sender to given recipient.
186    *
187    * @param _to address to transfer tokens to the owner of
188    * @param _value number of tokens to transfer to the owner of given address
189    * @return true if tokens were transferred successfully, false otherwise
190    */
191   function transfer (address _to, uint256 _value)
192   public returns (bool success) {
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
213   public returns (bool success) {
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
238   function approve (address _spender, uint256 _value)
239   public returns (bool success) {
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
257   function allowance (address _owner, address _spender)
258   public view returns (uint256 remaining) {
259     return allowances [_owner][_spender];
260   }
261 
262   /**
263    * Mapping from addresses of token holders to the numbers of tokens belonging
264    * to these token holders.
265    */
266   mapping (address => uint256) internal accounts;
267 
268   /**
269    * Mapping from addresses of token holders to the mapping of addresses of
270    * spenders to the allowances set by these token holders to these spenders.
271    */
272   mapping (address => mapping (address => uint256)) internal allowances;
273 }
274 
275 
276 /**
277  * Curaizon token smart contract.
278  */
279 contract Curatoken is AbstractToken {
280   /**
281    * Address of the owner of this smart contract.
282    */
283   address private owner;
284 
285   /**
286    * Total number of tokens in circulation.
287    */
288   uint256 tokenCount;
289 
290   /**
291    * True if tokens transfers are currently frozen, false otherwise.
292    */
293   bool frozen = false;
294 
295   /**
296    * Create new Curaizon token smart contract, with given number of tokens issued
297    * and given to msg.sender, and make msg.sender the owner of this smart
298    * contract.
299    *
300    * @param _tokenCount number of tokens to issue and give to msg.sender
301    */
302   function Curatoken (uint256 _tokenCount) public {
303     owner = msg.sender;
304     tokenCount = _tokenCount;
305     accounts [msg.sender] = _tokenCount;
306   }
307 
308   /**
309    * Get total number of tokens in circulation.
310    *
311    * @return total number of tokens in circulation
312    */
313   function totalSupply () public view returns (uint256 supply) {
314     return tokenCount;
315   }
316 
317   /**
318    * Get name of this token.
319    *
320    * @return name of this token
321    */
322   function name () public pure returns (string result) {
323     return "Curatoken";
324   }
325 
326   /**
327    * Get symbol of this token.
328    *
329    * @return symbol of this token
330    */
331   function symbol () public pure returns (string result) {
332     return "CTKN";
333   }
334   
335     /**
336    * Get number of decimals for this token.
337    *
338    * @return number of decimals for this token
339    */
340   function decimals () public pure returns (uint8 result) {
341     return 6;
342   }
343 
344 
345   /**
346    * Transfer given number of tokens from message sender to given recipient.
347    *
348    * @param _to address to transfer tokens to the owner of
349    * @param _value number of tokens to transfer to the owner of given address
350    * @return true if tokens were transferred successfully, false otherwise
351    */
352   function transfer (address _to, uint256 _value)
353     public returns (bool success) {
354     if (frozen) return false;
355     else return AbstractToken.transfer (_to, _value);
356   }
357 
358   /**
359    * Transfer given number of tokens from given owner to given recipient.
360    *
361    * @param _from address to transfer tokens from the owner of
362    * @param _to address to transfer tokens to the owner of
363    * @param _value number of tokens to transfer from given owner to given
364    *        recipient
365    * @return true if tokens were transferred successfully, false otherwise
366    */
367   function transferFrom (address _from, address _to, uint256 _value)
368     public returns (bool success) {
369     if (frozen) return false;
370     else return AbstractToken.transferFrom (_from, _to, _value);
371   }
372 
373   /**
374    * Change how many tokens given spender is allowed to transfer from message
375    * spender.  In order to prevent double spending of allowance, this method
376    * receives assumed current allowance value as an argument.  If actual
377    * allowance differs from an assumed one, this method just returns false.
378    *
379    * @param _spender address to allow the owner of to transfer tokens from
380    *        message sender
381    * @param _currentValue assumed number of tokens currently allowed to be
382    *        transferred
383    * @param _newValue number of tokens to allow to transfer
384    * @return true if token transfer was successfully approved, false otherwise
385    */
386   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
387     public returns (bool success) {
388     if (allowance (msg.sender, _spender) == _currentValue)
389       return approve (_spender, _newValue);
390     else return false;
391   }
392 
393   /**
394    * Set new owner for the smart contract.
395    * May only be called by smart contract owner.
396    *
397    * @param _newOwner address of new owner of the smart contract
398    */
399   function setOwner (address _newOwner) public {
400     require (msg.sender == owner);
401 
402     owner = _newOwner;
403   }
404 
405   /**
406    * Freeze token transfers.
407    * May only be called by smart contract owner.
408    */
409   function freezeTransfers () public {
410     require (msg.sender == owner);
411 
412     if (!frozen) {
413       frozen = true;
414       Freeze ();
415     }
416   }
417 
418   /**
419    * Unfreeze token transfers.
420    * May only be called by smart contract owner.
421    */
422   function unfreezeTransfers () public {
423     require (msg.sender == owner);
424 
425     if (frozen) {
426       frozen = false;
427       Unfreeze ();
428     }
429   }
430 
431   /**
432    * Logged when token transfers were frozen.
433    */
434   event Freeze ();
435 
436   /**
437    * Logged when token transfers were unfrozen.
438    */
439   event Unfreeze ();
440 }