1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 interface IERC20 {
44   function balanceOf(address _owner) public view returns (uint256);
45   function allowance(address _owner, address _spender) public view returns (uint256);
46   function transfer(address _to, uint256 _value) public returns (bool);
47   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
48   function approve(address _spender, uint256 _value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 
54 /**
55  * @title Standard ERC20 token
56  *
57  * @dev Implementation of the basic standard token.
58  * @dev https://github.com/ethereum/EIPs/issues/20
59  */
60 contract SolaToken is IERC20 {
61   using SafeMath for uint256;
62 
63   string public name = 'Sola';
64   string public symbol = 'SOLA';
65   uint8 public constant decimals = 18;
66   uint256 public constant decimalFactor = 10 ** uint256(decimals);
67   uint256 public constant totalSupply = 1000000000 * decimalFactor;
68   mapping (address => uint256) balances;
69   mapping (address => mapping (address => uint256)) internal allowed;
70 
71   event Transfer(address indexed from, address indexed to, uint256 value);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74   /**
75   * @dev Constructor for Sola creation
76   * @dev Assigns the totalSupply to the SolaDistribution contract
77   */
78   function SolaToken(address _solaDistributionContractAddress) public {
79     require(_solaDistributionContractAddress != address(0));
80     balances[_solaDistributionContractAddress] = totalSupply;
81     Transfer(address(0), _solaDistributionContractAddress, totalSupply);
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93   /**
94    * @dev Function to check the amount of tokens that an owner allowed to a spender.
95    * @param _owner address The address which owns the funds.
96    * @param _spender address The address which will spend the funds.
97    * @return A uint256 specifying the amount of tokens still available for the spender.
98    */
99   function allowance(address _owner, address _spender) public view returns (uint256) {
100     return allowed[_owner][_spender];
101   }
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender]);
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Increase the amount of tokens that an owner allowed to a spender.
155    *
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    * @param _spender The address which will spend the funds.
161    * @param _addedValue The amount of tokens to increase the allowance by.
162    */
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   /**
170    * @dev Decrease the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To decrement
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _subtractedValue The amount of tokens to decrease the allowance by.
178    */
179   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180     uint oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue > oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190 }
191 
192 
193 
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control
197  * functions, this simplifies the implementation of "user permissions".
198  */
199 contract Ownable {
200   address public owner;
201 
202   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() public {
209     owner = msg.sender;
210   }
211 
212   /**
213    * @dev Throws if called by any account other than the owner.
214    */
215   modifier onlyOwner() {
216     require(msg.sender == owner);
217     _;
218   }
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) public onlyOwner {
225     require(newOwner != address(0));
226     OwnershipTransferred(owner, newOwner);
227     owner = newOwner;
228   }
229 
230 }
231 
232 
233 /**
234  * @title SOLA token initial distribution
235  *
236  * @dev Distribute purchasers, airdrop, reserve, and founder tokens
237  */
238 contract SolaDistribution is Ownable {
239   using SafeMath for uint256;
240 
241   SolaToken public SOLA;
242 
243   uint256 private constant decimalFactor = 10**uint256(18);
244   enum AllocationType { PRESALE, FOUNDER, AIRDROP, ADVISOR, RESERVE, BONUS1, BONUS2, BONUS3 }
245   uint256 public constant INITIAL_SUPPLY   = 1000000000 * decimalFactor;
246   uint256 public AVAILABLE_TOTAL_SUPPLY    = 1000000000 * decimalFactor;
247   uint256 public AVAILABLE_PRESALE_SUPPLY  =  230000000 * decimalFactor; // 100% Released at Token Distribution (TD)
248   uint256 public AVAILABLE_FOUNDER_SUPPLY  =  150000000 * decimalFactor; // 33% Released at TD +1 year -> 100% at TD +3 years
249   uint256 public AVAILABLE_AIRDROP_SUPPLY  =   10000000 * decimalFactor; // 100% Released at TD
250   uint256 public AVAILABLE_ADVISOR_SUPPLY  =   20000000 * decimalFactor; // 100% Released at TD +7 months
251   uint256 public AVAILABLE_RESERVE_SUPPLY  =  513116658 * decimalFactor; // 6.8% Released at TD +100 days -> 100% at TD +4 years
252   uint256 public AVAILABLE_BONUS1_SUPPLY  =    39053330 * decimalFactor; // 100% Released at TD +1 year
253   uint256 public AVAILABLE_BONUS2_SUPPLY  =     9354408 * decimalFactor; // 100% Released at TD +2 years
254   uint256 public AVAILABLE_BONUS3_SUPPLY  =    28475604 * decimalFactor; // 100% Released at TD +3 years
255 
256   uint256 public grandTotalClaimed = 0;
257   uint256 public startTime;
258 
259   // Allocation with vesting information
260   struct Allocation {
261     uint8 AllocationSupply; // Type of allocation
262     uint256 endCliff;       // Tokens are locked until
263     uint256 endVesting;     // This is when the tokens are fully unvested
264     uint256 totalAllocated; // Total tokens allocated
265     uint256 amountClaimed;  // Total tokens claimed
266   }
267   mapping (address => Allocation) public allocations;
268 
269   // List of admins
270   mapping (address => bool) public airdropAdmins;
271 
272   // Keeps track of whether or not a 250 SOLA airdrop has been made to a particular address
273   mapping (address => bool) public airdrops;
274 
275   modifier onlyOwnerOrAdmin() {
276     require(msg.sender == owner || airdropAdmins[msg.sender]);
277     _;
278   }
279 
280   event LogNewAllocation(address indexed _recipient, AllocationType indexed _fromSupply, uint256 _totalAllocated, uint256 _grandTotalAllocated);
281   event LogSolaClaimed(address indexed _recipient, uint8 indexed _fromSupply, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
282 
283   /**
284     * @dev Constructor function - Set the sola token address
285     * @param _startTime The time when SolaDistribution goes live
286     */
287   function SolaDistribution(uint256 _startTime) public {
288     require(_startTime >= now);
289     require(AVAILABLE_TOTAL_SUPPLY == AVAILABLE_PRESALE_SUPPLY.add(AVAILABLE_FOUNDER_SUPPLY).add(AVAILABLE_AIRDROP_SUPPLY).add(AVAILABLE_ADVISOR_SUPPLY).add(AVAILABLE_BONUS1_SUPPLY).add(AVAILABLE_BONUS2_SUPPLY).add(AVAILABLE_BONUS3_SUPPLY).add(AVAILABLE_RESERVE_SUPPLY));
290     startTime = _startTime;
291     SOLA = new SolaToken(this);
292   }
293 
294   /**
295     * @dev Allow the owner of the contract to assign a new allocation
296     * @param _recipient The recipient of the allocation
297     * @param _totalAllocated The total amount of SOLA available to the receipient (after vesting)
298     * @param _supply The SOLA supply the allocation will be taken from
299     */
300   function setAllocation (address _recipient, uint256 _totalAllocated, AllocationType _supply) onlyOwner public {
301     require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0);
302     require(_supply >= AllocationType.PRESALE && _supply <= AllocationType.BONUS3);
303     require(_recipient != address(0));
304     if (_supply == AllocationType.PRESALE) {
305       AVAILABLE_PRESALE_SUPPLY = AVAILABLE_PRESALE_SUPPLY.sub(_totalAllocated);
306       allocations[_recipient] = Allocation(uint8(AllocationType.PRESALE), 0, 0, _totalAllocated, 0);
307     } else if (_supply == AllocationType.FOUNDER) {
308       AVAILABLE_FOUNDER_SUPPLY = AVAILABLE_FOUNDER_SUPPLY.sub(_totalAllocated);
309       allocations[_recipient] = Allocation(uint8(AllocationType.FOUNDER), startTime + 1 years, startTime + 3 years, _totalAllocated, 0);
310     } else if (_supply == AllocationType.ADVISOR) {
311       AVAILABLE_ADVISOR_SUPPLY = AVAILABLE_ADVISOR_SUPPLY.sub(_totalAllocated);
312       allocations[_recipient] = Allocation(uint8(AllocationType.ADVISOR), startTime + 209 days, 0, _totalAllocated, 0);
313     } else if (_supply == AllocationType.RESERVE) {
314       AVAILABLE_RESERVE_SUPPLY = AVAILABLE_RESERVE_SUPPLY.sub(_totalAllocated);
315       allocations[_recipient] = Allocation(uint8(AllocationType.RESERVE), startTime + 100 days, startTime + 4 years, _totalAllocated, 0);
316     } else if (_supply == AllocationType.BONUS1) {
317       AVAILABLE_BONUS1_SUPPLY = AVAILABLE_BONUS1_SUPPLY.sub(_totalAllocated);
318       allocations[_recipient] = Allocation(uint8(AllocationType.BONUS1), startTime + 1 years, startTime + 1 years, _totalAllocated, 0);
319     } else if (_supply == AllocationType.BONUS2) {
320       AVAILABLE_BONUS2_SUPPLY = AVAILABLE_BONUS2_SUPPLY.sub(_totalAllocated);
321       allocations[_recipient] = Allocation(uint8(AllocationType.BONUS2), startTime + 2 years, startTime + 2 years, _totalAllocated, 0);
322     } else if (_supply == AllocationType.BONUS3) {
323       AVAILABLE_BONUS3_SUPPLY = AVAILABLE_BONUS3_SUPPLY.sub(_totalAllocated);
324       allocations[_recipient] = Allocation(uint8(AllocationType.BONUS3), startTime + 3 years, startTime + 3 years, _totalAllocated, 0);
325     }
326     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(_totalAllocated);
327     LogNewAllocation(_recipient, _supply, _totalAllocated, grandTotalAllocated());
328   }
329 
330   /**
331     * @dev Add an airdrop admin
332     */
333   function setAirdropAdmin(address _admin, bool _isAdmin) public onlyOwner {
334     airdropAdmins[_admin] = _isAdmin;
335   }
336 
337   /**
338     * @dev perform a transfer of allocations
339     * @param _recipient is a list of recipients
340     */
341   function airdropTokens(address[] _recipient) public onlyOwnerOrAdmin {
342     require(now >= startTime);
343     uint airdropped;
344     for(uint256 i = 0; i< _recipient.length; i++)
345     {
346         if (!airdrops[_recipient[i]]) {
347           airdrops[_recipient[i]] = true;
348           require(SOLA.transfer(_recipient[i], 250 * decimalFactor));
349           airdropped = airdropped.add(250 * decimalFactor);
350         }
351     }
352     AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
353     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(airdropped);
354     grandTotalClaimed = grandTotalClaimed.add(airdropped);
355   }
356 
357   /**
358     * @dev Transfer a recipients available allocation to their address
359     * @param _recipient The address to withdraw tokens for
360     */
361   function transferTokens (address _recipient) public {
362     require(allocations[_recipient].amountClaimed < allocations[_recipient].totalAllocated);
363     require(now >= allocations[_recipient].endCliff);
364     require(now >= startTime);
365     uint256 newAmountClaimed;
366     if (allocations[_recipient].endVesting > now) {
367       // Transfer available amount based on vesting schedule and allocation
368       newAmountClaimed = allocations[_recipient].totalAllocated.mul(now.sub(startTime)).div(allocations[_recipient].endVesting.sub(startTime));
369     } else {
370       // Transfer total allocated (minus previously claimed tokens)
371       newAmountClaimed = allocations[_recipient].totalAllocated;
372     }
373     uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_recipient].amountClaimed);
374     allocations[_recipient].amountClaimed = newAmountClaimed;
375     require(SOLA.transfer(_recipient, tokensToTransfer));
376     grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
377     LogSolaClaimed(_recipient, allocations[_recipient].AllocationSupply, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
378   }
379 
380   // Returns the amount of SOLA allocated
381   function grandTotalAllocated() public view returns (uint256) {
382     return INITIAL_SUPPLY - AVAILABLE_TOTAL_SUPPLY;
383   }
384 
385   // Allow transfer of accidentally sent ERC20 tokens
386   function refundTokens(address _recipient, address _token) public onlyOwner {
387     require(_token != address(SOLA));
388     IERC20 token = IERC20(_token);
389     uint256 balance = token.balanceOf(this);
390     require(token.transfer(_recipient, balance));
391   }
392 }