1 pragma solidity ^0.4.13;
2 
3 
4 
5 contract ERC20Basic {
6 
7   uint256 public totalSupply;
8 
9   function balanceOf(address who) public constant returns (uint256);
10 
11   function transfer(address to, uint256 value) public returns (bool);
12 
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 
15 }
16 
17 
18 
19 contract ERC20 is ERC20Basic {
20 
21   function allowance(address owner, address spender) public constant returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24 
25   function approve(address spender, uint256 value) public returns (bool);
26 
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29 }
30 
31 
32 
33 contract Ownable {
34 
35   address public owner;
36 
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42 
43   /**
44 
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46 
47    * account.
48 
49    */
50 
51   function Ownable() {
52 
53     owner = msg.sender;
54 
55   }
56 
57 
58 
59   /**
60 
61    * @dev Throws if called by any account other than the owner.
62 
63    */
64 
65   modifier onlyOwner() {
66 
67     require(msg.sender == owner);
68 
69     _;
70 
71   }
72 
73 
74 
75   /**
76 
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78 
79    * @param newOwner The address to transfer ownership to.
80 
81    */
82 
83   function transferOwnership(address newOwner) onlyOwner public {
84 
85     require(newOwner != address(0));
86 
87     OwnershipTransferred(owner, newOwner);
88 
89     owner = newOwner;
90 
91   }
92 
93 }
94 
95 
96 
97 library SaferMath {
98 
99   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
100 
101     uint256 c = a * b;
102 
103     assert(a == 0 || c / a == b);
104 
105     return c;
106 
107   }
108 
109 
110 
111   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
112 
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114 
115     uint256 c = a / b;
116 
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119     return c;
120 
121   }
122 
123 
124 
125   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
126 
127     assert(b <= a);
128 
129     return a - b;
130 
131   }
132 
133 
134 
135   function add(uint256 a, uint256 b) internal constant returns (uint256) {
136 
137     uint256 c = a + b;
138 
139     assert(c >= a);
140 
141     return c;
142 
143   }
144 
145 }
146 
147 
148 
149 contract BasicToken is ERC20Basic {
150 
151   using SaferMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   /**
156 
157   * @dev transfer token for a specified address
158 
159   * @param _to The address to transfer to.
160 
161   * @param _value The amount to be transferred.
162 
163   */
164 
165   function transfer(address _to, uint256 _value) public returns (bool) {
166 
167     require(_to != address(0));
168 
169 
170 
171     // SafeMath.sub will throw if there is not enough balance.
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174 
175     balances[_to] = balances[_to].add(_value);
176 
177     Transfer(msg.sender, _to, _value);
178 
179     return true;
180 
181   }
182 
183 
184 
185   /**
186 
187   * @dev Gets the balance of the specified address.
188 
189   * @param _owner The address to query the the balance of.
190 
191   * @return An uint256 representing the amount owned by the passed address.
192 
193   */
194 
195   function balanceOf(address _owner) public constant returns (uint256 balance) {
196 
197     return balances[_owner];
198 
199   }
200 
201 
202 
203 }
204 
205 
206 
207 contract StandardToken is ERC20, BasicToken {
208 
209 
210 
211   mapping (address => mapping (address => uint256)) allowed;
212 
213 
214 
215 
216 
217   /**
218 
219    * @dev Transfer tokens from one address to another
220 
221    * @param _from address The address which you want to send tokens from
222 
223    * @param _to address The address which you want to transfer to
224 
225    * @param _value uint256 the amount of tokens to be transferred
226 
227    */
228 
229   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230 
231     require(_to != address(0));
232 
233 
234 
235     uint256 _allowance = allowed[_from][msg.sender];
236 
237 
238 
239     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
240 
241     // require (_value <= _allowance);
242 
243 
244 
245     balances[_from] = balances[_from].sub(_value);
246 
247     balances[_to] = balances[_to].add(_value);
248 
249     allowed[_from][msg.sender] = _allowance.sub(_value);
250 
251     Transfer(_from, _to, _value);
252 
253     return true;
254 
255   }
256 
257 
258 
259   /**
260 
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262 
263    *
264 
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266 
267    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268 
269    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
270 
271    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272 
273    * @param _spender The address which will spend the funds.
274 
275    * @param _value The amount of tokens to be spent.
276 
277    */
278 
279   function approve(address _spender, uint256 _value) public returns (bool) {
280 
281     allowed[msg.sender][_spender] = _value;
282 
283     Approval(msg.sender, _spender, _value);
284 
285     return true;
286 
287   }
288 
289 
290 
291   /**
292 
293    * @dev Function to check the amount of tokens that an owner allowed to a spender.
294 
295    * @param _owner address The address which owns the funds.
296 
297    * @param _spender address The address which will spend the funds.
298 
299    * @return A uint256 specifying the amount of tokens still available for the spender.
300 
301    */
302 
303   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
304 
305     return allowed[_owner][_spender];
306 
307   }
308 
309 
310 
311   /**
312 
313    * approve should be called when allowed[_spender] == 0. To increment
314 
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316 
317    * the first transaction is mined)
318 
319    * From MonolithDAO Token.sol
320 
321    */
322 
323   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
324 
325     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
326 
327     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328 
329     return true;
330 
331   }
332 
333 
334 
335   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
336 
337     uint oldValue = allowed[msg.sender][_spender];
338 
339     if (_subtractedValue > oldValue) {
340 
341       allowed[msg.sender][_spender] = 0;
342 
343     } else {
344 
345       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
346 
347     }
348 
349     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350 
351     return true;
352 
353   }
354 
355 }
356 
357 
358 
359 contract DexAlpha is StandardToken, Ownable {
360 
361 
362 
363   string public constant name = "DexAlpha Tokens";
364 
365   string public constant symbol = "DXAT";
366 
367   uint8 public constant decimals = 8;
368 
369 
370 
371   uint256 public constant SUPPLY_CAP = 1000000000 * (10 ** uint256(decimals));
372 
373 
374 
375   address NULL_ADDRESS = address(0);
376 
377 
378 
379   uint public nonce = 0;
380 
381 
382 
383 event NonceTick(uint nonce);
384 
385   function incNonce() {
386 
387     nonce += 1;
388 
389     if(nonce > 100) {
390 
391         nonce = 0;
392 
393     }
394 
395     NonceTick(nonce);
396 
397   }
398 
399   
400 
401   event PerformingDrop(uint count);
402 
403   function drop(address[] addresses, uint256 amount) public onlyOwner {
404 
405     uint256 amt = amount * 10**8;
406 
407     require(amt > 0);
408 
409     require(amt <= SUPPLY_CAP);
410 
411     PerformingDrop(addresses.length);
412 
413     
414 
415     // Multisend function
416 
417     assert(balances[owner] >= amt * addresses.length);
418 
419     for (uint i = 0; i < addresses.length; i++) {
420 
421       address recipient = addresses[i];
422 
423       if(recipient != NULL_ADDRESS) {
424 
425         balances[owner] -= amt;
426 
427         balances[recipient] += amt;
428 
429         Transfer(owner, recipient, amt);
430 
431       }
432 
433     }
434 
435   }
436 
437 
438 
439   /**
440 
441    * @dev Constructor that gives msg.sender all of existing tokens..
442 
443    */
444 
445   function DexAlpha() {
446 
447     totalSupply = SUPPLY_CAP;
448 
449     balances[msg.sender] = SUPPLY_CAP;
450 
451   }
452 
453 }