1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     function totalSupply() public view returns (uint256);
10 
11     function balanceOf(address _who) public view returns (uint256);
12 
13     function allowance(address _owner, address _spender)
14         public view returns (uint256);
15 
16     function transfer(address _to, uint256 _value) public returns (bool);
17 
18     function approve(address _spender, uint256 _value)
19         public returns (bool);
20 
21     function transferFrom(address _from, address _to, uint256 _value)
22         public returns (bool);
23 
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 value
28     );
29 
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45 
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     /**
52     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53     * account.
54     */
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     /**
60     * @dev Throws if called by any account other than the owner.
61     */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68     * @dev Allows the current owner to transfer control of the contract to a newOwner.
69     * @param _newOwner The address to transfer ownership to.
70     */
71     function transferOwnership(address _newOwner) public onlyOwner {
72         _transferOwnership(_newOwner);
73     }
74 
75     /**
76     * @dev Transfers control of the contract to a newOwner.
77     * @param _newOwner The address to transfer ownership to.
78     */
79     function _transferOwnership(address _newOwner) internal {
80         require(_newOwner != address(0));
81         emit OwnershipTransferred(owner, _newOwner);
82         owner = _newOwner;
83     }
84 }
85 
86 /**
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  */
90 contract Pausable is Ownable {
91     event Pause();
92     event Unpause();
93 
94     bool public paused = false;
95 
96     /**
97     * @dev Modifier to make a function callable only when the contract is not paused.
98     */
99     modifier whenNotPaused() {
100         require(!paused);
101         _;
102     }
103 
104     /**
105     * @dev Modifier to make a function callable only when the contract is paused.
106     */
107     modifier whenPaused() {
108         require(paused);
109         _;
110     }
111 
112     /**
113     * @dev called by the owner to pause, triggers stopped state
114     */
115     function pause() public onlyOwner whenNotPaused {
116         paused = true;
117         emit Pause();
118     }
119 
120     /**
121     * @dev called by the owner to unpause, returns to normal state
122     */
123     function unpause() public onlyOwner whenPaused {
124         paused = false;
125         emit Unpause();
126     }
127 }
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that revert on error
132  */
133 library SafeMath {
134 
135     /**
136     * @dev Multiplies two numbers, reverts on overflow.
137     */
138     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142         if (_a == 0) {
143             return 0;
144         }
145 
146         uint256 c = _a * _b;
147         require(c / _a == _b);
148 
149         return c;
150     }
151 
152     /**
153     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
154     */
155     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
156         require(_b > 0); // Solidity only automatically asserts when dividing by 0
157         uint256 c = _a / _b;
158         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
165     */
166     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
167         require(_b <= _a);
168         uint256 c = _a - _b;
169 
170         return c;
171     }
172 
173     /**
174     * @dev Adds two numbers, reverts on overflow.
175     */
176     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
177         uint256 c = _a + _b;
178         require(c >= _a);
179 
180         return c;
181     }
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * https://github.com/ethereum/EIPs/issues/20
189  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20,Pausable {
192     using SafeMath for uint256;
193 
194     mapping(address => uint256) balances;
195 
196     mapping (address => mapping (address => uint256)) internal allowed;
197 
198     uint256 totalSupply_;
199 
200     /**
201     * @dev Total number of tokens in existence
202     */
203     function totalSupply() public view returns (uint256) {
204         return totalSupply_;
205     }
206 
207     /**
208     * @dev Gets the balance of the specified address.
209     * @param _owner The address to query the the balance of.
210     * @return An uint256 representing the amount owned by the passed address.
211     */
212     function balanceOf(address _owner) public view returns (uint256) {
213         return balances[_owner];
214     }
215 
216     /**
217     * @dev Function to check the amount of tokens that an owner allowed to a spender.
218     * @param _owner address The address which owns the funds.
219     * @param _spender address The address which will spend the funds.
220     * @return A uint256 specifying the amount of tokens still available for the spender.
221     */
222     function allowance(
223         address _owner,
224         address _spender
225     )
226         public
227         view
228         returns (uint256)
229     {
230         return allowed[_owner][_spender];
231     }
232 
233     /**
234     * @dev Transfer token for a specified address
235     * @param _to The address to transfer to.
236     * @param _value The amount to be transferred.
237     */
238     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
239         require(_value <= balances[msg.sender]);
240         require(_to != address(0));
241 
242         balances[msg.sender] = balances[msg.sender].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244         emit Transfer(msg.sender, _to, _value);
245         return true;
246     }
247 
248     /**
249     * @dev Transfer tokens from one address to another
250     * @param _from address The address which you want to send tokens from
251     * @param _to address The address which you want to transfer to
252     * @param _value uint256 the amount of tokens to be transferred
253     */
254     function transferFrom(
255         address _from,
256         address _to,
257         uint256 _value
258     )   
259         whenNotPaused
260         public
261         returns (bool)
262     {
263         require(_value <= balances[_from]);
264         require(_value <= allowed[_from][msg.sender]);
265         require(_to != address(0));
266 
267         balances[_from] = balances[_from].sub(_value);
268         balances[_to] = balances[_to].add(_value);
269         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
270         emit Transfer(_from, _to, _value);
271         return true;
272     }
273 
274     /**
275     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
276     * Beware that changing an allowance with this method brings the risk that someone may use both the old
277     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280     * @param _spender The address which will spend the funds.
281     * @param _value The amount of tokens to be spent.
282     */
283     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
284         require(_value == 0 || (allowed[msg.sender][_spender] == 0));
285         
286         allowed[msg.sender][_spender] = _value;
287         emit Approval(msg.sender, _spender, _value);
288         return true;
289     }
290 
291     /**
292     * @dev Increase the amount of tokens that an owner allowed to a spender.
293     * approve should be called when allowed[_spender] == 0. To increment
294     * allowed value is better to use this function to avoid 2 calls (and wait until
295     * the first transaction is mined)
296     * From MonolithDAO Token.sol
297     * @param _spender The address which will spend the funds.
298     * @param _addedValue The amount of tokens to increase the allowance by.
299     */
300     function increaseApproval(
301         address _spender,
302         uint256 _addedValue
303     )   
304         whenNotPaused
305         public
306         returns (bool)
307     {
308         allowed[msg.sender][_spender] = (
309         allowed[msg.sender][_spender].add(_addedValue));
310         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311         return true;
312     }
313 
314     /**
315     * @dev Decrease the amount of tokens that an owner allowed to a spender.
316     * approve should be called when allowed[_spender] == 0. To decrement
317     * allowed value is better to use this function to avoid 2 calls (and wait until
318     * the first transaction is mined)
319     * From MonolithDAO Token.sol
320     * @param _spender The address which will spend the funds.
321     * @param _subtractedValue The amount of tokens to decrease the allowance by.
322     */
323     function decreaseApproval(
324         address _spender,
325         uint256 _subtractedValue
326     )
327         whenNotPaused
328         public
329         returns (bool)
330     {
331         uint256 oldValue = allowed[msg.sender][_spender];
332         if (_subtractedValue >= oldValue) {
333             allowed[msg.sender][_spender] = 0;
334         } else {
335             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
336         }
337         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
338         return true;
339     }
340 }
341 
342 /**
343  * @title SafeERC20
344  * @dev Wrappers around ERC20 operations that throw on failure.
345  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
346  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
347  */
348 library SafeERC20 {
349     function safeTransfer(
350         ERC20 _token,
351         address _to,
352         uint256 _value
353     )
354       internal
355     {
356         require(_token.transfer(_to, _value));
357     }
358 
359     function safeTransferFrom(
360         ERC20 _token,
361         address _from,
362         address _to,
363         uint256 _value
364     )
365       internal
366     {
367         require(_token.transferFrom(_from, _to, _value));
368     }
369 
370     function safeApprove(
371         ERC20 _token,
372         address _spender,
373         uint256 _value
374     )
375       internal
376     {
377         require(_token.approve(_spender, _value));
378     }
379 }
380 
381 /**
382  * @title TokenVesting
383  * @dev A token holder contract that can release its token balance gradually like a
384  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
385  * owner.
386  */
387 contract TokenVesting is Ownable {
388     using SafeMath for uint256;
389     using SafeERC20 for ERC20;
390 
391     event Released(uint256 amount);
392     event Revoked();
393 
394     // beneficiary of tokens after they are released
395     address public beneficiary;
396 
397     uint256 public cliff;
398     uint256 public start;
399     uint256 public duration;
400     uint256 public phased;
401 
402     bool public revocable;
403 
404     mapping (address => uint256) public released;
405     mapping (address => bool) public revoked;
406 
407     /**
408     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
409     * _beneficiary, gradually in a phased fashion until _start + _duration. By then all
410     * of the balance will have vested.
411     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
412     * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
413     * @param _start the time (as Unix time) at which point vesting starts
414     * @param _duration duration in seconds of the period in which the tokens will vest
415     * @param _phased duration in seconds of the every release stage
416     * @param _revocable whether the vesting is revocable or not
417     */
418     constructor(
419         address _beneficiary,
420         uint256 _start,
421         uint256 _cliff,
422         uint256 _duration,
423         uint256 _phased,
424         bool _revocable
425     )
426         public
427     {
428         require(_beneficiary != address(0));
429         require(_cliff <= _duration);
430         require(_phased <= _duration.sub(_cliff));
431 
432         beneficiary = _beneficiary;
433         revocable = _revocable;
434         duration = _duration;
435         cliff = _start.add(_cliff);
436         start = _start;
437         phased = _phased;
438     }
439 
440     /**
441     * @notice Transfers vested tokens to beneficiary.
442     * @param _token ERC20 token which is being vested
443     */
444     function release(ERC20 _token) public {
445         uint256 unreleased = releasableAmount(_token);
446 
447         require(unreleased > 0);
448 
449         released[_token] = released[_token].add(unreleased);
450 
451         _token.safeTransfer(beneficiary, unreleased);
452 
453         emit Released(unreleased);
454     }
455 
456     /**
457     * @notice Allows the owner to revoke the vesting. Tokens already vested
458     * remain in the contract, the rest are returned to the owner.
459     * @param _token ERC20 token which is being vested
460     */
461     function revoke(ERC20 _token) public onlyOwner {
462         require(revocable);
463         require(!revoked[_token]);
464 
465         uint256 balance = _token.balanceOf(address(this));
466 
467         uint256 unreleased = releasableAmount(_token);
468         uint256 refund = balance.sub(unreleased);
469 
470         revoked[_token] = true;
471 
472         _token.safeTransfer(owner, refund);
473 
474         emit Revoked();
475     }
476 
477     /**
478     * @dev Calculates the amount that has already vested but hasn't been released yet.
479     * @param _token ERC20 token which is being vested
480     */
481     function releasableAmount(ERC20 _token) public view returns (uint256) {
482         return vestedAmount(_token).sub(released[_token]);
483     }
484 
485     /**
486     * @dev Calculates the amount that has already vested.
487     * @param _token ERC20 token which is being vested
488     */
489     function vestedAmount(ERC20 _token) public view returns (uint256) {
490         uint256 currentBalance = _token.balanceOf(this);
491         uint256 totalBalance = currentBalance.add(released[_token]);
492 
493         uint256 totalPhased = (start.add(duration).sub(cliff)).div(phased);
494         uint256 everyPhasedReleaseAmount = totalBalance.div(totalPhased);
495 
496         if (block.timestamp < cliff.add(phased)) {
497             return 0;
498         } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
499             return totalBalance;
500         } else {
501             uint256 currentPhased = block.timestamp.sub(cliff).div(phased);
502             return everyPhasedReleaseAmount.mul(currentPhased);
503         }
504     }
505 }