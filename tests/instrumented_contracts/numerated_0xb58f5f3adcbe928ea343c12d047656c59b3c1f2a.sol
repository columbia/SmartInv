1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 interface UnicornDividendTokenInterface {
46     function totalSupply() external view returns (uint256);
47     function balanceOf(address who) external view returns (uint256);
48     function transfer(address to, uint256 value) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     function allowance(address owner, address spender) external view returns (uint256);
52     function transferFrom(address from, address to, uint256 value) external returns (bool);
53     function approve(address spender, uint256 value) external returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56     function getHolder(uint256) external view returns (address);
57     function getHoldersCount() external view returns (uint256);
58 }
59 
60 contract DividendManager {
61     using SafeMath for uint256;
62 
63     /* Our handle to the UnicornToken contract. */
64     UnicornDividendTokenInterface unicornDividendToken;
65 
66     /* Handle payments we couldn't make. */
67     mapping (address => uint256) public pendingWithdrawals;
68 
69     /* Indicates a payment is now available to a shareholder */
70     event WithdrawalAvailable(address indexed holder, uint256 amount);
71 
72     /* Indicates a payment is payed to a shareholder */
73     event WithdrawalPayed(address indexed holder, uint256 amount);
74 
75     /* Indicates a dividend payment was made. */
76     event DividendPayment(uint256 paymentPerShare);
77 
78     /* Create our contract with references to other contracts as required. */
79     function DividendManager(address _unicornDividendToken) public{
80         /* Setup access to our other contracts and validate their versions */
81         unicornDividendToken = UnicornDividendTokenInterface(_unicornDividendToken);
82     }
83 
84     uint256 public retainedEarning = 0;
85 
86 
87     // Makes a dividend payment - we make it available to all senders then send the change back to the caller.  We don't actually send the payments to everyone to reduce gas cost and also to
88     // prevent potentially getting into a situation where we have recipients throwing causing dividend failures and having to consolidate their dividends in a separate process.
89 
90     function () public payable {
91         payDividend();
92     }
93 
94     function payDividend() public payable {
95         retainedEarning = retainedEarning.add(msg.value);
96         require(retainedEarning > 0);
97 
98         /* Determine how much to pay each shareholder. */
99         uint256 totalSupply = unicornDividendToken.totalSupply();
100         uint256 paymentPerShare = retainedEarning.div(totalSupply);
101         if (paymentPerShare > 0) {
102             uint256 totalPaidOut = 0;
103             /* Enum all accounts and send them payment */
104             for (uint256 i = 1; i <= unicornDividendToken.getHoldersCount(); i++) {
105                 address holder = unicornDividendToken.getHolder(i);
106                 uint256 withdrawal = paymentPerShare * unicornDividendToken.balanceOf(holder);
107                 pendingWithdrawals[holder] = pendingWithdrawals[holder].add(withdrawal);
108                 WithdrawalAvailable(holder, withdrawal);
109                 totalPaidOut = totalPaidOut.add(withdrawal);
110             }
111             retainedEarning = retainedEarning.sub(totalPaidOut);
112         }
113         DividendPayment(paymentPerShare);
114     }
115 
116     /* Allows a user to request a withdrawal of their dividend in full. */
117     function withdrawDividend() public {
118         uint amount = pendingWithdrawals[msg.sender];
119         require (amount > 0);
120         pendingWithdrawals[msg.sender] = 0;
121         msg.sender.transfer(amount);
122         WithdrawalPayed(msg.sender, amount);
123     }
124 }