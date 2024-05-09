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
24     uint256 public costPerTicket = 75000000000000000;    // Init with 0.005 ETH per bet
25     uint256 public maxCost = 25000000000000000;         // Price increase every 7 days until 0.03 ETH
26     // test 2.0
27     uint256 constant public expireDate = 1543622400;    // Contract refused to get any more bets after Dec 1, 2018
28     // uint256 constant public expireDate = 1533027600;
29 
30     bool public confirmed;
31     bool public announced;
32     bool public gameOver;
33     bool public locked;
34     bool private developmentPaid;
35     uint private i;
36 
37     uint256 public startDate;
38     address public owner;
39     address public leader;
40     address public leader_2;
41     address public leader_3;
42     uint256 public announcedTimeStamp;
43     uint256 public rewardPool;
44     uint256 public confirmreward;               // Help us confirm when the man die and get a total of 5% ETH reward
45     uint256 public init_fund;
46 
47     uint256 public countConfirmed = 0;
48     uint256 public countPlayer = 0;
49     uint256 public countBet = 0 ;
50     uint256 public countWinners = 0;
51     uint256 public countSecondWinners = 0;
52 
53     uint256 public averageTimestamp;
54 
55     uint256 public numOfConfirmationNeeded;
56     uint256 private share = 0;
57 
58     uint256 public winnerTimestamp = 0;
59     uint256 public secondWinnerTimestamp =0;
60     uint256 countWeek;
61 
62 
63     constructor() payable public {
64         owner = 0xD29C684C272ca7BEb3B54Ed876acF8C784a84fD1;
65         leader = 0xD29C684C272ca7BEb3B54Ed876acF8C784a84fD1;
66         leader_2 = msg.sender;
67         leader_3 = 0xF06A984d59E64687a7Fd508554eB8763899366EE;
68         countWeek = 1;
69         numOfConfirmationNeeded =100;
70         startDate = now;
71         rewardPool = msg.value;
72         init_fund = msg.value;
73         announced = false;
74         confirmed = false;
75         gameOver = false;
76         locked = false;
77     }
78 
79     mapping(uint256 => address[]) mirrors ;
80 
81     uint256[] public timestampList;
82 
83 
84     mapping(address => bool) public isPlayer;
85     mapping(address => bool) public hasConfirmed;
86     mapping(address => uint256[]) public betHistory;
87     mapping(address => uint256) public playerBets;
88     mapping(address => address) public referral;
89     mapping(address => uint256) public countReferral;
90 
91 
92     event Bet(uint256 bets, address indexed player);
93     event Confirm(address player);
94     event Payreward(address indexed player, uint256 reward);
95 
96     function bet(uint256[] _timestamps, address _referral) payable public{
97         require(msg.value>=costPerTicket.mul(_timestamps.length));
98         require(!announced);
99 
100         if(now < expireDate){
101             for(i=0; i<_timestamps.length;i++){
102                 timestampList.push(_timestamps[i]);
103                 mirrors[_timestamps[i]].push(msg.sender);
104 
105                 betHistory[msg.sender].push(_timestamps[i]);
106 
107                 averageTimestamp = averageTimestamp.mul(countBet) + _timestamps[i];
108                 averageTimestamp = averageTimestamp.div(countBet+1);
109                 countBet ++;
110                 playerBets[msg.sender]++;
111             }
112 
113             if(isPlayer[msg.sender]!=true){
114                 countPlayer++;
115                 isPlayer[msg.sender]=true;
116                 referral[msg.sender]=_referral;
117                 countReferral[_referral]+=1;
118             }
119 
120             if(playerBets[msg.sender]>playerBets[leader] && msg.sender!=leader){
121                 if(msg.sender!=leader_2){
122                     leader_3 = leader_2;
123                 }
124                 leader_2 = leader;
125                 leader = msg.sender;
126             }else if(playerBets[msg.sender]>playerBets[leader_2] && msg.sender !=leader_2 && msg.sender != leader){
127                 leader_3 = leader_2;
128                 leader_2 = msg.sender;
129             }else if(playerBets[msg.sender]>playerBets[leader_3] && msg.sender !=leader_2 && msg.sender != leader && msg.sender != leader_3){
130                 leader_3 = msg.sender;
131             }
132 
133             rewardPool=rewardPool.add(msg.value);
134             owner.transfer(msg.value.mul(12).div(100)); // Developement Team get 12% on every transfer
135             emit Bet(_timestamps.length, msg.sender);
136         }else{
137             if(!locked){
138                 locked=true;
139             }
140             owner.transfer(msg.value);
141         }
142         // Increase Ticket Price every week
143         if(startDate.add(countWeek.mul(604800)) < now ){
144             countWeek++;
145             if(costPerTicket < maxCost){
146                 costPerTicket=costPerTicket.add(2500000000000000);
147             }
148         }
149     }
150 
151     function payLeaderAndDev() public {
152         require(locked || announced);
153         require(!developmentPaid);
154         // Send 12% of the original fund back to owner
155         owner.transfer(init_fund.mul(12).div(100));
156 
157         // Send 8% of all rewardPool to Leaderboard winners
158         leader.transfer(rewardPool.mul(4).div(100));
159         leader_2.transfer(rewardPool.mul(25).div(1000));
160         leader_3.transfer(rewardPool.mul(15).div(1000));
161         developmentPaid = true;
162     }
163 
164 
165     function getBetsOnTimestamp(uint256 _timestamp)public view returns (uint256){
166         return mirrors[_timestamp].length;
167     }
168 
169     function announce(uint256 _timestamp, uint256 _winnerTimestamp_1, uint256 _winnerTimestamp_2) public {
170         require(msg.sender == owner);
171         announced = true;
172 
173         announcedTimeStamp = _timestamp;
174         // Announce winners
175         winnerTimestamp = _winnerTimestamp_1;
176         secondWinnerTimestamp = _winnerTimestamp_2;
177 
178         countWinners = mirrors[winnerTimestamp].length;
179         countSecondWinners = mirrors[secondWinnerTimestamp].length;
180 
181         //5% of total rewardPool goes as confirmreward
182         confirmreward = rewardPool.mul(5).div(100).div(numOfConfirmationNeeded);
183     }
184 
185     function confirm() public{
186         require(announced==true);
187         require(confirmed==false);
188         require(isPlayer[msg.sender]==true);
189         require(hasConfirmed[msg.sender]!=true);
190 
191         countConfirmed += 1;
192         hasConfirmed[msg.sender] = true;
193 
194         msg.sender.transfer(confirmreward);
195         emit Confirm(msg.sender);
196         emit Payreward(msg.sender, confirmreward);
197 
198         if(countConfirmed>=numOfConfirmationNeeded){
199             confirmed=true;
200         }
201     }
202 
203     function payWinners() public{
204         require(confirmed);
205         require(!gameOver);
206         // Send ETH(50%) to first prize winners
207         share = rewardPool.div(2);
208         share = share.div(countWinners);
209         for(i=0; i<countWinners; i++){
210             mirrors[winnerTimestamp][i].transfer(share.mul(9).div(10));
211             referral[mirrors[winnerTimestamp][i]].transfer(share.mul(1).div(10));
212             emit Payreward(mirrors[winnerTimestamp][i], share);
213         }
214 
215         // Send ETH(25%) to second Winners
216         share = rewardPool.div(4);
217         share = share.div(countSecondWinners);
218         for(i=0; i<countSecondWinners; i++){
219             mirrors[secondWinnerTimestamp][i].transfer(share.mul(9).div(10));
220             referral[mirrors[secondWinnerTimestamp][i]].transfer(share.mul(1).div(10));
221             emit Payreward(mirrors[secondWinnerTimestamp][i], share);
222         }
223 
224         // Bye Guys
225         gameOver = true;
226     }
227 
228     function getBalance() public view returns (uint256){
229         return address(this).balance;
230     }
231 
232     function () public payable {
233          owner.transfer(msg.value);
234      }
235 }