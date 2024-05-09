1 pragma solidity >=0.4.21 <0.6.0;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * @notice Renouncing to ownership will leave the contract without an owner.
42      * It will not be possible to call the functions with the `onlyOwner`
43      * modifier anymore.
44      */
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 interface IERC20 {
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     function transferFrom(address from, address to, uint256 value) external returns (bool);
79 
80     function totalSupply() external view returns (uint256);
81 
82     function balanceOf(address who) external view returns (uint256);
83 
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title SafeMath
93  * @dev Unsigned math operations with safety checks that revert on error
94  */
95 library SafeMath {
96     /**
97     * @dev Multiplies two unsigned integers, reverts on overflow.
98     */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b);
109 
110         return c;
111     }
112 
113     /**
114     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
115     */
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
127     */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b <= a);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136     * @dev Adds two unsigned integers, reverts on overflow.
137     */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a);
141 
142         return c;
143     }
144 
145     /**
146     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
147     * reverts when dividing by zero.
148     */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         require(b != 0);
151         return a % b;
152     }
153 }
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
160  * Originally based on code by FirstBlood:
161  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  *
163  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
164  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
165  * compliant implementations may not do it.
166  */
167 contract ERC20 is IERC20 {
168     using SafeMath for uint256;
169 
170     mapping (address => uint256) private _balances;
171 
172     mapping (address => mapping (address => uint256)) private _allowed;
173 
174     uint256 private _totalSupply;
175 
176     /**
177     * @dev Total number of tokens in existence
178     */
179     function totalSupply() public view returns (uint256) {
180         return _totalSupply;
181     }
182 
183     /**
184     * @dev Gets the balance of the specified address.
185     * @param owner The address to query the balance of.
186     * @return An uint256 representing the amount owned by the passed address.
187     */
188     function balanceOf(address owner) public view returns (uint256) {
189         return _balances[owner];
190     }
191 
192     /**
193      * @dev Function to check the amount of tokens that an owner allowed to a spender.
194      * @param owner address The address which owns the funds.
195      * @param spender address The address which will spend the funds.
196      * @return A uint256 specifying the amount of tokens still available for the spender.
197      */
198     function allowance(address owner, address spender) public view returns (uint256) {
199         return _allowed[owner][spender];
200     }
201 
202     /**
203     * @dev Transfer token for a specified address
204     * @param to The address to transfer to.
205     * @param value The amount to be transferred.
206     */
207     function transfer(address to, uint256 value) public returns (bool) {
208         _transfer(msg.sender, to, value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param spender The address which will spend the funds.
219      * @param value The amount of tokens to be spent.
220      */
221     function approve(address spender, uint256 value) public returns (bool) {
222         require(spender != address(0));
223 
224         _allowed[msg.sender][spender] = value;
225         emit Approval(msg.sender, spender, value);
226         return true;
227     }
228 
229     /**
230      * @dev Transfer tokens from one address to another.
231      * Note that while this function emits an Approval event, this is not required as per the specification,
232      * and other compliant implementations may not emit the event.
233      * @param from address The address which you want to send tokens from
234      * @param to address The address which you want to transfer to
235      * @param value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address from, address to, uint256 value) public returns (bool) {
238         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
239         _transfer(from, to, value);
240         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
241         return true;
242     }
243 
244     /**
245      * @dev Increase the amount of tokens that an owner allowed to a spender.
246      * approve should be called when allowed_[_spender] == 0. To increment
247      * allowed value is better to use this function to avoid 2 calls (and wait until
248      * the first transaction is mined)
249      * From MonolithDAO Token.sol
250      * Emits an Approval event.
251      * @param spender The address which will spend the funds.
252      * @param addedValue The amount of tokens to increase the allowance by.
253      */
254     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
255         require(spender != address(0));
256 
257         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
258         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
259         return true;
260     }
261 
262     /**
263      * @dev Decrease the amount of tokens that an owner allowed to a spender.
264      * approve should be called when allowed_[_spender] == 0. To decrement
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * Emits an Approval event.
269      * @param spender The address which will spend the funds.
270      * @param subtractedValue The amount of tokens to decrease the allowance by.
271      */
272     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
273         require(spender != address(0));
274 
275         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
276         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
277         return true;
278     }
279 
280     /**
281     * @dev Transfer token for a specified addresses
282     * @param from The address to transfer from.
283     * @param to The address to transfer to.
284     * @param value The amount to be transferred.
285     */
286     function _transfer(address from, address to, uint256 value) internal {
287         require(to != address(0));
288 
289         _balances[from] = _balances[from].sub(value);
290         _balances[to] = _balances[to].add(value);
291         emit Transfer(from, to, value);
292     }
293 
294     /**
295      * @dev Internal function that mints an amount of the token and assigns it to
296      * an account. This encapsulates the modification of balances such that the
297      * proper events are emitted.
298      * @param account The account that will receive the created tokens.
299      * @param value The amount that will be created.
300      */
301     function _mint(address account, uint256 value) internal {
302         require(account != address(0));
303 
304         _totalSupply = _totalSupply.add(value);
305         _balances[account] = _balances[account].add(value);
306         emit Transfer(address(0), account, value);
307     }
308 
309     /**
310      * @dev Internal function that burns an amount of the token of a given
311      * account.
312      * @param account The account whose tokens will be burnt.
313      * @param value The amount that will be burnt.
314      */
315     function _burn(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.sub(value);
319         _balances[account] = _balances[account].sub(value);
320         emit Transfer(account, address(0), value);
321     }
322 
323     /**
324      * @dev Internal function that burns an amount of the token of a given
325      * account, deducting from the sender's allowance for said account. Uses the
326      * internal burn function.
327      * Emits an Approval event (reflecting the reduced allowance).
328      * @param account The account whose tokens will be burnt.
329      * @param value The amount that will be burnt.
330      */
331     function _burnFrom(address account, uint256 value) internal {
332         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
333         _burn(account, value);
334         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
335     }
336 }
337 
338 /**
339  * @title ERC20Detailed token
340  * @dev The decimals are only for visualization purposes.
341  * All the operations are done using the smallest and indivisible token unit,
342  * just as on Ethereum all the operations are done in wei.
343  */
344 contract ERC20Detailed is IERC20 {
345     string private _name;
346     string private _symbol;
347     uint8 private _decimals;
348 
349     constructor (string memory name, string memory symbol, uint8 decimals) public {
350         _name = name;
351         _symbol = symbol;
352         _decimals = decimals;
353     }
354 
355     /**
356      * @return the name of the token.
357      */
358     function name() public view returns (string memory) {
359         return _name;
360     }
361 
362     /**
363      * @return the symbol of the token.
364      */
365     function symbol() public view returns (string memory) {
366         return _symbol;
367     }
368 
369     /**
370      * @return the number of decimals of the token.
371      */
372     function decimals() public view returns (uint8) {
373         return _decimals;
374     }
375 }
376 
377 contract UTMT is ERC20, ERC20Detailed, Ownable{
378     mapping (address => bool) public isAdmin;
379     
380     constructor () public ERC20Detailed('UTime Token', 'UTMT', 6) {
381     	uint256 _totalSupply = (10 ** 9) * (10 ** 6);
382     	_mint(msg.sender, _totalSupply);
383     }
384 
385     modifier onlyAdmin {
386         require(isOwner() || isAdmin[msg.sender]);
387         _;
388     }
389 
390     function addToAdmin (address admin, bool isAdd) external onlyOwner {
391         isAdmin[admin] = isAdd;
392     }
393 
394     function burn(uint256 amount) public onlyAdmin {
395         _burn(msg.sender, amount);
396     }
397 }