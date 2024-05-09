1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract EtherCartel{
6     //uint256 EGGS_TO_HATCH_1SHRIMP=1;
7     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
8     uint256 public STARTING_SHRIMP=300;
9     uint256 PSN=10000;
10     uint256 PSNH=5000;
11     bool public initialized=false;
12     address public ceoAddress;
13     mapping (address => uint256) public hatcheryShrimp;
14     mapping (address => uint256) public claimedEggs;
15     mapping (address => uint256) public lastHatch;
16     mapping (address => address) public referrals;
17     uint256 public marketEggs;
18 
19 
20     // Additions 
21     mapping(address => bool) public hasDoubler;
22     uint256 public CurrentIcePrice = 0.01 ether;
23     uint256 public CurrentIceDelta = 0.001 ether;
24     uint256 public CurrentGoldPrice = 0.2 ether;
25     uint256 public CurrentGoldPercentIncrease = 200; // 200 = doubles in price 
26     uint256 public CurrentDevFee = 7;
27     address public GoldOwner;
28 
29 
30     constructor() public{
31         ceoAddress=msg.sender;
32         GoldOwner=msg.sender;
33     }
34 
35     function BuyDoubler() public payable{
36         require(initialized);
37         require(msg.value >= CurrentIcePrice);
38         uint256 left;
39         uint256 excess=0;
40         if (msg.value > CurrentIcePrice){
41             excess = msg.value - CurrentIcePrice;
42             left = CurrentIcePrice;
43         }
44         else{
45             left = msg.value;
46         }
47 
48 
49         // save current eggs into the wallet of user 
50         uint256 eggs = getMyEggs();
51         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggs);
52         // shrimp production all moved into claimed eggs 
53         lastHatch[msg.sender] = now;
54         hasDoubler[msg.sender] = true;
55         CurrentIcePrice = CurrentIcePrice + CurrentIceDelta;
56         ceoAddress.transfer(devFee(left));
57         if (excess > 0){
58             msg.sender.transfer(excess);
59         }
60     }
61 
62     function BuyGold() public payable{
63         require(initialized);
64         require(msg.value >= CurrentGoldPrice);
65         require(msg.sender != GoldOwner);
66         uint256 left;
67         uint256 excess=0;
68         if (msg.value > CurrentGoldPrice){
69             excess = msg.value - CurrentGoldPrice;
70             left = CurrentGoldPrice;
71         }
72         else{
73             left = msg.value;
74         }
75 
76         left = SafeMath.sub(left, devFee(left));
77 
78         uint256 eggs = getMyEggs();
79         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggs);
80         // shrimp production all moved into claimed eggs 
81         lastHatch[msg.sender] = now;
82 
83         eggs = getEggsOff(GoldOwner);
84         claimedEggs[GoldOwner] = SafeMath.add(claimedEggs[GoldOwner], eggs);
85         // shrimp production all moved into claimed eggs 
86         lastHatch[GoldOwner] = now;
87 
88 
89         CurrentGoldPrice = SafeMath.div(SafeMath.mul(CurrentGoldPrice,CurrentGoldPercentIncrease),100);
90         address oldOwner = GoldOwner;
91         GoldOwner = msg.sender;
92 
93         oldOwner.transfer(left);
94         if (excess > 0){
95             msg.sender.transfer(excess);
96         }
97     }
98 
99 
100     function hatchEggs(address ref) public{
101         require(initialized);
102         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
103             referrals[msg.sender]=ref;
104         }
105         uint256 eggsUsed=getMyEggs();
106         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
107         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
108         claimedEggs[msg.sender]=0;
109         lastHatch[msg.sender]=now;
110         
111         //send referral eggs
112         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
113         
114         //boost market to nerf shrimp hoarding
115         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
116     }
117     function sellEggs() public{
118         require(initialized);
119         uint256 hasEggs=getMyEggs();
120         uint256 eggValue=calculateEggSell(hasEggs);
121         uint256 fee=devFee(eggValue);
122         claimedEggs[msg.sender]=0;
123         lastHatch[msg.sender]=now;
124         marketEggs=SafeMath.add(marketEggs,hasEggs);
125         hatcheryShrimp[msg.sender]=SafeMath.div(SafeMath.mul(hatcheryShrimp[msg.sender],3),4);
126         ceoAddress.transfer(fee);
127         msg.sender.transfer(SafeMath.sub(eggValue,fee));
128     }
129     function buyEggs() public payable{
130         require(initialized);
131         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
132         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
133         ceoAddress.transfer(devFee(msg.value));
134         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
135     }
136     //magic trade balancing algorithm
137     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
138         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
139         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
140     }
141     function calculateEggSell(uint256 eggs) public view returns(uint256){
142         return calculateTrade(eggs,marketEggs,this.balance);
143     }
144     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
145         return calculateTrade(eth,contractBalance,marketEggs);
146     }
147     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
148         return calculateEggBuy(eth,this.balance);
149     }
150     function devFee(uint256 amount) public view returns(uint256){
151         return SafeMath.div(SafeMath.mul(amount,CurrentDevFee),100);
152     }
153     function seedMarket(uint256 eggs) public payable{
154         require(marketEggs==0);
155         initialized=true;
156         marketEggs=eggs;
157     }
158     function getFreeShrimp() public{
159         require(initialized);
160         require(hatcheryShrimp[msg.sender]==0);
161         lastHatch[msg.sender]=now;
162         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
163     }
164     function getBalance() public view returns(uint256){
165         return this.balance;
166     }
167     function getMyShrimp() public view returns(uint256){
168         return hatcheryShrimp[msg.sender];
169     }
170 
171     function getEggsOff(address adr) public view returns (uint256){
172         uint256 ret = SafeMath.add(claimedEggs[adr],getEggsSinceLastHatch(adr));
173         if (hasDoubler[adr]){
174             ret = SafeMath.mul(ret,2);
175         }
176         if (adr == GoldOwner){
177             ret = SafeMath.mul(ret,4);
178         }
179         return ret;
180     
181     }
182 
183 
184     function getMyEggs() public view returns(uint256){
185         uint256 ret = SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
186         if (hasDoubler[msg.sender]){
187             ret = SafeMath.mul(ret,2);
188         }
189         if (msg.sender == GoldOwner){
190             ret = SafeMath.mul(ret,4);
191         }
192         return ret;
193     }
194     function getEggsSinceLastHatch(address adr) public view returns(uint256){
195         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
196         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
197     }
198     function min(uint256 a, uint256 b) private pure returns (uint256) {
199         return a < b ? a : b;
200     }
201 }
202 
203 library SafeMath {
204 
205   /**
206   * @dev Multiplies two numbers, throws on overflow.
207   */
208   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209     if (a == 0) {
210       return 0;
211     }
212     uint256 c = a * b;
213     assert(c / a == b);
214     return c;
215   }
216 
217   /**
218   * @dev Integer division of two numbers, truncating the quotient.
219   */
220   function div(uint256 a, uint256 b) internal pure returns (uint256) {
221     // assert(b > 0); // Solidity automatically throws when dividing by 0
222     uint256 c = a / b;
223     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224     return c;
225   }
226 
227   /**
228   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
229   */
230   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231     assert(b <= a);
232     return a - b;
233   }
234 
235   /**
236   * @dev Adds two numbers, throws on overflow.
237   */
238   function add(uint256 a, uint256 b) internal pure returns (uint256) {
239     uint256 c = a + b;
240     assert(c >= a);
241     return c;
242   }
243 }