1 pragma solidity 0.5.2;
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
70  * @title Standard ERC20 token
71  *
72  * @dev Implementation of the basic standard token.
73  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
74  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
75  */
76 contract MyToken {
77   using SafeMath for uint256;
78 
79   mapping (address => uint256) internal _balances;
80 
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   uint256 internal _totalSupply;
84   
85   string internal _name;
86   string internal _symbol;
87   uint8 internal _decimals;
88 
89   /**
90    * @return the name of the token.
91    */
92   function name() public view returns(string memory) {
93     return _name;
94   }
95 
96   /**
97    * @return the symbol of the token.
98    */
99   function symbol() public view returns(string memory) {
100     return _symbol;
101   }
102 
103   /**
104    * @return the number of decimals of the token.
105    */
106   function decimals() public view returns(uint8) {
107     return _decimals;
108   }
109 
110 
111   /**
112   * @dev Total number of tokens in existence
113   */
114   function totalSupply() public view returns (uint256) {
115     return _totalSupply;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param owner The address to query the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address owner) public view returns (uint256) {
124     return _balances[owner];
125   }
126 
127   /**
128    * @dev Function to check the amount of tokens that an owner allowed to a spender.
129    * @param owner address The address which owns the funds.
130    * @param spender address The address which will spend the funds.
131    * @return A uint256 specifying the amount of tokens still available for the spender.
132    */
133   function allowance(
134     address owner,
135     address spender
136    )
137     public
138     view
139     returns (uint256)
140   {
141     return _allowed[owner][spender];
142   }
143 
144   /**
145   * @dev Transfer token for a specified address
146   * @param to The address to transfer to.
147   * @param value The amount to be transferred.
148   */
149   function transfer(address to, uint256 value) public returns (bool) {
150     _transfer(msg.sender, to, value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param spender The address which will spend the funds.
161    * @param value The amount of tokens to be spent.
162    */
163   function approve(address spender, uint256 value) public returns (bool) {
164     require(spender != address(0));
165 
166     _allowed[msg.sender][spender] = value;
167     emit Approval(msg.sender, spender, value);
168     return true;
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param from address The address which you want to send tokens from
174    * @param to address The address which you want to transfer to
175    * @param value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(
178     address from,
179     address to,
180     uint256 value
181   )
182     public
183     returns (bool)
184   {
185     require(value <= _allowed[from][msg.sender]);
186 
187     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
188     _transfer(from, to, value);
189     return true;
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed_[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param spender The address which will spend the funds.
199    * @param addedValue The amount of tokens to increase the allowance by.
200    */
201   function increaseAllowance(
202     address spender,
203     uint256 addedValue
204   )
205     public
206     returns (bool)
207   {
208     require(spender != address(0));
209 
210     _allowed[msg.sender][spender] = (
211       _allowed[msg.sender][spender].add(addedValue));
212     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    * approve should be called when allowed_[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param spender The address which will spend the funds.
223    * @param subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseAllowance(
226     address spender,
227     uint256 subtractedValue
228   )
229     public
230     returns (bool)
231   {
232     require(spender != address(0));
233 
234     _allowed[msg.sender][spender] = (
235       _allowed[msg.sender][spender].sub(subtractedValue));
236     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
237     return true;
238   }
239 
240   /**
241   * @dev Transfer token for a specified addresses
242   * @param from The address to transfer from.
243   * @param to The address to transfer to.
244   * @param value The amount to be transferred.
245   */
246   function _transfer(address from, address to, uint256 value) internal {
247     require(value <= _balances[from]);
248     require(to != address(0));
249 
250     _balances[from] = _balances[from].sub(value);
251     _balances[to] = _balances[to].add(value);
252     emit Transfer(from, to, value);
253   }
254   
255   event Transfer(
256     address indexed from,
257     address indexed to,
258     uint256 value
259   );
260 
261   event Approval(
262     address indexed owner,
263     address indexed spender,
264     uint256 value
265   );
266 }
267 
268 
269 /**
270  * @title Roles
271  * @dev Library for managing addresses assigned to a Role.
272  */
273 library Roles {
274     struct Role {
275         mapping (address => bool) bearer;
276     }
277 
278     /**
279      * @dev Give an account access to this role.
280      */
281     function add(Role storage role, address account) internal {
282         require(!has(role, account), "Roles: account already has role");
283         role.bearer[account] = true;
284     }
285 
286     /**
287      * @dev Remove an account's access to this role.
288      */
289     function remove(Role storage role, address account) internal {
290         require(has(role, account), "Roles: account does not have role");
291         role.bearer[account] = false;
292     }
293 
294     /**
295      * @dev Check if an account has this role.
296      * @return bool
297      */
298     function has(Role storage role, address account) internal view returns (bool) {
299         require(account != address(0), "Roles: account is the zero address");
300         return role.bearer[account];
301     }
302 }
303 
304 
305 contract MinterRole {
306     using Roles for Roles.Role;
307 
308     event MinterAdded(address indexed account);
309     event MinterRemoved(address indexed account);
310 
311     Roles.Role private _minters;
312 
313     uint private minterAmount;
314 
315     constructor () public {
316         _addMinter(msg.sender);
317     }
318 
319     modifier onlyMinter() {
320         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
321         _;
322     }
323 
324     function isMinter(address account) public view returns (bool) {
325         return _minters.has(account);
326     }
327 
328     function addMinter(address account) public onlyMinter {
329         _addMinter(account);
330     }
331 
332     function renounceMinter() public {
333         _removeMinter(msg.sender);
334     }
335 
336     function _addMinter(address account) internal {
337         minterAmount++;
338         _minters.add(account);
339         emit MinterAdded(account);
340     }
341 
342     function _removeMinter(address account) internal {
343         require(minterAmount > 1);
344         minterAmount--;
345         _minters.remove(account);
346         emit MinterRemoved(account);
347     }
348 }
349 
350 
351 contract MyMintableToken is MyToken, MinterRole {
352 
353 	constructor (string memory name, string memory symbol, uint8 decimals, uint totalSupply) public {
354         _name = name;
355         _symbol = symbol;
356         _decimals = decimals;
357     
358         _totalSupply = totalSupply;
359         _balances[msg.sender] = _totalSupply;
360         emit Transfer(address(0), msg.sender, _totalSupply);
361     }
362 
363     /**
364      *
365      * Requirements:
366      *
367      * - the caller must have the `MinterRole`.
368      */
369     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
370         _mint(account, amount);
371         return true;
372     }
373 
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a `Transfer` event with `from` set to the zero address.
378      *
379      * Requirements
380      *
381      * - `account` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal {
384         require(account != address(0), "ERC20: mint to the zero address");
385 
386         _totalSupply = _totalSupply.add(amount);
387         _balances[account] = _balances[account].add(amount);
388         emit Transfer(address(0), account, amount);
389     }
390 }