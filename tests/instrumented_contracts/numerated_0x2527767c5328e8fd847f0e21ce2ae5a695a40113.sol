1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b <= a); return a - b;}
14   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 }
20 
21 contract BlackChain {
22     using SafeMath for uint256;
23 
24     uint256 public costPerTicket = 7500000000000000;    // Init with 0.0075 ETH per bet
25     uint256 public maxCost = 25000000000000000;         // Price increase every 7 days until 0.025 ETH
26     uint256 constant public expireDate = 1543622400;    // Contract refused to get any more bets after Dec 1, 2018
27 
28     bool public confirmed;
29     bool public announced;
30     bool public gameOver;
31     bool public locked;
32     bool private developmentPaid;
33     uint private i;
34 
35     uint256 public startDate;
36     address public owner;
37     address public leader;
38     address public leader_2;
39     address public leader_3;
40     uint256 public announcedTimeStamp;
41     uint256 public rewardPool;
42     uint256 public confirmreward;               // Help us confirm when the man die and get a total of 5% ETH reward
43     uint256 public init_fund;
44 
45     uint256 public countConfirmed = 0;
46     uint256 public countPlayer = 0;
47     uint256 public countBet = 0 ;
48     uint256 public countWinners = 0;
49     uint256 public countSecondWinners = 0;
50 
51     uint256 public averageTimestamp;
52 
53     uint256 public numOfConfirmationNeeded;
54     uint256 private share = 0;
55 
56     uint256 public winnerTimestamp = 0;
57     uint256 public secondWinnerTimestamp =0;
58     uint256 countWeek;
59 
60 
61     constructor() payable public {
62         owner = 0xD29C684C272ca7BEb3B54Ed876acF8C784a84fD1;
63         leader = 0xD29C684C272ca7BEb3B54Ed876acF8C784a84fD1;
64         leader_2 = msg.sender;
65         leader_3 = 0xF06A984d59E64687a7Fd508554eB8763899366EE;
66         countWeek = 1;
67         numOfConfirmationNeeded =100;
68         startDate = now;
69         rewardPool = msg.value;
70         init_fund = msg.value;
71         announced = false;
72         confirmed = false;
73         gameOver = false;
74         locked = false;
75     }
76 
77     mapping(uint256 => address[]) mirrors ;
78 
79     uint256[] public timestampList;
80 
81 
82     mapping(address => bool) public isPlayer;
83     mapping(address => bool) public hasConfirmed;
84     mapping(address => uint256[]) public betHistory;
85     mapping(address => uint256) public playerBets;
86     mapping(address => address) public referral;
87     mapping(address => uint256) public countReferral;
88 
89 
90     event Bet(uint256 bets, address indexed player);
91     event Confirm(address player);
92     event Payreward(address indexed player, uint256 reward);
93 
94     function bet(uint256[] _timestamps, address _referral) payable public{
95         require(msg.value>=costPerTicket.mul(_timestamps.length));
96         require(!announced);
97 
98         if(now < expireDate){
99             for(i=0; i<_timestamps.length;i++){
100                 timestampList.push(_timestamps[i]);
101                 mirrors[_timestamps[i]].push(msg.sender);
102 
103                 betHistory[msg.sender].push(_timestamps[i]);
104 
105                 averageTimestamp = averageTimestamp.mul(countBet) + _timestamps[i];
106                 averageTimestamp = averageTimestamp.div(countBet+1);
107                 countBet ++;
108                 playerBets[msg.sender]++;
109             }
110 
111             if(isPlayer[msg.sender]!=true){
112                 countPlayer++;
113                 isPlayer[msg.sender]=true;
114                 referral[msg.sender]=_referral;
115                 countReferral[_referral]+=1;
116             }
117 
118             if(playerBets[msg.sender]>playerBets[leader] && msg.sender!=leader){
119                 if(msg.sender!=leader_2){
120                     leader_3 = leader_2;
121                 }
122                 leader_2 = leader;
123                 leader = msg.sender;
124             }else if(playerBets[msg.sender]>playerBets[leader_2] && msg.sender !=leader_2 && msg.sender != leader){
125                 leader_3 = leader_2;
126                 leader_2 = msg.sender;
127             }else if(playerBets[msg.sender]>playerBets[leader_3] && msg.sender !=leader_2 && msg.sender != leader && msg.sender != leader_3){
128                 leader_3 = msg.sender;
129             }
130 
131             rewardPool=rewardPool.add(msg.value);
132             owner.transfer(msg.value.mul(12).div(100)); // Developement Team get 12% on every transfer
133             emit Bet(_timestamps.length, msg.sender);
134         }else{
135             if(!locked){
136                 locked=true;
137             }
138             owner.transfer(msg.value);
139         }
140         // Increase Ticket Price every week
141         if(startDate.add(countWeek.mul(604800)) < now ){
142             countWeek++;
143             if(costPerTicket < maxCost){
144                 costPerTicket=costPerTicket.add(2500000000000000);
145             }
146         }
147     }
148 
149     function payLeaderAndDev() public {
150         require(locked || announced);
151         require(!developmentPaid);
152         // Send 12% of the original fund back to owner
153         owner.transfer(init_fund.mul(12).div(100));
154 
155         // Send 8% of all rewardPool to Leaderboard winners
156         leader.transfer(rewardPool.mul(4).div(100));
157         leader_2.transfer(rewardPool.mul(25).div(1000));
158         leader_3.transfer(rewardPool.mul(15).div(1000));
159         developmentPaid = true;
160     }
161 
162 
163     function getBetsOnTimestamp(uint256 _timestamp)public view returns (uint256){
164         return mirrors[_timestamp].length;
165     }
166 
167     function announce(uint256 _timestamp, uint256 _winnerTimestamp_1, uint256 _winnerTimestamp_2) public {
168         require(msg.sender == owner);
169         announced = true;
170 
171         announcedTimeStamp = _timestamp;
172         // Announce winners
173         winnerTimestamp = _winnerTimestamp_1;
174         secondWinnerTimestamp = _winnerTimestamp_2;
175 
176         countWinners = mirrors[winnerTimestamp].length;
177         countSecondWinners = mirrors[secondWinnerTimestamp].length;
178 
179         //5% of total rewardPool goes as confirmreward
180         confirmreward = rewardPool.mul(5).div(100).div(numOfConfirmationNeeded);
181     }
182 
183     function confirm() public{
184         require(announced==true);
185         require(confirmed==false);
186         require(isPlayer[msg.sender]==true);
187         require(hasConfirmed[msg.sender]!=true);
188 
189         countConfirmed += 1;
190         hasConfirmed[msg.sender] = true;
191 
192         msg.sender.transfer(confirmreward);
193         emit Confirm(msg.sender);
194         emit Payreward(msg.sender, confirmreward);
195 
196         if(countConfirmed>=numOfConfirmationNeeded){
197             confirmed=true;
198         }
199     }
200 
201     function payWinners() public{
202         require(confirmed);
203         require(!gameOver);
204         // Send ETH(50%) to first prize winners
205         share = rewardPool.div(2);
206         share = share.div(countWinners);
207         for(i=0; i<countWinners; i++){
208             mirrors[winnerTimestamp][i].transfer(share.mul(9).div(10));
209             referral[mirrors[winnerTimestamp][i]].transfer(share.mul(1).div(10));
210             emit Payreward(mirrors[winnerTimestamp][i], share);
211         }
212 
213         // Send ETH(25%) to second Winners
214         share = rewardPool.div(4);
215         share = share.div(countSecondWinners);
216         for(i=0; i<countSecondWinners; i++){
217             mirrors[secondWinnerTimestamp][i].transfer(share.mul(9).div(10));
218             referral[mirrors[secondWinnerTimestamp][i]].transfer(share.mul(1).div(10));
219             emit Payreward(mirrors[secondWinnerTimestamp][i], share);
220         }
221 
222         // Bye Guys
223         gameOver = true;
224     }
225 
226     function getBalance() public view returns (uint256){
227         return address(this).balance;
228     }
229 
230     function () public payable {
231          owner.transfer(msg.value);
232      }
233 }