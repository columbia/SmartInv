1 /*
2  * ERC-20 Standard Token Smart Contract Interface.
3  * Copyright © 2016–2017 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 pragma solidity ^0.4.16;
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
18   function totalSupply () constant returns (uint256 supply);
19 
20   /**
21    * Get number of tokens currently belonging to given owner.
22    *
23    * @param _owner address to get number of tokens currently belonging to the
24    *        owner of
25    * @return number of tokens currently belonging to the owner of given address
26    */
27   function balanceOf (address _owner) constant returns (uint256 balance);
28 
29   /**
30    * Transfer given number of tokens from message sender to given recipient.
31    *
32    * @param _to address to transfer tokens to the owner of
33    * @param _value number of tokens to transfer to the owner of given address
34    * @return true if tokens were transferred successfully, false otherwise
35    */
36   function transfer (address _to, uint256 _value) returns (bool success);
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
48   returns (bool success);
49 
50   /**
51    * Allow given spender to transfer given number of tokens from message sender.
52    *
53    * @param _spender address to allow the owner of to transfer tokens from
54    *        message sender
55    * @param _value number of tokens to allow to transfer
56    * @return true if token transfer was successfully approved, false otherwise
57    */
58   function approve (address _spender, uint256 _value) returns (bool success);
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
72   returns (uint256 remaining);
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
95 
96 /**
97  * Provides methods to safely add, subtract and multiply uint256 numbers.
98  */
99 contract SafeMath {
100   uint256 constant private MAX_UINT256 =
101     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
102 
103   /**
104    * Add two uint256 values, throw in case of overflow.
105    *
106    * @param x first value to add
107    * @param y second value to add
108    * @return x + y
109    */
110   function safeAdd (uint256 x, uint256 y)
111   constant internal
112   returns (uint256 z) {
113     assert (x <= MAX_UINT256 - y);
114     return x + y;
115   }
116 
117   /**
118    * Subtract one uint256 value from another, throw in case of underflow.
119    *
120    * @param x value to subtract from
121    * @param y value to subtract
122    * @return x - y
123    */
124   function safeSub (uint256 x, uint256 y)
125   constant internal
126   returns (uint256 z) {
127     assert (x >= y);
128     return x - y;
129   }
130 
131   /**
132    * Multiply two uint256 values, throw in case of overflow.
133    *
134    * @param x first value to multiply
135    * @param y second value to multiply
136    * @return x * y
137    */
138   function safeMul (uint256 x, uint256 y)
139   constant internal
140   returns (uint256 z) {
141     if (y == 0) return 0; // Prevent division by zero at the next line
142     assert (x <= MAX_UINT256 / y);
143     return x * y;
144   }
145 }
146 
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
178     uint256 fromBalance = accounts [msg.sender];
179     if (fromBalance < _value) return false;
180     if (_value > 0 && msg.sender != _to) {
181       accounts [msg.sender] = safeSub (fromBalance, _value);
182       accounts [_to] = safeAdd (accounts [_to], _value);
183     }
184     Transfer (msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189    * Transfer given number of tokens from given owner to given recipient.
190    *
191    * @param _from address to transfer tokens from the owner of
192    * @param _to address to transfer tokens to the owner of
193    * @param _value number of tokens to transfer from given owner to given
194    *        recipient
195    * @return true if tokens were transferred successfully, false otherwise
196    */
197   function transferFrom (address _from, address _to, uint256 _value)
198   returns (bool success) {
199     uint256 spenderAllowance = allowances [_from][msg.sender];
200     if (spenderAllowance < _value) return false;
201     uint256 fromBalance = accounts [_from];
202     if (fromBalance < _value) return false;
203 
204     allowances [_from][msg.sender] =
205       safeSub (spenderAllowance, _value);
206 
207     if (_value > 0 && _from != _to) {
208       accounts [_from] = safeSub (fromBalance, _value);
209       accounts [_to] = safeAdd (accounts [_to], _value);
210     }
211     Transfer (_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * Allow given spender to transfer given number of tokens from message sender.
217    *
218    * @param _spender address to allow the owner of to transfer tokens from
219    *        message sender
220    * @param _value number of tokens to allow to transfer
221    * @return true if token transfer was successfully approved, false otherwise
222    */
223   function approve (address _spender, uint256 _value) returns (bool success) {
224     allowances [msg.sender][_spender] = _value;
225     Approval (msg.sender, _spender, _value);
226 
227     return true;
228   }
229 
230   /**
231    * Tell how many tokens given spender is currently allowed to transfer from
232    * given owner.
233    *
234    * @param _owner address to get number of tokens allowed to be transferred
235    *        from the owner of
236    * @param _spender address to get number of tokens allowed to be transferred
237    *        by the owner of
238    * @return number of tokens given spender is currently allowed to transfer
239    *         from given owner
240    */
241   function allowance (address _owner, address _spender) constant
242   returns (uint256 remaining) {
243     return allowances [_owner][_spender];
244   }
245 
246   /**
247    * Mapping from addresses of token holders to the numbers of tokens belonging
248    * to these token holders.
249    */
250   mapping (address => uint256) accounts;
251 
252   /**
253    * Mapping from addresses of token holders to the mapping of addresses of
254    * spenders to the allowances set by these token holders to these spenders.
255    */
256   mapping (address => mapping (address => uint256)) private allowances;
257 }
258 
259 /**
260  * PAT Token Smart Contract.
261  */
262 contract PATToken is AbstractToken {
263   uint256 constant internal TOKENS_COUNT = 42000000000e18;
264 
265   /**
266    * Create PAT Token smart contract with given central bank address.
267    *
268    * @param _centralBank central bank address
269    */
270   function PATToken (address _centralBank)
271     AbstractToken () {
272     accounts [_centralBank] = TOKENS_COUNT; // Limit emission to 42G
273   }
274 
275   /**
276    * Get total number of tokens in circulation.
277    *
278    * @return total number of tokens in circulation
279    */
280   function totalSupply () constant returns (uint256 supply) {
281     return TOKENS_COUNT;
282   }
283 
284   /**
285    * Get name of this token.
286    *
287    * @return name of this token
288    */
289   function name () public pure returns (string) {
290     return "Pangea Arbitration Token";
291   }
292 
293   /**
294    * Get symbol of this token.
295    *
296    * @return symbol of this token
297    */
298   function symbol () public pure returns (string) {
299     return "PAT";
300   }
301 
302   /**
303    * Get number of decimals for this token.
304    *
305    * @return number of decimals for this token
306    */
307   function decimals () public pure returns (uint8) {
308     return 18;
309   }
310 }