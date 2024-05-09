1 pragma solidity ^0.4.24;
2 
3 //  _______  .______        ___      .__   __.  __  ___
4 // |       \ |   _  \      /   \     |  \ |  | |  |/  /
5 // |  .--.  ||  |_)  |    /  ^  \    |   \|  | |  '  /
6 // |  |  |  ||   _  <    /  /_\  \   |  . `  | |    <
7 // |  '--'  ||  |_)  |  /  _____  \  |  |\   | |  .  \
8 // |_______/ |______/  /__/     \__\ |__| \__| |__|\__\
9 // 
10 // VISIT => http://dbank.money
11 // 
12 // The first global decentralized bank.
13 // 
14 // 1. GAIN 4% PER 24 HOURS (every 5900 blocks)
15 // 2. [FREE BONUS] New users get a 0.1 ETH bonus immediately!
16 // 3. [REFERRAL BONUS] If you invite your friend to invest, you both get a 10% bonus.
17 // 4. NO COMMISSION. NO FEES.
18 // 
19 // Contracts reviewed and approved by pros!
20 
21 contract DBank {
22     uint256 dbk_;   // total investment in DBank
23     mapping (address => uint256) invested; // address => investment
24     mapping (address => uint256) atBlock; // address => user's investment at block
25     uint256 public r_ = 4; //profit ratio，every 5900 blocks(1 day) you earn 4%
26     uint256 public blocks_ = 5900; //blocks in every cycle
27 
28     // Player and referral bonus
29     uint256 public pID_;    // total number of players
30     mapping (address => uint256) public pIDxAddr_;  // (addr => pID) returns player id by address
31     mapping (uint256 => address) public plyr_;   // (pID => data) player data
32 
33     // New User Bonus
34     bool public bonusOn_ = true;    // give bonus or not
35     uint256 public bonusAmount_ = 1 * 10**16;   // 0.01 ETH
36 
37     // this function called every time anyone sends a transaction to this contract
38     function ()
39         external 
40         payable
41     {
42         buyCore(msg.sender, msg.value);
43     }
44 
45     // buy with refferal ID
46     function buy(uint256 refID)
47         public
48         payable
49     {
50         buyCore(msg.sender, msg.value);
51 
52         // bonus for refferal 10%
53         if (plyr_[refID] != address(0)) {
54             invested[plyr_[refID]] += msg.value / 10;
55         }
56 
57         // bonus for user self 10%
58         invested[msg.sender] += msg.value / 10;
59     }
60 
61     // Reinvest
62     function reinvest()
63         public
64     {
65         if (invested[msg.sender] != 0) {
66             uint256 amount = invested[msg.sender] * r_ / 100 * (block.number - atBlock[msg.sender]) / blocks_;
67             
68             atBlock[msg.sender] = block.number;
69             invested[msg.sender] += amount;
70         }
71     }
72 
73     // === Getters ===
74 
75     // get investment and profit
76     // returns: base, profit, playerID, players
77     function getMyInvestment()
78         public
79         view
80         returns (uint256, uint256, uint256, uint256)
81     {
82         uint256 amount = 0;
83         if (invested[msg.sender] != 0) {
84             amount = invested[msg.sender] * r_ / 100 * (block.number - atBlock[msg.sender]) / blocks_;
85         }
86         return (invested[msg.sender], amount, pIDxAddr_[msg.sender], pID_);
87     }
88 
89     // === Private Methods ===
90 
91     // Core Logic of Buying
92     function buyCore(address _addr, uint256 _value)
93         private
94     {
95         // New user check
96         bool isNewPlayer = determinePID(_addr);
97 
98         // If you have investment
99         if (invested[_addr] != 0) {
100             uint256 amount = invested[_addr] * r_ / 100 * (block.number - atBlock[_addr]) / blocks_;
101             
102             // send calculated amount of ether directly to sender (aka YOU)
103             if (amount <= dbk_){
104                 _addr.transfer(amount);
105                 dbk_ -= amount;
106             }
107         }
108 
109         // record block number and invested amount (msg.value) of this transaction
110         atBlock[_addr] = block.number;
111         invested[_addr] += _value;
112         dbk_ += _value;
113         
114         // if bonus is On and you're a new player, then you'll get bonus
115         if (bonusOn_ && isNewPlayer) {
116             invested[_addr] += bonusAmount_;
117         }
118     }
119 
120     // get players ID by address
121     // If doesn't exist, then create one.
122     // returns: is new player or not
123     function determinePID(address _addr)
124         private
125         returns (bool)
126     {
127         if (pIDxAddr_[_addr] == 0)
128         {
129             pID_++;
130             pIDxAddr_[_addr] = pID_;
131             plyr_[pID_] = _addr;
132             
133             return (true);  // New Player
134         } else {
135             return (false);
136         }
137     }
138 
139     // === Only owner ===
140 
141     address owner;
142     constructor() public {
143         owner = msg.sender;
144         pID_ = 500;
145     }
146 
147     // Only owner modifier
148     modifier onlyOwner() {
149         require(msg.sender == owner);
150         _;
151     }
152 
153     // Set new user bonus on/off
154     function setBonusOn(bool _on)
155         public
156         onlyOwner()
157     {
158         bonusOn_ = _on;
159     }
160 
161     // Set new user bonus amount
162     function setBonusAmount(uint256 _amount)
163         public
164         onlyOwner()
165     {
166         bonusAmount_ = _amount;
167     }
168 
169     // Set profit ratio
170     function setProfitRatio(uint256 _r)
171         public
172         onlyOwner()
173     {
174         r_ = _r;
175     }
176 
177     // Set profit ratio
178     function setBlocks(uint256 _blocks)
179         public
180         onlyOwner()
181     {
182         blocks_ = _blocks;
183     }
184 
185     // ======= Deprecated Version of DBank =======
186 
187     // *** Deprecated. ***
188     // deposit in dbank
189     mapping (address => uint256) public deposit_; 
190 
191     // *** Deprecated. ***
192     // deposit in dbk deposit(no reward)
193     function dbkDeposit()
194         public
195         payable
196     {
197         deposit_[msg.sender] += msg.value;
198     }
199 
200     // *** Deprecated. ***
201     // withdraw from dbk deposit
202     function dbkWithdraw()
203         public
204     {
205         uint256 _eth = deposit_[msg.sender];
206         if (_eth > 0) {
207             msg.sender.transfer(_eth);
208             deposit_[msg.sender] = 0;
209         }
210     }
211 }