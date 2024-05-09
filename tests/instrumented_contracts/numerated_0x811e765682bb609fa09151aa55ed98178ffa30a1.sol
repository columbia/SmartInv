1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  * 
7  * @dev Default OpenZeppelin
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  * 
74  * @dev Completely default OpenZeppelin.
75  */
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * It will not be possible to call the functions with the `onlyOwner`
115      * modifier anymore.
116      * @notice Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0));
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 /**
144  * @dev This has been changed slightly from OpenZeppelin to get rid of the Roles library 
145  *      and only allow owner to add pausers (and allow them to renounce).
146 **/
147 contract Pauser is Ownable {
148 
149     event PauserAdded(address indexed account);
150     event PauserRemoved(address indexed account);
151 
152     mapping (address => bool) private pausers;
153 
154     constructor () internal {
155         _addPauser(msg.sender);
156     }
157 
158     modifier onlyPauser() {
159         require(isPauser(msg.sender));
160         _;
161     }
162 
163     function isPauser(address account) public view returns (bool) {
164         return pausers[account];
165     }
166 
167     function addPauser(address account) public onlyOwner {
168         _addPauser(account);
169     }
170 
171     function renouncePauser(address account) public {
172         require(msg.sender == account || isOwner());
173         _removePauser(account);
174     }
175 
176     function _addPauser(address account) internal {
177         pausers[account] = true;
178         emit PauserAdded(account);
179     }
180 
181     function _removePauser(address account) internal {
182         pausers[account] = false;
183         emit PauserRemoved(account);
184     }
185 }
186 
187 /**
188  * @title Pausable
189  * @dev Base contract which allows children to implement an emergency stop mechanism.
190  */
191 contract Pausable  is Pauser {
192     event Paused(address account);
193     event Unpaused(address account);
194 
195     bool private _paused;
196 
197     constructor () internal {
198         _paused = false;
199     }
200 
201     /**
202      * @return true if the contract is paused, false otherwise.
203      */
204     function paused() public view returns (bool) {
205         return _paused;
206     }
207 
208     /**
209      * @dev Modifier to make a function callable only when the contract is not paused.
210      */
211     modifier whenNotPaused() {
212         require(!_paused);
213         _;
214     }
215 
216     /**
217      * @dev Modifier to make a function callable only when the contract is paused.
218      */
219     modifier whenPaused() {
220         require(_paused);
221         _;
222     }
223 
224     /**
225      * @dev called by the owner to pause, triggers stopped state
226      */
227     function pause() public onlyPauser whenNotPaused {
228         _paused = true;
229         emit Paused(msg.sender);
230     }
231 
232     /**
233      * @dev called by the owner to unpause, returns to normal state
234      */
235     function unpause() public onlyPauser whenPaused {
236         _paused = false;
237         emit Unpaused(msg.sender);
238     }
239 }
240 
241 /**
242  * @dev Standard OpenZeppelin ERC20 with minting, burning, and interface removed and pausing added.
243 **/
244 contract MonarchSecurity is Pausable {
245     using SafeMath for uint256;
246 
247     string private _name = "Monarch Token Security";
248     string private _symbol = "MTS";
249     uint8 private _decimals = 18;
250     uint256 private _totalSupply = 500000000 ether;
251 
252     mapping (address => uint256) private _balances;
253     mapping (address => mapping (address => uint256)) private _allowed;
254 
255     event Transfer(address indexed from, address indexed to, uint256 value);
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 
258     constructor () public {
259         _balances[msg.sender] = _totalSupply;
260     }
261 
262 /** ************************* CONSTANTS ****************************** **/
263 
264     /**
265      * @return the name of the token.
266      */
267     function name() public view returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @return the symbol of the token.
273      */
274     function symbol() public view returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @return the number of decimals of the token.
280      */
281     function decimals() public view returns (uint8) {
282         return _decimals;
283 }
284 
285     /**
286      * @dev Total number of tokens in existence
287      */
288     function totalSupply() public view returns (uint256) {
289         return _totalSupply;
290     }
291 
292     /**
293      * @dev Gets the balance of the specified address.
294      * @param owner The address to query the balance of.
295      * @return A uint256 representing the amount owned by the passed address.
296      */
297     function balanceOf(address owner) public view returns (uint256) {
298         return _balances[owner];
299     }
300 
301     /**
302      * @dev Function to check the amount of tokens that an owner allowed to a spender.
303      * @param owner address The address which owns the funds.
304      * @param spender address The address which will spend the funds.
305      * @return A uint256 specifying the amount of tokens still available for the spender.
306      */
307     function allowance(address owner, address spender) public view returns (uint256) {
308         return _allowed[owner][spender];
309     }
310 
311 /** ************************* PUBLIC ****************************** **/
312 
313     /**
314      * @dev Transfer token to a specified address
315      * @param to The address to transfer to.
316      * @param value The amount to be transferred.
317      */
318     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
319         _transfer(msg.sender, to, value);
320         return true;
321     }
322 
323     /**
324      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325      * Beware that changing an allowance with this method brings the risk that someone may use both the old
326      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
327      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
328      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329      * @param spender The address which will spend the funds.
330      * @param value The amount of tokens to be spent.
331      */
332     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
333         _approve(msg.sender, spender, value);
334         return true;
335     }
336 
337     /**
338      * @dev Transfer tokens from one address to another.
339      * Note that while this function emits an Approval event, this is not required as per the specification,
340      * and other compliant implementations may not emit the event.
341      * @param from address The address which you want to send tokens from
342      * @param to address The address which you want to transfer to
343      * @param value uint256 the amount of tokens to be transferred
344      */
345     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
346         _transfer(from, to, value);
347         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
348         return true;
349     }
350 
351     /**
352      * @dev Increase the amount of tokens that an owner allowed to a spender.
353      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
354      * allowed value is better to use this function to avoid 2 calls (and wait until
355      * the first transaction is mined)
356      * From MonolithDAO Token.sol
357      * Emits an Approval event.
358      * @param spender The address which will spend the funds.
359      * @param addedValue The amount of tokens to increase the allowance by.
360      */
361     function increaseApproval(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
362         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
363         return true;
364     }
365 
366     /**
367      * @dev Decrease the amount of tokens that an owner allowed to a spender.
368      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
369      * allowed value is better to use this function to avoid 2 calls (and wait until
370      * the first transaction is mined)
371      * From MonolithDAO Token.sol
372      * Emits an Approval event.
373      * @param spender The address which will spend the funds.
374      * @param subtractedValue The amount of tokens to decrease the allowance by.
375      */
376     function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
377         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
378         return true;
379     }
380     
381 /** ************************* INTERNAL ****************************** **/
382 
383     /**
384      * @dev Transfer token for a specified addresses
385      * @param from The address to transfer from.
386      * @param to The address to transfer to.
387      * @param value The amount to be transferred.
388      */
389     function _transfer(address from, address to, uint256 value) internal {
390         require(to != address(0));
391 
392         _balances[from] = _balances[from].sub(value);
393         _balances[to] = _balances[to].add(value);
394         emit Transfer(from, to, value);
395     }
396 
397     /**
398      * @dev Approve an address to spend another addresses' tokens.
399      * @param owner The address that owns the tokens.
400      * @param spender The address that will spend the tokens.
401      * @param value The number of tokens that can be spent.
402      */
403     function _approve(address owner, address spender, uint256 value) internal {
404         require(spender != address(0));
405         require(owner != address(0));
406 
407         _allowed[owner][spender] = value;
408         emit Approval(owner, spender, value);
409     }
410 
411 }