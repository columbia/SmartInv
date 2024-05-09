1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface ICvnToken {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two numbers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two numbers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96     address internal _owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     /**
101      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102      * account.
103      */
104     constructor () internal {
105         _owner = msg.sender;
106         emit OwnershipTransferred(address(0), _owner);
107     }
108 
109     /**
110      * @return the address of the owner.
111      */
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     /**
117      * @dev Throws if called by any account other than the owner.
118      */
119     modifier onlyOwner() {
120         require(isOwner());
121         _;
122     }
123 
124     /**
125      * @return true if `msg.sender` is the owner of the contract.
126      */
127     function isOwner() public view returns (bool) {
128         return msg.sender == _owner;
129     }
130 
131     /**
132      * @dev Allows the current owner to relinquish control of the contract.
133      * @notice Renouncing to ownership will leave the contract without an owner.
134      * It will not be possible to call the functions with the `onlyOwner`
135      * modifier anymore.
136      */
137     function renounceOwnership() public onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142     /**
143      * @dev Allows the current owner to transfer control of the contract to a newOwner.
144      * @param newOwner The address to transfer ownership to.
145      */
146     function transferOwnership(address newOwner) public onlyOwner {
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers control of the contract to a newOwner.
152      * @param newOwner The address to transfer ownership to.
153      */
154     function _transferOwnership(address newOwner) internal {
155         require(newOwner != address(0));
156         emit OwnershipTransferred(_owner, newOwner);
157         _owner = newOwner;
158     }
159 }
160 
161 
162 /**
163  * @title Pausable
164  * @dev Base contract which allows children to implement an emergency stop mechanism.
165  */
166 contract Pausable is Ownable {
167   event Pause();
168   event Unpause();
169 
170   bool public paused = false;
171 
172 
173   /**
174    * @dev Modifier to make a function callable only when the contract is not paused.
175    */
176   modifier whenNotPaused() {
177     require(!paused);
178     _;
179   }
180 
181   /**
182    * @dev Modifier to make a function callable only when the contract is paused.
183    */
184   modifier whenPaused() {
185     require(paused);
186     _;
187   }
188 
189   /**
190    * @dev called by the owner to pause, triggers stopped state
191    */
192   function pause() onlyOwner whenNotPaused public {
193     paused = true;
194     emit Pause();
195   }
196 
197   /**
198    * @dev called by the owner to unpause, returns to normal state
199    */
200   function unpause() onlyOwner whenPaused public {
201     paused = false;
202     emit Unpause();
203   }
204 }
205 
206 
207 /**
208  * @title Standard ERC20 token
209  *
210  * @dev Implementation of the basic standard token.
211  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
212  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
213  *
214  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
215  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
216  * compliant implementations may not do it.
217  */
218 contract CvnToken is ICvnToken, Pausable {
219     using SafeMath for uint256;
220 
221     mapping (address => uint256) private _balances;
222 
223     mapping (address => mapping (address => uint256)) private _allowed;
224 
225     string public name = "CVNToken";
226     string public symbol = "CVNT";
227     uint8 public decimals = 8;
228     
229     uint256 private _totalSupply = (10 ** 9) * (10 ** uint256(decimals));
230 
231     constructor() public {
232       _balances[msg.sender] = _totalSupply;
233     }
234 
235     /**
236     * @dev Total number of tokens in existence
237     */
238     function totalSupply() public view returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243     * @dev Gets the balance of the specified address.
244     * @param owner The address to query the balance of.
245     * @return An uint256 representing the amount owned by the passed address.
246     */
247     function balanceOf(address owner) public view returns (uint256) {
248         return _balances[owner];
249     }
250 
251     /**
252      * @dev Function to check the amount of tokens that an owner allowed to a spender.
253      * @param owner address The address which owns the funds.
254      * @param spender address The address which will spend the funds.
255      * @return A uint256 specifying the amount of tokens still available for the spender.
256      */
257     function allowance(address owner, address spender) public view returns (uint256) {
258         return _allowed[owner][spender];
259     }
260 
261     /**
262     * @dev Transfer token for a specified address
263     * @param to The address to transfer to.
264     * @param value The amount to be transferred.
265     */
266     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
267         _transfer(msg.sender, to, value);
268         return true;
269     }
270 
271     /**
272      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273      * Beware that changing an allowance with this method brings the risk that someone may use both the old
274      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277      * @param spender The address which will spend the funds.
278      * @param value The amount of tokens to be spent.
279      */
280     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
281         require(spender != address(0));
282 
283         _allowed[msg.sender][spender] = value;
284         emit Approval(msg.sender, spender, value);
285         return true;
286     }
287 
288     /**
289      * @dev Transfer tokens from one address to another.
290      * Note that while this function emits an Approval event, this is not required as per the specification,
291      * and other compliant implementations may not emit the event.
292      * @param from address The address which you want to send tokens from
293      * @param to address The address which you want to transfer to
294      * @param value uint256 the amount of tokens to be transferred
295      */
296     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
297         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
298         _transfer(from, to, value);
299         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
300         return true;
301     }
302 
303     /**
304      * @dev Increase the amount of tokens that an owner allowed to a spender.
305      * approve should be called when allowed_[_spender] == 0. To increment
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * Emits an Approval event.
310      * @param spender The address which will spend the funds.
311      * @param addedValue The amount of tokens to increase the allowance by.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
314         require(spender != address(0));
315 
316         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
317         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
318         return true;
319     }
320 
321     /**
322      * @dev Decrease the amount of tokens that an owner allowed to a spender.
323      * approve should be called when allowed_[_spender] == 0. To decrement
324      * allowed value is better to use this function to avoid 2 calls (and wait until
325      * the first transaction is mined)
326      * From MonolithDAO Token.sol
327      * Emits an Approval event.
328      * @param spender The address which will spend the funds.
329      * @param subtractedValue The amount of tokens to decrease the allowance by.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
332         require(spender != address(0));
333 
334         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
335         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
336         return true;
337     }
338 
339     /**
340     * @dev Transfer token for a specified addresses
341     * @param from The address to transfer from.
342     * @param to The address to transfer to.
343     * @param value The amount to be transferred.
344     */
345     function _transfer(address from, address to, uint256 value) internal {
346         require(to != address(0));
347 
348         _balances[from] = _balances[from].sub(value);
349         _balances[to] = _balances[to].add(value);
350         emit Transfer(from, to, value);
351     }
352 
353 
354         // transfer balance to owner
355     function withdrawEther(uint256 amount) public onlyOwner {
356         _owner.transfer(amount);
357     }
358     
359     // can accept ether
360     function() payable {}
361 }