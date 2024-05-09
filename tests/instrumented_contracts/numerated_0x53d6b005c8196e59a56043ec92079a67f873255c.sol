1 pragma solidity >=0.4.21 <0.6.0;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract Ownable {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70      * account.
71      */
72     constructor () internal {
73         _owner = msg.sender;
74         emit OwnershipTransferred(address(0), _owner);
75     }
76 
77     /**
78      * @return the address of the owner.
79      */
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(isOwner());
89         _;
90     }
91 
92     /**
93      * @return true if `msg.sender` is the owner of the contract.
94      */
95     function isOwner() public view returns (bool) {
96         return msg.sender == _owner;
97     }
98 
99     /**
100      * @dev Allows the current owner to relinquish control of the contract.
101      * @notice Renouncing to ownership will leave the contract without an owner.
102      * It will not be possible to call the functions with the `onlyOwner`
103      * modifier anymore.
104      */
105     function renounceOwnership() public onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     /**
111      * @dev Allows the current owner to transfer control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address newOwner) public onlyOwner {
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers control of the contract to a newOwner.
120      * @param newOwner The address to transfer ownership to.
121      */
122     function _transferOwnership(address newOwner) internal {
123         require(newOwner != address(0));
124         emit OwnershipTransferred(_owner, newOwner);
125         _owner = newOwner;
126     }
127 }
128 
129 interface IERC20 {
130     function transfer(address to, uint256 value) external returns (bool);
131 
132     function approve(address spender, uint256 value) external returns (bool);
133 
134     function transferFrom(address from, address to, uint256 value) external returns (bool);
135 
136     function totalSupply() external view returns (uint256);
137 
138     function balanceOf(address who) external view returns (uint256);
139 
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 contract ERC20 is IERC20 {
148     using SafeMath for uint256;
149 
150     mapping (address => uint256) internal _balances;
151 
152     mapping (address => mapping (address => uint256)) internal _allowed;
153 
154     uint256 internal _totalSupply;
155 
156     /**
157     * @dev Total number of tokens in existence
158     */
159     function totalSupply() public view returns (uint256) {
160         return _totalSupply;
161     }
162 
163     /**
164     * @dev Gets the balance of the specified address.
165     * @param owner The address to query the balance of.
166     * @return An uint256 representing the amount owned by the passed address.
167     */
168     function balanceOf(address owner) public view returns (uint256) {
169         return _balances[owner];
170     }
171 
172     /**
173      * @dev Function to check the amount of tokens that an owner allowed to a spender.
174      * @param owner address The address which owns the funds.
175      * @param spender address The address which will spend the funds.
176      * @return A uint256 specifying the amount of tokens still available for the spender.
177      */
178     function allowance(address owner, address spender) public view returns (uint256) {
179         return _allowed[owner][spender];
180     }
181 
182     /**
183     * @dev Transfer token for a specified address
184     * @param to The address to transfer to.
185     * @param value The amount to be transferred.
186     */
187     function transfer(address to, uint256 value) public returns (bool) {
188         _transfer(msg.sender, to, value);
189         return true;
190     }
191 
192     /**
193      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param spender The address which will spend the funds.
199      * @param value The amount of tokens to be spent.
200      */
201     function approve(address spender, uint256 value) public returns (bool) {
202         require(spender != address(0));
203 
204         _allowed[msg.sender][spender] = value;
205         emit Approval(msg.sender, spender, value);
206         return true;
207     }
208 
209     /**
210      * @dev Transfer tokens from one address to another.
211      * Note that while this function emits an Approval event, this is not required as per the specification,
212      * and other compliant implementations may not emit the event.
213      * @param from address The address which you want to send tokens from
214      * @param to address The address which you want to transfer to
215      * @param value uint256 the amount of tokens to be transferred
216      */
217     function transferFrom(address from, address to, uint256 value) public returns (bool) {
218         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
219         _transfer(from, to, value);
220         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
221         return true;
222     }
223 
224     /**
225      * @dev Increase the amount of tokens that an owner allowed to a spender.
226      * approve should be called when allowed_[_spender] == 0. To increment
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * Emits an Approval event.
231      * @param spender The address which will spend the funds.
232      * @param addedValue The amount of tokens to increase the allowance by.
233      */
234     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
235         require(spender != address(0));
236 
237         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
238         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
239         return true;
240     }
241 
242     /**
243      * @dev Decrease the amount of tokens that an owner allowed to a spender.
244      * approve should be called when allowed_[_spender] == 0. To decrement
245      * allowed value is better to use this function to avoid 2 calls (and wait until
246      * the first transaction is mined)
247      * From MonolithDAO Token.sol
248      * Emits an Approval event.
249      * @param spender The address which will spend the funds.
250      * @param subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
253         require(spender != address(0));
254 
255         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
256         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
257         return true;
258     }
259 
260     /**
261     * @dev Transfer token for a specified addresses
262     * @param from The address to transfer from.
263     * @param to The address to transfer to.
264     * @param value The amount to be transferred.
265     */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Internal function that burns an amount of the token of a given
305      * account, deducting from the sender's allowance for said account. Uses the
306      * internal burn function.
307      * Emits an Approval event (reflecting the reduced allowance).
308      * @param account The account whose tokens will be burnt.
309      * @param value The amount that will be burnt.
310      */
311     function _burnFrom(address account, uint256 value) internal {
312         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
313         _burn(account, value);
314         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
315     }
316 }
317 
318 contract Equity is ERC20, Ownable {
319 
320     string private _name;
321     string private _symbol;
322     uint8  private _decimals;
323     string private _contractHash;
324     string private _contractUrl;
325 
326     constructor (
327         string memory name,
328         string memory symbol,
329         uint8 decimals,
330         string memory contractHash,
331         string memory contractUrl) public {
332 
333         _name = name;
334         _symbol = symbol;
335         _decimals = decimals;
336         _totalSupply = 0;
337         _contractHash = contractHash;
338         _contractUrl = contractUrl;
339     }
340 
341     /**
342      * @return the name of the token.
343      */
344     function name() public view returns (string memory) {
345         return _name;
346     }
347 
348     /**
349      * @return the symbol of the token.
350      */
351     function symbol() public view returns (string memory) {
352         return _symbol;
353     }
354 
355     /**
356      * @return the number of decimals of the token.
357      */
358     function decimals() public view returns (uint8) {
359         return _decimals;
360     }
361 
362     /**
363      * @return the contractHash
364      */
365     function contractHash() public view returns (string memory) {
366         return _contractHash;
367     }
368 
369      /**
370      * @return the contractUrl
371      */
372     function contractUrl() public view returns (string memory) {
373         return _contractUrl;
374     }
375 
376     /**
377      * @return set the contractUrl
378      */
379     function setContractUrl(string memory url) public onlyOwner returns (bool) {
380         _contractUrl = url;
381         return true;
382     }
383 
384     /**
385     * @dev Destroy the contract
386     */
387     function Destroy() public onlyOwner returns (bool) {
388         selfdestruct(msg.sender);
389         return true;
390     }
391 
392     /**
393     * @dev sudo Transfer tokens
394     * @param from The address to transfer from.
395     * @param to The address to transfer to.
396     * @param value The amount to be transferred.
397     */
398     function sudoTransfer(address from, address to, uint256 value) public onlyOwner returns (bool) {
399         _transfer(from, to, value);
400         return true;
401     }
402 
403     /**
404     * @dev Mint tokens
405     * @param to The address to mint in.
406     * @param value The amount to be minted.
407     */
408     function Mint(address to, uint256 value) public onlyOwner returns (bool) {
409         _mint(to, value);
410         return true;
411     }
412 
413     /**
414     * @dev Burn tokens
415     * @param from The address to burn in.
416     * @param value The amount to be burned.
417     */
418     function Burn(address from, uint256 value) public onlyOwner returns (bool) {
419         _burn(from, value);
420         return true;
421     }
422 
423 }