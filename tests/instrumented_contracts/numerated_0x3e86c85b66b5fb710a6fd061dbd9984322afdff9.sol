1 pragma solidity ^0.5.7;
2 
3 
4  contract Ownable {
5      address private _owner;
6 
7      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9      /**
10       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11       * account.
12       */
13      constructor () internal {
14          _owner = msg.sender;
15          emit OwnershipTransferred(address(0), _owner);
16      }
17 
18      /**
19       * @return the address of the owner.
20       */
21      function owner() public view returns (address) {
22          return _owner;
23      }
24 
25      /**
26       * @dev Throws if called by any account other than the owner.
27       */
28      modifier onlyOwner() {
29          require(isOwner());
30          _;
31      }
32 
33      /**
34       * @return true if `msg.sender` is the owner of the contract.
35       */
36      function isOwner() public view returns (bool) {
37          return msg.sender == _owner;
38      }
39 
40      /**
41       * @dev Allows the current owner to relinquish control of the contract.
42       * It will not be possible to call the functions with the `onlyOwner`
43       * modifier anymore.
44       * @notice Renouncing ownership will leave the contract without an owner,
45       * thereby removing any functionality that is only available to the owner.
46       */
47      function renounceOwnership() public onlyOwner {
48          emit OwnershipTransferred(_owner, address(0));
49          _owner = address(0);
50      }
51 
52      /**
53       * @dev Allows the current owner to transfer control of the contract to a newOwner.
54       * @param newOwner The address to transfer ownership to.
55       */
56      function transferOwnership(address newOwner) public onlyOwner {
57          _transferOwnership(newOwner);
58      }
59 
60      /**
61       * @dev Transfers control of the contract to a newOwner.
62       * @param newOwner The address to transfer ownership to.
63       */
64      function _transferOwnership(address newOwner) internal {
65          require(newOwner != address(0));
66          emit OwnershipTransferred(_owner, newOwner);
67          _owner = newOwner;
68      }
69  }
70 
71 
72 
73  contract Pausable is Ownable {
74    event Pause();
75    event Unpause();
76 
77    bool public paused = false;
78 
79 
80    /**
81     * @dev Modifier to make a function callable only when the contract is not paused.
82     */
83    modifier whenNotPaused() {
84      require(!paused);
85      _;
86    }
87 
88    /**
89     * @dev Modifier to make a function callable only when the contract is paused.
90     */
91    modifier whenPaused() {
92      require(paused);
93      _;
94    }
95 
96    /**
97     * @dev called by the owner to pause, triggers stopped state
98     */
99    function pause() onlyOwner whenNotPaused public {
100      paused = true;
101      emit Pause();
102    }
103 
104    /**
105     * @dev called by the owner to unpause, returns to normal state
106     */
107    function unpause() onlyOwner whenPaused public {
108      paused = false;
109      emit Unpause();
110    }
111  }
112 
113 
114 contract IERC20 {
115     function transfer(address to, uint256 value) external returns (bool);
116 
117     function approve(address spender, uint256 value) external returns (bool);
118 
119     function transferFrom(address from, address to, uint256 value) external returns (bool);
120 
121     function totalSupply() external view returns (uint256);
122 
123     function balanceOf(address who) external view returns (uint256);
124 
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 contract ERC20 is IERC20 {
133     using SafeMath for uint256;
134 
135     mapping (address => uint256) public _balances;
136 
137     mapping (address => mapping (address => uint256)) private _allowed;
138 
139     uint256 public totalSupply;
140 
141 
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param owner The address to query the balance of.
145      * @return A uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address owner) public view returns (uint256) {
148         return _balances[owner];
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param owner address The address which owns the funds.
154      * @param spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(address owner, address spender) public view returns (uint256) {
158         return _allowed[owner][spender];
159     }
160 
161     /**
162      * @dev Transfer token to a specified address
163      * @param to The address to transfer to.
164      * @param value The amount to be transferred.
165      */
166     function transfer(address to, uint256 value) public returns (bool) {
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171 
172     function approve(address spender, uint256 value) public returns (bool) {
173         _approve(msg.sender, spender, value);
174         return true;
175     }
176 
177   
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _transfer(from, to, value);
180         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
190         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
191         return true;
192     }
193 
194     function _transfer(address from, address to, uint256 value) internal {
195         require(to != address(0));
196 
197         _balances[from] = _balances[from].sub(value);
198         _balances[to] = _balances[to].add(value);
199         emit Transfer(from, to, value);
200     }
201 
202 
203     function _approve(address owner, address spender, uint256 value) internal {
204         require(spender != address(0));
205         require(owner != address(0));
206 
207         _allowed[owner][spender] = value;
208         emit Approval(owner, spender, value);
209     }
210 
211 
212 }
213 
214 
215 
216 
217 contract ERC20Pausable is ERC20, Pausable {
218     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
219         return super.transfer(to, value);
220     }
221 
222     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
223         return super.transferFrom(from, to, value);
224     }
225 
226     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
227         return super.approve(spender, value);
228     }
229 
230     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
231         return super.increaseAllowance(spender, addedValue);
232     }
233 
234     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
235         return super.decreaseAllowance(spender, subtractedValue);
236     }
237 }
238 
239 
240 
241 
242 
243 
244 contract MVITc is Ownable {
245 
246 
247   MVITtoken public token;
248   uint256 constant public tokenDecimals = 18;
249   uint256 public totalSupply = 90000000 * (10 ** uint256(tokenDecimals));
250 
251   constructor () public {
252 
253     token = createTokenContract();
254     token.unpause();
255   }
256 
257 
258 
259   //
260   // Token related operations
261   //
262 
263   // creates the token to be sold.
264   // override this method to have crowdsale of a specific mintable token.
265   function createTokenContract() internal returns (MVITtoken) {
266     return new MVITtoken();
267   }
268 
269   // enable token transferability
270   function enableTokenTransferability() external onlyOwner {
271     token.unpause();
272   }
273 
274   // disable token transferability
275   function disableTokenTransferability() external onlyOwner {
276     token.pause();
277   }
278 
279   // transfer token to designated address
280   function transfer(address to, uint256 value) external onlyOwner returns (bool ok)  {
281     uint256 converterdValue = value * (10 ** uint256(tokenDecimals));
282     return token.transfer(to, converterdValue);
283    }
284 
285 
286 
287 }
288 
289 
290 
291 
292 
293 contract MVITtoken is ERC20Pausable {
294   string constant public name = "MVit Token";
295   string constant public symbol = "MVT";
296   uint8 constant public decimals = 18;
297   uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
298   uint256 constant INITIAL_SUPPLY = 90000000 * TOKEN_UNIT;
299 
300 
301   constructor () public {
302     // Set untransferable by default to the token
303     paused = true;
304     // asign all tokens to the contract creator
305     totalSupply = INITIAL_SUPPLY;
306 
307     _balances[msg.sender] = INITIAL_SUPPLY;
308   }
309 
310 
311 
312 }
313 
314 
315 
316 library SafeMath {
317     /**
318     * @dev Multiplies two unsigned integers, reverts on overflow.
319     */
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
322         // benefit is lost if 'b' is also tested.
323         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
324         if (a == 0) {
325             return 0;
326         }
327 
328         uint256 c = a * b;
329         require(c / a == b);
330 
331         return c;
332     }
333 
334     /**
335     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
336     */
337     function div(uint256 a, uint256 b) internal pure returns (uint256) {
338         // Solidity only automatically asserts when dividing by 0
339         require(b > 0);
340         uint256 c = a / b;
341         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
342 
343         return c;
344     }
345 
346     /**
347     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
348     */
349     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
350         require(b <= a);
351         uint256 c = a - b;
352 
353         return c;
354     }
355 
356     /**
357     * @dev Adds two unsigned integers, reverts on overflow.
358     */
359     function add(uint256 a, uint256 b) internal pure returns (uint256) {
360         uint256 c = a + b;
361         require(c >= a);
362 
363         return c;
364     }
365 
366     /**
367     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
368     * reverts when dividing by zero.
369     */
370     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
371         require(b != 0);
372         return a % b;
373     }
374 }