1 pragma solidity ^0.4.18;
2 
3 //Contract By Yoav Taieb. yoav.iosdev@gmail.com
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
29 interface LikaToken {
30     function setLock(bool _newLockState) external returns (bool success);
31     function mint(address _for, uint256 _amount) external returns (bool success);
32     function demint(address _for, uint256 _amount) external returns (bool success);
33     function decimals() view external returns (uint8 decDigits);
34     function totalSupply() view external returns (uint256 supply);
35     function balanceOf(address _owner) view external returns (uint256 balance);
36 }
37 
38 contract LikaCrowdsale {
39     using SafeMath for uint256;
40     //global definisions
41     enum ICOStateEnum {NotStarted, Started, Refunded, Successful}
42 
43     address public owner = msg.sender;
44 
45     LikaToken public managedTokenLedger;
46 
47     string public name = "Lika";
48     string public symbol = "LIK";
49 
50     bool public halted = false;
51 
52     uint256 public minTokensToBuy = 100;
53 
54     uint256 public ICOcontributors = 0;
55 
56     uint256 public ICOstart = 1526947200; //17 May 1018 00:00:00 GMT
57     uint256 public ICOend = 1529884800; // 17 June 2018 00:00:00 GMT
58     uint256 public Hardcap = 2000 ether;
59     uint256 public ICOcollected = 0;
60     uint256 public Softcap = 200 ether;
61     uint256 public ICOtokensSold = 0;
62     uint256 public TakedFunds = 0;
63 
64     uint256 public bonusState = 0;
65 
66     ICOStateEnum public ICOstate = ICOStateEnum.NotStarted;
67 
68     uint8 public decimals = 18;
69     uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);
70 
71     uint256 public ICOprice = uint256(12 ether).div(100000);
72     uint256[4] public ICOamountBonusLimits = [5 ether, 20 ether, 50 ether, 200 ether];
73     uint256[4] public ICOamountBonusMultipierInPercent = [103, 105, 107, 110]; // count bonus
74     uint256[5] public ICOweekBonus = [152, 117, 110, 105, 102]; // time bonus
75 
76     mapping(address => uint256) public weiForRefundICO;
77 
78     mapping(address => uint256) public weiToRecoverICO;
79 
80     mapping(address => uint256) public balancesForICO;
81 
82     event Purchased(address indexed _from, uint256 _value);
83 
84     function advanceState() public returns (bool success) {
85         transitionState();
86         return true;
87     }
88 
89     function transitionState() internal {
90 
91       if (now >= ICOstart) {
92             if (ICOstate == ICOStateEnum.NotStarted) {
93                 ICOstate = ICOStateEnum.Started;
94             }
95             if (Hardcap > 0 && ICOcollected >= Hardcap) {
96                 ICOstate = ICOStateEnum.Successful;
97             }
98         } if (now >= ICOend) {
99             if (ICOstate == ICOStateEnum.Started) {
100                 if (ICOcollected >= Softcap) {
101                     ICOstate = ICOStateEnum.Successful;
102                 } else {
103                     ICOstate = ICOStateEnum.Refunded;
104                 }
105              }
106          }
107      }
108 
109     modifier stateTransition() {
110         transitionState();
111         _;
112         transitionState();
113     }
114 
115     modifier notHalted() {
116         require(!halted);
117         _;
118     }
119 
120     // Ownership
121 
122     event OwnershipTransferred(address indexed viousOwner, address indexed newOwner);
123 
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128 
129     function transferOwnership(address newOwner) public onlyOwner {
130         require(newOwner != address(0));
131         emit OwnershipTransferred(owner, newOwner);
132         owner = newOwner;
133     }
134 
135     function balanceOf(address _owner) view public returns (uint256 balance) {
136         return managedTokenLedger.balanceOf(_owner);
137     }
138 
139     function totalSupply() view public returns (uint256 balance) {
140         return managedTokenLedger.totalSupply();
141     }
142 
143 
144     constructor(address _newLedgerAddress) public {
145         require(_newLedgerAddress != address(0));
146         managedTokenLedger = LikaToken(_newLedgerAddress);
147     }
148 
149     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
150         require(bytes(_name).length > 1);
151         require(bytes(_symbol).length > 1);
152         name = _name;
153         symbol = _symbol;
154         return true;
155     }
156 
157     function setBonusState(uint256 _newState) onlyOwner public returns (bool success){
158        bonusState = _newState;
159        return true;
160     }
161 
162 
163     function setLedger(address _newLedgerAddress) onlyOwner public returns (bool success) {
164         require(_newLedgerAddress != address(0));
165         managedTokenLedger = LikaToken(_newLedgerAddress);
166         return true;
167     }
168 
169 
170     function () public payable stateTransition notHalted {
171         require(msg.value > 0);
172         require(ICOstate == ICOStateEnum.Started);
173         assert(ICOBuy());
174     }
175 
176     function finalize() stateTransition public returns (bool success) {
177         require(ICOstate == ICOStateEnum.Successful);
178         owner.transfer(ICOcollected - TakedFunds);
179         return true;
180     }
181 
182     function setHalt(bool _halt) onlyOwner public returns (bool success) {
183         halted = _halt;
184         return true;
185     }
186 
187     function calculateAmountBoughtICO(uint256 _weisSentScaled, uint256 _amountBonusMultiplier)
188         view internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {
189         uint256 value = _weisSentScaled;
190         uint256 totalPurchased = 0;
191 
192       totalPurchased = value.div(ICOprice);
193 	    uint256 weekbonus = getWeekBonus(totalPurchased).sub(totalPurchased);
194 	    uint256 forThisRate = totalPurchased.mul(_amountBonusMultiplier).div(100).sub(totalPurchased);
195 	    value = _weisSentScaled.sub(totalPurchased.mul(ICOprice));
196       totalPurchased = totalPurchased.add(forThisRate).add(weekbonus);
197 
198       return (totalPurchased, value);
199     }
200 
201     function getBonusMultipierInPercents(uint256 _sentAmount) public view returns (uint256 _multi) {
202         uint256 bonusMultiplier = 100;
203         for (uint8 i = 0; i < ICOamountBonusLimits.length; i++) {
204             if (_sentAmount < ICOamountBonusLimits[i]) {
205                 break;
206             } else {
207                 bonusMultiplier = ICOamountBonusMultipierInPercent[i];
208             }
209         }
210         return bonusMultiplier;
211     }
212 
213     function getWeekBonus(uint256 amountTokens) internal view returns(uint256 count) {
214         uint256 countCoints = 0;
215         uint256 bonusMultiplier = 100;
216 
217         //You can check the current Bonus State on www.LikaCoin.io
218 
219         if (bonusState == 0) {
220            countCoints = amountTokens.mul(ICOweekBonus[0]);
221         } else if (bonusState == 1) {
222            countCoints = amountTokens.mul(ICOweekBonus[1] );
223         } else if (bonusState == 2) {
224           countCoints = amountTokens.mul(ICOweekBonus[2] );
225         } else if (bonusState == 3) {
226           countCoints = amountTokens.mul(ICOweekBonus[3] );
227         }else {
228           countCoints = amountTokens.mul(ICOweekBonus[3] );
229         }
230 
231         return countCoints.div(bonusMultiplier);
232     }
233 
234     function ICOBuy() internal notHalted returns (bool success) {
235         uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);
236         address _for = msg.sender;
237         uint256 amountBonus = getBonusMultipierInPercents(msg.value);
238         uint256 tokensBought;
239         uint256 fundsLeftScaled;
240         (tokensBought, fundsLeftScaled) = calculateAmountBoughtICO(weisSentScaled, amountBonus);
241         if (tokensBought < minTokensToBuy.mul(DECIMAL_MULTIPLIER)) {
242             revert();
243         }
244         uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);
245         uint256 totalSpent = msg.value.sub(fundsLeft);
246         if (balanceOf(_for) == 0) {
247             ICOcontributors = ICOcontributors + 1;
248         }
249         managedTokenLedger.mint(_for, tokensBought);
250         balancesForICO[_for] = balancesForICO[_for].add(tokensBought);
251         weiForRefundICO[_for] = weiForRefundICO[_for].add(totalSpent);
252         weiToRecoverICO[_for] = weiToRecoverICO[_for].add(fundsLeft);
253         emit Purchased(_for, tokensBought);
254         ICOcollected = ICOcollected.add(totalSpent);
255         ICOtokensSold = ICOtokensSold.add(tokensBought);
256         return true;
257    }
258 
259     function recoverLeftoversICO() stateTransition notHalted public returns (bool success) {
260         require(ICOstate != ICOStateEnum.NotStarted);
261         uint256 value = weiToRecoverICO[msg.sender];
262         delete weiToRecoverICO[msg.sender];
263         msg.sender.transfer(value);
264         return true;
265     }
266 
267     function refundICO(address refundAdress) stateTransition notHalted onlyOwner public returns (bool success) {
268         require(ICOstate == ICOStateEnum.Refunded);
269         uint256 value = weiForRefundICO[refundAdress];
270         delete weiForRefundICO[refundAdress];
271         uint256 tokenValue = balancesForICO[refundAdress];
272         delete balancesForICO[refundAdress];
273         managedTokenLedger.demint(refundAdress, tokenValue);
274         refundAdress.transfer(value);
275         return true;
276     }
277 
278     function withdrawFunds() onlyOwner public returns (bool success) {
279         require(Softcap <= ICOcollected);
280         owner.transfer(ICOcollected - TakedFunds);
281         TakedFunds = ICOcollected;
282         return true;
283     }
284 
285     function setSoftCap(uint256 _newSoftCap) onlyOwner public returns (bool success) {
286        Softcap = _newSoftCap;
287        return true;
288     }
289 
290     function setHardCap(uint256 _newHardCap) onlyOwner public returns (bool success) {
291        Hardcap = _newHardCap;
292        return true;
293     }
294 
295     function setEndDate(uint256 _newEndDate) onlyOwner public returns (bool success) {
296           ICOend = _newEndDate;
297           return true;
298     }
299 
300 
301     function manualSendTokens(address rAddress, uint256 amount) onlyOwner public returns (bool success) {
302         managedTokenLedger.mint(rAddress, amount);
303         balancesForICO[rAddress] = balancesForICO[rAddress].add(amount);
304         emit Purchased(rAddress, amount);
305         ICOtokensSold = ICOtokensSold.add(amount);
306         return true;
307     }
308 
309 }