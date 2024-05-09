1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Controller
71  * @dev The Controller contract has an owner address, and provides basic authorization and transfer control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Controller {
75     
76     address private _owner;
77     bool private _paused;
78     
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80     event Paused(address account);
81     event Unpaused(address account);
82     
83     mapping(address => bool) private owners;
84     
85     /**
86     * @dev The Controller constructor sets the initial `owner` of the contract to the sender
87     * account, and allows transfer by default.
88     */
89     constructor() internal {
90         setOwner(msg.sender);
91     }
92 
93     /**
94     * @dev Throws if called by any account other than the owner.
95     */
96     modifier onlyOwner() {
97         require(owners[msg.sender]);
98         _;
99     }
100 
101     function setOwner(address addr) internal returns(bool) {
102         if (!owners[addr]) {
103           owners[addr] = true;
104           _owner = addr;
105           return true; 
106         }
107     }
108 
109     /**
110     * @dev Allows the current owner to transfer control of the contract to a newOwner.
111     * @param newOwner The address to transfer ownership to.
112     */   
113     function changeOwner(address newOwner) onlyOwner public returns(bool) {
114         require (!owners[newOwner]);
115           owners[newOwner];
116           _owner = newOwner;
117           emit OwnershipTransferred(_owner, newOwner);
118           return; 
119         }
120 
121     /**
122     * @return the address of the owner.
123     */
124     function Owner() public view returns (address) {
125         return _owner;
126     }
127     
128     /**
129     * @return true if the contract is paused, false otherwise.
130     */
131     function paused() public view returns(bool) {
132     return _paused;
133     }
134     
135     /**
136     * @dev Modifier to make a function callable only when the contract is not paused.
137     */
138     modifier whenNotPaused() {
139     require(!_paused);
140     _;
141     }
142     
143     /**
144     * @dev Modifier to make a function callable only when the contract is paused.
145     */
146     modifier whenPaused() {
147     require(_paused);
148     _;
149     }
150     
151     /**
152     * @dev called by the owner to pause, triggers stopped state
153     */
154     function pause() public onlyOwner whenNotPaused {
155     _paused = true;
156     emit Paused(msg.sender);
157     }
158     
159     /**
160     * @dev called by the owner to unpause, returns to normal state
161     */
162     function unpause() public onlyOwner whenPaused {
163     _paused = false;
164     emit Unpaused(msg.sender);
165     }
166     
167 }
168 
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 interface IERC20 {
175   function totalSupply() external view returns (uint256);
176 
177   function balanceOf(address who) external view returns (uint256);
178 
179   function allowance(address owner, address spender)
180     external view returns (uint256);
181 
182   function transfer(address to, uint256 value) external returns (bool);
183 
184   function approve(address spender, uint256 value)
185     external returns (bool);
186 
187   function transferFrom(address from, address to, uint256 value)
188     external returns (bool);
189 
190   event Transfer(
191     address indexed from,
192     address indexed to,
193     uint256 value
194   );
195 
196   event Approval(
197     address indexed owner,
198     address indexed spender,
199     uint256 value
200   );
201 }
202 
203 
204 /**
205  * @title Standard ERC20 token
206  *
207  * @dev Implementation of the basic standard token.
208  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
209  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
210  */
211 contract ERC20 is IERC20 {
212   using SafeMath for uint256;
213 
214   mapping (address => uint256) private _balances;
215 
216   mapping (address => mapping (address => uint256)) private _allowed;
217 
218   uint256 private _totalSupply;
219 
220   /**
221   * @dev Total number of tokens in existence
222   */
223   function totalSupply() public view returns (uint256) {
224     return _totalSupply;
225   }
226 
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param owner The address to query the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address owner) public view returns (uint256) {
233     return _balances[owner];
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param owner address The address which owns the funds.
239    * @param spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(
243     address owner,
244     address spender
245    )
246     public
247     view
248     returns (uint256)
249   {
250     return _allowed[owner][spender];
251   }
252 
253   /**
254   * @dev Transfer token for a specified address
255   * @param to The address to transfer to.
256   * @param value The amount to be transferred.
257   */
258   function transfer(address to, uint256 value) public returns (bool) {
259     _transfer(msg.sender, to, value);
260     return true;
261   }
262 
263   /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param spender The address which will spend the funds.
270    * @param value The amount of tokens to be spent.
271    */
272   function approve(address spender, uint256 value) public returns (bool) {
273     require(spender != address(0));
274 
275     _allowed[msg.sender][spender] = value;
276     emit Approval(msg.sender, spender, value);
277     return true;
278   }
279 
280   /**
281    * @dev Transfer tokens from one address to another
282    * @param from address The address which you want to send tokens from
283    * @param to address The address which you want to transfer to
284    * @param value uint256 the amount of tokens to be transferred
285    */
286   function transferFrom(
287     address from,
288     address to,
289     uint256 value
290   )
291     public
292     returns (bool)
293   {
294     require(value <= _allowed[from][msg.sender]);
295 
296     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
297     _transfer(from, to, value);
298     return true;
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed_[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param spender The address which will spend the funds.
308    * @param addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseAllowance(
311     address spender,
312     uint256 addedValue
313   )
314     public
315     returns (bool)
316   {
317     require(spender != address(0));
318 
319     _allowed[msg.sender][spender] = (
320       _allowed[msg.sender][spender].add(addedValue));
321     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
322     return true;
323   }
324 
325   /**
326    * @dev Decrease the amount of tokens that an owner allowed to a spender.
327    * approve should be called when allowed_[_spender] == 0. To decrement
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol
331    * @param spender The address which will spend the funds.
332    * @param subtractedValue The amount of tokens to decrease the allowance by.
333    */
334   function decreaseAllowance(
335     address spender,
336     uint256 subtractedValue
337   )
338     public
339     returns (bool)
340   {
341     require(spender != address(0));
342 
343     _allowed[msg.sender][spender] = (
344       _allowed[msg.sender][spender].sub(subtractedValue));
345     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
346     return true;
347   }
348 
349   /**
350   * @dev Transfer token for a specified addresses
351   * @param from The address to transfer from.
352   * @param to The address to transfer to.
353   * @param value The amount to be transferred.
354   */
355   function _transfer(address from, address to, uint256 value) internal {
356     require(value <= _balances[from]);
357     require(to != address(0));
358 
359     _balances[from] = _balances[from].sub(value);
360     _balances[to] = _balances[to].add(value);
361     emit Transfer(from, to, value);
362   }
363 
364   /**
365    * @dev Internal function that mints an amount of the token and assigns it to
366    * an account. This encapsulates the modification of balances such that the
367    * proper events are emitted.
368    * @param account The account that will receive the created tokens.
369    * @param value The amount that will be created.
370    */
371   function _mint(address account, uint256 value) internal {
372     require(account != 0);
373     _totalSupply = _totalSupply.add(value);
374     _balances[account] = _balances[account].add(value);
375     emit Transfer(address(0), account, value);
376   }
377 
378   /**
379    * @dev Internal function that burns an amount of the token of a given
380    * account.
381    * @param account The account whose tokens will be burnt.
382    * @param value The amount that will be burnt.
383    */
384   function _burn(address account, uint256 value) internal {
385     require(account != 0);
386     require(value <= _balances[account]);
387 
388     _totalSupply = _totalSupply.sub(value);
389     _balances[account] = _balances[account].sub(value);
390     emit Transfer(account, address(0), value); 
391   }
392 }
393 
394 
395 contract LobefyToken is ERC20, Controller {
396     
397     using SafeMath for uint256;
398     
399     string private _name = "Lobefy Token";
400     string private _symbol = "CRWD";
401     uint8 private _decimals = 18;
402     
403     address private team1 = 0xDA19316953D19f5f8C6361d68C6D0078c06285d3;
404     address private team2 = 0x928bdD2F7b286Ff300b054ac0897464Ffe5455b2;
405     address private team3 = 0x327d33e81988425B380B7f91C317961e3797Eedf;
406     address private team4 = 0x4d76022f6df7D007119FDffc310984b1F1E30660;
407     address private team5 = 0xA8534e7645003708B10316Dd5B6166b90649F4da;
408     address private team6 = 0xfF3005C63FD5633c3bd5D3D4f34b0491D0a564E5;
409     address private team7 = 0xb3FCDed4A67E56621F06dB5ff72bf8D93afeCb12;
410     address private reserve = 0x6Fc693855Ef50fDf378Add1bf487dB12772F4c8f;
411     
412     uint256 private team1Balance = 50 * (10 ** 6) * (10 ** 18);
413     uint256 private team2Balance = 50 * (10 ** 6) * (10 ** 18);
414     uint256 private team3Balance = 25 * (10 ** 6) * (10 ** 18);
415     uint256 private team4Balance = 15 * (10 ** 6) * (10 ** 18);
416     uint256 private team5Balance = 25 * (10 ** 6) * (10 ** 18);
417     uint256 private team6Balance = 25 * (10 ** 6) * (10 ** 18);
418     uint256 private team7Balance = 25 * (10 ** 6) * (10 ** 18);
419     uint256 private reserveBalance = 35 * (10 ** 6) * (10 ** 18);
420     
421     
422     constructor() public {
423         mint(team1,team1Balance);
424         mint(team2,team2Balance);
425         mint(team3,team3Balance);
426         mint(team4,team4Balance);
427         mint(team5,team5Balance);
428         mint(team6,team6Balance);
429         mint(team7,team7Balance);
430         mint(reserve,reserveBalance);
431     }
432 
433     /**
434     * @return the name of the token.
435     */
436     function name() public view returns(string) {
437         return _name;
438     }
439 
440     /**
441     * @return the symbol of the token.
442     */
443     function symbol() public view returns(string) {
444         return _symbol;
445     }
446 
447     /**
448     * @return the number of decimals of the token.
449     */
450     function decimals() public view returns(uint8) {
451         return _decimals;
452     }
453     
454     /**
455     * @dev Function to mint tokens
456     * @param to The address that will receive the minted tokens.
457     * @param value The amount of tokens to mint.
458     * @return A boolean that indicates if the operation was successful.
459     */
460     function mint(address to, uint256 value) public onlyOwner returns (bool) {
461         _mint(to, value);
462         return true;
463     }
464 
465     /**
466     * @dev ERC20 modified with pausable transfers.
467     **/
468     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
469         return super.transfer(to, value);
470     }
471 
472     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
473         return super.transferFrom(from, to, value);
474     }
475     
476     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
477         return super.approve(spender, value);
478     }
479 
480     function increaseAllowance( address spender, uint addedValue) public whenNotPaused returns (bool success) {
481         return super.increaseAllowance(spender, addedValue);
482     }
483 
484     function decreaseAllowance( address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
485         return super.decreaseAllowance(spender, subtractedValue);
486     }
487     
488     /**
489     * @dev Burns a specific amount of tokens.
490     * @param value The amount of token to be burned.
491     */
492     function burn(uint256 value) public {
493         _burn(msg.sender, value);
494     }
495 }