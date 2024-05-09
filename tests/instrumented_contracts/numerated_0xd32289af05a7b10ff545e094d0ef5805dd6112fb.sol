1 pragma solidity ^0.4.24;
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
67 pragma solidity ^0.4.24;
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address private _owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor () internal {
84         _owner = msg.sender;
85         emit OwnershipTransferred(address(0), _owner);
86     }
87 
88     /**
89      * @return the address of the owner.
90      */
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(isOwner());
100         _;
101     }
102 
103     /**
104      * @return true if `msg.sender` is the owner of the contract.
105      */
106     function isOwner() public view returns (bool) {
107         return msg.sender == _owner;
108     }
109 
110     /**
111      * @dev Allows the current owner to relinquish control of the contract.
112      * @notice Renouncing to ownership will leave the contract without an owner.
113      * It will not be possible to call the functions with the `onlyOwner`
114      * modifier anymore.
115      */
116     function renounceOwnership() public onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) public onlyOwner {
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function _transferOwnership(address newOwner) internal {
134         require(newOwner != address(0));
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 pragma solidity ^0.4.24;
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 interface IERC20 {
147     function totalSupply() external view returns (uint256);
148 
149     function balanceOf(address who) external view returns (uint256);
150 
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     function transfer(address to, uint256 value) external returns (bool);
154 
155     function approve(address spender, uint256 value) external returns (bool);
156 
157     function transferFrom(address from, address to, uint256 value) external returns (bool);
158 
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 pragma solidity ^0.4.24;
165 
166 /**
167  * @title ERC20Detailed token
168  * @dev The decimals are only for visualization purposes.
169  * All the operations are done using the smallest and indivisible token unit,
170  * just as on Ethereum all the operations are done in wei.
171  */
172 contract ERC20Detailed is IERC20 {
173     string private _name;
174     string private _symbol;
175     uint8 private _decimals;
176 
177     constructor (string name, string symbol, uint8 decimals) public {
178         _name = name;
179         _symbol = symbol;
180         _decimals = decimals;
181     }
182 
183     /**
184      * @return the name of the token.
185      */
186     function name() public view returns (string) {
187         return _name;
188     }
189 
190     /**
191      * @return the symbol of the token.
192      */
193     function symbol() public view returns (string) {
194         return _symbol;
195     }
196 
197     /**
198      * @return the number of decimals of the token.
199      */
200     function decimals() public view returns (uint8) {
201         return _decimals;
202     }
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
210  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  *
212  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
213  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
214  * compliant implementations may not do it.
215  */
216 contract ERC20 is IERC20 {
217     using SafeMath for uint256;
218 
219     mapping (address => uint256) private _balances;
220     mapping (address => mapping (address => uint256)) private _allowed;
221     uint256 private _totalSupply;
222 
223     /**
224     * @dev Total number of tokens in existence
225     */
226     function totalSupply() public view returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231     * @dev Gets the balance of the specified address.
232     * @param owner The address to query the balance of.
233     * @return An uint256 representing the amount owned by the passed address.
234     */
235     function balanceOf(address owner) public view returns (uint256) {
236         return _balances[owner];
237     }
238 
239     /**
240      * @dev Function to check the amount of tokens that an owner allowed to a spender.
241      * @param owner address The address which owns the funds.
242      * @param spender address The address which will spend the funds.
243      * @return A uint256 specifying the amount of tokens still available for the spender.
244      */
245     function allowance(address owner, address spender) public view returns (uint256) {
246         return _allowed[owner][spender];
247     }
248 
249     /**
250     * @dev Transfer token for a specified address
251     * @param to The address to transfer to.
252     * @param value The amount to be transferred.
253     */
254     function transfer(address to, uint256 value) public returns (bool) {
255         _transfer(msg.sender, to, value);
256         return true;
257     }
258 
259     /**
260      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261      * Beware that changing an allowance with this method brings the risk that someone may use both the old
262      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
263      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      * @param spender The address which will spend the funds.
266      * @param value The amount of tokens to be spent.
267      */
268     function approve(address spender, uint256 value) public returns (bool) {
269         require(spender != address(0));
270 
271         _allowed[msg.sender][spender] = value;
272         emit Approval(msg.sender, spender, value);
273         return true;
274     }
275 
276     /**
277      * @dev Transfer tokens from one address to another.
278      * Note that while this function emits an Approval event, this is not required as per the specification,
279      * and other compliant implementations may not emit the event.
280      * @param from address The address which you want to send tokens from
281      * @param to address The address which you want to transfer to
282      * @param value uint256 the amount of tokens to be transferred
283      */
284     function transferFrom(address from, address to, uint256 value) public returns (bool) {
285         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
286         _transfer(from, to, value);
287         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
288         return true;
289     }
290 
291     /**
292      * @dev Increase the amount of tokens that an owner allowed to a spender.
293      * approve should be called when allowed_[_spender] == 0. To increment
294      * allowed value is better to use this function to avoid 2 calls (and wait until
295      * the first transaction is mined)
296      * From MonolithDAO Token.sol
297      * Emits an Approval event.
298      * @param spender The address which will spend the funds.
299      * @param addedValue The amount of tokens to increase the allowance by.
300      */
301     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
302         require(spender != address(0));
303 
304         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
305         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306         return true;
307     }
308 
309     /**
310      * @dev Decrease the amount of tokens that an owner allowed to a spender.
311      * approve should be called when allowed_[_spender] == 0. To decrement
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * Emits an Approval event.
316      * @param spender The address which will spend the funds.
317      * @param subtractedValue The amount of tokens to decrease the allowance by.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
320         require(spender != address(0));
321 
322         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
323         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324         return true;
325     }
326 
327     /**
328     * @dev Transfer token for a specified addresses
329     * @param from The address to transfer from.
330     * @param to The address to transfer to.
331     * @param value The amount to be transferred.
332     */
333     function _transfer(address from, address to, uint256 value) internal {
334         require(to != address(0));
335 
336         _balances[from] = _balances[from].sub(value);
337         _balances[to] = _balances[to].add(value);
338         emit Transfer(from, to, value);
339     }
340 
341     /**
342      * @dev Internal function that mints an amount of the token and assigns it to
343      * an account. This encapsulates the modification of balances such that the
344      * proper events are emitted.
345      * @param account The account that will receive the created tokens.
346      * @param value The amount that will be created.
347      */
348     function _mint(address account, uint256 value) internal {
349         require(account != address(0));
350 
351         _totalSupply = _totalSupply.add(value);
352         _balances[account] = _balances[account].add(value);
353         emit Transfer(address(0), account, value);
354     }
355 
356     /**
357      * @dev Internal function that burns an amount of the token of a given
358      * account.
359      * @param account The account whose tokens will be burnt.
360      * @param value The amount that will be burnt.
361      */
362     function _burn(address account, uint256 value) internal {
363         require(account != address(0));
364 
365         _totalSupply = _totalSupply.sub(value);
366         _balances[account] = _balances[account].sub(value);
367         emit Transfer(account, address(0), value);
368     }
369 }
370 
371 contract GetEthIoToken is ERC20, ERC20Detailed, Ownable {
372 
373     constructor () public ERC20Detailed("JOIN A RELIABLE INVEST PROJECT GETETH.IO", "geteth.io", 18) {
374 
375     }
376 
377     function mint(address to, uint256 weiAmount) public onlyOwner {
378         _mint(to, weiAmount);
379     }
380 }