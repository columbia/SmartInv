1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 /**
70  * @title Roles
71  * @dev Library for managing addresses assigned to a Role.
72  */
73 library Roles {
74     struct Role {
75         mapping (address => bool) bearer;
76     }
77 
78     /**
79      * @dev give an account access to this role
80      */
81     function add(Role storage role, address account) internal {
82         require(account != address(0));
83         require(!has(role, account));
84 
85         role.bearer[account] = true;
86     }
87 
88     /**
89      * @dev remove an account's access to this role
90      */
91     function remove(Role storage role, address account) internal {
92         require(account != address(0));
93         require(has(role, account));
94 
95         role.bearer[account] = false;
96     }
97 
98     /**
99      * @dev check if an account has this role
100      * @return bool
101      */
102     function has(Role storage role, address account) internal view returns (bool) {
103         require(account != address(0));
104         return role.bearer[account];
105     }
106 }
107 
108 
109 contract MinterRole {
110     using Roles for Roles.Role;
111 
112     event MinterAdded(address indexed account);
113     event MinterRemoved(address indexed account);
114 
115     Roles.Role private _minters;
116 
117     constructor () internal {
118         _addMinter(msg.sender);
119     }
120 
121     modifier onlyMinter() {
122         require(isMinter(msg.sender));
123         _;
124     }
125 
126     function isMinter(address account) public view returns (bool) {
127         return _minters.has(account);
128     }
129 
130     function addMinter(address account) public onlyMinter {
131         _addMinter(account);
132     }
133 
134     function renounceMinter() public {
135         _removeMinter(msg.sender);
136     }
137 
138     function _addMinter(address account) internal {
139         _minters.add(account);
140         emit MinterAdded(account);
141     }
142 
143     function _removeMinter(address account) internal {
144         _minters.remove(account);
145         emit MinterRemoved(account);
146     }
147 }
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 interface IERC20 {
155   function totalSupply() external view returns (uint256);
156 
157   function balanceOf(address who) external view returns (uint256);
158 
159   function allowance(address owner, address spender)
160     external view returns (uint256);
161 
162   function transfer(address to, uint256 value) external returns (bool);
163 
164   function approve(address spender, uint256 value)
165     external returns (bool);
166 
167   function transferFrom(address from, address to, uint256 value)
168     external returns (bool);
169 
170   event Transfer(
171     address indexed from,
172     address indexed to,
173     uint256 value
174   );
175 
176   event Approval(
177     address indexed owner,
178     address indexed spender,
179     uint256 value
180   );
181 }
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
189  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract ERC20 is IERC20 {
192   using SafeMath for uint256;
193 
194   mapping (address => uint256) private _balances;
195 
196   mapping (address => mapping (address => uint256)) private _allowed;
197 
198   uint256 private _totalSupply;
199 
200   /**
201   * @dev Total number of tokens in existence
202   */
203   function totalSupply() public view returns (uint256) {
204     return _totalSupply;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param owner The address to query the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address owner) public view returns (uint256) {
213     return _balances[owner];
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param owner address The address which owns the funds.
219    * @param spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(
223     address owner,
224     address spender
225    )
226     public
227     view
228     returns (uint256)
229   {
230     return _allowed[owner][spender];
231   }
232 
233   /**
234   * @dev Transfer token for a specified address
235   * @param to The address to transfer to.
236   * @param value The amount to be transferred.
237   */
238   function transfer(address to, uint256 value) public returns (bool) {
239     _transfer(msg.sender, to, value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param spender The address which will spend the funds.
250    * @param value The amount of tokens to be spent.
251    */
252   function approve(address spender, uint256 value) public returns (bool) {
253     require(spender != address(0));
254 
255     _allowed[msg.sender][spender] = value;
256     emit Approval(msg.sender, spender, value);
257     return true;
258   }
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param from address The address which you want to send tokens from
263    * @param to address The address which you want to transfer to
264    * @param value uint256 the amount of tokens to be transferred
265    */
266   function transferFrom(
267     address from,
268     address to,
269     uint256 value
270   )
271     public
272     returns (bool)
273   {
274     require(value <= _allowed[from][msg.sender]);
275 
276     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
277     _transfer(from, to, value);
278     return true;
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed_[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param spender The address which will spend the funds.
288    * @param addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseAllowance(
291     address spender,
292     uint256 addedValue
293   )
294     public
295     returns (bool)
296   {
297     require(spender != address(0));
298 
299     _allowed[msg.sender][spender] = (
300       _allowed[msg.sender][spender].add(addedValue));
301     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed_[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param spender The address which will spend the funds.
312    * @param subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseAllowance(
315     address spender,
316     uint256 subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     require(spender != address(0));
322 
323     _allowed[msg.sender][spender] = (
324       _allowed[msg.sender][spender].sub(subtractedValue));
325     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
326     return true;
327   }
328 
329   /**
330   * @dev Transfer token for a specified addresses
331   * @param from The address to transfer from.
332   * @param to The address to transfer to.
333   * @param value The amount to be transferred.
334   */
335   function _transfer(address from, address to, uint256 value) internal {
336     require(value <= _balances[from]);
337     require(to != address(0));
338 
339     _balances[from] = _balances[from].sub(value);
340     _balances[to] = _balances[to].add(value);
341     emit Transfer(from, to, value);
342   }
343 
344   /**
345    * @dev Internal function that mints an amount of the token and assigns it to
346    * an account. This encapsulates the modification of balances such that the
347    * proper events are emitted.
348    * @param account The account that will receive the created tokens.
349    * @param value The amount that will be created.
350    */
351   function _mint(address account, uint256 value) internal {
352     require(account != address(0));
353     _totalSupply = _totalSupply.add(value);
354     _balances[account] = _balances[account].add(value);
355     emit Transfer(address(0), account, value);
356   }
357 
358   /**
359    * @dev Internal function that burns an amount of the token of a given
360    * account.
361    * @param account The account whose tokens will be burnt.
362    * @param value The amount that will be burnt.
363    */
364   function _burn(address account, uint256 value) internal {
365     require(account != address(0));
366     require(value <= _balances[account]);
367 
368     _totalSupply = _totalSupply.sub(value);
369     _balances[account] = _balances[account].sub(value);
370     emit Transfer(account, address(0), value);
371   }
372 
373   /**
374    * @dev Internal function that burns an amount of the token of a given
375    * account, deducting from the sender's allowance for said account. Uses the
376    * internal burn function.
377    * @param account The account whose tokens will be burnt.
378    * @param value The amount that will be burnt.
379    */
380   function _burnFrom(address account, uint256 value) internal {
381     require(value <= _allowed[account][msg.sender]);
382 
383     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
384     // this function needs to emit an event with the updated approval.
385     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
386       value);
387     _burn(account, value);
388   }
389 }
390 
391 
392 /**
393  * @title ERC20Mintable
394  * @dev ERC20 minting logic
395  */
396 contract ERC20Mintable is ERC20, MinterRole {
397     /**
398      * @dev Function to mint tokens
399      * @param to The address that will receive the minted tokens.
400      * @param value The amount of tokens to mint.
401      * @return A boolean that indicates if the operation was successful.
402      */
403     function mint(address to, uint256 value) public onlyMinter returns (bool) {
404         _mint(to, value);
405         return true;
406     }
407 }
408 
409 
410 /**
411  * @title Capped token
412  * @dev Mintable token with a token cap.
413  */
414 contract ERC20Capped is ERC20Mintable {
415     uint256 private _cap;
416 
417     constructor (uint256 cap) public {
418         require(cap > 0);
419         _cap = cap;
420     }
421 
422     /**
423      * @return the cap for the token minting.
424      */
425     function cap() public view returns (uint256) {
426         return _cap;
427     }
428 
429     function _mint(address account, uint256 value) internal {
430         require(totalSupply().add(value) <= _cap);
431         super._mint(account, value);
432     }
433 }
434 
435 
436 /**
437  * @title TKJade Token
438  * @dev Custom ERC20 token
439  */
440 contract TKJadeToken is ERC20Capped {
441 
442   string public constant name = "TKJade";
443   string public constant symbol = "TKJ";
444   uint8 public constant decimals = 18;
445 
446   /**
447    * @dev Constructor that gives owner all of existing tokens.
448    * @param initSupplyReceiver Address will receive initial supply
449    * @param cap Hard cap of the token
450    */
451   constructor(
452     address initSupplyReceiver,
453     uint256 cap
454   )
455     public
456     ERC20Capped(cap)
457   {
458     // mint 1 billion tokens for initial supply receiver
459     _mint(initSupplyReceiver, 1000000000000000000000000000);
460   }
461 }