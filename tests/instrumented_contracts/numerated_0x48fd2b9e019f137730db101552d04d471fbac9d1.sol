1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
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
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title Roles
70  * @dev Library for managing addresses assigned to a Role.
71  */
72 library Roles {
73     struct Role {
74         mapping (address => bool) bearer;
75     }
76 
77     /**
78      * @dev give an account access to this role
79      */
80     function add(Role storage role, address account) internal {
81         require(account != address(0));
82         require(!has(role, account));
83 
84         role.bearer[account] = true;
85     }
86 
87     /**
88      * @dev remove an account's access to this role
89      */
90     function remove(Role storage role, address account) internal {
91         require(account != address(0));
92         require(has(role, account));
93 
94         role.bearer[account] = false;
95     }
96 
97     /**
98      * @dev check if an account has this role
99      * @return bool
100      */
101     function has(Role storage role, address account) internal view returns (bool) {
102         require(account != address(0));
103         return role.bearer[account];
104     }
105 }
106 
107 contract MinterRole {
108     using Roles for Roles.Role;
109 
110     event MinterAdded(address indexed account);
111     event MinterRemoved(address indexed account);
112 
113     Roles.Role private _minters;
114 
115     constructor () internal {
116         _addMinter(msg.sender);
117     }
118 
119     modifier onlyMinter() {
120         require(isMinter(msg.sender));
121         _;
122     }
123 
124     function isMinter(address account) public view returns (bool) {
125         return _minters.has(account);
126     }
127 
128     function addMinter(address account) public onlyMinter {
129         _addMinter(account);
130     }
131 
132     function renounceMinter() public {
133         _removeMinter(msg.sender);
134     }
135 
136     function _addMinter(address account) internal {
137         _minters.add(account);
138         emit MinterAdded(account);
139     }
140 
141     function _removeMinter(address account) internal {
142         _minters.remove(account);
143         emit MinterRemoved(account);
144     }
145 }
146 
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 interface IERC20 {
153     function totalSupply() external view returns (uint256);
154 
155     function balanceOf(address who) external view returns (uint256);
156 
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     function transfer(address to, uint256 value) external returns (bool);
160 
161     function approve(address spender, uint256 value) external returns (bool);
162 
163     function transferFrom(address from, address to, uint256 value) external returns (bool);
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
175  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  *
177  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
178  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
179  * compliant implementations may not do it.
180  */
181 contract ERC20 is IERC20 {
182     using SafeMath for uint256;
183 
184     mapping (address => uint256) private _balances;
185 
186     mapping (address => mapping (address => uint256)) private _allowed;
187 
188     uint256 private _totalSupply;
189 
190     /**
191     * @dev Total number of tokens in existence
192     */
193     function totalSupply() public view returns (uint256) {
194         return _totalSupply;
195     }
196 
197     /**
198     * @dev Gets the balance of the specified address.
199     * @param owner The address to query the balance of.
200     * @return An uint256 representing the amount owned by the passed address.
201     */
202     function balanceOf(address owner) public view returns (uint256) {
203         return _balances[owner];
204     }
205 
206     /**
207      * @dev Function to check the amount of tokens that an owner allowed to a spender.
208      * @param owner address The address which owns the funds.
209      * @param spender address The address which will spend the funds.
210      * @return A uint256 specifying the amount of tokens still available for the spender.
211      */
212     function allowance(address owner, address spender) public view returns (uint256) {
213         return _allowed[owner][spender];
214     }
215 
216     /**
217     * @dev Transfer token for a specified address
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function transfer(address to, uint256 value) public returns (bool) {
222         _transfer(msg.sender, to, value);
223         return true;
224     }
225 
226     /**
227      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228      * Beware that changing an allowance with this method brings the risk that someone may use both the old
229      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      * @param spender The address which will spend the funds.
233      * @param value The amount of tokens to be spent.
234      */
235     function approve(address spender, uint256 value) public returns (bool) {
236         require(spender != address(0));
237 
238         _allowed[msg.sender][spender] = value;
239         emit Approval(msg.sender, spender, value);
240         return true;
241     }
242 
243     /**
244      * @dev Transfer tokens from one address to another.
245      * Note that while this function emits an Approval event, this is not required as per the specification,
246      * and other compliant implementations may not emit the event.
247      * @param from address The address which you want to send tokens from
248      * @param to address The address which you want to transfer to
249      * @param value uint256 the amount of tokens to be transferred
250      */
251     function transferFrom(address from, address to, uint256 value) public returns (bool) {
252         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
253         _transfer(from, to, value);
254         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
255         return true;
256     }
257 
258     /**
259      * @dev Increase the amount of tokens that an owner allowed to a spender.
260      * approve should be called when allowed_[_spender] == 0. To increment
261      * allowed value is better to use this function to avoid 2 calls (and wait until
262      * the first transaction is mined)
263      * From MonolithDAO Token.sol
264      * Emits an Approval event.
265      * @param spender The address which will spend the funds.
266      * @param addedValue The amount of tokens to increase the allowance by.
267      */
268     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
269         require(spender != address(0));
270 
271         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
272         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
273         return true;
274     }
275 
276     /**
277      * @dev Decrease the amount of tokens that an owner allowed to a spender.
278      * approve should be called when allowed_[_spender] == 0. To decrement
279      * allowed value is better to use this function to avoid 2 calls (and wait until
280      * the first transaction is mined)
281      * From MonolithDAO Token.sol
282      * Emits an Approval event.
283      * @param spender The address which will spend the funds.
284      * @param subtractedValue The amount of tokens to decrease the allowance by.
285      */
286     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
287         require(spender != address(0));
288 
289         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
290         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
291         return true;
292     }
293 
294     /**
295     * @dev Transfer token for a specified addresses
296     * @param from The address to transfer from.
297     * @param to The address to transfer to.
298     * @param value The amount to be transferred.
299     */
300     function _transfer(address from, address to, uint256 value) internal {
301         require(to != address(0));
302 
303         _balances[from] = _balances[from].sub(value);
304         _balances[to] = _balances[to].add(value);
305         emit Transfer(from, to, value);
306     }
307 
308     /**
309      * @dev Internal function that mints an amount of the token and assigns it to
310      * an account. This encapsulates the modification of balances such that the
311      * proper events are emitted.
312      * @param account The account that will receive the created tokens.
313      * @param value The amount that will be created.
314      */
315     function _mint(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.add(value);
319         _balances[account] = _balances[account].add(value);
320         emit Transfer(address(0), account, value);
321     }
322 
323     /**
324      * @dev Internal function that burns an amount of the token of a given
325      * account.
326      * @param account The account whose tokens will be burnt.
327      * @param value The amount that will be burnt.
328      */
329     function _burn(address account, uint256 value) internal {
330         require(account != address(0));
331 
332         _totalSupply = _totalSupply.sub(value);
333         _balances[account] = _balances[account].sub(value);
334         emit Transfer(account, address(0), value);
335     }
336 
337     /**
338      * @dev Internal function that burns an amount of the token of a given
339      * account, deducting from the sender's allowance for said account. Uses the
340      * internal burn function.
341      * Emits an Approval event (reflecting the reduced allowance).
342      * @param account The account whose tokens will be burnt.
343      * @param value The amount that will be burnt.
344      */
345     function _burnFrom(address account, uint256 value) internal {
346         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
347         _burn(account, value);
348         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
349     }
350 }
351 
352 
353 /**
354  * @title ERC20Mintable
355  * @dev ERC20 minting logic
356  */
357 contract ERC20Mintable is ERC20, MinterRole {
358     /**
359      * @dev Function to mint tokens
360      * @param to The address that will receive the minted tokens.
361      * @param value The amount of tokens to mint.
362      * @return A boolean that indicates if the operation was successful.
363      */
364     function mint(address to, uint256 value) public onlyMinter returns (bool) {
365         _mint(to, value);
366         return true;
367     }
368 }
369 
370 /**
371  * @title ERC20Detailed token
372  * @dev The decimals are only for visualization purposes.
373  * All the operations are done using the smallest and indivisible token unit,
374  * just as on Ethereum all the operations are done in wei.
375  */
376 contract ERC20Detailed is IERC20 {
377     string private _name;
378     string private _symbol;
379     uint8 private _decimals;
380 
381     constructor (string name, string symbol, uint8 decimals) public {
382         _name = name;
383         _symbol = symbol;
384         _decimals = decimals;
385     }
386 
387     /**
388      * @return the name of the token.
389      */
390     function name() public view returns (string) {
391         return _name;
392     }
393 
394     /**
395      * @return the symbol of the token.
396      */
397     function symbol() public view returns (string) {
398         return _symbol;
399     }
400 
401     /**
402      * @return the number of decimals of the token.
403      */
404     function decimals() public view returns (uint8) {
405         return _decimals;
406     }
407 }
408 
409 contract GBCERC20 is ERC20Detailed("GOBlockchain Coin", "GBC", 18), ERC20Mintable {
410 
411 }