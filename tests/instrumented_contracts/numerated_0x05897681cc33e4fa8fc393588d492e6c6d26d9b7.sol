1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6         if (_a == 0) {
7             return 0;
8         }
9         uint256 c = _a * _b;
10         require(c / _a == _b);
11         return c;
12     }
13     
14     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         // require(_b > 0); // Solidity autom
16         uint256 c = _a / _b;
17         // require(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
18         return c;
19     }
20     /**
21     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
22     */
23     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24         require(_b <= _a);
25         uint256 c = _a - _b;
26         return c;
27     }
28     /**
29     * @dev Adds two numbers, throws on overflow.
30     */
31     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         uint256 c = _a + _b;
33         require(c >= _a);
34         return c;
35     }
36 }
37 
38 contract Ownable {
39     address public owner;
40     event OwnershipRenounced(address indexed previousOwner);
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45     /**
46     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47     * account.
48     */
49     constructor() public {
50         owner = msg.sender;
51     }
52     /**
53     * @dev Throws if called by any account other than the owner.
54     */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59     /**
60     * @dev Allows the current owner to relinquish control of the contract.
61     * @notice Renouncing to ownership will leave the contract without an owner.
62     * It will not be possible to call the functions with the `onlyOwner`
63     * modifier anymore.
64     */
65     function renounceOwnership() public onlyOwner {
66 emit OwnershipRenounced(owner);
67 owner = address(0);
68     }
69     /**
70     * @dev Allows the current owner to transfer control of the contract to a newOwner.
71     * @param _newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address _newOwner) public onlyOwner {
74         _transferOwnership(_newOwner);
75     }
76     /**
77     * @dev Transfers control of the contract to a newOwner.
78     * @param _newOwner The address to transfer ownership to.
79     */
80     function _transferOwnership(address _newOwner) internal {
81         require(_newOwner != address(0)); 
82         emit OwnershipTransferred(owner, _newOwner);
83         owner = _newOwner;
84     }
85 }
86 /**
87 * @title Pausable
88 * @dev Base contract which allows children to implement an emergency stop mechanism.
89 */
90 
91 contract Pausable is Ownable {
92     event Pause();
93     event Unpause();
94     bool public paused = false;
95     /**
96     * @dev Modifier to make a function callable only when the contract is not paused.
97     */
98     modifier whenNotPaused() {
99 require(!paused);
100         _;
101     }
102     /**
103     * @dev Modifier to make a function callable only when the contract is paused.
104     */
105     modifier whenPaused() {
106         require(paused);
107         _;
108     }
109     /**
110     * @dev called by the owner to pause, triggers stopped state
111     */
112     function pause() public onlyOwner whenNotPaused {
113         paused = true;
114         emit Pause();
115     }
116     /**
117     * @dev called by the owner to unpause, returns to normal state
118     */
119     function unpause() public onlyOwner whenPaused {
120         paused = false;
121         emit Unpause();
122     }
123 }
124 /**
125 * @title ERC20 interface
126 * @dev see https://github.com/ethereum/EIPs/issues/20
127 */
128 contract ERC20 {
129     function totalSupply() public view returns (uint256);
130     function balanceOf(address _who) public view returns (uint256);
131     function allowance(address _owner, address _spender)
132     public view returns (uint256);
133     function transfer(address _to, uint256 _value) public returns (bool);
134     function approve(address _spender, uint256 _value)
135     public returns (bool);
136     function transferFrom(address _from, address _to, uint256 _value)
137     public returns (bool);
138     event Transfer(
139         address indexed from,
140         address indexed to,
141         uint256 value
142     );
143     event Approval(
144         address indexed owner,
145         address indexed spender,
146         uint256 value
147     );
148 }
149 /**
150 * @title Standard ERC20 token
151 *
152 * @dev Implementation of the basic standard token.
153 * https://github.com/ethereum/EIPs/issues/20
154 * Based on code by FirstBlood:
155 https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156 */
157 contract StandardToken is ERC20 {
158     using SafeMath for uint256;
159     mapping(address => uint256) balances;
160     mapping (address => mapping (address => uint256)) internal allowed;
161     uint256 totalSupply_;
162     /**
163     * @dev Total number of tokens in existence
164     */
165     function totalSupply() public view returns (uint256) {
166 return totalSupply_;
167     }
168     /**
169     * @dev Gets the balance of the specified address.
170     * @param _owner The address to query the the balance of.
171     * @return An uint256 representing the amount owned by the passed address.
172     */
173     function balanceOf(address _owner) public view returns (uint256) {
174         return balances[_owner];
175     }
176     /**
177     * @dev Function to check the amount of tokens that an owner allowed to a spender.
178     * @param _owner address The address which owns the funds.
179     * @param _spender address The address which will spend the funds.
180     * @return A uint256 specifying the amount of tokens still available for the spender.
181     */
182     function allowance(
183         address _owner,
184         address _spender
185     )
186     public
187     view
188     returns (uint256)
189     {
190         return allowed[_owner][_spender];
191     }
192     /**
193     * @dev Transfer token for a specified address
194     * @param _to The address to transfer to.
195     * @param _value The amount to be transferred.
196     */
197     function transfer(address _to, uint256 _value) public returns (bool) {
198 require(_value <= balances[msg.sender]);
199 require(_to != address(0)); 
200 balances[msg.sender] = balances[msg.sender].sub(_value);
201 balances[_to] = balances[_to].add(_value);
202 emit Transfer(msg.sender, _to, _value);
203         return true; 
204     }
205     /**
206     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207     * Beware that changing an allowance with this method brings the risk that someone may use both the old
208     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211     * @param _spender The address which will spend the funds.
212     * @param _value The amount of tokens to be spent.
213     */
214     function approve(address _spender, uint256 _value) public returns (bool) {
215         allowed[msg.sender][_spender] = _value;
216         emit Approval(msg.sender, _spender, _value);
217         return true; 
218     }
219     /**
220     * @dev Transfer tokens from one address to another
221     * @param _from address The address which you want to send tokens from
222     * @param _to address The address which you want to transfer to
223     * @param _value uint256 the amount of tokens to be transferred
224     */
225     function transferFrom(
226         address _from,
227         address _to,
228         uint256 _value
229     )
230     public
231     returns (bool)
232 {
233 require(_value <= balances[_from]);
234 require(_value <= allowed[_from][msg.sender]);
235 require(_to != address(0)); 
236 balances[_from] = balances[_from].sub(_value);
237 balances[_to] = balances[_to].add(_value);
238 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     emit Transfer(_from, _to, _value);
240     return true; 
241 }
242     /**
243     * @dev Increase the amount of tokens that an owner allowed to a spender.
244     * approve should be called when allowed[_spender] == 0. To increment
245     * allowed value is better to use this function to avoid 2 calls (and wait until
246     * the first transaction is mined)
247     * From MonolithDAO Token.sol
248     * @param _spender The address which will spend the funds.
249     * @param _addedValue The amount of tokens to increase the allowance by.
250     */
251     function increaseApproval(
252         address _spender,
253         uint256 _addedValue
254     )
255     public
256     returns (bool)
257     {
258         allowed[msg.sender][_spender] = (
259         allowed[msg.sender][_spender].add(_addedValue));
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263     /**
264     * @dev Decrease the amount of tokens that an owner allowed to a spender.
265     * approve should be called when allowed[_spender] == 0. To decrement
266     * allowed value is better to use this function to avoid 2 calls (and wait until
267     * the first transaction is mined)
268     * From MonolithDAO Token.sol
269     * @param _spender The address which will spend the funds.
270     * @param _subtractedValue The amount of tokens to decrease the allowance by.
271     */
272     function decreaseApproval(
273         address _spender,
274         uint256 _subtractedValue
275     )
276     public
277     returns (bool)
278     {
279         uint256 oldValue = allowed[msg.sender][_spender];
280         if (_subtractedValue >= oldValue) {
281             allowed[msg.sender][_spender] = 0;
282         } else {
283             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284         }
285         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286         return true;
287     }
288 }
289 /**
290 * @title Pausable token
291 * @dev StandardToken modified with pausable transfers.
292 **/
293 contract PausableERC20Token is StandardToken, Pausable {
294     function transfer(
295         address _to,
296         uint256 _value
297     )
298     public
299     whenNotPaused
300     returns (bool)
301     {
302         return super.transfer(_to, _value);
303     }
304     function transferFrom(
305         address _from,
306         address _to,
307         uint256 _value
308     )
309     public
310     whenNotPaused
311     returns (bool)
312     {
313         return super.transferFrom(_from, _to, _value);
314     }
315     function approve(
316         address _spender,
317         uint256 _value
318     )
319     public
320     whenNotPaused
321     returns (bool)
322     {
323         return super.approve(_spender, _value);
324     }
325     function increaseApproval(
326         address _spender,
327         uint _addedValue
328     )
329     public
330     whenNotPaused
331     returns (bool success)
332     {
333         return super.increaseApproval(_spender, _addedValue);
334     }
335     function decreaseApproval(
336         address _spender,
337         uint _subtractedValue
338     )
339     public
340     whenNotPaused
341     returns (bool success)
342     {
343         return super.decreaseApproval(_spender, _subtractedValue);
344     }
345 }
346 /**
347 * @title Burnable Pausable Token
348 * @dev Pausable Token that can be irreversibly burned (destroyed).
349 */
350 contract BurnablePausableERC20Token is PausableERC20Token {
351     mapping (address => mapping (address => uint256)) internal allowedBurn;
352     event Burn(address indexed burner, uint256 value);
353     event ApprovalBurn(
354         address indexed owner,
355         address indexed spender,
356         uint256 value
357     );
358     function allowanceBurn(
359         address _owner,
360         address _spender
361     )
362     public
363     view
364     returns (uint256)
365     {
366         return allowedBurn[_owner][_spender];
367     }
368     function approveBurn(address _spender, uint256 _value)
369     public
370     whenNotPaused
371     returns (bool)
372     {
373         allowedBurn[msg.sender][_spender] = _value;
374         emit ApprovalBurn(msg.sender, _spender, _value);
375         return true;
376     }
377     /**
378     * @dev Burns a specific amount of tokens.
379     * @param _value The amount of token to be burned.
380     */
381     function burn(
382         uint256 _value
383     )
384     public
385     whenNotPaused
386 {
387 _burn(msg.sender, _value);
388 }
389     /**
390     * @dev Burns a specific amount of tokens from the target address and decrements allowance
391     * @param _from address The address which you want to send tokens from
392     * @param _value uint256 The amount of token to be burned
393     */
394     function burnFrom(
395         address _from,
396         uint256 _value
397     )
398     public
399     whenNotPaused
400     {
401         require(_value <= allowedBurn[_from][msg.sender]);
402         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
403         // this function needs to emit an event with the updated approval.
404         allowedBurn[_from][msg.sender] = allowedBurn[_from][msg.sender].sub(_value);
405         _burn(_from, _value);
406     }
407     function _burn(
408         address _who,
409         uint256 _value
410     )
411     internal
412     whenNotPaused
413     {
414         require(_value <= balances[_who]);
415         // no need to require value <= totalSupply, since that would imply the
416         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
417         balances[_who] = balances[_who].sub(_value);
418         totalSupply_ = totalSupply_.sub(_value);
419         emit Burn(_who, _value);
420         emit Transfer(_who, address(0), _value);
421     }
422     function increaseBurnApproval(
423         address _spender,
424         uint256 _addedValue
425     )
426     public
427     whenNotPaused
428     returns (bool)
429     {
430         allowedBurn[msg.sender][_spender] = (
431         allowedBurn[msg.sender][_spender].add(_addedValue));
432         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
433         return true;
434     }
435     function decreaseBurnApproval(
436         address _spender,
437         uint256 _subtractedValue
438     )
439     public
440     whenNotPaused
441     returns (bool)
442     {
443         uint256 oldValue = allowedBurn[msg.sender][_spender];
444         if (_subtractedValue >= oldValue) {
445             allowedBurn[msg.sender][_spender] = 0;
446         } else {
447             allowedBurn[msg.sender][_spender] = oldValue.sub(_subtractedValue);
448         }
449         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
450         return true;
451     }
452 }
453 contract FreezableBurnablePausableERC20Token is BurnablePausableERC20Token {
454     mapping (address => bool) public frozenAccount;
455     event FrozenFunds(address target, bool frozen);
456     function freezeAccount(
457         address target,
458         bool freeze
459     )
460     public
461     onlyOwner
462 {
463 frozenAccount[target] = freeze;
464     emit FrozenFunds(target, freeze);
465 }
466     function transfer(
467         address _to,
468         uint256 _value
469     )
470     public
471     whenNotPaused
472     returns (bool)
473     {
474         require(!frozenAccount[msg.sender], "Sender account freezed");
475         require(!frozenAccount[_to], "Receiver account freezed");
476         return super.transfer(_to, _value);
477     }
478     function transferFrom(
479         address _from,
480         address _to,
481         uint256 _value
482     )
483     public
484     whenNotPaused
485     returns (bool)
486     {
487         require(!frozenAccount[msg.sender], "Spender account freezed");
488         require(!frozenAccount[_from], "Sender account freezed");
489         require(!frozenAccount[_to], "Receiver account freezed");
490         return super.transferFrom(_from, _to, _value);
491     }
492     function burn(
493         uint256 _value
494     )
495     public
496     whenNotPaused
497 {
498 require(!frozenAccount[msg.sender], "Sender account freezed");
499 return super.burn(_value);
500 }
501     function burnFrom(
502         address _from,
503         uint256 _value
504     )
505     public
506     whenNotPaused
507     {
508         require(!frozenAccount[msg.sender], "Spender account freezed");
509         require(!frozenAccount[_from], "Sender account freezed");
510         return super.burnFrom(_from, _value);
511     }
512 }
513 
514 contract MAX is FreezableBurnablePausableERC20Token {
515 
516     string public constant name = "Matrix Max Value";
517     string public constant symbol = "MAX";
518     uint8 public constant decimals = 18;
519     uint256 public constant INITIAL_SUPPLY = 2100000000 * (10 ** uint256(decimals));
520    
521     constructor() public {
522         totalSupply_ = INITIAL_SUPPLY;
523         balances[msg.sender] = INITIAL_SUPPLY;
524         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
525     }
526 }