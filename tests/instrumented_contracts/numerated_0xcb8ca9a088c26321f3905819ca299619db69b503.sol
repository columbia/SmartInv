1 pragma solidity ^0.4.24;
2 
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 interface ExtendedShrimp {
15   function sendFunds(address user,uint hexAmount) external returns (uint256);
16   function signalHatch(address user,uint shrimpAmount) external; //to allow the safe use of shrimp as divs, with an effective snapshot of all shrimp counts.
17 }
18 
19 
20 contract ShrimpFarmer is IERC20{
21     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
22     uint256 PSN=10000;
23     uint256 PSNH=5000;
24     bool public initialized=false;
25     IERC20 public hexToken;
26     ExtendedShrimp public extendedContract;
27     uint256 public extendedContractSetAt;
28     uint256 public extendedContractTimeToGoLive=1 days;
29     address public contractCreator;
30     address public feeshare2;
31     address public feeshare3;
32     address public feeshare4;
33     address public feeshare5;
34     mapping (address => uint256) public hatcheryShrimp;
35     mapping (address => uint256) public claimedEggs;
36     mapping (address => uint256) public lastHatch;
37     mapping (address => address) public referrals;
38 
39     uint256 public marketEggs;
40 
41     //ERC20 constants
42     string public constant name = "HEXSHRIMP";
43     string public constant symbol = "HEXSHRIMP";
44     uint8 public constant decimals = 0;
45 
46     //for view only
47     mapping(address => uint) public referralCount;
48     mapping(address => uint) public eggsFromReferral;
49     mapping(address => bytes32) public refName;
50     mapping(bytes32 => address) public addressByRefName;
51 
52     event Referral(address from,address to,uint eggsSent);
53     event Hatch(address from,uint newShrimp);
54     event Buy(address from,uint hexSpent,uint eggsBought);
55     event Sell(address from,uint eggsSold,uint hexWithdrawn);
56     function ShrimpFarmer(address token,address fs2,address fs3,address fs4,address fs5) public{
57         contractCreator=msg.sender;
58         feeshare2=fs2;
59         feeshare3=fs3;
60         feeshare4=fs4;
61         feeshare5=fs5;
62         hexToken=IERC20(token);
63     }
64     function hatchEggs(address ref) public{
65         require(initialized);
66         if(getExtendedContract() != address(0)){
67           extendedContract.signalHatch(msg.sender,hatcheryShrimp[msg.sender]);
68         }
69         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
70             referrals[msg.sender]=ref;
71             referralCount[ref]+=1;
72         }
73 
74         uint256 eggsUsed=getMyEggs();
75         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
76         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
77         claimedEggs[msg.sender]=0;
78         lastHatch[msg.sender]=now;
79 
80         //send referral eggs
81         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,20));
82         if(referrals[msg.sender]!=0){
83           eggsFromReferral[referrals[msg.sender]]+=SafeMath.div(eggsUsed,20);
84           emit Referral(msg.sender,referrals[msg.sender],SafeMath.div(eggsUsed,20));
85         }
86         //if(ref!=msg.sender){
87         //  claimedEggs[ref]=SafeMath.add(claimedEggs[ref],SafeMath.div(eggsUsed,20));//divided by 20 is 5%
88         //}
89 
90         //boost market to nerf shrimp hoarding
91         //re-enabled with lower amount.
92         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,20));
93 
94         emit Hatch(msg.sender,newShrimp);
95     }
96     function payoutFee(uint fee) private{
97       hexToken.transfer(contractCreator,SafeMath.div(SafeMath.mul(fee,30),100));
98       hexToken.transfer(feeshare2,SafeMath.div(SafeMath.mul(fee,20),100));
99       hexToken.transfer(feeshare3,SafeMath.div(SafeMath.mul(fee,20),100));
100       hexToken.transfer(feeshare4,SafeMath.div(SafeMath.mul(fee,15),100));
101       hexToken.transfer(feeshare5,SafeMath.div(SafeMath.mul(fee,15),100));
102     }
103     function sellEggs() public{
104         require(initialized);
105         uint256 hasEggs=getMyEggs();
106         uint256 eggValue=calculateEggSell(hasEggs);
107         uint256 fee=devFee(eggValue);
108         claimedEggs[msg.sender]=0;
109         lastHatch[msg.sender]=now;
110         marketEggs=SafeMath.add(marketEggs,hasEggs);
111         //contractCreator.transfer(fee);
112         payoutFee(fee);
113         hexToken.transfer(msg.sender,SafeMath.sub(eggValue,fee));
114 
115         emit Sell(msg.sender,hasEggs,SafeMath.sub(eggValue,fee));
116     }
117     function buyEggs(uint hexIn1) public{
118         require(initialized);
119         uint hexIn;
120 
121         //transfer hex from user, must have allowance already set
122         hexToken.transferFrom(msg.sender,address(this),hexIn1);
123 
124         if(getExtendedContract() != address(0)){
125           sendToExtendedShrimp(getExtendedFee(hexIn1));
126           hexIn=SafeMath.sub(hexIn1,getExtendedFee(hexIn1));
127         }
128         else{
129           hexIn=hexIn1;
130         }
131 
132         uint256 eggsBought=calculateEggBuy(hexIn,SafeMath.sub(hexToken.balanceOf(address(this)),hexIn));
133         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
134 
135         payoutFee(devFee(hexIn));
136         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
137 
138         emit Buy(msg.sender,hexIn,eggsBought);
139     }
140     //magic trade balancing algorithm
141     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
142         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
143         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
144     }
145     function calculateEggSell(uint256 eggs) public view returns(uint256){
146         return calculateTrade(eggs,marketEggs,hexToken.balanceOf(address(this)));
147     }
148     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
149         return calculateTrade(eth,contractBalance,marketEggs);
150     }
151     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
152         return calculateEggBuy(eth,hexToken.balanceOf(address(this)));
153     }
154     function devFee(uint256 amount) public pure returns(uint256){
155         return SafeMath.div(SafeMath.mul(amount,4),100);
156     }
157     function seedMarket(uint256 eggs,uint256 hexIn) public{
158         require(msg.sender==contractCreator);
159         require(marketEggs==0);
160         hexToken.transferFrom(msg.sender,address(this),hexIn);
161         initialized=true;
162         marketEggs=eggs;
163     }
164     function getExtendedFee(uint hexAmount) public pure returns(uint256){
165       return SafeMath.div(SafeMath.mul(hexAmount,10),100);
166     }
167     function sendToExtendedShrimp(uint hexAmount) private{
168       hexToken.transfer(address(extendedContract),hexAmount);
169       extendedContract.sendFunds(msg.sender,hexAmount);
170     }
171     /*
172       The contract upgrade function
173     */
174     function setExtendedShrimp(address extended) public{
175       require(msg.sender==contractCreator);
176       extendedContract=ExtendedShrimp(extended);
177       extendedContractSetAt=now;
178     }
179     /*
180       Ensures that the upgraded contract only goes live after a buffer of time has passed after it was set. Users may examine the code of the contract in the meantime.
181     */
182     function getExtendedContract() public view returns(ExtendedShrimp){
183       if(SafeMath.sub(now,extendedContractSetAt)>extendedContractTimeToGoLive){
184         return extendedContract;
185       }
186       else{
187         return ExtendedShrimp(address(0));
188       }
189     }
190     function setRefName(bytes32 s) public{
191       require(addressByRefName[s]==0);
192       addressByRefName[s]=msg.sender;
193       refName[msg.sender]=s;
194     }
195     /* disabled
196     function getFreeShrimp() public{
197         require(initialized);
198         require(hatcheryShrimp[msg.sender]==0);
199         lastHatch[msg.sender]=now;
200         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
201     }
202     */
203     function getBalance() public view returns(uint256){
204         return hexToken.balanceOf(address(this));
205     }
206     function getMyShrimp() public view returns(uint256){
207         return hatcheryShrimp[msg.sender];
208     }
209     function getMyEggs() public view returns(uint256){
210         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
211     }
212     function getEggsSinceLastHatch(address adr) public view returns(uint256){
213         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
214         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
215     }
216     function min(uint256 a, uint256 b) private pure returns (uint256) {
217         return a < b ? a : b;
218     }
219 
220 /*
221   Making this a token to take advantage of metrics collection for shrimp balances. Shrimp cannot be transferred.
222 */
223     function totalSupply() external view returns (uint256){
224       return 0;
225     }
226     function balanceOf(address account) external view returns (uint256){
227       return hatcheryShrimp[account];
228     }
229     function transfer(address recipient, uint256 amount) external returns (bool){
230       revert();
231     }
232     function allowance(address owner, address spender) external view returns (uint256){
233       return 0;
234     }
235     function approve(address spender, uint256 amount) external returns (bool){
236       revert();
237     }
238     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
239       revert();
240     }
241 }
242 
243 library SafeMath {
244 
245   /**
246   * @dev Multiplies two numbers, throws on overflow.
247   */
248   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249     if (a == 0) {
250       return 0;
251     }
252     uint256 c = a * b;
253     assert(c / a == b);
254     return c;
255   }
256 
257   /**
258   * @dev Integer division of two numbers, truncating the quotient.
259   */
260   function div(uint256 a, uint256 b) internal pure returns (uint256) {
261     // assert(b > 0); // Solidity automatically throws when dividing by 0
262     uint256 c = a / b;
263     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264     return c;
265   }
266 
267   /**
268   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
269   */
270   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271     assert(b <= a);
272     return a - b;
273   }
274 
275   /**
276   * @dev Adds two numbers, throws on overflow.
277   */
278   function add(uint256 a, uint256 b) internal pure returns (uint256) {
279     uint256 c = a + b;
280     assert(c >= a);
281     return c;
282   }
283 }