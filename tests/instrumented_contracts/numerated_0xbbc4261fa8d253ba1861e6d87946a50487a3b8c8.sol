1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 interface token {
38     function transfer(address receiver, uint amount) public;
39 }
40 
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48     address public owner;
49 
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71 
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner) public onlyOwner {
77         require(newOwner != address(0));
78         OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 
82 }
83 
84 
85 /*
86  * Haltable
87  *
88  * Abstract contract that allows children to implement an
89  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
90  *
91  *
92  * Originally envisioned in FirstBlood ICO contract.
93  */
94 contract Haltable is Ownable {
95     bool public halted;
96 
97     modifier stopInEmergency {
98         if (halted) revert();
99         _;
100     }
101 
102     modifier onlyInEmergency {
103         if (!halted) revert();
104         _;
105     }
106 
107     // called by the owner on emergency, triggers stopped state
108     function halt() external onlyOwner {
109         halted = true;
110     }
111 
112     // called by the owner on end of emergency, returns to normal state
113     function unhalt() external onlyOwner onlyInEmergency {
114         halted = false;
115     }
116 
117 }
118 
119 ////////////////////////////////////////////////////////////////////////////////////////
120 
121 contract Crowdsale  is Haltable {
122     using SafeMath for uint256;
123     event FundTransfer(address backer, uint amount, bool isContribution);
124     // Crowdsale end time has been changed
125     event EndsAtChanged(uint deadline);
126     event CSClosed(bool crowdsaleClosed);
127 
128     address public beneficiary;
129     uint public amountRaised;
130     uint public amountAvailable;
131     uint public deadline;
132     uint public price;
133     token public tokenReward;
134     mapping(address => uint256) public balanceOf;
135     bool public crowdsaleClosed = false;
136 
137     uint public numTokensLeft;
138     uint public numTokensSold;
139     /* the UNIX timestamp end date of the crowdsale */
140     //    uint public newDeadline;
141 
142     /**
143      * Constrctor function
144      *
145      * Setup the owner
146      */
147     function Crowdsale(
148         address ifSuccessfulSendTo,
149         address addressOfTokenUsedAsReward,
150         uint unixTimestampEnd,
151         uint initialTokenSupply
152     ) public {
153         owner = msg.sender;
154 
155         if(unixTimestampEnd == 0) {
156             revert();
157         }
158         uint dec = 1000000000;
159         numTokensLeft = initialTokenSupply.mul(dec);
160         deadline = unixTimestampEnd;
161 
162         // Don't mess the dates
163         if(now >= deadline) {
164             revert();
165         }
166 
167         beneficiary = ifSuccessfulSendTo;
168         price = 0.000000000000166666 ether;
169         tokenReward = token(addressOfTokenUsedAsReward);
170     }
171 
172     /**
173      * Fallback function
174      *
175      * The function without name is the default function that is called whenever anyone sends funds to a contract
176      */
177     function () public stopInEmergency payable {
178         require(!crowdsaleClosed);
179         uint amount = msg.value;
180         uint leastAmount = 600000000000;
181         uint numTokens = amount.div(price);
182 
183         uint stageOne = 1520856000;// 03/12/2018 @ 12:00pm (UTC) -- 40% bonus before
184         uint stageTwo = 1521460800;// 03/19/2018 @ 12:00pm (UTC) -- 20% bonus before
185         uint stageThree = 1522065600;// 03/26/2018 @ 12:00pm (UTC) -- 15%  bonus before
186         uint stageFour = 1522670400;// 04/02/2018 @ 12:00pm (UTC) -- 10%  bonus before
187         // end date -- 1523275199 @ 04/09/2018 @ 11:59am (UTC)  -- 0%   bonus before
188 
189         uint numBonusTokens;
190         uint totalNumTokens;
191 
192         /////////////////////////////
193         //  Next step is to add in a check to see once the new price goes live
194         ////////////////////////////
195         if(now < stageOne)
196         {
197             //  40% Presale bonus
198             numBonusTokens = (numTokens.div(100)).mul(40);
199             totalNumTokens = numTokens.add(numBonusTokens);
200         }
201         else if(now < stageTwo)
202         {
203             //  20% bonus
204             numBonusTokens = (numTokens.div(100)).mul(20);
205             totalNumTokens = numTokens.add(numBonusTokens);
206         }
207         else if(now < stageThree){
208             //  15% bonus
209             numBonusTokens = (numTokens.div(100)).mul(15);
210             totalNumTokens = numTokens.add(numBonusTokens);
211         }
212         else if(now < stageFour){
213             //  10% bonus
214             numBonusTokens = (numTokens.div(100)).mul(10);
215             totalNumTokens = numTokens.add(numBonusTokens);
216         }
217         else{
218             numBonusTokens = 0;
219             totalNumTokens = numTokens.add(numBonusTokens);
220         }
221 
222         // do not sell less than 100 tokens at a time.
223         if (numTokens <= leastAmount) {
224             revert();
225         } else {
226             balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
227             amountRaised = amountRaised.add(amount);
228             amountAvailable = amountAvailable.add(amount);
229             numTokensSold = numTokensSold.add(totalNumTokens);
230             numTokensLeft = numTokensLeft.sub(totalNumTokens);
231             tokenReward.transfer(msg.sender, totalNumTokens);
232             FundTransfer(msg.sender, amount, true);
233         }
234     }
235 
236     ///////////////////////////////////////////////////////////
237     //     * Withdraw received funds
238     ///////////////////////////////////////////////////////////
239     function safeWithdrawal() public onlyOwner{
240         if(amountAvailable < 0)
241         {
242             revert();
243         }
244         else
245         {
246             uint amtA = amountAvailable;
247             amountAvailable = 0;
248             beneficiary.transfer(amtA);
249         }
250     }
251 
252     ///////////////////////////////////////////////////////////
253     // Withdraw tokens
254     ///////////////////////////////////////////////////////////
255     function withdrawTheUnsoldTokens() public onlyOwner afterDeadline{
256         if(numTokensLeft <= 0)
257         {
258             revert();
259         }
260         else
261         {
262             uint ntl = numTokensLeft;
263             numTokensLeft=0;
264             tokenReward.transfer(beneficiary, ntl);
265             crowdsaleClosed = true;
266             CSClosed(crowdsaleClosed);
267         }
268     }
269 
270     /////////////////////////////////////////////////////////////
271     // give the crowdsale a new newDeadline
272     ////////////////////////////////////////////////////////////
273 
274     modifier afterDeadline() { if (now >= deadline) _; }
275 
276     function setDeadline(uint time) public onlyOwner {
277         if(now > time || msg.sender==beneficiary)
278         {
279             revert(); // Don't change past
280         }
281         deadline = time;
282         EndsAtChanged(deadline);
283     }
284 
285     ///////////////////////////////////////////////////////////////////////////////////////////////
286 }