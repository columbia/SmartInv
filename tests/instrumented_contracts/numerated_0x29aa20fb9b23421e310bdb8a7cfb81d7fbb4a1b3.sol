1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 
43 /**
44  * @title Helps contracts guard agains rentrancy attacks.
45  * @author Remco Bloemen <remco@2π.com>
46  * @notice If you mark a function `nonReentrant`, you should also
47  * mark it `external`.
48  */
49 contract ReentrancyGuard {
50 
51   /**
52    * @dev We use a single lock for the whole contract.
53    */
54   bool private rentrancy_lock = false;
55 
56   /**
57    * @dev Prevents a contract from calling itself, directly or indirectly.
58    * @notice If you mark a function `nonReentrant`, you should also
59    * mark it `external`. Calling one nonReentrant function from
60    * another is not supported. Instead, you can implement a
61    * `private` function doing the actual work, and a `external`
62    * wrapper marked as `nonReentrant`.
63    */
64   modifier nonReentrant() {
65     require(!rentrancy_lock);
66     rentrancy_lock = true;
67     _;
68     rentrancy_lock = false;
69   }
70 
71 }
72 
73 
74 // Minimal Bitcoineum interface for proxy mining
75 contract BitcoineumInterface {
76    function mine() payable;
77    function claim(uint256 _blockNumber, address forCreditTo);
78    function checkMiningAttempt(uint256 _blockNum, address _sender) constant public returns (bool);
79    function checkWinning(uint256 _blockNum) constant public returns (bool);
80    function transfer(address _to, uint256 _value) returns (bool);
81    function balanceOf(address _owner) constant returns (uint256 balance);
82    function currentDifficultyWei() constant public returns (uint256);
83    }
84 
85 
86 // Sharkpool is a rolling window Bitcoineum miner
87 // Smart contract based virtual mining
88 // http://www.bitcoineum.com/
89 
90 contract SharkPool is Ownable, ReentrancyGuard {
91 
92     string constant public pool_name = "SharkPool 100";
93 
94     // Percentage of BTE pool takes for operations
95     uint256 public pool_percentage = 0;
96 
97     // Limiting users because of gas limits
98     // I would not increase this value it could make the pool unstable
99     uint256 constant public max_users = 100;
100 
101     // Track total users to switch to degraded case when contract is full
102     uint256 public total_users = 0;
103 
104     uint256 public constant divisible_units = 10000000;
105 
106     // How long will a payment event mine blocks for you
107     uint256 public contract_period = 100;
108     uint256 public mined_blocks = 1;
109     uint256 public claimed_blocks = 1;
110     uint256 public blockCreationRate = 0;
111 
112     BitcoineumInterface base_contract;
113 
114     struct user {
115         uint256 start_block;
116         uint256 end_block;
117         uint256 proportional_contribution;
118     }
119 
120     mapping (address => user) public users;
121     mapping (uint256 => uint256) public attempts;
122     mapping(address => uint256) balances;
123     uint8[] slots;
124     address[256] public active_users; // Should equal max_users
125 
126     function balanceOf(address _owner) constant returns (uint256 balance) {
127       return balances[_owner];
128     }
129 
130     function set_pool_percentage(uint8 _percentage) external nonReentrant onlyOwner {
131        // Just in case owner is compromised
132        require(_percentage < 6);
133        pool_percentage = _percentage;
134     }
135 
136 
137     function find_contribution(address _who) constant external returns (uint256, uint256, uint256, uint256, uint256) {
138       if (users[_who].start_block > 0) {
139          user memory u = users[_who];
140          uint256 remaining_period= 0;
141          if (u.end_block > mined_blocks) {
142             remaining_period = u.end_block - mined_blocks;
143             } else {
144             remaining_period = 0;
145             }
146          return (u.start_block, u.end_block,
147                  u.proportional_contribution,
148                  u.proportional_contribution * contract_period,
149                  u.proportional_contribution * remaining_period);
150       }
151       return (0,0,0,0,0);
152     }
153 
154     function allocate_slot(address _who) internal {
155        if(total_users < max_users) { 
156             // Just push into active_users
157             active_users[total_users] = _who;
158             total_users += 1;
159           } else {
160             // The maximum users have been reached, can we allocate a free space?
161             if (slots.length == 0) {
162                 // There isn't any room left
163                 revert();
164             } else {
165                uint8 location = slots[slots.length-1];
166                active_users[location] = _who;
167                delete slots[slots.length-1];
168             }
169           }
170     }
171 
172      function external_to_internal_block_number(uint256 _externalBlockNum) public constant returns (uint256) {
173         // blockCreationRate is > 0
174         return _externalBlockNum / blockCreationRate;
175      }
176 
177      function available_slots() public constant returns (uint256) {
178         if (total_users < max_users) {
179             return max_users - total_users;
180         } else {
181           return slots.length;
182         }
183      }
184   
185    event LogEvent(
186        uint256 _info
187    );
188 
189     function get_bitcoineum_contract_address() public constant returns (address) {
190        return 0x73dD069c299A5d691E9836243BcaeC9c8C1D8734; // Production
191     
192        // return 0x7e7a299da34a350d04d204cd80ab51d068ad530f; // Testing
193     }
194 
195     // iterate over all account holders
196     // and balance transfer proportional bte
197     // balance should be 0 aftwards in a perfect world
198     function distribute_reward(uint256 _totalAttempt, uint256 _balance) internal {
199       uint256 remaining_balance = _balance;
200       for (uint8 i = 0; i < total_users; i++) {
201           address user_address = active_users[i];
202           if (user_address > 0 && remaining_balance != 0) {
203               uint256 proportion = users[user_address].proportional_contribution;
204               uint256 divided_portion = (proportion * divisible_units) / _totalAttempt;
205               uint256 payout = (_balance * divided_portion) / divisible_units;
206               if (payout > remaining_balance) {
207                  payout = remaining_balance;
208               }
209               balances[user_address] = balances[user_address] + payout;
210               remaining_balance = remaining_balance - payout;
211           }
212       }
213     }
214 
215     function SharkPool() {
216       blockCreationRate = 50; // match bte
217       base_contract = BitcoineumInterface(get_bitcoineum_contract_address());
218     }
219 
220     function current_external_block() public constant returns (uint256) {
221         return block.number;
222     }
223 
224 
225     function calculate_minimum_contribution() public constant returns (uint256)  {
226        return base_contract.currentDifficultyWei() / 10000000 * contract_period;
227     }
228 
229     // A default ether tx without gas specified will fail.
230     function () payable {
231          require(msg.value >= calculate_minimum_contribution());
232 
233          // Did the user already contribute
234          user storage current_user = users[msg.sender];
235 
236          // Does user exist already
237          if (current_user.start_block > 0) {
238             if (current_user.end_block > mined_blocks) {
239                 uint256 periods_left = current_user.end_block - mined_blocks;
240                 uint256 amount_remaining = current_user.proportional_contribution * periods_left;
241                 amount_remaining = amount_remaining + msg.value;
242                 amount_remaining = amount_remaining / contract_period;
243                 current_user.proportional_contribution = amount_remaining;
244             } else {
245                current_user.proportional_contribution = msg.value / contract_period;
246             }
247 
248           // If the user exists and has a balance let's transfer it to them
249           do_redemption();
250 
251           } else {
252                current_user.proportional_contribution = msg.value / contract_period;
253                allocate_slot(msg.sender);
254           }
255           current_user.start_block = mined_blocks;
256           current_user.end_block = mined_blocks + contract_period;
257          }
258 
259     
260     // Proxy mining to token
261    function mine() external nonReentrant
262    {
263      // Did someone already try to mine this block?
264      uint256 _blockNum = external_to_internal_block_number(current_external_block());
265      require(!base_contract.checkMiningAttempt(_blockNum, this));
266 
267      // Alright nobody mined lets iterate over our active_users
268 
269      uint256 total_attempt = 0;
270      uint8 total_ejected = 0; 
271 
272      for (uint8 i=0; i < total_users; i++) {
273          address user_address = active_users[i];
274          if (user_address > 0) {
275              // This user exists
276              user memory u = users[user_address];
277              if (u.end_block <= mined_blocks) {
278                 // This user needs to be ejected, no more attempts left
279                 // but we limit to 20 to prevent gas issues on slot insert
280                 if (total_ejected < 10) {
281                     delete active_users[i];
282                     slots.push(i);
283                     delete users[active_users[i]];
284                     total_ejected = total_ejected + 1;
285                 }
286              } else {
287                // This user is still active
288                total_attempt = total_attempt + u.proportional_contribution;
289              }
290          }
291      }
292      if (total_attempt > 0) {
293         // Now we have a total contribution amount
294         attempts[_blockNum] = total_attempt;
295         base_contract.mine.value(total_attempt)();
296         mined_blocks = mined_blocks + 1;
297      }
298    }
299 
300    function claim(uint256 _blockNumber, address forCreditTo)
301                   nonReentrant
302                   external returns (bool) {
303                   
304                   // Did we win the block in question
305                   require(base_contract.checkWinning(_blockNumber));
306 
307                   uint256 initial_balance = base_contract.balanceOf(this);
308 
309                   // We won let's get our reward
310                   base_contract.claim(_blockNumber, this);
311 
312                   uint256 balance = base_contract.balanceOf(this);
313                   uint256 total_attempt = attempts[_blockNumber];
314 
315                   distribute_reward(total_attempt, balance - initial_balance);
316                   claimed_blocks = claimed_blocks + 1;
317                   }
318 
319    function do_redemption() internal {
320      uint256 balance = balances[msg.sender];
321      if (balance > 0) {
322         uint256 owner_cut = (balance / 100) * pool_percentage;
323         uint256 remainder = balance - owner_cut;
324         if (owner_cut > 0) {
325             base_contract.transfer(owner, owner_cut);
326         }
327         base_contract.transfer(msg.sender, remainder);
328         balances[msg.sender] = 0;
329     }
330    }
331 
332    function redeem() external nonReentrant
333      {
334         do_redemption();
335      }
336 
337    function checkMiningAttempt(uint256 _blockNum, address _sender) constant public returns (bool) {
338       return base_contract.checkMiningAttempt(_blockNum, _sender);
339    }
340    
341    function checkWinning(uint256 _blockNum) constant public returns (bool) {
342      return base_contract.checkWinning(_blockNum);
343    }
344 
345 }