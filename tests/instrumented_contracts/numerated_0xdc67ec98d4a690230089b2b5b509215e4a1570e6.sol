1 pragma solidity 0.5.6;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner, "");
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0), "");
18         owner = newOwner;
19     }
20 
21 }
22 
23 
24 contract Manageable is Ownable {
25     mapping(address => bool) public listOfManagers;
26 
27     modifier onlyManager() {
28         require(listOfManagers[msg.sender], "");
29         _;
30     }
31 
32     function addManager(address _manager) public onlyOwner returns (bool success) {
33         if (!listOfManagers[_manager]) {
34             require(_manager != address(0), "");
35             listOfManagers[_manager] = true;
36             success = true;
37         }
38     }
39 
40     function removeManager(address _manager) public onlyOwner returns (bool success) {
41         if (listOfManagers[_manager]) {
42             listOfManagers[_manager] = false;
43             success = true;
44         }
45     }
46 
47     function getInfo(address _manager) public view returns (bool) {
48         return listOfManagers[_manager];
49     }
50 }
51 
52 interface iHourlyGame {
53     function buyBonusTickets(
54         address _participant,
55         uint _hourlyTicketsCount,
56         uint _dailyTicketsCount,
57         uint _weeklyTicketsCount,
58         uint _monthlyTicketsCount,
59         uint _yearlyTicketsCount,
60         uint _jackPotTicketsCount,
61         uint _superJackPotTicketsCount
62     ) external payable;
63 }
64 
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 interface IERC20 {
71     function balanceOf(address who) external view returns (uint256);
72     function allowance(address owner, address spender) external view returns (uint256);
73     function transfer(address to, uint256 value) external returns (bool);
74     function transferFrom(address from, address to, uint256 value) external returns (bool);
75 }
76 
77 
78 contract ProxyBonusContract is Manageable {
79     using SafeMath for uint;
80 
81     IERC20 public token;
82 
83     address hourlyGame;
84 
85     constructor (
86         address _token,
87         address _hourlyGame
88     )
89     public
90     {
91         require(_token != address(0));
92         require(_hourlyGame != address(0), "");
93 
94         token = IERC20(_token);
95         hourlyGame = _hourlyGame;
96     }
97 
98     function buyTickets(address _participant, uint _luckyBacksAmount) public {
99         require(_luckyBacksAmount > 0, "");
100         require(token.transferFrom(msg.sender, address(this), _luckyBacksAmount), "");
101 
102         uint amount = _luckyBacksAmount.div(10**18);
103 
104         iHourlyGame(hourlyGame).buyBonusTickets(
105             _participant,
106             amount,
107             amount,
108             amount,
109             amount,
110             amount,
111             amount,
112             amount
113         );
114     }
115 
116     function changeToken(address _token) public onlyManager {
117         token = IERC20(_token);
118     }
119 }
120 
121 library SafeMath {
122 
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         if (a == 0) {
125             return 0;
126         }
127 
128         uint256 c = a * b;
129         require(c / a == b, "");
130 
131         return c;
132     }
133 
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
136         uint256 c = a / b;
137 
138         return c;
139     }
140 
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a, "");
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "");
151 
152         return c;
153     }
154 
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         require(b != 0, "");
157         return a % b;
158     }
159 }