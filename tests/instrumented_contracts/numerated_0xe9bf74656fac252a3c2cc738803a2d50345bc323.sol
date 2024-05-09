1 pragma solidity ^0.4.24;
2 
3 /*
4     CryptoPrize(address _token_address)   // this will unlock the prize and send yum to user
5   @author Yumerium Ltd
6 */
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 contract YUM {
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31     mapping (address => uint256) public balanceOf;
32     function transfer(address _to, uint256 _value) public;
33 }
34 
35 
36 contract TokenReward {
37     using SafeMath for uint256;
38     uint256 public maxCount = 2 ** 256 - 1;
39     uint256 public budget;
40     uint256 public totalUnlocked;
41     uint256 public startYum;
42     uint256 public nextRewardAmount;
43     uint256 public count;
44     address public owner;
45     YUM public token;
46 
47     event UnlockReward(address to, uint256 amount);
48     event CalcNextReward(uint256 count, uint256 amount);
49     event Retrieve(address to, uint256 amount);
50     event AddBudget(uint256 budget, uint256 startYum);
51 
52     // start with 0 budget and 0 Yum for the prize
53     constructor(address _token_address) public {
54         budget = 0;
55         startYum = 0;
56         count = 0;
57         owner = msg.sender;
58         token = YUM(_token_address);
59     }
60 
61     /* 
62      * Calculate the next prize
63      * TODO: Change the equation if needed
64     */
65     function calcNextReward() public returns (uint256) {
66         uint256 oneYUM = 10 ** 8;
67         uint256 amount = startYum.mul(oneYUM).div(count.mul(oneYUM).div(500).add(oneYUM)); // 100 YUM / (1 YUM / 500 + 1 YUM)
68         emit CalcNextReward(count, amount);
69         return amount;
70     }
71     
72     // unlock the prize
73     function sendNextRewardTo(address to) external {
74         require(msg.sender==owner);
75         uint256 amount = nextRewardAmount;
76         require(amount > 0);
77         uint256 total = totalUnlocked.add(amount);
78         require(total<=budget);
79         token.transfer(to, amount);
80         budget = budget.sub(amount);
81         if (count < maxCount)
82             count++;
83         totalUnlocked = total;
84         nextRewardAmount = calcNextReward();
85         emit UnlockReward(to, amount);
86     }
87 
88     // change creator address
89     function changeOwnerTo(address _creator) external {
90         require(msg.sender==owner);
91         owner = _creator;
92     }
93 
94     // change creator address
95     function changeYumAddressTo(address _token_address) external {
96         require(msg.sender==owner);
97         token = YUM(_token_address);
98     }
99 
100     // Retrieve all YUM token left from the contract
101     function retrieveAll() external {
102         require(msg.sender==owner);
103         uint256 amount = token.balanceOf(this);
104         token.transfer(owner, amount);   
105         emit Retrieve(owner, amount);   
106     }
107 
108     // add more budget and reset startYum and count
109     function addBudget(uint256 _budget, uint256 _startYum, uint256 _count) external {
110         require(msg.sender==owner);
111         require(token.transferFrom(msg.sender, this, _budget));
112         budget = budget.add(_budget);
113         startYum = _startYum;
114         count = _count;
115         nextRewardAmount = calcNextReward();
116         emit AddBudget(budget, startYum);
117     }
118 }