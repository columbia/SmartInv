1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 contract ERC20Interface {
5     function transfer(address to, uint256 tokens) public returns (bool success);
6 }
7 
8 contract Halo3D {
9 
10     function buy(address) public payable returns(uint256);
11     function transfer(address, uint256) public returns(bool);
12     function myTokens() public view returns(uint256);
13     function myDividends(bool) public view returns(uint256);
14     function reinvest() public;
15 }
16 
17 /**
18  * Definition of contract accepting Halo3D tokens
19  * Games, casinos, anything can reuse this contract to support Halo3D tokens
20  */
21 contract AcceptsHalo3D {
22     Halo3D public tokenContract;
23 
24     function AcceptsHalo3D(address _tokenContract) public {
25         tokenContract = Halo3D(_tokenContract);
26     }
27 
28     modifier onlyTokenContract {
29         require(msg.sender == address(tokenContract));
30         _;
31     }
32 
33     /**
34     * @dev Standard ERC677 function that will handle incoming token transfers.
35     *
36     * @param _from  Token sender address.
37     * @param _value Amount of tokens.
38     * @param _data  Transaction metadata.
39     */
40     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
41 }
42 
43 // 50 Tokens, seeded market of 8640000000 Eggs
44 // start give out 300 Shrimps
45 contract Halo3DShrimpFarmer is AcceptsHalo3D {
46     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
47     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
48     uint256 public STARTING_SHRIMP=300;
49     uint256 PSN=10000;
50     uint256 PSNH=5000;
51     bool public initialized=false;
52     address public ceoAddress;
53     mapping (address => uint256) public hatcheryShrimp;
54     mapping (address => uint256) public claimedEggs;
55     mapping (address => uint256) public lastHatch;
56     mapping (address => address) public referrals;
57     uint256 public marketEggs;
58 
59     function Halo3DShrimpFarmer(address _baseContract)
60       AcceptsHalo3D(_baseContract)
61       public{
62         ceoAddress=msg.sender;
63     }
64 
65     /**
66      * Fallback function for the contract, protect investors
67      */
68     function() payable public {
69       // Not accepting Ether directly
70       revert();
71     }
72 
73     /**
74     * Deposit Halo3D tokens to buy eggs in farm
75     *
76     * @dev Standard ERC677 function that will handle incoming token transfers.
77     * @param _from  Token sender address.
78     * @param _value Amount of tokens.
79     * @param _data  Transaction metadata.
80     */
81     function tokenFallback(address _from, uint256 _value, bytes _data)
82       external
83       onlyTokenContract
84       returns (bool) {
85         require(initialized);
86         require(!_isContract(_from));
87         require(_value >= 1 finney); // 0.001 H3D token
88 
89         uint256 halo3DBalance = tokenContract.myTokens();
90 
91         uint256 eggsBought=calculateEggBuy(_value, SafeMath.sub(halo3DBalance, _value));
92         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
93         tokenContract.transfer(ceoAddress, devFee(_value));
94         claimedEggs[_from]=SafeMath.add(claimedEggs[_from],eggsBought);
95 
96         return true;
97     }
98 
99     function hatchEggs(address ref) public{
100         require(initialized);
101         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
102             referrals[msg.sender]=ref;
103         }
104         uint256 eggsUsed=getMyEggs();
105         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
106         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
107         claimedEggs[msg.sender]=0;
108         lastHatch[msg.sender]=now;
109 
110         //send referral eggs
111         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
112 
113         //boost market to nerf shrimp hoarding
114         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
115     }
116 
117     function sellEggs() public{
118         require(initialized);
119         uint256 hasEggs=getMyEggs();
120         uint256 eggValue=calculateEggSell(hasEggs);
121         uint256 fee=devFee(eggValue);
122         claimedEggs[msg.sender]=0;
123         lastHatch[msg.sender]=now;
124         marketEggs=SafeMath.add(marketEggs,hasEggs);
125         tokenContract.transfer(ceoAddress, fee);
126         tokenContract.transfer(msg.sender, SafeMath.sub(eggValue,fee));
127     }
128 
129     // Dev should initially seed the game before start
130     function seedMarket(uint256 eggs) public {
131         require(marketEggs==0);
132         require(msg.sender==ceoAddress); // only CEO can seed the market
133         initialized=true;
134         marketEggs=eggs;
135     }
136 
137     // Reinvest Halo3D Shrimp Farm dividends
138     // All the dividends this contract makes will be used to grow token fund for players
139     // of the Halo3D Schrimp Farm
140     function reinvest() public {
141        tokenContract.reinvest();
142     }
143 
144     //magic trade balancing algorithm
145     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
146         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
147         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
148     }
149 
150     // Calculate trade to sell eggs
151     function calculateEggSell(uint256 eggs) public view returns(uint256){
152         return calculateTrade(eggs,marketEggs, tokenContract.myTokens());
153     }
154 
155     // Calculate trade to buy eggs
156     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
157         return calculateTrade(eth, contractBalance, marketEggs);
158     }
159 
160     // Calculate eggs to buy simple
161     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
162         return calculateEggBuy(eth, tokenContract.myTokens());
163     }
164 
165     // Calculate dev fee in game
166     function devFee(uint256 amount) public view returns(uint256){
167         return SafeMath.div(SafeMath.mul(amount,4),100);
168     }
169 
170     // Get amount of Shrimps user has
171     function getMyShrimp() public view returns(uint256){
172         return hatcheryShrimp[msg.sender];
173     }
174 
175     // Get amount of eggs of current user
176     function getMyEggs() public view returns(uint256){
177         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
178     }
179 
180     // Get number of doges since last hatch
181     function getEggsSinceLastHatch(address adr) public view returns(uint256){
182         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
183         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
184     }
185 
186     // Collect information about doge farm dividents amount
187     function getContractDividends() public view returns(uint256) {
188       return tokenContract.myDividends(true);
189     }
190 
191     // Get tokens balance of the doge farm
192     function getBalance() public view returns(uint256){
193         return tokenContract.myTokens();
194     }
195 
196     // Check transaction coming from the contract or not
197     function _isContract(address _user) internal view returns (bool) {
198         uint size;
199         assembly { size := extcodesize(_user) }
200         return size > 0;
201     }
202 
203     function min(uint256 a, uint256 b) private pure returns (uint256) {
204         return a < b ? a : b;
205     }
206 }
207 
208 library SafeMath {
209 
210   /**
211   * @dev Multiplies two numbers, throws on overflow.
212   */
213   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214     if (a == 0) {
215       return 0;
216     }
217     uint256 c = a * b;
218     assert(c / a == b);
219     return c;
220   }
221 
222   /**
223   * @dev Integer division of two numbers, truncating the quotient.
224   */
225   function div(uint256 a, uint256 b) internal pure returns (uint256) {
226     // assert(b > 0); // Solidity automatically throws when dividing by 0
227     uint256 c = a / b;
228     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229     return c;
230   }
231 
232   /**
233   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
234   */
235   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236     assert(b <= a);
237     return a - b;
238   }
239 
240   /**
241   * @dev Adds two numbers, throws on overflow.
242   */
243   function add(uint256 a, uint256 b) internal pure returns (uint256) {
244     uint256 c = a + b;
245     assert(c >= a);
246     return c;
247   }
248 }