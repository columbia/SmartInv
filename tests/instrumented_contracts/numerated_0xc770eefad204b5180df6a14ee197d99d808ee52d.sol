1 pragma solidity 0.5.4;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     /**
24     * @dev Multiplies two unsigned integers, reverts on overflow.
25     */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b);
36 
37         return c;
38     }
39 
40     /**
41     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
42     */
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 
52     /**
53     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
54     */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63     * @dev Adds two unsigned integers, reverts on overflow.
64     */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 
72     /**
73     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
74     * reverts when dividing by zero.
75     */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 library Roles {
83     struct Role {
84         mapping (address => bool) bearer;
85     }
86 
87     /**
88      * @dev give an account access to this role
89      */
90     function add(Role storage role, address account) internal {
91         require(account != address(0));
92         require(!has(role, account));
93 
94         role.bearer[account] = true;
95     }
96 
97     /**
98      * @dev remove an account's access to this role
99      */
100     function remove(Role storage role, address account) internal {
101         require(account != address(0));
102         require(has(role, account));
103 
104         role.bearer[account] = false;
105     }
106 
107     /**
108      * @dev check if an account has this role
109      * @return bool
110      */
111     function has(Role storage role, address account) internal view returns (bool) {
112         require(account != address(0));
113         return role.bearer[account];
114     }
115 }
116 
117 contract ERC20 is IERC20 {
118     using SafeMath for uint256;
119 
120     mapping (address => uint256) private _balances;
121 
122     mapping (address => mapping (address => uint256)) private _allowed;
123 
124     uint256 private _totalSupply;
125 
126     /**
127     * @dev Total number of tokens in existence
128     */
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     /**
134     * @dev Gets the balance of the specified address.
135     * @param owner The address to query the balance of.
136     * @return An uint256 representing the amount owned by the passed address.
137     */
138     function balanceOf(address owner) public view returns (uint256) {
139         return _balances[owner];
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param owner address The address which owns the funds.
145      * @param spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address owner, address spender) public view returns (uint256) {
149         return _allowed[owner][spender];
150     }
151 
152     /**
153     * @dev Transfer token for a specified address
154     * @param to The address to transfer to.
155     * @param value The amount to be transferred.
156     */
157     function transfer(address to, uint256 value) public returns (bool) {
158         _transfer(msg.sender, to, value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param spender The address which will spend the funds.
169      * @param value The amount of tokens to be spent.
170      */
171     function approve(address spender, uint256 value) public returns (bool) {
172         require(spender != address(0));
173 
174         _allowed[msg.sender][spender] = value;
175         emit Approval(msg.sender, spender, value);
176         return true;
177     }
178 
179     /**
180      * @dev Transfer tokens from one address to another.
181      * Note that while this function emits an Approval event, this is not required as per the specification,
182      * and other compliant implementations may not emit the event.
183      * @param from address The address which you want to send tokens from
184      * @param to address The address which you want to transfer to
185      * @param value uint256 the amount of tokens to be transferred
186      */
187     function transferFrom(address from, address to, uint256 value) public returns (bool) {
188         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
189         _transfer(from, to, value);
190         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
191         return true;
192     }
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      * approve should be called when allowed_[_spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param addedValue The amount of tokens to increase the allowance by.
203      */
204     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
205         require(spender != address(0));
206 
207         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
208         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
209         return true;
210     }
211 
212     /**
213      * @dev Decrease the amount of tokens that an owner allowed to a spender.
214      * approve should be called when allowed_[_spender] == 0. To decrement
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * Emits an Approval event.
219      * @param spender The address which will spend the funds.
220      * @param subtractedValue The amount of tokens to decrease the allowance by.
221      */
222     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
223         require(spender != address(0));
224 
225         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
226         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227         return true;
228     }
229 
230     /**
231     * @dev Transfer token for a specified addresses
232     * @param from The address to transfer from.
233     * @param to The address to transfer to.
234     * @param value The amount to be transferred.
235     */
236     function _transfer(address from, address to, uint256 value) internal {
237         require(to != address(0));
238 
239         _balances[from] = _balances[from].sub(value);
240         _balances[to] = _balances[to].add(value);
241         emit Transfer(from, to, value);
242     }
243 
244     /**
245      * @dev Internal function that mints an amount of the token and assigns it to
246      * an account. This encapsulates the modification of balances such that the
247      * proper events are emitted.
248      * @param account The account that will receive the created tokens.
249      * @param value The amount that will be created.
250      */
251     function _mint(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.add(value);
255         _balances[account] = _balances[account].add(value);
256         emit Transfer(address(0), account, value);
257     }
258 
259     /**
260      * @dev Internal function that burns an amount of the token of a given
261      * account.
262      * @param account The account whose tokens will be burnt.
263      * @param value The amount that will be burnt.
264      */
265     function _burn(address account, uint256 value) internal {
266         require(account != address(0));
267 
268         _totalSupply = _totalSupply.sub(value);
269         _balances[account] = _balances[account].sub(value);
270         emit Transfer(account, address(0), value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
283         _burn(account, value);
284         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
285     }
286 }
287 
288 contract MinterRole {
289     using Roles for Roles.Role;
290 
291     event MinterAdded(address indexed account);
292     event MinterRemoved(address indexed account);
293 
294     Roles.Role private _minters;
295 
296     constructor () internal {
297         _addMinter(msg.sender);
298     }
299 
300     modifier onlyMinter() {
301         require(isMinter(msg.sender));
302         _;
303     }
304 
305     function isMinter(address account) public view returns (bool) {
306         return _minters.has(account);
307     }
308 
309     function addMinter(address account) public onlyMinter {
310         _addMinter(account);
311     }
312 
313     function renounceMinter() public {
314         _removeMinter(msg.sender);
315     }
316 
317     function _addMinter(address account) internal {
318         _minters.add(account);
319         emit MinterAdded(account);
320     }
321 
322     function _removeMinter(address account) internal {
323         _minters.remove(account);
324         emit MinterRemoved(account);
325     }
326 }
327 
328 contract ERC20Mintable is ERC20, MinterRole {
329     /**
330      * @dev Function to mint tokens
331      * @param to The address that will receive the minted tokens.
332      * @param value The amount of tokens to mint.
333      * @return A boolean that indicates if the operation was successful.
334      */
335     function mint(address to, uint256 value) public onlyMinter returns (bool) {
336         _mint(to, value);
337         return true;
338     }
339 }
340 
341 contract ERC20Capped is ERC20Mintable {
342     uint256 private _cap;
343 
344     constructor (uint256 cap) public {
345         require(cap > 0);
346         _cap = cap;
347     }
348 
349     /**
350      * @return the cap for the token minting.
351      */
352     function cap() public view returns (uint256) {
353         return _cap;
354     }
355 
356     function _mint(address account, uint256 value) internal {
357         require(totalSupply().add(value) <= _cap);
358         super._mint(account, value);
359     }
360 }
361 
362 contract FOX is ERC20, ERC20Capped {
363 	
364 	string public constant name = "FOX";
365 	string public constant symbol = "FOX";
366 	uint8 public constant decimals = 18;
367 
368 	constructor() ERC20Capped(1000001337 * (uint(10) ** decimals)) public {
369 		mint(msg.sender, 1000001337 * (uint(10) ** decimals));
370 	}
371 }