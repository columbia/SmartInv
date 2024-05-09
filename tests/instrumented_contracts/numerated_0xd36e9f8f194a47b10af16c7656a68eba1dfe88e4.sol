1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
10     */
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a);
13         uint256 c = a - b;
14 
15         return c;
16     }
17 
18     /**
19     * @dev Adds two numbers, reverts on overflow.
20     */
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a);
24 
25         return c;
26     }
27 }
28 
29 
30 /**
31  * @title ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 interface IEIPERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address who) external view returns (uint256);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function transfer(address to, uint256 value) external returns (bool);
42 
43     function approve(address spender, uint256 value) external returns (bool);
44 
45     function transferFrom(address from, address to, uint256 value) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59 
60     address internal _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @return the address of the owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == _owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to relinquish control of the contract.
81      * @notice Renouncing to ownership will leave the contract without an owner.
82      * It will not be possible to call the functions with the `onlyOwner`
83      * modifier anymore.
84      */
85     function renounceOwnership() public onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Allows the current owner to transfer control of the contract to a newOwner.
92      * @param newOwner The address to transfer ownership to.
93      */
94     function transferOwnership(address newOwner) public onlyOwner {
95         require(newOwner != address(0));
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 /**
103  * @title Mintable
104  */
105 contract Mintable is Ownable {
106 
107     address internal _minter;
108 
109     // public variables
110     bool public mintingClosed = true;
111 
112     event MinterTransferred(address indexed previousMinter, address indexed newMinter);
113     event MintSwitched(bool mintingIsClosed);
114 
115     /**
116      * @return the address of the minter.
117      */
118     function minter() public view returns (address) {
119         return _minter;
120     }
121 
122     /**
123      * @dev Throws if called by any account other than the minter.
124      */
125     modifier onlyMinter() {
126         require(msg.sender == _minter);
127         _;
128     }
129 
130     modifier canMint() {
131         require(!mintingClosed);
132         _;
133     }
134 
135     /**
136      * @dev Allows the current minter to transfer control of the contract to a newMinter.
137      * @param newMinter The address to transfer minter to.
138      */
139     function transferMinter(address newMinter) public onlyOwner {
140         require(newMinter != address(0));
141         emit MinterTransferred(_minter, newMinter);
142         _minter = newMinter;
143     }
144 
145     function switchMinting() public onlyOwner returns (bool) {
146         mintingClosed = !mintingClosed;
147         emit MintSwitched(mintingClosed);
148         return true;
149     }
150 }
151 
152 /**
153  * @title ExtensionToken token
154  * 
155  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
156  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
157  * compliant implementations may not do it.
158  */
159 contract ExtensionToken is IEIPERC20, Mintable {
160     using SafeMath for uint256;
161 
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowed;
165 
166     uint256 private _totalSupply;
167 
168     /**
169     * @dev Total number of tokens in existence
170     */
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     /**
176     * @dev Gets the balance of the specified address.
177     * @param owner The address to query the balance of.
178     * @return An uint256 representing the amount owned by the passed address.
179     */
180     function balanceOf(address owner) public view returns (uint256) {
181         return _balances[owner];
182     }
183 
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param owner address The address which owns the funds.
187      * @param spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      */
190     function allowance(address owner, address spender) public view returns (uint256) {
191         return _allowed[owner][spender];
192     }
193 
194     /**
195     * @dev Transfer token for a specified address
196     * @param to The address to transfer to.
197     * @param value The amount to be transferred.
198     */
199     function transfer(address to, uint256 value) public returns (bool) {
200         _transfer(msg.sender, to, value);
201         return true;
202     }
203 
204     /**
205      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * Beware that changing an allowance with this method brings the risk that someone may use both the old
207      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      * @param spender The address which will spend the funds.
211      * @param value The amount of tokens to be spent.
212      */
213     function approve(address spender, uint256 value) public returns (bool) {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = value;
217         emit Approval(msg.sender, spender, value);
218         return true;
219     }
220 
221     /**
222      * @dev Transfer tokens from one address to another.
223      * Note that while this function emits an Approval event, this is not required as per the specification,
224      * and other compliant implementations may not emit the event.
225      * @param from address The address which you want to send tokens from
226      * @param to address The address which you want to transfer to
227      * @param value uint256 the amount of tokens to be transferred
228      */
229     function transferFrom(address from, address to, uint256 value) public returns (bool) {
230         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
231         _transfer(from, to, value);
232         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
233         return true;
234     }
235 
236     /**
237      * @dev Increase the amount of tokens that an owner allowed to a spender.
238      * approve should be called when allowed_[_spender] == 0. To increment
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param addedValue The amount of tokens to increase the allowance by.
245      */
246     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
247         require(spender != address(0));
248 
249         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
250         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251         return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender.
256      * approve should be called when allowed_[_spender] == 0. To decrement
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * Emits an Approval event.
261      * @param spender The address which will spend the funds.
262      * @param subtractedValue The amount of tokens to decrease the allowance by.
263      */
264     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
265         require(spender != address(0));
266 
267         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
268         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
269         return true;
270     }
271 
272     /**
273     * @dev Transfer token for a specified addresses
274     * @param from The address to transfer from.
275     * @param to The address to transfer to.
276     * @param value The amount to be transferred.
277     */
278     function _transfer(address from, address to, uint256 value) internal {
279         require(to != address(0));
280 
281         _balances[from] = _balances[from].sub(value);
282         _balances[to] = _balances[to].add(value);
283         emit Transfer(from, to, value);
284     }
285 
286     /**
287      * @dev Internal function that mints an amount of the token and assigns it to
288      * an account. This encapsulates the modification of balances such that the
289      * proper events are emitted.
290      * @param account The account that will receive the created tokens.
291      * @param value The amount that will be created.
292      */
293     function _mint(address account, uint256 value) internal {
294         require(account != address(0));
295 
296         _totalSupply = _totalSupply.add(value);
297         _balances[account] = _balances[account].add(value);
298         emit Transfer(address(0), account, value);
299     }
300 
301     /**
302      * @dev Internal function that burns an amount of the token of a given
303      * account.
304      * @param account The account whose tokens will be burnt.
305      * @param value The amount that will be burnt.
306      */
307     function _burn(address account, uint256 value) internal {
308         require(account != address(0));
309 
310         _totalSupply = _totalSupply.sub(value);
311         _balances[account] = _balances[account].sub(value);
312         emit Transfer(account, address(0), value);
313     }
314 }
315 
316 
317 /**
318  *
319  *  Atlas Token Contract Requirement
320  *  •	Standard ERC20 Token
321  *  •	Name: Atlas Token
322  *  •	Ticker: ATLS
323  *  •	18 Decimal numbers
324  *  •	Live mint function for potential inflation
325  *  •	Live burn function for potential token destroyed
326  *  Atlas Token Metrics
327  *  •	Total Supply: 875,000,000 ATLS
328  ***/
329 contract AtlasToken is ExtensionToken {
330     string public name = "Atlas Token"; 
331     string public symbol = "ATLS";
332     uint256 public decimals = 18;
333 
334     constructor(address owner, address minter) public {
335         _minter = minter;
336         _owner = owner;
337 
338         uint256 totalSupply_ = 875000000 * (10 ** decimals);
339         _mint(_owner, totalSupply_);
340     }
341 
342     /**
343      * @dev Function to mint tokens
344      * @param value The amount of tokens to mint.
345      * @return A boolean that indicates if the operation was successful.
346      */
347     function mint(uint256 value) public onlyMinter canMint returns (bool) {
348         _mint(_owner, value);
349         return true;
350     }
351 
352     /**
353      * @dev Burns a specific amount of tokens.
354      * @param value The amount of token to be burned.
355      */
356     function burn(uint256 value) public onlyOwner {
357         _burn(msg.sender, value);
358     }
359 }