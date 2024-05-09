1 pragma solidity ^0.4.18;
2 
3 /**
4  * Etheropoly Board Game without Developer Fee taken out.
5  */
6 
7 contract ERC20Interface {
8     function transfer(address to, uint256 tokens) public returns (bool success);
9 }
10 
11 contract Etheropoly {
12 
13     function buy(address) public payable returns(uint256);
14     function transfer(address, uint256) public returns(bool);
15     function myTokens() public view returns(uint256);
16     function myDividends(bool) public view returns(uint256);
17     function reinvest() public;
18 }
19 
20 /**
21  * Definition of contract accepting Etheropoly tokens
22  * Games, casinos, anything can reuse this contract to support Etheropoly tokens
23  */
24 contract AcceptsEtheropoly {
25     Etheropoly public tokenContract;
26 
27     function AcceptsEtheropoly(address _tokenContract) public {
28         tokenContract = Etheropoly(_tokenContract);
29     }
30 
31     modifier onlyTokenContract {
32         require(msg.sender == address(tokenContract));
33         _;
34     }
35 
36     /**
37     * @dev Standard ERC677 function that will handle incoming token transfers.
38     *
39     * @param _from  Token sender address.
40     * @param _value Amount of tokens.
41     * @param _data  Transaction metadata.
42     */
43     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
44 }
45 
46 // 50 Tokens, seeded market of 8640000000 Eggs
47 contract EtheropolyShrimpFarmer is AcceptsEtheropoly {
48     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
49     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
50     uint256 public STARTING_SHRIMP=300;
51     uint256 PSN=10000;
52     uint256 PSNH=5000;
53     bool public initialized=false;
54     address public ceoAddress;
55     mapping (address => uint256) public hatcheryShrimp;
56     mapping (address => uint256) public claimedEggs;
57     mapping (address => uint256) public lastHatch;
58     mapping (address => address) public referrals;
59     uint256 public marketEggs;
60 
61     function EtheropolyShrimpFarmer(address _baseContract)
62       AcceptsEtheropoly(_baseContract)
63       public{
64         ceoAddress=msg.sender;
65     }
66 
67     /**
68      * Fallback function for the contract if sent ethereum by mistake
69      */
70     function() payable public {
71         ceoAddress.transfer(msg.value);
72       /* revert(); */
73     }
74 
75     /**
76     * Deposit Etheropoly tokens to buy eggs in farm
77     *
78     * @dev Standard ERC677 function that will handle incoming token transfers.
79     * @param _from  Token sender address.
80     * @param _value Amount of tokens.
81     * @param _data  Transaction metadata.
82     */
83     function tokenFallback(address _from, uint256 _value, bytes _data)
84       external
85       onlyTokenContract
86       returns (bool) {
87         require(initialized);
88         require(!_isContract(_from));
89         require(_value >= 1 finney); // 0.001 OPOLY token
90 
91         uint256 EtheropolyBalance = tokenContract.myTokens();
92 
93         uint256 eggsBought=calculateEggBuy(_value, SafeMath.sub(EtheropolyBalance, _value));
94         reinvest();
95         claimedEggs[_from]=SafeMath.add(claimedEggs[_from],eggsBought);
96 
97         return true;
98     }
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
117 
118     function sellEggs() public{
119         require(initialized);
120         uint256 hasEggs=getMyEggs();
121         uint256 eggValue=calculateEggSell(hasEggs);
122         claimedEggs[msg.sender]=0;
123         lastHatch[msg.sender]=now;
124         marketEggs=SafeMath.add(marketEggs,hasEggs);
125         reinvest();
126         tokenContract.transfer(msg.sender, eggValue);
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
137     // Reinvest Etheropoly Shrimp Farm dividends
138     // All the dividends this contract makes will be used to grow token fund for players
139     // of the Etheropoly Schrimp Farm
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
167     // Get amount of Shrimps user has
168     function getMyShrimp() public view returns(uint256){
169         return hatcheryShrimp[msg.sender];
170     }
171 
172     // Get amount of eggs of current user
173     function getMyEggs() public view returns(uint256){
174         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
175     }
176 
177     // Get number of doges since last hatch
178     function getEggsSinceLastHatch(address adr) public view returns(uint256){
179         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
180         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
181     }
182 
183     // Collect information about doge farm dividends amount
184     function getContractDividends() public view returns(uint256) {
185       return tokenContract.myDividends(true); // + this.balance;
186     }
187 
188     // Get tokens balance of the doge farm
189     function getBalance() public view returns(uint256){
190         return tokenContract.myTokens();
191     }
192 
193     // Check transaction coming from the contract or not
194     function _isContract(address _user) internal view returns (bool) {
195         uint size;
196         assembly { size := extcodesize(_user) }
197         return size > 0;
198     }
199 
200     function min(uint256 a, uint256 b) private pure returns (uint256) {
201         return a < b ? a : b;
202     }
203 }
204 
205 library SafeMath {
206 
207   /**
208   * @dev Multiplies two numbers, throws on overflow.
209   */
210   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211     if (a == 0) {
212       return 0;
213     }
214     uint256 c = a * b;
215     assert(c / a == b);
216     return c;
217   }
218 
219   /**
220   * @dev Integer division of two numbers, truncating the quotient.
221   */
222   function div(uint256 a, uint256 b) internal pure returns (uint256) {
223     // assert(b > 0); // Solidity automatically throws when dividing by 0
224     uint256 c = a / b;
225     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226     return c;
227   }
228 
229   /**
230   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
231   */
232   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233     assert(b <= a);
234     return a - b;
235   }
236 
237   /**
238   * @dev Adds two numbers, throws on overflow.
239   */
240   function add(uint256 a, uint256 b) internal pure returns (uint256) {
241     uint256 c = a + b;
242     assert(c >= a);
243     return c;
244   }
245 }