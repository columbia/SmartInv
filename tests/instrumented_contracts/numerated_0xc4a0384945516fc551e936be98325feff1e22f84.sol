1 pragma solidity 0.4 .24;
2 
3 /**
4 Welcome to the first innovational investment project – SmartRocket.
5 The all you need is to make a deposit and wait for your profit: 4% of your deposit per day.
6 
7 To make a deposit send any amount of ETH to the smart contract address.
8 You can reinvest your deposit via sending more ETH to the smart contract above the sum you have sent before.
9 
10 All the deposits are accumulated and the percentage is calculated from the total investment.
11 6% of your deposit goes to marketing, promotion and charity.
12 3% of your deposit goes to the backup budget. Backup budget is a bank, that is formed from all the investments and, if the growth of the project slows down due to some reasons, the calculated necessary sum of money will be transferred to the smart contract to protect the “late investors”. This scheme is about that everyone in the project helps each other.
13 The project fund forms from 91% of all deposits + 3% (the whole backup budget, if it is needed).
14 
15 You can get paid any time you want, but not more frequently, than once per minute!
16 To get your % you need to send 0 ETH to the smart contract address.
17 
18 You can get only 217% of your revenue. After you got paid 217% of your investments (100% of your deposit plus 117% of profit), smart contract automatically deletes you from the project and you can re-enter it to continue getting profit. This scheme in addition to the most optimized profit percentage (4%) allows the project to exist for a long time.
19 
20 You have an option of getting more, than 217% of your revenue. For this you need not to withdraw your percents until accumulating the sum you need.
21 For example, if you want to get 300% of your revenue, you need to wait 75 days since you have made a deposit (25 days (100% of your dep – 4% per day for 25 days) x 3)
22 
23 !_IMPORTANT_! – GAS LIMIT for ALL TRANSACTIONS is 150000. All unused gas will be returned to you automatically.
24 
25 
26 
27 */
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns(uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
41         uint256 c = a * b;
42         assert(a == 0 || c / a == b);
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns(uint256) {
46         // assert(b > 0);
47         uint256 c = a / b;
48         return c;
49     }
50 }
51 contract SmartRocket {
52     using SafeMath
53     for uint;
54 
55     mapping(address => uint) public TimeOfInvestments;
56     mapping(address => uint) public CalculatedProfit;
57     mapping(address => uint) public SumOfInvestments;
58     uint public WithdrawPeriod = 1 minutes;
59     uint public HappyInvestors = 0;
60     address public constant PromotionBank = 0x3B2CCc7B82f18eCAB670FA4802cFAE8e8957661d;
61     address public constant BackUpBank = 0x0674D98b3f6f3045981029FDCD8adE493071ba37;
62 
63     modifier AreYouGreedy() {
64         require(now >= TimeOfInvestments[msg.sender].add(WithdrawPeriod), "Don’t hurry, dude, not yet");
65         _;
66     }
67 
68     modifier AreYouLucky() {
69         require(SumOfInvestments[msg.sender] > 0, "You are not with us, yet");
70         _;
71     }
72 
73     function() external payable {
74         if (msg.value > 0) {
75             if (SumOfInvestments[msg.sender] == 0) {
76                 HappyInvestors += 1;
77             }
78             if (SumOfInvestments[msg.sender] > 0 && now > TimeOfInvestments[msg.sender].add(WithdrawPeriod)) {
79                 PrepareToBeRich();
80             }
81             SumOfInvestments[msg.sender] = SumOfInvestments[msg.sender].add(msg.value);
82             TimeOfInvestments[msg.sender] = now;
83             PromotionBank.transfer(msg.value.mul(6).div(100));
84             BackUpBank.transfer(msg.value.mul(3).div(100));
85         } else {
86             PrepareToBeRich();
87         }
88     }
89 
90     function PrepareToBeRich() AreYouGreedy AreYouLucky internal {
91         if ((SumOfInvestments[msg.sender].mul(217).div(100)) <= CalculatedProfit[msg.sender]) {
92             SumOfInvestments[msg.sender] = 0;
93             CalculatedProfit[msg.sender] = 0;
94             TimeOfInvestments[msg.sender] = 0;
95         } else {
96             uint GetYourMoney = YourPercent();
97             CalculatedProfit[msg.sender] += GetYourMoney;
98             TimeOfInvestments[msg.sender] = now;
99             msg.sender.transfer(GetYourMoney);
100         }
101     }
102 //calculating the percent rate per day (1day=24hours=1440minutes); 1/36000*1440=0.04 (4% per day)
103     function YourPercent() public view returns(uint) {
104         uint withdrawalAmount = ((SumOfInvestments[msg.sender].mul(1).div(36000)).mul(now.sub(TimeOfInvestments[msg.sender]).div(WithdrawPeriod)));
105         return (withdrawalAmount);
106     }
107 }