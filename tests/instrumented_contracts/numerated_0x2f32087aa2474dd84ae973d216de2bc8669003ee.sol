1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 interface ManagedToken{
28     function setLock(bool _newLockState) public returns (bool success);
29     function mint(address _for, uint256 _amount) public returns (bool success);
30     function demint(address _for, uint256 _amount) public returns (bool success);
31     function decimals() view public returns (uint8 decDigits);
32     function totalSupply() view public returns (uint256 supply);
33     function balanceOf(address _owner) view public returns (uint256 balance);
34 }
35   
36 contract HardcodedCrowdsale {
37     using SafeMath for uint256;
38 
39     //global definisions
40 
41     enum ICOStateEnum {NotStarted, Started, Refunded, Successful}
42 
43     address public owner = msg.sender;
44     ManagedToken public managedTokenLedger;
45 
46     string public name = "Tokensale of CPL";
47     string public symbol = "CPL";
48 
49     bool public halted = false;
50      
51     uint256 public minTokensToBuy = 10;
52     
53     uint256 public preICOcontributors = 0;
54 
55     uint256 public preICOstart;
56     uint256 public preICOend;
57     uint256 public preICOgoal;
58     uint256 public preICOcollected = 0;
59     uint256 public preICOcap = 0 ether;
60     uint256 public preICOtokensSold = 0;
61     ICOStateEnum public preICOstate = ICOStateEnum.NotStarted;
62     
63     uint8 public decimals = 9;
64     uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);
65 
66     uint8 public saleIndex = 0;
67  
68     uint256 public preICOprice = uint256(1 ether).div(1000);
69     uint256[3] public preICObonusMultipiersInPercent = [150, 145, 140];
70     uint256[3] public preICOcoinsLeft = [1000000*DECIMAL_MULTIPLIER, 1000000*DECIMAL_MULTIPLIER, 1000000*DECIMAL_MULTIPLIER];
71     uint256 public totalPreICOavailibleWithBonus = 4350000*DECIMAL_MULTIPLIER; 
72     uint256 public maxIssuedWithAmountBasedBonus = 4650000*DECIMAL_MULTIPLIER; 
73     uint256[4] public preICOamountBonusLimits = [5 ether, 20 ether, 50 ether, 300 ether];
74     uint256[4] public preICOamountBonusMultipierInPercent = [103, 105, 107, 110];
75 
76     mapping(address => uint256) public weiForRefundPreICO;
77 
78     mapping(address => uint256) public weiToRecoverPreICO;
79 
80     mapping(address => uint256) public balancesForPreICO;
81 
82     event Purchased(address indexed _from, uint256 _value);
83 
84     function advanceState() public returns (bool success) {
85         transitionState();
86         return true;
87     }
88 
89     function transitionState() internal {
90         if (now >= preICOstart) {
91             if (preICOstate == ICOStateEnum.NotStarted) {
92                 preICOstate = ICOStateEnum.Started;
93             }
94             if (preICOcap > 0 && preICOcollected >= preICOcap) {
95                 preICOstate = ICOStateEnum.Successful;
96             }
97             if ( (saleIndex == preICOcoinsLeft.length) && (preICOcoinsLeft[saleIndex-1] == 0) ) {
98                 preICOstate = ICOStateEnum.Successful;
99             }
100         } if (now >= preICOend) {
101             if (preICOstate == ICOStateEnum.Started) {
102                 if (preICOcollected >= preICOgoal) {
103                     preICOstate = ICOStateEnum.Successful;
104                 } else {
105                     preICOstate = ICOStateEnum.Refunded;
106                 }
107             }
108         } 
109     }
110 
111     modifier stateTransition() {
112         transitionState();
113         _;
114         transitionState();
115     }
116 
117     modifier notHalted() {
118         require(!halted);
119         _;
120     }
121 
122     // Ownership
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     modifier onlyOwner() {
127         require(msg.sender == owner);
128         _;
129     }
130 
131     function transferOwnership(address newOwner) public onlyOwner {
132         require(newOwner != address(0));      
133         OwnershipTransferred(owner, newOwner);
134         owner = newOwner;
135     }
136 
137     function balanceOf(address _owner) view public returns (uint256 balance) {
138         return managedTokenLedger.balanceOf(_owner);
139     }
140 
141     function totalSupply() view public returns (uint256 balance) {
142         return managedTokenLedger.totalSupply();
143     }
144 
145 
146     function HardcodedCrowdsale (uint _preICOstart, uint _preICOend, uint _preICOgoal, uint _preICOcap, address _newLedgerAddress) public {
147         require(_preICOstart > now);
148         require(_preICOend > _preICOstart);
149         require(_preICOgoal > 0);
150         require(_newLedgerAddress != address(0));
151         preICOstart = _preICOstart;
152         preICOend = _preICOend;
153         preICOgoal = _preICOgoal;
154         preICOcap = _preICOcap;
155         managedTokenLedger = ManagedToken(_newLedgerAddress);
156         assert(managedTokenLedger.decimals() == decimals);
157     }
158 
159     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
160         require(bytes(_name).length > 1);
161         require(bytes(_symbol).length > 1);
162         name = _name;
163         symbol = _symbol;
164         return true;
165     }
166 
167     function setLedger (address _newLedgerAddress) onlyOwner public returns (bool success) {
168         require(_newLedgerAddress != address(0));
169         managedTokenLedger = ManagedToken(_newLedgerAddress);
170         assert(managedTokenLedger.decimals() == decimals);
171         return true;
172     }
173 
174     function () payable stateTransition notHalted external {
175         require(msg.value > 0);
176         require(preICOstate == ICOStateEnum.Started);
177         assert(preICOBuy());
178     }
179 
180     
181     function finalize() stateTransition public returns (bool success) {
182         require(preICOstate == ICOStateEnum.Successful);
183         owner.transfer(preICOcollected);
184         return true;
185     }
186 
187     function setHalt(bool _halt) onlyOwner public returns (bool success) {
188         halted = _halt;
189         return true;
190     }
191 
192     function calculateAmountBoughtPreICO(uint256 _weisSentScaled, uint256 _amountBonusMultiplier) 
193         internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {
194         uint256 value = _weisSentScaled;
195         uint256 totalPurchased = 0;
196         for (uint8 i = saleIndex; i < preICOcoinsLeft.length; i++) {
197             if (preICOcoinsLeft[i] == 0) {
198                 continue;
199             }
200             uint256 forThisRate = value.div(preICOprice);
201             if (forThisRate == 0) {
202                 break;
203             }
204             if (forThisRate >= preICOcoinsLeft[i]) {
205                 forThisRate = preICOcoinsLeft[i];
206                 preICOcoinsLeft[i] = 0;
207                 saleIndex = i+1;
208             } else {
209                 preICOcoinsLeft[i] = preICOcoinsLeft[i].sub(forThisRate);
210             }
211             uint256 consumed = forThisRate.mul(preICOprice);
212             value = value.sub(consumed);
213             forThisRate = forThisRate.mul(_amountBonusMultiplier.add(preICObonusMultipiersInPercent[i]).sub(100)).div(100);
214             totalPurchased = totalPurchased.add(forThisRate);
215         }
216         return (totalPurchased, value);
217     }
218 
219     function getBonusMultipierInPercents(uint256 _sentAmount) public view returns (uint256 _multi) {
220         uint256 bonusMultiplier = 100;
221         for (uint8 i = 0; i < preICOamountBonusLimits.length; i++) {
222             if (_sentAmount < preICOamountBonusLimits[i]) {
223                 break;
224             } else {
225                 bonusMultiplier = preICOamountBonusMultipierInPercent[i];
226             }
227         }
228         return bonusMultiplier;
229     }
230 
231     function preICOBuy() internal notHalted returns (bool success) {
232         uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);
233         address _for = msg.sender;
234         uint256 amountBonus = getBonusMultipierInPercents(msg.value);
235         var (tokensBought, fundsLeftScaled) = calculateAmountBoughtPreICO(weisSentScaled, amountBonus);
236         if (tokensBought < minTokensToBuy.mul(DECIMAL_MULTIPLIER)) {
237             revert();
238         }
239         uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);
240         uint256 totalSpent = msg.value.sub(fundsLeft);
241         if (balanceOf(_for) == 0) {
242             preICOcontributors = preICOcontributors + 1;
243         }
244         managedTokenLedger.mint(_for, tokensBought);
245         balancesForPreICO[_for] = balancesForPreICO[_for].add(tokensBought);
246         weiForRefundPreICO[_for] = weiForRefundPreICO[_for].add(totalSpent);
247         weiToRecoverPreICO[_for] = weiToRecoverPreICO[_for].add(fundsLeft);
248         Purchased(_for, tokensBought);
249         preICOcollected = preICOcollected.add(totalSpent);
250         preICOtokensSold = preICOtokensSold.add(tokensBought);
251         return true;
252     }
253 
254     function recoverLeftoversPreICO() stateTransition notHalted public returns (bool success) {
255         require(preICOstate != ICOStateEnum.NotStarted);
256         uint256 value = weiToRecoverPreICO[msg.sender];
257         delete weiToRecoverPreICO[msg.sender];
258         msg.sender.transfer(value);
259         return true;
260     }
261 
262     function refundPreICO() stateTransition notHalted public returns (bool success) {
263         require(preICOstate == ICOStateEnum.Refunded);
264         uint256 value = weiForRefundPreICO[msg.sender];
265         delete weiForRefundPreICO[msg.sender];
266         uint256 tokenValue = balancesForPreICO[msg.sender];
267         delete balancesForPreICO[msg.sender];
268         managedTokenLedger.demint(msg.sender, tokenValue);
269         msg.sender.transfer(value);
270         return true;
271     }
272 
273     function cleanup() onlyOwner public {
274         require(preICOstate == ICOStateEnum.Successful);
275         selfdestruct(owner);
276     }
277 
278 }