1 pragma solidity ^0.4.24;
2 
3 /*
4     Sale(address ethwallet)   // this will send the received ETH funds to this address
5   @author Yumerium Ltd
6 */
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract YumeriumManager {
54     function getYumerium(address sender) external payable returns (uint256);
55 }
56 
57 contract Sale {
58     uint public saleEnd1 = 1535846400 + 1 days; //9/3/2018 @ 12:00am (UTC)
59     uint public saleEnd2 = saleEnd1 + 1 days; //9/4/2018 @ 12:00am (UTC)
60     uint public saleEnd3 = saleEnd2 + 1 days; //9/5/2018 @ 12:00am (UTC)
61     uint public saleEnd4 = 1539129600; //10/10/2018 @ 12:00am (UTC)
62     uint256 public minEthValue = 10 ** 15; // 0.001 eth
63     
64     using SafeMath for uint256;
65     uint256 public maxSale;
66     uint256 public totalSaled;
67     mapping(uint256 => mapping(address => uint256)) public ticketsEarned;   // tickets earned for each user each day
68                                                                             // (day => (user address => # tickets))
69     mapping(uint256 => uint256) public totalTickets; // (day => # total tickets)
70     mapping(uint256 => uint256) public eachDaySold; // how many ethereum sold for each day
71     uint256 public currentDay;  // shows what day current day is for event sale (0 = event sale ended)
72                                 // 1 = day 1, 2 = day 2, 3 = day 3
73     mapping(uint256 => address[]) public eventSaleParticipants; // participants for event sale for each day
74     
75     YumeriumManager public manager;
76 
77     address public creator;
78 
79     event Contribution(address from, uint256 amount);
80 
81     constructor(address _manager_address) public {
82         maxSale = 316906850 * 10 ** 8; 
83         manager = YumeriumManager(_manager_address);
84         creator = msg.sender;
85         currentDay = 1;
86     }
87 
88     function () external payable {
89         buy();
90     }
91 
92     // CONTRIBUTE FUNCTION
93     // converts ETH to TOKEN and sends new TOKEN to the sender
94     function contribute() external payable {
95         buy();
96     }
97     
98     function getNumParticipants(uint256 whichDay) public view returns (uint256) {
99         return eventSaleParticipants[whichDay].length;
100     }
101     
102     function buy() internal {
103         require(msg.value>=minEthValue);
104         require(now < saleEnd4); // main sale postponed
105         
106         uint256 amount = manager.getYumerium.value(msg.value)(msg.sender);
107         uint256 total = totalSaled.add(amount);
108         
109         require(total<=maxSale);
110         
111         totalSaled = total;
112         if (currentDay > 0) {
113             eachDaySold[currentDay] = eachDaySold[currentDay].add(msg.value);
114             uint256 tickets = msg.value.div(10 ** 17);
115             if (ticketsEarned[currentDay][msg.sender] == 0) {
116                 eventSaleParticipants[currentDay].push(msg.sender);
117             }
118             ticketsEarned[currentDay][msg.sender] = ticketsEarned[currentDay][msg.sender].add(tickets);
119             totalTickets[currentDay] = totalTickets[currentDay].add(tickets);
120             if (now >= saleEnd3)
121             {
122                 currentDay = 0;
123             }
124             else if (now >= saleEnd2)
125             {
126                 currentDay = 3;
127             }
128             else if (now >= saleEnd1)
129             {
130                 currentDay = 2;
131             }
132         }
133         
134         emit Contribution(msg.sender, amount);
135     }
136 
137     // change yumo address
138     function changeManagerAddress(address _manager_address) external {
139         require(msg.sender==creator, "You are not a creator!");
140         manager = YumeriumManager(_manager_address);
141     }
142 }