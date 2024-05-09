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
16 contract CloneWars {
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
31     /* Constants */
32     
33     uint256 public clones_to_create_one_idea = 2 days;
34     uint256 public starting_clones           = 232;
35     uint256        PSN                       = 10000;
36     uint256        PSNH                      = 5000;
37     address        actualNorse               = 0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae;
38     
39     /* Variables */
40     uint256 public marketIdeas;
41     uint256 public norsefirePrice;
42     bool    public initialized;
43     address public currentNorsefire;
44     mapping (address => uint256) public arrayOfClones;
45     mapping (address => uint256) public claimedIdeas;
46     mapping (address => uint256) public lastDeploy;
47     mapping (address => address) public referrals;
48     
49     constructor () public {
50         initialized      = false;
51         norsefirePrice   = 0.1 ether;
52         currentNorsefire = 0x4d63d933BFd882cB0A9D73f7bA4318DDF3e244B0;
53     }
54     
55     function becomeNorsefire() public payable {
56         require(initialized);
57         address oldNorseAddr = currentNorsefire;
58         uint oldNorsePrice   = norsefirePrice;
59         norsefirePrice       = oldNorsePrice.add(oldNorsePrice.div(10));
60         
61         require(msg.value >= norsefirePrice);
62         
63         uint excess          = msg.value.sub(norsefirePrice);
64         uint diffFivePct     = (norsefirePrice.sub(oldNorsePrice)).div(20);
65         uint flipPrize       = diffFivePct.mul(10);
66         uint marketBoost     = diffFivePct.mul(9);
67         address _newNorse    = msg.sender;
68         uint    _toRefund    = (oldNorsePrice.add(flipPrize)).add(excess);
69         currentNorsefire     = _newNorse;
70         oldNorseAddr.transfer(_toRefund);
71         actualNorse.transfer(diffFivePct);
72         boostCloneMarket(marketBoost);
73         emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice);
74     }
75     
76     function boostCloneMarket(uint _eth) public payable {
77         require(initialized);
78         emit MarketBoost(_eth);
79     }
80     
81     function deployIdeas(address ref) public{
82         
83         require(initialized);
84         
85         address _deployer = msg.sender;
86         
87         if(referrals[_deployer] == 0 && referrals[_deployer] != _deployer){
88             referrals[_deployer]=ref;
89         }
90         
91         uint256 myIdeas          = getMyIdeas();
92         uint256 newIdeas         = myIdeas.div(clones_to_create_one_idea);
93         arrayOfClones[_deployer] = arrayOfClones[_deployer].add(newIdeas);
94         claimedIdeas[_deployer]  = 0;
95         lastDeploy[_deployer]    = now;
96         
97         // Send referral ideas: dropped to 5% instead of 20% to reduce inflation.
98         if (arrayOfClones[referrals[_deployer]] > 0) 
99         {
100             claimedIdeas[referrals[_deployer]] = claimedIdeas[referrals[_deployer]].add(myIdeas.div(20));
101         }
102         
103         // Boost market to minimise idea hoarding
104         marketIdeas = marketIdeas.add(myIdeas.div(10));
105     }
106     
107     function sellIdeas() public {
108         require(initialized);
109         
110         address _caller = msg.sender;
111         
112         uint256 hasIdeas        = getMyIdeas();
113         uint256 ideaValue       = calculateIdeaSell(hasIdeas);
114         uint256 fee             = devFee(ideaValue);
115         // Destroy a quarter the owner's clones when selling ideas thanks to market saturation.
116         arrayOfClones[_caller]  = arrayOfClones[msg.sender].div(4);
117         claimedIdeas[_caller]   = 0;
118         lastDeploy[_caller]     = now;
119         marketIdeas             = marketIdeas.add(hasIdeas);
120         currentNorsefire.transfer(fee);
121         _caller.transfer(ideaValue.sub(fee));
122     }
123     
124     function buyIdeas() public payable{
125         require(initialized);
126         address _buyer       = msg.sender;
127         uint    _sent        = msg.value;
128         uint256 ideasBought  = calculateIdeaBuy(_sent, SafeMath.sub(address(this).balance,_sent));
129         ideasBought          = ideasBought.sub(devFee(ideasBought));
130         currentNorsefire.transfer(devFee(_sent));
131         claimedIdeas[_buyer] = claimedIdeas[_buyer].add(ideasBought);
132     }
133 
134     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
135         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
136     }
137     
138     function calculateIdeaSell(uint256 _ideas) public view returns(uint256){
139         return calculateTrade(_ideas,marketIdeas,address(this).balance);
140     }
141     
142     function calculateIdeaBuy(uint256 eth,uint256 _balance) public view returns(uint256){
143         return calculateTrade(eth, _balance, marketIdeas);
144     }
145     function calculateIdeaBuySimple(uint256 eth) public view returns(uint256){
146         return calculateIdeaBuy(eth,address(this).balance);
147     }
148     
149     function devFee(uint256 amount) public pure returns(uint256){
150         return amount.mul(4).div(100);
151     }
152     
153     function releaseTheOriginal(uint256 _ideas) public payable {
154         require(msg.sender  == currentNorsefire);
155         require(marketIdeas == 0);
156         initialized         = true;
157         marketIdeas         = _ideas;
158         boostCloneMarket(msg.value);
159     }
160     
161     function hijackClones() public payable{
162         require(initialized);
163         require(msg.value==0.00232 ether); // Throwback to the OG.
164         address _caller        = msg.sender;
165         currentNorsefire.transfer(msg.value); // The current Norsefire gets this regitration
166         require(arrayOfClones[_caller]==0);
167         lastDeploy[_caller]    = now;
168         arrayOfClones[_caller] = starting_clones;
169     }
170     
171     function getBalance() public view returns(uint256){
172         return address(this).balance;
173     }
174     
175     function getMyClones() public view returns(uint256){
176         return arrayOfClones[msg.sender];
177     }
178     
179     function getNorsefirePrice() public view returns(uint256){
180         return norsefirePrice;
181     }
182     
183     function getMyIdeas() public view returns(uint256){
184         address _caller = msg.sender;
185         return claimedIdeas[_caller].add(getIdeasSinceLastDeploy(_caller));
186     }
187     
188     function getIdeasSinceLastDeploy(address adr) public view returns(uint256){
189         uint256 secondsPassed=min(clones_to_create_one_idea, now.sub(lastDeploy[adr]));
190         return secondsPassed.mul(arrayOfClones[adr]);
191     }
192     function min(uint256 a, uint256 b) private pure returns (uint256) {
193         return a < b ? a : b;
194     }
195 }
196 
197 library SafeMath {
198 
199   /**
200   * @dev Multiplies two numbers, throws on overflow.
201   */
202   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203     if (a == 0) {
204       return 0;
205     }
206     uint256 c = a * b;
207     assert(c / a == b);
208     return c;
209   }
210 
211   /**
212   * @dev Integer division of two numbers, truncating the quotient.
213   */
214   function div(uint256 a, uint256 b) internal pure returns (uint256) {
215     // assert(b > 0); // Solidity automatically throws when dividing by 0
216     uint256 c = a / b;
217     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218     return c;
219   }
220 
221   /**
222   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
223   */
224   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225     assert(b <= a);
226     return a - b;
227   }
228 
229   /**
230   * @dev Adds two numbers, throws on overflow.
231   */
232   function add(uint256 a, uint256 b) internal pure returns (uint256) {
233     uint256 c = a + b;
234     assert(c >= a);
235     return c;
236   }
237 }