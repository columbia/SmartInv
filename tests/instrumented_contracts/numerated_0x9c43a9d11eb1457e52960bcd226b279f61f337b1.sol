1 /*
2  * EIP-20 Standard Token Smart Contract Interface.
3  * Copyright © 2016–2018 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 pragma solidity ^0.4.20;
7 
8 /**
9  * ERC-20 standard token interface, as defined
10  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
11  */
12 contract Token {
13   /**
14    * Get total number of tokens in circulation.
15    *
16    * @return total number of tokens in circulation
17    */
18   function totalSupply () public view returns (uint256 supply);
19 
20   /**
21    * Get number of tokens currently belonging to given owner.
22    *
23    * @param _owner address to get number of tokens currently belonging to the
24    *        owner of
25    * @return number of tokens currently belonging to the owner of given address
26    */
27   function balanceOf (address _owner) public view returns (uint256 balance);
28 
29   /**
30    * Transfer given number of tokens from message sender to given recipient.
31    *
32    * @param _to address to transfer tokens to the owner of
33    * @param _value number of tokens to transfer to the owner of given address
34    * @return true if tokens were transferred successfully, false otherwise
35    */
36   function transfer (address _to, uint256 _value)
37   public returns (bool success);
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
49   public returns (bool success);
50 
51   /**
52    * Allow given spender to transfer given number of tokens from message sender.
53    *
54    * @param _spender address to allow the owner of to transfer tokens from
55    *        message sender
56    * @param _value number of tokens to allow to transfer
57    * @return true if token transfer was successfully approved, false otherwise
58    */
59   function approve (address _spender, uint256 _value)
60   public returns (bool success);
61 
62   /**
63    * Tell how many tokens given spender is currently allowed to transfer from
64    * given owner.
65    *
66    * @param _owner address to get number of tokens allowed to be transferred
67    *        from the owner of
68    * @param _spender address to get number of tokens allowed to be transferred
69    *        by the owner of
70    * @return number of tokens given spender is currently allowed to transfer
71    *         from given owner
72    */
73   function allowance (address _owner, address _spender)
74   public view returns (uint256 remaining);
75 
76   /**
77    * Logged when tokens were transferred from one owner to another.
78    *
79    * @param _from address of the owner, tokens were transferred from
80    * @param _to address of the owner, tokens were transferred to
81    * @param _value number of tokens transferred
82    */
83   event Transfer (address indexed _from, address indexed _to, uint256 _value);
84 
85   /**
86    * Logged when owner approved his tokens to be transferred by some spender.
87    *
88    * @param _owner owner who approved his tokens to be transferred
89    * @param _spender spender who were allowed to transfer the tokens belonging
90    *        to the owner
91    * @param _value number of tokens belonging to the owner, approved to be
92    *        transferred by the spender
93    */
94   event Approval (
95     address indexed _owner, address indexed _spender, uint256 _value);
96 }
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
112   pure internal
113   returns (uint256 z) {
114     assert (x <= MAX_UINT256 - y);
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
126   pure internal
127   returns (uint256 z) {
128     assert (x >= y);
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
140   pure internal
141   returns (uint256 z) {
142     if (y == 0) return 0; // Prevent division by zero at the next line
143     assert (x <= MAX_UINT256 / y);
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
155   function AbstractToken () public {
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
166   function balanceOf (address _owner) public view returns (uint256 balance) {
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
177   function transfer (address _to, uint256 _value)
178   public returns (bool success) {
179     uint256 fromBalance = accounts [msg.sender];
180     if (fromBalance < _value) return false;
181     if (_value > 0 && msg.sender != _to) {
182       accounts [msg.sender] = safeSub (fromBalance, _value);
183       accounts [_to] = safeAdd (accounts [_to], _value);
184     }
185     Transfer (msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190    * Transfer given number of tokens from given owner to given recipient.
191    *
192    * @param _from address to transfer tokens from the owner of
193    * @param _to address to transfer tokens to the owner of
194    * @param _value number of tokens to transfer from given owner to given
195    *        recipient
196    * @return true if tokens were transferred successfully, false otherwise
197    */
198   function transferFrom (address _from, address _to, uint256 _value)
199   public returns (bool success) {
200     uint256 spenderAllowance = allowances [_from][msg.sender];
201     if (spenderAllowance < _value) return false;
202     uint256 fromBalance = accounts [_from];
203     if (fromBalance < _value) return false;
204 
205     allowances [_from][msg.sender] =
206       safeSub (spenderAllowance, _value);
207 
208     if (_value > 0 && _from != _to) {
209       accounts [_from] = safeSub (fromBalance, _value);
210       accounts [_to] = safeAdd (accounts [_to], _value);
211     }
212     Transfer (_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * Allow given spender to transfer given number of tokens from message sender.
218    *
219    * @param _spender address to allow the owner of to transfer tokens from
220    *        message sender
221    * @param _value number of tokens to allow to transfer
222    * @return true if token transfer was successfully approved, false otherwise
223    */
224   function approve (address _spender, uint256 _value)
225   public returns (bool success) {
226     allowances [msg.sender][_spender] = _value;
227     Approval (msg.sender, _spender, _value);
228 
229     return true;
230   }
231 
232   /**
233    * Tell how many tokens given spender is currently allowed to transfer from
234    * given owner.
235    *
236    * @param _owner address to get number of tokens allowed to be transferred
237    *        from the owner of
238    * @param _spender address to get number of tokens allowed to be transferred
239    *        by the owner of
240    * @return number of tokens given spender is currently allowed to transfer
241    *         from given owner
242    */
243   function allowance (address _owner, address _spender)
244   public view returns (uint256 remaining) {
245     return allowances [_owner][_spender];
246   }
247 
248   /**
249    * Mapping from addresses of token holders to the numbers of tokens belonging
250    * to these token holders.
251    */
252   mapping (address => uint256) internal accounts;
253 
254   /**
255    * Mapping from addresses of token holders to the mapping of addresses of
256    * spenders to the allowances set by these token holders to these spenders.
257    */
258   mapping (address => mapping (address => uint256)) internal allowances;
259 }
260 
261 /**
262  * Orgon Token smart contract.
263  */
264 contract OrgonToken is AbstractToken {
265   /**
266    * Maximum allowed number of tokens in circulation (2^256 - 1).
267    */
268   uint256 constant MAX_TOKEN_COUNT =
269     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
270 
271   /**
272    * Deploy Orgon Token smart contract and make message sender to be the owner
273    * of the smart contract.
274    */
275   function OrgonToken () public {
276     owner = msg.sender;
277   }
278   /**
279    * Get name of this token.
280    *
281    * @return name of this token
282    */
283   function name () public pure returns (string) {
284     return "Orgon";
285   }
286 
287   /**
288    * Get symbol of this token.
289    *
290    * @return symbol of this token
291    */
292   function symbol () public pure returns (string) {
293     return "ORGN";
294   }
295 
296   /**
297    * Get number of decimals for this token.
298    *
299    * @return number of decimals for this token
300    */
301   function decimals () public pure returns (uint8) {
302     return 9;
303   }
304 
305   /**
306    * Get total number of tokens in circulation.
307    *
308    * @return total number of tokens in circulation
309    */
310   function totalSupply () public view returns (uint256 supply) {
311     return tokenCount;
312   }
313 
314   /**
315    * Create _value new tokens and give new created tokens to msg.sender.
316    * May only be called by smart contract owner.
317    *
318    * @param _value number of tokens to create
319    * @return true if tokens were created successfully, false otherwise
320    */
321   function createTokens (uint256 _value) public returns (bool) {
322     require (msg.sender == owner);
323 
324     if (_value > 0) {
325       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
326       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
327       tokenCount = safeAdd (tokenCount, _value);
328 
329       Transfer (address (0), msg.sender, _value);
330     }
331 
332     return true;
333   }
334 
335   /**
336    * Burn given number of tokens belonging to message sender.
337    * May only be called by smart contract owner.
338    *
339    * @param _value number of tokens to burn
340    * @return true on success, false on error
341    */
342   function burnTokens (uint256 _value) public returns (bool) {
343     require (msg.sender == owner);
344 
345     if (_value > accounts [msg.sender]) return false;
346     else if (_value > 0) {
347       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
348       tokenCount = safeSub (tokenCount, _value);
349 
350       Transfer (msg.sender, address (0), _value);
351 
352       return true;
353     } else return true;
354   }
355 
356   /**
357    * Set new owner for the smart contract.
358    * May only be called by smart contract owner.
359    *
360    * @param _newOwner address of new owner of the smart contract
361    */
362   function setOwner (address _newOwner) public {
363     require (msg.sender == owner);
364 
365     owner = _newOwner;
366   }
367 
368   /**
369    * Total number of tokens in circulation.
370    */
371   uint256 internal tokenCount;
372 
373   /**
374    * Owner of the smart contract.
375    */
376   address public owner;
377 }