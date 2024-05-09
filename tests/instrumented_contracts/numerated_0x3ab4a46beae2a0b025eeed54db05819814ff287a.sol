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
28         uint price,
29         uint a,
30         uint b,
31         uint c
32     );
33     
34     event ClonesDeployed(
35         address deployer,
36         uint clones
37     );
38     
39     event IdeasSold(
40         address seller,
41         uint ideas
42     );
43     
44     event IdeasBought(
45         address buyer,
46         uint ideas
47     );
48     
49     /* Constants */
50     
51     uint256 public clones_to_create_one_idea = 2 days;
52     uint256 public starting_clones           = 3; // Shrimp, Shrooms and Snails.
53     uint256        PSN                       = 10000;
54     uint256        PSNH                      = 5000;
55     address        actualNorse               = 0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae;
56     
57     /* Variables */
58     uint256 public marketIdeas;
59     uint256 public norsefirePrice;
60     bool    public initialized;
61     address public currentNorsefire;
62     mapping (address => uint256) public arrayOfClones;
63     mapping (address => uint256) public claimedIdeas;
64     mapping (address => uint256) public lastDeploy;
65     mapping (address => address) public referrals;
66     
67     constructor () public {
68         initialized      = false;
69         norsefirePrice   = 0.1 ether;
70         currentNorsefire = 0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae;
71     }
72     
73     function becomeNorsefire() public payable {
74         require(initialized);
75         address oldNorseAddr = currentNorsefire;
76         uint oldNorsePrice   = norsefirePrice.mul(100).div(110);
77         
78         // Did you actually send enough?
79         require(msg.value >= norsefirePrice);
80         
81         uint excess          = msg.value.sub(norsefirePrice);
82         uint diffFivePct     = (norsefirePrice.sub(oldNorsePrice)).div(20);
83         norsefirePrice       = norsefirePrice.add(norsefirePrice.div(10));
84         uint flipPrize       = diffFivePct.mul(10);
85         uint marketBoost     = diffFivePct.mul(9);
86         address _newNorse    = msg.sender;
87         uint    _toRefund    = (oldNorsePrice.add(flipPrize));
88         currentNorsefire     = _newNorse;
89         oldNorseAddr.send(_toRefund);
90         actualNorse.send(diffFivePct);
91         if (excess > 0){
92             msg.sender.send(excess);
93         }
94         boostCloneMarket(marketBoost);
95         emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice, _toRefund, flipPrize, diffFivePct);
96     }
97     
98     function boostCloneMarket(uint _eth) public payable {
99         require(initialized);
100         emit MarketBoost(_eth);
101     }
102     
103     function deployIdeas(address ref) public{
104         
105         require(initialized);
106         
107         address _deployer = msg.sender;
108         
109         if(referrals[_deployer] == 0 && referrals[_deployer] != _deployer){
110             referrals[_deployer]=ref;
111         }
112         
113         uint256 myIdeas          = getMyIdeas();
114         uint256 newIdeas         = myIdeas.div(clones_to_create_one_idea);
115         arrayOfClones[_deployer] = arrayOfClones[_deployer].add(newIdeas);
116         claimedIdeas[_deployer]  = 0;
117         lastDeploy[_deployer]    = now;
118         
119         // Send referral ideas: dropped to 5% instead of 20% to reduce inflation.
120         if (arrayOfClones[referrals[_deployer]] > 0) 
121         {
122             claimedIdeas[referrals[_deployer]] = claimedIdeas[referrals[_deployer]].add(myIdeas.div(20));
123         }
124         
125         // Boost market to minimise idea hoarding
126         marketIdeas = marketIdeas.add(myIdeas.div(10));
127         emit ClonesDeployed(_deployer, newIdeas);
128     }
129     
130     function sellIdeas() public {
131         require(initialized);
132         
133         address _caller = msg.sender;
134         
135         uint256 hasIdeas        = getMyIdeas();
136         uint256 ideaValue       = calculateIdeaSell(hasIdeas);
137         uint256 fee             = devFee(ideaValue);
138         // Destroy a quarter the owner's clones when selling ideas thanks to market saturation.
139         arrayOfClones[_caller]  = (arrayOfClones[msg.sender].div(4)).mul(3);
140         claimedIdeas[_caller]   = 0;
141         lastDeploy[_caller]     = now;
142         marketIdeas             = marketIdeas.add(hasIdeas);
143         currentNorsefire.send(fee);
144         _caller.send(ideaValue.sub(fee));
145         emit IdeasSold(_caller, hasIdeas);
146     }
147     
148     function buyIdeas() public payable{
149         require(initialized);
150         address _buyer       = msg.sender;
151         uint    _sent        = msg.value;
152         uint256 ideasBought  = calculateIdeaBuy(_sent, SafeMath.sub(address(this).balance,_sent));
153         ideasBought          = ideasBought.sub(devFee(ideasBought));
154         currentNorsefire.send(devFee(_sent));
155         claimedIdeas[_buyer] = claimedIdeas[_buyer].add(ideasBought);
156         emit IdeasBought(_buyer, ideasBought);
157     }
158 
159     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
160         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
161     }
162     
163     function calculateIdeaSell(uint256 _ideas) public view returns(uint256){
164         return calculateTrade(_ideas,marketIdeas,address(this).balance);
165     }
166     
167     function calculateIdeaBuy(uint256 eth,uint256 _balance) public view returns(uint256){
168         return calculateTrade(eth, _balance, marketIdeas);
169     }
170     function calculateIdeaBuySimple(uint256 eth) public view returns(uint256){
171         return calculateIdeaBuy(eth,address(this).balance);
172     }
173     
174     function devFee(uint256 amount) public pure returns(uint256){
175         return amount.mul(4).div(100);
176     }
177     
178     function releaseTheOriginal(uint256 _ideas) public payable {
179         require(msg.sender  == currentNorsefire);
180         require(marketIdeas == 0);
181         initialized         = true;
182         marketIdeas         = _ideas;
183         boostCloneMarket(msg.value);
184     }
185     
186     function hijackClones() public payable{
187         require(initialized);
188         require(msg.value==0.00232 ether); // Throwback to the OG.
189         address _caller        = msg.sender;
190         currentNorsefire.send(msg.value); // The current Norsefire gets this regitration
191         require(arrayOfClones[_caller]==0);
192         lastDeploy[_caller]    = now;
193         arrayOfClones[_caller] = starting_clones;
194     }
195     
196     function getBalance() public view returns(uint256){
197         return address(this).balance;
198     }
199     
200     function getMyClones() public view returns(uint256){
201         return arrayOfClones[msg.sender];
202     }
203     
204     function getNorsefirePrice() public view returns(uint256){
205         return norsefirePrice;
206     }
207     
208     function getMyIdeas() public view returns(uint256){
209         address _caller = msg.sender;
210         return claimedIdeas[_caller].add(getIdeasSinceLastDeploy(_caller));
211     }
212     
213     function getIdeasSinceLastDeploy(address adr) public view returns(uint256){
214         uint256 secondsPassed=min(clones_to_create_one_idea, now.sub(lastDeploy[adr]));
215         return secondsPassed.mul(arrayOfClones[adr]);
216     }
217     function min(uint256 a, uint256 b) private pure returns (uint256) {
218         return a < b ? a : b;
219     }
220 }
221 
222 library SafeMath {
223 
224   /**
225   * @dev Multiplies two numbers, throws on overflow.
226   */
227   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228     if (a == 0) {
229       return 0;
230     }
231     uint256 c = a * b;
232     assert(c / a == b);
233     return c;
234   }
235 
236   /**
237   * @dev Integer division of two numbers, truncating the quotient.
238   */
239   function div(uint256 a, uint256 b) internal pure returns (uint256) {
240     // assert(b > 0); // Solidity automatically throws when dividing by 0
241     uint256 c = a / b;
242     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243     return c;
244   }
245 
246   /**
247   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
248   */
249   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250     assert(b <= a);
251     return a - b;
252   }
253 
254   /**
255   * @dev Adds two numbers, throws on overflow.
256   */
257   function add(uint256 a, uint256 b) internal pure returns (uint256) {
258     uint256 c = a + b;
259     assert(c >= a);
260     return c;
261   }
262 }