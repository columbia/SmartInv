1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.4;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint);
7     function balanceOf(address account) external view returns (uint);
8     function transfer(address recipient, uint amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint);
10     function approve(address spender, uint amount) external returns (bool);
11     function transferFrom(
12         address sender,
13         address recipient,
14         uint amount
15     ) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 contract DreamX {
21 
22     string public name = "DreamX";
23     
24     // create 2 state variables
25     address public Dream = 0x8b17feA54d85F61E71BdF161e920762898AC53da;
26 
27     uint reward_rate;
28 
29     struct farm_slot {
30         bool active;
31         uint balance;
32         uint deposit_time;
33         uint locked_time;
34         uint index;
35         address token;
36     }
37 
38     struct farm_pool {
39         mapping(uint => uint) lock_multiplier;
40         mapping(address => uint) is_farming;
41         mapping(address => bool) has_farmed;
42         uint total_balance;
43     }
44 
45     address public owner;
46 
47     address[] public farms;
48 
49     mapping(address => mapping(uint => farm_slot)) public farming_unit;
50     mapping(address => uint[]) farmer_pools;
51     mapping(address => farm_pool) public token_pool;
52     mapping(address => uint) farm_id;
53     mapping(address => bool) public is_farmable;
54     mapping(address => uint) public last_tx;
55     mapping(address => mapping(uint => uint)) public lock_multiplier;
56     mapping(uint => bool) time_allowed;
57 
58     mapping(address => bool) public is_auth;
59 
60     uint256 cooldown_time = 10 seconds;
61 
62     bool is_fixed_locking = true;
63     
64     IERC20 dream_reward;
65 
66     constructor() {
67         owner = msg.sender;
68         is_farmable[Dream] = false;
69         dream_reward = IERC20(Dream);
70 
71     }
72 
73     bool locked;
74 
75     modifier safe() {
76         require (!locked, "Guard");
77         locked = true;
78         _;
79         locked = false;
80     }
81 
82     modifier cooldown() {
83         require(block.timestamp > last_tx[msg.sender] + cooldown_time, "Calm down");
84         _;
85         last_tx[msg.sender] = block.timestamp;
86     }
87 
88     modifier authorized() {
89         require(owner==msg.sender || is_auth[msg.sender], "403");
90         _;
91     }
92     
93     function is_unlocked (uint id, address addy) public view returns(bool) {
94         return( (block.timestamp > farming_unit[addy][id].deposit_time + farming_unit[addy][id].locked_time) );
95     }
96 
97 
98     ///@notice Public farming functions
99 
100     ///@dev Approve
101     function approveTokens() public {
102         bool approved = IERC20(Dream).approve(address(this), 2**256 - 1);
103         require(approved, "Can't approve");
104     }
105 
106     ///@dev Deposit farmable tokens in the contract
107     function farmTokens(uint _amount, uint locking) public {
108         require(is_farmable[Dream], "Farming not supported");
109         if (is_fixed_locking) {
110             require(time_allowed[locking], "Locking time not allowed");
111         } else {
112             require(locking >= 1 days, "Locking time not allowed");
113         }
114         require(IERC20(Dream).allowance(msg.sender, address(this)) >= _amount, "Allowance?");
115 
116         // Trasnfer farmable tokens to contract for farming
117         bool transferred = IERC20(Dream).transferFrom(msg.sender, address(this), _amount);
118         require(transferred, "Not transferred");
119 
120         // Update the farming balance in mappings
121         farm_id[msg.sender]++;
122         uint id = farm_id[msg.sender];
123         farming_unit[msg.sender][id].locked_time = locking;
124         farming_unit[msg.sender][id].balance = farming_unit[msg.sender][id].balance + _amount;
125         farming_unit[msg.sender][id].deposit_time = block.timestamp;
126         farming_unit[msg.sender][id].token = Dream;
127         token_pool[Dream].total_balance += _amount;
128 
129         // Add user to farms array if they haven't farmd already
130         if(token_pool[Dream].has_farmed[msg.sender]) {
131             token_pool[Dream].has_farmed[msg.sender] = true;
132         }
133 
134         // Update farming status to track
135         token_pool[Dream].is_farming[msg.sender]++;
136         farmer_pools[msg.sender].push(id);
137         farming_unit[msg.sender][id].index = (farmer_pools[msg.sender].length)-1;
138     }
139 
140 
141      ///@dev Unfarm tokens (if not locked)
142      function unfarmTokens(uint id) public safe cooldown {
143         if (!is_auth[msg.sender]) {
144             require(is_unlocked(id, msg.sender), "Locking time not finished");
145         }
146 
147         uint balance = _calculate_rewards(id, msg.sender);
148 
149         // require the amount farms needs to be greater then 0
150         require(balance > 0, "farming balance can not be 0");
151     
152         // transfer dream tokens out of this contract to the msg.sender
153         dream_reward.transfer(msg.sender, farming_unit[msg.sender][id].balance);
154         dream_reward.transfer(msg.sender, balance);
155     
156         // reset farming balance map to 0
157         farming_unit[msg.sender][id].balance = 0;
158         farming_unit[msg.sender][id].active = false;
159         farming_unit[msg.sender][id].deposit_time = block.timestamp;
160         address token = farming_unit[msg.sender][id].token;
161 
162         // update the farming status
163         token_pool[token].is_farming[msg.sender]--;
164 
165         // delete farming pool id
166         delete farmer_pools[msg.sender][farming_unit[msg.sender][id].index];
167 }
168 
169     ///@dev Give rewards and clear the reward status    
170     function issueInterestToken(uint id) public safe cooldown {
171         require(is_unlocked(id, msg.sender), "Locking time not finished");
172         uint balance = _calculate_rewards(id, msg.sender);            
173         dream_reward.transfer(msg.sender, balance);
174         // reset the time counter so it is not double paid
175         farming_unit[msg.sender][id].deposit_time = block.timestamp;    
176         }
177 
178     ///@dev return the general state of a pool
179     function get_pool() public view returns (uint) {
180         require(is_farmable[Dream], "Not active");
181         return(token_pool[Dream].total_balance);
182     }
183         
184         
185 
186     ///@notice Private functions
187 
188     ///@dev Helper to calculate rewards in a quick and lightweight way
189     function _calculate_rewards(uint id, address addy) public view returns (uint) {
190     	// get the users farming balance in dream
191         uint delta_time = block.timestamp - farming_unit[addy][id].deposit_time; // - initial deposit
192         /// Rationale: balance*rate/100 gives the APY reward. Is multiplied by year/time passed that is written like that because solidity doesn't like floating numbers
193         uint locking_time = farming_unit[addy][id].locked_time;
194         uint updated_reward_rate = reward_rate + lock_multiplier[Dream][locking_time];
195         uint balance = (((farming_unit[addy][id].balance * updated_reward_rate) / 100) * ((delta_time * 1000000) / 365 days ))/1000000;
196         return balance;
197      }
198 
199      ///@notice Control functions
200 
201      function get_farmer_pools(address farmer) public view returns(uint[] memory) {
202          return(farmer_pools[farmer]);
203      }
204 
205      function unstuck_tokens(address tkn) public authorized {
206          require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
207          uint amount = IERC20(tkn).balanceOf(address(this));
208          IERC20(tkn).transfer(msg.sender, amount);
209      }
210 
211      function set_time_allowed(uint time, bool booly) public authorized {
212          time_allowed[time] = booly;
213      }
214 
215      function set_authorized(address addy, bool booly) public authorized {
216          is_auth[addy] = booly;
217      }
218 
219      function set_farming_state(bool status) public authorized {
220          is_farmable[Dream] = status;
221      }
222 
223      function get_farming_state() public view returns (bool) {
224          return is_farmable[Dream];
225      }
226 
227      function get_reward_rate() public view returns (uint) {
228         return reward_rate;
229      }
230 
231      function get_reward_rate_timed(uint time) public view returns (uint) {
232          uint reward_timed = reward_rate+lock_multiplier[Dream][time];
233          return reward_timed;
234      }
235 
236     function set_reward_rate(uint rate) public authorized {
237         reward_rate = rate;
238     }
239 
240      function set_dream(address token) public authorized {
241          Dream = token;
242          dream_reward = IERC20(Dream);
243      }  
244 
245      function set_multiplier(uint time, uint multiplier) public authorized {
246          lock_multiplier[Dream][time] = multiplier;
247      }
248 
249     function set_is_fixed_locking(bool fixed_locking) public authorized {
250         is_fixed_locking = fixed_locking;
251     }
252      
253      function get_multiplier(uint time) public view returns(uint) {
254          return lock_multiplier[Dream][time];
255      }
256 
257 
258     ///@notice time helpers
259 
260      function get_1_day() public pure returns(uint) {
261          return(1 days);
262      }
263 
264      function get_1_week() public pure returns(uint) {
265          return(7 days);
266      }
267 
268      function get_1_month() public pure returns(uint) {
269          return(30 days);
270      }
271      
272      function get_3_months() public pure returns(uint) {
273          return(90 days);
274      }
275 
276      function get_x_days(uint x) public pure returns(uint) {
277          return((1 days*x));
278      }
279     
280     function get_single_pool(uint id, address addy) public view returns (farm_slot memory) {
281         return(farming_unit[addy][id]);
282     }
283 
284     function get_time_remaining(uint id, address addy) public view returns (uint) {
285         return(farming_unit[addy][id].deposit_time + farming_unit[addy][id].locked_time);
286     }
287 
288     function get_pool_lock_time(uint id, address addy) public view returns (uint) {
289         return(farming_unit[addy][id].locked_time);
290     }
291     
292     function get_pool_balance(uint id, address addy) public view returns (uint) {
293         return(farming_unit[addy][id].balance);
294     }
295 
296     function get_pool_details(uint id, address addy) public view returns (uint, uint) {
297       return(get_pool_balance(id, addy), get_time_remaining(id, addy));   
298     }
299 
300     receive() external payable {}
301     fallback() external payable {}
302 }