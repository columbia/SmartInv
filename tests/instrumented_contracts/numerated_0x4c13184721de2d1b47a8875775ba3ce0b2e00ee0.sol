1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Helps contracts guard agains rentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>
6  * @notice If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10 
11   /**
12    * @dev We use a single lock for the whole contract.
13    */
14   bool private rentrancy_lock = false;
15 
16   /**
17    * @dev Prevents a contract from calling itself, directly or indirectly.
18    * @notice If you mark a function `nonReentrant`, you should also
19    * mark it `external`. Calling one nonReentrant function from
20    * another is not supported. Instead, you can implement a
21    * `private` function doing the actual work, and a `external`
22    * wrapper marked as `nonReentrant`.
23    */
24   modifier nonReentrant() {
25     require(!rentrancy_lock);
26     rentrancy_lock = true;
27     _;
28     rentrancy_lock = false;
29   }
30 
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 // Minimal Bitcoineum interface for proxy mining
73 contract BitcoineumInterface {
74    function mine() payable;
75    function claim(uint256 _blockNumber, address forCreditTo);
76    function checkMiningAttempt(uint256 _blockNum, address _sender) constant public returns (bool);
77    function checkWinning(uint256 _blockNum) constant public returns (bool);
78    function transfer(address _to, uint256 _value) returns (bool);
79    function balanceOf(address _owner) constant returns (uint256 balance);
80    function currentDifficultyWei() constant public returns (uint256);
81    }
82 
83 // Sharkpool is a rolling window Bitcoineum miner
84 // Smart contract based virtual mining
85 // http://www.bitcoineum.com/
86 
87 contract SharkPool is Ownable, ReentrancyGuard {
88 
89     string constant public pool_name = "SharkPool 200";
90 
91     // Percentage of BTE pool takes for operations
92     uint256 public pool_percentage = 5;
93 
94     // Limiting users because of gas limits
95     // I would not increase this value it could make the pool unstable
96     uint256 constant public max_users = 100;
97 
98     // Track total users to switch to degraded case when contract is full
99     uint256 public total_users = 0;
100 
101     uint256 public constant divisible_units = 10000000;
102 
103     // How long will a payment event mine blocks for you
104     uint256 public contract_period = 100;
105     uint256 public mined_blocks = 1;
106     uint256 public claimed_blocks = 1;
107     uint256 public blockCreationRate = 0;
108 
109     BitcoineumInterface base_contract;
110 
111     struct user {
112         uint256 start_block;
113         uint256 end_block;
114         uint256 proportional_contribution;
115     }
116 
117     mapping (address => user) public users;
118     mapping (uint256 => uint256) public attempts;
119     mapping(address => uint256) balances;
120     uint8[] slots;
121     address[256] public active_users; // Should equal max_users
122 
123     function balanceOf(address _owner) constant returns (uint256 balance) {
124       return balances[_owner];
125     }
126 
127     function set_pool_percentage(uint8 _percentage) external nonReentrant onlyOwner {
128        // Just in case owner is compromised
129        require(_percentage < 11);
130        pool_percentage = _percentage;
131     }
132 
133 
134     function find_contribution(address _who) constant external returns (uint256, uint256, uint256, uint256, uint256) {
135       if (users[_who].start_block > 0) {
136          user memory u = users[_who];
137          uint256 remaining_period= 0;
138          if (u.end_block > mined_blocks) {
139             remaining_period = u.end_block - mined_blocks;
140             } else {
141             remaining_period = 0;
142             }
143          return (u.start_block, u.end_block,
144                  u.proportional_contribution,
145                  u.proportional_contribution * contract_period,
146                  u.proportional_contribution * remaining_period);
147       }
148       return (0,0,0,0,0);
149     }
150 
151     function allocate_slot(address _who) internal {
152        if(total_users < max_users) { 
153             // Just push into active_users
154             active_users[total_users] = _who;
155             total_users += 1;
156           } else {
157             // The maximum users have been reached, can we allocate a free space?
158             if (slots.length == 0) {
159                 // There isn't any room left
160                 revert();
161             } else {
162                uint8 location = slots[slots.length-1];
163                active_users[location] = _who;
164                delete slots[slots.length-1];
165             }
166           }
167     }
168 
169      function external_to_internal_block_number(uint256 _externalBlockNum) public constant returns (uint256) {
170         // blockCreationRate is > 0
171         return _externalBlockNum / blockCreationRate;
172      }
173 
174      function available_slots() public constant returns (uint256) {
175         if (total_users < max_users) {
176             return max_users - total_users;
177         } else {
178           return slots.length;
179         }
180      }
181   
182    event LogEvent(
183        uint256 _info
184    );
185 
186     function get_bitcoineum_contract_address() public constant returns (address) {
187        return 0x73dD069c299A5d691E9836243BcaeC9c8C1D8734; // Production
188     
189        // return 0x7e7a299da34a350d04d204cd80ab51d068ad530f; // Testing
190     }
191 
192     // iterate over all account holders
193     // and balance transfer proportional bte
194     // balance should be 0 aftwards in a perfect world
195     function distribute_reward(uint256 _totalAttempt, uint256 _balance) internal {
196       uint256 remaining_balance = _balance;
197       for (uint8 i = 0; i < total_users; i++) {
198           address user_address = active_users[i];
199           if (user_address > 0 && remaining_balance != 0) {
200               uint256 proportion = users[user_address].proportional_contribution;
201               uint256 divided_portion = (proportion * divisible_units) / _totalAttempt;
202               uint256 payout = (_balance * divided_portion) / divisible_units;
203               if (payout > remaining_balance) {
204                  payout = remaining_balance;
205               }
206               balances[user_address] = balances[user_address] + payout;
207               remaining_balance = remaining_balance - payout;
208           }
209       }
210     }
211 
212     function SharkPool() {
213       blockCreationRate = 50; // match bte
214       base_contract = BitcoineumInterface(get_bitcoineum_contract_address());
215     }
216 
217     function current_external_block() public constant returns (uint256) {
218         return block.number;
219     }
220 
221 
222     function calculate_minimum_contribution() public constant returns (uint256)  {
223        return base_contract.currentDifficultyWei() / 10000000 * contract_period;
224     }
225 
226     // A default ether tx without gas specified will fail.
227     function () payable {
228          require(msg.value >= calculate_minimum_contribution());
229 
230          // Did the user already contribute
231          user storage current_user = users[msg.sender];
232 
233          // Does user exist already
234          if (current_user.start_block > 0) {
235             if (current_user.end_block > mined_blocks) {
236                 uint256 periods_left = current_user.end_block - mined_blocks;
237                 uint256 amount_remaining = current_user.proportional_contribution * periods_left;
238                 amount_remaining = amount_remaining + msg.value;
239                 amount_remaining = amount_remaining / contract_period;
240                 current_user.proportional_contribution = amount_remaining;
241             } else {
242                current_user.proportional_contribution = msg.value / contract_period;
243             }
244 
245           // If the user exists and has a balance let's transfer it to them
246           do_redemption();
247 
248           } else {
249                current_user.proportional_contribution = msg.value / contract_period;
250                allocate_slot(msg.sender);
251           }
252           current_user.start_block = mined_blocks;
253           current_user.end_block = mined_blocks + contract_period;
254          }
255 
256     
257     // Proxy mining to token
258    function mine() external nonReentrant
259    {
260      // Did someone already try to mine this block?
261      uint256 _blockNum = external_to_internal_block_number(current_external_block());
262      require(!base_contract.checkMiningAttempt(_blockNum, this));
263 
264      // Alright nobody mined lets iterate over our active_users
265 
266      uint256 total_attempt = 0;
267      uint8 total_ejected = 0; 
268 
269      for (uint8 i=0; i < total_users; i++) {
270          address user_address = active_users[i];
271          if (user_address > 0) {
272              // This user exists
273              user memory u = users[user_address];
274              if (u.end_block <= mined_blocks) {
275                 // This user needs to be ejected, no more attempts left
276                 // but we limit to 20 to prevent gas issues on slot insert
277                 if (total_ejected < 10) {
278                     delete active_users[i];
279                     slots.push(i);
280                     delete users[active_users[i]];
281                     total_ejected = total_ejected + 1;
282                 }
283              } else {
284                // This user is still active
285                total_attempt = total_attempt + u.proportional_contribution;
286              }
287          }
288      }
289      if (total_attempt > 0) {
290         // Now we have a total contribution amount
291         attempts[_blockNum] = total_attempt;
292         base_contract.mine.value(total_attempt)();
293         mined_blocks = mined_blocks + 1;
294      }
295    }
296 
297    function claim(uint256 _blockNumber, address forCreditTo)
298                   nonReentrant
299                   external returns (bool) {
300                   
301                   // Did we win the block in question
302                   require(base_contract.checkWinning(_blockNumber));
303 
304                   uint256 initial_balance = base_contract.balanceOf(this);
305 
306                   // We won let's get our reward
307                   base_contract.claim(_blockNumber, this);
308 
309                   uint256 balance = base_contract.balanceOf(this);
310                   uint256 total_attempt = attempts[_blockNumber];
311 
312                   distribute_reward(total_attempt, balance - initial_balance);
313                   claimed_blocks = claimed_blocks + 1;
314                   }
315 
316    function do_redemption() internal {
317      uint256 balance = balances[msg.sender];
318      if (balance > 0) {
319         uint256 owner_cut = (balance / 100) * pool_percentage;
320         uint256 remainder = balance - owner_cut;
321         if (owner_cut > 0) {
322             base_contract.transfer(owner, owner_cut);
323         }
324         base_contract.transfer(msg.sender, remainder);
325         balances[msg.sender] = 0;
326     }
327    }
328 
329    function redeem() external nonReentrant
330      {
331         do_redemption();
332      }
333 
334    function checkMiningAttempt(uint256 _blockNum, address _sender) constant public returns (bool) {
335       return base_contract.checkMiningAttempt(_blockNum, _sender);
336    }
337    
338    function checkWinning(uint256 _blockNum) constant public returns (bool) {
339      return base_contract.checkWinning(_blockNum);
340    }
341 
342 }