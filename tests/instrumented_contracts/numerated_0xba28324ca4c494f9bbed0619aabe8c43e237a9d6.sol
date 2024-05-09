1 pragma solidity ^0.4.24;
2 
3 contract Magic10 {
4     
5     // Timer of percentage increasing 
6 	uint256 public periodLength = 7 days;
7 	
8 	// We need to work with fractional percents like 0.7%, so we need to devide by 1000 before multiply the number
9 	// Each variable which calculated with this value has a prefix Decimal
10 	uint256 public percentDecimals = 3;
11 	
12 	// Percents calculation using percentDecimals 2% = 20
13 	uint256 public startDecimalPercent = 20;
14 
15     // Additional percent for completed period is 0.3% = 3
16 	uint256 public bonusDecimalPercentByPeriod = 3; 
17 	
18 	// Maximal percent is 5% = 50
19 	uint256 public maximalDecimalPercent = 50;
20 
21     // Structure of deposit
22 	struct Deposit {
23 	    address owner;
24         uint256 amount;
25         uint64 timeFrom;
26     }
27     
28     // Notice, start index for all deposits is 1.
29     // List of all deposits
30     mapping(uint64 => Deposit) public deposits;
31     
32     // List of all deposits by each investor
33     // Implemented to enable quick access to investor deposits even without server caching
34     mapping(address => mapping(uint64 => uint64)) public investorsToDeposit;
35     
36     // Count of deposits by each investor
37     mapping(address => uint16) public depositsByInvestor;
38     
39     // List of registered referrals
40     mapping(address => bool) public referralList;
41     
42     // Total number of deposits
43     uint64 public depositsCount = 0;
44     
45     
46     // Create a new deposit
47     function createDeposit(address _referral) external payable {
48         
49         // Minimal deposit is 1 finney
50         require(msg.value >= 1 finney);
51         
52         // Create a deposit object
53         Deposit memory _deposit = Deposit({
54             owner: msg.sender,
55             amount: msg.value,
56             timeFrom: uint64(now)
57         });
58         
59         //
60         // Calculating IDS
61         //
62         
63         // New deposit ID equals to current deposits count + 1
64         uint64 depositId = depositsCount+1;
65         
66         // new deposit ID for investor equals current count + 1
67         uint64 depositIdByInvestor = depositsByInvestor[msg.sender] + 1;
68         
69         //
70         // Saving data
71         //
72         
73         // Saving deposit into current ID
74         deposits[depositId] = _deposit;
75         
76         // Adding deposit ID into list of deposits for current investor
77         investorsToDeposit[msg.sender][depositIdByInvestor] = depositId;
78         
79         //
80         // Counters incrementing    
81         //
82         
83         // Increment count of deposits for current investor
84         depositsByInvestor[msg.sender]++;
85         
86         // Increment global count of deposits
87         depositsCount++;
88         
89         //
90         // Additional sendings - 5% to company and 1-5% to referrals
91         //
92         
93         address company = 0xFd40fE6D5d31c6A523F89e3Af05bb3457B5EAD0F;
94         
95         // 5% goes to the company budget
96         company.transfer(msg.value / 20);
97         
98         // Referral percent
99         uint8 refferalPercent = currentReferralPercent();
100         
101         // Referral receive reward according current reward percent if he is in list.
102         if(referralList[_referral] && _referral != msg.sender) {
103             _referral.transfer(msg.value * refferalPercent/ 100);
104         }
105     }
106     
107     // Function for withdraw
108     function withdrawPercents(uint64 _depositId) external {
109         
110         // Get deposit information
111         Deposit memory deposit = deposits[_depositId];
112         
113         // Available for deposit owner only
114         require(deposit.owner == msg.sender);
115         
116         // Get reward amount by public function currentReward
117         uint256 reward = currentReward(_depositId);
118         
119         // Refresh deposit time and save it
120         deposit.timeFrom = uint64(now);
121         deposits[_depositId] = deposit;
122         
123         // Transfer reward to investor
124         deposit.owner.transfer(reward);
125     }
126 
127     // Referal registration
128     function registerReferral(address _refferal) external {
129         // Available from this address only 
130         require(msg.sender == 0x21b4d32e6875a6c2e44032da71a33438bbae8820);
131         
132         referralList[_refferal] = true;
133     }
134     
135     //
136     //
137     //
138     // Information functions
139     //
140     //
141     //
142     
143     // Calcaulating current reward by deposit ID
144     function currentReward(uint64 _depositId)
145         view 
146         public 
147         returns(uint256 amount) 
148     {
149         // Get information about deposit
150         Deposit memory deposit = deposits[_depositId];
151         
152         // Bug protection with "now" time
153         if(deposit.timeFrom > now)
154             return 0;
155         
156         // Get current deposit percent using public function rewardDecimalPercentByTime
157         uint16 dayDecimalPercent = rewardDecimalPercentByTime(deposit.timeFrom);
158         
159         // Calculating reward for each day
160         uint256 amountByDay = ( deposit.amount * dayDecimalPercent / 10**percentDecimals ) ;
161         
162         // Calculate time from the start of the deposit to current time in minutes
163         uint256 minutesPassed = (now - deposit.timeFrom) / 60;
164         amount = amountByDay * minutesPassed / 1440;
165     }
166     
167     // Calculate reward percent by timestamp of creation
168     function rewardDecimalPercentByTime(uint256 _timeFrom) 
169         view 
170         public 
171         returns(uint16 decimalPercent) 
172     {
173         // Returning start percent, if sending timestamp from the future
174         if(_timeFrom >= now)
175             return uint16(startDecimalPercent);
176             
177         // Main calculating
178         decimalPercent = uint16(startDecimalPercent +  (( (now - _timeFrom) / periodLength ) * bonusDecimalPercentByPeriod));
179         
180         // Returning the maximum percentage if the percentage is higher than the maximum
181         if(decimalPercent > maximalDecimalPercent)
182             return uint16(maximalDecimalPercent);
183     }
184     
185     // Referral percent calculating by contract balance
186     function currentReferralPercent() 
187         view 
188         public 
189         returns(uint8 percent) 
190     {
191         if(address(this).balance > 10000 ether)
192             return 1;
193             
194         if(address(this).balance > 1000 ether)
195             return 2;
196             
197         if(address(this).balance > 100 ether)
198             return 3;
199             
200         if(address(this).balance > 10 ether)
201             return 4;
202         
203         return 5;
204     }
205 }