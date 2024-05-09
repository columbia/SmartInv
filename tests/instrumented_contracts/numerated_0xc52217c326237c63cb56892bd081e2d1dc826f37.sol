1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * See https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address _who) public view returns (uint256);
126   function transfer(address _to, uint256 _value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address _owner, address _spender)
137     public view returns (uint256);
138 
139   function transferFrom(address _from, address _to, uint256 _value)
140     public returns (bool);
141 
142   function approve(address _spender, uint256 _value) public returns (bool);
143   event Approval(
144     address indexed owner,
145     address indexed spender,
146     uint256 value
147   );
148 }
149 
150 
151 /**
152  * @title VeloxToken
153  * @dev VeloxCoin => VeloxToken ERC20 token contract
154  * This contract supports POS-style staking
155  */
156 contract VeloxToken is ERC20, Ownable {
157     using SafeMath for uint256;
158 
159     string public constant name = "Velox";
160     string public constant symbol = "VLX";
161     uint8 public constant decimals = 2;
162 
163     uint256 public constant STAKE_START_TIME = 1535241600;
164     uint256 public constant STAKE_MIN_AGE = 64 seconds * 20;
165     uint256 public constant STAKE_APR = 13; // 13% annual interest
166     uint256 public constant MAX_TOTAL_SUPPLY = 100 * (10 ** (6 + uint256(decimals))); // 100 million tokens
167     
168     bool public balancesInitialized = false;
169     
170     struct transferIn {
171         uint64 amount;
172         uint64 time;
173     }
174 
175     mapping (address => uint256) private balances;
176     mapping (address => mapping (address => uint256)) private allowed;
177     mapping (address => transferIn[]) transferIns;
178     uint256 private totalSupply_;
179 
180     event Mint(address indexed to, uint256 amount);
181 
182     modifier canMint() {
183         require(totalSupply_ < MAX_TOTAL_SUPPLY);
184         _;
185     }
186 
187     /**
188     * @dev Constructor to set totalSupply_
189     */
190     constructor() public {
191         totalSupply_ = 0;
192     }
193 
194     function mint() public canMint returns (bool) {
195         if (balances[msg.sender] <= 0) return false;
196         if (transferIns[msg.sender].length <= 0) return false;
197 
198         uint reward = _getStakingReward(msg.sender);
199         if (reward <= 0) return false;
200 
201         _mint(msg.sender, reward);
202         emit Mint(msg.sender, reward);
203         return true;
204     }
205 
206     function getCoinAge() public view returns (uint256) {
207         return _getCoinAge(msg.sender, block.timestamp);
208     }
209 
210     function _getStakingReward(address _address) internal view returns (uint256) {
211         require(block.timestamp >= STAKE_START_TIME);
212         uint256 coinAge = _getCoinAge(_address, block.timestamp); // Sum (value * days since tx arrived)
213         if (coinAge <= 0) return 0;
214         return (coinAge * STAKE_APR).div(365 * 100); // Amount to deliver in this interval to user
215     }
216 
217     function _getCoinAge(address _address, uint256 _now) internal view returns (uint256 _coinAge) {
218         if (transferIns[_address].length <= 0) return 0;
219 
220         for (uint256 i = 0; i < transferIns[_address].length; i++) {
221             if (_now < uint256(transferIns[_address][i].time).add(STAKE_MIN_AGE)) continue;
222             uint256 coinSeconds = _now.sub(uint256(transferIns[_address][i].time));
223             _coinAge = _coinAge.add(uint256(transferIns[_address][i].amount).mul(coinSeconds).div(1 days));
224         }
225     }
226 
227     /**
228     * @dev Function to init balances mapping on token launch
229     */
230     function initBalances(address[] _accounts, uint64[] _amounts) external onlyOwner {
231         require(!balancesInitialized);
232         require(_accounts.length > 0 && _accounts.length == _amounts.length);
233 
234         uint256 total = 0;
235         for (uint256 i = 0; i < _amounts.length; i++) total = total.add(uint256(_amounts[i]));
236         require(total <= MAX_TOTAL_SUPPLY);
237 
238         for (uint256 j = 0; j < _accounts.length; j++) _mint(_accounts[j], uint256(_amounts[j]));
239     }
240 
241     /**
242     * @dev Function to complete initialization of token balances after launch
243     */
244     function completeInitialization() external onlyOwner {
245         require(!balancesInitialized);
246         balancesInitialized = true;
247     }
248 
249     /**
250     * @dev Total number of tokens in existence
251     */
252     function totalSupply() public view returns (uint256) {
253         return totalSupply_;
254     }
255 
256     /**
257     * @dev Gets the balance of the specified address.
258     * @param _owner The address to query the the balance of.
259     * @return An uint256 representing the amount owned by the passed address.
260     */
261     function balanceOf(address _owner) public view returns (uint256) {
262         return balances[_owner];
263     }
264 
265     /**
266     * @dev Function to check the amount of tokens that an owner allowed to a spender.
267     * @param _owner address The address which owns the funds.
268     * @param _spender address The address which will spend the funds.
269     * @return A uint256 specifying the amount of tokens still available for the spender.
270     */
271     function allowance(
272         address _owner,
273         address _spender
274     )
275         public
276         view
277         returns (uint256)
278     {
279         return allowed[_owner][_spender];
280     }
281 
282     /**
283     * @dev Transfer token for a specified address
284     * @param _to The address to transfer to.
285     * @param _value The amount to be transferred.
286     */
287     function transfer(address _to, uint256 _value) public returns (bool) {
288         if (msg.sender == _to) return mint();
289         require(_value <= balances[msg.sender]);
290         require(_to != address(0));
291 
292         balances[msg.sender] = balances[msg.sender].sub(_value);
293         balances[_to] = balances[_to].add(_value);
294         emit Transfer(msg.sender, _to, _value);
295         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
296         uint64 time = uint64(block.timestamp);
297         transferIns[msg.sender].push(transferIn(uint64(balances[msg.sender]), time));
298         transferIns[_to].push(transferIn(uint64(_value), time));
299         return true;
300     }
301 
302     /**
303     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
304     * Beware that changing an allowance with this method brings the risk that someone may use both the old
305     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
306     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
307     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308     * @param _spender The address which will spend the funds.
309     * @param _value The amount of tokens to be spent.
310     */
311     function approve(address _spender, uint256 _value) public returns (bool) {
312         allowed[msg.sender][_spender] = _value;
313         emit Approval(msg.sender, _spender, _value);
314         return true;
315     }
316 
317     /**
318     * @dev Transfer tokens from one address to another
319     * @param _from address The address which you want to send tokens from
320     * @param _to address The address which you want to transfer to
321     * @param _value uint256 the amount of tokens to be transferred
322     */
323     function transferFrom(
324         address _from,
325         address _to,
326         uint256 _value
327     )
328         public
329         returns (bool)
330     {
331         require(_value <= balances[_from]);
332         require(_value <= allowed[_from][msg.sender]);
333         require(_to != address(0));
334 
335         balances[_from] = balances[_from].sub(_value);
336         balances[_to] = balances[_to].add(_value);
337         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
338         emit Transfer(_from, _to, _value);
339         if (transferIns[_from].length > 0) delete transferIns[_from];
340         uint64 time = uint64(block.timestamp);
341         transferIns[_from].push(transferIn(uint64(balances[_from]), time));
342         transferIns[_to].push(transferIn(uint64(_value), time));
343         return true;
344     }
345 
346     /**
347     * @dev Increase the amount of tokens that an owner allowed to a spender.
348     * approve should be called when allowed[_spender] == 0. To increment
349     * allowed value is better to use this function to avoid 2 calls (and wait until
350     * the first transaction is mined)
351     * From MonolithDAO Token.sol
352     * @param _spender The address which will spend the funds.
353     * @param _addedValue The amount of tokens to increase the allowance by.
354     */
355     function increaseApproval(
356         address _spender,
357         uint256 _addedValue
358     )
359         public
360         returns (bool)
361     {
362         allowed[msg.sender][_spender] = (
363         allowed[msg.sender][_spender].add(_addedValue));
364         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365         return true;
366     }
367 
368     /**
369     * @dev Decrease the amount of tokens that an owner allowed to a spender.
370     * approve should be called when allowed[_spender] == 0. To decrement
371     * allowed value is better to use this function to avoid 2 calls (and wait until
372     * the first transaction is mined)
373     * From MonolithDAO Token.sol
374     * @param _spender The address which will spend the funds.
375     * @param _subtractedValue The amount of tokens to decrease the allowance by.
376     */
377     function decreaseApproval(
378         address _spender,
379         uint256 _subtractedValue
380     )
381         public
382         returns (bool)
383     {
384         uint256 oldValue = allowed[msg.sender][_spender];
385         if (_subtractedValue >= oldValue) {
386             allowed[msg.sender][_spender] = 0;
387         } else {
388             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
389         }
390         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
391         return true;
392     }
393 
394     /**
395     * @dev Internal function that mints an amount of the token and assigns it to
396     * an account. This encapsulates the modification of balances such that the
397     * proper events are emitted.
398     * @param _account The account that will receive the created tokens.
399     * @param _amount The amount that will be created.
400     */
401     function _mint(address _account, uint256 _amount) internal {
402         require(_account != 0);
403         totalSupply_ = totalSupply_.add(_amount);
404         balances[_account] = balances[_account].add(_amount);
405         if (transferIns[_account].length > 0) delete transferIns[_account];
406         transferIns[_account].push(transferIn(uint64(balances[_account]), uint64(block.timestamp)));
407         emit Transfer(address(0), _account, _amount);
408     }
409 }