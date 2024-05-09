1 pragma solidity 0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://eips.ethereum.org/EIPS/eip-20
61  */
62 interface IERC20 {
63     function transfer(address to, uint256 value) external returns (bool);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68 
69     function mint(address to, uint256 value) external returns (bool);
70 
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address who) external view returns (uint256);
74 
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @title Standard ERC20 token
84  *
85  * @dev Implementation of the basic standard token.
86  * https://eips.ethereum.org/EIPS/eip-20
87  * Originally based on code by FirstBlood:
88  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  *
90  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
91  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
92  * compliant implementations may not do it.
93  */
94 contract ERC20 is IERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowed;
100 
101     uint256 private _totalSupply;
102 
103     /**
104      * @dev Total number of tokens in existence
105      */
106     function totalSupply() public view returns (uint256) {
107         return _totalSupply;
108     }
109 
110     /**
111      * @dev Gets the balance of the specified address.
112      * @param owner The address to query the balance of.
113      * @return A uint256 representing the amount owned by the passed address.
114      */
115     function balanceOf(address owner) public view returns (uint256) {
116         return _balances[owner];
117     }
118 
119     /**
120      * @dev Function to check the amount of tokens that an owner allowed to a spender.
121      * @param owner address The address which owns the funds.
122      * @param spender address The address which will spend the funds.
123      * @return A uint256 specifying the amount of tokens still available for the spender.
124      */
125     function allowance(address owner, address spender) public view returns (uint256) {
126         return _allowed[owner][spender];
127     }
128 
129     /**
130      * @dev Transfer token to a specified address
131      * @param to The address to transfer to.
132      * @param value The amount to be transferred.
133      */
134     function transfer(address to, uint256 value) public returns (bool) {
135         _transfer(msg.sender, to, value);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param spender The address which will spend the funds.
146      * @param value The amount of tokens to be spent.
147      */
148     function approve(address spender, uint256 value) public returns (bool) {
149         _approve(msg.sender, spender, value);
150         return true;
151     }
152 
153     /**
154      * @dev Transfer tokens from one address to another.
155      * Note that while this function emits an Approval event, this is not required as per the specification,
156      * and other compliant implementations may not emit the event.
157      * @param from address The address which you want to send tokens from
158      * @param to address The address which you want to transfer to
159      * @param value uint256 the amount of tokens to be transferred
160      */
161     function transferFrom(address from, address to, uint256 value) public returns (bool) {
162         _transfer(from, to, value);
163         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
164         return true;
165     }
166 
167     /**
168      * @dev Increase the amount of tokens that an owner allowed to a spender.
169      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
170      * allowed value is better to use this function to avoid 2 calls (and wait until
171      * the first transaction is mined)
172      * From MonolithDAO Token.sol
173      * Emits an Approval event.
174      * @param spender The address which will spend the funds.
175      * @param addedValue The amount of tokens to increase the allowance by.
176      */
177     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
178         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
179         return true;
180     }
181 
182     /**
183      * @dev Decrease the amount of tokens that an owner allowed to a spender.
184      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param subtractedValue The amount of tokens to decrease the allowance by.
191      */
192     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
193         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
194         return true;
195     }
196 
197     /**
198      * @dev Transfer token for a specified addresses
199      * @param from The address to transfer from.
200      * @param to The address to transfer to.
201      * @param value The amount to be transferred.
202      */
203     function _transfer(address from, address to, uint256 value) internal {
204         require(to != address(0));
205 
206         _balances[from] = _balances[from].sub(value);
207         _balances[to] = _balances[to].add(value);
208         emit Transfer(from, to, value);
209     }
210 
211     /**
212      * @dev Internal function that mints an amount of the token and assigns it to
213      * an account. This encapsulates the modification of balances such that the
214      * proper events are emitted.
215      * @param account The account that will receive the created tokens.
216      * @param value The amount that will be created.
217      */
218     function _mint(address account, uint256 value) internal {
219         require(account != address(0));
220 
221         _totalSupply = _totalSupply.add(value);
222         _balances[account] = _balances[account].add(value);
223         emit Transfer(address(0), account, value);
224     }
225 
226     /**
227      * @dev Internal function that burns an amount of the token of a given
228      * account.
229      * @param account The account whose tokens will be burnt.
230      * @param value The amount that will be burnt.
231      */
232     function _burn(address account, uint256 value) internal {
233         require(account != address(0));
234 
235         _totalSupply = _totalSupply.sub(value);
236         _balances[account] = _balances[account].sub(value);
237         emit Transfer(account, address(0), value);
238     }
239 
240     /**
241      * @dev Approve an address to spend another addresses' tokens.
242      * @param owner The address that owns the tokens.
243      * @param spender The address that will spend the tokens.
244      * @param value The number of tokens that can be spent.
245      */
246     function _approve(address owner, address spender, uint256 value) internal {
247         require(spender != address(0));
248         require(owner != address(0));
249 
250         _allowed[owner][spender] = value;
251         emit Approval(owner, spender, value);
252     }
253 
254     /**
255      * @dev Internal function that burns an amount of the token of a given
256      * account, deducting from the sender's allowance for said account. Uses the
257      * internal burn function.
258      * Emits an Approval event (reflecting the reduced allowance).
259      * @param account The account whose tokens will be burnt.
260      * @param value The amount that will be burnt.
261      */
262     function _burnFrom(address account, uint256 value) internal {
263         _burn(account, value);
264         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
265     }
266 }
267 
268 /**
269  * @title Roles
270  * @dev Library for managing addresses assigned to a Role.
271  */
272 library Roles {
273     struct Role {
274         mapping (address => bool) bearer;
275     }
276 
277     /**
278      * @dev give an account access to this role
279      */
280     function add(Role storage role, address account) internal {
281         require(account != address(0));
282         require(!has(role, account));
283 
284         role.bearer[account] = true;
285     }
286 
287     /**
288      * @dev remove an account's access to this role
289      */
290     function remove(Role storage role, address account) internal {
291         require(account != address(0));
292         require(has(role, account));
293 
294         role.bearer[account] = false;
295     }
296 
297     /**
298      * @dev check if an account has this role
299      * @return bool
300      */
301     function has(Role storage role, address account) internal view returns (bool) {
302         require(account != address(0));
303         return role.bearer[account];
304     }
305 }
306 
307 /**
308  * @title MinterRole
309  * @dev Role who can mint the new tokens
310  */
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
332     function _addMinter(address account) internal {
333         _minters.add(account);
334         emit MinterAdded(account);
335     }
336 }
337 
338 /**
339  * @title ERC20Mintable
340  * @dev ERC20 minting logic
341  */
342 contract ERC20Mintable is ERC20, MinterRole {
343     /**
344      * @dev Function to mint tokens
345      * @param to The address that will receive the minted tokens.
346      * @param value The amount of tokens to mint.
347      * @return A boolean that indicates if the operation was successful.
348      */
349     function mint(address to, uint256 value) public onlyMinter returns (bool) {
350         _mint(to, value);
351         return true;
352     }
353 }
354 
355 /**
356  * @title Burnable Token
357  * @dev Token that can be irreversibly burned (destroyed).
358  */
359 contract ERC20Burnable is ERC20 {
360     /**
361      * @dev Burns a specific amount of tokens.
362      * @param value The amount of token to be burned.
363      */
364     function burn(uint256 value) public {
365         _burn(msg.sender, value);
366     }
367 
368     /**
369      * @dev Burns a specific amount of tokens from the target address and decrements allowance
370      * @param from address The account whose tokens will be burned.
371      * @param value uint256 The amount of token to be burned.
372      */
373     function burnFrom(address from, uint256 value) public {
374         _burnFrom(from, value);
375     }
376 }
377 
378 /**
379  * @title TuneTradeToken burnable and mintable smart contract
380  */
381 contract TuneTradeToken is ERC20Burnable, ERC20Mintable {
382     string private constant _name = "TuneTradeX";
383     string private constant _symbol = "TXT";
384     uint8 private constant _decimals = 18;
385 
386     /**
387      * @return the name of the token.
388      */
389     function name() public pure returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @return the symbol of the token.
395      */
396     function symbol() public pure returns (string memory) {
397         return _symbol;
398     }
399 
400     /**
401      * @return the number of decimals of the token.
402      */
403     function decimals() public pure returns (uint8) {
404         return _decimals;
405     }
406 }