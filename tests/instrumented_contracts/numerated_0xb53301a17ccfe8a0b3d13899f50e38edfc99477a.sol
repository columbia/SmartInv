1 pragma solidity ^0.4.21;
2 /*
3  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 
7 
8 /**
9  * ERC-20 standard token interface, as defined
10  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
11  */
12 contract Token {
13   /**
14    * Get total number of tokens in circulation.
15    *
16    * @return total number of tokens in circulation
17    */
18   function totalSupply () public constant returns (uint256 supply);
19 
20   /**
21    * Get number of tokens currently belonging to given owner.
22    *
23    * @param _owner address to get number of tokens currently belonging to the
24    *        owner of
25    * @return number of tokens currently belonging to the owner of given address
26    */
27   function balanceOf (address _owner) public constant returns (uint256 balance);
28 
29   /**
30    * Transfer given number of tokens from message sender to given recipient.
31    *
32    * @param _to address to transfer tokens to the owner of
33    * @param _value number of tokens to transfer to the owner of given address
34    * @return true if tokens were transferred successfully, false otherwise
35    */
36   function transfer (address _to, uint256 _value) public returns (bool success);
37 
38   /**
39    * Transfer given number of tokens from given owner to given recipient.
40    *
41    * @param _from address to transfer tokens from the owner of
42    * @param _to address to transfer tokens to the owner of
43    * @param _value number of tokens to transfer from given owner to given
44    *        recipient
45    * @return true if tokens were transferred successfully, false otherwise
46    */
47   function transferFrom (address _from, address _to, uint256 _value)
48   public returns (bool success);
49 
50   /**
51    * Allow given spender to transfer given number of tokens from message sender.
52    *
53    * @param _spender address to allow the owner of to transfer tokens from
54    *        message sender
55    * @param _value number of tokens to allow to transfer
56    * @return true if token transfer was successfully approved, false otherwise
57    */
58   function approve (address _spender, uint256 _value) public returns (bool success);
59 
60   /**
61    * Tell how many tokens given spender is currently allowed to transfer from
62    * given owner.
63    *
64    * @param _owner address to get number of tokens allowed to be transferred
65    *        from the owner of
66    * @param _spender address to get number of tokens allowed to be transferred
67    *        by the owner of
68    * @return number of tokens given spender is currently allowed to transfer
69    *         from given owner
70    */
71   function allowance (address _owner, address _spender) constant
72   public returns (uint256 remaining);
73 
74   /**
75    * Logged when tokens were transferred from one owner to another.
76    *
77    * @param _from address of the owner, tokens were transferred from
78    * @param _to address of the owner, tokens were transferred to
79    * @param _value number of tokens transferred
80    */
81   event Transfer (address indexed _from, address indexed _to, uint256 _value);
82 
83   /**
84    * Logged when owner approved his tokens to be transferred by some spender.
85    *
86    * @param _owner owner who approved his tokens to be transferred
87    * @param _spender spender who were allowed to transfer the tokens belonging
88    *        to the owner
89    * @param _value number of tokens belonging to the owner, approved to be
90    *        transferred by the spender
91    */
92   event Approval (
93     address indexed _owner, address indexed _spender, uint256 _value);
94 }
95 /*
96  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
97  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
98  */
99 
100 
101 /**
102  * Provides methods to safely add, subtract and multiply uint256 numbers.
103  */
104 contract SafeMath {
105   uint256 constant private MAX_UINT256 =
106     0xFF;
107 
108   /**
109    * Add two uint256 values, throw in case of overflow.
110    *
111    * @param x first value to add
112    * @param y second value to add
113    * @return x + y
114    */
115   function safeAdd (uint256 x, uint256 y)
116   pure internal
117   returns (uint256 z) {
118     assert (x <= MAX_UINT256 - y);
119     return x + y;
120   }
121 
122   /**
123    * Subtract one uint256 value from another, throw in case of underflow.
124    *
125    * @param x value to subtract from
126    * @param y value to subtract
127    * @return x - y
128    */
129   function safeSub (uint256 x, uint256 y)
130   pure internal
131   returns (uint256 z) {
132     assert (x >= y);
133     return x - y;
134   }
135 
136   /**
137    * Multiply two uint256 values, throw in case of overflow.
138    *
139    * @param x first value to multiply
140    * @param y second value to multiply
141    * @return x * y
142    */
143   function safeMul (uint256 x, uint256 y)
144   pure internal
145   returns (uint256 z) {
146     if (y == 0) return 0; // Prevent division by zero at the next line
147     assert (x <= MAX_UINT256 / y);
148     return x * y;
149   }
150 }
151 /**
152  * Abstract Token Smart Contract that could be used as a base contract for
153  * ERC-20 token contracts.
154  */
155 
156 
157 contract AbstractToken is Token, SafeMath {
158   /**
159    * Create new Abstract Token contract.
160    */
161   function AbstractToken () public {
162     // Do nothing
163   }
164 
165   /**
166    * Get number of tokens currently belonging to given owner.
167    *
168    * @param _owner address to get number of tokens currently belonging to the
169    *        owner of
170    * @return number of tokens currently belonging to the owner of given address
171    */
172   function balanceOf (address _owner) public constant returns (uint256 balance) {
173     return accounts [_owner];
174   }
175 
176   /**
177    * Transfer given number of tokens from message sender to given recipient.
178    *
179    * @param _to address to transfer tokens to the owner of
180    * @param _value number of tokens to transfer to the owner of given address
181    * @return true if tokens were transferred successfully, false otherwise
182    */
183   function transfer (address _to, uint256 _value) public returns (bool success) {
184     if (accounts [msg.sender] < _value) return false;
185     if (_value > 0 && msg.sender != _to) {
186       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
187       accounts [_to] = safeAdd (accounts [_to], _value);
188     }
189     Transfer (msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194    * Transfer given number of tokens from given owner to given recipient.
195    *
196    * @param _from address to transfer tokens from the owner of
197    * @param _to address to transfer tokens to the owner of
198    * @param _value number of tokens to transfer from given owner to given
199    *        recipient
200    * @return true if tokens were transferred successfully, false otherwise
201    */
202   function transferFrom (address _from, address _to, uint256 _value)
203   public returns (bool success) {
204     if (allowances [_from][msg.sender] < _value) return false;
205     if (accounts [_from] < _value) return false;
206 
207     allowances [_from][msg.sender] =
208       safeSub (allowances [_from][msg.sender], _value);
209 
210     if (_value > 0 && _from != _to) {
211       accounts [_from] = safeSub (accounts [_from], _value);
212       accounts [_to] = safeAdd (accounts [_to], _value);
213     }
214     Transfer (_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * Allow given spender to transfer given number of tokens from message sender.
220    *
221    * @param _spender address to allow the owner of to transfer tokens from
222    *        message sender
223    * @param _value number of tokens to allow to transfer
224    * @return true if token transfer was successfully approved, false otherwise
225    */
226   function approve (address _spender, uint256 _value) public returns (bool success) {
227     allowances [msg.sender][_spender] = _value;
228     Approval (msg.sender, _spender, _value);
229 
230     return true;
231   }
232 
233   /**
234    * Tell how many tokens given spender is currently allowed to transfer from
235    * given owner.
236    *
237    * @param _owner address to get number of tokens allowed to be transferred
238    *        from the owner of
239    * @param _spender address to get number of tokens allowed to be transferred
240    *        by the owner of
241    * @return number of tokens given spender is currently allowed to transfer
242    *         from given owner
243    */
244   function allowance (address _owner, address _spender) public constant
245   returns (uint256 remaining) {
246     return allowances [_owner][_spender];
247   }
248 
249   /**
250    * Mapping from addresses of token holders to the numbers of tokens belonging
251    * to these token holders.
252    */
253   mapping (address => uint256) accounts;
254 
255   /**
256    * Mapping from addresses of token holders to the mapping of addresses of
257    * spenders to the allowances set by these token holders to these spenders.
258    */
259   mapping (address => mapping (address => uint256)) private allowances;
260 }
261 /**
262  * Ponder token smart contract.
263  */
264 
265 
266 contract PonderAirdropToken is AbstractToken {
267   /**
268    * Address of the owner of this smart contract.
269    */
270   address private owner;
271 
272   /**
273    * True if tokens transfers are currently frozen, false otherwise.
274    */
275   bool frozen = false;
276 
277   /**
278    * Create new Ponder token smart contract, with given number of tokens issued
279    * and given to msg.sender, and make msg.sender the owner of this smart
280    * contract.
281    */
282   function PonderAirdropToken () public {
283     owner = msg.sender;
284     accounts [msg.sender] = totalSupply();
285   }
286 
287   /**
288    * Get total number of tokens in circulation.
289    *
290    * @return total number of tokens in circulation
291    */
292   function totalSupply () public constant returns (uint256 supply) {
293     return 0;
294   }
295 
296   /**
297    * Get name of this token.
298    *
299    * @return name of this token
300    */
301   function name () public pure returns (string result) {
302     return "Ponder Airdrop Token";
303   }
304 
305   /**
306    * Get symbol of this token.
307    *
308    * @return symbol of this token
309    */
310   function symbol () public pure returns (string result) {
311     return "PONA";
312   }
313 
314   /**
315    * Get number of decimals for this token.
316    *
317    * @return number of decimals for this token
318    */
319   function decimals () public pure returns (uint256 result) {
320     return 0;
321   }
322 
323   /**
324    * Transfer given number of tokens from message sender to given recipient.
325    *
326    * @param _to address to transfer tokens to the owner of
327    * @param _value number of tokens to transfer to the owner of given address
328    * @return true if tokens were transferred successfully, false otherwise
329    */
330   function transfer (address _to, uint256 _value) public returns (bool success) {
331     if (frozen) return false;
332     else return AbstractToken.transfer (_to, _value);
333   }
334 
335   /**
336    * Transfer given number of tokens from given owner to given recipient.
337    *
338    * @param _from address to transfer tokens from the owner of
339    * @param _to address to transfer tokens to the owner of
340    * @param _value number of tokens to transfer from given owner to given
341    *        recipient
342    * @return true if tokens were transferred successfully, false otherwise
343    */
344   function transferFrom (address _from, address _to, uint256 _value)
345     public returns (bool success) {
346     if (frozen) return false;
347     else return AbstractToken.transferFrom (_from, _to, _value);
348   }
349 
350   /**
351    * Change how many tokens given spender is allowed to transfer from message
352    * spender.  In order to prevent double spending of allowance, this method
353    * receives assumed current allowance value as an argument.  If actual
354    * allowance differs from an assumed one, this method just returns false.
355    *
356    * @param _spender address to allow the owner of to transfer tokens from
357    *        message sender
358    * @param _currentValue assumed number of tokens currently allowed to be
359    *        transferred
360    * @param _newValue number of tokens to allow to transfer
361    * @return true if token transfer was successfully approved, false otherwise
362    */
363   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
364     public returns (bool success) {
365     if (allowance (msg.sender, _spender) == _currentValue)
366       return approve (_spender, _newValue);
367     else return false;
368   }
369 
370   /**
371    * Set new owner for the smart contract.
372    * May only be called by smart contract owner.
373    *
374    * @param _newOwner address of new owner of the smart contract
375    */
376   function setOwner (address _newOwner) public {
377     require (msg.sender == owner);
378 
379     owner = _newOwner;
380   }
381 
382   /**
383    * Freeze token transfers.
384    * May only be called by smart contract owner.
385    */
386   function freezeTransfers () public {
387     require (msg.sender == owner);
388 
389     if (!frozen) {
390       frozen = true;
391       Freeze ();
392     }
393   }
394 
395   /**
396    * Unfreeze token transfers.
397    * May only be called by smart contract owner.
398    */
399   function unfreezeTransfers () public {
400     require (msg.sender == owner);
401 
402     if (frozen) {
403       frozen = false;
404       Unfreeze ();
405     }
406   }
407 
408   /**
409    * Logged when token transfers were frozen.
410    */
411   event Freeze ();
412 
413   /**
414    * Logged when token transfers were unfrozen.
415    */
416   event Unfreeze ();
417   
418   function airdrop(address [] _addresses, uint256 [] values) public {
419     require (msg.sender == owner);
420     require (_addresses.length == values.length);
421     for (uint24 i = 0; i < _addresses.length; i++){
422       accounts[_addresses[i]] = values[i];
423     }
424   }
425 }