1 /*! eth2x.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         require(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         require(b > 0);
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22         require(b <= a);
23         uint256 c = a - b;
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns(uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
34         require(b != 0);
35         return a % b;
36     }
37 }
38 
39 contract Eth2x {
40     using SafeMath for uint;
41 
42     struct Investor {
43         uint invested;
44         uint payouts;
45         uint first_invest;
46         uint last_payout;
47         address referrer;
48     }
49 
50     uint constant public COMMISSION = 10;
51     uint constant public WITHDRAW = 85;
52     uint constant public REFBONUS = 2;
53     uint constant public CASHBACK = 3;
54     uint constant public MULTIPLICATION = 2;
55 
56     address public beneficiary = 0x373D3f20f9F10d23686Dc5Cda704E4EFCf0Ab1DB;
57 
58     mapping(address => Investor) public investors;
59 
60     event AddInvestor(address indexed holder);
61 
62     event Payout(address indexed holder, uint amount);
63     event Deposit(address indexed holder, uint amount, address referrer);
64     event RefBonus(address indexed from, address indexed to, uint amount);
65     event CashBack(address indexed holder, uint amount);
66     event Withdraw(address indexed holder, uint amount);
67 
68     function bonusSize() view public returns(uint) {
69         uint b = address(this).balance;
70 
71         if(b >= 5000 ether) return 9;
72         if(b >= 3000 ether) return 4;
73         if(b >= 2000 ether) return 5;
74         if(b >= 1000 ether) return 6;
75         return 7;
76     }
77 
78     function payoutSize(address _to) view public returns(uint) {
79         uint max = investors[_to].invested.mul(MULTIPLICATION);
80         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
81 
82         uint payout = investors[_to].invested.mul(bonusSize()).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
83         return investors[_to].payouts.add(payout) > max ? max.sub(investors[_to].payouts) : payout;
84     }
85 
86     function withdrawSize(address _to) view public returns(uint) {
87         uint max = investors[_to].invested.div(100).mul(WITHDRAW);
88         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
89 
90         return max.sub(investors[_to].payouts);
91     }
92 
93     function bytesToAddress(bytes bys) pure private returns(address addr) {
94         assembly {
95             addr := mload(add(bys, 20))
96         }
97     }
98 
99     function() payable external {
100         if(investors[msg.sender].invested > 0) {
101             uint payout = payoutSize(msg.sender);
102 
103             require(msg.value > 0 || payout > 0, "No payouts");
104 
105             if(payout > 0) {
106                 investors[msg.sender].last_payout = block.timestamp;
107                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
108 
109                 msg.sender.transfer(payout);
110 
111                 emit Payout(msg.sender, payout);
112             }
113 
114             if(investors[msg.sender].payouts >= investors[msg.sender].invested.mul(MULTIPLICATION)) {
115                 delete investors[msg.sender];
116 
117                 emit Withdraw(msg.sender, 0);
118             }
119         }
120 
121         if(msg.value == 0.00000007 ether) {
122             require(investors[msg.sender].invested > 0, "You have not invested anything yet");
123 
124             uint amount = withdrawSize(msg.sender);
125 
126             require(amount > 0, "You have nothing to withdraw");
127             
128             msg.sender.transfer(amount);
129 
130             delete investors[msg.sender];
131             
132             emit Withdraw(msg.sender, amount);
133         }
134         else if(msg.value > 0) {
135             require(msg.value >= 0.01 ether, "Minimum investment amount 0.01 ether");
136 
137             investors[msg.sender].last_payout = block.timestamp;
138             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
139 
140             beneficiary.transfer(msg.value.mul(COMMISSION).div(100));
141 
142             if(investors[msg.sender].first_invest == 0) {
143                 investors[msg.sender].first_invest = block.timestamp;
144 
145                 if(msg.data.length > 0) {
146                     address ref = bytesToAddress(msg.data);
147 
148                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
149                         investors[msg.sender].referrer = ref;
150 
151                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
152                         ref.transfer(ref_bonus);
153 
154                         emit RefBonus(msg.sender, ref, ref_bonus);
155 
156                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
157                         msg.sender.transfer(cashback_bonus);
158 
159                         emit CashBack(msg.sender, cashback_bonus);
160                     }
161                 }
162                 emit AddInvestor(msg.sender);
163             }
164 
165             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
166         }
167     }
168 }