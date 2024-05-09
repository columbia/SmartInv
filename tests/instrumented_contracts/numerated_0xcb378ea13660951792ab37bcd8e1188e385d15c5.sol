1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6 
7  * @title ERC20Basic
8 
9  * @dev Simpler version of ERC20 interface
10 
11  * See https://github.com/ethereum/EIPs/issues/179
12 
13  */
14 
15 contract ERC20Basic {
16 
17   function totalSupply() public view returns (uint256);
18 
19   function balanceOf(address who) public view returns (uint256);
20 
21   function transfer(address to, uint256 value) public returns (bool);
22 
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 
25 }
26 
27 
28 
29 /**
30 
31  * @title SafeMath
32 
33  * @dev Math operations with safety checks that throw on error
34 
35  */
36 
37 library SafeMath {
38 
39   /**
40 
41   * @dev Multiplies two numbers, throws on overflow.
42 
43   */
44 
45   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46 
47     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
48 
49     // benefit is lost if 'b' is also tested.
50 
51     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52 
53     if (a == 0) {
54 
55       return 0;
56 
57     }
58 
59 
60 
61     c = a * b;
62 
63     assert(c / a == b);
64 
65     return c;
66 
67   }
68 
69 
70 
71   /**
72 
73   * @dev Integer division of two numbers, truncating the quotient.
74 
75   */
76 
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78 
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80 
81     // uint256 c = a / b;
82 
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85     return a / b;
86 
87   }
88 
89 
90 
91   /**
92 
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94 
95   */
96 
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98 
99     assert(b <= a);
100 
101     return a - b;
102 
103   }
104 
105 
106 
107   /**
108 
109   * @dev Adds two numbers, throws on overflow.
110 
111   */
112 
113   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
114 
115     c = a + b;
116 
117     assert(c >= a);
118 
119     return c;
120 
121   }
122 
123 }
124 
125 
126 
127 /**
128 
129  * @title Basic token
130 
131  * @dev Basic version of StandardToken, with no allowances.
132 
133  */
134 
135 contract BasicToken is ERC20Basic {
136 
137   using SafeMath for uint256;
138 
139 
140 
141   mapping(address => uint256) balances;
142 
143 
144 
145   uint256 totalSupply_;
146 
147 
148 
149   /**
150 
151   * @dev Total number of tokens in existence
152 
153   */
154 
155   function totalSupply() public view returns (uint256) {
156 
157     return totalSupply_;
158 
159   }
160 
161 
162 
163   /**
164 
165   * @dev Transfer token for a specified address
166 
167   * @param _to The address to transfer to.
168 
169   * @param _value The amount to be transferred.
170 
171   */
172 
173   function transfer(address _to, uint256 _value) public returns (bool) {
174 
175     require(_to != address(0));
176 
177     require(_value <= balances[msg.sender]);
178 
179 
180 
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182 
183     balances[_to] = balances[_to].add(_value);
184 
185     emit Transfer(msg.sender, _to, _value);
186 
187     return true;
188 
189   }
190 
191 
192 
193   /**
194 
195   * @dev Gets the balance of the specified address.
196 
197   * @param _owner The address to query the the balance of.
198 
199   * @return An uint256 representing the amount owned by the passed address.
200 
201   */
202 
203   function balanceOf(address _owner) public view returns (uint256) {
204 
205     return balances[_owner];
206 
207   }
208 
209 }
210 
211 
212 
213 /**
214 
215  * @title ERC20 interface
216 
217  * @dev see https://github.com/ethereum/EIPs/issues/20
218 
219  */
220 
221 contract ERC20 is ERC20Basic {
222 
223   function allowance(address owner, address spender)
224 
225     public view returns (uint256);
226 
227 
228 
229   function transferFrom(address from, address to, uint256 value)
230 
231     public returns (bool);
232 
233 
234 
235   function approve(address spender, uint256 value) public returns (bool);
236 
237   event Approval(
238 
239     address indexed owner,
240 
241     address indexed spender,
242 
243     uint256 value
244 
245   );
246 
247 }
248 
249 
250 
251 /**
252 
253  * @title Standard ERC20 token
254 
255  *
256 
257  * @dev Implementation of the basic standard token.
258 
259  * https://github.com/ethereum/EIPs/issues/20
260 
261  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
262 
263  */
264 
265 contract StandardToken is ERC20, BasicToken {
266 
267 
268 
269   mapping (address => mapping (address => uint256)) internal allowed;
270 
271 
272 
273   /**
274 
275    * @dev Transfer tokens from one address to another
276 
277    * @param _from address The address which you want to send tokens from
278 
279    * @param _to address The address which you want to transfer to
280 
281    * @param _value uint256 the amount of tokens to be transferred
282 
283    */
284 
285   function transferFrom(
286 
287     address _from,
288 
289     address _to,
290 
291     uint256 _value
292 
293   )
294 
295     public
296 
297     returns (bool)
298 
299   {
300 
301     require(_to != address(0));
302 
303     require(_value <= balances[_from]);
304 
305     require(_value <= allowed[_from][msg.sender]);
306 
307 
308 
309     balances[_from] = balances[_from].sub(_value);
310 
311     balances[_to] = balances[_to].add(_value);
312 
313     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
314 
315     emit Transfer(_from, _to, _value);
316 
317     return true;
318 
319   }
320 
321 
322 
323   /**
324 
325    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
326 
327    * Beware that changing an allowance with this method brings the risk that someone may use both the old
328 
329    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
330 
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332 
333    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
334 
335    * @param _spender The address which will spend the funds.
336 
337    * @param _value The amount of tokens to be spent.
338 
339    */
340 
341   function approve(address _spender, uint256 _value) public returns (bool) {
342 
343     allowed[msg.sender][_spender] = _value;
344 
345     emit Approval(msg.sender, _spender, _value);
346 
347     return true;
348 
349   }
350 
351 
352 
353   /**
354 
355    * @dev Function to check the amount of tokens that an owner allowed to a spender.
356 
357    * @param _owner address The address which owns the funds.
358 
359    * @param _spender address The address which will spend the funds.
360 
361    * @return A uint256 specifying the amount of tokens still available for the spender.
362 
363    */
364 
365   function allowance(
366 
367     address _owner,
368 
369     address _spender
370 
371    )
372 
373     public
374 
375     view
376 
377     returns (uint256)
378 
379   {
380 
381     return allowed[_owner][_spender];
382 
383   }
384 
385 
386 
387   /**
388 
389    * @dev Increase the amount of tokens that an owner allowed to a spender.
390 
391    * approve should be called when allowed[_spender] == 0. To increment
392 
393    * allowed value is better to use this function to avoid 2 calls (and wait until
394 
395    * the first transaction is mined)
396 
397    * From MonolithDAO Token.sol
398 
399    * @param _spender The address which will spend the funds.
400 
401    * @param _addedValue The amount of tokens to increase the allowance by.
402 
403    */
404 
405   function increaseApproval(
406 
407     address _spender,
408 
409     uint256 _addedValue
410 
411   )
412 
413     public
414 
415     returns (bool)
416 
417   {
418 
419     allowed[msg.sender][_spender] = (
420 
421       allowed[msg.sender][_spender].add(_addedValue));
422 
423     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
424 
425     return true;
426 
427   }
428 
429 
430 
431   /**
432 
433    * @dev Decrease the amount of tokens that an owner allowed to a spender.
434 
435    * approve should be called when allowed[_spender] == 0. To decrement
436 
437    * allowed value is better to use this function to avoid 2 calls (and wait until
438 
439    * the first transaction is mined)
440 
441    * From MonolithDAO Token.sol
442 
443    * @param _spender The address which will spend the funds.
444 
445    * @param _subtractedValue The amount of tokens to decrease the allowance by.
446 
447    */
448 
449   function decreaseApproval(
450 
451     address _spender,
452 
453     uint256 _subtractedValue
454 
455   )
456 
457     public
458 
459     returns (bool)
460 
461   {
462 
463     uint256 oldValue = allowed[msg.sender][_spender];
464 
465     if (_subtractedValue > oldValue) {
466 
467       allowed[msg.sender][_spender] = 0;
468 
469     } else {
470 
471       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
472 
473     }
474 
475     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
476 
477     return true;
478 
479   }
480 
481 
482 
483 }
484 
485 
486 
487 contract EKToken is StandardToken {
488 
489     string public name = "EKToken"; 
490 
491     string public symbol = "EK";
492 
493     uint public decimals = 8;
494 
495     uint public totalSupply = 5000000000 * (10 ** decimals);
496 
497     
498 
499     constructor() public {
500 
501         balances[msg.sender] = totalSupply;
502 
503     }
504 
505 }