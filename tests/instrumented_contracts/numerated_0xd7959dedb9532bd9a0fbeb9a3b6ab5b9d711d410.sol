1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27     address public owner;
28 
29 
30     event OwnershipRenounced(address indexed previousOwner);
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36 
37     /**
38      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39      * account.
40      */
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     /**
54      * @dev Allows the current owner to relinquish control of the contract.
55      * @notice Renouncing to ownership will leave the contract without an owner.
56      * It will not be possible to call the functions with the `onlyOwner`
57      * modifier anymore.
58      */
59     function renounceOwnership() public onlyOwner {
60         emit OwnershipRenounced(owner);
61         owner = address(0);
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param _newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address _newOwner) public onlyOwner {
69         _transferOwnership(_newOwner);
70     }
71 
72     /**
73      * @dev Transfers control of the contract to a newOwner.
74      * @param _newOwner The address to transfer ownership to.
75      */
76     function _transferOwnership(address _newOwner) internal {
77         require(_newOwner != address(0));
78         emit OwnershipTransferred(owner, _newOwner);
79         owner = _newOwner;
80     }
81 }
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100 
101     /**
102     * @dev Multiplies two numbers, throws on overflow.
103     */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
105         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         c = a * b;
113         assert(c / a == b);
114         return c;
115     }
116 
117     /**
118     * @dev Integer division of two numbers, truncating the quotient.
119     */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // assert(b > 0); // Solidity automatically throws when dividing by 0
122         // uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124         return a / b;
125     }
126 
127     /**
128     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
129     */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         assert(b <= a);
132         return a - b;
133     }
134 
135     /**
136     * @dev Adds two numbers, throws on overflow.
137     */
138     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
139         c = a + b;
140         assert(c >= a);
141         return c;
142     }
143 }
144 
145 
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152     using SafeMath for uint256;
153 
154     mapping(address => uint256) balances;
155 
156     uint256 totalSupply_;
157 
158     /**
159     * @dev Total number of tokens in existence
160     */
161     function totalSupply() public view returns (uint256) {
162         return totalSupply_;
163     }
164 
165     /**
166     * @dev Transfer token for a specified address
167     * @param _to The address to transfer to.
168     * @param _value The amount to be transferred.
169     */
170     function transfer(address _to, uint256 _value) public returns (bool) {
171         require(_to != address(0));
172         require(_value <= balances[msg.sender]);
173 
174         balances[msg.sender] = balances[msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         emit Transfer(msg.sender, _to, _value);
177         return true;
178     }
179 
180     /**
181     * @dev Gets the balance of the specified address.
182     * @param _owner The address to query the the balance of.
183     * @return An uint256 representing the amount owned by the passed address.
184     */
185     function balanceOf(address _owner) public view returns (uint256) {
186         return balances[_owner];
187     }
188 
189 }
190 
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197     function allowance(address owner, address spender)
198     public view returns (uint256);
199 
200     function transferFrom(address from, address to, uint256 value)
201     public returns (bool);
202 
203     function approve(address spender, uint256 value) public returns (bool);
204 
205     event Approval(
206         address indexed owner,
207         address indexed spender,
208         uint256 value
209     );
210 }
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * https://github.com/ethereum/EIPs/issues/20
217  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221     mapping(address => mapping(address => uint256)) internal allowed;
222 
223 
224     /**
225      * @dev Transfer tokens from one address to another
226      * @param _from address The address which you want to send tokens from
227      * @param _to address The address which you want to transfer to
228      * @param _value uint256 the amount of tokens to be transferred
229      */
230     function transferFrom(
231         address _from,
232         address _to,
233         uint256 _value
234     )
235     public
236     returns (bool)
237     {
238         require(_to != address(0));
239         require(_value <= balances[_from]);
240         require(_value <= allowed[_from][msg.sender]);
241 
242         balances[_from] = balances[_from].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245         emit Transfer(_from, _to, _value);
246         return true;
247     }
248 
249     /**
250      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251      * Beware that changing an allowance with this method brings the risk that someone may use both the old
252      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      * @param _spender The address which will spend the funds.
256      * @param _value The amount of tokens to be spent.
257      */
258     function approve(address _spender, uint256 _value) public returns (bool) {
259         allowed[msg.sender][_spender] = _value;
260         emit Approval(msg.sender, _spender, _value);
261         return true;
262     }
263 
264     /**
265      * @dev Function to check the amount of tokens that an owner allowed to a spender.
266      * @param _owner address The address which owns the funds.
267      * @param _spender address The address which will spend the funds.
268      * @return A uint256 specifying the amount of tokens still available for the spender.
269      */
270     function allowance(
271         address _owner,
272         address _spender
273     )
274     public
275     view
276     returns (uint256)
277     {
278         return allowed[_owner][_spender];
279     }
280 
281     /**
282      * @dev Increase the amount of tokens that an owner allowed to a spender.
283      * approve should be called when allowed[_spender] == 0. To increment
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * @param _spender The address which will spend the funds.
288      * @param _addedValue The amount of tokens to increase the allowance by.
289      */
290     function increaseApproval(
291         address _spender,
292         uint256 _addedValue
293     )
294     public
295     returns (bool)
296     {
297         allowed[msg.sender][_spender] = (
298         allowed[msg.sender][_spender].add(_addedValue));
299         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300         return true;
301     }
302 
303     /**
304      * @dev Decrease the amount of tokens that an owner allowed to a spender.
305      * approve should be called when allowed[_spender] == 0. To decrement
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * @param _spender The address which will spend the funds.
310      * @param _subtractedValue The amount of tokens to decrease the allowance by.
311      */
312     function decreaseApproval(
313         address _spender,
314         uint256 _subtractedValue
315     )
316     public
317     returns (bool)
318     {
319         uint256 oldValue = allowed[msg.sender][_spender];
320         if (_subtractedValue > oldValue) {
321             allowed[msg.sender][_spender] = 0;
322         } else {
323             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324         }
325         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326         return true;
327     }
328 
329 }
330 
331 
332 
333 
334 
335 
336 
337 /**
338  * @title Pausable
339  * @dev Base contract which allows children to implement an emergency stop mechanism.
340  */
341 contract Pausable is Ownable {
342     event Pause();
343     event Unpause();
344 
345     bool public paused = false;
346 
347 
348     /**
349      * @dev Modifier to make a function callable only when the contract is not paused.
350      */
351     modifier whenNotPaused() {
352         require(!paused);
353         _;
354     }
355 
356     /**
357      * @dev Modifier to make a function callable only when the contract is paused.
358      */
359     modifier whenPaused() {
360         require(paused);
361         _;
362     }
363 
364     /**
365      * @dev called by the owner to pause, triggers stopped state
366      */
367     function pause() onlyOwner whenNotPaused public {
368         paused = true;
369         emit Pause();
370     }
371 
372     /**
373      * @dev called by the owner to unpause, returns to normal state
374      */
375     function unpause() onlyOwner whenPaused public {
376         paused = false;
377         emit Unpause();
378     }
379 }
380 
381 
382 
383 /**
384  * @title Pausable token
385  * @dev StandardToken modified with pausable transfers.
386  **/
387 contract PausableToken is StandardToken, Pausable {
388 
389     function transfer(
390         address _to,
391         uint256 _value
392     )
393     public
394     whenNotPaused
395     returns (bool)
396     {
397         return super.transfer(_to, _value);
398     }
399 
400     function transferFrom(
401         address _from,
402         address _to,
403         uint256 _value
404     )
405     public
406     whenNotPaused
407     returns (bool)
408     {
409         return super.transferFrom(_from, _to, _value);
410     }
411 
412     function approve(
413         address _spender,
414         uint256 _value
415     )
416     public
417     whenNotPaused
418     returns (bool)
419     {
420         return super.approve(_spender, _value);
421     }
422 
423     function increaseApproval(
424         address _spender,
425         uint _addedValue
426     )
427     public
428     whenNotPaused
429     returns (bool success)
430     {
431         return super.increaseApproval(_spender, _addedValue);
432     }
433 
434     function decreaseApproval(
435         address _spender,
436         uint _subtractedValue
437     )
438     public
439     whenNotPaused
440     returns (bool success)
441     {
442         return super.decreaseApproval(_spender, _subtractedValue);
443     }
444 }
445 
446 
447 
448 /**
449  * @title DetailedERC20 token
450  * @dev The decimals are only for visualization purposes.
451  * All the operations are done using the smallest and indivisible token unit,
452  * just as on Ethereum all the operations are done in wei.
453  */
454 contract DetailedERC20 is ERC20 {
455     string public name;
456     string public symbol;
457     uint8 public decimals;
458 
459     constructor(string _name, string _symbol, uint8 _decimals) public {
460         name = _name;
461         symbol = _symbol;
462         decimals = _decimals;
463     }
464 }
465 
466 
467 contract GemstoneChain is PausableToken, DetailedERC20
468 {
469     constructor() DetailedERC20("Gemstone Chain", "GESC", 18) public
470     {
471         totalSupply_ = 2000000000 * 10 ** 18;
472         balances[msg.sender] = totalSupply();
473     }
474 }