1 pragma solidity ^0.4.25;
2 
3 
4 
5 
6 /**
7 * @title AccessControl
8 * @notice This contract defines organizational roles and permissions.
9 */
10 contract AccessControl {
11     /**
12      * @notice ContractUpgrade is the event that will be emitted if we set a new contract address
13      */
14     event ContractUpgrade(address newContract);
15     event Paused();
16     event Unpaused();
17 
18     /**
19      * @notice CEO's address FOOBAR
20      */
21     address public ceoAddress;
22 
23     /**
24      * @notice CFO's address
25      */
26     address public cfoAddress;
27 
28     /**
29      * @notice COO's address
30      */
31     address public cooAddress;
32 
33     /**
34      * @notice withdrawal address
35      */
36     address public withdrawalAddress;
37 
38     bool public paused = false;
39 
40     /**
41      * @dev Modifier to make a function only callable by the CEO
42      */
43     modifier onlyCEO() {
44         require(msg.sender == ceoAddress);
45         _;
46     }
47 
48     /**
49      * @dev Modifier to make a function only callable by the CFO
50      */
51     modifier onlyCFO() {
52         require(msg.sender == cfoAddress);
53         _;
54     }
55 
56     /**
57      * @dev Modifier to make a function only callable by the COO
58      */
59     modifier onlyCOO() {
60         require(msg.sender == cooAddress);
61         _;
62     }
63 
64     /**
65      * @dev Modifier to make a function only callable by C-level execs
66      */
67     modifier onlyCLevel() {
68         require(
69         msg.sender == cooAddress ||
70         msg.sender == ceoAddress ||
71         msg.sender == cfoAddress
72         );
73         _;
74     }
75 
76     /**
77      * @dev Modifier to make a function only callable by CEO or CFO
78      */
79     modifier onlyCEOOrCFO() {
80         require(
81         msg.sender == cfoAddress ||
82         msg.sender == ceoAddress
83         );
84         _;
85     }
86 
87     /**
88      * @dev Modifier to make a function only callable by CEO or COO
89      */
90     modifier onlyCEOOrCOO() {
91         require(
92         msg.sender == cooAddress ||
93         msg.sender == ceoAddress
94         );
95         _;
96     }
97 
98     /**
99      * @notice Sets a new CEO
100      * @param _newCEO - the address of the new CEO
101      */
102     function setCEO(address _newCEO) external onlyCEO {
103         require(_newCEO != address(0));
104         ceoAddress = _newCEO;
105     }
106 
107     /**
108      * @notice Sets a new CFO
109      * @param _newCFO - the address of the new CFO
110      */
111     function setCFO(address _newCFO) external onlyCEO {
112         require(_newCFO != address(0));
113         cfoAddress = _newCFO;
114     }
115 
116     /**
117      * @notice Sets a new COO
118      * @param _newCOO - the address of the new COO
119      */
120     function setCOO(address _newCOO) external onlyCEO {
121         require(_newCOO != address(0));
122         cooAddress = _newCOO;
123     }
124 
125     /**
126      * @dev Modifier to make a function callable only when the contract is not paused.
127      */
128     modifier whenNotPaused() {
129         require(!paused);
130         _;
131     }
132 
133     /**
134      * @dev Modifier to make a function callable only when the contract is paused.
135      */
136     modifier whenPaused() {
137         require(paused);
138         _;
139     }
140 
141     /**
142      * @notice called by any C-level to pause, triggers stopped state
143      */
144     function pause() public onlyCLevel whenNotPaused {
145         paused = true;
146         emit Paused();
147     }
148 
149     /**
150      * @notice called by the CEO to unpause, returns to normal state
151      */
152     function unpause() public onlyCEO whenPaused {
153         paused = false;
154         emit Unpaused();
155     }
156 }
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 interface IERC20 {
163   function totalSupply() external view returns (uint256);
164 
165   function balanceOf(address who) external view returns (uint256);
166 
167   function allowance(address owner, address spender)
168     external view returns (uint256);
169 
170   function transfer(address to, uint256 value) external returns (bool);
171 
172   function approve(address spender, uint256 value)
173     external returns (bool);
174 
175   function transferFrom(address from, address to, uint256 value)
176     external returns (bool);
177 
178   event Transfer(
179     address indexed from,
180     address indexed to,
181     uint256 value
182   );
183 
184   event Approval(
185     address indexed owner,
186     address indexed spender,
187     uint256 value
188   );
189 }
190 
191 
192 /**
193  * @title SafeMath
194  * @dev Math operations with safety checks that revert on error
195  */
196 library SafeMath {
197 
198   /**
199   * @dev Multiplies two numbers, reverts on overflow.
200   */
201   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203     // benefit is lost if 'b' is also tested.
204     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
205     if (a == 0) {
206       return 0;
207     }
208 
209     uint256 c = a * b;
210     require(c / a == b);
211 
212     return c;
213   }
214 
215   /**
216   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
217   */
218   function div(uint256 a, uint256 b) internal pure returns (uint256) {
219     require(b > 0); // Solidity only automatically asserts when dividing by 0
220     uint256 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223     return c;
224   }
225 
226   /**
227   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
228   */
229   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230     require(b <= a);
231     uint256 c = a - b;
232 
233     return c;
234   }
235 
236   /**
237   * @dev Adds two numbers, reverts on overflow.
238   */
239   function add(uint256 a, uint256 b) internal pure returns (uint256) {
240     uint256 c = a + b;
241     require(c >= a);
242 
243     return c;
244   }
245 
246   /**
247   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
248   * reverts when dividing by zero.
249   */
250   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251     require(b != 0);
252     return a % b;
253   }
254 }
255 
256 
257 contract LockToken is AccessControl {
258     mapping (address => uint256) private lockTokenNum;
259     mapping (address => uint256) private lockTokenTime;
260     
261     event SetLockTokenNum(address from,uint256 num);
262     event SetLockTokenTime(address from,uint256 time);
263     event SetLockTokenInfo(address from,uint256 num,uint256 time);
264 
265     function setLockTokenNum (address from,uint256 num) public  whenNotPaused onlyCEO {
266         require(from != address(0));
267         lockTokenNum[from] = num;
268         emit SetLockTokenNum(from,num);
269     }
270     
271     function setLockTokenTime(address from,uint256 time) public whenNotPaused onlyCEO {
272         require(from != address(0));
273         lockTokenTime[from] = time;
274         emit SetLockTokenTime(from,time);
275     }
276     
277     function setLockTokenInfo(address from,uint256 num,uint256 time) public whenNotPaused onlyCEO {
278         require(from != address(0));
279         lockTokenNum[from] = num;
280         lockTokenTime[from] = time;
281         emit SetLockTokenInfo(from,num,time);
282     }
283     
284     
285     function setLockTokenInfoList (address[] froms,uint256[] nums, uint256[] times) public whenNotPaused onlyCEO {
286         for(uint256 i =0;i<froms.length ;i++ ){
287             require(froms[i] != address(0));
288             lockTokenNum[froms[i]] = nums[i];
289             lockTokenTime[froms[i]] = times[i];
290         }
291     }
292     
293     function getLockTokenNum (address from) public view returns (uint256) {
294         require(from != address(0));
295         return lockTokenNum[from];
296     }
297     
298     function getLockTokenTime(address from) public view returns (uint256) {
299         require(from != address(0));
300         return lockTokenTime[from];
301     }
302     
303     function getBlockTime() public view returns(uint256){
304         return block.timestamp;
305     }
306 }
307 
308 /**
309  * @title Standard ERC20 token
310  *
311  * @dev Implementation of the basic standard token.
312  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
313  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
314  */
315 contract ERC20 is IERC20,LockToken{
316   using SafeMath for uint256;
317 
318   mapping (address => uint256) public _balances;
319 
320   mapping (address => mapping (address => uint256)) public _allowed;
321 
322   uint256 public _totalSupply;
323 
324   /**
325   * @dev Total number of tokens in existence
326   */
327   function totalSupply() public view returns (uint256) {
328     return _totalSupply;
329   }
330 
331   /**
332   * @dev Gets the balance of the specified address.
333   * @param owner The address to query the balance of.
334   * @return An uint256 representing the amount owned by the passed address.
335   */
336   function balanceOf(address owner) public view returns (uint256) {
337     return _balances[owner];
338   }
339 
340   /**
341    * @dev Function to check the amount of tokens that an owner allowed to a spender.
342    * @param owner address The address which owns the funds.
343    * @param spender address The address which will spend the funds.
344    * @return A uint256 specifying the amount of tokens still available for the spender.
345    */
346   function allowance(
347     address owner,
348     address spender
349    )
350     public
351     view whenNotPaused
352     returns (uint256) 
353   {
354     return _allowed[owner][spender];
355   }
356 
357   /**
358   * @dev Transfer token for a specified address
359   * @param to The address to transfer to.
360   * @param value The amount to be transferred.
361   */
362   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
363     require(value <= _balances[msg.sender]);
364     require(to != address(0));
365     uint256 time = getLockTokenTime(msg.sender);
366     uint256 blockTime = block.timestamp;
367     require(blockTime >time);
368     _balances[msg.sender] = _balances[msg.sender].sub(value);
369     _balances[to] = _balances[to].add(value);
370     emit Transfer(msg.sender, to, value);
371     return true;
372   }
373 
374   /**
375    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
376    * Beware that changing an allowance with this method brings the risk that someone may use both the old
377    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
378    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
379    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
380    * @param spender The address which will spend the funds.
381    * @param value The amount of tokens to be spent.
382    */
383   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
384     require(spender != address(0));
385     uint256 time = getLockTokenTime(msg.sender);
386     uint256 blockTime = block.timestamp;
387     require(blockTime >time);
388     _allowed[msg.sender][spender] = value;
389     emit Approval(msg.sender, spender, value);
390     return true;
391   }
392 
393   /**
394    * @dev Transfer tokens from one address to another
395    * @param from address The address which you want to send tokens from
396    * @param to address The address which you want to transfer to
397    * @param value uint256 the amount of tokens to be transferred
398    */
399   function transferFrom(
400     address from,
401     address to,
402     uint256 value
403   )
404     public whenNotPaused
405     returns (bool)
406   {
407     require(value <= _balances[from]);
408     require(value <= _allowed[from][msg.sender]);
409     require(to != address(0));
410     uint256 time = getLockTokenTime(from);
411     uint256 blockTime = block.timestamp;
412     require(blockTime >time);
413     _balances[from] = _balances[from].sub(value);
414     _balances[to] = _balances[to].add(value);
415     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
416     emit Transfer(from, to, value);
417     return true;
418   }
419 
420   /**
421    * @dev Increase the amount of tokens that an owner allowed to a spender.
422    * approve should be called when allowed_[_spender] == 0. To increment
423    * allowed value is better to use this function to avoid 2 calls (and wait until
424    * the first transaction is mined)
425    * From MonolithDAO Token.sol
426    * @param spender The address which will spend the funds.
427    * @param addedValue The amount of tokens to increase the allowance by.
428    */
429   function increaseAllowance(
430     address spender,
431     uint256 addedValue
432   )
433     public
434     returns (bool)
435   {
436     require(spender != address(0));
437 
438     _allowed[msg.sender][spender] = (
439       _allowed[msg.sender][spender].add(addedValue));
440     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
441     return true;
442   }
443 
444   /**
445    * @dev Decrease the amount of tokens that an owner allowed to a spender.
446    * approve should be called when allowed_[_spender] == 0. To decrement
447    * allowed value is better to use this function to avoid 2 calls (and wait until
448    * the first transaction is mined)
449    * From MonolithDAO Token.sol
450    * @param spender The address which will spend the funds.
451    * @param subtractedValue The amount of tokens to decrease the allowance by.
452    */
453   function decreaseAllowance(
454     address spender,
455     uint256 subtractedValue
456   )
457     public
458     returns (bool)
459   {
460     require(spender != address(0));
461 
462     _allowed[msg.sender][spender] = (
463       _allowed[msg.sender][spender].sub(subtractedValue));
464     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
465     return true;
466   }
467 
468   /**
469    * @dev Internal function that mints an amount of the token and assigns it to
470    * an account. This encapsulates the modification of balances such that the
471    * proper events are emitted.
472    * @param account The account that will receive the created tokens.
473    * @param amount The amount that will be created.
474    */
475   function _mint(address account, uint256 amount) internal {
476     require(account != 0);
477     _totalSupply = _totalSupply.add(amount);
478     _balances[account] = _balances[account].add(amount);
479     emit Transfer(address(0), account, amount);
480   }
481 
482   /**
483    * @dev Internal function that burns an amount of the token of a given
484    * account.
485    * @param account The account whose tokens will be burnt.
486    * @param amount The amount that will be burnt.
487    */
488   function _burn(address account, uint256 amount) internal {
489     require(account != 0);
490     require(amount <= _balances[account]);
491 
492     _totalSupply = _totalSupply.sub(amount);
493     _balances[account] = _balances[account].sub(amount);
494     emit Transfer(account, address(0), amount);
495   }
496 
497   /**
498    * @dev Internal function that burns an amount of the token of a given
499    * account, deducting from the sender's allowance for said account. Uses the
500    * internal burn function.
501    * @param account The account whose tokens will be burnt.
502    * @param amount The amount that will be burnt.
503    */
504   function _burnFrom(address account, uint256 amount) internal {
505     require(amount <= _allowed[account][msg.sender]);
506 
507     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
508     // this function needs to emit an event with the updated approval.
509     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
510       amount);
511     _burn(account, amount);
512   }
513 }
514 
515 
516 
517 /**
518  * @title FTV
519  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
520  * Note they can later distribute these tokens as they wish using `transfer` and other
521  * `ERC20` functions.
522  */
523 contract FTV is ERC20 {
524 
525   string public constant name = "fashion tv";
526   string public constant symbol = "FTV";
527   uint8 public constant decimals = 8;
528 
529   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
530 
531   /**
532    * @dev Constructor that gives msg.sender all of existing tokens.
533    */
534   constructor() public {
535     paused =false;
536     ceoAddress = msg.sender;
537     cooAddress = msg.sender;
538     cfoAddress = msg.sender;
539     _mint(msg.sender, INITIAL_SUPPLY);
540   }
541 
542 }