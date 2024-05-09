1 /*
2  * ICOS Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 
6 pragma solidity ^0.4.11;
7 
8 contract Token {
9   /**
10    * Get total number of tokens in circulation.
11    *
12    * @return total number of tokens in circulation
13    */
14   function totalSupply () constant returns (uint256 supply);
15 
16   /**
17    * Get number of tokens currently belonging to given owner.
18    *
19    * @param _owner address to get number of tokens currently belonging to the
20    *        owner of
21    * @return number of tokens currently belonging to the owner of given address
22    */
23   function balanceOf (address _owner) constant returns (uint256 balance);
24 
25   /**
26    * Transfer given number of tokens from message sender to given recipient.
27    *
28    * @param _to address to transfer tokens to the owner of
29    * @param _value number of tokens to transfer to the owner of given address
30    * @return true if tokens were transferred successfully, false otherwise
31    */
32   function transfer (address _to, uint256 _value) returns (bool success);
33 
34   /**
35    * Transfer given number of tokens from given owner to given recipient.
36    *
37    * @param _from address to transfer tokens from the owner of
38    * @param _to address to transfer tokens to the owner of
39    * @param _value number of tokens to transfer from given owner to given
40    *        recipient
41    * @return true if tokens were transferred successfully, false otherwise
42    */
43   function transferFrom (address _from, address _to, uint256 _value)
44   returns (bool success);
45 
46   /**
47    * Allow given spender to transfer given number of tokens from message sender.
48    *
49    * @param _spender address to allow the owner of to transfer tokens from
50    *        message sender
51    * @param _value number of tokens to allow to transfer
52    * @return true if token transfer was successfully approved, false otherwise
53    */
54   function approve (address _spender, uint256 _value) returns (bool success);
55 
56   /**
57    * Tell how many tokens given spender is currently allowed to transfer from
58    * given owner.
59    *
60    * @param _owner address to get number of tokens allowed to be transferred
61    *        from the owner of
62    * @param _spender address to get number of tokens allowed to be transferred
63    *        by the owner of
64    * @return number of tokens given spender is currently allowed to transfer
65    *         from given owner
66    */
67   function allowance (address _owner, address _spender) constant
68   returns (uint256 remaining);
69 
70   /**
71    * Logged when tokens were transferred from one owner to another.
72    *
73    * @param _from address of the owner, tokens were transferred from
74    * @param _to address of the owner, tokens were transferred to
75    * @param _value number of tokens transferred
76    */
77   event Transfer (address indexed _from, address indexed _to, uint256 _value);
78 
79   /**
80    * Logged when owner approved his tokens to be transferred by some spender.
81    *
82    * @param _owner owner who approved his tokens to be transferred
83    * @param _spender spender who were allowed to transfer the tokens belonging
84    *        to the owner
85    * @param _value number of tokens belonging to the owner, approved to be
86    *        transferred by the spender
87    */
88   event Approval (
89     address indexed _owner, address indexed _spender, uint256 _value);
90 }
91 /*
92  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
93  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
94  */
95 pragma solidity ^0.4.11;
96 
97 /**
98  * Provides methods to safely add, subtract and multiply uint256 numbers.
99  */
100 contract SafeMath {
101   uint256 constant private MAX_UINT256 =
102     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
103 
104   /**
105    * Add two uint256 values, throw in case of overflow.
106    *
107    * @param x first value to add
108    * @param y second value to add
109    * @return x + y
110    */
111   function safeAdd (uint256 x, uint256 y)
112   constant internal
113   returns (uint256 z) {
114     if (x > MAX_UINT256 - y) throw;
115     return x + y;
116   }
117 
118   /**
119    * Subtract one uint256 value from another, throw in case of underflow.
120    *
121    * @param x value to subtract from
122    * @param y value to subtract
123    * @return x - y
124    */
125   function safeSub (uint256 x, uint256 y)
126   constant internal
127   returns (uint256 z) {
128     if (x < y) throw;
129     return x - y;
130   }
131 
132   /**
133    * Multiply two uint256 values, throw in case of overflow.
134    *
135    * @param x first value to multiply
136    * @param y second value to multiply
137    * @return x * y
138    */
139   function safeMul (uint256 x, uint256 y)
140   constant internal
141   returns (uint256 z) {
142     if (y == 0) return 0; // Prevent division by zero at the next line
143     if (x > MAX_UINT256 / y) throw;
144     return x * y;
145   }
146 }
147 /**
148  * Abstract Token Smart Contract that could be used as a base contract for
149  * ERC-20 token contracts.
150  */
151 contract AbstractToken is Token, SafeMath {
152   /**
153    * Create new Abstract Token contract.
154    */
155   function AbstractToken () {
156     // Do nothing
157   }
158 
159   /**
160    * Get number of tokens currently belonging to given owner.
161    *
162    * @param _owner address to get number of tokens currently belonging to the
163    *        owner of
164    * @return number of tokens currently belonging to the owner of given address
165    */
166   function balanceOf (address _owner) constant returns (uint256 balance) {
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
177   function transfer (address _to, uint256 _value) returns (bool success) {
178     if (accounts [msg.sender] < _value) return false;
179     if (_value > 0 && msg.sender != _to) {
180       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
181       accounts [_to] = safeAdd (accounts [_to], _value);
182       Transfer (msg.sender, _to, _value);
183     }
184     return true;
185   }
186 
187   /**
188    * Transfer given number of tokens from given owner to given recipient.
189    *
190    * @param _from address to transfer tokens from the owner of
191    * @param _to address to transfer tokens to the owner of
192    * @param _value number of tokens to transfer from given owner to given
193    *        recipient
194    * @return true if tokens were transferred successfully, false otherwise
195    */
196   function transferFrom (address _from, address _to, uint256 _value)
197   returns (bool success) {
198     if (allowances [_from][msg.sender] < _value) return false;
199     if (accounts [_from] < _value) return false;
200 
201     allowances [_from][msg.sender] =
202       safeSub (allowances [_from][msg.sender], _value);
203 
204     if (_value > 0 && _from != _to) {
205       accounts [_from] = safeSub (accounts [_from], _value);
206       accounts [_to] = safeAdd (accounts [_to], _value);
207       Transfer (_from, _to, _value);
208     }
209     return true;
210   }
211 
212   /**
213    * Allow given spender to transfer given number of tokens from message sender.
214    *
215    * @param _spender address to allow the owner of to transfer tokens from
216    *        message sender
217    * @param _value number of tokens to allow to transfer
218    * @return true if token transfer was successfully approved, false otherwise
219    */
220   function approve (address _spender, uint256 _value) returns (bool success) {
221     allowances [msg.sender][_spender] = _value;
222     Approval (msg.sender, _spender, _value);
223 
224     return true;
225   }
226 
227   /**
228    * Tell how many tokens given spender is currently allowed to transfer from
229    * given owner.
230    *
231    * @param _owner address to get number of tokens allowed to be transferred
232    *        from the owner of
233    * @param _spender address to get number of tokens allowed to be transferred
234    *        by the owner of
235    * @return number of tokens given spender is currently allowed to transfer
236    *         from given owner
237    */
238   function allowance (address _owner, address _spender) constant
239   returns (uint256 remaining) {
240     return allowances [_owner][_spender];
241   }
242 
243   /**
244    * Mapping from addresses of token holders to the numbers of tokens belonging
245    * to these token holders.
246    */
247   mapping (address => uint256) accounts;
248 
249   /**
250    * Mapping from addresses of token holders to the mapping of addresses of
251    * spenders to the allowances set by these token holders to these spenders.
252    */
253   mapping (address => mapping (address => uint256)) private allowances;
254 }
255 
256 
257 contract ICOSToken is AbstractToken {
258   /**
259    * Address of the owner of this smart contract.
260    */
261   address owner;
262 
263   /**
264    * Total number of tokens ins circulation.
265    */
266   uint256 tokensCount;
267 
268   /**
269    * True if tokens transfers are currently frozen, false otherwise.
270    */
271   bool frozen = false;
272 
273   /**
274    * Create new ICOS Token Smart Contract, make message sender to be the owner
275    * of smart contract, issue given number of tokens and give them to message
276    * sender.
277    *
278    * @param _tokensCount number of tokens to issue and give to message sender
279    */
280   function ICOSToken (uint256 _tokensCount) {
281     tokensCount = _tokensCount;
282     accounts [msg.sender] = _tokensCount;
283     owner = msg.sender;
284   }
285 
286   /**
287    * Get name of this token.
288    *
289    * @return name of this token
290    */
291   function name () constant returns (string name) {
292     return "ICOS";
293   }
294 
295   /**
296    * Get number of decimals for this token.
297    *
298    * @return number of decimals for this token
299    */
300   function decimals () constant returns (uint8 decimals) {
301     return 6;
302   }
303 
304   /**
305    * Get total number of tokens in circulation.
306    *
307    * @return total number of tokens in circulation
308    */
309   function totalSupply () constant returns (uint256 supply) {
310     return tokensCount;
311   }
312 
313   /**
314    * Transfer given number of tokens from message sender to given recipient.
315    *
316    * @param _to address to transfer tokens to the owner of
317    * @param _value number of tokens to transfer to the owner of given address
318    * @return true if tokens were transferred successfully, false otherwise
319    */
320   function transfer (address _to, uint256 _value) returns (bool success) {
321     if (frozen) return false;
322     else return AbstractToken.transfer (_to, _value);
323   }
324 
325   /**
326    * Transfer given number of tokens from given owner to given recipient.
327    *
328    * @param _from address to transfer tokens from the owner of
329    * @param _to address to transfer tokens to the owner of
330    * @param _value number of tokens to transfer from given owner to given
331    *        recipient
332    * @return true if tokens were transferred successfully, false otherwise
333    */
334   function transferFrom (address _from, address _to, uint256 _value)
335   returns (bool success) {
336     if (frozen) return false;
337     else return AbstractToken.transferFrom (_from, _to, _value);
338   }
339 
340   /**
341    * Change how many tokens given spender is allowed to transfer from message
342    * spender.  In order to prevent double spending of allowance, this method
343    * receives assumed current allowance value as an argument.  If actual
344    * allowance differs from an assumed one, this method just returns false.
345    *
346    * @param _spender address to allow the owner of to transfer tokens from
347    *        message sender
348    * @param _currentValue assumed number of tokens currently allowed to be
349    *        transferred
350    * @param _newValue number of tokens to allow to transfer
351    * @return true if token transfer was successfully approved, false otherwise
352    */
353   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
354   returns (bool success) {
355     if (allowance (msg.sender, _spender) == _currentValue)
356       return approve (_spender, _newValue);
357     else return false;
358   }
359 
360   /**
361    * Burn given number of tokens belonging to message sender.
362    *
363    * @param _value number of tokens to burn
364    * @return true on success, false on error
365    */
366   function burnTokens (uint256 _value) returns (bool success) {
367     if (_value > accounts [msg.sender]) return false;
368     else if (_value > 0) {
369       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
370       tokensCount = safeSub (tokensCount, _value);
371       return true;
372     } else return true;
373   }
374 
375   /**
376    * Set new owner for the smart contract.
377    * May only be called by smart contract owner.
378    *
379    * @param _newOwner address of new owner of the smart contract
380    */
381   function setOwner (address _newOwner) {
382     if (msg.sender != owner) throw;
383 
384     owner = _newOwner;
385   }
386 
387   /**
388    * Freeze token transfers.
389    * May only be called by smart contract owner.
390    */
391   function freezeTransfers () {
392     if (msg.sender != owner) throw;
393 
394     if (!frozen) {
395       frozen = true;
396       Freeze ();
397     }
398   }
399 
400   /**
401    * Unfreeze token transfers.
402    * May only be called by smart contract owner.
403    */
404   function unfreezeTransfers () {
405     if (msg.sender != owner) throw;
406 
407     if (frozen) {
408       frozen = false;
409       Unfreeze ();
410     }
411   }
412 
413   /**
414    * Logged when token transfers were frozen.
415    */
416   event Freeze ();
417 
418   /**
419    * Logged when token transfers were unfrozen.
420    */
421   event Unfreeze ();
422 }