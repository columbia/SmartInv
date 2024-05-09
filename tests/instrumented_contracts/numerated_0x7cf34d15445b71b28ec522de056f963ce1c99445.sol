1 pragma solidity ^0.5.2;
2 
3 library Roles {
4     struct Role {
5         mapping (address => bool) bearer;
6     }
7 
8     /**
9      * @dev give an account access to this role
10      */
11     function add(Role storage role, address account) internal {
12         require(account != address(0));
13         require(!has(role, account));
14 
15         role.bearer[account] = true;
16     }
17 
18     /**
19      * @dev remove an account's access to this role
20      */
21     function remove(Role storage role, address account) internal {
22         require(account != address(0));
23         require(has(role, account));
24 
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev check if an account has this role
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0));
34         return role.bearer[account];
35     }
36 }
37 
38 contract MinterRole {
39     using Roles for Roles.Role;
40 
41     event MinterAdded(address indexed account);
42     event MinterRemoved(address indexed account);
43 
44     Roles.Role private _minters;
45 
46     constructor () internal {
47         _addMinter(msg.sender);
48     }
49 
50     modifier onlyMinter() {
51         require(isMinter(msg.sender));
52         _;
53     }
54 
55     function isMinter(address account) public view returns (bool) {
56         return _minters.has(account);
57     }
58 
59     function addMinter(address account) public onlyMinter {
60         _addMinter(account);
61     }
62 
63     function renounceMinter() public {
64         _removeMinter(msg.sender);
65     }
66 
67     function _addMinter(address account) internal {
68         _minters.add(account);
69         emit MinterAdded(account);
70     }
71 
72     function _removeMinter(address account) internal {
73         _minters.remove(account);
74         emit MinterRemoved(account);
75     }
76 }
77 
78 library SafeMath {
79     /**
80      * @dev Multiplies two unsigned integers, reverts on overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b);
92 
93         return c;
94     }
95 
96     /**
97      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b <= a);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119      * @dev Adds two unsigned integers, reverts on overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a);
124 
125         return c;
126     }
127 
128     /**
129      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130      * reverts when dividing by zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0);
134         return a % b;
135     }
136 }
137 
138 interface IERC20 {
139     function transfer(address to, uint256 value) external returns (bool);
140 
141     function approve(address spender, uint256 value) external returns (bool);
142 
143     function transferFrom(address from, address to, uint256 value) external returns (bool);
144 
145     function totalSupply() external view returns (uint256);
146 
147     function balanceOf(address who) external view returns (uint256);
148 
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 contract ERC20 is IERC20 {
157     using SafeMath for uint256;
158 
159     mapping (address => uint256) private _balances;
160 
161     mapping (address => mapping (address => uint256)) private _allowed;
162 
163     uint256 private _totalSupply;
164 
165     /**
166      * @dev Total number of tokens in existence
167      */
168     function totalSupply() public view returns (uint256) {
169         return _totalSupply;
170     }
171 
172     /**
173      * @dev Gets the balance of the specified address.
174      * @param owner The address to query the balance of.
175      * @return A uint256 representing the amount owned by the passed address.
176      */
177     function balanceOf(address owner) public view returns (uint256) {
178         return _balances[owner];
179     }
180 
181     /**
182      * @dev Function to check the amount of tokens that an owner allowed to a spender.
183      * @param owner address The address which owns the funds.
184      * @param spender address The address which will spend the funds.
185      * @return A uint256 specifying the amount of tokens still available for the spender.
186      */
187     function allowance(address owner, address spender) public view returns (uint256) {
188         return _allowed[owner][spender];
189     }
190 
191     /**
192      * @dev Transfer token to a specified address
193      * @param to The address to transfer to.
194      * @param value The amount to be transferred.
195      */
196     function transfer(address to, uint256 value) public returns (bool) {
197         _transfer(msg.sender, to, value);
198         return true;
199     }
200 
201     /**
202      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203      * Beware that changing an allowance with this method brings the risk that someone may use both the old
204      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      * @param spender The address which will spend the funds.
208      * @param value The amount of tokens to be spent.
209      */
210     function approve(address spender, uint256 value) public returns (bool) {
211         _approve(msg.sender, spender, value);
212         return true;
213     }
214 
215     /**
216      * @dev Transfer tokens from one address to another.
217      * Note that while this function emits an Approval event, this is not required as per the specification,
218      * and other compliant implementations may not emit the event.
219      * @param from address The address which you want to send tokens from
220      * @param to address The address which you want to transfer to
221      * @param value uint256 the amount of tokens to be transferred
222      */
223     function transferFrom(address from, address to, uint256 value) public returns (bool) {
224         _transfer(from, to, value);
225         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
226         return true;
227     }
228 
229     /**
230      * @dev Increase the amount of tokens that an owner allowed to a spender.
231      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * Emits an Approval event.
236      * @param spender The address which will spend the funds.
237      * @param addedValue The amount of tokens to increase the allowance by.
238      */
239     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
240         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
241         return true;
242     }
243 
244     /**
245      * @dev Decrease the amount of tokens that an owner allowed to a spender.
246      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
247      * allowed value is better to use this function to avoid 2 calls (and wait until
248      * the first transaction is mined)
249      * From MonolithDAO Token.sol
250      * Emits an Approval event.
251      * @param spender The address which will spend the funds.
252      * @param subtractedValue The amount of tokens to decrease the allowance by.
253      */
254     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
255         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
256         return true;
257     }
258 
259     /**
260      * @dev Transfer token for a specified addresses
261      * @param from The address to transfer from.
262      * @param to The address to transfer to.
263      * @param value The amount to be transferred.
264      */
265     function _transfer(address from, address to, uint256 value) internal {
266         require(to != address(0));
267 
268         _balances[from] = _balances[from].sub(value);
269         _balances[to] = _balances[to].add(value);
270         emit Transfer(from, to, value);
271     }
272 
273     /**
274      * @dev Internal function that mints an amount of the token and assigns it to
275      * an account. This encapsulates the modification of balances such that the
276      * proper events are emitted.
277      * @param account The account that will receive the created tokens.
278      * @param value The amount that will be created.
279      */
280     function _mint(address account, uint256 value) internal {
281         require(account != address(0));
282 
283         _totalSupply = _totalSupply.add(value);
284         _balances[account] = _balances[account].add(value);
285         emit Transfer(address(0), account, value);
286     }
287 
288     /**
289      * @dev Internal function that burns an amount of the token of a given
290      * account.
291      * @param account The account whose tokens will be burnt.
292      * @param value The amount that will be burnt.
293      */
294     function _burn(address account, uint256 value) internal {
295         require(account != address(0));
296 
297         _totalSupply = _totalSupply.sub(value);
298         _balances[account] = _balances[account].sub(value);
299         emit Transfer(account, address(0), value);
300     }
301 
302     /**
303      * @dev Approve an address to spend another addresses' tokens.
304      * @param owner The address that owns the tokens.
305      * @param spender The address that will spend the tokens.
306      * @param value The number of tokens that can be spent.
307      */
308     function _approve(address owner, address spender, uint256 value) internal {
309         require(spender != address(0));
310         require(owner != address(0));
311 
312         _allowed[owner][spender] = value;
313         emit Approval(owner, spender, value);
314     }
315 
316     /**
317      * @dev Internal function that burns an amount of the token of a given
318      * account, deducting from the sender's allowance for said account. Uses the
319      * internal burn function.
320      * Emits an Approval event (reflecting the reduced allowance).
321      * @param account The account whose tokens will be burnt.
322      * @param value The amount that will be burnt.
323      */
324     function _burnFrom(address account, uint256 value) internal {
325         _burn(account, value);
326         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
327     }
328 }
329 
330 contract ERC20Burnable is ERC20 {
331     /**
332      * @dev Burns a specific amount of tokens.
333      * @param value The amount of token to be burned.
334      */
335     function burn(uint256 value) public {
336         _burn(msg.sender, value);
337     }
338 
339     /**
340      * @dev Burns a specific amount of tokens from the target address and decrements allowance
341      * @param from address The account whose tokens will be burned.
342      * @param value uint256 The amount of token to be burned.
343      */
344     function burnFrom(address from, uint256 value) public {
345         _burnFrom(from, value);
346     }
347 }
348 
349 contract ERC20Detailed is IERC20 {
350     string private _name;
351     string private _symbol;
352     uint8 private _decimals;
353 
354     constructor (string memory name, string memory symbol, uint8 decimals) public {
355         _name = name;
356         _symbol = symbol;
357         _decimals = decimals;
358     }
359 
360     /**
361      * @return the name of the token.
362      */
363     function name() public view returns (string memory) {
364         return _name;
365     }
366 
367     /**
368      * @return the symbol of the token.
369      */
370     function symbol() public view returns (string memory) {
371         return _symbol;
372     }
373 
374     /**
375      * @return the number of decimals of the token.
376      */
377     function decimals() public view returns (uint8) {
378         return _decimals;
379     }
380 }
381 
382 contract ERC20Mintable is ERC20, MinterRole {
383     /**
384      * @dev Function to mint tokens
385      * @param to The address that will receive the minted tokens.
386      * @param value The amount of tokens to mint.
387      * @return A boolean that indicates if the operation was successful.
388      */
389     function mint(address to, uint256 value) public onlyMinter returns (bool) {
390         _mint(to, value);
391         return true;
392     }
393 }
394 
395 contract ERC20Capped is ERC20Mintable {
396     uint256 private _cap;
397 
398     constructor (uint256 cap) public {
399         require(cap > 0);
400         _cap = cap;
401     }
402 
403     /**
404      * @return the cap for the token minting.
405      */
406     function cap() public view returns (uint256) {
407         return _cap;
408     }
409 
410     function _mint(address account, uint256 value) internal {
411         require(totalSupply().add(value) <= _cap);
412         super._mint(account, value);
413     }
414 }
415 
416 contract CustomToken is ERC20, ERC20Detailed, ERC20Capped, ERC20Burnable {
417     constructor(
418             string memory _name,
419             string memory _symbol,
420             uint8 _decimals,
421             uint256 _maxSupply
422         )
423         ERC20Burnable()
424         ERC20Capped(_maxSupply)
425         ERC20Detailed(_name, _symbol, _decimals)
426         ERC20()
427         public {
428             
429         }
430 }
431 
432 contract TCGToken is CustomToken {
433     uint8 private DECIMALS = 18; //자리수
434     uint256 private MAX_TOKEN_COUNT = 1000000000;   // 총 토큰 개수
435     uint256 private MAX_SUPPLY = MAX_TOKEN_COUNT * (10 ** uint256(DECIMALS)); //총 발행량 %
436     uint256 private INITIAL_SUPPLY = MAX_SUPPLY * 10 / 10; //초기 공급량 %
437 
438     bool private issued = false;
439 
440     constructor()
441         CustomToken("T-Comm Global", "TCG", DECIMALS, MAX_SUPPLY)
442         public {
443             require(issued == false);
444             super.mint(msg.sender, INITIAL_SUPPLY);
445             issued = true;
446     }
447 
448 }