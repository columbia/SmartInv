1 pragma solidity ^0.4.12;
2 
3 
4 
5 library SafeMath {
6 
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8 
9     uint256 c = a * b;
10 
11     assert(a == 0 || c / a == b);
12 
13     return c;
14 
15   }
16 
17 
18 
19   function div(uint256 a, uint256 b) internal constant returns (uint256) {
20 
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22 
23     uint256 c = a / b;
24 
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26 
27     return c;
28 
29   }
30 
31 
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34 
35     assert(b <= a);
36 
37     return a - b;
38 
39   }
40 
41 
42 
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44 
45     uint256 c = a + b;
46 
47     assert(c >= a);
48 
49     return c;
50 
51   }
52 
53 }
54 
55 
56 
57 
58 
59 /**
60 
61  * @title Ownable
62 
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64 
65  * functions, this simplifies the implementation of "user permissions".
66 
67  */
68 
69 contract Ownable {
70 
71   address public owner;
72 
73 
74 
75 
76 
77   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79 
80 
81 
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
99 
100 
101   /**
102 
103    * @dev Throws if called by any account other than the owner.
104 
105    */
106 
107   modifier onlyOwner() {
108 
109     require(msg.sender == owner);
110 
111     _;
112 
113   }
114 
115 
116 
117 
118 
119   /**
120 
121    * @dev Allows the current owner to transfer control of the contract to a newOwner.
122 
123    * @param newOwner The address to transfer ownership to.
124 
125    */
126 
127   function transferOwnership(address newOwner) onlyOwner public {
128 
129     require(newOwner != address(0));
130 
131     OwnershipTransferred(owner, newOwner);
132 
133     owner = newOwner;
134 
135   }
136 
137 }
138 
139 
140 
141 /**
142 
143  * @title ERC20Basic
144 
145  * @dev Simpler version of ERC20 interface
146 
147  * @dev see https://github.com/ethereum/EIPs/issues/179
148 
149  */
150 
151 contract ERC20Basic {
152 
153   uint256 public totalSupply;
154 
155   function balanceOf(address who) public constant returns (uint256);
156 
157   function transfer(address to, uint256 value) public returns (bool);
158 
159   event Transfer(address indexed from, address indexed to, uint256 value);
160 
161 }
162 
163 
164 
165 
166 
167 /**
168 
169  * @title Basic token
170 
171  * @dev Basic version of StandardToken, with no allowances.
172 
173  */
174 
175 contract BasicToken is ERC20Basic {
176 
177   using SafeMath for uint256;
178 
179 
180 
181   mapping(address => uint256) balances;
182 
183 
184 
185   /**
186 
187   * @dev transfer token for a specified address
188 
189   * @param _to The address to transfer to.
190 
191   * @param _value The amount to be transferred.
192 
193   */
194 
195   function transfer(address _to, uint256 _value) public returns (bool) {
196 
197     require(_to != address(0));
198 
199 
200 
201     // SafeMath.sub will throw if there is not enough balance.
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204 
205     balances[_to] = balances[_to].add(_value);
206 
207     Transfer(msg.sender, _to, _value);
208 
209     return true;
210 
211   }
212 
213 
214 
215   /**
216 
217   * @dev Gets the balance of the specified address.
218 
219   * @param _owner The address to query the the balance of.
220 
221   * @return An uint256 representing the amount owned by the passed address.
222 
223   */
224 
225   function balanceOf(address _owner) public constant returns (uint256 balance) {
226 
227     return balances[_owner];
228 
229   }
230 
231 }
232 
233 
234 
235 /**
236 
237  * @title ERC20 interface
238 
239  * @dev see https://github.com/ethereum/EIPs/issues/20
240 
241  */
242 
243 contract ERC20 is ERC20Basic {
244 
245   function allowance(address owner, address spender) public constant returns (uint256);
246 
247   function transferFrom(address from, address to, uint256 value) public returns (bool);
248 
249   function approve(address spender, uint256 value) public returns (bool);
250 
251   event Approval(address indexed owner, address indexed spender, uint256 value);
252 
253 }
254 
255 
256 
257 
258 
259 /**
260 
261  * @title Standard ERC20 token
262 
263  *
264 
265  * @dev Implementation of the basic standard token.
266 
267  * @dev https://github.com/ethereum/EIPs/issues/20
268 
269  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
270 
271  */
272 
273 contract StandardToken is ERC20, BasicToken {
274 
275 
276 
277   mapping (address => mapping (address => uint256)) allowed;
278 
279 
280 
281 
282 
283   /**
284 
285    * @dev Transfer tokens from one address to another
286 
287    * @param _from address The address which you want to send tokens from
288 
289    * @param _to address The address which you want to transfer to
290 
291    * @param _value uint256 the amount of tokens to be transferred
292 
293    */
294 
295   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
296 
297     require(_to != address(0));
298 
299 
300 
301     uint256 _allowance = allowed[_from][msg.sender];
302 
303 
304 
305     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
306 
307     // require (_value <= _allowance);
308 
309 
310 
311     balances[_from] = balances[_from].sub(_value);
312 
313     balances[_to] = balances[_to].add(_value);
314 
315     allowed[_from][msg.sender] = _allowance.sub(_value);
316 
317     Transfer(_from, _to, _value);
318 
319     return true;
320 
321   }
322 
323 
324 
325   /**
326 
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328 
329    *
330 
331    * Beware that changing an allowance with this method brings the risk that someone may use both the old
332 
333    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
334 
335    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
336 
337    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338 
339    * @param _spender The address which will spend the funds.
340 
341    * @param _value The amount of tokens to be spent.
342 
343    */
344 
345   function approve(address _spender, uint256 _value) public returns (bool) {
346 
347     allowed[msg.sender][_spender] = _value;
348 
349     Approval(msg.sender, _spender, _value);
350 
351     return true;
352 
353   }
354 
355 
356 
357   /**
358 
359    * @dev Function to check the amount of tokens that an owner allowed to a spender.
360 
361    * @param _owner address The address which owns the funds.
362 
363    * @param _spender address The address which will spend the funds.
364 
365    * @return A uint256 specifying the amount of tokens still available for the spender.
366 
367    */
368 
369   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
370 
371     return allowed[_owner][_spender];
372 
373   }
374 
375 
376 
377   /**
378 
379    * approve should be called when allowed[_spender] == 0. To increment
380 
381    * allowed value is better to use this function to avoid 2 calls (and wait until
382 
383    * the first transaction is mined)
384 
385    * From MonolithDAO Token.sol
386 
387    */
388 
389   function increaseApproval (address _spender, uint _addedValue)
390 
391     returns (bool success) {
392 
393     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
394 
395     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
396 
397     return true;
398 
399   }
400 
401 
402 
403   function decreaseApproval (address _spender, uint _subtractedValue)
404 
405     returns (bool success) {
406 
407     uint oldValue = allowed[msg.sender][_spender];
408 
409     if (_subtractedValue > oldValue) {
410 
411       allowed[msg.sender][_spender] = 0;
412 
413     } else {
414 
415       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
416 
417     }
418 
419     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
420 
421     return true;
422 
423   }
424 
425 }
426 
427 
428 
429 
430 
431 /**
432 
433  * @title Burnable Token
434 
435  * @dev Token that can be irreversibly burned (destroyed).
436 
437  */
438 
439 contract BurnableToken is StandardToken {
440 
441 
442 
443     event Burn(address indexed burner, uint256 value);
444 
445 
446 
447     /**
448 
449      * @dev Burns a specific amount of tokens.
450 
451      * @param _value The amount of token to be burned.
452 
453      */
454 
455     function burn(uint256 _value) public {
456 
457         require(_value > 0);
458 
459         require(_value <= balances[msg.sender]);
460 
461         // no need to require value <= totalSupply, since that would imply the
462 
463         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
464 
465 
466 
467         address burner = msg.sender;
468 
469         balances[burner] = balances[burner].sub(_value);
470 
471         totalSupply = totalSupply.sub(_value);
472 
473         Burn(burner, _value);
474 
475     }
476 
477 }
478 
479 
480 
481 contract LiteDashCoin is BurnableToken, Ownable {
482 
483 
484 
485     string public constant name = "LiteDash";
486 
487     string public constant symbol = "LDASH";
488 
489     uint public constant decimals = 18;
490 
491     uint256 public constant initialSupply = 18900000 * (10 ** uint256(decimals));
492 
493 
494 
495     // Constructor
496 
497     function LiteDashCoin() {
498 
499         totalSupply = initialSupply;
500 
501         balances[msg.sender] = initialSupply; // Send all tokens to owner
502 
503     }
504 
505 }