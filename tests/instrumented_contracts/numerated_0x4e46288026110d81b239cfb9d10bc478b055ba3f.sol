1 pragma solidity 0.5.4;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
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
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     /**
37      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38      * account.
39      */
40     constructor () internal {
41         _owner = msg.sender;
42         emit OwnershipTransferred(address(0), _owner);
43     }
44 
45     /**
46      * @return the address of the owner.
47      */
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(isOwner());
57         _;
58     }
59 
60     /**
61      * @return true if `msg.sender` is the owner of the contract.
62      */
63     function isOwner() public view returns (bool) {
64         return msg.sender == _owner;
65     }
66 
67     /**
68      * @dev Allows the current owner to relinquish control of the contract.
69      * @notice Renouncing to ownership will leave the contract without an owner.
70      * It will not be possible to call the functions with the `onlyOwner`
71      * modifier anymore.
72      */
73     function renounceOwnership() public onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         _transferOwnership(newOwner);
84     }
85 
86     /**
87      * @dev Transfers control of the contract to a newOwner.
88      * @param newOwner The address to transfer ownership to.
89      */
90     function _transferOwnership(address newOwner) internal {
91         require(newOwner != address(0));
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103     event Paused(address account);
104     event Unpaused(address account);
105 
106     bool private _paused;
107 
108     constructor () internal {
109         _paused = false;
110     }
111 
112     /**
113      * @return true if the contract is paused, false otherwise.
114      */
115     function paused() public view returns (bool) {
116         return _paused;
117     }
118 
119     /**
120      * @dev Modifier to make a function callable only when the contract is not paused.
121      */
122     modifier whenNotPaused() {
123         require(!_paused);
124         _;
125     }
126 
127     /**
128      * @dev Modifier to make a function callable only when the contract is paused.
129      */
130     modifier whenPaused() {
131         require(_paused);
132         _;
133     }
134 
135     /**
136      * @dev called by the owner to pause, triggers stopped state
137      */
138     function pause() public onlyOwner whenNotPaused {
139         _paused = true;
140         emit Paused(msg.sender);
141     }
142 
143     /**
144      * @dev called by the owner to unpause, returns to normal state
145      */
146     function unpause() public onlyOwner whenPaused {
147         _paused = false;
148         emit Unpaused(msg.sender);
149     }
150 }
151 
152 
153 /**
154  * @title SafeMath
155  * @dev Unsigned math operations with safety checks that revert on error
156  */
157 library SafeMath {
158     /**
159     * @dev Multiplies two unsigned integers, reverts on overflow.
160     */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b);
171 
172         return c;
173     }
174 
175     /**
176     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
177     */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Solidity only automatically asserts when dividing by 0
180         require(b > 0);
181         uint256 c = a / b;
182         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184         return c;
185     }
186 
187     /**
188     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
189     */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         require(b <= a);
192         uint256 c = a - b;
193 
194         return c;
195     }
196 
197     /**
198     * @dev Adds two unsigned integers, reverts on overflow.
199     */
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a);
203 
204         return c;
205     }
206 
207     /**
208     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
209     * reverts when dividing by zero.
210     */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         require(b != 0);
213         return a % b;
214     }
215 }
216 
217 
218 contract MPD is IERC20, Ownable, Pausable {
219     using SafeMath for uint256;
220 
221     mapping (address => uint256) private _balances;
222     mapping (address => mapping (address => uint256)) private _allowed;
223 
224     string private _name = "MetexPalladium";
225     string private _symbol = "MPD";
226     uint256 private _decimals = 18;
227     uint256 private _totalSupply;
228     string public certificate;
229     //uint256 private initialAmount = 10 * (10 ** _decimals);
230     uint256 private initialAmount = 0;
231 
232     constructor(string memory certHash) public {
233         certificate = certHash;
234         mint(msg.sender, initialAmount);
235     }
236 
237     /**
238      * @return the name of the token.
239      */
240     function name() public view returns (string memory) {
241         return _name;
242     }
243 
244     /**
245      * @return the symbol of the token.
246      */
247     function symbol() public view returns (string memory) {
248         return _symbol;
249     }
250 
251     /**
252      * @return the number of decimals of the token.
253      */
254     function decimals() public view returns (uint256) {
255         return _decimals;
256     }
257 
258     function totalSupply() public view returns (uint256) {
259         return _totalSupply;
260     }
261 
262     /**
263     * @dev Gets the balance of the specified address.
264     * @param owner The address to query the balance of.
265     * @return An uint256 representing the amount owned by the passed address.
266     */
267     function balanceOf(address owner) public view returns (uint256) {
268         return _balances[owner];
269     }
270 
271     /**
272      * @dev Function to check the amount of tokens that an owner allowed to a spender.
273      * @param owner address The address which owns the funds.
274      * @param spender address The address which will spend the funds.
275      * @return A uint256 specifying the amount of tokens still available for the spender.
276      */
277     function allowance(address owner, address spender) public view returns (uint256) {
278         return _allowed[owner][spender];
279     }
280 
281     /**
282     * @dev Transfer token for a specified address
283     * @param to The address to transfer to.
284     * @param value The amount to be transferred.
285     */
286     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
287         _transfer(msg.sender, to, value);
288         return true;
289     }
290 
291     /**
292      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
293      * Beware that changing an allowance with this method brings the risk that someone may use both the old
294      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297      * @param spender The address which will spend the funds.
298      * @param value The amount of tokens to be spent.
299      */
300     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
301         require(spender != address(0));
302 
303         _allowed[msg.sender][spender] = value;
304         emit Approval(msg.sender, spender, value);
305         return true;
306     }
307 
308     /**
309      * @dev Transfer tokens from one address to another.
310      * Note that while this function emits an Approval event, this is not required as per the specification,
311      * and other compliant implementations may not emit the event.
312      * @param from address The address which you want to send tokens from
313      * @param to address The address which you want to transfer to
314      * @param value uint256 the amount of tokens to be transferred
315      */
316     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
317         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
318         _transfer(from, to, value);
319         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
320         return true;
321     }
322 
323     /**
324      * @dev Increase the amount of tokens that an owner allowed to a spender.
325      * approve should be called when allowed_[_spender] == 0. To increment
326      * allowed value is better to use this function to avoid 2 calls (and wait until
327      * the first transaction is mined)
328      * From MonolithDAO Token.sol
329      * Emits an Approval event.
330      * @param spender The address which will spend the funds.
331      * @param addedValue The amount of tokens to increase the allowance by.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
334         require(spender != address(0));
335 
336         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
337         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
338         return true;
339     }
340 
341     /**
342      * @dev Decrease the amount of tokens that an owner allowed to a spender.
343      * approve should be called when allowed_[_spender] == 0. To decrement
344      * allowed value is better to use this function to avoid 2 calls (and wait until
345      * the first transaction is mined)
346      * From MonolithDAO Token.sol
347      * Emits an Approval event.
348      * @param spender The address which will spend the funds.
349      * @param subtractedValue The amount of tokens to decrease the allowance by.
350      */
351     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
352         require(spender != address(0));
353 
354         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
355         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
356         return true;
357     }
358 
359     /**
360     * @dev Transfer token for a specified addresses
361     * @param from The address to transfer from.
362     * @param to The address to transfer to.
363     * @param value The amount to be transferred.
364     */
365     function _transfer(address from, address to, uint256 value) internal {
366         require(to != address(0));
367 
368         _balances[from] = _balances[from].sub(value);
369         _balances[to] = _balances[to].add(value);
370         emit Transfer(from, to, value);
371     }
372 
373     function mint(address to, uint256 value) public onlyOwner returns (bool) {
374         require(to != address(0));
375 
376         _totalSupply = _totalSupply.add(value);
377         _balances[to] = _balances[to].add(value);
378         emit Transfer(address(0), to, value);
379         return true;
380     }
381 
382     /**
383      * @dev Burns a specific amount of tokens.
384      * @param value The amount of token to be burned.
385      */
386     function burn(uint256 value) onlyOwner public {
387         require(msg.sender != address(0));
388 
389         _totalSupply = _totalSupply.sub(value);
390         _balances[msg.sender] = _balances[msg.sender].sub(value);
391         emit Transfer(msg.sender, address(0), value);
392     }
393 
394     /**
395      * @dev Set the IPFS hash to the certificate
396      * @param hash The new IPFS hash
397      */
398     function setCertificate(string memory hash) public onlyOwner {
399         certificate = hash;
400     }
401 }