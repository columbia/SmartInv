1 pragma solidity ^0.4.17;
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
31     function decimals() constant public returns (uint8 decDigits);
32     function totalSupply() constant public returns (uint256 supply);
33     function balanceOf(address _owner) constant public returns (uint256 balance);
34 }
35   
36 contract HardcodedCrowdsale {
37     using SafeMath for uint256;
38 
39     //global definisions
40 
41     enum ICOStateEnum {NotStarted, Started, Refunded, Successful}
42 
43 
44     address public owner = msg.sender;
45     ManagedToken public managedTokenLedger;
46 
47     string public name = "MDBlockchainPreICO";
48     string public symbol = "MDB";
49 
50     bool public unlocked = false;
51     bool public halted = false;
52 
53     uint256 public totalSupply = 0;
54     
55     uint256 public minTokensToBuy = 1000;
56     
57     uint256 public preICOcontributors = 0;
58     uint256 public ICOcontributors = 0;
59 
60     uint256 public preICOstart;
61     uint256 public preICOend;
62     uint256 public preICOgoal;
63     uint256 public preICOcollected = 0;
64     uint256 public preICOcap = 0 ether;
65     uint256 public preICOtokensSold = 0;
66     ICOStateEnum public preICOstate = ICOStateEnum.NotStarted;
67     
68     uint8 public decimals = 18;
69     uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);
70 
71     uint256[3] public preICOrates = [uint(1 ether).div(1600), uint(1 ether).div(1400), uint(1 ether).div(1200)];
72     uint256[3] public preICOcoinsLeft = [7000000*DECIMAL_MULTIPLIER, 14000000*DECIMAL_MULTIPLIER, 21000000*DECIMAL_MULTIPLIER];
73     uint256 public totalPreICOavailible = 42000000*DECIMAL_MULTIPLIER;
74 
75     mapping(address => uint256) public weiForRefundPreICO;
76 
77     mapping(address => uint256) public weiToRecoverPreICO;
78 
79     mapping(address => uint256) public balancesForPreICO;
80 
81     event Purchased(address indexed _from, uint256 _value);
82 
83     function advanceState() public returns (bool success) {
84         transitionState();
85         return true;
86     }
87 
88     function transitionState() internal {
89         if (now >= preICOstart) {
90             if (preICOstate == ICOStateEnum.NotStarted) {
91                 preICOstate = ICOStateEnum.Started;
92             }
93             if (preICOcap > 0 && preICOcollected >= preICOcap) {
94                 preICOstate = ICOStateEnum.Successful;
95             }
96             if (preICOtokensSold == totalPreICOavailible) {
97                 preICOstate = ICOStateEnum.Successful;
98             }
99         } if (now >= preICOend) {
100             if (preICOstate == ICOStateEnum.Started) {
101                 if (preICOcollected >= preICOgoal) {
102                     preICOstate = ICOStateEnum.Successful;
103                 } else {
104                     preICOstate = ICOStateEnum.Refunded;
105                 }
106             }
107         } 
108     }
109 
110     modifier stateTransition() {
111         transitionState();
112         _;
113         transitionState();
114     }
115 
116     modifier requirePreICOState(ICOStateEnum _state) {
117         require(preICOstate == _state);
118         _;
119     }
120 
121     modifier notHalted() {
122         require(!halted);
123         _;
124     }
125 
126     // Ownership
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     modifier onlyOwner() {
131         require(msg.sender == owner);
132         _;
133     }
134 
135     function transferOwnership(address newOwner) public onlyOwner {
136         require(newOwner != address(0));      
137         OwnershipTransferred(owner, newOwner);
138         owner = newOwner;
139     }
140 
141     function balanceOf(address _owner) constant public returns (uint256 balance) {
142         return managedTokenLedger.balanceOf(_owner);
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
156         decimals = managedTokenLedger.decimals();
157         DECIMAL_MULTIPLIER = 10**uint256(decimals);
158     }
159 
160     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
161         require(bytes(_name).length > 1);
162         require(bytes(_symbol).length > 1);
163         name = _name;
164         symbol = _symbol;
165         return true;
166     }
167 
168     function setLedger (address _newLedgerAddress) onlyOwner public returns (bool success) {
169         require(_newLedgerAddress != address(0));
170         managedTokenLedger = ManagedToken(_newLedgerAddress);
171         decimals = managedTokenLedger.decimals();
172         DECIMAL_MULTIPLIER = 10**uint256(decimals);
173         return true;
174     }
175 
176     function () payable stateTransition notHalted public {
177         if (preICOstate == ICOStateEnum.Started) {
178             assert(preICOBuy());
179         } else {
180             revert();
181         }
182     }
183 
184     function transferPreICOCollected() onlyOwner stateTransition public returns (bool success) {
185         require(preICOstate == ICOStateEnum.Successful);
186         owner.transfer(preICOcollected);
187         return true;
188     }
189 
190     function setHalt(bool _halt) onlyOwner public returns (bool success) {
191         halted = _halt;
192         return true;
193     }
194 
195     function calculateAmountBoughtPreICO(uint256 _weisSentScaled) internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {
196         uint256 value = _weisSentScaled;
197         uint256 totalPurchased = 0;
198         for (uint8 i = 0; i < preICOrates.length; i++) {
199             if (preICOcoinsLeft[i] == 0) {
200                 continue;
201             }
202             uint256 rate = preICOrates[i];
203             uint256 forThisRate = value.div(rate);
204             if (forThisRate == 0) {
205                 break;
206             }
207             if (forThisRate > preICOcoinsLeft[i]) {
208                 forThisRate = preICOcoinsLeft[i];
209                 preICOcoinsLeft[i] = 0;
210             } else {
211                 preICOcoinsLeft[i] = preICOcoinsLeft[i].sub(forThisRate);
212             }
213             uint256 consumed = forThisRate.mul(rate);
214             value = value.sub(consumed);
215             totalPurchased = totalPurchased.add(forThisRate);
216         }
217         return (totalPurchased, value);
218     }
219 
220     function preICOBuy() internal notHalted returns (bool success) {
221         uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);
222         address _for = msg.sender;
223         var (tokensBought, fundsLeftScaled) = calculateAmountBoughtPreICO(weisSentScaled);
224         if (tokensBought < minTokensToBuy.mul(DECIMAL_MULTIPLIER)) {
225             revert();
226         }
227         uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);
228         uint256 totalSpent = msg.value.sub(fundsLeft);
229         if (balanceOf(_for) == 0) {
230             preICOcontributors = preICOcontributors + 1;
231         }
232         managedTokenLedger.mint(_for, tokensBought);
233         balancesForPreICO[_for] = balancesForPreICO[_for].add(tokensBought);
234         weiForRefundPreICO[_for] = weiForRefundPreICO[_for].add(totalSpent);
235         weiToRecoverPreICO[_for] = weiToRecoverPreICO[_for].add(fundsLeft);
236         Purchased(_for, tokensBought);
237         preICOcollected = preICOcollected.add(totalSpent);
238         totalSupply = totalSupply.add(tokensBought);
239         preICOtokensSold = preICOtokensSold.add(tokensBought);
240         return true;
241     }
242 
243     function recoverLeftoversPreICO() stateTransition notHalted public returns (bool success) {
244         require(preICOstate != ICOStateEnum.NotStarted);
245         uint256 value = weiToRecoverPreICO[msg.sender];
246         delete weiToRecoverPreICO[msg.sender];
247         msg.sender.transfer(value);
248         return true;
249     }
250 
251     function refundPreICO() stateTransition requirePreICOState(ICOStateEnum.Refunded) notHalted 
252         public returns (bool success) {
253             uint256 value = weiForRefundPreICO[msg.sender];
254             delete weiForRefundPreICO[msg.sender];
255             uint256 tokenValue = balancesForPreICO[msg.sender];
256             delete balancesForPreICO[msg.sender];
257             managedTokenLedger.demint(msg.sender, tokenValue);
258             msg.sender.transfer(value);
259             return true;
260     }
261 
262     function cleanup() onlyOwner public {
263         selfdestruct(owner);
264     }
265 
266 }