1 pragma solidity ^0.4.16;
2 
3 
4 pragma solidity ^0.4.16;
5 
6 
7 pragma solidity ^0.4.16;
8 
9 /**
10  * ERC-20 standard token interface, as defined
11  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
12  */
13 contract Token {
14   /**
15    * Get total number of tokens in circulation.
16    *
17    * @return total number of tokens in circulation
18    */
19   function totalSupply () constant returns (uint256 supply);
20 
21   /**
22    * Get number of tokens currently belonging to given owner.
23    *
24    * @param _owner address to get number of tokens currently belonging to the
25    *        owner of
26    * @return number of tokens currently belonging to the owner of given address
27    */
28   function balanceOf (address _owner) constant returns (uint256 balance);
29 
30   /**
31    * Transfer given number of tokens from message sender to given recipient.
32    *
33    * @param _to address to transfer tokens to the owner of
34    * @param _value number of tokens to transfer to the owner of given address
35    * @return true if tokens were transferred successfully, false otherwise
36    */
37   function transfer (address _to, uint256 _value) returns (bool success);
38 
39   /**
40    * Transfer given number of tokens from given owner to given recipient.
41    *
42    * @param _from address to transfer tokens from the owner of
43    * @param _to address to transfer tokens to the owner of
44    * @param _value number of tokens to transfer from given owner to given
45    *        recipient
46    * @return true if tokens were transferred successfully, false otherwise
47    */
48   function transferFrom (address _from, address _to, uint256 _value)
49   returns (bool success);
50 
51   /**
52    * Allow given spender to transfer given number of tokens from message sender.
53    *
54    * @param _spender address to allow the owner of to transfer tokens from
55    *        message sender
56    * @param _value number of tokens to allow to transfer
57    * @return true if token transfer was successfully approved, false otherwise
58    */
59   function approve (address _spender, uint256 _value) returns (bool success);
60 
61   /**
62    * Tell how many tokens given spender is currently allowed to transfer from
63    * given owner.
64    *
65    * @param _owner address to get number of tokens allowed to be transferred
66    *        from the owner of
67    * @param _spender address to get number of tokens allowed to be transferred
68    *        by the owner of
69    * @return number of tokens given spender is currently allowed to transfer
70    *         from given owner
71    */
72   function allowance (address _owner, address _spender) constant
73   returns (uint256 remaining);
74 
75   /**
76    * Logged when tokens were transferred from one owner to another.
77    *
78    * @param _from address of the owner, tokens were transferred from
79    * @param _to address of the owner, tokens were transferred to
80    * @param _value number of tokens transferred
81    */
82   event Transfer (address indexed _from, address indexed _to, uint256 _value);
83 
84   /**
85    * Logged when owner approved his tokens to be transferred by some spender.
86    *
87    * @param _owner owner who approved his tokens to be transferred
88    * @param _spender spender who were allowed to transfer the tokens belonging
89    *        to the owner
90    * @param _value number of tokens belonging to the owner, approved to be
91    *        transferred by the spender
92    */
93   event Approval (
94     address indexed _owner, address indexed _spender, uint256 _value);
95 }
96 
97 /*
98  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
99  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
100  */
101 pragma solidity ^0.4.16;
102 
103 /**
104  * Provides methods to safely add, subtract and multiply uint256 numbers.
105  */
106 contract SafeMath {
107   uint256 constant private MAX_UINT256 =
108     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
109 
110   /**
111    * Add two uint256 values, throw in case of overflow.
112    *
113    * @param x first value to add
114    * @param y second value to add
115    * @return x + y
116    */
117   function safeAdd (uint256 x, uint256 y)
118   constant internal
119   returns (uint256 z) {
120     assert (x <= MAX_UINT256 - y);
121     return x + y;
122   }
123 
124   /**
125    * Subtract one uint256 value from another, throw in case of underflow.
126    *
127    * @param x value to subtract from
128    * @param y value to subtract
129    * @return x - y
130    */
131   function safeSub (uint256 x, uint256 y)
132   constant internal
133   returns (uint256 z) {
134     assert (x >= y);
135     return x - y;
136   }
137 
138   /**
139    * Multiply two uint256 values, throw in case of overflow.
140    *
141    * @param x first value to multiply
142    * @param y second value to multiply
143    * @return x * y
144    */
145   function safeMul (uint256 x, uint256 y)
146   constant internal
147   returns (uint256 z) {
148     if (y == 0) return 0; // Prevent division by zero at the next line
149     assert (x <= MAX_UINT256 / y);
150     return x * y;
151   }
152 }
153 
154 
155 /**
156  * Abstract Token Smart Contract that could be used as a base contract for
157  * ERC-20 token contracts.
158  */
159 contract AbstractToken is Token, SafeMath {
160   /**
161    * Create new Abstract Token contract.
162    */
163   function AbstractToken () {
164     // Do nothing
165   }
166 
167   /**
168    * Get number of tokens currently belonging to given owner.
169    *
170    * @param _owner address to get number of tokens currently belonging to the
171    *        owner of
172    * @return number of tokens currently belonging to the owner of given address
173    */
174   function balanceOf (address _owner) constant returns (uint256 balance) {
175     return accounts [_owner];
176   }
177 
178   /**
179    * Transfer given number of tokens from message sender to given recipient.
180    *
181    * @param _to address to transfer tokens to the owner of
182    * @param _value number of tokens to transfer to the owner of given address
183    * @return true if tokens were transferred successfully, false otherwise
184    */
185   function transfer (address _to, uint256 _value) returns (bool success) {
186     if (accounts [msg.sender] < _value) return false;
187     if (_value > 0 && msg.sender != _to) {
188       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
189       accounts [_to] = safeAdd (accounts [_to], _value);
190     }
191     Transfer (msg.sender, _to, _value);
192     return true;
193   }
194 
195   /**
196    * Transfer given number of tokens from given owner to given recipient.
197    *
198    * @param _from address to transfer tokens from the owner of
199    * @param _to address to transfer tokens to the owner of
200    * @param _value number of tokens to transfer from given owner to given
201    *        recipient
202    * @return true if tokens were transferred successfully, false otherwise
203    */
204   function transferFrom (address _from, address _to, uint256 _value)
205   returns (bool success) {
206     if (allowances [_from][msg.sender] < _value) return false;
207     if (accounts [_from] < _value) return false;
208 
209     allowances [_from][msg.sender] =
210       safeSub (allowances [_from][msg.sender], _value);
211 
212     if (_value > 0 && _from != _to) {
213       accounts [_from] = safeSub (accounts [_from], _value);
214       accounts [_to] = safeAdd (accounts [_to], _value);
215     }
216     Transfer (_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * Allow given spender to transfer given number of tokens from message sender.
222    *
223    * @param _spender address to allow the owner of to transfer tokens from
224    *        message sender
225    * @param _value number of tokens to allow to transfer
226    * @return true if token transfer was successfully approved, false otherwise
227    */
228   function approve (address _spender, uint256 _value) returns (bool success) {
229     allowances [msg.sender][_spender] = _value;
230     Approval (msg.sender, _spender, _value);
231 
232     return true;
233   }
234 
235   /**
236    * Tell how many tokens given spender is currently allowed to transfer from
237    * given owner.
238    *
239    * @param _owner address to get number of tokens allowed to be transferred
240    *        from the owner of
241    * @param _spender address to get number of tokens allowed to be transferred
242    *        by the owner of
243    * @return number of tokens given spender is currently allowed to transfer
244    *         from given owner
245    */
246   function allowance (address _owner, address _spender) constant
247   returns (uint256 remaining) {
248     return allowances [_owner][_spender];
249   }
250 
251   /**
252    * Mapping from addresses of token holders to the numbers of tokens belonging
253    * to these token holders.
254    */
255   mapping (address => uint256) accounts;
256 
257   /**
258    * Mapping from addresses of token holders to the mapping of addresses of
259    * spenders to the allowances set by these token holders to these spenders.
260    */
261   mapping (address => mapping (address => uint256)) private allowances;
262 }
263 
264 
265 /**
266  * PDPCoin token smart contract.
267  */
268 contract PDPCointoken is AbstractToken {
269   /**
270    * Maximum allowed number of tokens in circulation.
271    */
272   uint256 constant MAX_TOKEN_COUNT =
273     0x0e0d1afcb6833daf6e0833af8a7727d2874dff8c;
274 
275   /**
276    * Address of the owner of this smart contract.
277    */
278   address private owner;
279 
280   /**
281    * Current number of tokens in circulation.
282    */
283   uint256 tokenCount = 500000000 *1 ether;
284 
285 
286 
287   /**
288    * Create new PDPCoin token smart contract and make msg.sender the
289    * owner of this smart contract.
290    */
291   function PDPCointoken () {
292     owner = msg.sender;
293   }
294 
295   /**
296    * Get total number of tokens in circulation.
297    *
298    * @return total number of tokens in circulation
299    */
300   function totalSupply () constant returns (uint256 supply) {
301     return tokenCount;
302   }
303 
304   /**
305    * Get name of this token.
306    *
307    * @return name of this token
308    */
309   function name () constant returns (string result) {
310     return "PDPCOIN TOKEN";
311   }
312 
313   /**
314    * Get symbol of this token.
315    *
316    * @return symbol of this token
317    */
318   function symbol () constant returns (string result) {
319     return "PDP";
320   }
321 
322   /**
323    * Get number of decimals for this token.
324    *
325    * @return number of decimals for this token
326    */
327   function decimals () constant returns (uint8 result) {
328     return 18;
329   }
330 
331   /**
332    * Transfer given number of tokens from message sender to given recipient.
333    *
334    * @param _to address to transfer tokens to the owner of
335    * @param _value number of tokens to transfer to the owner of given address
336    * @return true if tokens were transferred successfully, false otherwise
337    */
338   function transfer (address _to, uint256 _value) returns (bool success) {
339    return AbstractToken.transfer (_to, _value);
340   }
341 
342   /**
343    * Transfer given number of tokens from given owner to given recipient.
344    *
345    * @param _from address to transfer tokens from the owner of
346    * @param _to address to transfer tokens to the owner of
347    * @param _value number of tokens to transfer from given owner to given
348    *        recipient
349    * @return true if tokens were transferred successfully, false otherwise
350    */
351   function transferFrom (address _from, address _to, uint256 _value)
352     returns (bool success) {
353     return AbstractToken.transferFrom (_from, _to, _value);
354   }
355 
356   /**
357    * Change how many tokens given spender is allowed to transfer from message
358    * spender.  In order to prevent double spending of allowance, this method
359    * receives assumed current allowance value as an argument.  If actual
360    * allowance differs from an assumed one, this method just returns false.
361    *
362    * @param _spender address to allow the owner of to transfer tokens from
363    *        message sender
364    * @param _currentValue assumed number of tokens currently allowed to be
365    *        transferred
366    * @param _newValue number of tokens to allow to transfer
367    * @return true if token transfer was successfully approved, false otherwise
368    */
369   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
370     returns (bool success) {
371     if (allowance (msg.sender, _spender) == _currentValue)
372       return approve (_spender, _newValue);
373     else return false;
374   }
375 
376   /**
377    * Burn given number of tokens belonging to message sender.
378    *
379    * @param _value number of tokens to burn
380    * @return true on success, false on error
381    */
382   function burnTokens (uint256 _value) returns (bool success) {
383     if (_value > accounts [msg.sender]) return false;
384     else if (_value > 0) {
385       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
386       tokenCount = safeSub (tokenCount, _value);
387       return true;
388     } else return true;
389   }
390 
391   /**
392    * Set new owner for the smart contract.
393    * May only be called by smart contract owner.
394    *
395    * @param _newOwner address of new owner of the smart contract
396    */
397   function setOwner (address _newOwner) {
398     require (msg.sender == owner);
399 
400     owner = _newOwner;
401   }
402 
403  }