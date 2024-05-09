1 /**
2  *  ForecasterReward.sol v1.1.0
3  * 
4  *  Bilal Arif - https://twitter.com/furusiyya_
5  *  Draglet GbmH
6  */
7 
8 pragma solidity 0.4.19;
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) pure internal returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) pure internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));      
84     owner = newOwner;
85   }
86 
87 }
88 
89 /*
90  * Haltable
91  *
92  * Abstract contract that allows children to implement an
93  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
94  *
95  *
96  * Originally envisioned in FirstBlood ICO contract.
97  */
98 contract Haltable is Ownable {
99   bool public halted;
100 
101   modifier stopInEmergency {
102     assert(!halted);
103     _;
104   }
105 
106   modifier onlyInEmergency {
107     require(halted);
108     _;
109   }
110 
111   // called by the owner on emergency, triggers stopped state
112   function halt() external onlyOwner {
113     halted = true;
114   }
115 
116   // called by the owner on end of emergency, returns to normal state
117   function unhalt() external onlyOwner onlyInEmergency {
118     halted = false;
119   }
120 
121 }
122 
123 contract ForecasterReward is Haltable {
124 
125   using SafeMath for uint;
126 
127   /* the starting time of the crowdsale */
128   uint private startsAt;
129 
130   /* the ending time of the crowdsale */
131   uint private endsAt;
132 
133   /* How many wei of funding we have received so far */
134   uint private weiRaised = 0;
135 
136   /* How many distinct addresses have invested */
137   uint private investorCount = 0;
138   
139   /* How many total investments have been made */
140   uint private totalInvestments = 0;
141   
142   /* Address of pre-ico contract*/
143   address private multisig;
144  
145 
146   /** How much ETH each address has invested to this crowdsale */
147   mapping (address => uint256) public investedAmountOf;
148 
149   
150   /** State machine
151    *
152    * - Prefunding: We have not passed start time yet
153    * - Funding: Active crowdsale
154    * - Closed: Funding is closed.
155    */
156   enum State{PreFunding, Funding, Closed}
157 
158   // A new investment was made
159   event Invested(uint index, address indexed investor, uint weiAmount);
160 
161   // Funds transfer to other address
162   event Transfer(address indexed receiver, uint weiAmount);
163 
164   // Crowdsale end time has been changed
165   event EndsAtChanged(uint endTimestamp);
166 
167   function ForecasterReward() public
168   {
169 
170     owner = 0xed4C73Ad76D90715d648797Acd29A8529ED511A0;
171     multisig = 0x177B63c7CaF85A360074bcB095952Aa8E929aE03;
172     
173     startsAt = 1515600000;
174     endsAt = 1516118400;
175   }
176 
177   /**
178    * Allow investor to just send in money
179    */
180   function() nonZero payable public{
181     buy(msg.sender);
182   }
183 
184   /**
185    * Make an investment.
186    *
187    * Crowdsale must be running for one to invest.
188    * We must have not pressed the emergency brake.
189    *
190    * @param receiver The Ethereum address who have invested
191    *
192    */
193   function buy(address receiver) stopInEmergency inState(State.Funding) nonZero public payable{
194     require(receiver != 0x00);
195     
196     uint weiAmount = msg.value;
197    
198     if(investedAmountOf[receiver] == 0) {
199       // A new investor
200       investorCount++;
201     }
202 
203     // count all investments
204     totalInvestments++;
205 
206     // Update investor
207     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
208     
209     // Up total accumulated fudns
210     weiRaised = weiRaised.add(weiAmount);
211     
212     // Pocket the money
213     if(!distributeFunds()) revert();
214     
215     // Tell us invest was success
216     Invested(totalInvestments, receiver, weiAmount);
217   }
218 
219  
220   /**
221    * @return multisig Address of Multisig Wallet contract
222    */
223   function multisigAddress() public constant returns(address){
224       return multisig;
225   }
226   
227   /**
228    * @return startDate Crowdsale opening date
229    */
230   function fundingStartAt() public constant returns(uint ){
231       return startsAt;
232   }
233   
234   /**
235    * @return endDate Crowdsale closing date
236    */
237   function fundingEndsAt() public constant returns(uint){
238       return endsAt;
239   }
240   
241   /**
242    * @return investors Total of distinct investors
243    */
244   function distinctInvestors() public constant returns(uint){
245       return investorCount;
246   }
247   
248   /**
249    * @return investments Crowdsale closing date
250    */
251   function investments() public constant returns(uint){
252       return totalInvestments;
253   }
254   
255   
256   /**
257    * Send out contributions imediately
258    */
259   function distributeFunds() private returns(bool){
260         
261     Transfer(multisig,this.balance);
262     
263     if(!multisig.send(this.balance)){
264       return false;
265     }
266     
267     return true;
268   }
269   
270   /**
271    * Allow crowdsale owner to close early or extend the crowdsale.
272    *
273    * This is useful e.g. for a manual soft cap implementation:
274    * - after X amount is reached determine manual closing
275    *
276    * This may put the crowdsale to an invalid state,
277    * but we trust owners know what they are doing.
278    *
279    */
280   function setEndsAt(uint _endsAt) public onlyOwner {
281     
282     // Don't change past
283     require(_endsAt > now);
284 
285     endsAt = _endsAt;
286     EndsAtChanged(_endsAt);
287   }
288 
289   /**
290    * @return total of amount of wie collected by the contract 
291    */
292   function fundingRaised() public constant returns (uint){
293     return weiRaised;
294   }
295   
296   
297   /**
298    * Crowdfund state machine management.
299    *
300    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
301    */
302   function getState() public constant returns (State) {
303     if (now < startsAt) return State.PreFunding;
304     else if (now <= endsAt) return State.Funding;
305     else if (now > endsAt) return State.Closed;
306   }
307 
308   /** Interface marker. */
309   function isCrowdsale() public pure returns (bool) {
310     return true;
311   }
312 
313   //
314   // Modifiers
315   //
316   /** Modifier allowing execution only if the crowdsale is currently running.  */
317   modifier inState(State state) {
318     require(getState() == state);
319     _;
320   }
321 
322   /** Modifier allowing execution only if received value is greater than zero */
323   modifier nonZero(){
324     require(msg.value > 0);
325     _;
326   }
327 }