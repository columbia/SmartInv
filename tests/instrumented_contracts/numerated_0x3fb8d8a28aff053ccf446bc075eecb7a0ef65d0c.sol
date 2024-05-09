1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two numbers, reverts on overflow.
6      */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b > 0); // Solidity only automatically asserts when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 
29         return c;
30     }
31 
32     /**
33      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b <= a);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     /**
43      * @dev Adds two numbers, reverts on overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a);
48 
49         return c;
50     }
51 
52     /**
53      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
54      * reverts when dividing by zero.
55      */
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0);
58         return a % b;
59     }
60 }
61 
62 contract Ownable { 
63   address public owner;
64   address public controller;
65   
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72   event setControl(address indexed newController);
73   event renounceControl(address indexed controller);
74   
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   // permision to control
85   modifier onlyController() { 
86     require(msg.sender == controller);
87     _;    
88   }
89 
90   function setController(address _controller) public onlyOwner {       
91     _setController(_controller);
92   }
93 
94   function _setController(address _controller) internal { 
95     controller = _controller;
96     emit setControl(controller);
97   }
98   
99   function renounceController() public onlyOwner {
100     emit renounceControl(controller);
101     controller = address(0);    
102   }
103 
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108   
109   function transferOwnership(address _newOwner) public onlyOwner {
110     _transferOwnership(_newOwner);
111   }
112   
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 contract Pausable is Ownable{ 
121     event Pause();
122     event Unpause();
123 
124   bool public paused = false;
125 
126   mapping (address => bool) public frozenAccount;
127   event FrozenFunds(address target, bool frozen);
128 
129     // freeze, unfreeze 
130   function freezeAccount(address target, bool freeze) onlyController public {
131     frozenAccount[target] = freeze;
132     emit FrozenFunds(target, freeze);
133   }
134 
135   // need deploy
136   function isFrozenAccount(address target) onlyController public view returns (bool) {
137       return frozenAccount[target];
138   }
139   
140   /**
141    * @dev Modifier to make a function callable only when the contract is not paused.
142    */
143   modifier whenNotPaused() {
144     require(!paused);
145     _;
146   }
147 
148   /**
149    * @dev Modifier to make a function callable only when the contract is paused.
150    */
151   modifier whenPaused() {
152     require(paused);
153     _;
154   }
155 
156   /**
157    * @dev called by the owner to pause, triggers stopped state
158    */
159   function pause() onlyOwner whenNotPaused public {
160     paused = true;
161     emit Pause();
162   }
163 
164   /**
165    * @dev called by the owner to unpause, returns to normal state
166    */
167   function unpause() onlyOwner whenPaused public {
168     paused = false;
169     emit Unpause();
170   }  
171 }
172 
173 
174 interface IERC20 {
175     function totalSupply() external view returns (uint256);
176 
177     function balanceOf(address who) external view returns (uint256);
178 
179     function allowance(address owner, address spender)
180     external view returns (uint256);
181 
182     function transfer(address to, uint256 value) external returns (bool);
183 
184     function approve(address spender, uint256 value)
185     external returns (bool);
186 
187     function transferFrom(address from, address to, uint256 value)
188     external returns (bool);
189 
190     event Transfer(
191         address indexed from,
192         address indexed to,
193         uint256 value
194     );
195 
196     event Approval(
197         address indexed owner,
198         address indexed spender,
199         uint256 value
200     );
201 }
202 
203 contract ERC20 is IERC20, Pausable {
204     using SafeMath for uint256;
205 
206     mapping (address => uint256) private _balances;
207 
208     mapping (address => mapping (address => uint256)) private _allowed;
209 
210     uint256 private _totalSupply;
211 
212     /**
213      * @dev Total number of tokens in existence
214      */
215     function totalSupply() public view returns (uint256) {
216         return _totalSupply;
217     }
218 
219     /**
220      * @dev Gets the balance of the specified address.
221      * @param owner The address to query the balance of.
222      * @return An uint256 representing the amount owned by the passed address.
223      */
224     function balanceOf(address owner) public view returns (uint256) {
225         return _balances[owner];
226     }
227 
228     /**
229      * @dev Function to check the amount of tokens that an owner allowed to a spender.
230      * @param owner address The address which owns the funds.
231      * @param spender address The address which will spend the funds.
232      * @return A uint256 specifying the amount of tokens still available for the spender.
233      */
234     function allowance(
235         address owner,
236         address spender
237     )
238     public
239     view
240     returns (uint256)
241     {
242         require(!frozenAccount[msg.sender]);
243         return _allowed[owner][spender];
244     }
245 
246     /**
247      * @dev Transfer token for a specified address
248      * @param to The address to transfer to.
249      * @param value The amount to be transferred.
250      */
251     function transfer(address to, uint256 value) public returns (bool) {
252         require(!frozenAccount[msg.sender]);
253         _transfer(msg.sender, to, value);
254         return true;
255     }
256 
257     /**
258      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259      * Beware that changing an allowance with this method brings the risk that someone may use both the old
260      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      * @param spender The address which will spend the funds.
264      * @param value The amount of tokens to be spent.
265      */
266     function approve(address spender, uint256 value) public returns (bool) {
267         require(spender != address(0));
268         require(!frozenAccount[msg.sender]);
269 
270         _allowed[msg.sender][spender] = value;
271         emit Approval(msg.sender, spender, value);
272         return true;
273     }
274 
275     /**
276      * @dev Transfer tokens from one address to another
277      * @param from address The address which you want to send tokens from
278      * @param to address The address which you want to transfer to
279      * @param value uint256 the amount of tokens to be transferred
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 value
285     )
286     public
287     returns (bool)
288     {
289         require(!frozenAccount[msg.sender]);
290         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
291         _transfer(from, to, value);
292         return true;
293     }
294 
295     /**
296      * @dev Increase the amount of tokens that an owner allowed to a spender.
297      * approve should be called when allowed_[_spender] == 0. To increment
298      * allowed value is better to use this function to avoid 2 calls (and wait until
299      * the first transaction is mined)
300      * From MonolithDAO Token.sol
301      * @param spender The address which will spend the funds.
302      * @param addedValue The amount of tokens to increase the allowance by.
303      */
304     function increaseAllowance(
305         address spender,
306         uint256 addedValue
307     )
308     public
309     returns (bool)
310     {
311         require(spender != address(0));
312         require(!frozenAccount[msg.sender]);
313 
314         _allowed[msg.sender][spender] = (
315         _allowed[msg.sender][spender].add(addedValue));
316         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
317         return true;
318     }
319 
320     /**
321      * @dev Decrease the amount of tokens that an owner allowed to a spender.
322      * approve should be called when allowed_[_spender] == 0. To decrement
323      * allowed value is better to use this function to avoid 2 calls (and wait until
324      * the first transaction is mined)
325      * From MonolithDAO Token.sol
326      * @param spender The address which will spend the funds.
327      * @param subtractedValue The amount of tokens to decrease the allowance by.
328      */
329     function decreaseAllowance(
330         address spender,
331         uint256 subtractedValue
332     )
333     public
334     returns (bool)
335     {
336         require(spender != address(0));
337         require(!frozenAccount[msg.sender]);
338 
339         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
340         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
341         return true;
342     }
343 
344     /**
345      * @dev Transfer token for a specified addresses
346      * @param from The address to transfer from.
347      * @param to The address to transfer to.
348      * @param value The amount to be transferred.
349      */
350     function _transfer(address from, address to, uint256 value) internal {        
351         require(to != address(0));                        
352 
353         _balances[from] = _balances[from].sub(value);
354         _balances[to] = _balances[to].add(value);
355         emit Transfer(from, to, value);
356     }
357 
358     /**
359      * @dev Internal function that mints an amount of the token and assigns it to
360      * an account. This encapsulates the modification of balances such that the
361      * proper events are emitted.
362      * @param account The account that will receive the created tokens.
363      * @param value The amount that will be created.
364      */
365     function _mint(address account, uint256 value) internal {
366         require(account != address(0));
367 
368         _totalSupply = _totalSupply.add(value);
369         _balances[account] = _balances[account].add(value);
370         emit Transfer(address(0), account, value);
371     }
372 
373     /**
374      * @dev Internal function that burns an amount of the token of a given
375      * account.
376      * @param account The account whose tokens will be burnt.
377      * @param value The amount that will be burnt.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0));
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Internal function that burns an amount of the token of a given
389      * account, deducting from the sender's allowance for said account. Uses the
390      * internal burn function.
391      * @param account The account whose tokens will be burnt.
392      * @param value The amount that will be burnt.
393      */
394     function _burnFrom(address account, uint256 value) internal {
395         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
396         // this function needs to emit an event with the updated approval.
397         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
398             value);
399         _burn(account, value);
400     }
401 }
402 
403 contract ERC20Burnable is ERC20 {
404     /**
405      * @dev Burns a specific amount of tokens.
406      * @param value The amount of token to be burned.
407      */
408     function burn(uint256 value) public {
409         _burn(msg.sender, value);
410     }
411 
412     /**
413      * @dev Burns a specific amount of tokens from the target address and decrements allowance
414      * @param from address The address which you want to send tokens from
415      * @param value uint256 The amount of token to be burned
416      */
417     function burnFrom(address from, uint256 value) public {
418         _burnFrom(from, value);
419     }
420 }
421 
422 contract ERC20Mintable is ERC20 {
423     /**
424      * @dev Function to mint tokens
425      * @param to The address that will receive the minted tokens.
426      * @param value The amount of tokens to mint.
427      * @return A boolean that indicates if the operation was successful.
428      */
429     function mint(address to, uint256 value) public returns (bool) {
430         _mint(to, value);
431         return true;
432     }
433 }
434 
435 contract ERC20Pausable is ERC20 {
436     
437     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
438         return super.transfer(to, value);
439     }
440 
441     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
442         return super.transferFrom(from, to, value);
443     }
444 
445     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
446         return super.approve(spender, value);
447     }
448 
449     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
450         return super.increaseAllowance(spender, addedValue);
451     }
452 
453     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
454         return super.decreaseAllowance(spender, subtractedValue);
455     }
456     
457 }
458 
459 contract STPCToken is ERC20, ERC20Mintable, ERC20Burnable, ERC20Pausable {
460     string private _name;
461     string private _symbol;
462     uint256 private _decimals;
463     
464     
465     constructor (string name, string symbol, uint256 decimals ) public {
466         _name = name;
467         _symbol = symbol;
468         _decimals = decimals;
469     }
470 
471     /**
472      * @return the name of the token.
473      */
474     function name() public view returns (string) {
475         return _name;
476     }
477 
478     /**
479      * @return the symbol of the token.
480      */
481     function symbol() public view returns (string) {
482         return _symbol;
483     }
484 
485     /**
486      * @return the number of decimals of the token.
487      */
488     function decimals() public view returns (uint256) {
489         return _decimals;
490     }
491 }