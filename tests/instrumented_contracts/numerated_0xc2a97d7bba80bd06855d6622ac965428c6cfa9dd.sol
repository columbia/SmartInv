1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4 
5   uint256 public totalSupply;
6 
7   function balanceOf(address who) public constant returns (uint256);
8 
9   function transfer(address to, uint256 value) public returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 
13 }
14 
15 contract ERC20 is ERC20Basic {
16 
17   function allowance(address owner, address spender) public constant returns (uint256);
18 
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20 
21   function approve(address spender, uint256 value) public returns (bool);
22 
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25 }
26 
27 contract BasicToken is ERC20Basic {
28 
29   using SaferMath for uint256;
30 
31   mapping(address => uint256) balances;
32 
33   /**
34 
35   * @dev transfer token for a specified address
36 
37   * @param _to The address to transfer to.
38 
39   * @param _value The amount to be transferred.
40 
41   */
42 
43   function transfer(address _to, uint256 _value) public returns (bool) {
44 
45     require(_to != address(0));
46 
47 
48 
49     // SafeMath.sub will throw if there is not enough balance.
50 
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52 
53     balances[_to] = balances[_to].add(_value);
54 
55     Transfer(msg.sender, _to, _value);
56 
57     return true;
58 
59   }
60 
61 
62 
63   /**
64 
65   * @dev Gets the balance of the specified address.
66 
67   * @param _owner The address to query the the balance of.
68 
69   * @return An uint256 representing the amount owned by the passed address.
70 
71   */
72 
73   function balanceOf(address _owner) public constant returns (uint256 balance) {
74 
75     return balances[_owner];
76 
77   }
78 
79 
80 
81 }
82 
83 contract StandardToken is ERC20, BasicToken {
84 
85 
86 
87   mapping (address => mapping (address => uint256)) allowed;
88 
89 
90 
91 
92 
93   /**
94 
95    * @dev Transfer tokens from one address to another
96 
97    * @param _from address The address which you want to send tokens from
98 
99    * @param _to address The address which you want to transfer to
100 
101    * @param _value uint256 the amount of tokens to be transferred
102 
103    */
104 
105   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106 
107     require(_to != address(0));
108 
109 
110 
111     uint256 _allowance = allowed[_from][msg.sender];
112 
113 
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116 
117     // require (_value <= _allowance);
118 
119 
120 
121     balances[_from] = balances[_from].sub(_value);
122 
123     balances[_to] = balances[_to].add(_value);
124 
125     allowed[_from][msg.sender] = _allowance.sub(_value);
126 
127     Transfer(_from, _to, _value);
128 
129     return true;
130 
131   }
132 
133 
134 
135   /**
136 
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138 
139    *
140 
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142 
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144 
145    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146 
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148 
149    * @param _spender The address which will spend the funds.
150 
151    * @param _value The amount of tokens to be spent.
152 
153    */
154 
155   function approve(address _spender, uint256 _value) public returns (bool) {
156 
157     allowed[msg.sender][_spender] = _value;
158 
159     Approval(msg.sender, _spender, _value);
160 
161     return true;
162 
163   }
164 
165 
166 
167   /**
168 
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170 
171    * @param _owner address The address which owns the funds.
172 
173    * @param _spender address The address which will spend the funds.
174 
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176 
177    */
178 
179   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
180 
181     return allowed[_owner][_spender];
182 
183   }
184 
185 
186 
187   /**
188 
189    * approve should be called when allowed[_spender] == 0. To increment
190 
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192 
193    * the first transaction is mined)
194 
195    * From MonolithDAO Token.sol
196 
197    */
198 
199   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
200 
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202 
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204 
205     return true;
206 
207   }
208 
209 
210 
211   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
212 
213     uint oldValue = allowed[msg.sender][_spender];
214 
215     if (_subtractedValue > oldValue) {
216 
217       allowed[msg.sender][_spender] = 0;
218 
219     } else {
220 
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222 
223     }
224 
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226 
227     return true;
228 
229   }
230 
231 }
232 
233 contract Ownable {
234 
235   address public owner;
236 
237 
238 
239   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
240 
241 
242 
243   /**
244 
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246 
247    * account.
248 
249    */
250 
251   function Ownable() {
252 
253     owner = msg.sender;
254 
255   }
256 
257 
258 
259   /**
260 
261    * @dev Throws if called by any account other than the owner.
262 
263    */
264 
265   modifier onlyOwner() {
266 
267     require(msg.sender == owner);
268 
269     _;
270 
271   }
272 
273 
274 
275   /**
276 
277    * @dev Allows the current owner to transfer control of the contract to a newOwner.
278 
279    * @param newOwner The address to transfer ownership to.
280 
281    */
282 
283   function transferOwnership(address newOwner) onlyOwner public {
284 
285     require(newOwner != address(0));
286 
287     OwnershipTransferred(owner, newOwner);
288 
289     owner = newOwner;
290 
291   }
292 
293 }
294 
295 contract BitcoinCore is StandardToken, Ownable {
296 
297 
298 
299   string public constant name = "Bitcoin Core";
300 
301   string public constant symbol = "BTCC";
302 
303   uint8 public constant decimals = 8;
304 
305 
306 
307   uint256 public constant SUPPLY_CAP = 42000000000 * (10 ** uint256(decimals));
308 
309 
310 
311   address NULL_ADDRESS = address(0);
312 
313   
314 
315   event PerformingDrop(uint count);
316 
317   function drop(address[] addresses, uint256 amount) public onlyOwner {
318 
319     uint256 amt = amount * 10**8;
320 
321     require(amt > 0);
322 
323     require(amt <= SUPPLY_CAP);
324 
325     PerformingDrop(addresses.length);
326 
327     // Maximum drop is 1000 addresses
328 
329     assert(addresses.length <= 1000);
330 
331     assert(balances[owner] >= amt * addresses.length);
332 
333     for (uint i = 0; i < addresses.length; i++) {
334 
335       address recipient = addresses[i];
336 
337       if (recipient != NULL_ADDRESS) {
338 
339         balances[owner] -= amt;
340 
341         balances[recipient] += amt;
342 
343         Transfer(owner, recipient, amt);
344 
345       }
346 
347     }
348 
349   }
350 
351 
352 
353   /**
354 
355    * @dev Constructor that gives msg.sender all of existing tokens..
356 
357    */
358 
359   function BitcoinCore() {
360 
361     totalSupply = SUPPLY_CAP;
362 
363     balances[msg.sender] = SUPPLY_CAP;
364 
365   }
366 
367 }
368 
369 library SaferMath {
370 
371   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
372 
373     uint256 c = a * b;
374 
375     assert(a == 0 || c / a == b);
376 
377     return c;
378 
379   }
380 
381 
382 
383   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
384 
385     // assert(b > 0); // Solidity automatically throws when dividing by 0
386 
387     uint256 c = a / b;
388 
389     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391     return c;
392 
393   }
394 
395 
396 
397   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
398 
399     assert(b <= a);
400 
401     return a - b;
402 
403   }
404 
405 
406 
407   function add(uint256 a, uint256 b) internal constant returns (uint256) {
408 
409     uint256 c = a + b;
410 
411     assert(c >= a);
412 
413     return c;
414 
415   }
416 
417 }