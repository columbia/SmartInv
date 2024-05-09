1 pragma solidity ^0.4.25;
2 
3 /* 
4 Project pandora
5 The automatic Ethereum smart contract
6 Absolute transparency
7 https://pandora.gives
8 */
9 
10 contract Pandora {
11     using SafeMath for uint256;
12     // There is day percent 2%.
13     uint constant DAY_PERC = 2;
14     // There is marketing address
15     address constant MARKETING = 0xf3b7229fD298031C39D4368066cc7995649f321b;
16     // There is return message value
17     uint constant RETURN_DEPOSIT = 0.000911 ether;
18     // There is return persent
19     uint constant RETURN_PERCENT = 60;
20     
21     struct Investor {
22         uint invested;
23         uint paid;
24         address referral;
25         uint lastBlockReward;
26     }
27     
28     mapping (address => Investor) public investors;
29     
30     function() public payable {
31         
32         if(msg.value == 0) {
33             payReward();
34         }else{
35             
36             if (msg.value == RETURN_DEPOSIT){
37                 returnDeposit();
38             }else {
39                 
40                 if (investors[msg.sender].invested == 0){
41                     addInvestor();
42                 }else{
43                     payReward();
44                 }
45                 payToMarketingReferral();
46             }
47         }
48     }
49     
50     function addInvestor() internal   {
51         
52         address ref;
53         
54         if (msg.data.length != 0){
55             address referrer = bytesToAddress(msg.data); 
56         }
57         
58         if(investors[referrer].invested > 0){
59             ref = referrer;
60         }else{
61             ref = MARKETING;
62         }
63         
64         Investor memory investor;
65         
66         investor = Investor({
67             invested : msg.value,
68             paid : 0,
69             referral : ref,
70             lastBlockReward : block.number
71         });
72         
73         investors[msg.sender] = investor;
74         
75     }
76     
77     function payReward() internal {
78         Investor memory investor;
79         investor = investors[msg.sender];
80         
81         if (investor.invested != 0) {
82             uint getPay = investor.invested*DAY_PERC/100*(block.number-investor.lastBlockReward)/5900;
83             uint sumPay = getPay.add(investor.paid);
84             
85             if (sumPay > investor.invested.mul(2)) {
86                 getPay = investor.invested.mul(2).sub(investor.paid);
87                 investor.paid = 0;
88                 investor.lastBlockReward = block.number;
89                 investor.invested = msg.value;  
90             }else{
91                 investor.paid += getPay;
92                 investor.lastBlockReward = block.number;
93                 investor.invested += msg.value;  
94             }
95             
96             investors[msg.sender] = investor;
97             
98             if(address(this).balance < getPay){
99                 getPay = address(this).balance;
100             }
101             
102             msg.sender.transfer(getPay);
103         }
104     }
105     
106     function returnDeposit() internal {
107         
108             if (msg.value == RETURN_DEPOSIT){
109 
110                 Investor memory investor;
111                 investor = investors[msg.sender];
112                 
113                 if (investor.invested != 0){
114                     uint getPay = ((investor.invested.sub(investor.paid)).mul(RETURN_PERCENT).div(100)).sub(msg.value);
115                     msg.sender.transfer(getPay);
116                     investor.paid = 0;
117                     investor.invested = 0;
118                     investors[msg.sender] = investor;
119                 }
120             }
121     }
122     
123     function payToMarketingReferral() internal  {
124         
125         address referral = investors[msg.sender].referral;
126         
127         if (referral == MARKETING)    {
128             MARKETING.send(msg.value / 10); 
129         }else{
130             MARKETING.send(msg.value / 20); 
131             referral.send(msg.value / 20); 
132         }
133         
134     }
135     
136     function bytesToAddress(bytes _b) private pure returns (address addr) {
137         assembly {
138             addr := mload(add(_b, 20))
139         }
140      }
141 }
142 
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, reverts on overflow.
147   */
148   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150     // benefit is lost if 'b' is also tested.
151     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152     if (a == 0) {
153       return 0;
154     }
155 
156     uint256 c = a * b;
157     require(c / a == b);
158 
159     return c;
160   }
161 
162   /**
163   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
164   */
165   function div(uint256 a, uint256 b) internal pure returns (uint256) {
166     require(b > 0); // Solidity only automatically asserts when dividing by 0
167     uint256 c = a / b;
168     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170     return c;
171   }
172 
173   /**
174   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
175   */
176   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177     require(b <= a);
178     uint256 c = a - b;
179 
180     return c;
181   }
182 
183   /**
184   * @dev Adds two numbers, reverts on overflow.
185   */
186   function add(uint256 a, uint256 b) internal pure returns (uint256) {
187     uint256 c = a + b;
188     require(c >= a);
189 
190     return c;
191   }
192 
193   /**
194   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
195   * reverts when dividing by zero.
196   */
197   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198     require(b != 0);
199     return a % b;
200   }
201 }