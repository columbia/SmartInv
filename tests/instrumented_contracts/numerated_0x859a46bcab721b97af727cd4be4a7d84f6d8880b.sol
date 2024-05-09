1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract Main {
68 
69     using SafeMath for uint;
70 
71     // The nested mapping is used to implement the round-based logic
72     mapping(uint => mapping(address => uint)) public balance;
73     mapping(uint => mapping(address => uint)) public time;
74     mapping(uint => mapping(address => uint)) public percentWithdraw;
75     mapping(uint => mapping(address => uint)) public allPercentWithdraw;
76     mapping(uint => uint) public investorsByRound;
77 
78     uint public stepTime = 24 hours;
79     uint public countOfInvestors = 0;
80     uint public totalRaised;
81     uint public rounds_counter;
82     uint public projectPercent = 10;
83     uint public totalWithdrawed = 0;
84     bool public started;
85 
86     address public ownerAddress;
87 
88     event Invest(uint indexed round, address indexed investor, uint256 amount);
89     event Withdraw(uint indexed round, address indexed investor, uint256 amount);
90 
91     modifier userExist() {
92         require(balance[rounds_counter][msg.sender] > 0, "Address not found");
93         _;
94     }
95 
96     modifier checkTime() {
97         require(now >= time[rounds_counter][msg.sender].add(stepTime), "Too fast payout request");
98         _;
99     }
100 
101     modifier onlyStarted() {
102         require(started == true);
103         _;
104     }
105 
106     // @dev This function is processing all the logic with withdraw
107     function collectPercent() userExist checkTime internal {
108 
109         // Check that user already has received 200%
110         // In this case - remove him from the db
111         if ((balance[rounds_counter][msg.sender].mul(2)) <= allPercentWithdraw[rounds_counter][msg.sender]) {
112             balance[rounds_counter][msg.sender] = 0;
113             time[rounds_counter][msg.sender] = 0;
114             percentWithdraw[rounds_counter][msg.sender] = 0;
115         } else {
116             // User has not reached the limit yet
117             // Process the withdraw and update the stats
118 
119             uint payout = payoutAmount();  // Get the amount of weis to send
120 
121             percentWithdraw[rounds_counter][msg.sender] = percentWithdraw[rounds_counter][msg.sender].add(payout);
122             allPercentWithdraw[rounds_counter][msg.sender] = allPercentWithdraw[rounds_counter][msg.sender].add(payout);
123 
124             // Send Ethers
125             msg.sender.transfer(payout);
126             totalWithdrawed = totalWithdrawed.add(payout);
127 
128             emit Withdraw(rounds_counter, msg.sender, payout);
129         }
130 
131     }
132 
133     // @dev The withdraw percentage depends on two things:
134     // @dev first one is total amount of Ethers on the contract balance
135     // @dev and second one is the deposit size of current investor
136     function percentRate() public view returns(uint) {
137 
138         uint contractBalance = address(this).balance;
139         uint user_balance = balance[rounds_counter][msg.sender];
140         uint contract_depending_percent = 0;
141 
142         // Check the contract balance and add some additional percents
143         // Because of the Solidity troubles with floats
144         // 20 means 2%, 15 means 1.5%, 10 means 1%
145         if (contractBalance >= 10000 ether) {
146             contract_depending_percent = 20;
147         } else if (contractBalance >= 5000 ether) {
148             contract_depending_percent = 15;
149         } else if (contractBalance >= 1000 ether) {
150             contract_depending_percent = 10;
151         }
152 
153         // Check the investor's balance
154         if (user_balance < 9999999999999999999) {          // < 9.999999 Ethers
155           return (30 + contract_depending_percent);
156         } else if (user_balance < 29999999999999999999) {  // < 29.999999 Ethers
157           return (35 + contract_depending_percent);
158         } else if (user_balance < 49999999999999999999) {  // < 49.999999 Ethers
159           return (40 + contract_depending_percent);
160         } else {                                        // <= 100 Ethers
161           return (45 + contract_depending_percent);
162         }
163 
164     }
165 
166 
167     // @dev This function returns the amount in weis for withdraw
168     function payoutAmount() public view returns(uint256) {
169         // Minimum percent is 3%, maximum percent is 6.5% per 24 hours
170         uint256 percent = percentRate();
171 
172         uint256 different = now.sub(time[rounds_counter][msg.sender]).div(stepTime);
173 
174         // 1000 instead of 100, because in case of 3%
175         // 'percent' equals to 30 and so on
176         uint256 rate = balance[rounds_counter][msg.sender].mul(percent).div(1000);
177 
178         uint256 withdrawalAmount = rate.mul(different).sub(percentWithdraw[rounds_counter][msg.sender]);
179 
180         return withdrawalAmount;
181     }
182 
183     // @dev This function is called each time when user sends Ethers
184     function deposit() private {
185         if (msg.value > 0) { // User wants to invest
186             require(balance[rounds_counter][msg.sender] == 0);  // User can invest only once
187 
188             if (balance[rounds_counter][msg.sender] == 0) {  // New investor
189               countOfInvestors = countOfInvestors.add(1);
190               investorsByRound[rounds_counter] = investorsByRound[rounds_counter].add(1);
191             }
192 
193             // If already has some investments and the time gap is correct
194             // make a withdraw
195             if (
196               balance[rounds_counter][msg.sender] > 0 &&
197               now > time[rounds_counter][msg.sender].add(stepTime)
198             ) {
199                 collectPercent();
200                 percentWithdraw[rounds_counter][msg.sender] = 0;
201             }
202 
203             balance[rounds_counter][msg.sender] = balance[rounds_counter][msg.sender].add(msg.value);
204             time[rounds_counter][msg.sender] = now;
205 
206             // Send fee to the owner
207             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
208             totalRaised = totalRaised.add(msg.value);
209 
210             emit Invest(rounds_counter, msg.sender, msg.value);
211         } else {  // User wants to withdraw his profit
212             collectPercent();
213         }
214     }
215 
216     // @dev This function is called when user sends Ethers
217     function() external payable onlyStarted {
218         // Maximum deposit per address - 100 Ethers
219         require(balance[rounds_counter][msg.sender].add(msg.value) <= 100 ether, "More than 100 ethers");
220 
221         // Check that contract has less than 10%
222         // of total collected investments
223         if (address(this).balance < totalRaised.div(100).mul(10)) {
224             startNewRound();
225         }
226 
227         deposit();
228     }
229 
230     // @dev In the case of new round - reset all the stats
231     // @dev and start new round with the rest of the balance on the contract
232     function startNewRound() internal {
233         rounds_counter = rounds_counter.add(1);
234         totalRaised = address(this).balance;
235     }
236 
237     // @dev Enable the game
238     function start() public {
239         require(ownerAddress == msg.sender);
240         started = true;
241     }
242 
243     constructor() public {
244         ownerAddress = msg.sender;
245         started = false;
246     }
247 
248 }