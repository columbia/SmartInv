1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
46     string public name = "Uservice Token";
47     string public symbol = "UST";
48 
49     bool public halted = false;
50      
51     uint256 public minWeiToBuy = 200000000000000000;          //  minimum 0.2 ETH to buy
52     
53     uint256 public preICOcontributors = 0;
54 
55     uint256 public preICOstart;
56     uint256 public preICOend;
57     uint256 public preICOgoal;
58     uint256 public preICOcollected = 0;
59     uint256 public preICOcap = 10000 ether;
60     uint256 public preICOtokensSold = 0;
61     ICOStateEnum public preICOstate = ICOStateEnum.NotStarted;
62     
63     uint8 public decimals = 18;
64     uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);
65 
66     uint8 public saleIndex = 0;
67  
68     uint256 public preICOprice = uint256(0.25 ether).div(1000);
69     uint256[3] public preICOcoinsLeft = [40000000*DECIMAL_MULTIPLIER, 0*DECIMAL_MULTIPLIER, 0*DECIMAL_MULTIPLIER];
70 
71     mapping(address => uint256) public weiForRefundPreICO;
72 
73     mapping(address => uint256) public weiToRecoverPreICO;
74 
75     mapping(address => uint256) public balancesForPreICO;
76 
77     event Purchased(address indexed _from, uint256 _value);
78 
79     function advanceState() public returns (bool success) {
80         transitionState();
81         return true;
82     }
83 
84     function transitionState() internal {
85         if (now >= preICOstart) {
86             if (preICOstate == ICOStateEnum.NotStarted) {
87                 preICOstate = ICOStateEnum.Started;
88             }
89             if (preICOcap > 0 && preICOcollected >= preICOcap) {
90                 preICOstate = ICOStateEnum.Successful;
91             }
92             if ( (saleIndex == preICOcoinsLeft.length) && (preICOcoinsLeft[saleIndex-1] == 0) ) {
93                 preICOstate = ICOStateEnum.Successful;
94             }
95         } if (now >= preICOend) {
96             if (preICOstate == ICOStateEnum.Started) {
97                 if (preICOcollected >= preICOgoal) {
98                     preICOstate = ICOStateEnum.Successful;
99                 } else {
100                     preICOstate = ICOStateEnum.Refunded;
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
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
141     function HardcodedCrowdsale (uint _preICOstart, uint _preICOend, uint _preICOgoal, uint _preICOcap, address _newLedgerAddress) public {
142 //        require(_preICOstart > now);
143         require(_preICOend > _preICOstart);
144         require(_preICOgoal > 0);
145         require(_newLedgerAddress != address(0));
146         preICOstart = _preICOstart;
147         preICOend = _preICOend;
148         preICOgoal = _preICOgoal;
149         preICOcap = _preICOcap;
150         managedTokenLedger = ManagedToken(_newLedgerAddress);
151         assert(managedTokenLedger.decimals() == decimals);
152     }
153 
154     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
155         require(bytes(_name).length > 1);
156         require(bytes(_symbol).length > 1);
157         name = _name;
158         symbol = _symbol;
159         return true;
160     }
161 
162     function setLedger (address _newLedgerAddress) onlyOwner public returns (bool success) {
163         require(_newLedgerAddress != address(0));
164         managedTokenLedger = ManagedToken(_newLedgerAddress);
165         assert(managedTokenLedger.decimals() == decimals);
166         return true;
167     }
168 
169     function () payable stateTransition notHalted external {
170         require(msg.value > 0);
171         require(preICOstate == ICOStateEnum.Started);
172         assert(preICOBuy());
173     }
174 
175     
176     function finalize() stateTransition public returns (bool success) {
177         require(preICOstate == ICOStateEnum.Successful);
178         owner.transfer(preICOcollected);
179         return true;
180     }
181 
182     function setHalt(bool _halt) onlyOwner public returns (bool success) {
183         halted = _halt;
184         return true;
185     }
186 
187     function calculateAmountBoughtPreICO(uint256 _weisSentScaled)
188         internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {
189         uint256 value = _weisSentScaled;
190         uint256 totalPurchased = 0;
191         for (uint8 i = saleIndex; i < preICOcoinsLeft.length; i++) {
192             if (preICOcoinsLeft[i] == 0) {
193                 continue;
194             }
195             uint256 forThisRate = value.div(preICOprice);
196             if (forThisRate == 0) {
197                 break;
198             }
199             if (forThisRate >= preICOcoinsLeft[i]) {
200                 forThisRate = preICOcoinsLeft[i];
201                 preICOcoinsLeft[i] = 0;
202                 saleIndex = i+1;
203             } else {
204                 preICOcoinsLeft[i] = preICOcoinsLeft[i].sub(forThisRate);
205             }
206             uint256 consumed = forThisRate.mul(preICOprice);
207             value = value.sub(consumed);
208             totalPurchased = totalPurchased.add(forThisRate);
209         }
210         return (totalPurchased, value);
211     }
212 
213     function preICOBuy() internal notHalted returns (bool success) {
214         uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);
215         address _for = msg.sender;
216         var (tokensBought, fundsLeftScaled) = calculateAmountBoughtPreICO(weisSentScaled);
217         uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);
218         uint256 totalSpent = msg.value.sub(fundsLeft);
219         if (totalSpent < minWeiToBuy) {
220             revert();
221         }
222         if (balanceOf(_for) == 0) {
223             preICOcontributors = preICOcontributors + 1;
224         }
225         managedTokenLedger.mint(_for, tokensBought);
226         balancesForPreICO[_for] = balancesForPreICO[_for].add(tokensBought);
227         weiForRefundPreICO[_for] = weiForRefundPreICO[_for].add(totalSpent);
228         weiToRecoverPreICO[_for] = weiToRecoverPreICO[_for].add(fundsLeft);
229         Purchased(_for, tokensBought);
230         preICOcollected = preICOcollected.add(totalSpent);
231         preICOtokensSold = preICOtokensSold.add(tokensBought);
232         return true;
233     }
234 
235     function recoverLeftoversPreICO() stateTransition notHalted public returns (bool success) {
236         require(preICOstate != ICOStateEnum.NotStarted);
237         uint256 value = weiToRecoverPreICO[msg.sender];
238         delete weiToRecoverPreICO[msg.sender];
239         msg.sender.transfer(value);
240         return true;
241     }
242 
243     function refundPreICO() stateTransition notHalted public returns (bool success) {
244         require(preICOstate == ICOStateEnum.Refunded);
245         uint256 value = weiForRefundPreICO[msg.sender];
246         delete weiForRefundPreICO[msg.sender];
247         uint256 tokenValue = balancesForPreICO[msg.sender];
248         delete balancesForPreICO[msg.sender];
249         managedTokenLedger.demint(msg.sender, tokenValue);
250         msg.sender.transfer(value);
251         return true;
252     }
253 
254     function cleanup() onlyOwner public {
255         selfdestruct(owner);
256     }
257 
258 }