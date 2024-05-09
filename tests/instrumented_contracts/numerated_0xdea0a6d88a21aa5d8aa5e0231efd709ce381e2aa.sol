1 pragma solidity ^0.4.12;
2 
3 
4 
5 /**
6 
7  * @title SafeMath
8 
9  * @dev Math operations with safety checks that throw on error
10 
11  */
12 
13 library SafeMath {
14 
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16 
17     uint256 c = a * b;
18 
19     assert(a == 0 || c / a == b);
20 
21     return c;
22 
23   }
24 
25 
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28 
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30 
31     uint256 c = a / b;
32 
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36 
37   }
38 
39 
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42 
43     assert(b <= a);
44 
45     return a - b;
46 
47   }
48 
49 
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52 
53     uint256 c = a + b;
54 
55     assert(c >= a);
56 
57     return c;
58 
59   }
60 
61 }
62 
63 
64 
65 
66 
67 /**
68 
69  * @title Ownable
70 
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72 
73  * functions, this simplifies the implementation of "user permissions".
74 
75  */
76 
77 contract Ownable {
78 
79   address public owner;
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83   /**
84 
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86 
87    * account.
88 
89    */
90 
91   function Ownable() {
92 
93     owner = msg.sender;
94 
95   }
96 
97 
98 
99   /**
100 
101    * @dev Throws if called by any account other than the owner.
102 
103    */
104 
105   modifier onlyOwner() {
106 
107     require(msg.sender == owner);
108 
109     _;
110 
111   }
112 
113 
114   /**
115 
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117 
118    * @param newOwner The address to transfer ownership to.
119 
120    */
121 
122   function transferOwnership(address newOwner) onlyOwner public {
123 
124     require(newOwner != address(0));
125 
126     OwnershipTransferred(owner, newOwner);
127 
128     owner = newOwner;
129 
130   }
131 
132 }
133 
134 
135 
136 /**
137 
138  * @title ERC20Basic
139 
140  * @dev Simpler version of ERC20 interface
141 
142  * @dev see https://github.com/ethereum/EIPs/issues/179
143 
144  */
145 
146 contract ERC20Basic {
147 
148   uint256 public totalSupply;
149 
150   function balanceOf(address who) public constant returns (uint256);
151 
152   function transfer(address to, uint256 value) public returns (bool);
153 
154   event Transfer(address indexed from, address indexed to, uint256 value);
155 
156 }
157 
158 
159 
160 
161 
162 /**
163 
164  * @title Basic token
165 
166  * @dev Basic version of StandardToken, with no allowances.
167 
168  */
169 
170 contract BasicToken is ERC20Basic {
171 
172   using SafeMath for uint256;
173 
174 
175 
176   mapping(address => uint256) balances;
177 
178 
179 
180   /**
181 
182   * @dev transfer token for a specified address
183 
184   * @param _to The address to transfer to.
185 
186   * @param _value The amount to be transferred.
187 
188   */
189 
190   function transfer(address _to, uint256 _value) public returns (bool) {
191 
192     require(_to != address(0));
193 
194 
195 
196     // SafeMath.sub will throw if there is not enough balance.
197 
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199 
200     balances[_to] = balances[_to].add(_value);
201 
202     Transfer(msg.sender, _to, _value);
203 
204     return true;
205 
206   }
207 
208 
209 
210   /**
211 
212   * @dev Gets the balance of the specified address.
213 
214   * @param _owner The address to query the the balance of.
215 
216   * @return An uint256 representing the amount owned by the passed address.
217 
218   */
219 
220   function balanceOf(address _owner) public constant returns (uint256 balance) {
221 
222     return balances[_owner];
223 
224   }
225 
226 }
227 
228 
229 
230 /**
231 
232  * @title ERC20 interface
233 
234  * @dev see https://github.com/ethereum/EIPs/issues/20
235 
236  */
237 
238 contract ERC20 is ERC20Basic {
239 
240   function allowance(address owner, address spender) public constant returns (uint256);
241 
242   function transferFrom(address from, address to, uint256 value) public returns (bool);
243 
244   function approve(address spender, uint256 value) public returns (bool);
245 
246   event Approval(address indexed owner, address indexed spender, uint256 value);
247 
248 }
249 
250 
251 
252 
253 
254 /**
255 
256  * @title Standard ERC20 token
257 
258  *
259 
260  * @dev Implementation of the basic standard token.
261 
262  * @dev https://github.com/ethereum/EIPs/issues/20
263 
264  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
265 
266  */
267 
268 contract StandardToken is ERC20, BasicToken {
269 
270 
271 
272   mapping (address => mapping (address => uint256)) allowed;
273 
274 
275 
276 
277 
278   /**
279 
280    * @dev Transfer tokens from one address to another
281 
282    * @param _from address The address which you want to send tokens from
283 
284    * @param _to address The address which you want to transfer to
285 
286    * @param _value uint256 the amount of tokens to be transferred
287 
288    */
289 
290   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
291 
292     require(_to != address(0));
293 
294 
295 
296     uint256 _allowance = allowed[_from][msg.sender];
297 
298 
299 
300     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
301 
302     // require (_value <= _allowance);
303 
304 
305 
306     balances[_from] = balances[_from].sub(_value);
307 
308     balances[_to] = balances[_to].add(_value);
309 
310     allowed[_from][msg.sender] = _allowance.sub(_value);
311 
312     Transfer(_from, _to, _value);
313 
314     return true;
315 
316   }
317 
318 
319 
320   /**
321 
322    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323 
324    *
325 
326    * Beware that changing an allowance with this method brings the risk that someone may use both the old
327 
328    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
329 
330    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
331 
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333 
334    * @param _spender The address which will spend the funds.
335 
336    * @param _value The amount of tokens to be spent.
337 
338    */
339 
340   function approve(address _spender, uint256 _value) public returns (bool) {
341 
342     allowed[msg.sender][_spender] = _value;
343 
344     Approval(msg.sender, _spender, _value);
345 
346     return true;
347 
348   }
349 
350 
351 
352   /**
353 
354    * @dev Function to check the amount of tokens that an owner allowed to a spender.
355 
356    * @param _owner address The address which owns the funds.
357 
358    * @param _spender address The address which will spend the funds.
359 
360    * @return A uint256 specifying the amount of tokens still available for the spender.
361 
362    */
363 
364   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
365 
366     return allowed[_owner][_spender];
367 
368   }
369 
370 
371 
372   /**
373 
374    * approve should be called when allowed[_spender] == 0. To increment
375 
376    * allowed value is better to use this function to avoid 2 calls (and wait until
377 
378    * the first transaction is mined)
379 
380    * From MonolithDAO Token.sol
381 
382    */
383 
384   function increaseApproval (address _spender, uint _addedValue)
385 
386     returns (bool success) {
387 
388     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
389 
390     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
391 
392     return true;
393 
394   }
395 
396 
397 
398   function decreaseApproval (address _spender, uint _subtractedValue)
399 
400     returns (bool success) {
401 
402     uint oldValue = allowed[msg.sender][_spender];
403 
404     if (_subtractedValue > oldValue) {
405 
406       allowed[msg.sender][_spender] = 0;
407 
408     } else {
409 
410       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
411 
412     }
413 
414     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415 
416     return true;
417 
418   }
419 
420 }
421 
422 
423 
424 
425 
426 /**
427 
428  * @title Burnable Token
429 
430  * @dev Token that can be irreversibly burned (destroyed).
431 
432  */
433 
434 contract BurnableToken is StandardToken {
435 
436 
437 
438     event Burn(address indexed burner, uint256 value);
439 
440 
441 
442     /**
443 
444      * @dev Burns a specific amount of tokens.
445 
446      * @param _value The amount of token to be burned.
447 
448      */
449 
450     function burn(uint256 _value) public {
451 
452         require(_value > 0);
453 
454         require(_value <= balances[msg.sender]);
455 
456         // no need to require value <= totalSupply, since that would imply the
457 
458         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
459 
460 
461 
462         address burner = msg.sender;
463 
464         balances[burner] = balances[burner].sub(_value);
465 
466         totalSupply = totalSupply.sub(_value);
467 
468         Burn(burner, _value);
469 
470     }
471 
472 }
473 
474 
475 
476 contract TitaToken  is BurnableToken, Ownable {
477 
478 
479 
480     string public constant name = "Tita";
481 
482     string public constant symbol = "TTN";
483 
484     uint public constant decimals = 18;
485 
486     uint256 public constant initialSupply = 250000000 * (10 ** uint256(decimals));
487 
488 
489 
490     // Constructor
491 
492     function TitaToken () {
493 
494         totalSupply = initialSupply;
495 
496         balances[msg.sender] = initialSupply; // Send all tokens to owner
497 
498     }
499 
500 
501 
502 }