1 pragma solidity 0.5.2;
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
22 library SafeMath {
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "");
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
37         uint256 c = a / b;
38 
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "");
52 
53         return c;
54     }
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0, "");
58         return a % b;
59     }
60 }
61 
62 
63 contract iBaseLottery {
64     function getPeriod() public view returns (uint);
65     function startLottery(uint _startPeriod) public payable;
66     function setTicketPrice(uint _ticketPrice) public;
67 }
68 
69 
70 contract Management is Ownable {
71     using SafeMath for uint;
72 
73     uint constant public BET_PRICE = 10000000000000000;                     // 0.01 eth in wei
74     uint constant public HOURLY_LOTTERY_SHARE = 30;                         // 30% to hourly lottery
75     uint constant public DAILY_LOTTERY_SHARE = 10;                          // 10% to daily lottery
76     uint constant public WEEKLY_LOTTERY_SHARE = 5;                          // 5% to weekly lottery
77     uint constant public MONTHLY_LOTTERY_SHARE = 5;                         // 5% to monthly lottery
78     uint constant public YEARLY_LOTTERY_SHARE = 5;                          // 5% to yearly lottery
79     uint constant public JACKPOT_LOTTERY_SHARE = 10;                        // 10% to jackpot lottery
80     uint constant public SUPER_JACKPOT_LOTTERY_SHARE = 15;                  // 15% to superJackpot lottery
81     uint constant public SHARE_DENOMINATOR = 100;                           // denominator for share
82     uint constant public ORACLIZE_TIMEOUT = 86400;
83 
84     iBaseLottery public mainLottery;
85     iBaseLottery public dailyLottery;
86     iBaseLottery public weeklyLottery;
87     iBaseLottery public monthlyLottery;
88     iBaseLottery public yearlyLottery;
89     iBaseLottery public jackPot;
90     iBaseLottery public superJackPot;
91 
92     uint public start = 1553472000;     // Monday, 25-Mar-19 00:00:00 UTC
93 
94     constructor (
95         address _mainLottery,
96         address _dailyLottery,
97         address _weeklyLottery,
98         address _monthlyLottery,
99         address _yearlyLottery,
100         address _jackPot,
101         address _superJackPot
102     )
103         public
104     {
105         require(_mainLottery != address(0), "");
106         require(_dailyLottery != address(0), "");
107         require(_weeklyLottery != address(0), "");
108         require(_monthlyLottery != address(0), "");
109         require(_yearlyLottery != address(0), "");
110         require(_jackPot != address(0), "");
111         require(_superJackPot != address(0), "");
112 
113         mainLottery = iBaseLottery(_mainLottery);
114         dailyLottery = iBaseLottery(_dailyLottery);
115         weeklyLottery = iBaseLottery(_weeklyLottery);
116         monthlyLottery = iBaseLottery(_monthlyLottery);
117         yearlyLottery = iBaseLottery(_yearlyLottery);
118         jackPot = iBaseLottery(_jackPot);
119         superJackPot = iBaseLottery(_superJackPot);
120     }
121 
122     function startLotteries() public payable onlyOwner {
123 
124         mainLottery.setTicketPrice(BET_PRICE.mul(HOURLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
125         dailyLottery.setTicketPrice(BET_PRICE.mul(DAILY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
126         weeklyLottery.setTicketPrice(BET_PRICE.mul(WEEKLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
127         monthlyLottery.setTicketPrice(BET_PRICE.mul(MONTHLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
128         yearlyLottery.setTicketPrice(BET_PRICE.mul(YEARLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
129         jackPot.setTicketPrice(BET_PRICE.mul(JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
130         superJackPot.setTicketPrice(BET_PRICE.mul(SUPER_JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
131 
132         mainLottery.startLottery.value(msg.value/7)(start.add(mainLottery.getPeriod()).sub(now));
133         dailyLottery.startLottery.value(msg.value/7)(start.add(dailyLottery.getPeriod()).sub(now));
134         weeklyLottery.startLottery.value(msg.value/7)(start.add(weeklyLottery.getPeriod()).sub(now));
135         monthlyLottery.startLottery.value(msg.value/7)(start.add(monthlyLottery.getPeriod()).sub(now));
136         yearlyLottery.startLottery.value(msg.value/7)(start.add(yearlyLottery.getPeriod()).sub(now));
137         jackPot.startLottery.value(msg.value/7)(ORACLIZE_TIMEOUT);
138         superJackPot.startLottery.value(msg.value/7)(ORACLIZE_TIMEOUT);
139     }
140 }