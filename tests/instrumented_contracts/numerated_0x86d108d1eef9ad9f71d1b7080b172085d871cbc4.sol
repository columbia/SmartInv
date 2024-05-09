1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     function transfer(address _to, uint _value) public returns(bool);
5     function burn(uint _value) public;
6     function balanceOf(address _owner) view public returns(uint);
7     function decimals() view public returns(uint8);
8     function transferOwnership(address _newOwner) public;
9 }
10 
11 library SafeMath {
12     function add(uint _a, uint _b) internal pure returns(uint) {
13         uint c = _a + _b;
14         assert(c >= _a);
15         return c;
16     }
17 
18     function mul(uint _a, uint _b) internal pure returns(uint) {
19         if (_a == 0) {
20           return 0;
21         }
22         uint c = _a * _b;
23         assert(c / _a == _b);
24         return c;
25     }
26 
27     function div(uint _a, uint _b) internal pure returns(uint) {
28         return _a / _b;
29     }
30 
31     function sub(uint _a, uint _b) internal pure returns (uint) {
32         assert(_b <= _a);
33         return _a - _b;
34     }
35 }
36 
37 contract Owned {
38     address public contractOwner;
39     address public pendingContractOwner;
40 
41     event LogContractOwnershipChangeInitiated(address to);
42     event LogContractOwnershipChangeCompleted(address to);
43 
44     function Owned() public {
45         contractOwner = msg.sender;
46     }
47 
48     modifier onlyContractOwner() {
49         require(contractOwner == msg.sender);
50         _;
51     }
52 
53     function changeContractOwnership(address _to) onlyContractOwner() public returns(bool) {
54         pendingContractOwner = _to;
55         LogContractOwnershipChangeInitiated(_to);
56         return true;
57     }
58 
59     function claimContractOwnership() public returns(bool) {
60         if (pendingContractOwner != msg.sender) {
61             return false;
62         }
63         contractOwner = pendingContractOwner;
64         delete pendingContractOwner;
65         LogContractOwnershipChangeCompleted(contractOwner);
66         return true;
67     }
68 
69     function forceChangeContractOwnership(address _to) onlyContractOwner() public returns(bool) {
70         contractOwner = _to;
71         LogContractOwnershipChangeCompleted(contractOwner);
72         return true;
73     }
74 }
75 
76 contract NeuroSale is Owned {
77     using SafeMath for uint;
78 
79     mapping(address => uint) public totalSpentEth;
80     mapping(address => uint) public totalTokensWithoutBonuses;
81     mapping(address => uint) public volumeBonusesTokens;
82 
83     uint public constant TOKEN_PRICE = 0.001 ether;
84     uint public constant MULTIPLIER = uint(10) ** uint(18);
85     uint public salesStart;
86     uint public salesDeadline;
87     Token public token;
88     address public wallet;
89     bool public salePaused;
90 
91     event LogBought(address indexed receiver, uint contribution, uint reward, uint128 customerId);
92     event LogPaused(bool isPaused);
93     event LogWalletUpdated(address to);
94 
95     modifier notPaused() {
96         require(!salePaused);
97         _;
98     }
99 
100     // Can be iniitialized only once.
101     function init(Token _token, address _wallet, uint _start, uint _deadline) onlyContractOwner() public returns(bool) {
102         require(address(token) == 0);
103         require(_wallet != 0);
104         token = _token;
105         wallet = _wallet;
106         salesStart = _start;
107         salesDeadline = _deadline;
108         return true;
109     }
110 
111     function setSalePause(bool _value) onlyContractOwner() public returns(bool) {
112         salePaused = _value;
113         LogPaused(_value);
114         return true;
115     }
116 
117     function setWallet(address _wallet) onlyContractOwner() public returns(bool) {
118         require(_wallet != 0);
119         wallet = _wallet;
120         LogWalletUpdated(_wallet);
121         return true;
122     }
123 
124     function transferOwnership() onlyContractOwner() public returns(bool) {
125         token.transferOwnership(contractOwner);
126         return true;
127     }
128 
129     function burnUnsold() onlyContractOwner() public returns(bool) {
130         uint tokensToBurn = token.balanceOf(address(this));
131         token.burn(tokensToBurn);
132         return true;
133     }
134 
135     function buy() payable notPaused() public returns(bool) {
136         require(now >= salesStart);
137         require(now < salesDeadline);
138 
139         // Overflow is impossible because amounts are calculated based on actual ETH being sent.
140         // There is no division remainder.
141         uint tokensToBuy = msg.value * MULTIPLIER / TOKEN_PRICE;
142         require(tokensToBuy > 0);
143         uint timeBonus = _calculateTimeBonus(tokensToBuy, now);
144         uint volumeBonus = _calculateVolumeBonus(tokensToBuy, msg.sender, msg.value);
145         // Overflow is impossible because amounts are calculated based on actual ETH being sent.
146         uint totalTokensToTransfer = tokensToBuy + timeBonus + volumeBonus;
147         require(token.transfer(msg.sender, totalTokensToTransfer));
148         LogBought(msg.sender, msg.value, totalTokensToTransfer, 0);
149         // Call is performed as the last action, no threats.
150         require(wallet.call.value(msg.value)());
151         return true;
152     }
153 
154     function buyWithCustomerId(address _beneficiary, uint _value, uint _amount, uint128 _customerId, uint _date, bool _autobonus) onlyContractOwner() public returns(bool) {
155         uint totalTokensToTransfer;
156         uint volumeBonus;
157 
158         if (_autobonus) {
159             uint tokensToBuy = _value.mul(MULTIPLIER).div(TOKEN_PRICE);
160             require(tokensToBuy > 0);
161             uint timeBonus = _calculateTimeBonus(tokensToBuy, _date);
162             volumeBonus = _calculateVolumeBonus(tokensToBuy, _beneficiary, _value);
163             // Overflow is possible because value is specified in the input.
164             totalTokensToTransfer = tokensToBuy.add(timeBonus).add(volumeBonus);
165         } else {
166             totalTokensToTransfer = _amount;
167         }
168 
169         require(token.transfer(_beneficiary, totalTokensToTransfer));
170         LogBought(_beneficiary, _value, totalTokensToTransfer, _customerId);
171         return true;
172     }
173 
174     function _calculateTimeBonus(uint _value, uint _date) view internal returns(uint) {
175         // Overflows are possible because value is specified in the input.
176         if (_date < salesStart) {
177             return 0;
178         }
179         // between 07.01.2018 00:00:00 UTC and 14.01.2018 00:00:00 UTC +15%
180         if (_date < salesStart + 1 weeks) {
181             return _value.mul(150).div(1000);
182         }
183         // between 14.01.2018 00:00:00 UTC and 21.01.2018 00:00:00 UTC +10%
184         if (_date < salesStart + 2 weeks) {
185             return _value.mul(100).div(1000);
186         }
187         // between 21.01.2018 00:00:00 UTC and 28.01.2018 00:00:00 UTC +7%
188         if (_date < salesStart + 3 weeks) {
189             return _value.mul(70).div(1000);
190         }
191         // between 28.01.2018 00:00:00 UTC and 04.02.2018 00:00:00 UTC +4%
192         if (_date < salesStart + 4 weeks) {
193             return _value.mul(40).div(1000);
194         }
195         // between 04.02.2018 00:00:00 UTC and 11.02.2018 00:00:00 UTC +2%
196         if (_date < salesStart + 5 weeks) {
197             return _value.mul(20).div(1000);
198         }
199         // between 11.02.2018 00:00:00 UTC and 15.02.2018 23:59:59 UTC +1%
200         if (_date < salesDeadline) {
201             return _value.mul(10).div(1000);
202         }
203 
204         return 0;
205     }
206 
207     function _calculateVolumeBonus(uint _amount, address _receiver, uint _value) internal returns(uint) {
208         // Overflows are possible because amount and value are specified in the input.
209         uint totalCollected = totalTokensWithoutBonuses[_receiver].add(_amount);
210         uint totalEth = totalSpentEth[_receiver].add(_value);
211         uint totalBonus;
212 
213         if (totalEth < 30 ether) {
214             totalBonus = 0;
215         } else if (totalEth < 50 ether) {
216             totalBonus = totalCollected.mul(10).div(1000);
217         } else if (totalEth < 100 ether) {
218             totalBonus = totalCollected.mul(25).div(1000);
219         } else if (totalEth < 300 ether) {
220             totalBonus = totalCollected.mul(50).div(1000);
221         } else if (totalEth < 500 ether) {
222             totalBonus = totalCollected.mul(80).div(1000);
223         } else if (totalEth < 1000 ether) {
224             totalBonus = totalCollected.mul(150).div(1000);
225         } else if (totalEth < 2000 ether) {
226             totalBonus = totalCollected.mul(200).div(1000);
227         } else if (totalEth < 3000 ether) {
228             totalBonus = totalCollected.mul(300).div(1000);
229         } else if (totalEth >= 3000 ether) {
230             totalBonus = totalCollected.mul(400).div(1000);
231         }
232 
233         // Overflow is impossible because totalBonus is always >= volumeBonusesTokens[_receiver];
234         uint bonusToPay = totalBonus - volumeBonusesTokens[_receiver];
235         volumeBonusesTokens[_receiver] = totalBonus;
236 
237         totalSpentEth[_receiver] = totalEth;
238         totalTokensWithoutBonuses[_receiver] = totalCollected;
239         return bonusToPay;
240     }
241 
242     function () payable public {
243         buy();
244     }
245 
246     // In case somebody sends tokens here.
247     function recoverTokens(Token _token, uint _amount) onlyContractOwner() public returns(bool) {
248         return _token.transfer(contractOwner, _amount);
249     }
250 }