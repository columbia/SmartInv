1 pragma solidity ^0.4.16;
2 
3 pragma solidity ^0.4.20;
4 
5 /*
6  * EIP-20 Standard Token Smart Contract Interface.
7  * Copyright © 2016–2018 by ABDK Consulting.
8  */
9 pragma solidity ^0.4.20;
10 
11 /**
12  * ERC-20 standard token interface, as defined
13  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
14  */
15 contract Token {
16   /**
17    * Get total number of tokens in circulation.
18    *
19    * @return total number of tokens in circulation
20    */
21   function totalSupply () public view returns (uint256 supply);
22 
23   /**
24    * Get number of tokens currently belonging to given owner.
25    *
26    * @param _owner address to get number of tokens currently belonging to the
27    *        owner of
28    * @return number of tokens currently belonging to the owner of given address
29    */
30   function balanceOf (address _owner) public view returns (uint256 balance);
31 
32   /**
33    * Transfer given number of tokens from message sender to given recipient.
34    *
35    * @param _to address to transfer tokens to the owner of
36    * @param _value number of tokens to transfer to the owner of given address
37    * @return true if tokens were transferred successfully, false otherwise
38    */
39   function transfer (address _to, uint256 _value)
40   public returns (bool success);
41 
42   /**
43    * Transfer given number of tokens from given owner to given recipient.
44    *
45    * @param _from address to transfer tokens from the owner of
46    * @param _to address to transfer tokens to the owner of
47    * @param _value number of tokens to transfer from given owner to given
48    *        recipient
49    * @return true if tokens were transferred successfully, false otherwise
50    */
51   function transferFrom (address _from, address _to, uint256 _value)
52   public returns (bool success);
53 
54   /**
55    * Allow given spender to transfer given number of tokens from message sender.
56    *
57    * @param _spender address to allow the owner of to transfer tokens from
58    *        message sender
59    * @param _value number of tokens to allow to transfer
60    * @return true if token transfer was successfully approved, false otherwise
61    */
62   function approve (address _spender, uint256 _value)
63   public returns (bool success);
64 
65   /**
66    * Tell how many tokens given spender is currently allowed to transfer from
67    * given owner.
68    *
69    * @param _owner address to get number of tokens allowed to be transferred
70    *        from the owner of
71    * @param _spender address to get number of tokens allowed to be transferred
72    *        by the owner of
73    * @return number of tokens given spender is currently allowed to transfer
74    *         from given owner
75    */
76   function allowance (address _owner, address _spender)
77   public view returns (uint256 remaining);
78 
79   /**
80    * Logged when tokens were transferred from one owner to another.
81    *
82    * @param _from address of the owner, tokens were transferred from
83    * @param _to address of the owner, tokens were transferred to
84    * @param _value number of tokens transferred
85    */
86   event Transfer (address indexed _from, address indexed _to, uint256 _value);
87 
88   /**
89    * Logged when owner approved his tokens to be transferred by some spender.
90    *
91    * @param _owner owner who approved his tokens to be transferred
92    * @param _spender spender who were allowed to transfer the tokens belonging
93    *        to the owner
94    * @param _value number of tokens belonging to the owner, approved to be
95    *        transferred by the spender
96    */
97   event Approval (
98     address indexed _owner, address indexed _spender, uint256 _value);
99 }
100 /*
101  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
102  */
103 pragma solidity ^0.4.20;
104 
105 /**
106  * Provides methods to safely add, subtract and multiply uint256 numbers.
107  */
108 contract SafeMath {
109   uint256 constant private MAX_UINT256 =
110     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
111 
112   /**
113    * Add two uint256 values, throw in case of overflow.
114    *
115    * @param x first value to add
116    * @param y second value to add
117    * @return x + y
118    */
119   function safeAdd (uint256 x, uint256 y)
120   pure internal
121   returns (uint256 z) {
122     assert (x <= MAX_UINT256 - y);
123     return x + y;
124   }
125 
126   /**
127    * Subtract one uint256 value from another, throw in case of underflow.
128    *
129    * @param x value to subtract from
130    * @param y value to subtract
131    * @return x - y
132    */
133   function safeSub (uint256 x, uint256 y)
134   pure internal
135   returns (uint256 z) {
136     assert (x >= y);
137     return x - y;
138   }
139 
140   /**
141    * Multiply two uint256 values, throw in case of overflow.
142    *
143    * @param x first value to multiply
144    * @param y second value to multiply
145    * @return x * y
146    */
147   function safeMul (uint256 x, uint256 y)
148   pure internal
149   returns (uint256 z) {
150     if (y == 0) return 0; // Prevent division by zero at the next line
151     assert (x <= MAX_UINT256 / y);
152     return x * y;
153   }
154 }
155 
156 
157 /**
158  * Abstract Token Smart Contract that could be used as a base contract for
159  * ERC-20 token contracts.
160  */
161 contract AbstractToken is Token, SafeMath {
162   /**
163    * Create new Abstract Token contract.
164    */
165   function AbstractToken () public {
166     // Do nothing
167   }
168 
169   /**
170    * Get number of tokens currently belonging to given owner.
171    *
172    * @param _owner address to get number of tokens currently belonging to the
173    *        owner of
174    * @return number of tokens currently belonging to the owner of given address
175    */
176   function balanceOf (address _owner) public view returns (uint256 balance) {
177     return accounts [_owner];
178   }
179 
180   /**
181    * Transfer given number of tokens from message sender to given recipient.
182    *
183    * @param _to address to transfer tokens to the owner of
184    * @param _value number of tokens to transfer to the owner of given address
185    * @return true if tokens were transferred successfully, false otherwise
186    */
187   function transfer (address _to, uint256 _value)
188   public returns (bool success) {
189     uint256 fromBalance = accounts [msg.sender];
190     if (fromBalance < _value) return false;
191     if (_value > 0 && msg.sender != _to) {
192       accounts [msg.sender] = safeSub (fromBalance, _value);
193       accounts [_to] = safeAdd (accounts [_to], _value);
194     }
195     Transfer (msg.sender, _to, _value);
196     return true;
197   }
198 
199   /**
200    * Transfer given number of tokens from given owner to given recipient.
201    *
202    * @param _from address to transfer tokens from the owner of
203    * @param _to address to transfer tokens to the owner of
204    * @param _value number of tokens to transfer from given owner to given
205    *        recipient
206    * @return true if tokens were transferred successfully, false otherwise
207    */
208   function transferFrom (address _from, address _to, uint256 _value)
209   public returns (bool success) {
210     uint256 spenderAllowance = allowances [_from][msg.sender];
211     if (spenderAllowance < _value) return false;
212     uint256 fromBalance = accounts [_from];
213     if (fromBalance < _value) return false;
214 
215     allowances [_from][msg.sender] =
216       safeSub (spenderAllowance, _value);
217 
218     if (_value > 0 && _from != _to) {
219       accounts [_from] = safeSub (fromBalance, _value);
220       accounts [_to] = safeAdd (accounts [_to], _value);
221     }
222     Transfer (_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * Allow given spender to transfer given number of tokens from message sender.
228    *
229    * @param _spender address to allow the owner of to transfer tokens from
230    *        message sender
231    * @param _value number of tokens to allow to transfer
232    * @return true if token transfer was successfully approved, false otherwise
233    */
234   function approve (address _spender, uint256 _value)
235   public returns (bool success) {
236     allowances [msg.sender][_spender] = _value;
237     Approval (msg.sender, _spender, _value);
238 
239     return true;
240   }
241 
242   /**
243    * Tell how many tokens given spender is currently allowed to transfer from
244    * given owner.
245    *
246    * @param _owner address to get number of tokens allowed to be transferred
247    *        from the owner of
248    * @param _spender address to get number of tokens allowed to be transferred
249    *        by the owner of
250    * @return number of tokens given spender is currently allowed to transfer
251    *         from given owner
252    */
253   function allowance (address _owner, address _spender)
254   public view returns (uint256 remaining) {
255     return allowances [_owner][_spender];
256   }
257 
258   /**
259    * Mapping from addresses of token holders to the numbers of tokens belonging
260    * to these token holders.
261    */
262   mapping (address => uint256) internal accounts;
263 
264   /**
265    * Mapping from addresses of token holders to the mapping of addresses of
266    * spenders to the allowances set by these token holders to these spenders.
267    */
268   mapping (address => mapping (address => uint256)) internal allowances;
269 }
270 
271 
272 /**
273  * Sponsy token smart contract.
274  */
275 contract SponsyTokens is AbstractToken {
276   /**
277    * Address of the owner of this smart contract.
278    */
279   address private owner;
280 
281   /**
282    * Total number of tokens in circulation.
283    */
284   uint256 tokenCount;
285 
286   /**
287    * True if tokens transfers are currently frozen, false otherwise.
288    */
289   bool frozen = false;
290 
291   /**
292    * Create new Sponsy token smart contract, with given number of tokens issued
293    * and given to msg.sender, and make msg.sender the owner of this smart
294    * contract.
295    *
296    * @param _tokenCount number of tokens to issue and give to msg.sender
297    */
298   function SponsyTokens (uint256 _tokenCount) public {
299     owner = msg.sender;
300     tokenCount = _tokenCount;
301     accounts [msg.sender] = _tokenCount;
302   }
303 
304   /**
305    * Get total number of tokens in circulation.
306    *
307    * @return total number of tokens in circulation
308    */
309   function totalSupply () public view returns (uint256 supply) {
310     return tokenCount;
311   }
312 
313   /**
314    * Get name of this token.
315    *
316    * @return name of this token
317    */
318   function name () public pure returns (string result) {
319     return "Sponsy Token";
320   }
321 
322   /**
323    * Get symbol of this token.
324    *
325    * @return symbol of this token
326    */
327   function symbol () public pure returns (string result) {
328     return "SPONS";
329   }
330 
331   /**
332    * Get number of decimals for this token.
333    *
334    * @return number of decimals for this token
335    */
336   function decimals () public pure returns (uint8 result) {
337     return 6;
338   }
339 
340   /**
341    * Transfer given number of tokens from message sender to given recipient.
342    *
343    * @param _to address to transfer tokens to the owner of
344    * @param _value number of tokens to transfer to the owner of given address
345    * @return true if tokens were transferred successfully, false otherwise
346    */
347   function transfer (address _to, uint256 _value)
348     public returns (bool success) {
349     if (frozen) return false;
350     else return AbstractToken.transfer (_to, _value);
351   }
352 
353   /**
354    * Transfer given number of tokens from given owner to given recipient.
355    *
356    * @param _from address to transfer tokens from the owner of
357    * @param _to address to transfer tokens to the owner of
358    * @param _value number of tokens to transfer from given owner to given
359    *        recipient
360    * @return true if tokens were transferred successfully, false otherwise
361    */
362   function transferFrom (address _from, address _to, uint256 _value)
363     public returns (bool success) {
364     if (frozen) return false;
365     else return AbstractToken.transferFrom (_from, _to, _value);
366   }
367 
368   /**
369    * Change how many tokens given spender is allowed to transfer from message
370    * spender.  In order to prevent double spending of allowance, this method
371    * receives assumed current allowance value as an argument.  If actual
372    * allowance differs from an assumed one, this method just returns false.
373    *
374    * @param _spender address to allow the owner of to transfer tokens from
375    *        message sender
376    * @param _currentValue assumed number of tokens currently allowed to be
377    *        transferred
378    * @param _newValue number of tokens to allow to transfer
379    * @return true if token transfer was successfully approved, false otherwise
380    */
381   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
382     public returns (bool success) {
383     if (allowance (msg.sender, _spender) == _currentValue)
384       return approve (_spender, _newValue);
385     else return false;
386   }
387 
388   /**
389    * Burn given number of tokens belonging to message sender.
390    *
391    * @param _value number of tokens to burn
392    * @return true on success, false on error
393    */
394   function burnTokens (uint256 _value) public returns (bool success) {
395     if (_value > accounts [msg.sender]) return false;
396     else if (_value > 0) {
397       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
398       tokenCount = safeSub (tokenCount, _value);
399 
400       Transfer (msg.sender, address (0), _value);
401       return true;
402     } else return true;
403   }
404 
405   /**
406    * Set new owner for the smart contract.
407    * May only be called by smart contract owner.
408    *
409    * @param _newOwner address of new owner of the smart contract
410    */
411   function setOwner (address _newOwner) public {
412     require (msg.sender == owner);
413 
414     owner = _newOwner;
415   }
416 
417   /**
418    * Freeze token transfers.
419    * May only be called by smart contract owner.
420    */
421   function freezeTransfers () public {
422     require (msg.sender == owner);
423 
424     if (!frozen) {
425       frozen = true;
426       Freeze ();
427     }
428   }
429 
430   /**
431    * Unfreeze token transfers.
432    * May only be called by smart contract owner.
433    */
434   function unfreezeTransfers () public {
435     require (msg.sender == owner);
436 
437     if (frozen) {
438       frozen = false;
439       Unfreeze ();
440     }
441   }
442 
443   /**
444    * Logged when token transfers were frozen.
445    */
446   event Freeze ();
447 
448   /**
449    * Logged when token transfers were unfrozen.
450    */
451   event Unfreeze ();
452 }