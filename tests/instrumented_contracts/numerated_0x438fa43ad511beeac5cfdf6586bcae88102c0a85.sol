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
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender)
63         public view returns (uint256);
64 
65     function transferFrom(address from, address to, uint256 value)
66         public returns (bool);
67 
68     function approve(address spender, uint256 value) public returns (bool);
69 
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74     using SafeMath for uint256;
75 
76     mapping(address => uint256) balances;
77 
78     uint256 totalSupply_;
79 
80     function totalSupply() public view returns (uint256) {
81         return totalSupply_;
82     }
83 
84     function transfer(address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[msg.sender]);
87 
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256) {
95         return balances[_owner];
96     }
97 }
98 
99 contract Ownable {
100     address public owner;
101 
102     event OwnershipRenounced(address indexed previousOwner);
103     event OwnershipTransferred(
104         address indexed previousOwner,
105         address indexed newOwner
106     );
107 
108 
109     constructor() public {
110         owner = msg.sender;
111     }
112 
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipRenounced(owner);
120         owner = address(0);
121     }
122 
123     function transferOwnership(address _newOwner) public onlyOwner {
124         _transferOwnership(_newOwner);
125     }
126 
127     function _transferOwnership(address _newOwner) internal {
128         require(_newOwner != address(0));
129         emit OwnershipTransferred(owner, _newOwner);
130         owner = _newOwner;
131     }
132 }
133 
134 contract Pausable is Ownable {
135     event Pause();
136     event Unpause();
137 
138     bool public paused = false;
139 
140 
141     modifier whenNotPaused() {
142         require(!paused);
143         _;
144     }
145 
146 
147     modifier whenPaused() {
148         require(paused);
149         _;
150     }
151 
152 
153     function pause() onlyOwner whenNotPaused public {
154         paused = true;
155         emit Pause();
156     }
157 
158 
159     function unpause() onlyOwner whenPaused public {
160         paused = false;
161         emit Unpause();
162     }
163 }
164 
165 contract Lockable is Pausable {
166     mapping(address => bool) public lockedAccounts;
167     mapping(address => uint) public lockedTokenToBlockList;
168 
169     event LockTokenToBlockSuccess(address indexed target, uint toBlockNumber);
170 
171     function lockTokenToBlock(uint _blockNumber) public returns (bool success) {
172         require(lockedTokenToBlockList[msg.sender] < _blockNumber);
173 
174         return _lockTokenToBlock(msg.sender, _blockNumber);
175     }
176 
177     function lockTokenToBlock(address _target, uint _blockNumber) public onlyOwner returns (bool success) {
178         return _lockTokenToBlock(_target, _blockNumber);
179     }
180 
181     function _lockTokenToBlock(address _target, uint _blockNumber) private returns (bool success) {
182         require(_target != address(0) && _blockNumber > block.number);
183 
184         lockedTokenToBlockList[_target] = _blockNumber;
185 
186         emit LockTokenToBlockSuccess(_target, _blockNumber);
187 
188         return true;
189     }
190 
191 
192     function lockAddress(address _target) public onlyOwner returns (bool success) {
193         require(_target != address(0));
194 
195         lockedAccounts[_target] = true;
196 
197         return true;
198     }
199 
200     function unlockAddress(address _target) public onlyOwner returns (bool success) {
201         delete lockedAccounts[_target];
202 
203         return true;
204     }
205 
206 
207     modifier transferAllowed(address _target) {
208         require(_target != address(0)
209             && lockedAccounts[_target] == false
210             && lockedTokenToBlockList[_target] < block.number);
211 
212         _;
213     }
214 }
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * https://github.com/ethereum/EIPs/issues/20
221  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, BasicToken {
224 
225     mapping (address => mapping (address => uint256)) internal allowed;
226 
227 
228     /**
229     * @dev Transfer tokens from one address to another
230     * @param _from address The address which you want to send tokens from
231     * @param _to address The address which you want to transfer to
232     * @param _value uint256 the amount of tokens to be transferred
233     */
234     function transferFrom(
235         address _from,
236         address _to,
237         uint256 _value
238     )
239         public
240         returns (bool)
241     {
242         require(_to != address(0));
243         require(_value <= balances[_from]);
244         require(_value <= allowed[_from][msg.sender]);
245 
246         balances[_from] = balances[_from].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
249         emit Transfer(_from, _to, _value);
250         return true;
251     }
252 
253     /**
254     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255     * Beware that changing an allowance with this method brings the risk that someone may use both the old
256     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259     * @param _spender The address which will spend the funds.
260     * @param _value The amount of tokens to be spent.
261     */
262     function approve(address _spender, uint256 _value) public returns (bool) {
263         allowed[msg.sender][_spender] = _value;
264         emit Approval(msg.sender, _spender, _value);
265         return true;
266     }
267 
268     /**
269     * @dev Function to check the amount of tokens that an owner allowed to a spender.
270     * @param _owner address The address which owns the funds.
271     * @param _spender address The address which will spend the funds.
272     * @return A uint256 specifying the amount of tokens still available for the spender.
273     */
274     function allowance(
275         address _owner,
276         address _spender
277     )
278         public
279         view
280         returns (uint256)
281     {
282         return allowed[_owner][_spender];
283     }
284 
285     /**
286     * @dev Increase the amount of tokens that an owner allowed to a spender.
287     * approve should be called when allowed[_spender] == 0. To increment
288     * allowed value is better to use this function to avoid 2 calls (and wait until
289     * the first transaction is mined)
290     * From MonolithDAO Token.sol
291     * @param _spender The address which will spend the funds.
292     * @param _addedValue The amount of tokens to increase the allowance by.
293     */
294     function increaseApproval(
295         address _spender,
296         uint256 _addedValue
297     )
298         public
299         returns (bool)
300     {
301         allowed[msg.sender][_spender] = (
302         allowed[msg.sender][_spender].add(_addedValue));
303         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 
307     /**
308     * @dev Decrease the amount of tokens that an owner allowed to a spender.
309     * approve should be called when allowed[_spender] == 0. To decrement
310     * allowed value is better to use this function to avoid 2 calls (and wait until
311     * the first transaction is mined)
312     * From MonolithDAO Token.sol
313     * @param _spender The address which will spend the funds.
314     * @param _subtractedValue The amount of tokens to decrease the allowance by.
315     */
316     function decreaseApproval(
317         address _spender,
318         uint256 _subtractedValue
319     )
320         public
321         returns (bool)
322     {
323         uint256 oldValue = allowed[msg.sender][_spender];
324         if (_subtractedValue >= oldValue) {
325             allowed[msg.sender][_spender] = 0;
326         } else {
327             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328         }
329         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330         return true;
331     }
332 }
333 
334 contract LockableToken is StandardToken, Lockable {
335     function transfer(
336         address _to,
337         uint256 _value
338     )
339         public
340         whenNotPaused
341         transferAllowed(msg.sender) 
342         returns (bool)
343     {
344         return super.transfer(_to, _value);
345     }
346 
347 
348     function transferFrom(
349         address _from,
350         address _to,
351         uint256 _value
352     )
353         public
354         whenNotPaused
355         transferAllowed(_from) 
356         returns (bool)
357     {
358         return super.transferFrom(_from, _to, _value);
359     }
360 
361     function approve(
362         address _spender,
363         uint256 _value
364     )
365         public
366         whenNotPaused
367         returns (bool)
368     {
369         return super.approve(_spender, _value);
370     }
371 
372 
373     function increaseApproval(
374         address _spender,
375         uint _addedValue
376     )
377         public
378         whenNotPaused
379         returns (bool success)
380     {
381         return super.increaseApproval(_spender, _addedValue);
382     }
383     
384 
385     function decreaseApproval(
386         address _spender,
387         uint _subtractedValue
388     )
389         public
390         whenNotPaused
391         returns (bool success)
392     {
393         return super.decreaseApproval(_spender, _subtractedValue);
394     }
395 }
396 
397 contract MQT is LockableToken {
398     function () external {
399         revert();
400     }
401 
402     string public name = "Miao Quark Token"; 
403     uint8 public decimals = 18;              
404     string public symbol = "MQT";          
405 
406     uint public TOKEN_UNIT_RATIO = 10 ** 18;
407 
408     uint public totalTokens = 21000000000 * TOKEN_UNIT_RATIO;
409 
410     /*分配给基石投资的总数*/
411     uint public assignedAmountToCornerstoneInvestment = totalTokens * 5 / 100;
412 
413     /*分配给团队的总数*/
414     uint public assignedAmountToDevelopmentTeam = totalTokens * 20 / 100;
415 
416     /*分配给私募的总数*/
417     uint public assignedAmountToPrivateEquityFund = totalTokens * 15 / 100;
418 
419     /*分配给基金会的总数*/
420     uint public assignedAmountToTheFoundation = totalTokens * 10 / 100;
421 
422     /*分配给市场开拓的总数*/
423     uint public assignedAmountToMarketExpand = totalTokens * 15 / 100;
424 
425     /*生态奖励奖池总数*/
426     uint public assignedAmountToEcoReward = totalTokens * 35 / 100;
427 
428     enum PoolTypeChoices {Other, CornerstoneInvestment, DevelopmentTeam, PrivateEquityFund, Foundation, MarketExpand, EcoReward }
429 
430     mapping (uint32 => uint) assignedInfo;
431 
432     uint public defaultLockBlocksForPool = 182 days / 15 seconds;
433 
434     constructor() public {
435         totalSupply_ = totalTokens;
436     }
437 
438     function allocateTokens(PoolTypeChoices _choice, address _target, uint _amount) public onlyOwner whenNotPaused returns(bool) {
439         uint _lockedBlocks = 0;
440         if (_choice != PoolTypeChoices.EcoReward) {
441             _lockedBlocks = defaultLockBlocksForPool;
442         }
443         return allocateTokens(_choice, _target, _amount, _lockedBlocks);
444     }
445 
446     function allocateTokens(
447         PoolTypeChoices _choice, 
448         address _target,
449         uint _amount,
450         uint _lockedBlocks
451     ) 
452         public 
453         onlyOwner 
454         whenNotPaused 
455         returns(bool) 
456     {
457         require(_target != address(0) && _amount > 0);
458 
459         uint totalAssigned = _amount.add(assignedInfo[uint32(_choice)]);
460 
461         uint totalPool = totalTokenForPool(_choice);
462 
463         require(totalAssigned <= totalPool);
464 
465         assignedInfo[uint32(_choice)] = totalAssigned;
466         balances[_target] = _amount.add(balances[_target]);
467 
468         if (_lockedBlocks > 0) {
469             lockTokenToBlock(_target, block.number + _lockedBlocks);
470         }
471 
472         emit Transfer(address(0), _target, _amount);
473         return true;
474     }
475 
476     function remainingTokenForPool(PoolTypeChoices _choice) public view returns(uint) {
477         uint totalPool = totalTokenForPool(_choice);
478 
479         if (totalPool > 0) {
480             return totalPool.sub(assignedInfo[uint32(_choice)]);
481         }
482 
483         return 0;
484     }
485 
486     function totalTokenForPool(PoolTypeChoices _choice) public view returns(uint) {
487         uint totalPool = 0;
488 
489         if (_choice == PoolTypeChoices.CornerstoneInvestment) {
490             totalPool = assignedAmountToCornerstoneInvestment;
491         } 
492         else if (_choice == PoolTypeChoices.DevelopmentTeam) {
493             totalPool = assignedAmountToDevelopmentTeam;
494         }
495         else if (_choice == PoolTypeChoices.PrivateEquityFund) {
496             totalPool = assignedAmountToPrivateEquityFund;
497         }
498         else if (_choice == PoolTypeChoices.Foundation) {
499             totalPool = assignedAmountToTheFoundation;
500         }
501         else if (_choice == PoolTypeChoices.MarketExpand) {
502             totalPool = assignedAmountToMarketExpand;
503         }
504         else if (_choice == PoolTypeChoices.EcoReward) {
505             totalPool = assignedAmountToEcoReward;
506         }
507 
508         return totalPool;
509     }
510 }