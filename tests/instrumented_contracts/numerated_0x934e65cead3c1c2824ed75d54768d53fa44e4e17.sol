1 pragma solidity ^0.4.14;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5 
6     function balanceOf(address who) constant returns (uint256);
7 }
8 
9 contract Ownable {
10     address public owner;
11 
12     function Ownable() {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner {
22         require(newOwner != address(0));
23         owner = newOwner;
24     }
25 
26 }
27 
28 contract CryptoSlotsGame is Ownable {
29 
30     struct Win {
31     uint8 odds;
32     uint8 chance;
33     }
34 
35     ERC20Basic public token;
36 
37     mapping (address => uint) private investorToProfitDay;
38 
39     address private houseAddress;
40 
41     uint public lastInvestorsProfit = 0;
42 
43     uint public lastInvestorsProfitSum = 0;
44 
45     uint public lastInvestorsProfitDay = 0;
46 
47     uint public nextInvestorsProfitSum = 0;
48 
49     uint public houseFee = 100;
50 
51     uint public investorsFee = 100;
52 
53     uint public constant percentDivider = 10000;
54 
55     uint public minBet = 0.01 ether;
56 
57     uint public maxBet = 0.25 ether;
58 
59     uint private rnd = 8345634;
60 
61     uint private seed = 578340194;
62 
63     Win[] private winConfig;
64 
65     event LogBet(address indexed player, uint bet, uint win);
66 
67     event LogInvestorProfit(address indexed investor, uint value);
68 
69     event LogUpdateInvestorProfitSum(uint value);
70 
71 
72     function CryptoSlotsGame() {
73         houseAddress = msg.sender;
74         winConfig.push(Win(5, 10));
75         winConfig.push(Win(2, 30));
76     }
77 
78     function deleteContract() onlyOwner
79     {
80         selfdestruct(msg.sender);
81     }
82 
83     function changeWinConfig(uint8[] _winOdds, uint8[] _winChance) onlyOwner {
84         winConfig.length = _winOdds.length;
85         for (uint8 i = 0; i < winConfig.length; i++) {
86             winConfig[i].odds = _winOdds[i];
87             winConfig[i].chance = _winChance[i];
88         }
89     }
90 
91     function() payable {
92         bet();
93     }
94 
95     function bet() public payable returns (uint win) {
96         require(minBet <= msg.value && msg.value <= maxBet);
97 
98         updateProfit();
99 
100         uint playerWin = msg.value * odds(getRandom());
101 
102         if (playerWin > 0) {
103             if (playerWin > this.balance) playerWin = this.balance;
104             msg.sender.transfer(playerWin);
105             LogBet(msg.sender, msg.value, playerWin);
106         }
107         else {
108             playerWin = 1;
109             nextInvestorsProfitSum += msg.value * investorsFee / percentDivider;
110             msg.sender.transfer(playerWin);
111             LogBet(msg.sender, msg.value, playerWin);
112             houseAddress.transfer(msg.value * houseFee / percentDivider);
113         }
114         
115         return playerWin;
116     }
117 
118     function updateProfit() private {
119         uint today = now / 1 days;
120 
121         if (lastInvestorsProfitDay < today) {
122             lastInvestorsProfitDay = today;
123             lastInvestorsProfitSum = nextInvestorsProfitSum + lastInvestorsProfit;
124             lastInvestorsProfit = lastInvestorsProfitSum;
125 
126             LogUpdateInvestorProfitSum(lastInvestorsProfitSum);
127 
128             nextInvestorsProfitSum = 0;
129         }
130     }
131 
132     function getRandom() private returns (uint) {
133         rnd = (uint(sha3(block.blockhash(block.number - rnd), block.coinbase, block.timestamp, seed)) % 100);
134         return rnd;
135     }
136 
137     function setSeed(uint value) {
138         seed = value;
139     }
140 
141     function setMinBet(uint value) onlyOwner {
142         minBet = value;
143     }
144 
145     function setMaxBet(uint value) onlyOwner {
146         maxBet = value;
147     }
148 
149     function odds(uint value) private constant returns (uint8){
150         for (uint8 i = 0; i < winConfig.length; i++) {
151             if (value <= winConfig[i].chance) return winConfig[i].odds;
152         }
153         return 0;
154     }
155 
156     function getProfit() returns (uint) {
157         updateProfit();
158 
159         if (lastInvestorsProfit > 0 && investorToProfitDay[msg.sender] < lastInvestorsProfitDay) {
160             uint tokenBalance = token.balanceOf(msg.sender);
161             if (tokenBalance > 0) {
162                 uint profit = tokenBalance / token.totalSupply() * lastInvestorsProfitSum;
163                 msg.sender.transfer(profit);
164                 lastInvestorsProfit -= profit;
165                 investorToProfitDay[msg.sender] = lastInvestorsProfitDay;
166                 LogInvestorProfit(msg.sender, profit);
167                 return profit;
168             }
169         }
170         return 0;
171     }
172 
173     function setHouseFee(uint value) onlyOwner {
174         houseFee = value;
175     }
176 
177     function setInvestorsFee(uint value) onlyOwner {
178         investorsFee = value;
179     }
180 
181     function setHouseAddress(address value) onlyOwner {
182         houseAddress = value;
183     }
184 
185     function setToken(address value) onlyOwner {
186         token = ERC20Basic(value);
187     }
188 
189 }