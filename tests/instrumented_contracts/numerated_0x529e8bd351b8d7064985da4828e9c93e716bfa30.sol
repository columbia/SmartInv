1 pragma solidity 0.5.6;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner, "");
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0), "");
17         owner = newOwner;
18     }
19 
20 }
21 
22 
23 // Developer @gogol
24 // Design @chechenets
25 // Architect @tugush
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "");
36 
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
42         uint256 c = a / b;
43 
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b <= a, "");
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "");
57 
58         return c;
59     }
60 
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "");
63         return a % b;
64     }
65 }
66 
67 
68 // Developer @gogol
69 // Design @chechenets
70 // Architect @tugush
71 
72 contract iBaseGame {
73     function getPeriod() public view returns (uint);
74     function startGame(uint _startPeriod) public payable;
75     function setTicketPrice(uint _ticketPrice) public;
76 }
77 
78 
79 contract Management is Ownable {
80     using SafeMath for uint;
81 
82     uint constant public BET_PRICE = 10000000000000000;                     //0.01 eth in wei
83     uint constant public HOURLY_GAME_SHARE = 30;                         //30% to hourly game
84     uint constant public DAILY_GAME_SHARE = 10;                          //10% to daily game
85     uint constant public WEEKLY_GAME_SHARE = 5;                          //5% to weekly game
86     uint constant public MONTHLY_GAME_SHARE = 5;                         //5% to monthly game
87     uint constant public YEARLY_GAME_SHARE = 5;                          //5% to yearly game
88     uint constant public JACKPOT_GAME_SHARE = 10;                        //10% to jackpot game
89     uint constant public SUPER_JACKPOT_GAME_SHARE = 15;                  //15% to superJackpot game
90     uint constant public SHARE_DENOMINATOR = 100;                           //denominator for share
91     uint constant public ORACLIZE_TIMEOUT = 86400;
92     uint constant public N_Y = 1514764800;                                  // 01.01.2018 00:00:00 Monday
93 
94 
95     iBaseGame public hourlyGame;
96     iBaseGame public dailyGame;
97     iBaseGame public weeklyGame;
98     iBaseGame public monthlyGame;
99     iBaseGame public yearlyGame;
100     iBaseGame public jackPot;
101     iBaseGame public superJackPot;
102 
103 //    //uint public start = 1546300800; // 01.01.2019 00:00:00
104 //    uint public start = now;
105 
106     constructor (
107         address _hourlyGame,
108         address _dailyGame,
109         address _weeklyGame,
110         address _monthlyGame,
111         address _yearlyGame,
112         address _jackPot,
113         address _superJackPot
114     )
115         public
116     {
117         require(_hourlyGame != address(0), "");
118         require(_dailyGame != address(0), "");
119         require(_weeklyGame != address(0), "");
120         require(_monthlyGame != address(0), "");
121         require(_yearlyGame != address(0), "");
122         require(_jackPot != address(0), "");
123         require(_superJackPot != address(0), "");
124 
125         hourlyGame = iBaseGame(_hourlyGame);
126         dailyGame = iBaseGame(_dailyGame);
127         weeklyGame = iBaseGame(_weeklyGame);
128         monthlyGame = iBaseGame(_monthlyGame);
129         yearlyGame = iBaseGame(_yearlyGame);
130         jackPot = iBaseGame(_jackPot);
131         superJackPot = iBaseGame(_superJackPot);
132     }
133 
134     function startGames() public payable onlyOwner {
135 
136         hourlyGame.setTicketPrice(BET_PRICE.mul(HOURLY_GAME_SHARE).div(SHARE_DENOMINATOR));
137         dailyGame.setTicketPrice(BET_PRICE.mul(DAILY_GAME_SHARE).div(SHARE_DENOMINATOR));
138         weeklyGame.setTicketPrice(BET_PRICE.mul(WEEKLY_GAME_SHARE).div(SHARE_DENOMINATOR));
139         monthlyGame.setTicketPrice(BET_PRICE.mul(MONTHLY_GAME_SHARE).div(SHARE_DENOMINATOR));
140         yearlyGame.setTicketPrice(BET_PRICE.mul(YEARLY_GAME_SHARE).div(SHARE_DENOMINATOR));
141         jackPot.setTicketPrice(BET_PRICE.mul(JACKPOT_GAME_SHARE).div(SHARE_DENOMINATOR));
142         superJackPot.setTicketPrice(BET_PRICE.mul(SUPER_JACKPOT_GAME_SHARE).div(SHARE_DENOMINATOR));
143 
144         uint hourlyPeriod = hourlyGame.getPeriod();
145         uint dailyPeriod = dailyGame.getPeriod();
146         uint weeklyPeriod = weeklyGame.getPeriod();
147         uint monthlyPeriod = monthlyGame.getPeriod();
148         uint yearlyPeriod = yearlyGame.getPeriod();
149 
150         hourlyGame.startGame.value(msg.value/7)(hourlyPeriod.sub((now.sub(N_Y)) % hourlyPeriod));
151         dailyGame.startGame.value(msg.value/7)(dailyPeriod.sub((now.sub(N_Y)) % dailyPeriod));
152         weeklyGame.startGame.value(msg.value/7)(weeklyPeriod.sub((now.sub(N_Y)) % weeklyPeriod));
153         monthlyGame.startGame.value(msg.value/7)(monthlyPeriod.sub((now.sub(N_Y)) % monthlyPeriod));
154         yearlyGame.startGame.value(msg.value/7)(yearlyPeriod.sub((now.sub(N_Y)) % yearlyPeriod));
155         jackPot.startGame.value(msg.value/7)(ORACLIZE_TIMEOUT);
156         superJackPot.startGame.value(msg.value/7)(ORACLIZE_TIMEOUT);
157     }
158 }
159 
160 
161 // Developer @gogol
162 // Design @chechenets
163 // Architect @tugush