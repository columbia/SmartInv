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
25     address vrfAddress=0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;//0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;
26     VerifyToken vrfcontract=VerifyToken(vrfAddress);
27 
28     //257977574257854071311765966
29     //                10000000000
30     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
31     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//86400
32     uint public VRF_EGG_COST=(1000000000000000000*300)/EGGS_TO_HATCH_1SHRIMP;
33     //uint256 public STARTING_SHRIMP=300;
34     uint256 PSN=100000000000000;
35     uint256 PSNH=50000000000000;
36     uint public POT_DRAIN_TIME=12 hours;//24 hours;
37     uint public HATCH_COOLDOWN=6 hours;//6 hours;
38     bool public initialized=false;
39     //bool public completed=false;
40 
41     address public ceoAddress;
42     address public dev2;
43     mapping (address => uint256) public hatcheryShrimp;
44     mapping (address => uint256) public claimedEggs;
45     mapping (address => uint256) public lastHatch;
46     mapping (address => bool) public hasClaimedFree;
47     uint256 public marketEggs;
48     EthVerifyCore public ethVerify=EthVerifyCore(0x1c307A39511C16F74783fCd0091a921ec29A0b51);//0x1c307A39511C16F74783fCd0091a921ec29A0b51);
49 
50     uint public lastBidTime;//last time someone bid for the pot
51     address public currentWinner;
52     //uint public potEth=0;
53     uint public totalHatcheryShrimp=0;
54     uint public prizeEth=0;//eth specifically set aside for the pot
55 
56     function ShrimpFarmer() public{
57         ceoAddress=msg.sender;
58         dev2=address(0x95096780Efd48FA66483Bc197677e89f37Ca0CB5);
59         lastBidTime=now;
60         currentWinner=msg.sender;
61     }
62     function finalizeIfNecessary() public{
63       if(lastBidTime.add(POT_DRAIN_TIME)<now){
64         currentWinner.transfer(this.balance);//winner gets everything
65         initialized=false;
66         //completed=true;
67       }
68     }
69     function getPotCost() public view returns(uint){
70         return totalHatcheryShrimp.div(100);
71     }
72     function stealPot() public {
73       finalizeIfNecessary();
74       if(initialized){
75           _hatchEggs(0);
76           uint cost=getPotCost();
77           hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].sub(cost);//cost is 1% of total shrimp
78           totalHatcheryShrimp=totalHatcheryShrimp.add(cost);
79           lastBidTime=now;
80           currentWinner=msg.sender;
81       }
82     }
83     function hatchEggs(address ref) public{
84       require(lastHatch[msg.sender].add(HATCH_COOLDOWN)<now);
85       _hatchEggs(ref);
86     }
87     function _hatchEggs(address ref) private{
88         require(initialized);
89 
90         uint256 eggsUsed=getMyEggs();
91         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
92         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
93         totalHatcheryShrimp=totalHatcheryShrimp.add(newShrimp);
94         claimedEggs[msg.sender]=0;
95         lastHatch[msg.sender]=now;
96 
97         //send referral eggs
98         require(ref!=msg.sender);
99         if(ref!=0){
100           claimedEggs[ref]=claimedEggs[ref].add(eggsUsed.div(7));
101         }
102         //boost market to nerf shrimp hoarding
103         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,7));
104     }
105 
106     function sellEggs() public{
107         require(initialized);
108         uint256 hasEggs=getMyEggs();
109         uint256 eggValue=calculateEggSell(hasEggs);
110         //uint256 fee=devFee(eggValue);
111         uint potfee=potFee(eggValue);
112         claimedEggs[msg.sender]=0;
113         lastHatch[msg.sender]=now;
114         marketEggs=SafeMath.add(marketEggs,hasEggs);
115         //ceoAddress.transfer(fee);
116         prizeEth=prizeEth.add(potfee);
117         msg.sender.transfer(eggValue.sub(potfee));
118     }
119     function buyEggs() public payable{
120         require(initialized);
121         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
122         eggsBought=eggsBought.sub(devFee(eggsBought));
123         eggsBought=eggsBought.sub(devFee2(eggsBought));
124         ceoAddress.transfer(devFee(msg.value));
125         dev2.transfer(devFee2(msg.value));
126         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
127     }
128     //magic trade balancing algorithm
129     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
130         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
131         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
132     }
133     function calculateEggSell(uint256 eggs) public view returns(uint256){
134         return calculateTrade(eggs,marketEggs,this.balance.sub(prizeEth));
135     }
136     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
137         return calculateTrade(eth,contractBalance.sub(prizeEth),marketEggs);
138     }
139     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
140         return calculateEggBuy(eth,this.balance);
141     }
142     function potFee(uint amount) public view returns(uint){
143         return SafeMath.div(SafeMath.mul(amount,20),100);
144     }
145     function devFee(uint256 amount) public view returns(uint256){
146         return SafeMath.div(SafeMath.mul(amount,4),100);
147     }
148     function devFee2(uint256 amount) public view returns(uint256){
149         return SafeMath.div(amount,100);
150     }
151     function seedMarket(uint256 eggs) public payable{
152         require(msg.sender==ceoAddress);
153         require(!initialized);
154         //require(marketEggs==0);
155         initialized=true;
156         marketEggs=eggs;
157         lastBidTime=now;
158     }
159     //to correct a mistake necessitating a redeploy of the contract
160     function setPreShrimp(address holder,uint shrimp){
161       require(!initialized);
162       require(msg.sender==ceoAddress);
163       claimedEggs[holder]=shrimp*EGGS_TO_HATCH_1SHRIMP;
164     }
165     //Tokens are exchanged for shrimp by sending them to this contract with ApproveAndCall
166     function receiveApproval(address from, uint256 tokens, address token, bytes data) public{
167         require(!initialized);
168         require(msg.sender==vrfAddress);
169         vrfcontract.transferFrom(from,this,tokens);
170         claimedEggs[from]=claimedEggs[from].add(tokens.div(VRF_EGG_COST));
171     }
172     //allow sending eth to the contract
173     function () public payable {}
174 
175     function claimFreeEggs() public{
176         require(ethVerify.verifiedUsers(msg.sender));
177         require(initialized);
178         require(!hasClaimedFree[msg.sender]);
179         claimedEggs[msg.sender]=claimedEggs[msg.sender].add(getFreeEggs());
180         hasClaimedFree[msg.sender]=true;
181         //require(hatcheryShrimp[msg.sender]==0);
182         //lastHatch[msg.sender]=now;
183         //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(STARTING_SHRIMP);
184     }
185     function getFreeEggs() public view returns(uint){
186         return min(calculateEggBuySimple(this.balance.div(100)),calculateEggBuySimple(0.05 ether));
187     }
188     function getBalance() public view returns(uint256){
189         return this.balance;
190     }
191     function getMyShrimp() public view returns(uint256){
192         return hatcheryShrimp[msg.sender];
193     }
194     function getMyEggs() public view returns(uint256){
195         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
196     }
197     function getEggsSinceLastHatch(address adr) public view returns(uint256){
198         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
199         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
200     }
201     function min(uint256 a, uint256 b) private pure returns (uint256) {
202         return a < b ? a : b;
203     }
204 }
205 
206 library SafeMath {
207 
208   /**
209   * @dev Multiplies two numbers, throws on overflow.
210   */
211   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212     if (a == 0) {
213       return 0;
214     }
215     uint256 c = a * b;
216     assert(c / a == b);
217     return c;
218   }
219 
220   /**
221   * @dev Integer division of two numbers, truncating the quotient.
222   */
223   function div(uint256 a, uint256 b) internal pure returns (uint256) {
224     // assert(b > 0); // Solidity automatically throws when dividing by 0
225     uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227     return c;
228   }
229 
230   /**
231   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
232   */
233   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234     assert(b <= a);
235     return a - b;
236   }
237 
238   /**
239   * @dev Adds two numbers, throws on overflow.
240   */
241   function add(uint256 a, uint256 b) internal pure returns (uint256) {
242     uint256 c = a + b;
243     assert(c >= a);
244     return c;
245   }
246 }