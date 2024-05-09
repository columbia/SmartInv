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
81 
82 
83 
84 
85   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87 
88 
89 
90 
91   /**
92 
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94 
95    * account.
96 
97    */
98 
99   function Ownable() {
100 
101     owner = msg.sender;
102 
103   }
104 
105 
106 
107 
108 
109   /**
110 
111    * @dev Throws if called by any account other than the owner.
112 
113    */
114 
115   modifier onlyOwner() {
116 
117     require(msg.sender == owner);
118 
119     _;
120 
121   }
122 
123 
124 
125 
126 
127   /**
128 
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130 
131    * @param newOwner The address to transfer ownership to.
132 
133    */
134 
135   function transferOwnership(address newOwner) onlyOwner public {
136 
137     require(newOwner != address(0));
138 
139     OwnershipTransferred(owner, newOwner);
140 
141     owner = newOwner;
142 
143   }
144 
145 }
146 
147 
148 
149 /**
150 
151  * @title ERC20Basic
152 
153  * @dev Simpler version of ERC20 interface
154 
155  * @dev see https://github.com/ethereum/EIPs/issues/179
156 
157  */
158 
159 contract ERC20Basic {
160 
161   uint256 public totalSupply;
162 
163   function balanceOf(address who) public constant returns (uint256);
164 
165   function transfer(address to, uint256 value) public returns (bool);
166 
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 
169 }
170 
171 
172 
173 
174 
175 /**
176 
177  * @title Basic token
178 
179  * @dev Basic version of StandardToken, with no allowances.
180 
181  */
182 
183 contract BasicToken is ERC20Basic {
184 
185   using SafeMath for uint256;
186 
187 
188 
189   mapping(address => uint256) balances;
190 
191 
192 
193   /**
194 
195   * @dev transfer token for a specified address
196 
197   * @param _to The address to transfer to.
198 
199   * @param _value The amount to be transferred.
200 
201   */
202 
203   function transfer(address _to, uint256 _value) public returns (bool) {
204 
205     require(_to != address(0));
206 
207 
208 
209     // SafeMath.sub will throw if there is not enough balance.
210 
211     balances[msg.sender] = balances[msg.sender].sub(_value);
212 
213     balances[_to] = balances[_to].add(_value);
214 
215     Transfer(msg.sender, _to, _value);
216 
217     return true;
218 
219   }
220 
221 
222 
223   /**
224 
225   * @dev Gets the balance of the specified address.
226 
227   * @param _owner The address to query the the balance of.
228 
229   * @return An uint256 representing the amount owned by the passed address.
230 
231   */
232 
233   function balanceOf(address _owner) public constant returns (uint256 balance) {
234 
235     return balances[_owner];
236 
237   }
238 
239 }
240 
241 
242 
243 /**
244 
245  * @title ERC20 interface
246 
247  * @dev see https://github.com/ethereum/EIPs/issues/20
248 
249  */
250 
251 contract ERC20 is ERC20Basic {
252 
253   function allowance(address owner, address spender) public constant returns (uint256);
254 
255   function transferFrom(address from, address to, uint256 value) public returns (bool);
256 
257   function approve(address spender, uint256 value) public returns (bool);
258 
259   event Approval(address indexed owner, address indexed spender, uint256 value);
260 
261 }
262 
263 
264 
265 
266 
267 /**
268 
269  * @title Standard ERC20 token
270 
271  *
272 
273  * @dev Implementation of the basic standard token.
274 
275  * @dev https://github.com/ethereum/EIPs/issues/20
276 
277  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
278 
279  */
280 
281 contract StandardToken is ERC20, BasicToken {
282 
283 
284 
285   mapping (address => mapping (address => uint256)) allowed;
286 
287 
288 
289 
290 
291   /**
292 
293    * @dev Transfer tokens from one address to another
294 
295    * @param _from address The address which you want to send tokens from
296 
297    * @param _to address The address which you want to transfer to
298 
299    * @param _value uint256 the amount of tokens to be transferred
300 
301    */
302 
303   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
304 
305     require(_to != address(0));
306 
307 
308 
309     uint256 _allowance = allowed[_from][msg.sender];
310 
311 
312 
313     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
314 
315     // require (_value <= _allowance);
316 
317 
318 
319     balances[_from] = balances[_from].sub(_value);
320 
321     balances[_to] = balances[_to].add(_value);
322 
323     allowed[_from][msg.sender] = _allowance.sub(_value);
324 
325     Transfer(_from, _to, _value);
326 
327     return true;
328 
329   }
330 
331 
332 
333   /**
334 
335    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
336 
337    *
338 
339    * Beware that changing an allowance with this method brings the risk that someone may use both the old
340 
341    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
342 
343    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
344 
345    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346 
347    * @param _spender The address which will spend the funds.
348 
349    * @param _value The amount of tokens to be spent.
350 
351    */
352 
353   function approve(address _spender, uint256 _value) public returns (bool) {
354 
355     allowed[msg.sender][_spender] = _value;
356 
357     Approval(msg.sender, _spender, _value);
358 
359     return true;
360 
361   }
362 
363 
364 
365   /**
366 
367    * @dev Function to check the amount of tokens that an owner allowed to a spender.
368 
369    * @param _owner address The address which owns the funds.
370 
371    * @param _spender address The address which will spend the funds.
372 
373    * @return A uint256 specifying the amount of tokens still available for the spender.
374 
375    */
376 
377   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
378 
379     return allowed[_owner][_spender];
380 
381   }
382 
383 
384 
385   /**
386 
387    * approve should be called when allowed[_spender] == 0. To increment
388 
389    * allowed value is better to use this function to avoid 2 calls (and wait until
390 
391    * the first transaction is mined)
392 
393    * From MonolithDAO Token.sol
394 
395    */
396 
397   function increaseApproval (address _spender, uint _addedValue)
398 
399     returns (bool success) {
400 
401     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
402 
403     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
404 
405     return true;
406 
407   }
408 
409 
410 
411   function decreaseApproval (address _spender, uint _subtractedValue)
412 
413     returns (bool success) {
414 
415     uint oldValue = allowed[msg.sender][_spender];
416 
417     if (_subtractedValue > oldValue) {
418 
419       allowed[msg.sender][_spender] = 0;
420 
421     } else {
422 
423       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
424 
425     }
426 
427     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
428 
429     return true;
430 
431   }
432 
433 }
434 
435 
436 
437 
438 
439 /**
440 
441  * @title Burnable Token
442 
443  * @dev Token that can be irreversibly burned (destroyed).
444 
445  */
446 
447 contract BurnableToken is StandardToken {
448 
449 
450 
451     event Burn(address indexed burner, uint256 value);
452 
453 
454 
455     /**
456 
457      * @dev Burns a specific amount of tokens.
458 
459      * @param _value The amount of token to be burned.
460 
461      */
462 
463     function burn(uint256 _value) public {
464 
465         require(_value > 0);
466 
467         require(_value <= balances[msg.sender]);
468 
469         // no need to require value <= totalSupply, since that would imply the
470 
471         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
472 
473 
474 
475         address burner = msg.sender;
476 
477         balances[burner] = balances[burner].sub(_value);
478 
479         totalSupply = totalSupply.sub(_value);
480 
481         Burn(burner, _value);
482 
483     }
484 
485 }
486 
487 
488 
489 contract EnthalpyNickel is BurnableToken, Ownable {
490 
491 
492 
493     string public constant name = "Enthalpy Nickel";
494 
495     string public constant symbol = "ENI";
496 
497     uint public constant decimals = 18;
498 
499     uint256 public constant initialSupply = 7000000000 * (10 ** uint256(decimals));
500 
501 
502 
503     // Constructor
504 
505     function EnthalpyNickel() {
506 
507         totalSupply = initialSupply;
508 
509         balances[msg.sender] = initialSupply; // Send all tokens to owner
510 
511     }
512 
513 }