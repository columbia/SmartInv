1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-28
3 */
4 
5 pragma solidity >=0.5.0 <0.6.0;
6 
7 /**
8  * @title SafeMath for uint256
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMathUint256 {
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         require(c / a == b, "SafeMath: Multiplier exception");
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a / b; // Solidity automatically throws when dividing by 0
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a, "SafeMath: Subtraction exception");
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         require(c >= a, "SafeMath: Addition exception");
45         return c;
46     }
47 
48     /**
49     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
50     * reverts when dividing by zero.
51     */
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0, "SafeMath: Modulo exception");
54         return a % b;
55     }
56 
57 }
58 
59 /**
60  * @title SafeMath for uint8
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMathUint8 {
64     /**
65     * @dev Multiplies two numbers, throws on overflow.
66     */
67     function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
68         if (a == 0) {
69             return 0;
70         }
71         c = a * b;
72         require(c / a == b, "SafeMath: Multiplier exception");
73         return c;
74     }
75 
76     /**
77     * @dev Integer division of two numbers, truncating the quotient.
78     */
79     function div(uint8 a, uint8 b) internal pure returns (uint8) {
80         return a / b; // Solidity automatically throws when dividing by 0
81     }
82 
83     /**
84     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85     */
86     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
87         require(b <= a, "SafeMath: Subtraction exception");
88         return a - b;
89     }
90 
91     /**
92     * @dev Adds two numbers, throws on overflow.
93     */
94     function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
95         c = a + b;
96         require(c >= a, "SafeMath: Addition exception");
97         return c;
98     }
99 
100     /**
101     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
102     * reverts when dividing by zero.
103     */
104     function mod(uint8 a, uint8 b) internal pure returns (uint8) {
105         require(b != 0, "SafeMath: Modulo exception");
106         return a % b;
107     }
108 
109 }
110 
111 
112 contract Ownership {
113     address payable public owner;
114     address payable public pendingOwner;
115 
116     event OwnershipTransferred (address indexed from, address indexed to);
117 
118     constructor () public
119     {
120         owner = msg.sender;
121     }
122 
123     modifier onlyOwner {
124         require (msg.sender == owner, "Ownership: Access denied");
125         _;
126     }
127 
128     function transferOwnership (address payable _pendingOwner) public
129         onlyOwner
130     {
131         pendingOwner = _pendingOwner;
132     }
133 
134     function acceptOwnership () public
135     {
136         require (msg.sender == pendingOwner, "Ownership: Only new owner is allowed");
137 
138         emit OwnershipTransferred (owner, pendingOwner);
139 
140         owner = pendingOwner;
141         pendingOwner = address(0);
142     }
143 
144 }
145 
146 
147 /**
148  * @title Controllable contract
149  * @dev Implementation of the controllable operations
150  */
151 contract Controllable is Ownership {
152 
153     bool public stopped;
154     mapping (address => bool) public freezeAddresses;
155 
156     event Paused();
157     event Resumed();
158 
159     event FreezeAddress(address indexed addressOf);
160     event UnfreezeAddress(address indexed addressOf);
161 
162     modifier onlyActive(address _sender) {
163         require(!freezeAddresses[_sender], "Controllable: Not active");
164         _;
165     }
166 
167     modifier isUsable {
168         require(!stopped, "Controllable: Paused");
169         _;
170     }
171 
172     function pause () public
173         onlyOwner
174     {
175         stopped = true;
176         emit Paused ();
177     }
178     
179     function resume () public
180         onlyOwner
181     {
182         stopped = false;
183         emit Resumed ();
184     }
185 
186     function freezeAddress(address _addressOf) public
187         onlyOwner
188         returns (bool)
189     {
190         if (!freezeAddresses[_addressOf]) {
191             freezeAddresses[_addressOf] = true;
192             emit FreezeAddress(_addressOf);
193         }
194 
195         return true;
196     }
197 	
198     function unfreezeAddress(address _addressOf) public
199         onlyOwner
200         returns (bool)
201     {
202         if (freezeAddresses[_addressOf]) {
203             delete freezeAddresses[_addressOf];
204             emit UnfreezeAddress(_addressOf);
205         }
206 
207         return true;
208     }
209 
210 }
211 
212 
213 /**
214  * @title ERC20Basic
215  * @dev Simpler version of ERC20 interface
216  * @dev see https://github.com/ethereum/EIPs/issues/179
217  */
218 contract ERC20Basic {
219     function balanceOf(address who) public view returns (uint256);
220     function transfer(address to, uint256 value) public returns (bool);
221 
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 }
224 
225 
226 /**
227  * @title ERC20 interface
228  * @dev see https://github.com/ethereum/EIPs/issues/20
229  */
230 contract ERC20 is ERC20Basic {
231     function allowance(address owner, address spender) public view returns (uint256);
232     function transferFrom(address from, address to, uint256 value) public returns (bool);
233     function approve(address spender, uint256 value) public returns (bool);
234 
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 
239 /**
240  * @title Basic token
241  * @dev Basic version of StandardToken, with no allowances.
242  */
243 contract BasicToken is ERC20Basic, Controllable {
244     using SafeMathUint256 for uint256;
245 
246     mapping(address => uint256) balances;
247 
248     uint256 public totalSupply;
249 
250     constructor(uint256 _initialSupply) public
251     {
252         totalSupply = _initialSupply;
253 
254         if (0 < _initialSupply) {
255             balances[msg.sender] = _initialSupply;
256             emit Transfer(address(0), msg.sender, _initialSupply);
257         }
258     }
259 
260     /**
261     * @dev transfer token for a specified address
262     * @param _to The address to transfer to.
263     * @param _value The amount to be transferred.
264     */
265     function transfer(address _to, uint256 _value) public
266         isUsable
267         onlyActive(msg.sender)
268         onlyActive(_to)
269         returns (bool)
270     {
271         require(0 < _value, "BasicToken.transfer: Zero value");
272         require(_value <= balances[msg.sender], "BasicToken.transfer: Insufficient fund");
273 
274         // SafeMath.sub will throw if there is not enough balance.
275         balances[msg.sender] = balances[msg.sender].sub(_value);
276         balances[_to] = balances[_to].add(_value);
277         emit Transfer(msg.sender, _to, _value);
278         return true;
279     }
280 
281     /**
282     * @dev Gets the balance of the specified address.
283     * @param _owner The address to query the the balance of.
284     * @return An uint256 representing the amount owned by the passed address.
285     */
286     function balanceOf(address _owner) public view
287         returns (uint256 balance)
288     {
289         return balances[_owner];
290     }
291 
292 }
293 
294 
295 /**
296  * @title Standard ERC20 token
297  *
298  * @dev Implementation of the basic standard token.
299  * @dev https://github.com/ethereum/EIPs/issues/20
300  */
301 contract StandardToken is ERC20, BasicToken {
302 
303     mapping (address => mapping (address => uint256)) internal allowed;
304 
305     /**
306     * @dev Transfer tokens from one address to another
307     * @param _from address The address which you want to send tokens from
308     * @param _to address The address which you want to transfer to
309     * @param _value uint256 the amount of tokens to be transferred
310     */
311     function transferFrom(address _from, address _to, uint256 _value) public
312         isUsable
313         onlyActive(msg.sender)
314         onlyActive(_from)
315         onlyActive(_to)
316         returns (bool)
317     {
318         require(0 < _value, "StandardToken.transferFrom: Zero value");
319         require(_value <= balances[_from], "StandardToken.transferFrom: Insufficient fund");
320         require(_value <= allowed[_from][msg.sender], "StandardToken.transferFrom: Insufficient allowance");
321 
322         balances[_from] = balances[_from].sub(_value);
323         balances[_to] = balances[_to].add(_value);
324         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
325         emit Transfer(_from, _to, _value);
326         return true;
327     }
328 
329     /**
330     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
331     *
332     * Beware that changing an allowance with this method brings the risk that someone may use both the old
333     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
334     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
335     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
336     * @param _spender The address which will spend the funds.
337     * @param _value The amount of tokens to be spent.
338     */
339     function approve(address _spender, uint256 _value) public
340         isUsable
341         onlyActive(msg.sender)
342         onlyActive(_spender)
343         returns (bool)
344     {
345         require(0 < _value, "StandardToken.approve: Zero value");
346 
347         allowed[msg.sender][_spender] = _value;
348         emit Approval(msg.sender, _spender, _value);
349         return true;
350     }
351 
352     /**
353     * @dev Function to check the amount of tokens that an owner allowed to a spender.
354     * @param _owner address The address which owns the funds.
355     * @param _spender address The address which will spend the funds.
356     * @return A uint256 specifying the amount of tokens still available for the spender.
357     */
358     function allowance(address _owner, address _spender) public view
359         returns (uint256)
360     {
361         return allowed[_owner][_spender];
362     }
363 
364     /**
365     * @dev Increase the amount of tokens that an owner allowed to a spender.
366     *
367     * approve should be called when allowed[_spender] == 0. To increment
368     * allowed value is better to use this function to avoid 2 calls (and wait until
369     * the first transaction is mined)
370     * From MonolithDAO Token.sol
371     * @param _spender The address which will spend the funds.
372     * @param _addedValue The amount of tokens to increase the allowance by.
373     */
374     function increaseApproval(address _spender, uint256 _addedValue) public
375         isUsable
376         onlyActive(msg.sender)
377         onlyActive(_spender)
378         returns (bool)
379     {
380         require(0 < _addedValue, "StandardToken.increaseApproval: Zero value");
381 
382         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
383         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384         return true;
385     }
386 
387     /**
388     * @dev Decrease the amount of tokens that an owner allowed to a spender.
389     *
390     * approve should be called when allowed[_spender] == 0. To decrement
391     * allowed value is better to use this function to avoid 2 calls (and wait until
392     * the first transaction is mined)
393     * From MonolithDAO Token.sol
394     * @param _spender The address which will spend the funds.
395     * @param _subtractedValue The amount of tokens to decrease the allowance by.
396     */
397     function decreaseApproval(address _spender, uint256 _subtractedValue) public
398         isUsable
399         onlyActive(msg.sender)
400         onlyActive(_spender)
401         returns (bool)
402     {
403         require(0 < _subtractedValue, "StandardToken.decreaseApproval: Zero value");
404 
405         uint256 oldValue = allowed[msg.sender][_spender];
406 
407         if (_subtractedValue > oldValue)
408             allowed[msg.sender][_spender] = 0;
409         else
410             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
411 
412         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
413         return true;
414     }
415 
416 }
417 
418 
419 contract ApprovalReceiver {
420     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes memory _extraData) public;
421 }
422 
423 contract MUB is StandardToken {
424     using SafeMathUint256 for uint256;
425 
426     event Freeze(address indexed from, uint256 value);
427     event Unfreeze(address indexed from, uint256 value);
428 
429     string public name;
430     string public symbol;
431     uint8 public decimals;
432 
433     mapping (address => uint256) public freezeOf;
434 
435     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) public
436         BasicToken(_initialSupply)
437     {
438         name = _name;
439         symbol = _symbol;
440         decimals = _decimals;
441     }
442 
443     /**
444     * @dev Freeze holder balance
445     *
446     * @param _from The address which will be freeze
447     * @param _value The amount of tokens to be freeze
448     */
449     function freeze(address _from, uint256 _value) external
450         onlyOwner
451         returns (bool)
452     {
453         require(_value <= balances[_from], "RLACoin.freeze: Insufficient fund");
454 
455         balances[_from] = balances[_from].sub(_value);
456         freezeOf[_from] = freezeOf[_from].add(_value);
457         emit Freeze(_from, _value);
458         return true;
459     }
460 	
461     /**
462     * @dev Unfreeze holder balance
463     *
464     * @param _from The address which will be unfreeze
465     * @param _value The amount of tokens to be unfreeze
466     */
467     function unfreeze(address _from, uint256 _value) external
468         onlyOwner
469         returns (bool)
470     {
471         require(_value <= freezeOf[_from], "RLACoin.unfreeze: Insufficient fund");
472 
473         freezeOf[_from] = freezeOf[_from].sub(_value);
474         balances[_from] = balances[_from].add(_value);
475         emit Unfreeze(_from, _value);
476         return true;
477     }
478 
479     /**
480      * @dev Allocate allowance and perform contract call
481      *
482      * @param _spender The spender address
483      * @param _value The allowance value
484      * @param _extraData The function call data
485      */
486     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) external
487         isUsable
488         returns (bool)
489     {
490         // Give allowance to spender (previous approved allowances will be clear)
491         approve(_spender, _value);
492 
493         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
494         return true;
495     }
496 
497 }