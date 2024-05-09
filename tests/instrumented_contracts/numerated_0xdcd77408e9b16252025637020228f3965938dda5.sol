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
163     uint256 public constant STAKE_MIN_AGE = 64 seconds * 20; // 64 second block time * 20 blocks
164     uint256 public constant STAKE_APR = 13; // 13% annual interest
165     uint256 public constant MAX_TOTAL_SUPPLY = 100 * (10 ** (6 + uint256(decimals))); // 100 million tokens
166     
167     bool public balancesInitialized = false;
168     
169     struct transferIn {
170         uint64 amount;
171         uint64 time;
172     }
173 
174     mapping (address => uint256) private balances;
175     mapping (address => mapping (address => uint256)) private allowed;
176     mapping (address => transferIn[]) transferIns;
177     uint256 private totalSupply_;
178 
179     event Mint(address indexed to, uint256 amount);
180 
181     modifier canMint() {
182         require(totalSupply_ < MAX_TOTAL_SUPPLY);
183         _;
184     }
185 
186     /**
187      * @dev Constructor to set totalSupply_
188      */
189     constructor() public {
190         totalSupply_ = 0;
191     }
192 
193     /**
194      * @dev POS-style staking reward mint function
195      */
196     function mint() public canMint returns (bool) {
197         if (balances[msg.sender] <= 0) return false;
198         if (transferIns[msg.sender].length <= 0) return false;
199 
200         uint reward = _getStakingReward(msg.sender);
201         if (reward <= 0) return false;
202 
203         _mint(msg.sender, reward);
204         emit Mint(msg.sender, reward);
205         return true;
206     }
207 
208     /**
209      * @dev External coin age computation function
210      */
211     function getCoinAge() external view returns (uint256) {
212         return _getCoinAge(msg.sender, block.timestamp);
213     }
214 
215     /**
216      * @dev Internal staking reward computation function
217      * @return An uint256 representing the sum of coin ages times interest rate
218      */
219     function _getStakingReward(address _address) internal view returns (uint256) {
220         uint256 coinAge = _getCoinAge(_address, block.timestamp); // Sum (value * days since tx arrived)
221         if (coinAge <= 0) return 0;
222         return (coinAge * STAKE_APR).div(365 * 100); // Amount to deliver in this interval to user
223     }
224 
225     /**
226      * @dev Internal coin age computation function
227      * @return An uint256 representing the sum of all coin ages (value * days since tx arrived for each utxo)
228      */
229     function _getCoinAge(address _address, uint256 _now) internal view returns (uint256 _coinAge) {
230         if (transferIns[_address].length <= 0) return 0;
231 
232         for (uint256 i = 0; i < transferIns[_address].length; i++) {
233             if (_now < uint256(transferIns[_address][i].time).add(STAKE_MIN_AGE)) continue;
234             uint256 coinSeconds = _now.sub(uint256(transferIns[_address][i].time));
235             _coinAge = _coinAge.add(uint256(transferIns[_address][i].amount).mul(coinSeconds).div(1 days));
236         }
237     }
238 
239     /**
240      * @dev Function to init balances mapping on token launch
241      */
242     function initBalances(address[] _accounts, uint64[] _amounts) external onlyOwner {
243         require(!balancesInitialized);
244         require(_accounts.length > 0 && _accounts.length == _amounts.length);
245 
246         uint256 total = 0;
247         for (uint256 i = 0; i < _amounts.length; i++) total = total.add(uint256(_amounts[i]));
248         require(total <= MAX_TOTAL_SUPPLY);
249 
250         for (uint256 j = 0; j < _accounts.length; j++) _mint(_accounts[j], uint256(_amounts[j]));
251     }
252 
253     /**
254      * @dev Function to complete initialization of token balances after launch
255      */
256     function completeInitialization() external onlyOwner {
257         require(!balancesInitialized);
258         balancesInitialized = true;
259     }
260 
261     /**
262      * @dev Total number of tokens in existence
263      */
264     function totalSupply() public view returns (uint256) {
265         return totalSupply_;
266     }
267 
268     /**
269      * @dev Gets the balance of the specified address.
270      * @param _owner The address to query the the balance of.
271      * @return An uint256 representing the amount owned by the passed address.
272      */
273     function balanceOf(address _owner) public view returns (uint256) {
274         return balances[_owner];
275     }
276 
277     /**
278      * @dev Function to check the amount of tokens that an owner allowed to a spender.
279      * @param _owner address The address which owns the funds.
280      * @param _spender address The address which will spend the funds.
281      * @return A uint256 specifying the amount of tokens still available for the spender.
282      */
283     function allowance(
284         address _owner,
285         address _spender
286     )
287         public
288         view
289         returns (uint256)
290     {
291         return allowed[_owner][_spender];
292     }
293 
294     /**
295      * @dev Transfer token for a specified address
296      * @param _to The address to transfer to.
297      * @param _value The amount to be transferred.
298      */
299     function transfer(address _to, uint256 _value) public returns (bool) {
300         if (msg.sender == _to) return mint();
301         require(_value <= balances[msg.sender]);
302         require(_to != address(0));
303 
304         balances[msg.sender] = balances[msg.sender].sub(_value);
305         balances[_to] = balances[_to].add(_value);
306         emit Transfer(msg.sender, _to, _value);
307         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
308         uint64 time = uint64(block.timestamp);
309         transferIns[msg.sender].push(transferIn(uint64(balances[msg.sender]), time));
310         transferIns[_to].push(transferIn(uint64(_value), time));
311         return true;
312     }
313 
314     /**
315      * @dev Transfer tokens to multiple addresses
316      * @param _to The addresses to transfer to.
317      * @param _values The amounts to be transferred.
318      */
319     function batchTransfer(address[] _to, uint256[] _values) public returns (bool) {
320         require(_to.length == _values.length);
321         for (uint256 i = 0; i < _to.length; i++) require(transfer(_to[i], _values[i]));
322         return true;
323     }
324 
325     /**
326      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
327      * Beware that changing an allowance with this method brings the risk that someone may use both the old
328      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
329      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
330      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331      * @param _spender The address which will spend the funds.
332      * @param _value The amount of tokens to be spent.
333      */
334     function approve(address _spender, uint256 _value) public returns (bool) {
335         allowed[msg.sender][_spender] = _value;
336         emit Approval(msg.sender, _spender, _value);
337         return true;
338     }
339 
340     /**
341      * @dev Transfer tokens from one address to another
342      * @param _from address The address which you want to send tokens from
343      * @param _to address The address which you want to transfer to
344      * @param _value uint256 the amount of tokens to be transferred
345      */
346     function transferFrom(
347         address _from,
348         address _to,
349         uint256 _value
350     )
351         public
352         returns (bool)
353     {
354         require(_value <= balances[_from]);
355         require(_value <= allowed[_from][msg.sender]);
356         require(_to != address(0));
357 
358         balances[_from] = balances[_from].sub(_value);
359         balances[_to] = balances[_to].add(_value);
360         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
361         emit Transfer(_from, _to, _value);
362         if (transferIns[_from].length > 0) delete transferIns[_from];
363         uint64 time = uint64(block.timestamp);
364         transferIns[_from].push(transferIn(uint64(balances[_from]), time));
365         transferIns[_to].push(transferIn(uint64(_value), time));
366         return true;
367     }
368 
369     /**
370      * @dev Increase the amount of tokens that an owner allowed to a spender.
371      * approve should be called when allowed[_spender] == 0. To increment
372      * allowed value is better to use this function to avoid 2 calls (and wait until
373      * the first transaction is mined)
374      * From MonolithDAO Token.sol
375      * @param _spender The address which will spend the funds.
376      * @param _addedValue The amount of tokens to increase the allowance by.
377      */
378     function increaseApproval(
379         address _spender,
380         uint256 _addedValue
381     )
382         public
383         returns (bool)
384     {
385         allowed[msg.sender][_spender] = (
386         allowed[msg.sender][_spender].add(_addedValue));
387         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388         return true;
389     }
390 
391     /**
392      * @dev Decrease the amount of tokens that an owner allowed to a spender.
393      * approve should be called when allowed[_spender] == 0. To decrement
394      * allowed value is better to use this function to avoid 2 calls (and wait until
395      * the first transaction is mined)
396      * From MonolithDAO Token.sol
397      * @param _spender The address which will spend the funds.
398      * @param _subtractedValue The amount of tokens to decrease the allowance by.
399      */
400     function decreaseApproval(
401         address _spender,
402         uint256 _subtractedValue
403     )
404         public
405         returns (bool)
406     {
407         uint256 oldValue = allowed[msg.sender][_spender];
408         if (_subtractedValue >= oldValue) {
409             allowed[msg.sender][_spender] = 0;
410         } else {
411             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
412         }
413         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414         return true;
415     }
416 
417     /**
418      * @dev Internal function that mints an amount of the token and assigns it to
419      * an account. This encapsulates the modification of balances such that the
420      * proper events are emitted.
421      * @param _account The account that will receive the created tokens.
422      * @param _amount The amount that will be created.
423      */
424     function _mint(address _account, uint256 _amount) internal {
425         require(_account != 0);
426         totalSupply_ = totalSupply_.add(_amount);
427         balances[_account] = balances[_account].add(_amount);
428         if (transferIns[_account].length > 0) delete transferIns[_account];
429         transferIns[_account].push(transferIn(uint64(balances[_account]), uint64(block.timestamp)));
430         emit Transfer(address(0), _account, _amount);
431     }
432 }