1 pragma solidity ^0.4.18;
2 
3 // Created by LLC "Uinkey" bearchik@gmail.com
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 interface ManagedToken{
30     function setLock(bool _newLockState) public returns (bool success);
31     function mint(address _for, uint256 _amount) public returns (bool success);
32     function demint(address _for, uint256 _amount) public returns (bool success);
33     function decimals() view public returns (uint8 decDigits);
34     function totalSupply() view public returns (uint256 supply);
35     function balanceOf(address _owner) view public returns (uint256 balance);
36 }
37   
38 contract HardcodedCrowdsale {
39     using SafeMath for uint256;
40 
41     //global definisions
42 
43     enum ICOStateEnum {NotStarted, Started, Refunded, Successful}
44 
45     address public owner = msg.sender;
46     ManagedToken public managedTokenLedger;
47 
48     string public name = "Coinplace";
49     string public symbol = "CPL";
50 
51     bool public halted = false;
52      
53     uint256 public minTokensToBuy = 100;
54     
55     uint256 public ICOcontributors = 0;
56 
57     uint256 public ICOstart = 1521518400; //20 Mar 2018 13:00:00 GMT+9
58     uint256 public ICOend = 1526857200; // 20 May 2018 13:00:00 GMT+9
59     uint256 public Hardcap = 20000 ether; 
60     uint256 public ICOcollected = 0;
61     uint256 public Softcap = 200 ether;
62     uint256 public ICOtokensSold = 0;
63     uint256 public TakedFunds = 0;
64     ICOStateEnum public ICOstate = ICOStateEnum.NotStarted;
65     
66     uint8 public decimals = 9;
67     uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);
68  
69     uint256 public ICOprice = uint256(1 ether).div(1000);
70     uint256[4] public ICOamountBonusLimits = [5 ether, 20 ether, 50 ether, 200 ether];
71     uint256[4] public ICOamountBonusMultipierInPercent = [103, 105, 107, 110]; // count bonus
72     uint256[5] public ICOweekBonus = [130, 125, 120, 115, 110]; // time bonus
73 
74     mapping(address => uint256) public weiForRefundICO;
75 
76     mapping(address => uint256) public weiToRecoverICO;
77 
78     mapping(address => uint256) public balancesForICO;
79 
80     event Purchased(address indexed _from, uint256 _value);
81 
82     function advanceState() public returns (bool success) {
83         transitionState();
84         return true;
85     }
86 
87     function transitionState() internal {
88         if (now >= ICOstart) {
89             if (ICOstate == ICOStateEnum.NotStarted) {
90                 ICOstate = ICOStateEnum.Started;
91             }
92             if (Hardcap > 0 && ICOcollected >= Hardcap) {
93                 ICOstate = ICOStateEnum.Successful;
94             }
95         } if (now >= ICOend) {
96             if (ICOstate == ICOStateEnum.Started) {
97                 if (ICOcollected >= Softcap) {
98                     ICOstate = ICOStateEnum.Successful;
99                 } else {
100                     ICOstate = ICOStateEnum.Refunded;
101                 }
102             }
103         } 
104     }
105 
106     modifier stateTransition() {
107         transitionState();
108         _;
109         transitionState();
110     }
111 
112     modifier notHalted() {
113         require(!halted);
114         _;
115     }
116 
117     // Ownership
118 
119     event OwnershipTransferred(address indexed viousOwner, address indexed newOwner);
120 
121     modifier onlyOwner() {
122         require(msg.sender == owner);
123         _;
124     }
125 
126     function transferOwnership(address newOwner) public onlyOwner {
127         require(newOwner != address(0));      
128         OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130     }
131 
132     function balanceOf(address _owner) view public returns (uint256 balance) {
133         return managedTokenLedger.balanceOf(_owner);
134     }
135 
136     function totalSupply() view public returns (uint256 balance) {
137         return managedTokenLedger.totalSupply();
138     }
139 
140 
141     function HardcodedCrowdsale (address _newLedgerAddress) public {
142         require(_newLedgerAddress != address(0));
143         managedTokenLedger = ManagedToken(_newLedgerAddress);
144         assert(managedTokenLedger.decimals() == decimals);
145     }
146 
147     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
148         require(bytes(_name).length > 1);
149         require(bytes(_symbol).length > 1);
150         name = _name;
151         symbol = _symbol;
152         return true;
153     }
154 
155     function setLedger (address _newLedgerAddress) onlyOwner public returns (bool success) {
156         require(_newLedgerAddress != address(0));
157         managedTokenLedger = ManagedToken(_newLedgerAddress);
158         assert(managedTokenLedger.decimals() == decimals);
159         return true;
160     }
161 
162     function () payable stateTransition notHalted external {
163         require(msg.value > 0);
164         require(ICOstate == ICOStateEnum.Started);
165         assert(ICOBuy());
166     }
167 
168     
169     function finalize() stateTransition public returns (bool success) {
170         require(ICOstate == ICOStateEnum.Successful);
171         owner.transfer(ICOcollected - TakedFunds);
172         return true;
173     }
174 
175     function setHalt(bool _halt) onlyOwner public returns (bool success) {
176         halted = _halt;
177         return true;
178     }
179 
180     function calculateAmountBoughtICO(uint256 _weisSentScaled, uint256 _amountBonusMultiplier) 
181         internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {
182         uint256 value = _weisSentScaled;
183         uint256 totalPurchased = 0;
184         
185         totalPurchased = value.div(ICOprice);
186 	    uint256 weekbonus = getWeekBonus(totalPurchased).sub(totalPurchased);
187 	    uint256 forThisRate = totalPurchased.mul(_amountBonusMultiplier).div(100).sub(totalPurchased);
188 	    value = _weisSentScaled.sub(totalPurchased.mul(ICOprice));
189         totalPurchased = totalPurchased.add(forThisRate).add(weekbonus);
190         
191         
192         return (totalPurchased, value);
193     }
194 
195     function getBonusMultipierInPercents(uint256 _sentAmount) public view returns (uint256 _multi) {
196         uint256 bonusMultiplier = 100;
197         for (uint8 i = 0; i < ICOamountBonusLimits.length; i++) {
198             if (_sentAmount < ICOamountBonusLimits[i]) {
199                 break;
200             } else {
201                 bonusMultiplier = ICOamountBonusMultipierInPercent[i];
202             }
203         }
204         return bonusMultiplier;
205     }
206     
207     function getWeekBonus(uint256 amountTokens) internal view returns(uint256 count) {
208         uint256 countCoints = 0;
209         uint256 bonusMultiplier = 100;
210         if(block.timestamp <= (ICOstart + 1 weeks)) {
211             countCoints = amountTokens.mul(ICOweekBonus[0] );
212         } else if (block.timestamp <= (ICOstart + 2 weeks) && block.timestamp <= (ICOstart + 3 weeks)) {
213             countCoints = amountTokens.mul(ICOweekBonus[1] );
214         } else if (block.timestamp <= (ICOstart + 4 weeks) && block.timestamp <= (ICOstart + 5 weeks)) {
215             countCoints = amountTokens.mul(ICOweekBonus[2] );
216         } else if (block.timestamp <= (ICOstart + 6 weeks) && block.timestamp <= (ICOstart + 7 weeks)) {
217             countCoints = amountTokens.mul(ICOweekBonus[3] );
218         } else {
219             countCoints = amountTokens.mul(ICOweekBonus[4] );
220         }
221         return countCoints.div(bonusMultiplier);
222     }
223 
224     function ICOBuy() internal notHalted returns (bool success) {
225         uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);
226         address _for = msg.sender;
227         uint256 amountBonus = getBonusMultipierInPercents(msg.value);
228         var (tokensBought, fundsLeftScaled) = calculateAmountBoughtICO(weisSentScaled, amountBonus);
229         if (tokensBought < minTokensToBuy.mul(DECIMAL_MULTIPLIER)) {
230             revert();
231         }
232         uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);
233         uint256 totalSpent = msg.value.sub(fundsLeft);
234         if (balanceOf(_for) == 0) {
235             ICOcontributors = ICOcontributors + 1;
236         }
237         managedTokenLedger.mint(_for, tokensBought);
238         balancesForICO[_for] = balancesForICO[_for].add(tokensBought);
239         weiForRefundICO[_for] = weiForRefundICO[_for].add(totalSpent);
240         weiToRecoverICO[_for] = weiToRecoverICO[_for].add(fundsLeft);
241         Purchased(_for, tokensBought);
242         ICOcollected = ICOcollected.add(totalSpent);
243         ICOtokensSold = ICOtokensSold.add(tokensBought);
244         return true;
245     }
246 
247     function recoverLeftoversICO() stateTransition notHalted public returns (bool success) {
248         require(ICOstate != ICOStateEnum.NotStarted);
249         uint256 value = weiToRecoverICO[msg.sender];
250         delete weiToRecoverICO[msg.sender];
251         msg.sender.transfer(value);
252         return true;
253     }
254 
255     function refundICO() stateTransition notHalted public returns (bool success) {
256         require(ICOstate == ICOStateEnum.Refunded);
257         uint256 value = weiForRefundICO[msg.sender];
258         delete weiForRefundICO[msg.sender];
259         uint256 tokenValue = balancesForICO[msg.sender];
260         delete balancesForICO[msg.sender];
261         managedTokenLedger.demint(msg.sender, tokenValue);
262         msg.sender.transfer(value);
263         return true;
264     }
265     
266     function withdrawFunds() onlyOwner public returns (bool success) {
267         require(Softcap <= ICOcollected);
268         owner.transfer(ICOcollected - TakedFunds);
269         TakedFunds = ICOcollected;
270         return true;
271     }
272     
273     function manualSendTokens(address rAddress, uint256 amount) onlyOwner public returns (bool success) {
274         managedTokenLedger.mint(rAddress, amount);
275         balancesForICO[rAddress] = balancesForICO[rAddress].add(amount);
276         Purchased(rAddress, amount);
277         ICOtokensSold = ICOtokensSold.add(amount);
278         return true;
279     } 
280 
281     function cleanup() onlyOwner public {
282         selfdestruct(owner);
283     }
284 
285 }