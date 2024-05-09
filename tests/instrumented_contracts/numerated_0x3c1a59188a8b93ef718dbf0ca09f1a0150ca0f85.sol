1 pragma solidity ^0.4.24;
2 
3 contract ETHCOOLMain {
4 
5     using SafeMath for uint;
6 
7     struct Deposit {
8         address user;
9         uint amount;
10     }
11 
12     address public owner;
13     uint public main_balance;
14     uint public next;
15 
16     mapping (address => uint) public user_balances;
17     mapping (address => address) public user_referrals;
18     
19     Deposit[] public deposits;
20     
21     constructor() public {
22         owner = msg.sender;
23         user_referrals[owner] = owner;
24         main_balance = 0;
25         next = 0;
26     }
27 
28     function publicGetBalance(address user) view public returns (uint) {
29         return user_balances[user];
30     }
31 
32     function publicGetStatus() view public returns (uint, uint, uint) {
33         return (main_balance, next, deposits.length);
34     }
35 
36     function publicGetDeposit(uint index) view public returns (address, address, uint) {
37         return (deposits[index].user, user_referrals[deposits[index].user], deposits[index].amount);
38     }
39 
40     function userWithdraw() public {
41         userPayout();
42         
43         if (user_balances[msg.sender] > 0) {
44             uint amount = user_balances[msg.sender];
45             user_balances[msg.sender] = 0;
46             msg.sender.transfer(amount);
47         }
48     }
49 
50     function userDeposit(address referral) public payable {
51         if (msg.value > 0) {
52             if(user_referrals[msg.sender] == address(0)) {
53                 user_referrals[msg.sender] = (referral != address(0) && referral != msg.sender) ? referral : owner;
54             }
55 
56             Deposit memory deposit = Deposit(msg.sender, msg.value);
57             deposits.push(deposit);
58 
59             uint referral_cut = msg.value.div(100);
60             uint owner_cut = msg.value.mul(4).div(100);
61             user_balances[user_referrals[msg.sender]] = user_balances[user_referrals[msg.sender]].add(referral_cut);
62             user_balances[owner] = user_balances[owner].add(owner_cut);
63             main_balance = main_balance.add(msg.value).sub(referral_cut).sub(owner_cut);
64         }
65 
66         userPayout();
67     }
68 
69     function userReinvest() public {
70         if (user_balances[msg.sender] > 0) {
71             Deposit memory deposit = Deposit(msg.sender, user_balances[msg.sender]);
72             deposits.push(deposit);
73 
74             uint owner_cut = user_balances[msg.sender].mul(5).div(100);
75             user_balances[owner] = user_balances[owner].add(owner_cut);
76             main_balance = main_balance.add(user_balances[msg.sender]).sub(owner_cut);
77             user_balances[msg.sender] = 0;
78         }
79 
80         userPayout();
81     }
82 
83     function userPayout() public {
84         if (next < deposits.length) {
85             uint next_payout = deposits[next].amount.mul(120).div(100);
86             if (main_balance >= next_payout) {
87                 user_balances[deposits[next].user] = user_balances[deposits[next].user].add(next_payout);
88                 main_balance = main_balance.sub(next_payout);
89                 next = next.add(1);
90             }
91         }
92     }
93 
94     function contractBoost(uint share) public payable {
95         if (msg.value > 0) {
96             uint owner_cut = msg.value.mul(share).div(100);
97             user_balances[owner] = user_balances[owner].add(owner_cut);
98             main_balance = main_balance.add(msg.value).sub(owner_cut);
99         }
100     }
101 }
102 
103 library SafeMath {
104 
105     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
106         if (a == 0) {
107             return 0;
108         }
109         c = a * b;
110         assert(c / a == b);
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a / b;
116     }
117 
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         assert(b <= a);
120         return a - b;
121     }
122 
123     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
124         c = a + b;
125         assert(c >= a);
126         return c;
127     }
128 }