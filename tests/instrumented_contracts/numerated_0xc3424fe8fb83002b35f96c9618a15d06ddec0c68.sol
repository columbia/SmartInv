1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 }
19 
20 //-----------------------------------------------------------------------
21 contract ETHButton {
22     using SafeMath for uint256;
23     
24     address private owner;
25     
26     // game data
27     uint256 private constant CLICKERS_SIZE = 30;
28     uint256 private constant EXPIRE_DELAY = 3600;
29     address[CLICKERS_SIZE] private clickers;
30     uint256 private clickPrice;
31     uint256 private clikerIndex;
32     uint256 private expireTime;
33     uint256 private totalPot;
34     uint256 private devFund;
35     
36     // statistics
37     mapping(address=>uint256) private playerClickCount;
38     mapping(address=>uint256) private playerSecToTimeout;
39     uint256 private totalClicks;
40     
41     // index to address mapping
42     mapping(uint256=>address) private playerIndexes;
43     uint256 private totalPlayers;
44     
45     // referal system
46     mapping(address=>uint256) private playerReferedByCount;
47     mapping(address=>uint256) private playerReferedMoneyGain;
48     
49     // ------------------------------------------------------------------------
50     // Constructor
51     // ------------------------------------------------------------------------
52     function ETHButton() public {
53         owner = msg.sender;
54    
55         clickPrice = 0.01 ether;
56         
57         expireTime = block.timestamp + 360000;
58         
59         totalPot = 0;
60         devFund = 0;
61         clikerIndex = 0;
62         totalPlayers = 0;
63     }
64     
65     //--------------------------------------------------------------------------
66     // GET functions 
67     //--------------------------------------------------------------------------
68     function GetTotalPlayers() external view returns(uint256)
69     {
70         return totalPlayers;
71     }
72     
73     function GetTotalClicks() external view returns(uint256)
74     {
75         return totalClicks;
76     }
77     
78     function GetTotalPot() external view returns(uint256)
79     {
80         return totalPot;
81     }
82     
83     function GetExpireTime() external view returns(uint256)
84     {
85         return expireTime;
86     }
87     
88     function GetClickPrice() external view returns(uint256)
89     {
90         return clickPrice;
91     }
92     
93     function GetPlayerAt(uint256 idx) external view returns (address)
94     {
95         require(idx < totalPlayers);
96         
97         return playerIndexes[idx];
98     }
99     
100     function GetPlayerDataAt(address player) external view returns(uint256 _playerClickCount, uint256 _playerSecToTimeout, 
101     uint256 _referCount, uint256 _referalRevenue)
102     {
103         _playerClickCount = playerClickCount[player];
104         _playerSecToTimeout = playerSecToTimeout[player];
105         _referCount = playerReferedByCount[player];
106         _referalRevenue = playerReferedMoneyGain[player];
107     }
108     
109     function GetWinnerAt(uint256 idx) external view returns (address _addr)
110     {
111         require(idx < CLICKERS_SIZE);
112         
113         if(idx < clikerIndex)
114             _addr = clickers[clikerIndex-(idx+1)];
115         else
116             _addr = clickers[(clikerIndex + CLICKERS_SIZE) - (idx+1)];
117     }
118     
119     function GetWinners() external view returns (address[CLICKERS_SIZE] _addr)
120     {
121         for(uint256 idx = 0; idx < CLICKERS_SIZE; ++idx)
122         {
123             if(idx < clikerIndex)
124                 _addr[idx] = clickers[clikerIndex-(idx+1)];
125             else
126                 _addr[idx] = clickers[(clikerIndex + CLICKERS_SIZE) - (idx+1)];
127         }
128     }
129     
130     //--------------------------------------------------------------------------
131     // Game Mechanics
132     //--------------------------------------------------------------------------
133     function ButtonClicked(address referee) external payable
134     {
135         require(msg.value >= clickPrice);
136         require(expireTime >= block.timestamp);
137         require(referee != msg.sender);
138         
139         if(playerClickCount[msg.sender] == 0)
140         {
141             playerIndexes[totalPlayers] = msg.sender;
142             totalPlayers += 1;
143         }
144         
145         totalClicks += 1;
146         playerClickCount[msg.sender] += 1;
147         if(playerSecToTimeout[msg.sender] == 0 || playerSecToTimeout[msg.sender] > (expireTime - block.timestamp))
148             playerSecToTimeout[msg.sender] = expireTime - block.timestamp;
149         
150         expireTime = block.timestamp + EXPIRE_DELAY;
151         
152         address refAddr = referee;
153         
154         // a player who never played cannot be referenced
155         if(refAddr == 0 || playerClickCount[referee] == 0)
156             refAddr = owner;
157             
158         if(totalClicks > CLICKERS_SIZE)
159         {
160             totalPot = totalPot.add(((msg.value.mul(8)) / 10));
161             
162             uint256 fee = msg.value / 10;
163             devFund += fee;
164             
165             // don't try to hack the system with invalid addresses...
166             if(!refAddr.send(fee))
167             {
168                 // if I write "totalPot" here everybody will exploit 
169                 // the referal system with invalid address
170                 devFund += fee;
171             } else
172             {
173                 playerReferedByCount[refAddr] += 1;
174                 playerReferedMoneyGain[refAddr] += fee;
175             }
176         } else
177         {
178             // until CLICKERS_SIZE total clicks don't take dev funds, so the first clikcers
179             // don't risk 20% negative interest
180             totalPot += msg.value;
181         }
182         
183         clickers[clikerIndex] = msg.sender;
184         clikerIndex += 1;
185        
186         if(clikerIndex >= CLICKERS_SIZE)
187         {
188             clickPrice += 0.01 ether;
189             clikerIndex = 0;
190         }
191     }
192     
193     function DistributeButtonIncome() external
194     {
195         require(expireTime < block.timestamp);
196         require(totalPot > 0);
197         
198         uint256 reward = totalPot / CLICKERS_SIZE;
199         
200         for(uint256 i = 0; i < CLICKERS_SIZE; ++i)
201         {
202             if(!clickers[i].send(reward))
203             {
204                 // oops
205             }
206         }
207         
208         totalPot = 0;
209     }
210     //--------------------------------------------------------------------------
211     // Funds menagement
212     //--------------------------------------------------------------------------
213     function WithdrawDevFunds() external
214     {
215         require(msg.sender == owner);
216 
217         if(owner.send(devFund))
218         {
219             devFund = 0;
220         }
221     }
222 }