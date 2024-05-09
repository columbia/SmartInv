1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 }
44 
45 contract Ownable {
46     address public owner;
47 
48     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function changeOwner(address _newOwner) onlyOwner public {
56         require(_newOwner != address(0));
57         emit OwnerChanged(owner, _newOwner);
58         owner = _newOwner;
59     }
60 }
61 
62 contract Ethebit is Ownable{
63 
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) investments;
67     mapping(address => uint256) joined;
68     mapping(address => uint256) withdrawals;
69     mapping(address => uint256) referrerBalance;
70     mapping(uint256 => address) refLinkToAddress;
71     mapping(address => uint256) refAddressToLink;
72 
73     uint256 public minimum = 0.01 ether;
74     uint256 percentDay = 83;
75     uint256 public countInvestor;
76     uint256 public amountWeiRaised;
77     uint256 public lastInvestment;
78     uint256 public lastInvestmentTime;
79     uint256 countReferralLink = 100;
80     address public lastInvestorAddress;
81 
82     uint256 DAYS_PROFIT = 30;
83 
84     address public wallet;
85     address public support;
86 
87     event Invest(address indexed investor, uint256 amount);
88     event Withdraw(address indexed investor, uint256 amount);
89     event ReferrerWithdraw(address indexed investor, uint256 amount);
90     event ReferrerProfit(address indexed hunter, address indexed referral, uint256 amount);
91     event MakeReferralLink(address indexed investor, uint256 refNumber);
92 
93     constructor(address _wallet, address _support) public {
94         //No more owner for this contract
95         owner = address(0);
96 
97         wallet = _wallet;
98         support = _support;
99     }
100 
101     function() payable public {
102         invest(0);
103     }
104 
105     function invest(uint256 _refLink) public payable returns (uint256) {
106         require(msg.value >= minimum);
107         address _investor = msg.sender;
108         uint256 currentDay = now;
109         if (currentDay < 1542240000) { //Thu, 15 Nov 2018 00:00:00 GMT
110             revert();
111         }
112         if (investments[_investor] == 0) {
113             countInvestor = countInvestor.add(1);
114         }
115         if (investments[_investor] > 0){
116             withdrawProfit();
117         }
118         investments[_investor] = investments[_investor].add(msg.value);
119         joined[_investor] = currentDay;
120         amountWeiRaised = amountWeiRaised.add(msg.value);
121         lastInvestment = msg.value;
122         lastInvestmentTime = currentDay;
123         lastInvestorAddress = _investor;
124         if (_refLink > 100) {
125             makeReferrerProfit(_refLink);
126         } else {
127             support.transfer(msg.value.mul(10).div(100)); //test's
128         }
129 
130         wallet.transfer(msg.value.mul(10).div(100)); //test's
131         emit Invest(_investor, msg.value);
132         return _refLink;
133     }
134 
135     function getBalance(address _address) view public returns (uint256 _result) {
136         _result = 0;
137         if (investments[_address] > 0) {
138             uint256 currentDay = now;
139             uint256 minutesCount = currentDay.sub(joined[_address]).div(1 minutes);
140             uint256 daysAfter = minutesCount.div(1440);
141             if (daysAfter > DAYS_PROFIT) {
142                 daysAfter = DAYS_PROFIT;
143             }
144             uint256 percent = investments[_address].mul(percentDay).div(10000);
145             uint256 different = percent.mul(daysAfter);
146             if (different > withdrawals[_address]) {
147                 _result = different.sub(withdrawals[_address]);
148                 _result = different;
149             }
150         }
151     }
152 
153     function withdrawProfit() public returns (uint256 _result){
154         address _address = msg.sender;
155         require(joined[msg.sender] > 0);
156         _result = getBalance(_address);
157         if (address(this).balance > _result){
158             if (_result > 0){
159                 withdrawals[_address] = withdrawals[_address].add(_result);
160                 _address.transfer(_result); //test's
161                 emit Withdraw(_address, _result);
162             }
163         }
164     }
165 
166     function getMyDeposit() public returns (uint256 _result){
167         address _address = msg.sender;
168         require(joined[_address] > 0);
169         _result = 0;
170         uint256 currentDay = now;
171         uint256 daysCount = currentDay.sub(joined[_address]).div(1 days);
172         require(daysCount > DAYS_PROFIT);
173 
174         uint256 profit = getBalance(_address);
175         uint256 myDeposit = investments[_address];
176         uint256 depositAndProfit = myDeposit.add(profit);
177         require(depositAndProfit >= 0);
178         if (address(this).balance > depositAndProfit) {
179             withdrawals[_address] = 0;
180             investments[_address] = 0;
181             joined[_address] = 0;
182             _address.transfer(depositAndProfit); //test's
183             emit Withdraw(_address, depositAndProfit);
184             _result = depositAndProfit;
185         }
186     }
187 
188     function makeReferrerProfit(uint256 _referralLink) public payable {
189         address referral = msg.sender;
190         address referrer = refLinkToAddress[_referralLink];
191         require(referrer != address(0));
192         uint256 profitReferrer = 0;
193         if (msg.value > 0) {
194             profitReferrer = msg.value.mul(10).div(100);
195             referrerBalance[referrer] = referrerBalance[referrer].add(profitReferrer);
196             emit ReferrerProfit(referrer, referral, profitReferrer);
197         }
198     }
199 
200     function getMyReferrerProfit() public returns (uint256 _result){
201         address _address = msg.sender;
202         require(joined[_address] > 0);
203         _result = checkReferrerBalance(_address);
204 
205         require(_result >= minimum);
206         if (address(this).balance > _result) {
207             referrerBalance[_address] = 0;
208             _address.transfer(_result);
209             emit ReferrerWithdraw(_address, _result);
210         }
211     }
212 
213     function makeReferralLink() public returns (uint256 _result){
214         address _address = msg.sender;
215 
216         if (refAddressToLink[_address] == 0) {
217             countReferralLink = countReferralLink.add(1);
218             refLinkToAddress[countReferralLink] = _address;
219             refAddressToLink[_address] = countReferralLink;
220             _result = countReferralLink;
221             emit MakeReferralLink(_address, _result);
222         } else {
223             _result = refAddressToLink[_address];
224         }
225     }
226 
227     function getReferralLink() public view returns (uint256){
228         return refAddressToLink[msg.sender];
229     }
230 
231     function checkReferrerBalance(address _hunter) public view returns (uint256) {
232         return referrerBalance[_hunter];
233     }
234 
235     function checkBalance() public view returns (uint256) {
236         return getBalance(msg.sender);
237     }
238 
239     function checkWithdrawals(address _investor) public view returns (uint256) {
240         return withdrawals[_investor];
241     }
242 
243     function checkInvestments(address _investor) public view returns (uint256) {
244         return investments[_investor];
245     }
246 }