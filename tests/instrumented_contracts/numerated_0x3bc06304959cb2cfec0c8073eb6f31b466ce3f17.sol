1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 contract ERC20Interface {
5     function transfer(address to, uint256 tokens) public returns (bool success);
6 }
7 
8 contract Elyxr {
9 
10     function buy(address) public payable returns(uint256);
11     function transfer(address, uint256) public returns(bool);
12     function myTokens() public view returns(uint256);
13     function myDividends(bool) public view returns(uint256);
14     function reinvest() public;
15 }
16 
17 /**
18  * Definition of contract accepting Elyxr tokens
19  * Games, casinos, anything can reuse this contract to support Elyxr tokens
20  */
21 contract AcceptsElyxr {
22     Elyxr public tokenContract;
23 
24     function AcceptsElyxr(address _tokenContract) public {
25         tokenContract = Elyxr(_tokenContract);
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
44 contract ElyxrShrimpFarmer is AcceptsElyxr {
45     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
46     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
47     uint256 public STARTING_SHRIMP=300;
48     uint256 PSN=10000;
49     uint256 PSNH=5000;
50     bool public initialized=false;
51     address public ceoAddress;
52     mapping (address => uint256) public hatcheryShrimp;
53     mapping (address => uint256) public claimedEggs;
54     mapping (address => uint256) public lastHatch;
55     mapping (address => address) public referrals;
56     uint256 public marketEggs;
57 
58     function ElyxrShrimpFarmer(address _baseContract)
59       AcceptsElyxr(_baseContract)
60       public{
61         ceoAddress=msg.sender;
62     }
63 
64     /**
65      * Fallback function for the contract, protect investors
66      */
67     function() payable public {
68       /* revert(); */
69     }
70 
71     /**
72     * Deposit Elyxr tokens to buy eggs in farm
73     *
74     * @dev Standard ERC677 function that will handle incoming token transfers.
75     * @param _from  Token sender address.
76     * @param _value Amount of tokens.
77     * @param _data  Transaction metadata.
78     */
79     function tokenFallback(address _from, uint256 _value, bytes _data)
80       external
81       onlyTokenContract
82       returns (bool) {
83         require(initialized);
84         require(!_isContract(_from));
85         require(_value >= 1 finney); // 0.001 ELXR token
86 
87         uint256 ElyxrBalance = tokenContract.myTokens();
88 
89         uint256 eggsBought=calculateEggBuy(_value, SafeMath.sub(ElyxrBalance, _value));
90         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
91         reinvest();
92         tokenContract.transfer(ceoAddress, devFee(_value));
93         claimedEggs[_from]=SafeMath.add(claimedEggs[_from],eggsBought);
94 
95         return true;
96     }
97 
98     function hatchEggs(address ref) public{
99         require(initialized);
100         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
101             referrals[msg.sender]=ref;
102         }
103         uint256 eggsUsed=getMyEggs();
104         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
105         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
106         claimedEggs[msg.sender]=0;
107         lastHatch[msg.sender]=now;
108 
109         //send referral eggs
110         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
111 
112         //boost market to nerf shrimp hoarding
113         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
114     }
115 
116     function sellEggs() public{
117         require(initialized);
118         uint256 hasEggs=getMyEggs();
119         uint256 eggValue=calculateEggSell(hasEggs);
120         uint256 fee=devFee(eggValue);
121         claimedEggs[msg.sender]=0;
122         lastHatch[msg.sender]=now;
123         marketEggs=SafeMath.add(marketEggs,hasEggs);
124         reinvest();
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
137     // Reinvest Elyxr Shrimp Farm dividends
138     // All the dividends this contract makes will be used to grow token fund for players
139     // of the Elyxr Schrimp Farm
140     function reinvest() public {
141        if(tokenContract.myDividends(true) > 1) {
142          tokenContract.reinvest();
143        }
144     }
145 
146     //magic trade balancing algorithm
147     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
148         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
149         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
150     }
151 
152     // Calculate trade to sell eggs
153     function calculateEggSell(uint256 eggs) public view returns(uint256){
154         return calculateTrade(eggs,marketEggs, tokenContract.myTokens());
155     }
156 
157     // Calculate trade to buy eggs
158     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
159         return calculateTrade(eth, contractBalance, marketEggs);
160     }
161 
162     // Calculate eggs to buy simple
163     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
164         return calculateEggBuy(eth, tokenContract.myTokens());
165     }
166 
167     // Calculate dev fee in game
168     function devFee(uint256 amount) public view returns(uint256){
169         return SafeMath.div(SafeMath.mul(amount,4),100);
170     }
171 
172     // Get amount of Shrimps user has
173     function getMyShrimp() public view returns(uint256){
174         return hatcheryShrimp[msg.sender];
175     }
176 
177     // Get amount of eggs of current user
178     function getMyEggs() public view returns(uint256){
179         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
180     }
181 
182     // Get number of doges since last hatch
183     function getEggsSinceLastHatch(address adr) public view returns(uint256){
184         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
185         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
186     }
187 
188     // Collect information about doge farm dividents amount
189     function getContractDividends() public view returns(uint256) {
190       return tokenContract.myDividends(true); // + this.balance;
191     }
192 
193     // Get tokens balance of the doge farm
194     function getBalance() public view returns(uint256){
195         return tokenContract.myTokens();
196     }
197 
198     // Check transaction coming from the contract or not
199     function _isContract(address _user) internal view returns (bool) {
200         uint size;
201         assembly { size := extcodesize(_user) }
202         return size > 0;
203     }
204 
205     function min(uint256 a, uint256 b) private pure returns (uint256) {
206         return a < b ? a : b;
207     }
208 }
209 
210 library SafeMath {
211 
212   /**
213   * @dev Multiplies two numbers, throws on overflow.
214   */
215   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216     if (a == 0) {
217       return 0;
218     }
219     uint256 c = a * b;
220     assert(c / a == b);
221     return c;
222   }
223 
224   /**
225   * @dev Integer division of two numbers, truncating the quotient.
226   */
227   function div(uint256 a, uint256 b) internal pure returns (uint256) {
228     // assert(b > 0); // Solidity automatically throws when dividing by 0
229     uint256 c = a / b;
230     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231     return c;
232   }
233 
234   /**
235   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
236   */
237   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238     assert(b <= a);
239     return a - b;
240   }
241 
242   /**
243   * @dev Adds two numbers, throws on overflow.
244   */
245   function add(uint256 a, uint256 b) internal pure returns (uint256) {
246     uint256 c = a + b;
247     assert(c >= a);
248     return c;
249   }
250 }