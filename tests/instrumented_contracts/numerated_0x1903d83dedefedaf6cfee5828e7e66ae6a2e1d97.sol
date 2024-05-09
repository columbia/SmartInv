1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, throws on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18      * @dev Integer division of two numbers, truncating the quotient.
19      */
20     function div(uint256 a, uint256 b) internal pure returns(uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Adds two numbers, throws on overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns(uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 contract Ownable {
45   address public owner;
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     if (newOwner != address(0)) {
72       owner = newOwner;
73     }
74   }
75 
76 }
77 
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev modifier to allow actions only when the contract IS paused
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev modifier to allow actions only when the contract IS NOT paused
95    */
96   modifier whenPaused {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() public onlyOwner whenNotPaused returns (bool) {
105     paused = true;
106     return true;
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() public onlyOwner whenPaused returns (bool) {
113     paused = false;
114     return true;
115   }
116 }
117 
118 contract BatCave is Pausable {
119     // total eggs one bat can produce per day
120     uint256 public EGGS_TO_HATCH_1BAT = 86400;
121     // how much bat for newbie user
122     uint256 public STARTING_BAT = 300;
123     uint256 PSN = 10000;
124     uint256 PSNH = 5000;
125     address public batman;
126     address public superman;
127     address public aquaman;
128     mapping(address => uint256) public hatcheryBat;
129     mapping(address => uint256) public claimedEggs;
130     mapping(address => uint256) public lastHatch;
131     mapping(address => address) public referrals;
132     mapping (address => uint256) realRef;
133 
134 
135     // total eggs in market
136     uint256 public marketEggs;
137 
138     function BatCave() public{
139         paused = false;
140     }
141 
142     modifier onlyDCFamily() {
143       require(batman!=address(0) && superman!=address(0) && aquaman!=address(0));
144       require(msg.sender == owner || msg.sender == batman || msg.sender == superman || msg.sender == aquaman);
145       _;
146     }
147 
148     function setBatman(address _bat) public onlyOwner{
149       require(_bat!=address(0));
150       batman = _bat;
151     }
152 
153     function setSuperman(address _bat) public onlyOwner{
154       require(_bat!=address(0));
155       superman = _bat;
156     }
157 
158     function setAquaman(address _bat) public onlyOwner{
159       require(_bat!=address(0));
160       aquaman = _bat;
161     }
162 
163     function setRealRef(address _ref,uint256 _isReal) public onlyOwner{
164         require(_ref!=address(0));
165         require(_isReal==0 || _isReal==1);
166         realRef[_ref] = _isReal;
167     }
168 
169     function withdraw(uint256 _percent) public onlyDCFamily {
170         require(_percent>0&&_percent<=100);
171         uint256 val = SafeMath.div(SafeMath.mul(address(this).balance,_percent), 300);
172         if (val>0){
173           batman.transfer(val);
174           superman.transfer(val);
175           aquaman.transfer(val);
176         }
177     }
178 
179     // hatch eggs into bats
180     function hatchEggs(address ref) public whenNotPaused {
181         // set user's referral only if which is empty
182         if (referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {
183             //referrals[msg.sender] = ref;
184             if (realRef[ref] == 1){
185                 referrals[msg.sender] = ref;
186             }else{
187                 referrals[msg.sender] = owner;
188             }
189 
190         }
191         uint256 eggsUsed = getMyEggs();
192         uint256 newBat = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1BAT);
193         hatcheryBat[msg.sender] = SafeMath.add(hatcheryBat[msg.sender], newBat);
194         claimedEggs[msg.sender] = 0;
195         lastHatch[msg.sender] = now;
196 
197         //send referral eggs 20% of user
198         //claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 5));
199         claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 3));
200 
201         //boost market to nerf bat hoarding
202         // add 10% of user into market
203         marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 10));
204     }
205 
206     // sell eggs for eth
207     function sellEggs() public whenNotPaused {
208         uint256 hasEggs = getMyEggs();
209         uint256 eggValue = calculateEggSell(hasEggs);
210         uint256 fee = devFee(eggValue);
211         // kill one third of the owner's snails on egg sale
212         hatcheryBat[msg.sender] = SafeMath.mul(SafeMath.div(hatcheryBat[msg.sender], 3), 2);
213         claimedEggs[msg.sender] = 0;
214         lastHatch[msg.sender] = now;
215         marketEggs = SafeMath.add(marketEggs, hasEggs);
216         owner.transfer(fee);
217         msg.sender.transfer(SafeMath.sub(eggValue, fee));
218     }
219 
220     function buyEggs() public payable whenNotPaused {
221         uint256 eggsBought = calculateEggBuy(msg.value, SafeMath.sub(address(this).balance, msg.value));
222         eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));
223         owner.transfer(devFee(msg.value));
224         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);
225     }
226     //magic trade balancing algorithm
227     function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {
228         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
229         return SafeMath.div(SafeMath.mul(PSN, bs), SafeMath.add(PSNH, SafeMath.div(SafeMath.add(SafeMath.mul(PSN, rs), SafeMath.mul(PSNH, rt)), rt)));
230     }
231 
232     // eggs to eth
233     function calculateEggSell(uint256 eggs) public view returns(uint256) {
234         return calculateTrade(eggs, marketEggs, address(this).balance);
235     }
236 
237     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
238         return calculateTrade(eth, contractBalance, marketEggs);
239     }
240 
241     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
242         return calculateEggBuy(eth, address(this).balance);
243     }
244 
245     // eggs amount to eth for developers: eggs*4/100
246     function devFee(uint256 amount) public pure returns(uint256) {
247         return SafeMath.div(SafeMath.mul(amount, 4), 100);
248     }
249 
250     // add eggs when there's no more eggs
251     // 864000000 with 0.02 Ether
252     function seedMarket(uint256 eggs) public payable {
253         require(marketEggs == 0);
254         marketEggs = eggs;
255     }
256 
257     function getFreeBat() public payable whenNotPaused {
258         require(msg.value == 0.001 ether);
259         require(hatcheryBat[msg.sender] == 0);
260         lastHatch[msg.sender] = now;
261         hatcheryBat[msg.sender] = STARTING_BAT;
262         owner.transfer(msg.value);
263     }
264 
265     function getBalance() public view returns(uint256) {
266         return address(this).balance;
267     }
268 
269     function getMyBat() public view returns(uint256) {
270         return hatcheryBat[msg.sender];
271     }
272 
273     function getMyEggs() public view returns(uint256) {
274         return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
275     }
276 
277     function getEggsSinceLastHatch(address adr) public view returns(uint256) {
278         uint256 secondsPassed = min(EGGS_TO_HATCH_1BAT, SafeMath.sub(now, lastHatch[adr]));
279         return SafeMath.mul(secondsPassed, hatcheryBat[adr]);
280     }
281 
282     function min(uint256 a, uint256 b) private pure returns(uint256) {
283         return a < b ? a : b;
284     }
285 }