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
25 
26 library SafeMath {
27     /**
28      * @dev Multiplies two unsigned integers, reverts on overflow.
29      */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46      */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Adds two unsigned integers, reverts on overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a);
72 
73         return c;
74     }
75 
76     /**
77      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
78      * reverts when dividing by zero.
79      */
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b != 0);
82         return a % b;
83     }
84 }
85 
86 
87 contract ERC20 is IERC20 {
88     using SafeMath for uint256;
89 
90     mapping (address => uint256) private _balances;
91 
92     mapping (address => mapping (address => uint256)) private _allowed;
93 
94     uint256 private _totalSupply;
95 
96     /**
97      * @dev Total number of tokens in existence
98      */
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     /**
104      * @dev Gets the balance of the specified address.
105      * @param owner The address to query the balance of.
106      * @return A uint256 representing the amount owned by the passed address.
107      */
108     function balanceOf(address owner) public view returns (uint256) {
109         return _balances[owner];
110     }
111 
112     /**
113      * @dev Function to check the amount of tokens that an owner allowed to a spender.
114      * @param owner address The address which owns the funds.
115      * @param spender address The address which will spend the funds.
116      * @return A uint256 specifying the amount of tokens still available for the spender.
117      */
118     function allowance(address owner, address spender) public view returns (uint256) {
119         return _allowed[owner][spender];
120     }
121 
122     /**
123      * @dev Transfer token to a specified address
124      * @param to The address to transfer to.
125      * @param value The amount to be transferred.
126      */
127     function transfer(address to, uint256 value) public returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     /**
133      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param spender The address which will spend the funds.
139      * @param value The amount of tokens to be spent.
140      */
141     function approve(address spender, uint256 value) public returns (bool) {
142         _approve(msg.sender, spender, value);
143         return true;
144     }
145 
146     /**
147      * @dev Transfer tokens from one address to another.
148      * Note that while this function emits an Approval event, this is not required as per the specification,
149      * and other compliant implementations may not emit the event.
150      * @param from address The address which you want to send tokens from
151      * @param to address The address which you want to transfer to
152      * @param value uint256 the amount of tokens to be transferred
153      */
154     function transferFrom(address from, address to, uint256 value) public returns (bool) {
155         _transfer(from, to, value);
156         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
157         return true;
158     }
159 
160     /**
161      * @dev Increase the amount of tokens that an owner allowed to a spender.
162      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
163      * allowed value is better to use this function to avoid 2 calls (and wait until
164      * the first transaction is mined)
165      * From MonolithDAO Token.sol
166      * Emits an Approval event.
167      * @param spender The address which will spend the funds.
168      * @param addedValue The amount of tokens to increase the allowance by.
169      */
170     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
171         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
172         return true;
173     }
174 
175     /**
176      * @dev Decrease the amount of tokens that an owner allowed to a spender.
177      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      * Emits an Approval event.
182      * @param spender The address which will spend the funds.
183      * @param subtractedValue The amount of tokens to decrease the allowance by.
184      */
185     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
186         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
187         return true;
188     }
189 
190     /**
191      * @dev Transfer token for a specified addresses
192      * @param from The address to transfer from.
193      * @param to The address to transfer to.
194      * @param value The amount to be transferred.
195      */
196     function _transfer(address from, address to, uint256 value) internal {
197         require(to != address(0));
198 
199         _balances[from] = _balances[from].sub(value);
200         _balances[to] = _balances[to].add(value);
201         emit Transfer(from, to, value);
202     }
203 
204     /**
205      * @dev Internal function that mints an amount of the token and assigns it to
206      * an account. This encapsulates the modification of balances such that the
207      * proper events are emitted.
208      * @param account The account that will receive the created tokens.
209      * @param value The amount that will be created.
210      */
211     function _mint(address account, uint256 value) internal {
212         require(account != address(0));
213 
214         _totalSupply = _totalSupply.add(value);
215         _balances[account] = _balances[account].add(value);
216         emit Transfer(address(0), account, value);
217     }
218 
219     /**
220      * @dev Internal function that burns an amount of the token of a given
221      * account.
222      * @param account The account whose tokens will be burnt.
223      * @param value The amount that will be burnt.
224      */
225     function _burn(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.sub(value);
229         _balances[account] = _balances[account].sub(value);
230         emit Transfer(account, address(0), value);
231     }
232 
233     /**
234      * @dev Approve an address to spend another addresses' tokens.
235      * @param owner The address that owns the tokens.
236      * @param spender The address that will spend the tokens.
237      * @param value The number of tokens that can be spent.
238      */
239     function _approve(address owner, address spender, uint256 value) internal {
240         require(spender != address(0));
241         require(owner != address(0));
242 
243         _allowed[owner][spender] = value;
244         emit Approval(owner, spender, value);
245     }
246 
247     /**
248      * @dev Internal function that burns an amount of the token of a given
249      * account, deducting from the sender's allowance for said account. Uses the
250      * internal burn function.
251      * Emits an Approval event (reflecting the reduced allowance).
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burnFrom(address account, uint256 value) internal {
256         _burn(account, value);
257         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
258     }
259 }
260 
261 
262 library Roles {
263     struct Role {
264         mapping (address => bool) bearer;
265     }
266 
267     /**
268      * @dev give an account access to this role
269      */
270     function add(Role storage role, address account) internal {
271         require(account != address(0));
272         require(!has(role, account));
273 
274         role.bearer[account] = true;
275     }
276 
277     /**
278      * @dev remove an account's access to this role
279      */
280     function remove(Role storage role, address account) internal {
281         require(account != address(0));
282         require(has(role, account));
283 
284         role.bearer[account] = false;
285     }
286 
287     /**
288      * @dev check if an account has this role
289      * @return bool
290      */
291     function has(Role storage role, address account) internal view returns (bool) {
292         require(account != address(0));
293         return role.bearer[account];
294     }
295 }
296 
297 
298 contract MinterRole {
299     using Roles for Roles.Role;
300 
301     event MinterAdded(address indexed account);
302     event MinterRemoved(address indexed account);
303 
304     Roles.Role private _minters;
305 
306     constructor () internal {
307         _addMinter(msg.sender);
308     }
309 
310     modifier onlyMinter() {
311         require(isMinter(msg.sender));
312         _;
313     }
314 
315     function isMinter(address account) public view returns (bool) {
316         return _minters.has(account);
317     }
318 
319     function addMinter(address account) public onlyMinter {
320         _addMinter(account);
321     }
322 
323     function renounceMinter() public {
324         _removeMinter(msg.sender);
325     }
326 
327     function _addMinter(address account) internal {
328         _minters.add(account);
329         emit MinterAdded(account);
330     }
331 
332     function _removeMinter(address account) internal {
333         _minters.remove(account);
334         emit MinterRemoved(account);
335     }
336 }
337 
338 
339 contract ERC20Mintable is ERC20, MinterRole {
340     /**
341      * @dev Function to mint tokens
342      * @param to The address that will receive the minted tokens.
343      * @param value The amount of tokens to mint.
344      * @return A boolean that indicates if the operation was successful.
345      */
346     function mint(address to, uint256 value) public onlyMinter returns (bool) {
347         _mint(to, value);
348         return true;
349     }
350 }
351 
352 
353 contract ERC20Burnable is ERC20 {
354     /**
355      * @dev Burns a specific amount of tokens.
356      * @param value The amount of token to be burned.
357      */
358     function burn(uint256 value) public {
359         _burn(msg.sender, value);
360     }
361 
362     /**
363      * @dev Burns a specific amount of tokens from the target address and decrements allowance
364      * @param from address The account whose tokens will be burned.
365      * @param value uint256 The amount of token to be burned.
366      */
367     function burnFrom(address from, uint256 value) public {
368         _burnFrom(from, value);
369     }
370 }
371 
372 
373 contract ERC20Detailed is IERC20 {
374     string private _name;
375     string private _symbol;
376     uint8 private _decimals;
377 
378     constructor (string memory name, string memory symbol, uint8 decimals) public {
379         _name = name;
380         _symbol = symbol;
381         _decimals = decimals;
382     }
383 
384     /**
385      * @return the name of the token.
386      */
387     function name() public view returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @return the symbol of the token.
393      */
394     function symbol() public view returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @return the number of decimals of the token.
400      */
401     function decimals() public view returns (uint8) {
402         return _decimals;
403     }
404 }
405 
406 contract TauschToken is ERC20Mintable, ERC20Burnable, ERC20Detailed {
407     
408     string private  _name = "TauschToken"; 
409     string private  _symbol = "TUC"; 
410     uint8 private  _decimals = 10;
411     
412     uint256 public constant INITIAL_SUPPLY = 50 * (10 ** 18);
413     
414     address account = msg.sender; 
415 
416     constructor() 
417         ERC20Detailed(_name, _symbol, _decimals) 
418         ERC20Burnable() 
419         ERC20Mintable()
420         public { 
421             _mint(account, INITIAL_SUPPLY); 
422         } 
423 }