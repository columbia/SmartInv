1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 contract MinterRole {
38   using Roles for Roles.Role;
39 
40   event MinterAdded(address indexed account);
41   event MinterRemoved(address indexed account);
42 
43   Roles.Role private minters;
44 
45   constructor() internal {
46     _addMinter(msg.sender);
47   }
48 
49   modifier onlyMinter() {
50     require(isMinter(msg.sender));
51     _;
52   }
53 
54   function isMinter(address account) public view returns (bool) {
55     return minters.has(account);
56   }
57 
58   function addMinter(address account) public onlyMinter {
59     _addMinter(account);
60   }
61 
62   function renounceMinter() public {
63     _removeMinter(msg.sender);
64   }
65 
66   function _addMinter(address account) internal {
67     minters.add(account);
68     emit MinterAdded(account);
69   }
70 
71   function _removeMinter(address account) internal {
72     minters.remove(account);
73     emit MinterRemoved(account);
74   }
75 }
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that revert on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, reverts on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     uint256 c = a * b;
96     require(c / a == b);
97 
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b > 0); // Solidity only automatically asserts when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109     return c;
110   }
111 
112   /**
113   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     require(b <= a);
117     uint256 c = a - b;
118 
119     return c;
120   }
121 
122   /**
123   * @dev Adds two numbers, reverts on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     require(c >= a);
128 
129     return c;
130   }
131 
132   /**
133   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
134   * reverts when dividing by zero.
135   */
136   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b != 0);
138     return a % b;
139   }
140 }
141 
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
148  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract ERC20 is IERC20 {
151   using SafeMath for uint256;
152 
153   mapping (address => uint256) private _balances;
154 
155   mapping (address => mapping (address => uint256)) private _allowed;
156 
157   uint256 private _totalSupply;
158 
159   /**
160   * @dev Total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return _totalSupply;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param owner The address to query the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address owner) public view returns (uint256) {
172     return _balances[owner];
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param owner address The address which owns the funds.
178    * @param spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(
182     address owner,
183     address spender
184    )
185     public
186     view
187     returns (uint256)
188   {
189     return _allowed[owner][spender];
190   }
191 
192   /**
193   * @dev Transfer token for a specified address
194   * @param to The address to transfer to.
195   * @param value The amount to be transferred.
196   */
197   function transfer(address to, uint256 value) public returns (bool) {
198     _transfer(msg.sender, to, value);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param spender The address which will spend the funds.
209    * @param value The amount of tokens to be spent.
210    */
211   function approve(address spender, uint256 value) public returns (bool) {
212     require(spender != address(0));
213 
214     _allowed[msg.sender][spender] = value;
215     emit Approval(msg.sender, spender, value);
216     return true;
217   }
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param from address The address which you want to send tokens from
222    * @param to address The address which you want to transfer to
223    * @param value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(
226     address from,
227     address to,
228     uint256 value
229   )
230     public
231     returns (bool)
232   {
233     require(value <= _allowed[from][msg.sender]);
234 
235     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
236     _transfer(from, to, value);
237     return true;
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    * approve should be called when allowed_[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param spender The address which will spend the funds.
247    * @param addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseAllowance(
250     address spender,
251     uint256 addedValue
252   )
253     public
254     returns (bool)
255   {
256     require(spender != address(0));
257 
258     _allowed[msg.sender][spender] = (
259       _allowed[msg.sender][spender].add(addedValue));
260     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
261     return true;
262   }
263 
264   /**
265    * @dev Decrease the amount of tokens that an owner allowed to a spender.
266    * approve should be called when allowed_[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param spender The address which will spend the funds.
271    * @param subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseAllowance(
274     address spender,
275     uint256 subtractedValue
276   )
277     public
278     returns (bool)
279   {
280     require(spender != address(0));
281 
282     _allowed[msg.sender][spender] = (
283       _allowed[msg.sender][spender].sub(subtractedValue));
284     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
285     return true;
286   }
287 
288   /**
289   * @dev Transfer token for a specified addresses
290   * @param from The address to transfer from.
291   * @param to The address to transfer to.
292   * @param value The amount to be transferred.
293   */
294   function _transfer(address from, address to, uint256 value) internal {
295     require(value <= _balances[from]);
296     require(to != address(0));
297 
298     _balances[from] = _balances[from].sub(value);
299     _balances[to] = _balances[to].add(value);
300     emit Transfer(from, to, value);
301   }
302 
303   /**
304    * @dev Internal function that mints an amount of the token and assigns it to
305    * an account. This encapsulates the modification of balances such that the
306    * proper events are emitted.
307    * @param account The account that will receive the created tokens.
308    * @param value The amount that will be created.
309    */
310   function _mint(address account, uint256 value) internal {
311     require(account != 0);
312     _totalSupply = _totalSupply.add(value);
313     _balances[account] = _balances[account].add(value);
314     emit Transfer(address(0), account, value);
315   }
316 
317   /**
318    * @dev Internal function that burns an amount of the token of a given
319    * account.
320    * @param account The account whose tokens will be burnt.
321    * @param value The amount that will be burnt.
322    */
323   function _burn(address account, uint256 value) internal {
324     require(account != 0);
325     require(value <= _balances[account]);
326 
327     _totalSupply = _totalSupply.sub(value);
328     _balances[account] = _balances[account].sub(value);
329     emit Transfer(account, address(0), value);
330   }
331 
332   /**
333    * @dev Internal function that burns an amount of the token of a given
334    * account, deducting from the sender's allowance for said account. Uses the
335    * internal burn function.
336    * @param account The account whose tokens will be burnt.
337    * @param value The amount that will be burnt.
338    */
339   function _burnFrom(address account, uint256 value) internal {
340     require(value <= _allowed[account][msg.sender]);
341 
342     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
343     // this function needs to emit an event with the updated approval.
344     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
345       value);
346     _burn(account, value);
347   }
348 }
349 
350 
351 /**
352  * @title ERC20Detailed token
353  * @dev The decimals are only for visualization purposes.
354  * All the operations are done using the smallest and indivisible token unit,
355  * just as on Ethereum all the operations are done in wei.
356  */
357 contract ERC20Detailed is IERC20 {
358   string private _name;
359   string private _symbol;
360   uint8 private _decimals;
361 
362   constructor(string name, string symbol, uint8 decimals) public {
363     _name = name;
364     _symbol = symbol;
365     _decimals = decimals;
366   }
367 
368   /**
369    * @return the name of the token.
370    */
371   function name() public view returns(string) {
372     return _name;
373   }
374 
375   /**
376    * @return the symbol of the token.
377    */
378   function symbol() public view returns(string) {
379     return _symbol;
380   }
381 
382   /**
383    * @return the number of decimals of the token.
384    */
385   function decimals() public view returns(uint8) {
386     return _decimals;
387   }
388 }
389 
390 
391 /**
392  * @title ERC20Mintable
393  * @dev ERC20 minting logic
394  */
395 contract ERC20Mintable is ERC20, MinterRole {
396   /**
397    * @dev Function to mint tokens
398    * @param to The address that will receive the minted tokens.
399    * @param value The amount of tokens to mint.
400    * @return A boolean that indicates if the operation was successful.
401    */
402   function mint(
403     address to,
404     uint256 value
405   )
406     public
407     onlyMinter
408     returns (bool)
409   {
410     _mint(to, value);
411     return true;
412   }
413 }
414 
415 
416 /**
417  * @title Roles
418  * @dev Library for managing addresses assigned to a Role.
419  */
420 library Roles {
421   struct Role {
422     mapping (address => bool) bearer;
423   }
424 
425   /**
426    * @dev give an account access to this role
427    */
428   function add(Role storage role, address account) internal {
429     require(account != address(0));
430     require(!has(role, account));
431 
432     role.bearer[account] = true;
433   }
434 
435   /**
436    * @dev remove an account's access to this role
437    */
438   function remove(Role storage role, address account) internal {
439     require(account != address(0));
440     require(has(role, account));
441 
442     role.bearer[account] = false;
443   }
444 
445   /**
446    * @dev check if an account has this role
447    * @return bool
448    */
449   function has(Role storage role, address account)
450     internal
451     view
452     returns (bool)
453   {
454     require(account != address(0));
455     return role.bearer[account];
456   }
457 }
458 
459 /**
460  * @title GREF
461  */
462 contract GREF is ERC20, ERC20Detailed, ERC20Mintable {
463     
464     /**
465      * @dev Constructor that gives msg.sender all of existing tokens.
466      */
467     constructor () public ERC20Detailed("GREF", "GREF", 18) {
468         _mint(msg.sender, 5000000 * (10 ** uint256(decimals())));
469     }
470 }