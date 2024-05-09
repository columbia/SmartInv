1 pragma solidity ^0.4.18;
2 
3 /*Deverlopment by anteros.io*/
4 
5 /*E-Mail:support@anteros.io*/
6 
7 /*twitter.com/anteros_token*/
8 
9 /**
10 
11 * @title SafeMath
12 
13 * @dev Math operations with safety checks that throw on error
14 
15 */
16 
17 library SafeMath {
18 
19 /**
20 
21 * @dev Multiplies two numbers, throws on overflow.
22 
23 */
24 
25 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26 
27 if (a == 0) {
28 
29 return 0;
30 
31 }
32 
33 uint256 c = a * b;
34 
35 assert(c / a == b);
36 
37 return c;
38 
39 }
40 
41 /**
42 
43 * @dev Integer division of two numbers, truncating the quotient.
44 
45 */
46 
47 function div(uint256 a, uint256 b) internal pure returns (uint256) {
48 
49 // assert(b > 0); // Solidity automatically throws when dividing by 0
50 
51 uint256 c = a / b;
52 
53 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55 return c;
56 
57 }
58 
59 /**
60 
61 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62 
63 */
64 
65 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66 
67 assert(b <= a);
68 
69 return a - b;
70 
71 }
72 
73 /**
74 
75 * @dev Adds two numbers, throws on overflow.
76 
77 */
78 
79 function add(uint256 a, uint256 b) internal pure returns (uint256) {
80 
81 uint256 c = a + b;
82 
83 assert(c >= a);
84 
85 return c;
86 
87 }
88 
89 }
90 
91 /**
92 
93 * @title ERC20Basic
94 
95 * @dev Simpler version of ERC20 interface
96 
97 * @dev see https://github.com/ethereum/EIPs/issues/179
98 
99 */
100 
101 contract ERC20Basic {
102 
103 function totalSupply() public view returns (uint256);
104 
105 function balanceOf(address who) public view returns (uint256);
106 
107 function transfer(address to, uint256 value) public returns (bool);
108 
109 event Transfer(address indexed from, address indexed to, uint256 value);
110 
111 }
112 
113 /**
114 
115 * @title ERC20 interface
116 
117 * @dev see https://github.com/ethereum/EIPs/issues/20
118 
119 */
120 
121 contract ERC20 is ERC20Basic {
122 
123 function allowance(address owner, address spender) public view returns (uint256);
124 
125 function transferFrom(address from, address to, uint256 value) public returns (bool);
126 
127 function approve(address spender, uint256 value) public returns (bool);
128 
129 event Approval(address indexed owner, address indexed spender, uint256 value);
130 
131 }
132 
133 /**
134 
135 * @title Basic token
136 
137 * @dev Basic version of StandardToken, with no allowances.
138 
139 */
140 
141 contract BasicToken is ERC20Basic {
142 
143 using SafeMath for uint256;
144 
145 mapping(address => uint256) balances;
146 
147 uint256 totalSupply_;
148 
149 /**
150 
151 * @dev total number of tokens in existence
152 
153 */
154 
155 function totalSupply() public view returns (uint256) {
156 
157 return totalSupply_;
158 
159 }
160 
161 /**
162 
163 * @dev transfer token for a specified address
164 
165 * @param _to The address to transfer to.
166 
167 * @param _value The amount to be transferred.
168 
169 */
170 
171 function transfer(address _to, uint256 _value) public returns (bool) {
172 
173 require(_to != address(0));
174 
175 require(_value <= balances[msg.sender]);
176 
177 // SafeMath.sub will throw if there is not enough balance.
178 
179 balances[msg.sender] = balances[msg.sender].sub(_value);
180 
181 balances[_to] = balances[_to].add(_value);
182 
183 Transfer(msg.sender, _to, _value);
184 
185 return true;
186 
187 }
188 
189 /**
190 
191 * @dev Gets the balance of the specified address.
192 
193 * @param _owner The address to query the the balance of.
194 
195 * @return An uint256 representing the amount owned by the passed address.
196 
197 */
198 
199 function balanceOf(address _owner) public view returns (uint256 balance) {
200 
201 return balances[_owner];
202 
203 }
204 
205 }
206 
207 /**
208 
209 * @title Standard ERC20 token
210 
211 *
212 
213 * @dev Implementation of the basic standard token.
214 
215 * @dev https://github.com/ethereum/EIPs/issues/20
216 
217 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218 
219 */
220 
221 contract StandardToken is ERC20, BasicToken {
222 
223 mapping (address => mapping (address => uint256)) internal allowed;
224 
225 /**
226 
227 * @dev Transfer tokens from one address to another
228 
229 * @param _from address The address which you want to send tokens from
230 
231 * @param _to address The address which you want to transfer to
232 
233 * @param _value uint256 the amount of tokens to be transferred
234 
235 */
236 
237 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238 
239 require(_to != address(0));
240 
241 require(_value <= balances[_from]);
242 
243 require(_value <= allowed[_from][msg.sender]);
244 
245 balances[_from] = balances[_from].sub(_value);
246 
247 balances[_to] = balances[_to].add(_value);
248 
249 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250 
251 Transfer(_from, _to, _value);
252 
253 return true;
254 
255 }
256 
257 /**
258 
259 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
260 
261 *
262 
263 * Beware that changing an allowance with this method brings the risk that someone may use both the old
264 
265 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266 
267 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268 
269 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270 
271 * @param _spender The address which will spend the funds.
272 
273 * @param _value The amount of tokens to be spent.
274 
275 */
276 
277 function approve(address _spender, uint256 _value) public returns (bool) {
278 
279 allowed[msg.sender][_spender] = _value;
280 
281 Approval(msg.sender, _spender, _value);
282 
283 return true;
284 
285 }
286 
287 /**
288 
289 * @dev Function to check the amount of tokens that an owner allowed to a spender.
290 
291 * @param _owner address The address which owns the funds.
292 
293 * @param _spender address The address which will spend the funds.
294 
295 * @return A uint256 specifying the amount of tokens still available for the spender.
296 
297 */
298 
299 function allowance(address _owner, address _spender) public view returns (uint256) {
300 
301 return allowed[_owner][_spender];
302 
303 }
304 
305 /**
306 
307 * @dev Increase the amount of tokens that an owner allowed to a spender.
308 
309 *
310 
311 * approve should be called when allowed[_spender] == 0. To increment
312 
313 * allowed value is better to use this function to avoid 2 calls (and wait until
314 
315 * the first transaction is mined)
316 
317 * From MonolithDAO Token.sol
318 
319 * @param _spender The address which will spend the funds.
320 
321 * @param _addedValue The amount of tokens to increase the allowance by.
322 
323 */
324 
325 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
326 
327 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
328 
329 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330 
331 return true;
332 
333 }
334 
335 /**
336 
337 * @dev Decrease the amount of tokens that an owner allowed to a spender.
338 
339 *
340 
341 * approve should be called when allowed[_spender] == 0. To decrement
342 
343 * allowed value is better to use this function to avoid 2 calls (and wait until
344 
345 * the first transaction is mined)
346 
347 * From MonolithDAO Token.sol
348 
349 * @param _spender The address which will spend the funds.
350 
351 * @param _subtractedValue The amount of tokens to decrease the allowance by.
352 
353 */
354 
355 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
356 
357 uint oldValue = allowed[msg.sender][_spender];
358 
359 if (_subtractedValue > oldValue) {
360 
361 allowed[msg.sender][_spender] = 0;
362 
363 } else {
364 
365 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
366 
367 }
368 
369 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
370 
371 return true;
372 
373 }
374 
375 }
376 
377 /**
378 
379 * @title AnterosToken
380 
381 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
382 
383 * Note they can later distribute these tokens as they wish using `transfer` and other
384 
385 * `StandardToken` functions.
386 
387 */
388 
389 contract AnterosToken is StandardToken {
390 
391 string public constant name = "AnterosToken";
392 
393 string public constant symbol = "AOS";
394 
395 uint8 public constant decimals = 0;
396 
397 uint256 public constant INITIAL_SUPPLY = 30000000 * 1 wei;
398 
399 /**
400 
401 * @dev Constructor that gives msg.sender all of existing tokens.
402 
403 */
404 
405 function AnterosToken() public {
406 
407 totalSupply_ = INITIAL_SUPPLY;
408 
409 balances[msg.sender] = INITIAL_SUPPLY;
410 
411 Transfer(0x0, msg.sender, INITIAL_SUPPLY);
412 
413 }
414 
415 }