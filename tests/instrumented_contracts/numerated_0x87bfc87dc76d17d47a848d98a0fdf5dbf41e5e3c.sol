1 pragma solidity ^0.5.0;
2 
3 
4 // Imports
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
95  * Originally based on code by FirstBlood:
96  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  *
98  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
99  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
100  * compliant implementations may not do it.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110 
111     /**
112     * @dev Total number of tokens in existence
113     */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param owner The address to query the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138     * @dev Transfer token for a specified address
139     * @param to The address to transfer to.
140     * @param value The amount to be transferred.
141     */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param spender The address which will spend the funds.
154      * @param value The amount of tokens to be spent.
155      */
156     function approve(address spender, uint256 value) public returns (bool) {
157         require(spender != address(0));
158 
159         _allowed[msg.sender][spender] = value;
160         emit Approval(msg.sender, spender, value);
161         return true;
162     }
163 
164     /**
165      * @dev Transfer tokens from one address to another.
166      * Note that while this function emits an Approval event, this is not required as per the specification,
167      * and other compliant implementations may not emit the event.
168      * @param from address The address which you want to send tokens from
169      * @param to address The address which you want to transfer to
170      * @param value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address from, address to, uint256 value) public returns (bool) {
173         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
174         _transfer(from, to, value);
175         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when allowed_[_spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         require(spender != address(0));
191 
192         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
193         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed_[_spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
211         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
212         return true;
213     }
214 
215     /**
216     * @dev Transfer token for a specified addresses
217     * @param from The address to transfer from.
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * Emits an Approval event (reflecting the reduced allowance).
263      * @param account The account whose tokens will be burnt.
264      * @param value The amount that will be burnt.
265      */
266     function _burnFrom(address account, uint256 value) internal {
267         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
268         _burn(account, value);
269         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
270     }
271 }
272 /**
273  * @title Roles
274  * @dev Library for managing addresses assigned to a Role.
275  */
276 library Roles {
277     struct Role {
278         mapping (address => bool) bearer;
279     }
280 
281     /**
282      * @dev give an account access to this role
283      */
284     function add(Role storage role, address account) internal {
285         require(account != address(0));
286         require(!has(role, account));
287 
288         role.bearer[account] = true;
289     }
290 
291     /**
292      * @dev remove an account's access to this role
293      */
294     function remove(Role storage role, address account) internal {
295         require(account != address(0));
296         require(has(role, account));
297 
298         role.bearer[account] = false;
299     }
300 
301     /**
302      * @dev check if an account has this role
303      * @return bool
304      */
305     function has(Role storage role, address account) internal view returns (bool) {
306         require(account != address(0));
307         return role.bearer[account];
308     }
309 }
310 
311 contract MinterRole {
312     using Roles for Roles.Role;
313 
314     event MinterAdded(address indexed account);
315     event MinterRemoved(address indexed account);
316 
317     Roles.Role private _minters;
318 
319     constructor () internal {
320         _addMinter(msg.sender);
321     }
322 
323     modifier onlyMinter() {
324         require(isMinter(msg.sender));
325         _;
326     }
327 
328     function isMinter(address account) public view returns (bool) {
329         return _minters.has(account);
330     }
331 
332     function addMinter(address account) public onlyMinter {
333         _addMinter(account);
334     }
335 
336     function renounceMinter() public {
337         _removeMinter(msg.sender);
338     }
339 
340     function _addMinter(address account) internal {
341         _minters.add(account);
342         emit MinterAdded(account);
343     }
344 
345     function _removeMinter(address account) internal {
346         _minters.remove(account);
347         emit MinterRemoved(account);
348     }
349 }
350 
351 /**
352  * @title ERC20Mintable
353  * @dev ERC20 minting logic
354  */
355 contract ERC20Mintable is ERC20, MinterRole {
356     /**
357      * @dev Function to mint tokens
358      * @param to The address that will receive the minted tokens.
359      * @param value The amount of tokens to mint.
360      * @return A boolean that indicates if the operation was successful.
361      */
362     function mint(address to, uint256 value) public onlyMinter returns (bool) {
363         _mint(to, value);
364         return true;
365     }
366 }
367 
368 // Main token smart contract
369 contract GRAM is ERC20Mintable {
370   string public constant name = "GRAM Token";
371   string public constant symbol = "GRAM";
372   uint8 public constant decimals = 18;
373 }