1 pragma solidity ^0.5.2;
2 
3 /** Thanks to OpenZeppelin for the awesome Libraries and SmartContracts. */
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two unsigned integers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
74     address private _newOwner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor () internal {
83         _owner = msg.sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     /**
88      * @return the address of the owner.
89      */
90     function owner() public view returns (address) {
91         return _owner;
92     }
93     /**
94      * @return the address of the newOwner.
95      */
96     function newOwner_() public view returns (address) {
97         return _newOwner;
98     }
99     
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(isOwner());
105         _;
106     }
107 
108     /**
109      * @return true if `msg.sender` is the owner of the contract.
110      */
111     function isOwner() public view returns (bool) {
112         return msg.sender == _owner;
113     }
114 
115     /**
116      * @dev Allows the current owner to relinquish control of the contract.
117      * @notice Renouncing to ownership will leave the contract without an owner.
118      * It will not be possible to call the functions with the `onlyOwner`
119      * modifier anymore.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _newOwner = newOwner;
132     }
133     
134     function acceptOwnership() public{
135         require(msg.sender == _newOwner);
136         _transferOwnership(_newOwner);
137     }
138 
139     /**
140      * @dev Transfers control of the contract to a newOwner.
141      * @param newOwner The address to transfer ownership to.
142      */
143     function _transferOwnership(address newOwner) internal {
144         require(newOwner != address(0) && _newOwner == newOwner);
145         emit OwnershipTransferred(_owner, newOwner);
146         _owner = newOwner;
147     }
148 }
149 
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 interface IERC20 {
156     function transfer(address to, uint256 value) external returns (bool);
157 
158     function approve(address spender, uint256 value) external returns (bool);
159 
160     function transferFrom(address from, address to, uint256 value) external returns (bool);
161 
162     function totalSupply() external view returns (uint256);
163 
164     function balanceOf(address who) external view returns (uint256);
165 
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 contract ERC20 is IERC20 , Ownable{
174     using SafeMath for uint256;
175 
176     mapping (address => uint256) private _balances;
177 
178     mapping (address => mapping (address => uint256)) private _allowed;
179 
180     uint256 private _totalSupply;
181 
182     /**
183     * @dev Total number of tokens in existence
184     */
185     function totalSupply() public view returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param owner The address to query the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address owner) public view returns (uint256) {
195         return _balances[owner];
196     }
197 
198     /**
199      * @dev Function to check the amount of tokens that an owner allowed to a spender.
200      * @param owner address The address which owns the funds.
201      * @param spender address The address which will spend the funds.
202      * @return A uint256 specifying the amount of tokens still available for the spender.
203      */
204     function allowance(address owner, address spender) public view returns (uint256) {
205         return _allowed[owner][spender];
206     }
207 
208     /**
209     * @dev Transfer token for a specified address
210     * @param to The address to transfer to.
211     * @param value The amount to be transferred.
212     */
213     function transfer(address to, uint256 value) public returns (bool) {
214         _transfer(msg.sender, to, value);
215         return true;
216     }
217 
218     /**
219      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220      * Beware that changing an allowance with this method brings the risk that someone may use both the old
221      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224      * @param spender The address which will spend the funds.
225      * @param value The amount of tokens to be spent.
226      */
227     function approve(address spender, uint256 value) public returns (bool) {
228         _approve(msg.sender, spender, value);
229         return true;
230     }
231 
232     /**
233      * @dev Transfer tokens from one address to another.
234      * Note that while this function emits an Approval event, this is not required as per the specification,
235      * and other compliant implementations may not emit the event.
236      * @param from address The address which you want to send tokens from
237      * @param to address The address which you want to transfer to
238      * @param value uint256 the amount of tokens to be transferred
239      */
240     function transferFrom(address from, address to, uint256 value) public returns (bool) {
241         _transfer(from, to, value);
242         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
243         return true;
244     }
245 
246     /**
247      * @dev Increase the amount of tokens that an owner allowed to a spender.
248      * approve should be called when allowed_[_spender] == 0. To increment
249      * allowed value is better to use this function to avoid 2 calls (and wait until
250      * the first transaction is mined)
251      * From MonolithDAO Token.sol
252      * Emits an Approval event.
253      * @param spender The address which will spend the funds.
254      * @param addedValue The amount of tokens to increase the allowance by.
255      */
256     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
257         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
258         return true;
259     }
260 
261     /**
262      * @dev Decrease the amount of tokens that an owner allowed to a spender.
263      * approve should be called when allowed_[_spender] == 0. To decrement
264      * allowed value is better to use this function to avoid 2 calls (and wait until
265      * the first transaction is mined)
266      * From MonolithDAO Token.sol
267      * Emits an Approval event.
268      * @param spender The address which will spend the funds.
269      * @param subtractedValue The amount of tokens to decrease the allowance by.
270      */
271     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
272         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
273         return true;
274     }
275 
276     /**
277     * @dev Transfer token for a specified addresses
278     * @param from The address to transfer from.
279     * @param to The address to transfer to.
280     * @param value The amount to be transferred.
281     */
282     function _transfer(address from, address to, uint256 value) internal {
283         require(to != address(0));
284 
285         _balances[from] = _balances[from].sub(value);
286         _balances[to] = _balances[to].add(value);
287         emit Transfer(from, to, value);
288     }
289 
290     /**
291      * @dev Internal function that mints an amount of the token and assigns it to
292      * an account. This encapsulates the modification of balances such that the
293      * proper events are emitted.
294      * @param account The account that will receive the created tokens.
295      * @param value The amount that will be created.
296      */
297     function _mint(address account, uint256 value) internal onlyOwner {
298         require(account != address(0));
299 
300         _totalSupply = _totalSupply.add(value);
301         _balances[account] = _balances[account].add(value);
302         emit Transfer(address(0), account, value);
303     }
304 
305 
306     /**
307      * @dev Approve an address to spend another addresses' tokens.
308      * @param owner The address that owns the tokens.
309      * @param spender The address that will spend the tokens.
310      * @param value The number of tokens that can be spent.
311      */
312     function _approve(address owner, address spender, uint256 value) internal {
313         require(spender != address(0));
314         require(owner != address(0));
315 
316         _allowed[owner][spender] = value;
317         emit Approval(owner, spender, value);
318     }
319 
320 
321 }
322 /**
323  * @title ERC20Detailed token
324  * @dev The decimals are only for visualization purposes.
325  * All the operations are done using the smallest and indivisible token unit,
326  * just as on Ethereum all the operations are done in wei.
327  */
328 contract ERC20Detailed is IERC20 {
329     string internal _name;
330     string internal _symbol;
331     uint8 internal _decimals;
332 
333     constructor (string memory name, string memory symbol, uint8 decimals) public {
334         _name = name;
335         _symbol = symbol;
336         _decimals = decimals;
337     }
338 
339     /**
340      * @return the name of the token.
341      */
342     function name() public view returns (string memory) {
343         return _name;
344     }
345 
346     /**
347      * @return the symbol of the token.
348      */
349     function symbol() public view returns (string memory) {
350         return _symbol;
351     }
352 
353     /**
354      * @return the number of decimals of the token.
355      */
356     function decimals() public view returns (uint8) {
357         return _decimals;
358     }
359 }
360 /**
361  * @title SimpleToken
362  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
363  * Note they can later distribute these tokens as they wish using `transfer` and other
364  * `ERC20` functions.
365  */
366 contract Token is ERC20, ERC20Detailed {
367     
368     uint8 public constant DECIMALS = 18;
369     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(DECIMALS));
370 
371     /**
372      * @dev Constructor that gives msg.sender all of existing tokens.
373      */
374     constructor () public ERC20Detailed("TRADERX COIN", "TDR", DECIMALS) {
375         _mint(msg.sender, INITIAL_SUPPLY);
376     }
377     
378     /** 
379      * @dev send to more than one wallet
380      */
381     function multiSendToken(address[] memory _beneficiary, uint256 [] memory _value) public  {
382         require(_beneficiary.length != 0, "Is not possible to send null value");
383         require(_beneficiary.length == _value.length, "_beneficiary and _value need to have the same length");
384         uint256 _length = _value.length;
385         uint256 sumValue = 0;
386         for(uint256 i = 0; i < _length; i++){
387             sumValue = sumValue + _value[i];
388         }
389         require(balanceOf(msg.sender) >= sumValue, "Insufficient balance");
390         
391         for(uint256 i = 0; i < _length; i++){
392             transfer(_beneficiary[i],_value[i]);
393         }
394     }
395     
396 }