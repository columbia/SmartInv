1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMathForBoost {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 
79 contract Boost {
80     using SafeMathForBoost for uint256;
81 
82     string public name = "Boost";
83     uint8 public decimals = 0;
84     string public symbol = "BST";
85     uint256 public totalSupply = 100000000;
86 
87     // `balances` is the map that tracks the balance of each address, in this
88     //  contract when the balance changes the block number that the change
89     //  occurred is also included in the map
90     mapping (address => Checkpoint[]) balances;
91 
92     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
93     mapping (address => mapping (address => uint256)) allowed;
94 
95     /// @dev `Checkpoint` is the structure that attaches a block number to a
96     ///  given value, the block number attached is the one that last changed the value
97     struct  Checkpoint {
98 
99         // `fromBlock` is the block number that the value was generated from
100         uint256 fromBlock;
101 
102         // `value` is the amount of tokens at a specific block number
103         uint256 value;
104     }
105 
106     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
107     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
108 
109     /// @dev constructor
110     function Boost() public {
111         balances[msg.sender].push(Checkpoint({
112             fromBlock:block.number,
113             value:totalSupply
114         }));
115     }
116 
117     /// @dev Send `_amount` tokens to `_to` from `msg.sender`
118     /// @param _to The address of the recipient
119     /// @param _amount The amount of tokens to be transferred
120     /// @return Whether the transfer was successful or not
121     function transfer(address _to, uint256 _amount) public returns (bool success) {
122         doTransfer(msg.sender, _to, _amount);
123         return true;
124     }
125 
126     /// @dev Send `_amount` tokens to `_to` from `_from` on the condition it
127     ///  is approved by `_from`
128     /// @param _from The address holding the tokens being transferred
129     /// @param _to The address of the recipient
130     /// @param _amount The amount of tokens to be transferred
131     /// @return True if the transfer was successful
132     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
133 
134         // The standard ERC 20 transferFrom functionality
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
136 
137         doTransfer(_from, _to, _amount);
138         return true;
139     }
140 
141     /// @dev _owner The address that's balance is being requested
142     /// @return The balance of `_owner` at the current block
143     function balanceOf(address _owner) public view returns (uint256 balance) {
144         return balanceOfAt(_owner, block.number);
145     }
146 
147     /// @dev `msg.sender` approves `_spender` to spend `_amount` tokens on
148     ///  its behalf. This is a modified version of the ERC20 approve function
149     ///  to be a little bit safer
150     /// @param _spender The address of the account able to transfer the tokens
151     /// @param _amount The amount of tokens to be approved for transfer
152     /// @return True if the approval was successful
153     function approve(address _spender, uint256 _amount) public returns (bool success) {
154 
155         // To change the approve amount you first have to reduce the addresses`
156         //  allowance to zero by calling `approve(_spender,0)` if it is not
157         //  already 0 to mitigate the race condition described here:
158         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
160 
161         allowed[msg.sender][_spender] = _amount;
162         Approval(msg.sender, _spender, _amount);
163         return true;
164     }
165 
166     /// @dev This function makes it easy to read the `allowed[]` map
167     /// @param _owner The address of the account that owns the token
168     /// @param _spender The address of the account able to transfer the tokens
169     /// @return Amount of remaining tokens of _owner that _spender is allowed
170     ///  to spend
171     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
176     /// @param _owner The address from which the balance will be retrieved
177     /// @param _blockNumber The block number when the balance is queried
178     /// @return The balance at `_blockNumber`
179     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
180         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
181             return 0;
182         } else {
183             return getValueAt(balances[_owner], _blockNumber);
184         }
185     }
186 
187     /// @dev This is the actual transfer function in the token contract, it can
188     ///  only be called by other functions in this contract.
189     /// @param _from The address holding the tokens being transferred
190     /// @param _to The address of the recipient
191     /// @param _amount The amount of tokens to be transferred
192     /// @return True if the transfer was successful
193     function doTransfer(address _from, address _to, uint _amount) internal {
194 
195         // Do not allow transfer to 0x0 or the token contract itself
196         require((_to != 0) && (_to != address(this)) && (_amount != 0));
197 
198         // First update the balance array with the new value for the address
199         // sending the tokens
200         var previousBalanceFrom = balanceOfAt(_from, block.number);
201         updateValueAtNow(balances[_from], previousBalanceFrom.sub(_amount));
202 
203         // Then update the balance array with the new value for the address
204         // receiving the tokens
205         var previousBalanceTo = balanceOfAt(_to, block.number);
206         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
207 
208         // An event to make the transfer easy to find on the blockchain
209         Transfer(_from, _to, _amount);
210 
211     }
212 
213     /// @dev `getValueAt` retrieves the number of tokens at a given block number
214     /// @param checkpoints The history of values being queried
215     /// @param _block The block number to retrieve the value at
216     /// @return The number of tokens being queried
217     function getValueAt(Checkpoint[] storage checkpoints, uint _block) internal view  returns (uint) {
218         if (checkpoints.length == 0) return 0;
219 
220         // Shortcut for the actual value
221         if (_block >= checkpoints[checkpoints.length - 1].fromBlock)
222             return checkpoints[checkpoints.length - 1].value;
223         if (_block < checkpoints[0].fromBlock) return 0;
224 
225         // Binary search of the value in the array
226         uint min = 0;
227         uint max = checkpoints.length - 1;
228         while (max > min) {
229             uint mid = (max + min + 1) / 2;
230             if (checkpoints[mid].fromBlock <= _block) {
231                 min = mid;
232             } else {
233                 max = mid - 1;
234             }
235         }
236         return checkpoints[min].value;
237     }
238 
239     /// @dev `updateValueAtNow` used to update the `balances` map and the
240     ///  `totalSupplyHistory`
241     /// @param checkpoints The history of data being updated
242     /// @param _value The new number of tokens
243     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
244         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
245             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
246             newCheckPoint.fromBlock = block.number;
247             newCheckPoint.value = _value;
248         } else {
249             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
250             oldCheckPoint.value = _value;
251         }
252     }
253 
254     /// @dev Helper function to return a min between the two uints
255     function min(uint a, uint b) internal pure returns (uint) {
256         return a < b ? a : b;
257     }
258 }
259 
260 
261 // @title Boost token interface to use during the ICO
262 contract BoostCrowdsale is Ownable {
263     using SafeMathForBoost for uint256;
264 
265     // start and end timestamps where investments are allowed (both inclusive)
266     uint256 public startTime;
267     uint256 public endTime;
268 
269     // rate use during the ico
270     uint256 public rate;
271 
272     // address of multiSigWallet to store ether
273     address public wallet;
274 
275     // Boost token
276     Boost public boost;
277 
278     // cap
279     uint256 public cap;
280 
281     // amount of raised money in wei
282     uint256 public weiRaised;
283 
284     // minimun amount
285     uint256 public minimumAmount = 0.1 ether;
286 
287     // amount of sold token
288     uint256 public soldAmount;
289 
290     // isFinalised flag
291     bool public isFinalized = false;
292 
293     /**
294     * event for token purchase logging
295     * @param beneficiary who got the tokens
296     * @param value weis paid for purchase
297     * @param amount amount of tokens purchased
298     */
299     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
300 
301     // event for finalized
302     event Finalized();
303 
304     // @dev constructor
305     function BoostCrowdsale(uint256 _startTime, uint256 _endTime, address _boostAddress, uint256 _rate, address _wallet, uint256 _cap) public {
306         require(_startTime >= now);
307         require(_endTime >= _startTime);
308         require(_boostAddress != address(0));
309         require(_rate > 0);
310         require(_wallet != address(0));
311         require(_cap > 0);
312 
313         startTime = _startTime;
314         endTime = _endTime;
315         boost = Boost(_boostAddress);
316         rate = _rate;
317         wallet = _wallet;
318         cap = _cap;
319     }
320 
321     /**
322     * @dev Must be called after crowdsale ends, to do some extra finalization
323     * work. Calls the contract's finalization function.
324     */
325     function finalize() public onlyOwner {
326         require(!isFinalized);
327         require(hasEnded());
328 
329         finalization();
330         Finalized();
331 
332         isFinalized = true;
333     }
334 
335     // @dev fallback function to exchange the ether for Boost token
336     function() public payable {
337         uint256 weiAmount = msg.value;
338 
339         // calc token amount
340         uint256 tokens = getTokenAmount(weiAmount);
341 
342         require(validPurchase(tokens));
343 
344         // update state
345         weiRaised = weiRaised.add(weiAmount);
346         soldAmount = soldAmount.add(tokens);
347 
348         // transfer boostToken from owner to msg.sender
349         boost.transfer(msg.sender, tokens);
350         TokenPurchase(msg.sender, weiAmount, tokens);
351 
352         forwardFunds();
353     }
354 
355     // @dev return true if crowdsale event has ended
356     function hasEnded() public view returns (bool) {
357         bool overPeriod = now > endTime;
358         bool underPurchasableAmount = getPurchasableAmount() < 10000;
359         return overPeriod || underPurchasableAmount;
360     }
361 
362     // @dev return the amount of token that user can purchase
363     function getPurchasableAmount() public view returns (uint256) {
364         return boost.balanceOf(this);
365     }
366 
367     // @dev return the amount of ether that user can send in order to purchase token
368     function getSendableEther() public view returns (uint256) {
369         return boost.balanceOf(this).mul(10 ** 18).div(rate);
370     }
371 
372     // @dev return the amount of token that msg.sender can receive based on the amount of ether that msg.sender sent
373     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
374         return _weiAmount.mul(rate).div(10 ** 18);
375     }
376 
377     // @dev send ether to the fund collection wallet
378     function forwardFunds() internal {
379         wallet.transfer(msg.value);
380     }
381 
382     // @dev finalization
383     function finalization() internal {
384         if (boost.balanceOf(this) > 0) {
385             require(boost.transfer(owner, boost.balanceOf(this)));
386         }
387     }
388 
389     // @dev return true if the transaction can buy tokens
390     function validPurchase(uint256 _tokens) internal view returns (bool) {
391         bool withinPeriod = now >= startTime && now <= endTime;
392         bool moreThanOrEqualToMinimumAmount = msg.value >= minimumAmount;
393         bool validPurchasableAmount = cap >= soldAmount.add(_tokens);
394         return withinPeriod && moreThanOrEqualToMinimumAmount && validPurchasableAmount;
395     }
396 }