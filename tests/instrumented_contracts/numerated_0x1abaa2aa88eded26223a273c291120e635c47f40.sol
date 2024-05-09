1 pragma solidity ^0.5.0;
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
218 contract MAU is IERC20, Ownable, Pausable {
219     using SafeMath for uint256;
220 
221     mapping (address => uint256) private _balances;
222     mapping (address => mapping (address => uint256)) private _allowed;
223 
224     string private _name = "MetexGold";
225     string private _symbol = "MAU";
226     uint256 private _decimals = 18;
227     uint256 private _totalSupply;
228     string public certificate;
229     uint256 private initialAmount = 0;
230 
231     constructor(string memory certHash) public {
232         certificate = certHash;
233         mint(msg.sender, initialAmount);
234     }
235 
236     /**
237      * @return the name of the token.
238      */
239     function name() public view returns (string memory) {
240         return _name;
241     }
242 
243     /**
244      * @return the symbol of the token.
245      */
246     function symbol() public view returns (string memory) {
247         return _symbol;
248     }
249 
250     /**
251      * @return the number of decimals of the token.
252      */
253     function decimals() public view returns (uint256) {
254         return _decimals;
255     }
256 
257     function totalSupply() public view returns (uint256) {
258         return _totalSupply;
259     }
260 
261     /**
262     * @dev Gets the balance of the specified address.
263     * @param owner The address to query the balance of.
264     * @return An uint256 representing the amount owned by the passed address.
265     */
266     function balanceOf(address owner) public view returns (uint256) {
267         return _balances[owner];
268     }
269 
270     /**
271      * @dev Function to check the amount of tokens that an owner allowed to a spender.
272      * @param owner address The address which owns the funds.
273      * @param spender address The address which will spend the funds.
274      * @return A uint256 specifying the amount of tokens still available for the spender.
275      */
276     function allowance(address owner, address spender) public view returns (uint256) {
277         return _allowed[owner][spender];
278     }
279 
280     /**
281     * @dev Transfer token for a specified address
282     * @param to The address to transfer to.
283     * @param value The amount to be transferred.
284     */
285     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
286         _transfer(msg.sender, to, value);
287         return true;
288     }
289 
290     /**
291      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
292      * Beware that changing an allowance with this method brings the risk that someone may use both the old
293      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
294      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
295      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296      * @param spender The address which will spend the funds.
297      * @param value The amount of tokens to be spent.
298      */
299     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
300         require(spender != address(0));
301 
302         _allowed[msg.sender][spender] = value;
303         emit Approval(msg.sender, spender, value);
304         return true;
305     }
306 
307     /**
308      * @dev Transfer tokens from one address to another.
309      * Note that while this function emits an Approval event, this is not required as per the specification,
310      * and other compliant implementations may not emit the event.
311      * @param from address The address which you want to send tokens from
312      * @param to address The address which you want to transfer to
313      * @param value uint256 the amount of tokens to be transferred
314      */
315     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
316         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
317         _transfer(from, to, value);
318         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
319         return true;
320     }
321 
322     /**
323      * @dev Increase the amount of tokens that an owner allowed to a spender.
324      * approve should be called when allowed_[_spender] == 0. To increment
325      * allowed value is better to use this function to avoid 2 calls (and wait until
326      * the first transaction is mined)
327      * From MonolithDAO Token.sol
328      * Emits an Approval event.
329      * @param spender The address which will spend the funds.
330      * @param addedValue The amount of tokens to increase the allowance by.
331      */
332     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
333         require(spender != address(0));
334 
335         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
336         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
337         return true;
338     }
339 
340     /**
341      * @dev Decrease the amount of tokens that an owner allowed to a spender.
342      * approve should be called when allowed_[_spender] == 0. To decrement
343      * allowed value is better to use this function to avoid 2 calls (and wait until
344      * the first transaction is mined)
345      * From MonolithDAO Token.sol
346      * Emits an Approval event.
347      * @param spender The address which will spend the funds.
348      * @param subtractedValue The amount of tokens to decrease the allowance by.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
351         require(spender != address(0));
352 
353         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
354         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
355         return true;
356     }
357 
358     /**
359     * @dev Transfer token for a specified addresses
360     * @param from The address to transfer from.
361     * @param to The address to transfer to.
362     * @param value The amount to be transferred.
363     */
364     function _transfer(address from, address to, uint256 value) internal {
365         require(to != address(0));
366 
367         _balances[from] = _balances[from].sub(value);
368         _balances[to] = _balances[to].add(value);
369         emit Transfer(from, to, value);
370     }
371 
372     function mint(address to, uint256 value) public onlyOwner returns (bool) {
373         require(to != address(0));
374 
375         _totalSupply = _totalSupply.add(value);
376         _balances[to] = _balances[to].add(value);
377         emit Transfer(address(0), to, value);
378         return true;
379     }
380 
381     /**
382      * @dev Burns a specific amount of tokens.
383      * @param value The amount of token to be burned.
384      */
385     function burn(uint256 value) onlyOwner public {
386         require(msg.sender != address(0));
387 
388         _totalSupply = _totalSupply.sub(value);
389         _balances[msg.sender] = _balances[msg.sender].sub(value);
390         emit Transfer(msg.sender, address(0), value);
391     }
392 
393     /**
394      * @dev Set the IPFS hash to the certificate
395      * @param hash The new IPFS hash
396      */
397     function setCertificate(string memory hash) public onlyOwner {
398         certificate = hash;
399     }
400 }