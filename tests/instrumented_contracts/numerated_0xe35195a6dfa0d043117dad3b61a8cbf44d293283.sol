1 pragma solidity ^0.5;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     /**
23     * @dev Multiplies two unsigned integers, reverts on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62     * @dev Adds two unsigned integers, reverts on overflow.
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73     * reverts when dividing by zero.
74     */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85 
86     mapping (address => mapping (address => uint256)) private _allowed;
87 
88     uint256 private _totalSupply;
89 
90     /**
91     * @dev Total number of tokens in existence
92     */
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply;
95     }
96 
97     /**
98     * @dev Gets the balance of the specified address.
99     * @param owner The address to query the balance of.
100     * @return An uint256 representing the amount owned by the passed address.
101     */
102     function balanceOf(address owner) public view returns (uint256) {
103         return _balances[owner];
104     }
105 
106     /**
107      * @dev Function to check the amount of tokens that an owner allowed to a spender.
108      * @param owner address The address which owns the funds.
109      * @param spender address The address which will spend the funds.
110      * @return A uint256 specifying the amount of tokens still available for the spender.
111      */
112     function allowance(address owner, address spender) public view returns (uint256) {
113         return _allowed[owner][spender];
114     }
115 
116     /**
117     * @dev Transfer token for a specified address
118     * @param to The address to transfer to.
119     * @param value The amount to be transferred.
120     */
121     function transfer(address to, uint256 value) public returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param spender The address which will spend the funds.
133      * @param value The amount of tokens to be spent.
134      */
135     function approve(address spender, uint256 value) public returns (bool) {
136         require(spender != address(0));
137 
138         _allowed[msg.sender][spender] = value;
139         emit Approval(msg.sender, spender, value);
140         return true;
141     }
142 
143     /**
144      * @dev Transfer tokens from one address to another.
145      * Note that while this function emits an Approval event, this is not required as per the specification,
146      * and other compliant implementations may not emit the event.
147      * @param from address The address which you want to send tokens from
148      * @param to address The address which you want to transfer to
149      * @param value uint256 the amount of tokens to be transferred
150      */
151     function transferFrom(address from, address to, uint256 value) public returns (bool) {
152         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
153         _transfer(from, to, value);
154         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
155         return true;
156     }
157 
158     /**
159      * @dev Increase the amount of tokens that an owner allowed to a spender.
160      * approve should be called when allowed_[_spender] == 0. To increment
161      * allowed value is better to use this function to avoid 2 calls (and wait until
162      * the first transaction is mined)
163      * From MonolithDAO Token.sol
164      * Emits an Approval event.
165      * @param spender The address which will spend the funds.
166      * @param addedValue The amount of tokens to increase the allowance by.
167      */
168     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
169         require(spender != address(0));
170 
171         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
172         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173         return true;
174     }
175 
176     /**
177      * @dev Decrease the amount of tokens that an owner allowed to a spender.
178      * approve should be called when allowed_[_spender] == 0. To decrement
179      * allowed value is better to use this function to avoid 2 calls (and wait until
180      * the first transaction is mined)
181      * From MonolithDAO Token.sol
182      * Emits an Approval event.
183      * @param spender The address which will spend the funds.
184      * @param subtractedValue The amount of tokens to decrease the allowance by.
185      */
186     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
187         require(spender != address(0));
188 
189         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
190         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
191         return true;
192     }
193 
194     /**
195     * @dev Transfer token for a specified addresses
196     * @param from The address to transfer from.
197     * @param to The address to transfer to.
198     * @param value The amount to be transferred.
199     */
200     function _transfer(address from, address to, uint256 value) internal {
201         require(to != address(0));
202 
203         _balances[from] = _balances[from].sub(value);
204         _balances[to] = _balances[to].add(value);
205         emit Transfer(from, to, value);
206     }
207 
208     /**
209      * @dev Internal function that mints an amount of the token and assigns it to
210      * an account. This encapsulates the modification of balances such that the
211      * proper events are emitted.
212      * @param account The account that will receive the created tokens.
213      * @param value The amount that will be created.
214      */
215     function _mint(address account, uint256 value) internal {
216         require(account != address(0));
217 
218         _totalSupply = _totalSupply.add(value);
219         _balances[account] = _balances[account].add(value);
220         emit Transfer(address(0), account, value);
221     }
222 
223     /**
224      * @dev Internal function that burns an amount of the token of a given
225      * account.
226      * @param account The account whose tokens will be burnt.
227      * @param value The amount that will be burnt.
228      */
229     function _burn(address account, uint256 value) internal {
230         require(account != address(0));
231 
232         _totalSupply = _totalSupply.sub(value);
233         _balances[account] = _balances[account].sub(value);
234         emit Transfer(account, address(0), value);
235     }
236 
237     /**
238      * @dev Internal function that burns an amount of the token of a given
239      * account, deducting from the sender's allowance for said account. Uses the
240      * internal burn function.
241      * Emits an Approval event (reflecting the reduced allowance).
242      * @param account The account whose tokens will be burnt.
243      * @param value The amount that will be burnt.
244      */
245     function _burnFrom(address account, uint256 value) internal {
246         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
247         _burn(account, value);
248         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
249     }
250 }
251 contract ERC20Detailed is IERC20 {
252     string private _name;
253     string private _symbol;
254     uint8 private _decimals;
255 
256     constructor (string memory name, string memory symbol, uint8 decimals) public {
257         _name = name;
258         _symbol = symbol;
259         _decimals = decimals;
260     }
261 
262     /**
263      * @return the name of the token.
264      */
265     function name() public view returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @return the symbol of the token.
271      */
272     function symbol() public view returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @return the number of decimals of the token.
278      */
279     function decimals() public view returns (uint8) {
280         return _decimals;
281     }
282 }
283 
284 library Roles {
285     struct Role {
286         mapping (address => bool) bearer;
287     }
288 
289     /**
290      * @dev give an account access to this role
291      */
292     function add(Role storage role, address account) internal {
293         require(account != address(0));
294         require(!has(role, account));
295 
296         role.bearer[account] = true;
297     }
298 
299     /**
300      * @dev remove an account's access to this role
301      */
302     function remove(Role storage role, address account) internal {
303         require(account != address(0));
304         require(has(role, account));
305 
306         role.bearer[account] = false;
307     }
308 
309     /**
310      * @dev check if an account has this role
311      * @return bool
312      */
313     function has(Role storage role, address account) internal view returns (bool) {
314         require(account != address(0));
315         return role.bearer[account];
316     }
317 }
318 
319 
320 contract MinterRole {
321     using Roles for Roles.Role;
322 
323     event MinterAdded(address indexed account);
324     event MinterRemoved(address indexed account);
325 
326     Roles.Role private _minters;
327 
328     constructor () internal {
329         _addMinter(msg.sender);
330     }
331 
332     modifier onlyMinter() {
333         require(isMinter(msg.sender));
334         _;
335     }
336 
337     function isMinter(address account) public view returns (bool) {
338         return _minters.has(account);
339     }
340 
341     function addMinter(address account) public onlyMinter {
342         _addMinter(account);
343     }
344 
345     function renounceMinter() public {
346         _removeMinter(msg.sender);
347     }
348 
349     function _addMinter(address account) internal {
350         _minters.add(account);
351         emit MinterAdded(account);
352     }
353 
354     function _removeMinter(address account) internal {
355         _minters.remove(account);
356         emit MinterRemoved(account);
357     }
358 }
359 
360 contract ERC20Mintable is ERC20, MinterRole {
361     /**
362      * @dev Function to mint tokens
363      * @param to The address that will receive the minted tokens.
364      * @param value The amount of tokens to mint.
365      * @return A boolean that indicates if the operation was successful.
366      */
367     function mint(address to, uint256 value) public onlyMinter returns (bool) {
368         _mint(to, value);
369         return true;
370     }
371 }
372 contract ERC20Burnable is ERC20 {
373     /**
374      * @dev Burns a specific amount of tokens.
375      * @param value The amount of token to be burned.
376      */
377     function burn(uint256 value) public {
378         _burn(msg.sender, value);
379     }
380 
381     /**
382      * @dev Burns a specific amount of tokens from the target address and decrements allowance
383      * @param from address The address which you want to send tokens from
384      * @param value uint256 The amount of token to be burned
385      */
386     function burnFrom(address from, uint256 value) public {
387         _burnFrom(from, value);
388     }
389 }
390 
391 
392 contract ValentineToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
393 
394     constructor(
395     )
396         ERC20Burnable()
397         ERC20Mintable()
398         ERC20Detailed("Valentine", "VAL", 8)
399         ERC20()
400         public
401     {}
402 }