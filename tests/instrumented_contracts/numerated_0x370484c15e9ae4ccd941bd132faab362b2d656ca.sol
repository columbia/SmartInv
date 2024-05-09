1 library SafeMath {
2     /**
3     * @dev Multiplies two unsigned integers, reverts on overflow.
4     */
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
7         // benefit is lost if 'b' is also tested.
8         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9         if (a == 0) {
10             return 0;
11         }
12 
13         uint256 c = a * b;
14         require(c / a == b);
15 
16         return c;
17     }
18 
19     /**
20     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // Solidity only automatically asserts when dividing by 0
24         require(b > 0);
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27 
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a);
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41     /**
42     * @dev Adds two unsigned integers, reverts on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
53     * reverts when dividing by zero.
54     */
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0);
57         return a % b;
58     }
59 }
60 
61 interface IERC20 {
62     function transfer(address to, uint256 value) external returns (bool);
63 
64     function approve(address spender, uint256 value) external returns (bool);
65 
66     function transferFrom(address from, address to, uint256 value) external returns (bool);
67 
68     function totalSupply() external view returns (uint256);
69 
70     function balanceOf(address who) external view returns (uint256);
71 
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract ERC20 is IERC20 {
80     using SafeMath for uint256;
81 
82     mapping (address => uint256) private _balances;
83 
84     mapping (address => mapping (address => uint256)) private _allowed;
85 
86     uint256 private _totalSupply;
87 
88     /**
89     * @dev Total number of tokens in existence
90     */
91     function totalSupply() public view returns (uint256) {
92         return _totalSupply;
93     }
94 
95     /**
96     * @dev Gets the balance of the specified address.
97     * @param owner The address to query the balance of.
98     * @return An uint256 representing the amount owned by the passed address.
99     */
100     function balanceOf(address owner) public view returns (uint256) {
101         return _balances[owner];
102     }
103 
104     /**
105      * @dev Function to check the amount of tokens that an owner allowed to a spender.
106      * @param owner address The address which owns the funds.
107      * @param spender address The address which will spend the funds.
108      * @return A uint256 specifying the amount of tokens still available for the spender.
109      */
110     function allowance(address owner, address spender) public view returns (uint256) {
111         return _allowed[owner][spender];
112     }
113 
114     /**
115     * @dev Transfer token for a specified address
116     * @param to The address to transfer to.
117     * @param value The amount to be transferred.
118     */
119     function transfer(address to, uint256 value) public returns (bool) {
120         _transfer(msg.sender, to, value);
121         return true;
122     }
123 
124     /**
125      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126      * Beware that changing an allowance with this method brings the risk that someone may use both the old
127      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      * @param spender The address which will spend the funds.
131      * @param value The amount of tokens to be spent.
132      */
133     function approve(address spender, uint256 value) public returns (bool) {
134         require(spender != address(0));
135 
136         _allowed[msg.sender][spender] = value;
137         emit Approval(msg.sender, spender, value);
138         return true;
139     }
140 
141     /**
142      * @dev Transfer tokens from one address to another.
143      * Note that while this function emits an Approval event, this is not required as per the specification,
144      * and other compliant implementations may not emit the event.
145      * @param from address The address which you want to send tokens from
146      * @param to address The address which you want to transfer to
147      * @param value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(address from, address to, uint256 value) public returns (bool) {
150         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
151         _transfer(from, to, value);
152         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
153         return true;
154     }
155 
156     /**
157      * @dev Increase the amount of tokens that an owner allowed to a spender.
158      * approve should be called when allowed_[_spender] == 0. To increment
159      * allowed value is better to use this function to avoid 2 calls (and wait until
160      * the first transaction is mined)
161      * From MonolithDAO Token.sol
162      * Emits an Approval event.
163      * @param spender The address which will spend the funds.
164      * @param addedValue The amount of tokens to increase the allowance by.
165      */
166     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
167         require(spender != address(0));
168 
169         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
170         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
171         return true;
172     }
173 
174     /**
175      * @dev Decrease the amount of tokens that an owner allowed to a spender.
176      * approve should be called when allowed_[_spender] == 0. To decrement
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param subtractedValue The amount of tokens to decrease the allowance by.
183      */
184     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
185         require(spender != address(0));
186 
187         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
188         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
189         return true;
190     }
191 
192     /**
193     * @dev Transfer token for a specified addresses
194     * @param from The address to transfer from.
195     * @param to The address to transfer to.
196     * @param value The amount to be transferred.
197     */
198     function _transfer(address from, address to, uint256 value) internal {
199         require(to != address(0));
200 
201         _balances[from] = _balances[from].sub(value);
202         _balances[to] = _balances[to].add(value);
203         emit Transfer(from, to, value);
204     }
205 
206     /**
207      * @dev Internal function that mints an amount of the token and assigns it to
208      * an account. This encapsulates the modification of balances such that the
209      * proper events are emitted.
210      * @param account The account that will receive the created tokens.
211      * @param value The amount that will be created.
212      */
213     function _mint(address account, uint256 value) internal {
214         require(account != address(0));
215 
216         _totalSupply = _totalSupply.add(value);
217         _balances[account] = _balances[account].add(value);
218         emit Transfer(address(0), account, value);
219     }
220 
221     /**
222      * @dev Internal function that burns an amount of the token of a given
223      * account.
224      * @param account The account whose tokens will be burnt.
225      * @param value The amount that will be burnt.
226      */
227     function _burn(address account, uint256 value) internal {
228         require(account != address(0));
229 
230         _totalSupply = _totalSupply.sub(value);
231         _balances[account] = _balances[account].sub(value);
232         emit Transfer(account, address(0), value);
233     }
234 
235     /**
236      * @dev Internal function that burns an amount of the token of a given
237      * account, deducting from the sender's allowance for said account. Uses the
238      * internal burn function.
239      * Emits an Approval event (reflecting the reduced allowance).
240      * @param account The account whose tokens will be burnt.
241      * @param value The amount that will be burnt.
242      */
243     function _burnFrom(address account, uint256 value) internal {
244         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
245         _burn(account, value);
246         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
247     }
248 }
249 
250 contract Ownable {
251     address private _owner;
252 
253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255     /**
256      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
257      * account.
258      */
259     constructor () internal {
260         _owner = msg.sender;
261         emit OwnershipTransferred(address(0), _owner);
262     }
263 
264     /**
265      * @return the address of the owner.
266      */
267     function owner() public view returns (address) {
268         return _owner;
269     }
270 
271     /**
272      * @dev Throws if called by any account other than the owner.
273      */
274     modifier onlyOwner() {
275         require(isOwner());
276         _;
277     }
278 
279     /**
280      * @return true if `msg.sender` is the owner of the contract.
281      */
282     function isOwner() public view returns (bool) {
283         return msg.sender == _owner;
284     }
285 
286     /**
287      * @dev Allows the current owner to relinquish control of the contract.
288      * @notice Renouncing to ownership will leave the contract without an owner.
289      * It will not be possible to call the functions with the `onlyOwner`
290      * modifier anymore.
291      */
292     function renounceOwnership() public onlyOwner {
293         emit OwnershipTransferred(_owner, address(0));
294         _owner = address(0);
295     }
296 
297     /**
298      * @dev Allows the current owner to transfer control of the contract to a newOwner.
299      * @param newOwner The address to transfer ownership to.
300      */
301     function transferOwnership(address newOwner) public onlyOwner {
302         _transferOwnership(newOwner);
303     }
304 
305     /**
306      * @dev Transfers control of the contract to a newOwner.
307      * @param newOwner The address to transfer ownership to.
308      */
309     function _transferOwnership(address newOwner) internal {
310         require(newOwner != address(0));
311         emit OwnershipTransferred(_owner, newOwner);
312         _owner = newOwner;
313     }
314 }
315 
316 contract ERC20Detailed is IERC20 {
317     string private _name;
318     string private _symbol;
319     uint8 private _decimals;
320 
321     constructor (string memory name, string memory symbol, uint8 decimals) public {
322         _name = name;
323         _symbol = symbol;
324         _decimals = decimals;
325     }
326 
327     /**
328      * @return the name of the token.
329      */
330     function name() public view returns (string memory) {
331         return _name;
332     }
333 
334     /**
335      * @return the symbol of the token.
336      */
337     function symbol() public view returns (string memory) {
338         return _symbol;
339     }
340 
341     /**
342      * @return the number of decimals of the token.
343      */
344     function decimals() public view returns (uint8) {
345         return _decimals;
346     }
347 }
348 
349 contract TerraVirtua is ERC20Detailed, ERC20, Ownable {
350 
351     bool public isTransferFrozen = true;
352 
353     mapping(address => bool) public distributors;
354 
355     event DistributionPermissions(address account, bool _value);
356     event TransfersUnfrozen(address account);
357 
358     constructor(address _tokenHolder, uint256 _totalSupply)
359         public
360         ERC20Detailed("Terra Virtua", "TVA", 18)
361     {
362         _mint(_tokenHolder, _totalSupply);
363         distributors[msg.sender] = true;
364         distributors[_tokenHolder] = true;
365     }
366 
367     /**
368      * @dev set or unset distributor address
369      * @param _address The address of distributor.
370      * @param _value The bool value to set or unset permissions.
371      */
372     function setDistributionPermissions(
373         address _address,
374         bool _value
375     )
376         public
377         onlyOwner
378     {
379         distributors[_address] = _value;
380         emit DistributionPermissions(_address, _value);
381     }
382 
383     /**
384     * @dev allow to transfer tokens by everyone to everyone
385     */
386     function unfreezingTransfers() public onlyOwner {
387         isTransferFrozen = false;
388         emit TransfersUnfrozen(msg.sender);
389     }
390 
391     function bulkTransfer(address[] memory _addresses, uint256[] memory _tokens) public {
392         require(_addresses.length == _tokens.length);
393         for (uint256 i = 0; i < _addresses.length; i++) {
394             require(_addresses[i] != address(0) && _tokens[i] > 0);
395 
396             _transfer(msg.sender, _addresses[i], _tokens[i]);
397         }
398     }
399 
400     function _transfer(address from, address to, uint256 value) internal {
401         if (true == isTransferFrozen) {
402             require(
403                 distributors[from] == true || distributors[to] == true,
404                 "Action is not available"
405             );
406         }
407         return super._transfer(from, to, value);
408     }
409 
410 }