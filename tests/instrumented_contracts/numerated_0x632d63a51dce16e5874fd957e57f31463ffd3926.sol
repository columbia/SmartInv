1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 contract ERC20Interface {
5     function transfer(address to, uint256 tokens) public returns (bool success);
6 }
7 
8 contract Halo3D {
9 
10    
11     function transfer(address, uint256) public returns(bool);
12     function balanceOf() public view returns(uint256);
13   
14    
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
44 contract Halo3DShrimpFarmer is AcceptsHalo3D {
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
58     function Halo3DShrimpFarmer(address _baseContract)
59       AcceptsHalo3D(_baseContract)
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
72     * Deposit Halo3D tokens to buy eggs in farm
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
85         require(_value >= 1 finney); // 0.001 H3D token
86 
87         uint256 halo3DBalance = tokenContract.balanceOf();
88 
89         uint256 eggsBought=calculateEggBuy(_value, SafeMath.sub(halo3DBalance, _value));
90         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
91    
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
124      
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
140  
141 
142     //magic trade balancing algorithm
143     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
144         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
145         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
146     }
147 
148     // Calculate trade to sell eggs
149     function calculateEggSell(uint256 eggs) public view returns(uint256){
150         return calculateTrade(eggs,marketEggs, tokenContract.balanceOf());
151     }
152 
153     // Calculate trade to buy eggs
154     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
155         return calculateTrade(eth, contractBalance, marketEggs);
156     }
157 
158     // Calculate eggs to buy simple
159     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
160         return calculateEggBuy(eth, tokenContract.balanceOf());
161     }
162 
163     // Calculate dev fee in game
164     function devFee(uint256 amount) public view returns(uint256){
165         return SafeMath.div(SafeMath.mul(amount,4),100);
166     }
167 
168     // Get amount of Shrimps user has
169     function getMyShrimp() public view returns(uint256){
170         return hatcheryShrimp[msg.sender];
171     }
172 
173     // Get amount of eggs of current user
174     function getMyEggs() public view returns(uint256){
175         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
176     }
177 
178     // Get number of doges since last hatch
179     function getEggsSinceLastHatch(address adr) public view returns(uint256){
180         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
181         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
182     }
183 
184     // Collect information about doge farm dividents amount
185 
186 
187     // Get tokens balance of the doge farm
188     function getBalance() public view returns(uint256){
189         return tokenContract.balanceOf();
190     }
191 
192     // Check transaction coming from the contract or not
193     function _isContract(address _user) internal view returns (bool) {
194         uint size;
195         assembly { size := extcodesize(_user) }
196         return size > 0;
197     }
198 
199     function min(uint256 a, uint256 b) private pure returns (uint256) {
200         return a < b ? a : b;
201     }
202 }
203 
204 library SafeMath {
205 
206   /**
207   * @dev Multiplies two numbers, throws on overflow.
208   */
209   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210     if (a == 0) {
211       return 0;
212     }
213     uint256 c = a * b;
214     assert(c / a == b);
215     return c;
216   }
217 
218   /**
219   * @dev Integer division of two numbers, truncating the quotient.
220   */
221   function div(uint256 a, uint256 b) internal pure returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return c;
226   }
227 
228   /**
229   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
230   */
231   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232     assert(b <= a);
233     return a - b;
234   }
235 
236   /**
237   * @dev Adds two numbers, throws on overflow.
238   */
239   function add(uint256 a, uint256 b) internal pure returns (uint256) {
240     uint256 c = a + b;
241     assert(c >= a);
242     return c;
243   }
244 }