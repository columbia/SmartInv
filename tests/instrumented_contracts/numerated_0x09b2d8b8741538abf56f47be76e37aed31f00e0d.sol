1 pragma solidity ^0.4.13;
2 
3 
4 
5 
6 interface ERC20Interface {
7 function totalSupply() external view returns (uint256);
8 
9 
10 
11 
12 function balanceOf(address who) external view returns (uint256);
13 
14 
15 
16 
17 function allowance(address owner, address spender)
18 external view returns (uint256);
19 
20 
21 
22 
23 function transfer(address to, uint256 value) external returns (bool);
24 
25 
26 
27 
28 function approve(address spender, uint256 value)
29 external returns (bool);
30 
31 
32 
33 
34 function transferFrom(address from, address to, uint256 value)
35 external returns (bool);
36 
37 
38 
39 
40 event Transfer(
41 address indexed from,
42 address indexed to,
43 uint256 value
44 );
45 
46 
47 
48 
49 event Approval(
50 address indexed owner,
51 address indexed spender,
52 uint256 value
53 );
54 }
55 
56 
57 
58 
59 contract OpsCoin is ERC20Interface {
60 
61 
62 
63 
64 /**
65 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
66 */
67 
68 
69 
70 
71 using SafeMath for uint256;
72 
73 
74 
75 
76 string public symbol;
77 string public name;
78 address public owner;
79 uint256 public totalSupply;
80 
81 
82 
83 
84 
85 
86 
87 
88 mapping (address => uint256) private balances;
89 mapping (address => mapping (address => uint256)) private allowed;
90 mapping (address => mapping (address => uint)) private timeLock;
91 
92 
93 
94 
95 
96 
97 
98 
99 constructor() {
100 symbol = "OPS";
101 name = "EY OpsCoin";
102 totalSupply = 1000000;
103 owner = msg.sender;
104 balances[owner] = totalSupply;
105 emit Transfer(address(0), owner, totalSupply);
106 }
107 
108 
109 
110 
111 //only owner  modifier
112 modifier onlyOwner () {
113 require(msg.sender == owner);
114 _;
115 }
116 
117 
118 
119 
120 /**
121 self destruct added by westlad
122 */
123 function close() public onlyOwner {
124 selfdestruct(owner);
125 }
126 
127 
128 
129 
130 /**
131 * @dev Gets the balance of the specified address.
132 * @param _address The address to query the balance of.
133 * @return An uint256 representing the amount owned by the passed address.
134 */
135 function balanceOf(address _address) public view returns (uint256) {
136 return balances[_address];
137 }
138 
139 
140 
141 
142 /**
143 * @dev Function to check the amount of tokens that an owner allowed to a spender.
144 * @param _owner address The address which owns the funds.
145 * @param _spender address The address which will spend the funds.
146 * @return A uint256 specifying the amount of tokens still available for the spender.
147 */
148 function allowance(address _owner, address _spender) public view returns (uint256)
149 {
150 return allowed[_owner][_spender];
151 }
152 
153 
154 
155 
156 /**
157 * @dev Total number of tokens in existence
158 */
159 function totalSupply() public view returns (uint256) {
160 return totalSupply;
161 }
162 
163 
164 
165 
166 
167 
168 
169 
170 /**
171 * @dev Internal function that mints an amount of the token and assigns it to
172 * an account. This encapsulates the modification of balances such that the
173 * proper events are emitted.
174 * @param _account The account that will receive the created tokens.
175 * @param _amount The amount that will be created.
176 */
177 function mint(address _account, uint256 _amount) public {
178 require(_account != 0);
179 require(_amount > 0);
180 totalSupply = totalSupply.add(_amount);
181 balances[_account] = balances[_account].add(_amount);
182 emit Transfer(address(0), _account, _amount);
183 }
184 
185 
186 
187 
188 /**
189 * @dev Internal function that burns an amount of the token of a given
190 * account.
191 * @param _account The account whose tokens will be burnt.
192 * @param _amount The amount that will be burnt.
193 */
194 function burn(address _account, uint256 _amount) public {
195 require(_account != 0);
196 require(_amount <= balances[_account]);
197 
198 
199 
200 
201 totalSupply = totalSupply.sub(_amount);
202 balances[_account] = balances[_account].sub(_amount);
203 emit Transfer(_account, address(0), _amount);
204 }
205 
206 
207 
208 
209 /**
210 * @dev Internal function that burns an amount of the token of a given
211 * account, deducting from the sender's allowance for said account. Uses the
212 * internal burn function.
213 * @param _account The account whose tokens will be burnt.
214 * @param _amount The amount that will be burnt.
215 */
216 function burnFrom(address _account, uint256 _amount) public {
217 require(_amount <= allowed[_account][msg.sender]);
218 
219 
220 
221 
222 allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
223 emit Approval(_account, msg.sender, allowed[_account][msg.sender]);
224 burn(_account, _amount);
225 }
226 
227 
228 
229 
230 /**
231 * @dev Transfer token for a specified address
232 * @param _to The address to transfer to.
233 * @param _value The amount to be transferred.
234 */
235 function transfer(address _to, uint256 _value) public returns (bool) {
236 require(_value <= balances[msg.sender]);
237 require(_to != address(0));
238 
239 
240 
241 
242 balances[msg.sender] = balances[msg.sender].sub(_value);
243 balances[_to] = balances[_to].add(_value);
244 emit Transfer(msg.sender, _to, _value);
245 return true;
246 }
247 
248 
249 
250 
251 /**
252 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253 * Beware that changing an allowance with this method brings the risk that someone may use both the old
254 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257 * @param _spender The address which will spend the funds.
258 * @param _value The amount of tokens to be spent.
259 */
260 function approve(address _spender, uint256 _value) public returns (bool) {
261 require(_spender != address(0));
262 
263 
264 
265 
266 allowed[msg.sender][_spender] = _value;
267 emit Approval(msg.sender, _spender, _value);
268 return true;
269 }
270 
271 
272 
273 
274 /**
275 * @dev Approve the passed address to spend the specified amount of tokens after a specfied amount of time on behalf of msg.sender.
276 * Beware that changing an allowance with this method brings the risk that someone may use both the old
277 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280 * @param _spender The address which will spend the funds.
281 * @param _value The amount of tokens to be spent.
282 * @param _timeLockTill The time until when this amount cannot be withdrawn
283 */
284 function approveAt(address _spender, uint256 _value, uint _timeLockTill) public returns (bool) {
285 require(_spender != address(0));
286 
287 
288 
289 
290 allowed[msg.sender][_spender] = _value;
291 timeLock[msg.sender][_spender] = _timeLockTill;
292 emit Approval(msg.sender, _spender, _value);
293 return true;
294 }
295 
296 
297 
298 
299 /**
300 * @dev Transfer tokens from one address to another
301 * @param _from address The address which you want to send tokens from
302 * @param _to address The address which you want to transfer to
303 * @param _value uint256 the amount of tokens to be transferred
304 */
305 function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
306 {
307 require(_value <= balances[_from]);
308 require(_value <= allowed[_from][msg.sender]);
309 require(_to != address(0));
310 
311 
312 
313 
314 balances[_from] = balances[_from].sub(_value);
315 balances[_to] = balances[_to].add(_value);
316 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317 emit Transfer(_from, _to, _value);
318 return true;
319 }
320 
321 
322 
323 
324 /**
325 * @dev Transfer tokens from one address to another
326 * @param _from address The address which you want to send tokens from
327 * @param _to address The address which you want to transfer to
328 * @param _value uint256 the amount of tokens to be transferred
329 */
330 function transferFromAt(address _from, address _to, uint256 _value) public returns (bool)
331 {
332 require(_value <= balances[_from]);
333 require(_value <= allowed[_from][msg.sender]);
334 require(_to != address(0));
335 require(block.timestamp > timeLock[_from][msg.sender]);
336 
337 
338 
339 
340 balances[_from] = balances[_from].sub(_value);
341 balances[_to] = balances[_to].add(_value);
342 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
343 emit Transfer(_from, _to, _value);
344 return true;
345 }
346 
347 
348 
349 
350 /**
351 * @dev Increase the amount of tokens that an owner allowed to a spender.
352 * approve should be called when allowed_[_spender] == 0. To increment
353 * allowed value is better to use this function to avoid 2 calls (and wait until
354 * the first transaction is mined)
355 * From MonolithDAO Token.sol
356 * @param _spender The address which will spend the funds.
357 * @param _addedValue The amount of tokens to increase the allowance by.
358 */
359 function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool)
360 {
361 require(_spender != address(0));
362 
363 
364 
365 
366 allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
367 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
368 return true;
369 }
370 
371 
372 
373 
374 /**
375 * @dev Decrease the amount of tokens that an owner allowed to a spender.
376 * approve should be called when allowed_[_spender] == 0. To decrement
377 * allowed value is better to use this function to avoid 2 calls (and wait until
378 * the first transaction is mined)
379 * From MonolithDAO Token.sol
380 * @param _spender The address which will spend the funds.
381 * @param _subtractedValue The amount of tokens to decrease the allowance by.
382 */
383 function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool)
384 {
385 require(_spender != address(0));
386 
387 
388 
389 
390 allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].sub(_subtractedValue));
391 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392 return true;
393 }
394 
395 
396 
397 
398 }
399 
400 
401 
402 
403 library SafeMath {
404 
405 
406 
407 
408 /**
409 * @dev Multiplies two numbers, reverts on overflow.
410 */
411 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
412 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
413 // benefit is lost if 'b' is also tested.
414 // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
415 if (a == 0) {
416 return 0;
417 }
418 
419 
420 
421 
422 uint256 c = a * b;
423 require(c / a == b);
424 
425 
426 
427 
428 return c;
429 }
430 
431 
432 
433 
434 /**
435 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
436 */
437 function div(uint256 a, uint256 b) internal pure returns (uint256) {
438 require(b > 0); // Solidity only automatically asserts when dividing by 0
439 uint256 c = a / b;
440 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
441 
442 
443 
444 
445 return c;
446 }
447 
448 
449 
450 
451 /**
452 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
453 */
454 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
455 require(b <= a);
456 uint256 c = a - b;
457 
458 
459 
460 
461 return c;
462 }
463 
464 
465 
466 
467 /**
468 * @dev Adds two numbers, reverts on overflow.
469 */
470 function add(uint256 a, uint256 b) internal pure returns (uint256) {
471 uint256 c = a + b;
472 require(c >= a);
473 
474 
475 
476 
477 return c;
478 }
479 
480 
481 
482 
483 /**
484 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
485 * reverts when dividing by zero.
486 */
487 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
488 require(b != 0);
489 return a % b;
490 }
491 }