1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract VerifyToken {
6     function totalSupply() public constant returns (uint);
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
9     function transfer(address to, uint tokens) public returns (bool success);
10     function approve(address spender, uint tokens) public returns (bool success);
11     function transferFrom(address from, address to, uint tokens) public returns (bool success);
12     bool public activated;
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 contract ApproveAndCallFallBack {
18     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
19 }
20 contract EthVerifyCore{
21   mapping (address => bool) public verifiedUsers;
22 }
23 contract ShrimpFarmer is ApproveAndCallFallBack{
24     using SafeMath for uint;
25     address vrfAddress=0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;
26     VerifyToken vrfcontract=VerifyToken(vrfAddress);
27 
28     //257977574257854071311765966
29     //                10000000000
30     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
31     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//86400
32     uint public VRF_EGG_COST=(1000000000000000000*300)/EGGS_TO_HATCH_1SHRIMP;
33     uint256 public STARTING_SHRIMP=300;
34     uint256 PSN=100000000000000;
35     uint256 PSNH=50000000000000;
36     uint public potDrainTime=2 hours;//
37     uint public POT_DRAIN_INCREMENT=1 hours;
38     uint public POT_DRAIN_MAX=3 days;
39     uint public HATCH_COOLDOWN_MAX=6 hours;//6 hours;
40     bool public initialized=false;
41     //bool public completed=false;
42 
43     address public ceoAddress;
44     address public dev2;
45     mapping (address => uint256) public hatchCooldown;//the amount of time you must wait now varies per user
46     mapping (address => uint256) public hatcheryShrimp;
47     mapping (address => uint256) public claimedEggs;
48     mapping (address => uint256) public lastHatch;
49     mapping (address => bool) public hasClaimedFree;
50     uint256 public marketEggs;
51     EthVerifyCore public ethVerify=EthVerifyCore(0x1c307A39511C16F74783fCd0091a921ec29A0b51);
52 
53     uint public lastBidTime;//last time someone bid for the pot
54     address public currentWinner;
55     uint public potEth=0;//eth specifically set aside for the pot
56     uint public totalHatcheryShrimp=0;
57     uint public prizeEth=0;
58 
59     function ShrimpFarmer() public{
60         ceoAddress=msg.sender;
61         dev2=address(0x95096780Efd48FA66483Bc197677e89f37Ca0CB5);
62         lastBidTime=now;
63         currentWinner=msg.sender;
64     }
65     function finalizeIfNecessary() public{
66       if(lastBidTime.add(potDrainTime)<now){
67         currentWinner.transfer(this.balance);//winner gets everything
68         initialized=false;
69         //completed=true;
70       }
71     }
72     function getPotCost() public view returns(uint){
73         return totalHatcheryShrimp.div(100);
74     }
75     function stealPot() public {
76 
77       if(initialized){
78           _hatchEggs(0);
79           uint cost=getPotCost();
80           hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].sub(cost);//cost is 1% of total shrimp
81           totalHatcheryShrimp=totalHatcheryShrimp.sub(cost);
82           setNewPotWinner();
83           hatchCooldown[msg.sender]=0;
84       }
85     }
86     function setNewPotWinner() private {
87       finalizeIfNecessary();
88       if(initialized && msg.sender!=currentWinner){
89         potDrainTime=lastBidTime.add(potDrainTime).sub(now).add(POT_DRAIN_INCREMENT);//time left plus one hour
90         if(potDrainTime>POT_DRAIN_MAX){
91           potDrainTime=POT_DRAIN_MAX;
92         }
93         lastBidTime=now;
94         currentWinner=msg.sender;
95       }
96     }
97     function isHatchOnCooldown() public view returns(bool){
98       return lastHatch[msg.sender].add(hatchCooldown[msg.sender])<now;
99     }
100     function hatchEggs(address ref) public{
101       require(isHatchOnCooldown());
102       _hatchEggs(ref);
103     }
104     function _hatchEggs(address ref) private{
105         require(initialized);
106 
107         uint256 eggsUsed=getMyEggs();
108         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
109         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
110         totalHatcheryShrimp=totalHatcheryShrimp.add(newShrimp);
111         claimedEggs[msg.sender]=0;
112         lastHatch[msg.sender]=now;
113         hatchCooldown[msg.sender]=HATCH_COOLDOWN_MAX;
114         //send referral eggs
115         require(ref!=msg.sender);
116         if(ref!=0){
117           claimedEggs[ref]=claimedEggs[ref].add(eggsUsed.div(7));
118         }
119         //boost market to nerf shrimp hoarding
120         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,7));
121     }
122     function getHatchCooldown(uint eggs) public view returns(uint){
123       uint targetEggs=marketEggs.div(50);
124       if(eggs>=targetEggs){
125         return HATCH_COOLDOWN_MAX;
126       }
127       return (HATCH_COOLDOWN_MAX.mul(eggs)).div(targetEggs);
128     }
129     function reduceHatchCooldown(address addr,uint eggs) private{
130       uint reduction=getHatchCooldown(eggs);
131       if(reduction>=hatchCooldown[addr]){
132         hatchCooldown[addr]=0;
133       }
134       else{
135         hatchCooldown[addr]=hatchCooldown[addr].sub(reduction);
136       }
137     }
138     function sellEggs() public{
139         require(initialized);
140         finalizeIfNecessary();
141         uint256 hasEggs=getMyEggs();
142         uint256 eggValue=calculateEggSell(hasEggs);
143         //uint256 fee=devFee(eggValue);
144         uint potfee=potFee(eggValue);
145         claimedEggs[msg.sender]=0;
146         lastHatch[msg.sender]=now;
147         marketEggs=SafeMath.add(marketEggs,hasEggs);
148         //ceoAddress.transfer(fee);
149         prizeEth=prizeEth.add(potfee);
150         msg.sender.transfer(eggValue.sub(potfee));
151     }
152     function buyEggs() public payable{
153         require(initialized);
154         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
155         eggsBought=eggsBought.sub(devFee(eggsBought));
156         eggsBought=eggsBought.sub(devFee2(eggsBought));
157         ceoAddress.transfer(devFee(msg.value));
158         dev2.transfer(devFee2(msg.value));
159         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
160         reduceHatchCooldown(msg.sender,eggsBought); //reduce the hatching cooldown based on eggs bought
161 
162         //steal the pot if bought enough
163         uint potEggCost=getPotCost().mul(EGGS_TO_HATCH_1SHRIMP);//the equivalent number of eggs to the pot cost in shrimp
164         if(eggsBought>potEggCost){
165           //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(getPotCost());//to compensate for the shrimp that will be lost when calling the following
166           //stealPot();
167           setNewPotWinner();
168         }
169     }
170     //magic trade balancing algorithm
171     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
172         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
173         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
174     }
175     function calculateEggSell(uint256 eggs) public view returns(uint256){
176         return calculateTrade(eggs,marketEggs,this.balance.sub(prizeEth));
177     }
178     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
179         return calculateTrade(eth,contractBalance.sub(prizeEth),marketEggs);
180     }
181     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
182         return calculateEggBuy(eth,this.balance);
183     }
184     function potFee(uint amount) public view returns(uint){
185         return SafeMath.div(SafeMath.mul(amount,20),100);
186     }
187     function devFee(uint256 amount) public view returns(uint256){
188         return SafeMath.div(SafeMath.mul(amount,4),100);
189     }
190     function devFee2(uint256 amount) public view returns(uint256){
191         return SafeMath.div(amount,100);
192     }
193     function seedMarket(uint256 eggs) public payable{
194         require(msg.sender==ceoAddress);
195         require(!initialized);
196         //require(marketEggs==0);
197         initialized=true;
198         marketEggs=eggs;
199         lastBidTime=now;
200     }
201     //Tokens are exchanged for shrimp by sending them to this contract with ApproveAndCall
202     function receiveApproval(address from, uint256 tokens, address token, bytes data) public{
203         require(!initialized);
204         require(msg.sender==vrfAddress);
205         require(ethVerify.verifiedUsers(from));//you must now be verified for this
206         require(claimedEggs[from].add(tokens.div(VRF_EGG_COST))<=1001*EGGS_TO_HATCH_1SHRIMP);//you may now trade for a max of 1000 eggs
207         vrfcontract.transferFrom(from,this,tokens);
208         claimedEggs[from]=claimedEggs[from].add(tokens.div(VRF_EGG_COST));
209     }
210     //allow sending eth to the contract
211     function () public payable {}
212 
213     function claimFreeEggs() public{
214 //  RE ENABLE THIS BEFORE DEPLOYING MAINNET
215         require(ethVerify.verifiedUsers(msg.sender));
216         require(initialized);
217         require(!hasClaimedFree[msg.sender]);
218         claimedEggs[msg.sender]=claimedEggs[msg.sender].add(getFreeEggs());
219         _hatchEggs(0);
220         hatchCooldown[msg.sender]=0;
221         hasClaimedFree[msg.sender]=true;
222         //require(hatcheryShrimp[msg.sender]==0);
223         //lastHatch[msg.sender]=now;
224         //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(STARTING_SHRIMP);
225     }
226     function getFreeEggs() public view returns(uint){
227         return min(calculateEggBuySimple(this.balance.div(400)),calculateEggBuySimple(0.01 ether));
228     }
229     function getBalance() public view returns(uint256){
230         return this.balance;
231     }
232     function getMyShrimp() public view returns(uint256){
233         return hatcheryShrimp[msg.sender];
234     }
235     function getMyEggs() public view returns(uint256){
236         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
237     }
238     function getEggsSinceLastHatch(address adr) public view returns(uint256){
239         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
240         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
241     }
242     function min(uint256 a, uint256 b) private pure returns (uint256) {
243         return a < b ? a : b;
244     }
245 }
246 
247 library SafeMath {
248 
249   /**
250   * @dev Multiplies two numbers, throws on overflow.
251   */
252   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
253     if (a == 0) {
254       return 0;
255     }
256     uint256 c = a * b;
257     assert(c / a == b);
258     return c;
259   }
260 
261   /**
262   * @dev Integer division of two numbers, truncating the quotient.
263   */
264   function div(uint256 a, uint256 b) internal pure returns (uint256) {
265     // assert(b > 0); // Solidity automatically throws when dividing by 0
266     uint256 c = a / b;
267     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
268     return c;
269   }
270 
271   /**
272   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
273   */
274   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
275     assert(b <= a);
276     return a - b;
277   }
278 
279   /**
280   * @dev Adds two numbers, throws on overflow.
281   */
282   function add(uint256 a, uint256 b) internal pure returns (uint256) {
283     uint256 c = a + b;
284     assert(c >= a);
285     return c;
286   }
287 }