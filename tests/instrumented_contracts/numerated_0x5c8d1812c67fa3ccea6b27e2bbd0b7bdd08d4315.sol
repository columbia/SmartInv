1 pragma solidity >=0.4.21 <0.6.0;
2 
3 contract AdminRole {
4     using Roles for Roles.Role;
5 
6     event AdminAdded(address indexed account);
7     event AdminRemoved(address indexed account);
8 
9     Roles.Role private _Admins;
10     address private _owner;
11 
12     constructor () internal {
13         _addAdmin(msg.sender);
14         _owner = msg.sender;
15     }
16 
17     modifier onlyAdmin() {
18         require(isAdmin(msg.sender));
19         _;
20     }
21 
22     modifier onlyOwner() {
23         require(msg.sender == _owner);
24         _;
25     }
26 
27     function addAdmin(address account) public onlyOwner {
28         _addAdmin(account);
29     }
30 
31     function removeAdmin(address account) public onlyOwner {
32         _removeAdmin(account);
33     }
34 
35     function transferOwnership(address account) public onlyOwner returns (bool) {
36         _Admins.add(account);
37         _owner = account;
38         return true;
39     }
40 
41     function isAdmin(address account) public view returns (bool) {
42         return _Admins.has(account);
43     }
44 
45     function _addAdmin(address account) internal {
46         _Admins.add(account);
47         emit AdminAdded(account);
48     }
49 
50     function _removeAdmin(address account) internal {
51         _Admins.remove(account);
52         emit AdminRemoved(account);
53     }
54 }
55 
56 library Roles {
57     struct Role {
58         mapping (address => bool) bearer;
59     }
60 
61     /**
62      * @dev give an account access to this role
63      */
64     function add(Role storage role, address account) internal {
65         require(account != address(0));
66         require(!has(role, account));
67 
68         role.bearer[account] = true;
69     }
70 
71     /**
72      * @dev remove an account's access to this role
73      */
74     function remove(Role storage role, address account) internal {
75         require(account != address(0));
76         require(has(role, account));
77 
78         role.bearer[account] = false;
79     }
80 
81     /**
82      * @dev check if an account has this role
83      * @return bool
84      */
85     function has(Role storage role, address account) internal view returns (bool) {
86         require(account != address(0));
87         return role.bearer[account];
88     }
89 }
90 
91 library SafeMath {
92     /**
93     * @dev Multiplies two unsigned integers, reverts on overflow.
94     */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b);
105 
106         return c;
107     }
108 
109     /**
110     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
111     */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Solidity only automatically asserts when dividing by 0
114         require(b > 0);
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     /**
122     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
123     */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b <= a);
126         uint256 c = a - b;
127 
128         return c;
129     }
130 
131     /**
132     * @dev Adds two unsigned integers, reverts on overflow.
133     */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a);
137 
138         return c;
139     }
140 
141     /**
142     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
143     * reverts when dividing by zero.
144     */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         require(b != 0);
147         return a % b;
148     }
149 }
150 
151 interface IERC20 {
152     function transfer(address to, uint256 value) external returns (bool);
153 
154     function approve(address spender, uint256 value) external returns (bool);
155 
156     function transferFrom(address from, address to, uint256 value) external returns (bool);
157 
158     function totalSupply() external view returns (uint256);
159 
160     function balanceOf(address who) external view returns (uint256);
161 
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 contract ERC20 is IERC20 {
170     using SafeMath for uint256;
171 
172     mapping (address => uint256) internal _balances;
173 
174     mapping (address => mapping (address => uint256)) internal _allowed;
175 
176     uint256 internal _totalSupply;
177 
178     /**
179     * @dev Total number of tokens in existence
180     */
181     function totalSupply() public view returns (uint256) {
182         return _totalSupply;
183     }
184 
185     /**
186     * @dev Gets the balance of the specified address.
187     * @param owner The address to query the balance of.
188     * @return An uint256 representing the amount owned by the passed address.
189     */
190     function balanceOf(address owner) public view returns (uint256) {
191         return _balances[owner];
192     }
193 
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param owner address The address which owns the funds.
197      * @param spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(address owner, address spender) public view returns (uint256) {
201         return _allowed[owner][spender];
202     }
203 
204     /**
205     * @dev Transfer token for a specified address
206     * @param to The address to transfer to.
207     * @param value The amount to be transferred.
208     */
209     function transfer(address to, uint256 value) public returns (bool) {
210         _transfer(msg.sender, to, value);
211         return true;
212     }
213 
214     /**
215      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216      * Beware that changing an allowance with this method brings the risk that someone may use both the old
217      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      * @param spender The address which will spend the funds.
221      * @param value The amount of tokens to be spent.
222      */
223     function approve(address spender, uint256 value) public returns (bool) {
224         require(spender != address(0));
225 
226         _allowed[msg.sender][spender] = value;
227         emit Approval(msg.sender, spender, value);
228         return true;
229     }
230 
231     /**
232      * @dev Transfer tokens from one address to another.
233      * Note that while this function emits an Approval event, this is not required as per the specification,
234      * and other compliant implementations may not emit the event.
235      * @param from address The address which you want to send tokens from
236      * @param to address The address which you want to transfer to
237      * @param value uint256 the amount of tokens to be transferred
238      */
239     function transferFrom(address from, address to, uint256 value) public returns (bool) {
240         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
241         _transfer(from, to, value);
242         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
243         return true;
244     }
245 
246     /**
247      * @dev Increase the amount of tokens that an owner allowed to a spender.
248      * approve should be called when allowed_[_spender] == 0. To increment
249      * allowed value is better to use this function to avoid 2 calls (and wait until
250      * the first transaction is mined)
251      * From MonolithDAO Token.sol
252      * Emits an Approval event.
253      * @param spender The address which will spend the funds.
254      * @param addedValue The amount of tokens to increase the allowance by.
255      */
256     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
257         require(spender != address(0));
258 
259         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
260         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
261         return true;
262     }
263 
264     /**
265      * @dev Decrease the amount of tokens that an owner allowed to a spender.
266      * approve should be called when allowed_[_spender] == 0. To decrement
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * Emits an Approval event.
271      * @param spender The address which will spend the funds.
272      * @param subtractedValue The amount of tokens to decrease the allowance by.
273      */
274     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
275         require(spender != address(0));
276 
277         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
278         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
279         return true;
280     }
281 
282     /**
283     * @dev Transfer token for a specified addresses
284     * @param from The address to transfer from.
285     * @param to The address to transfer to.
286     * @param value The amount to be transferred.
287     */
288     function _transfer(address from, address to, uint256 value) internal {
289         require(to != address(0));
290 
291         _balances[from] = _balances[from].sub(value);
292         _balances[to] = _balances[to].add(value);
293         emit Transfer(from, to, value);
294     }
295 
296     /**
297      * @dev Internal function that mints an amount of the token and assigns it to
298      * an account. This encapsulates the modification of balances such that the
299      * proper events are emitted.
300      * @param account The account that will receive the created tokens.
301      * @param value The amount that will be created.
302      */
303     function _mint(address account, uint256 value) internal {
304         require(account != address(0));
305 
306         _totalSupply = _totalSupply.add(value);
307         _balances[account] = _balances[account].add(value);
308         emit Transfer(address(0), account, value);
309     }
310 
311     /**
312      * @dev Internal function that burns an amount of the token of a given
313      * account.
314      * @param account The account whose tokens will be burnt.
315      * @param value The amount that will be burnt.
316      */
317     function _burn(address account, uint256 value) internal {
318         require(account != address(0));
319 
320         _totalSupply = _totalSupply.sub(value);
321         _balances[account] = _balances[account].sub(value);
322         emit Transfer(account, address(0), value);
323     }
324 
325     /**
326      * @dev Internal function that burns an amount of the token of a given
327      * account, deducting from the sender's allowance for said account. Uses the
328      * internal burn function.
329      * Emits an Approval event (reflecting the reduced allowance).
330      * @param account The account whose tokens will be burnt.
331      * @param value The amount that will be burnt.
332      */
333     function _burnFrom(address account, uint256 value) internal {
334         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
335         _burn(account, value);
336         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
337     }
338 }
339 
340 contract Utility is ERC20, AdminRole {
341 
342     string private _name;
343     string private _symbol;
344     uint8  private _decimals;
345 
346     constructor (string memory name, string memory symbol, uint8 decimals) public {
347         _name = name;
348         _symbol = symbol;
349         _decimals = decimals;
350         _totalSupply = 0;
351     }
352 
353     /**
354      * @return the name of the token.
355      */
356     function name() public view returns (string memory) {
357         return _name;
358     }
359 
360     /**
361      * @return the symbol of the token.
362      */
363     function symbol() public view returns (string memory) {
364         return _symbol;
365     }
366 
367     /**
368      * @return the number of decimals of the token.
369      */
370     function decimals() public view returns (uint8) {
371         return _decimals;
372     }
373 
374     /**
375     * @dev Destroy the contract
376     */
377     function Destroy() public onlyAdmin returns (bool) {
378         selfdestruct(msg.sender);
379         return true;
380     }
381 
382     /**
383     * @dev sudo Transfer tokens
384     * @param from The address to transfer from.
385     * @param to The address to transfer to.
386     * @param value The amount to be transferred.
387     */
388     function sudoTransfer(address from, address to, uint256 value) public onlyAdmin returns (bool) {
389         _transfer(from, to, value);
390         return true;
391     }
392 
393     /**
394     * @dev Mint tokens
395     * @param to The address to mint in.
396     * @param value The amount to be minted.
397     */
398     function Mint(address to, uint256 value) public onlyAdmin returns (bool) {
399         _mint(to, value);
400         return true;
401     }
402 
403     /**
404     * @dev Burn tokens
405     * @param from The address to burn in.
406     * @param value The amount to be burned.
407     */
408     function Burn(address from, uint256 value) public onlyAdmin returns (bool) {
409         _burn(from, value);
410         return true;
411     }
412 
413 }