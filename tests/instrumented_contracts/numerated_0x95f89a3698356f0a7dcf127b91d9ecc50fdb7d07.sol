1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract ERC20 is IERC20 {
26     using SafeMath for uint256;
27 
28     mapping (address => uint256) private _balances;
29 
30     mapping (address => mapping (address => uint256)) private _allowed;
31 
32     uint256 private _totalSupply;
33 
34     /**
35      * @dev Total number of tokens in existence
36      */
37     function totalSupply() public view returns (uint256) {
38         return _totalSupply;
39     }
40 
41     /**
42      * @dev Gets the balance of the specified address.
43      * @param owner The address to query the balance of.
44      * @return A uint256 representing the amount owned by the passed address.
45      */
46     function balanceOf(address owner) public view returns (uint256) {
47         return _balances[owner];
48     }
49 
50     /**
51      * @dev Function to check the amount of tokens that an owner allowed to a spender.
52      * @param owner address The address which owns the funds.
53      * @param spender address The address which will spend the funds.
54      * @return A uint256 specifying the amount of tokens still available for the spender.
55      */
56     function allowance(address owner, address spender) public view returns (uint256) {
57         return _allowed[owner][spender];
58     }
59 
60     /**
61      * @dev Transfer token to a specified address
62      * @param to The address to transfer to.
63      * @param value The amount to be transferred.
64      */
65     function transfer(address to, uint256 value) public returns (bool) {
66         _transfer(msg.sender, to, value);
67         return true;
68     }
69 
70     /**
71      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
72      * Beware that changing an allowance with this method brings the risk that someone may use both the old
73      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
74      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      * @param spender The address which will spend the funds.
77      * @param value The amount of tokens to be spent.
78      */
79     function approve(address spender, uint256 value) public returns (bool) {
80         _approve(msg.sender, spender, value);
81         return true;
82     }
83 
84     /**
85      * @dev Transfer tokens from one address to another.
86      * Note that while this function emits an Approval event, this is not required as per the specification,
87      * and other compliant implementations may not emit the event.
88      * @param from address The address which you want to send tokens from
89      * @param to address The address which you want to transfer to
90      * @param value uint256 the amount of tokens to be transferred
91      */
92     function transferFrom(address from, address to, uint256 value) public returns (bool) {
93         _transfer(from, to, value);
94         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
95         return true;
96     }
97 
98     /**
99      * @dev Increase the amount of tokens that an owner allowed to a spender.
100      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
101      * allowed value is better to use this function to avoid 2 calls (and wait until
102      * the first transaction is mined)
103      * From MonolithDAO Token.sol
104      * Emits an Approval event.
105      * @param spender The address which will spend the funds.
106      * @param addedValue The amount of tokens to increase the allowance by.
107      */
108     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
109         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
110         return true;
111     }
112 
113     /**
114      * @dev Decrease the amount of tokens that an owner allowed to a spender.
115      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
116      * allowed value is better to use this function to avoid 2 calls (and wait until
117      * the first transaction is mined)
118      * From MonolithDAO Token.sol
119      * Emits an Approval event.
120      * @param spender The address which will spend the funds.
121      * @param subtractedValue The amount of tokens to decrease the allowance by.
122      */
123     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
124         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
125         return true;
126     }
127 
128     /**
129      * @dev Transfer token for a specified addresses
130      * @param from The address to transfer from.
131      * @param to The address to transfer to.
132      * @param value The amount to be transferred.
133      */
134     function _transfer(address from, address to, uint256 value) internal {
135         require(to != address(0));
136 
137         _balances[from] = _balances[from].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(from, to, value);
140     }
141 
142     /**
143      * @dev Internal function that mints an amount of the token and assigns it to
144      * an account. This encapsulates the modification of balances such that the
145      * proper events are emitted.
146      * @param account The account that will receive the created tokens.
147      * @param value The amount that will be created.
148      */
149     function _mint(address account, uint256 value) internal {
150         require(account != address(0));
151 
152         _totalSupply = _totalSupply.add(value);
153         _balances[account] = _balances[account].add(value);
154         emit Transfer(address(0), account, value);
155     }
156 
157     /**
158      * @dev Internal function that burns an amount of the token of a given
159      * account.
160      * @param account The account whose tokens will be burnt.
161      * @param value The amount that will be burnt.
162      */
163     function _burn(address account, uint256 value) internal {
164         require(account != address(0));
165 
166         _totalSupply = _totalSupply.sub(value);
167         _balances[account] = _balances[account].sub(value);
168         emit Transfer(account, address(0), value);
169     }
170 
171     /**
172      * @dev Approve an address to spend another addresses' tokens.
173      * @param owner The address that owns the tokens.
174      * @param spender The address that will spend the tokens.
175      * @param value The number of tokens that can be spent.
176      */
177     function _approve(address owner, address spender, uint256 value) internal {
178         require(spender != address(0));
179         require(owner != address(0));
180 
181         _allowed[owner][spender] = value;
182         emit Approval(owner, spender, value);
183     }
184 
185     /**
186      * @dev Internal function that burns an amount of the token of a given
187      * account, deducting from the sender's allowance for said account. Uses the
188      * internal burn function.
189      * Emits an Approval event (reflecting the reduced allowance).
190      * @param account The account whose tokens will be burnt.
191      * @param value The amount that will be burnt.
192      */
193     function _burnFrom(address account, uint256 value) internal {
194         _burn(account, value);
195         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
196     }
197 }
198 
199 library Roles {
200     struct Role {
201         mapping (address => bool) bearer;
202     }
203 
204     /**
205      * @dev give an account access to this role
206      */
207     function add(Role storage role, address account) internal {
208         require(account != address(0));
209         require(!has(role, account));
210 
211         role.bearer[account] = true;
212     }
213 
214     /**
215      * @dev remove an account's access to this role
216      */
217     function remove(Role storage role, address account) internal {
218         require(account != address(0));
219         require(has(role, account));
220 
221         role.bearer[account] = false;
222     }
223 
224     /**
225      * @dev check if an account has this role
226      * @return bool
227      */
228     function has(Role storage role, address account) internal view returns (bool) {
229         require(account != address(0));
230         return role.bearer[account];
231     }
232 }
233 
234 contract MinterRole {
235     using Roles for Roles.Role;
236 
237     event MinterAdded(address indexed account);
238     event MinterRemoved(address indexed account);
239 
240     Roles.Role private _minters;
241 
242     constructor () internal {
243         _addMinter(msg.sender);
244     }
245 
246     modifier onlyMinter() {
247         require(isMinter(msg.sender));
248         _;
249     }
250 
251     function isMinter(address account) public view returns (bool) {
252         return _minters.has(account);
253     }
254 
255     function addMinter(address account) public onlyMinter {
256         _addMinter(account);
257     }
258 
259     function renounceMinter() public {
260         _removeMinter(msg.sender);
261     }
262 
263     function _addMinter(address account) internal {
264         _minters.add(account);
265         emit MinterAdded(account);
266     }
267 
268     function _removeMinter(address account) internal {
269         _minters.remove(account);
270         emit MinterRemoved(account);
271     }
272 }
273 
274 library SafeMath {
275     /**
276      * @dev Multiplies two unsigned integers, reverts on overflow.
277      */
278     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
279         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
280         // benefit is lost if 'b' is also tested.
281         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
282         if (a == 0) {
283             return 0;
284         }
285 
286         uint256 c = a * b;
287         require(c / a == b);
288 
289         return c;
290     }
291 
292     /**
293      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
294      */
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         // Solidity only automatically asserts when dividing by 0
297         require(b > 0);
298         uint256 c = a / b;
299         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
300 
301         return c;
302     }
303 
304     /**
305      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
306      */
307     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
308         require(b <= a);
309         uint256 c = a - b;
310 
311         return c;
312     }
313 
314     /**
315      * @dev Adds two unsigned integers, reverts on overflow.
316      */
317     function add(uint256 a, uint256 b) internal pure returns (uint256) {
318         uint256 c = a + b;
319         require(c >= a);
320 
321         return c;
322     }
323 
324     /**
325      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
326      * reverts when dividing by zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         require(b != 0);
330         return a % b;
331     }
332 }
333 
334 contract ERC20Detailed is IERC20 {
335     string private _name;
336     string private _symbol;
337     uint8 private _decimals;
338 
339     constructor (string memory name, string memory symbol, uint8 decimals) public {
340         _name = name;
341         _symbol = symbol;
342         _decimals = decimals;
343     }
344 
345     /**
346      * @return the name of the token.
347      */
348     function name() public view returns (string memory) {
349         return _name;
350     }
351 
352     /**
353      * @return the symbol of the token.
354      */
355     function symbol() public view returns (string memory) {
356         return _symbol;
357     }
358 
359     /**
360      * @return the number of decimals of the token.
361      */
362     function decimals() public view returns (uint8) {
363         return _decimals;
364     }
365 }
366 
367 contract ERC20Mintable is ERC20, MinterRole {
368     /**
369      * @dev Function to mint tokens
370      * @param to The address that will receive the minted tokens.
371      * @param value The amount of tokens to mint.
372      * @return A boolean that indicates if the operation was successful.
373      */
374     function mint(address to, uint256 value) public onlyMinter returns (bool) {
375         _mint(to, value);
376         return true;
377     }
378 }
379 
380 contract TestToken is ERC20Mintable, ERC20Detailed {
381     uint8 public constant DECIMALS = 18;
382     uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(DECIMALS));
383 
384     /**
385      * @dev Constructor that gives msg.sender all of existing tokens.
386      */
387     constructor () public ERC20Detailed("Checking Penta Network Token", "PNT", DECIMALS) {
388         _mint(msg.sender, INITIAL_SUPPLY);
389     }
390 }