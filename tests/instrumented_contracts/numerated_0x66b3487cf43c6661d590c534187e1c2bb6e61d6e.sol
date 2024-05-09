1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address who) external view returns (uint256);
7 
8     function allowance(address owner, address spender) external view returns (uint256);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26     /**
27     * @dev Multiplies two numbers, reverts on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66     * @dev Adds two numbers, reverts on overflow.
67     */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
77     * reverts when dividing by zero.
78     */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 contract ERC20 is IERC20 {
86     using SafeMath for uint256;
87 
88     mapping (address => uint256) private _balances;
89 
90     mapping (address => mapping (address => uint256)) private _allowed;
91 
92     uint256 private _totalSupply;
93 
94     /**
95     * @dev Total number of tokens in existence
96     */
97     function totalSupply() public view returns (uint256) {
98         return _totalSupply;
99     }
100 
101     /**
102     * @dev Gets the balance of the specified address.
103     * @param owner The address to query the balance of.
104     * @return An uint256 representing the amount owned by the passed address.
105     */
106     function balanceOf(address owner) public view returns (uint256) {
107         return _balances[owner];
108     }
109 
110     /**
111      * @dev Function to check the amount of tokens that an owner allowed to a spender.
112      * @param owner address The address which owns the funds.
113      * @param spender address The address which will spend the funds.
114      * @return A uint256 specifying the amount of tokens still available for the spender.
115      */
116     function allowance(address owner, address spender) public view returns (uint256) {
117         return _allowed[owner][spender];
118     }
119 
120     /**
121     * @dev Transfer token for a specified address
122     * @param to The address to transfer to.
123     * @param value The amount to be transferred.
124     */
125     function transfer(address to, uint256 value) public returns (bool) {
126         _transfer(msg.sender, to, value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      * Beware that changing an allowance with this method brings the risk that someone may use both the old
133      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      * @param spender The address which will spend the funds.
137      * @param value The amount of tokens to be spent.
138      */
139     function approve(address spender, uint256 value) public returns (bool) {
140         require(spender != address(0));
141 
142         _allowed[msg.sender][spender] = value;
143         emit Approval(msg.sender, spender, value);
144         return true;
145     }
146 
147     /**
148      * @dev Transfer tokens from one address to another.
149      * Note that while this function emits an Approval event, this is not required as per the specification,
150      * and other compliant implementations may not emit the event.
151      * @param from address The address which you want to send tokens from
152      * @param to address The address which you want to transfer to
153      * @param value uint256 the amount of tokens to be transferred
154      */
155     function transferFrom(address from, address to, uint256 value) public returns (bool) {
156         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
157         _transfer(from, to, value);
158         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
159         return true;
160     }
161 
162     /**
163      * @dev Increase the amount of tokens that an owner allowed to a spender.
164      * approve should be called when allowed_[_spender] == 0. To increment
165      * allowed value is better to use this function to avoid 2 calls (and wait until
166      * the first transaction is mined)
167      * From MonolithDAO Token.sol
168      * Emits an Approval event.
169      * @param spender The address which will spend the funds.
170      * @param addedValue The amount of tokens to increase the allowance by.
171      */
172     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
173         require(spender != address(0));
174 
175         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
176         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
177         return true;
178     }
179 
180     /**
181      * @dev Decrease the amount of tokens that an owner allowed to a spender.
182      * approve should be called when allowed_[_spender] == 0. To decrement
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * Emits an Approval event.
187      * @param spender The address which will spend the funds.
188      * @param subtractedValue The amount of tokens to decrease the allowance by.
189      */
190     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
191         require(spender != address(0));
192 
193         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
194         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
195         return true;
196     }
197 
198     /**
199     * @dev Transfer token for a specified addresses
200     * @param from The address to transfer from.
201     * @param to The address to transfer to.
202     * @param value The amount to be transferred.
203     */
204     function _transfer(address from, address to, uint256 value) internal {
205         require(to != address(0));
206 
207         _balances[from] = _balances[from].sub(value);
208         _balances[to] = _balances[to].add(value);
209         emit Transfer(from, to, value);
210     }
211 
212     /**
213      * @dev Internal function that mints an amount of the token and assigns it to
214      * an account. This encapsulates the modification of balances such that the
215      * proper events are emitted.
216      * @param account The account that will receive the created tokens.
217      * @param value The amount that will be created.
218      */
219     function _mint(address account, uint256 value) internal {
220         require(account != address(0));
221 
222         _totalSupply = _totalSupply.add(value);
223         _balances[account] = _balances[account].add(value);
224         emit Transfer(address(0), account, value);
225     }
226 
227     /**
228      * @dev Internal function that burns an amount of the token of a given
229      * account.
230      * @param account The account whose tokens will be burnt.
231      * @param value The amount that will be burnt.
232      */
233     function _burn(address account, uint256 value) internal {
234         require(account != address(0));
235 
236         _totalSupply = _totalSupply.sub(value);
237         _balances[account] = _balances[account].sub(value);
238         emit Transfer(account, address(0), value);
239     }
240 
241     /**
242      * @dev Internal function that burns an amount of the token of a given
243      * account, deducting from the sender's allowance for said account. Uses the
244      * internal burn function.
245      * Emits an Approval event (reflecting the reduced allowance).
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burnFrom(address account, uint256 value) internal {
250         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
251         _burn(account, value);
252         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
253     }
254 }
255 
256 library Roles {
257     struct Role {
258         mapping (address => bool) bearer;
259     }
260 
261     /**
262      * @dev give an account access to this role
263      */
264     function add(Role storage role, address account) internal {
265         require(account != address(0));
266         require(!has(role, account));
267 
268         role.bearer[account] = true;
269     }
270 
271     /**
272      * @dev remove an account's access to this role
273      */
274     function remove(Role storage role, address account) internal {
275         require(account != address(0));
276         require(has(role, account));
277 
278         role.bearer[account] = false;
279     }
280 
281     /**
282      * @dev check if an account has this role
283      * @return bool
284      */
285     function has(Role storage role, address account) internal view returns (bool) {
286         require(account != address(0));
287         return role.bearer[account];
288     }
289 }
290 
291 contract MinterRole {
292     using Roles for Roles.Role;
293 
294     event MinterAdded(address indexed account);
295     event MinterRemoved(address indexed account);
296 
297     Roles.Role private _minters;
298 
299     constructor () internal {
300         _addMinter(msg.sender);
301     }
302 
303     modifier onlyMinter() {
304         require(isMinter(msg.sender));
305         _;
306     }
307 
308     function isMinter(address account) public view returns (bool) {
309         return _minters.has(account);
310     }
311 
312     function addMinter(address account) public onlyMinter {
313         _addMinter(account);
314     }
315 
316     function renounceMinter() public {
317         _removeMinter(msg.sender);
318     }
319 
320     function _addMinter(address account) internal {
321         _minters.add(account);
322         emit MinterAdded(account);
323     }
324 
325     function _removeMinter(address account) internal {
326         _minters.remove(account);
327         emit MinterRemoved(account);
328     }
329 }
330 
331 contract ERC20Mintable is ERC20, MinterRole {
332     /**
333      * @dev Function to mint tokens
334      * @param to The address that will receive the minted tokens.
335      * @param value The amount of tokens to mint.
336      * @return A boolean that indicates if the operation was successful.
337      */
338     function mint(address to, uint256 value) public onlyMinter returns (bool) {
339         _mint(to, value);
340         return true;
341     }
342 }
343 
344 contract ERC20Burnable is ERC20 {
345     /**
346      * @dev Burns a specific amount of tokens.
347      * @param value The amount of token to be burned.
348      */
349     function burn(uint256 value) public {
350         _burn(msg.sender, value);
351     }
352 
353     /**
354      * @dev Burns a specific amount of tokens from the target address and decrements allowance
355      * @param from address The address which you want to send tokens from
356      * @param value uint256 The amount of token to be burned
357      */
358     function burnFrom(address from, uint256 value) public {
359         _burnFrom(from, value);
360     }
361 }
362 
363 contract Goex is ERC20Mintable, ERC20Burnable {
364   string public name = "Goex";
365   string public symbol = "Goex";
366   uint public decimals = 8;
367 
368   /**
369    * @dev Constructor that gives msg.sender all of existing tokens.
370    */
371   constructor() public {
372   }
373 }