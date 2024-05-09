1 pragma solidity 0.4.25;
2 
3 /*
4 * https://www.eth2x.fund/
5 *
6 * Eth2x - Ethereum Fund
7 *
8 * Maximum profit - 200%
9 *
10 * Distributions of funds:
11 * Payments to investors - 90%
12 * Project marketing - 10%
13 *
14 * [✓] Up to 100 eth / 1 % daily
15 * [✓] From 200-300 eth / 2% daily
16 * [✓] From 300-400 eth / 3% daily
17 * [✓] From 400-500 eth / 4% daily
18 * [✓] From 500 eth / 5% daily
19 *
20 * [✓] Referral bouns - 2%
21 * [✓] Referral cashback - 3%
22 */
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
26         if(a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         require(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns(uint256) {
35         require(b > 0);
36         uint256 c = a / b;
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns(uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49         return c;
50     }
51 
52     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
53         require(b != 0);
54         return a % b;
55     }
56 }
57 
58 contract Eth2x {
59     using SafeMath for uint;
60 
61     struct Investor {
62         uint invested;
63         uint payouts;
64         uint first_invest;
65         uint last_payout;
66         address referrer;
67     }
68 
69     uint constant public COMMISSION = 10;
70     uint constant public WITHDRAW = 50;
71     uint constant public REFBONUS = 2;
72     uint constant public CASHBACK = 3;
73     uint constant public MULTIPLICATION = 2;
74 
75     address public beneficiary = 0x3368e0A06D0Ae1b826B5171Ced8C7c94D785f9E5;
76 
77     mapping(address => Investor) public investors;
78 
79     event AddInvestor(address indexed holder);
80 
81     event Payout(address indexed holder, uint amount);
82     event Deposit(address indexed holder, uint amount, address referrer);
83     event RefBonus(address indexed from, address indexed to, uint amount);
84     event CashBack(address indexed holder, uint amount);
85     event Withdraw(address indexed holder, uint amount);
86 
87     function bonusSize() view public returns(uint) {
88         uint b = address(this).balance;
89 
90         if(b >= 500 ether) return 5;
91         if(b >= 400 ether) return 4;
92         if(b >= 300 ether) return 3;
93         if(b >= 200 ether) return 2;
94         return 1;
95     }
96 
97     function payoutSize(address _to) view public returns(uint) {
98         uint max = investors[_to].invested.mul(MULTIPLICATION);
99         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
100 
101         uint payout = investors[_to].invested.mul(bonusSize()).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
102         return investors[_to].payouts.add(payout) > max ? max.sub(investors[_to].payouts) : payout;
103     }
104 
105     function withdrawSize(address _to) view public returns(uint) {
106         uint max = investors[_to].invested.div(100).mul(WITHDRAW);
107         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
108 
109         return max.sub(investors[_to].payouts);
110     }
111 
112     function bytesToAddress(bytes bys) pure private returns(address addr) {
113         assembly {
114             addr := mload(add(bys, 20))
115         }
116     }
117 
118     function() payable external {
119         if(investors[msg.sender].invested > 0) {
120             uint payout = payoutSize(msg.sender);
121 
122             require(msg.value > 0 || payout > 0, "No payouts");
123 
124             if(payout > 0) {
125                 investors[msg.sender].last_payout = block.timestamp;
126                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
127 
128                 msg.sender.transfer(payout);
129 
130                 emit Payout(msg.sender, payout);
131             }
132 
133             if(investors[msg.sender].payouts >= investors[msg.sender].invested.mul(MULTIPLICATION)) {
134                 delete investors[msg.sender];
135 
136                 emit Withdraw(msg.sender, 0);
137             }
138         }
139 
140         if(msg.value == 0.00000007 ether) {
141             require(investors[msg.sender].invested > 0, "You have not invested anything yet");
142 
143             uint amount = withdrawSize(msg.sender);
144 
145             require(amount > 0, "You have nothing to withdraw");
146             
147             msg.sender.transfer(amount);
148 
149             delete investors[msg.sender];
150             
151             emit Withdraw(msg.sender, amount);
152         }
153         else if(msg.value > 0) {
154             require(msg.value >= 0.01 ether, "Minimum investment amount 0.01 ether");
155 
156             investors[msg.sender].last_payout = block.timestamp;
157             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
158 
159             beneficiary.transfer(msg.value.mul(COMMISSION).div(100));
160 
161             if(investors[msg.sender].first_invest == 0) {
162                 investors[msg.sender].first_invest = block.timestamp;
163 
164                 if(msg.data.length > 0) {
165                     address ref = bytesToAddress(msg.data);
166 
167                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
168                         investors[msg.sender].referrer = ref;
169 
170                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
171                         ref.transfer(ref_bonus);
172 
173                         emit RefBonus(msg.sender, ref, ref_bonus);
174 
175                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
176                         msg.sender.transfer(cashback_bonus);
177 
178                         emit CashBack(msg.sender, cashback_bonus);
179                     }
180                 }
181                 emit AddInvestor(msg.sender);
182             }
183 
184             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
185         }
186     }
187 }