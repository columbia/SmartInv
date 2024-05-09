1 pragma solidity ^0.4.24;
2 
3 /* You've seen all of this before. Here are the differences.
4 
5 // A. A quarter of your clones die when you sell ideas. Market saturation, y'see?
6 // B. You can "become" Norsefire and take the dev fees, since he's involved in everything.
7 // B. 1. The Norsefire boon is a hot potato. If someone else buys it off you, you profit.
8 // B. 2. When Norsefire flips, we actually send him 5% of the increase. You receive 50%, the contract receives the other 45%.
9 // C. You get your 'free' clones for 0.00232 Ether, because throwbaaaaaack.
10 // D. Referral rates have been dropped to 5% instead of 20%. The referral target must have bought in.
11 // E. The generation rate of ideas have been halved, as a sign of my opinion of the community at large.
12 // F. God knows this will probably be successful in spite of myself.
13 
14 */
15 
16 contract CloneFarmFarmer {
17     using SafeMath for uint;
18     
19     /* Event */
20     
21     event MarketBoost(
22         uint amountSent  
23     );
24     
25     event NorsefireSwitch(
26         address from,
27         address to,
28         uint price
29     );
30     
31     event ClonesDeployed(
32         address deployer,
33         uint clones
34     );
35     
36     event IdeasSold(
37         address seller,
38         uint ideas
39     );
40     
41     event IdeasBought(
42         address buyer,
43         uint ideas
44     );
45     
46     /* Constants */
47     
48     uint256 public clones_to_create_one_idea = 2 days;
49     uint256 public starting_clones           = 3; // Shrimp, Shrooms and Snails.
50     uint256        PSN                       = 10000;
51     uint256        PSNH                      = 5000;
52     address        actualNorse               = 0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae;
53     
54     /* Variables */
55     uint256 public marketIdeas;
56     uint256 public norsefirePrice;
57     bool    public initialized;
58     address public currentNorsefire;
59     mapping (address => uint256) public arrayOfClones;
60     mapping (address => uint256) public claimedIdeas;
61     mapping (address => uint256) public lastDeploy;
62     mapping (address => address) public referrals;
63     
64     constructor () public {
65         initialized      = false;
66         norsefirePrice   = 0.1 ether;
67         currentNorsefire = 0x1337eaD98EaDcE2E04B1cfBf57E111479854D29A;
68     }
69     
70     function becomeNorsefire() public payable {
71         require(initialized);
72         address oldNorseAddr = currentNorsefire;
73         uint oldNorsePrice   = norsefirePrice;
74         
75         // Did you actually send enough?
76         require(msg.value >= norsefirePrice);
77         
78         uint excess          = msg.value.sub(oldNorsePrice);
79         norsefirePrice       = oldNorsePrice.add(oldNorsePrice.div(10));
80         uint diffFivePct     = (norsefirePrice.sub(oldNorsePrice)).div(20);
81         uint flipPrize       = diffFivePct.mul(10);
82         uint marketBoost     = diffFivePct.mul(9);
83         address _newNorse    = msg.sender;
84         uint    _toRefund    = (oldNorsePrice.add(flipPrize)).add(excess);
85         currentNorsefire     = _newNorse;
86         oldNorseAddr.send(_toRefund);
87         actualNorse.send(diffFivePct);
88         boostCloneMarket(marketBoost);
89         emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice);
90     }
91     
92     function boostCloneMarket(uint _eth) public payable {
93         require(initialized);
94         emit MarketBoost(_eth);
95     }
96     
97     function deployIdeas(address ref) public{
98         
99         require(initialized);
100         
101         address _deployer = msg.sender;
102         
103         if(referrals[_deployer] == 0 && referrals[_deployer] != _deployer){
104             referrals[_deployer]=ref;
105         }
106         
107         uint256 myIdeas          = getMyIdeas();
108         uint256 newIdeas         = myIdeas.div(clones_to_create_one_idea);
109         arrayOfClones[_deployer] = arrayOfClones[_deployer].add(newIdeas);
110         claimedIdeas[_deployer]  = 0;
111         lastDeploy[_deployer]    = now;
112         
113         // Send referral ideas: dropped to 5% instead of 20% to reduce inflation.
114         if (arrayOfClones[referrals[_deployer]] > 0) 
115         {
116             claimedIdeas[referrals[_deployer]] = claimedIdeas[referrals[_deployer]].add(myIdeas.div(20));
117         }
118         
119         // Boost market to minimise idea hoarding
120         marketIdeas = marketIdeas.add(myIdeas.div(10));
121         emit ClonesDeployed(_deployer, newIdeas);
122     }
123     
124     function sellIdeas() public {
125         require(initialized);
126         
127         address _caller = msg.sender;
128         
129         uint256 hasIdeas        = getMyIdeas();
130         uint256 ideaValue       = calculateIdeaSell(hasIdeas);
131         uint256 fee             = devFee(ideaValue);
132         // Destroy a quarter the owner's clones when selling ideas thanks to market saturation.
133         arrayOfClones[_caller]  = (arrayOfClones[msg.sender].div(4)).mul(3);
134         claimedIdeas[_caller]   = 0;
135         lastDeploy[_caller]     = now;
136         marketIdeas             = marketIdeas.add(hasIdeas);
137         currentNorsefire.send(fee);
138         _caller.send(ideaValue.sub(fee));
139         emit IdeasSold(_caller, hasIdeas);
140     }
141     
142     function buyIdeas() public payable{
143         require(initialized);
144         address _buyer       = msg.sender;
145         uint    _sent        = msg.value;
146         uint256 ideasBought  = calculateIdeaBuy(_sent, SafeMath.sub(address(this).balance,_sent));
147         ideasBought          = ideasBought.sub(devFee(ideasBought));
148         currentNorsefire.send(devFee(_sent));
149         claimedIdeas[_buyer] = claimedIdeas[_buyer].add(ideasBought);
150         emit IdeasBought(_buyer, ideasBought);
151     }
152 
153     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
154         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
155     }
156     
157     function calculateIdeaSell(uint256 _ideas) public view returns(uint256){
158         return calculateTrade(_ideas,marketIdeas,address(this).balance);
159     }
160     
161     function calculateIdeaBuy(uint256 eth,uint256 _balance) public view returns(uint256){
162         return calculateTrade(eth, _balance, marketIdeas);
163     }
164     function calculateIdeaBuySimple(uint256 eth) public view returns(uint256){
165         return calculateIdeaBuy(eth,address(this).balance);
166     }
167     
168     function devFee(uint256 amount) public pure returns(uint256){
169         return amount.mul(4).div(100);
170     }
171     
172     function releaseTheOriginal(uint256 _ideas) public payable {
173         require(msg.sender  == currentNorsefire);
174         require(marketIdeas == 0);
175         initialized         = true;
176         marketIdeas         = _ideas;
177         boostCloneMarket(msg.value);
178     }
179     
180     function hijackClones() public payable{
181         require(initialized);
182         require(msg.value==0.00232 ether); // Throwback to the OG.
183         address _caller        = msg.sender;
184         currentNorsefire.send(msg.value); // The current Norsefire gets this regitration
185         require(arrayOfClones[_caller]==0);
186         lastDeploy[_caller]    = now;
187         arrayOfClones[_caller] = starting_clones;
188     }
189     
190     function getBalance() public view returns(uint256){
191         return address(this).balance;
192     }
193     
194     function getMyClones() public view returns(uint256){
195         return arrayOfClones[msg.sender];
196     }
197     
198     function getNorsefirePrice() public view returns(uint256){
199         return norsefirePrice;
200     }
201     
202     function getMyIdeas() public view returns(uint256){
203         address _caller = msg.sender;
204         return claimedIdeas[_caller].add(getIdeasSinceLastDeploy(_caller));
205     }
206     
207     function getIdeasSinceLastDeploy(address adr) public view returns(uint256){
208         uint256 secondsPassed=min(clones_to_create_one_idea, now.sub(lastDeploy[adr]));
209         return secondsPassed.mul(arrayOfClones[adr]);
210     }
211     function min(uint256 a, uint256 b) private pure returns (uint256) {
212         return a < b ? a : b;
213     }
214 }
215 
216 library SafeMath {
217 
218   /**
219   * @dev Multiplies two numbers, throws on overflow.
220   */
221   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222     if (a == 0) {
223       return 0;
224     }
225     uint256 c = a * b;
226     assert(c / a == b);
227     return c;
228   }
229 
230   /**
231   * @dev Integer division of two numbers, truncating the quotient.
232   */
233   function div(uint256 a, uint256 b) internal pure returns (uint256) {
234     // assert(b > 0); // Solidity automatically throws when dividing by 0
235     uint256 c = a / b;
236     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237     return c;
238   }
239 
240   /**
241   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
242   */
243   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244     assert(b <= a);
245     return a - b;
246   }
247 
248   /**
249   * @dev Adds two numbers, throws on overflow.
250   */
251   function add(uint256 a, uint256 b) internal pure returns (uint256) {
252     uint256 c = a + b;
253     assert(c >= a);
254     return c;
255   }
256 }