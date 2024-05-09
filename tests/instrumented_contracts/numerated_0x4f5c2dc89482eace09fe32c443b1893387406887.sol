1 //etherate v.1.0
2 //https://etherate.org
3 //ETHERATE - BET and WIN ETH
4 /*
5 ╔═══╗╔════╗╔╗─╔╗╔═══╗╔═══╗╔═══╗╔════╗╔═══╗
6 ║╔══╝║╔╗╔╗║║║─║║║╔══╝║╔═╗║║╔═╗║║╔╗╔╗║║╔══╝
7 ║╚══╗╚╝║║╚╝║╚═╝║║╚══╗║╚═╝║║║─║║╚╝║║╚╝║╚══╗
8 ║╔══╝──║║──║╔═╗║║╔══╝║╔╗╔╝║╚═╝║──║║──║╔══╝
9 ║╚══╗──║║──║║─║║║╚══╗║║║╚╗║╔═╗║──║║──║╚══╗
10 ╚═══╝──╚╝──╚╝─╚╝╚═══╝╚╝╚═╝╚╝─╚╝──╚╝──╚═══╝
11 */
12 //69 84 72 69 82 65 84 69 
13 pragma solidity ^0.4.24;
14 contract Control
15 {
16     mapping(address => uint8) public agents;
17     modifier onlyADM()
18     {
19         require(agents[msg.sender] == 1);
20         _;
21     }
22     event ChangePermission(address indexed _called, address indexed _agent, uint8 _value);
23     function changePermission(address _agent, uint8 _value) public onlyADM()
24     {
25         require(msg.sender != _agent);
26         agents[_agent] = _value;
27         ChangePermission(msg.sender, _agent, _value);
28     }
29     bool public status;
30     event ChangeStatus(address indexed _called, bool _value);
31     function changeStatus(bool _value) public onlyADM()
32     {
33         status = _value;
34         ChangeStatus(msg.sender, _value);
35     }
36     modifier onlyRun()
37     {
38         require(status);
39         _;
40     }
41     event WithdrawWEI(address indexed _called, address indexed _to, uint256 _wei, uint8 indexed _type);
42     uint256 private totalDonateWEI;
43     event Donate(address indexed _from, uint256 _value);
44     function () payable //Thank you very much ;)
45     {
46         totalDonateWEI = totalDonateWEI + msg.value;
47         Donate(msg.sender, msg.value);
48     }
49     function getTotalDonateWEIInfo() public onlyADM() constant returns(uint256)
50     {
51         return totalDonateWEI;
52     }
53     function withdrawDonateWEI(address _to) public onlyADM()
54     {
55         _to.transfer(totalDonateWEI);
56         WithdrawWEI(msg.sender, _to, totalDonateWEI, 1);
57         totalDonateWEI = 0;
58     }
59     function Control()
60     {
61         agents[msg.sender] = 1;
62         status = true;
63     }
64 }
65 
66 contract Core is Control
67 {
68     ///RANDOM
69     function random(uint256 _min, uint256 _max) public constant returns(uint256)
70     {
71         return uint256(sha3(block.blockhash(block.number - 1))) % (_min + _max) - _min;
72 	}
73     ///*RANDOM
74     uint256 public betSizeFINNEY;
75     uint256 public totalBets;
76     uint256 public limitAgentBets;
77     uint256 public roundNum;
78     uint256 public betsNum;
79     uint256 public commissionPCT;
80     bool public commissionType;
81     uint256 private bankBalanceWEI;
82     uint256 private commissionBalanceWEI;
83     uint256 private overBalanceWEI;
84     uint256 public timeoutSEC;
85     uint256 public lastBetTimeSEC;
86     function getOverBalanceWEIInfo() public onlyADM() constant returns(uint256)
87     {
88         return overBalanceWEI;
89     }
90     function getBankBalanceWEIInfo() public onlyADM() constant returns(uint256)
91     {
92         return bankBalanceWEI;
93     }
94     function getCommissionBalanceWEIInfo() public onlyADM() constant returns(uint256)
95     {
96         return commissionBalanceWEI;
97     }
98     function withdrawOverBalanceWEI(address _to) public onlyADM()
99     {
100         _to.transfer(overBalanceWEI);
101         WithdrawWEI(msg.sender, _to, overBalanceWEI, 2);
102         overBalanceWEI = 0;
103     }
104     function withdrawCommissionBalanceWEI(address _to) public onlyADM()
105     {
106         _to.transfer(commissionBalanceWEI);
107         WithdrawWEI(msg.sender, _to, commissionBalanceWEI, 3);
108         commissionBalanceWEI = 0;
109     }
110     mapping(address => uint256) private agentAddressId;
111     address[] private agentIdAddress;
112     uint256[] private agentIdBetsSum;
113     uint256[] private agentIdBankBalanceWEI;
114     uint256[] private betsNumAgentId;
115     function getAgentId(address _agentAddress) public constant returns(uint256)
116     {
117         uint256 value;
118         uint256 id = agentAddressId[_agentAddress];
119         if (id != 0 && id <= agentIdAddress.length)
120         {
121             if (agentIdAddress[id - 1] == _agentAddress)
122             {
123                 value = agentAddressId[_agentAddress];
124             }
125         }
126         return value;
127     }
128     function getAgentAdress(uint256 _agentId) public constant returns(address)
129     {
130         address value;
131         if (_agentId > 0 && _agentId <= agentIdAddress.length)
132         {
133             value = agentIdAddress[_agentId - 1];
134         }
135         return value;
136     }
137     function getAgentBetsSum(uint256 _agentId) public constant returns(uint256)
138     {
139         uint256 value;
140         if (_agentId > 0 && _agentId <= agentIdBetsSum.length)
141         {
142             value = agentIdBetsSum[_agentId - 1];
143         }
144         return value;
145     }
146     function getAgentBankBalanceWEI(uint256 _agentId) public constant returns(uint256)
147     {
148         uint256 value;
149         if (_agentId > 0 && _agentId <= agentIdBankBalanceWEI.length)
150         {
151             value = agentIdBankBalanceWEI[_agentId - 1];
152         }
153         return value;
154     }
155     function getPositionBetAgent(uint256 _positionBet) public constant returns(uint256)
156     {
157         uint256 value;
158         if (_positionBet > 0 && _positionBet <= betsNumAgentId.length)
159         {
160             value = betsNumAgentId[_positionBet - 1];
161         }
162         return value;
163     }
164     function getAgentsNum() public constant returns(uint256)
165     {
166         return agentIdAddress.length;
167     }
168     function Core()
169     {
170         roundNum = 1;
171     }
172     event ChangeGameSettings(address indexed _called, uint256 _betSizeFINNEY, uint256 _totalBets, uint256 _limitAgentBets, uint256 _commissionPCT, bool _commissionType, uint256 _timeoutSEC);
173     function changeGameSettings(uint256 _betSizeFINNEY, uint256 _totalBets, uint256 _limitAgentBets, uint256 _commissionPCT, bool _commissionType, uint256 _timeoutSEC) public onlyADM()
174     {
175         require(betsNum == 0);
176         require(_limitAgentBets < _totalBets);
177         require(_commissionPCT < 100);
178         betSizeFINNEY = _betSizeFINNEY;
179         totalBets = _totalBets;
180         limitAgentBets = _limitAgentBets;
181         commissionPCT = _commissionPCT;
182         commissionType = _commissionType;
183         timeoutSEC = _timeoutSEC;
184         ChangeGameSettings(msg.sender, _betSizeFINNEY, _totalBets, _limitAgentBets, _commissionPCT, _commissionType, _timeoutSEC);
185     }
186     event Bet(address indexed _agent, uint256 _agentId, uint256 _round, uint256 _bets, uint256 _WEI);
187     event Winner(address indexed _agent, uint256 _agentId, uint256 _round, uint256 _betsSum, uint256 _depositWEI, uint256 _winWEI, uint256 _luckyNumber);
188     function bet() payable public onlyRun() //BET AND WIN
189     {
190         require(msg.value > 0);
191         uint256 agentID;
192         agentID = getAgentId(msg.sender);
193         if (agentID == 0)
194         {
195             agentIdAddress.push(msg.sender);
196             agentID = agentIdAddress.length;
197             agentAddressId[msg.sender] = agentID;
198             agentIdBetsSum.push(0);
199             agentIdBankBalanceWEI.push(0);
200         }
201         bankBalanceWEI = bankBalanceWEI + msg.value;
202         agentIdBankBalanceWEI[agentID - 1] = getAgentBankBalanceWEI(agentID) + msg.value;
203         uint256 agentTotalBets = (getAgentBankBalanceWEI(agentID)/1000000000000000)/betSizeFINNEY;
204         uint256 agentAmountBets = agentTotalBets - getAgentBetsSum(agentID);
205         if (agentAmountBets > 0)
206         {
207             if ((agentAmountBets + getAgentBetsSum(agentID) + betsNum) > totalBets)
208             {
209                 agentAmountBets = 
210                 totalBets - betsNum;
211             }
212             if ((agentAmountBets + getAgentBetsSum(agentID)) > limitAgentBets)
213             {
214                 agentAmountBets = 
215                 limitAgentBets - getAgentBetsSum(agentID);   
216             }
217             
218             agentIdBetsSum[agentID - 1] = getAgentBetsSum(agentID) + agentAmountBets;
219             
220             while (betsNumAgentId.length < betsNum + agentAmountBets)
221             {
222                 betsNumAgentId.push(agentID);
223             }
224             
225             betsNum = betsNum + agentAmountBets;
226             
227             Bet(msg.sender, agentID, roundNum, agentAmountBets, msg.value);
228         }
229         lastBetTimeSEC = block.timestamp;
230         if (betsNum == totalBets)
231         {
232             _play();
233         }
234     }
235     function playForcibly() public onlyRun() onlyADM()
236     {
237         require(block.timestamp + timeoutSEC > lastBetTimeSEC);
238         _play();
239     }
240     function _play() private
241     {
242         uint256 luckyNumber = random(1, betsNum);
243         uint256 winnerID = betsNumAgentId[luckyNumber - 1];
244         address winnerAddress = getAgentAdress(winnerID);
245         uint256 jackpotBankWEI = betsNum * betSizeFINNEY * 1000000000000000;
246         uint256 overWEI = bankBalanceWEI - jackpotBankWEI;
247         uint256 commissionWEI;
248         if (commissionType)
249         {
250             commissionWEI = (jackpotBankWEI/100) * commissionPCT;
251         }
252         else
253         {
254             commissionWEI = (betsNum - getAgentBetsSum(winnerID)) * (betSizeFINNEY * 1000000000000000) / 100 * commissionPCT;
255         }
256         winnerAddress.transfer(jackpotBankWEI - commissionWEI);
257         commissionBalanceWEI = commissionBalanceWEI + commissionWEI;
258         overBalanceWEI = overBalanceWEI + overWEI;
259         Winner(winnerAddress, winnerID, roundNum, getAgentBetsSum(winnerID), getAgentBankBalanceWEI(winnerID), jackpotBankWEI - commissionWEI, luckyNumber);
260         bankBalanceWEI = 0;
261         betsNum = 0;
262         roundNum++;
263         delete agentIdAddress;
264         delete agentIdBetsSum;
265         delete agentIdBankBalanceWEI;
266         delete betsNumAgentId;
267     }
268 }
269 //https://etherate.org
270 //Blog (Medium): https://medium.com/etherate
271 //Reddit: https://www.reddit.com/r/EtheRate
272 //Twitter: https://twitter.com/etherate_org
273 //Facebook: https://www.facebook.com/etherate
274 //Instagram: https://www.instagram.com/etherate_org
275 //Telegram: https://t.me/etherate