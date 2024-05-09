1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61     function totalSupply() public view returns (uint256);
62 
63     function balanceOf(address who) public view returns (uint256);
64 
65     function transfer(address to, uint256 value) public returns (bool);
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76     using SafeMath for uint256;
77 
78     mapping(address => uint256) balances;
79 
80     uint256 totalSupply_;
81 
82     /**
83     * @dev Total number of tokens in existence
84     */
85     function totalSupply() public view returns (uint256) {
86         return totalSupply_;
87     }
88 
89     /**
90     * @dev Transfer token for a specified address
91     * @param _to The address to transfer to.
92     * @param _value The amount to be transferred.
93     */
94     function transfer(address _to, uint256 _value) public returns (bool) {
95         require(_to != address(0));
96         require(_value <= balances[msg.sender]);
97 
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         emit Transfer(msg.sender, _to, _value);
101         return true;
102     }
103 
104     /**
105     * @dev Gets the balance of the specified address.
106     * @param _owner The address to query the the balance of.
107     * @return An uint256 representing the amount owned by the passed address.
108     */
109     function balanceOf(address _owner) public view returns (uint256) {
110         return balances[_owner];
111     }
112 
113 }
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121     function allowance(address owner, address spender)
122     public view returns (uint256);
123 
124     function transferFrom(address from, address to, uint256 value)
125     public returns (bool);
126 
127     function approve(address spender, uint256 value) public returns (bool);
128 
129     event Approval(
130         address indexed owner,
131         address indexed spender,
132         uint256 value
133     );
134 }
135 
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146     mapping(address => mapping(address => uint256)) internal allowed;
147 
148 
149     /**
150      * @dev Transfer tokens from one address to another
151      * @param _from address The address which you want to send tokens from
152      * @param _to address The address which you want to transfer to
153      * @param _value uint256 the amount of tokens to be transferred
154      */
155     function transferFrom(
156         address _from,
157         address _to,
158         uint256 _value
159     )
160     public
161     returns (bool)
162     {
163         require(_to != address(0));
164         require(_value <= balances[_from]);
165         require(_value <= allowed[_from][msg.sender]);
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     /**
175      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176      *
177      * Beware that changing an allowance with this method brings the risk that someone may use both the old
178      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      * @param _spender The address which will spend the funds.
182      * @param _value The amount of tokens to be spent.
183      */
184     function approve(address _spender, uint256 _value) public returns (bool) {
185         require(_spender != address(0));
186         allowed[msg.sender][_spender] = _value;
187         emit Approval(msg.sender, _spender, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Function to check the amount of tokens that an owner allowed to a spender.
193      * @param _owner address The address which owns the funds.
194      * @param _spender address The address which will spend the funds.
195      * @return A uint256 specifying the amount of tokens still available for the spender.
196      */
197     function allowance(
198         address _owner,
199         address _spender
200     )
201     public
202     view
203     returns (uint256)
204     {
205         return allowed[_owner][_spender];
206     }
207 
208     /**
209      * @dev Increase the amount of tokens that an owner allowed to a spender.
210      *
211      * approve should be called when allowed[_spender] == 0. To increment
212      * allowed value is better to use this function to avoid 2 calls (and wait until
213      * the first transaction is mined)
214      * @param _spender The address which will spend the funds.
215      * @param _addedValue The amount of tokens to increase the allowance by.
216      */
217     function increaseApproval(
218         address _spender,
219         uint _addedValue
220     )
221     public
222     returns (bool)
223     {
224         require(_spender != address(0));
225         allowed[msg.sender][_spender] = (
226         allowed[msg.sender][_spender].add(_addedValue));
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the amount of tokens that an owner allowed to a spender.
233      *
234      * approve should be called when allowed[_spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * @param _spender The address which will spend the funds.
238      * @param _subtractedValue The amount of tokens to decrease the allowance by.
239      */
240     function decreaseApproval(
241         address _spender,
242         uint _subtractedValue
243     )
244     public
245     returns (bool)
246     {
247         require(_spender != address(0));
248         uint oldValue = allowed[msg.sender][_spender];
249         if (_subtractedValue > oldValue) {
250             allowed[msg.sender][_spender] = 0;
251         } else {
252             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253         }
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258 }
259 
260 
261 /**
262  * @title Ownable
263  * @dev The Ownable contract has an owner address, and provides basic authorization control
264  * functions, this simplifies the implementation of "user permissions".
265  */
266 contract Ownable {
267     address public owner;
268 
269 
270     event OwnershipRenounced(address indexed previousOwner);
271     event OwnershipTransferred(
272         address indexed previousOwner,
273         address indexed newOwner
274     );
275 
276 
277     /**
278      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
279      * account.
280      */
281     constructor() public {
282         owner = msg.sender;
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         require(msg.sender == owner);
290         _;
291     }
292 
293     /**
294      * @dev Allows the current owner to relinquish control of the contract.
295      * @notice Renouncing to ownership will leave the contract without an owner.
296      * It will not be possible to call the functions with the `onlyOwner`
297      * modifier anymore.
298      */
299     function renounceOwnership() public onlyOwner {
300         emit OwnershipRenounced(owner);
301         owner = address(0);
302     }
303 
304     /**
305      * @dev Allows the current owner to transfer control of the contract to a newOwner.
306      * @param _newOwner The address to transfer ownership to.
307      */
308     function transferOwnership(address _newOwner) public onlyOwner {
309         _transferOwnership(_newOwner);
310     }
311 
312     /**
313      * @dev Transfers control of the contract to a newOwner.
314      * @param _newOwner The address to transfer ownership to.
315      */
316     function _transferOwnership(address _newOwner) internal {
317         require(_newOwner != address(0));
318         emit OwnershipTransferred(owner, _newOwner);
319         owner = _newOwner;
320     }
321 }
322 
323 
324 /**
325  * @title Pausable
326  * @dev Base contract which allows children to implement an emergency stop mechanism.
327  */
328 contract Pausable is Ownable {
329     event Pause();
330     event Unpause();
331 
332     bool public paused = false;
333 
334 
335     /**
336      * @dev Modifier to make a function callable only when the contract is not paused.
337      */
338     modifier whenNotPaused() {
339         require(!paused);
340         _;
341     }
342 
343     /**
344      * @dev Modifier to make a function callable only when the contract is paused.
345      */
346     modifier whenPaused() {
347         require(paused);
348         _;
349     }
350 
351     /**
352      * @dev called by the owner to pause, triggers stopped state
353      */
354     function pause() onlyOwner whenNotPaused public {
355         paused = true;
356         emit Pause();
357     }
358 
359     /**
360      * @dev called by the owner to unpause, returns to normal state
361      */
362     function unpause() onlyOwner whenPaused public {
363         paused = false;
364         emit Unpause();
365     }
366 }
367 
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375     function transfer(
376         address _to,
377         uint256 _value
378     )
379     public
380     whenNotPaused
381     returns (bool)
382     {
383         return super.transfer(_to, _value);
384     }
385 
386     function transferFrom(
387         address _from,
388         address _to,
389         uint256 _value
390     )
391     public
392     whenNotPaused
393     returns (bool)
394     {
395         return super.transferFrom(_from, _to, _value);
396     }
397 
398     function approve(
399         address _spender,
400         uint256 _value
401     )
402     public
403     whenNotPaused
404     returns (bool)
405     {
406         return super.approve(_spender, _value);
407     }
408 
409     function increaseApproval(
410         address _spender,
411         uint _addedValue
412     )
413     public
414     whenNotPaused
415     returns (bool success)
416     {
417         return super.increaseApproval(_spender, _addedValue);
418     }
419 
420     function decreaseApproval(
421         address _spender,
422         uint _subtractedValue
423     )
424     public
425     whenNotPaused
426     returns (bool success)
427     {
428         return super.decreaseApproval(_spender, _subtractedValue);
429     }
430 }
431 
432 
433 /**
434  * @title Burnable Token
435  * @dev Token that can be irreversibly burned (destroyed).
436  */
437 contract BurnableToken is BasicToken {
438 
439     event Burn(address indexed burner, uint256 value);
440 
441     /**
442      * @dev Burns a specific amount of tokens.
443      * @param _value The amount of token to be burned.
444      */
445     function burn(uint256 _value) public {
446         _burn(msg.sender, _value);
447     }
448 
449     function _burn(address _who, uint256 _value) internal {
450         require(_value <= balances[_who]);
451         // no need to require value <= totalSupply, since that would imply the
452         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
453 
454         balances[_who] = balances[_who].sub(_value);
455         totalSupply_ = totalSupply_.sub(_value);
456         emit Burn(_who, _value);
457         emit Transfer(_who, address(0), _value);
458     }
459 }
460 
461 
462 contract TecoToken is StandardToken, PausableToken, BurnableToken {
463     using SafeMath for uint256;
464 
465     string public name = "TECO";
466     string public symbol = "TECO";
467     uint8 public decimals = 18;
468 
469     uint256 public INITIAL_SUPPLY = 100000000 * (10 ** uint256(18));
470 
471     constructor() public {
472         totalSupply_ = INITIAL_SUPPLY;
473         balances[msg.sender] = INITIAL_SUPPLY;
474         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
475     }
476 }