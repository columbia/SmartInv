1 pragma solidity 0.4.24;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9 
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor() public {
19         owner = msg.sender;
20     }
21 
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that revert on error
48  */
49 library SafeMath {
50     /**
51     * @dev Multiplies two numbers, reverts on overflow.
52     */
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b);
63 
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     /**
80     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81     */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b <= a);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90     * @dev Adds two numbers, reverts on overflow.
91     */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a);
95 
96         return c;
97     }
98 
99     /**
100     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
101     * reverts when dividing by zero.
102     */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0);
105         return a % b;
106     }
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116  
117  
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 interface IERC20 {
123     function totalSupply() external view returns (uint256);
124 
125     function balanceOf(address who) external view returns (uint256);
126 
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     function transfer(address to, uint256 value) external returns (bool);
130 
131     function approve(address spender, uint256 value) external returns (bool);
132 
133     function transferFrom(address from, address to, uint256 value) external returns (bool);
134 
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 contract ERC20 is IERC20 {
141     using SafeMath for uint256;
142 
143     mapping (address => uint256) private _balances;
144 
145     mapping (address => mapping (address => uint256)) private _allowed;
146 
147     uint256 private _totalSupply;
148 
149     /**
150     * @dev Total number of tokens in existence
151     */
152     function totalSupply() public view returns (uint256) {
153         return _totalSupply;
154     }
155 
156     /**
157     * @dev Gets the balance of the specified address.
158     * @param owner The address to query the balance of.
159     * @return An uint256 representing the amount owned by the passed address.
160     */
161     function balanceOf(address owner) public view returns (uint256) {
162         return _balances[owner];
163     }
164 
165     /**
166      * @dev Function to check the amount of tokens that an owner allowed to a spender.
167      * @param owner address The address which owns the funds.
168      * @param spender address The address which will spend the funds.
169      * @return A uint256 specifying the amount of tokens still available for the spender.
170      */
171     function allowance(address owner, address spender) public view returns (uint256) {
172         return _allowed[owner][spender];
173     }
174 
175     /**
176     * @dev Transfer token for a specified address
177     * @param to The address to transfer to.
178     * @param value The amount to be transferred.
179     */
180     function transfer(address to, uint256 value) public returns (bool) {
181         _transfer(msg.sender, to, value);
182         return true;
183     }
184 
185     /**
186      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187      * Beware that changing an allowance with this method brings the risk that someone may use both the old
188      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      * @param spender The address which will spend the funds.
192      * @param value The amount of tokens to be spent.
193      */
194     function approve(address spender, uint256 value) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = value;
198         emit Approval(msg.sender, spender, value);
199         return true;
200     }
201 
202     /**
203      * @dev Transfer tokens from one address to another
204      * @param from address The address which you want to send tokens from
205      * @param to address The address which you want to transfer to
206      * @param value uint256 the amount of tokens to be transferred
207      */
208     function transferFrom(address from, address to, uint256 value) public returns (bool) {
209         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
210         _transfer(from, to, value);
211         return true;
212     }
213 
214     /**
215      * @dev Increase the amount of tokens that an owner allowed to a spender.
216      * approve should be called when allowed_[_spender] == 0. To increment
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * @param spender The address which will spend the funds.
221      * @param addedValue The amount of tokens to increase the allowance by.
222      */
223     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
224         require(spender != address(0));
225 
226         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
227         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the amount of tokens that an owner allowed to a spender.
233      * approve should be called when allowed_[_spender] == 0. To decrement
234      * allowed value is better to use this function to avoid 2 calls (and wait until
235      * the first transaction is mined)
236      * From MonolithDAO Token.sol
237      * @param spender The address which will spend the funds.
238      * @param subtractedValue The amount of tokens to decrease the allowance by.
239      */
240     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
241         require(spender != address(0));
242 
243         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
244         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
245         return true;
246     }
247 
248     /**
249     * @dev Transfer token for a specified addresses
250     * @param from The address to transfer from.
251     * @param to The address to transfer to.
252     * @param value The amount to be transferred.
253     */
254     function _transfer(address from, address to, uint256 value) internal {
255         require(to != address(0));
256 
257         _balances[from] = _balances[from].sub(value);
258         _balances[to] = _balances[to].add(value);
259         emit Transfer(from, to, value);
260     }
261 
262     /**
263      * @dev Internal function that mints an amount of the token and assigns it to
264      * an account. This encapsulates the modification of balances such that the
265      * proper events are emitted.
266      * @param account The account that will receive the created tokens.
267      * @param value The amount that will be created.
268      */
269     function _mint(address account, uint256 value) internal {
270         require(account != address(0));
271 
272         _totalSupply = _totalSupply.add(value);
273         _balances[account] = _balances[account].add(value);
274         emit Transfer(address(0), account, value);
275     }
276 
277     /**
278      * @dev Internal function that burns an amount of the token of a given
279      * account.
280      * @param account The account whose tokens will be burnt.
281      * @param value The amount that will be burnt.
282      */
283     function _burn(address account, uint256 value) internal {
284         require(account != address(0));
285 
286         _totalSupply = _totalSupply.sub(value);
287         _balances[account] = _balances[account].sub(value);
288         emit Transfer(account, address(0), value);
289     }
290 
291     /**
292      * @dev Internal function that burns an amount of the token of a given
293      * account, deducting from the sender's allowance for said account. Uses the
294      * internal burn function.
295      * @param account The account whose tokens will be burnt.
296      * @param value The amount that will be burnt.
297      */
298     function _burnFrom(address account, uint256 value) internal {
299         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300         // this function needs to emit an event with the updated approval.
301         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
302         _burn(account, value);
303     }
304 }
305 
306 
307 /**
308  * @title ERC20Detailed token
309  * @dev The decimals are only for visualization purposes.
310  * All the operations are done using the smallest and indivisible token unit,
311  * just as on Ethereum all the operations are done in wei.
312  */
313 contract ERC20Detailed is IERC20 {
314     string private _name;
315     string private _symbol;
316     uint8 private _decimals;
317 
318 constructor (string name, string symbol, uint8 decimals) public {
319     _name = name;
320     _symbol = symbol;
321     _decimals = decimals;
322 }
323 
324 /**
325  * @return the name of the token.
326  */
327 function name() public view returns (string) {
328     return _name;
329 }
330 
331 /**
332  * @return the symbol of the token.
333  */
334 function symbol() public view returns (string) {
335     return _symbol;
336 }
337 
338 /**
339  * @return the number of decimals of the token.
340  */
341 function decimals() public view returns (uint8) {
342     return _decimals;
343 }
344 }
345 
346 /**
347  * @title ERC20Mintable
348  * @dev ERC20 minting logic
349  */
350 contract ERC20Mintable is ERC20, Ownable {
351     /**
352      * @dev Function to mint tokens
353      * @param to The address that will receive the minted tokens.
354      * @param value The amount of tokens to mint.
355      * @return A boolean that indicates if the operation was successful.
356      */
357 
358     address public investingContract;
359 
360 
361     modifier onlyInvestingContract() {
362         require(msg.sender == investingContract);
363         _;
364     }
365 
366     constructor (address _investingContract) public {
367         investingContract = _investingContract;
368         owner = msg.sender;
369     }
370     function mint(address to, uint256 value) external onlyInvestingContract returns (bool) {
371         _mint(to, value);
372         return true;
373     }
374 	
375 	function transferInvestingContract(address newContract) public onlyOwner {
376         require(newContract != address(0));
377         investingContract = newContract;
378     }
379 }
380 
381 contract LoanyToken is ERC20, ERC20Detailed, ERC20Mintable {
382 
383     constructor(
384         string name,
385         string symbol,
386         uint8 decimals,
387         address investingContract
388     )
389     ERC20Mintable(investingContract)
390     ERC20Detailed(name, symbol, decimals)
391     ERC20()
392     public
393     {
394 
395     }
396 }