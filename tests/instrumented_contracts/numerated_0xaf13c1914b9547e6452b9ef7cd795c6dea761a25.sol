1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     function Ownable() public{
18         owner = msg.sender;
19     }
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address newOwner) onlyOwner public {
34         require(newOwner != address(0));
35         OwnershipTransferred(owner,newOwner);
36         owner = newOwner;
37     }
38 }
39 
40 library SafeMath {
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // assert(b > 0); // Solidity automatically throws when dividing by 0
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         assert(b <= a);
59         return a - b;
60     }
61 
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         assert(c >= a);
65         return c;
66     }
67 }
68 
69 interface token {
70     function balanceOf(address who) external constant returns (uint256);
71 	  function transfer(address to, uint256 value) external returns (bool);
72 	  function getTotalSupply() external view returns (uint256);
73 }
74 
75 contract ApolloSeptemBaseCrowdsale {
76     using SafeMath for uint256;
77 
78     // The token being sold
79     token public tokenReward;
80 	
81     // start and end timestamps where investments are allowed (both inclusive)
82     uint256 public startTime;
83     uint256 public endTime;
84 
85     // address where funds are collected
86     address public wallet;
87 	
88     // token address
89     address public tokenAddress;
90 
91     // amount of raised money in wei
92     uint256 public weiRaised;
93     
94     // ICO period (includes holidays)
95     uint public constant  ICO_PERIOD = 180 days;
96 
97     /**
98     * event for token purchase logging
99     * @param purchaser who paid for the tokens
100     * @param beneficiary who got the tokens
101     * @param value weis paid for purchase
102     * @param amount amount of tokens purchased
103     */
104     event ApolloSeptemTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
105     event ApolloSeptemTokenSpecialPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
106 
107     function ApolloSeptemBaseCrowdsale(address _wallet, address _tokens) public{		
108         require(_wallet != address(0));
109         tokenAddress = _tokens;
110         tokenReward = token(tokenAddress);
111         wallet = _wallet;
112 
113     }
114 
115     // fallback function can be used to buy tokens
116     function () public payable {
117         buyTokens(msg.sender);
118     }
119 
120     // low level token purchase function
121     function buyTokens(address beneficiary) public payable {
122         require(beneficiary != address(0));
123         require(validPurchase());
124 
125         uint256 weiAmount = msg.value;
126 
127         // calculate token to be substracted
128         uint256 tokens = computeTokens(weiAmount);
129 
130         require(isWithinTokenAllocLimit(tokens));
131 
132         // update state
133         weiRaised = weiRaised.add(weiAmount);
134 
135         // send tokens to beneficiary
136         tokenReward.transfer(beneficiary, tokens);
137 
138         ApolloSeptemTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
139 
140         forwardFunds();
141     }
142 
143     //transfer used for special contribuitions
144     function specialTransfer(address _to, uint _amount) internal returns(bool){
145         require(_to != address(0));
146         require(_amount > 0);
147       
148         // calculate token to be substracted
149         uint256 tokens = _amount * (10 ** 18);
150       
151         tokenReward.transfer(_to, tokens);		
152         ApolloSeptemTokenSpecialPurchase(msg.sender, _to, tokens);
153       
154         return true;
155     }
156 
157     // @return true if crowdsale event has ended
158     function hasEnded() public constant returns (bool) {
159         return now > endTime;
160     }
161 
162     // send ether to the fund collection wallet
163     function forwardFunds() internal {
164         wallet.transfer(msg.value);
165     }
166 
167     // @return true if the transaction can buy tokens
168     function validPurchase() internal view returns (bool) {
169         bool withinPeriod = now >= startTime && now <= endTime;
170         bool nonZeroPurchase = msg.value != 0;
171 		
172         return withinPeriod && nonZeroPurchase && isWithinICOTimeLimit();
173     }
174     
175     function isWithinICOTimeLimit() internal view returns (bool) {
176         return now <= endTime;
177     }
178 	
179     function isWithinICOLimit(uint256 _tokens) internal view returns (bool) {			
180         return tokenReward.balanceOf(this).sub(_tokens) >= 0;
181     }
182 
183     function isWithinTokenAllocLimit(uint256 _tokens) internal view returns (bool) {
184         return (isWithinICOTimeLimit() && isWithinICOLimit(_tokens));
185     }
186 	
187     function sendAllToOwner(address beneficiary) internal returns(bool){
188         tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));
189         return true;
190     }
191 
192     function computeTokens(uint256 weiAmount) internal pure returns (uint256) {
193 		    // 1 ETH = 4200 APO 
194         return weiAmount.mul(4200);
195     }
196 }
197 
198 /**
199  * @title ApolloSeptemCappedCrowdsale
200  * @dev Extension of ApolloSeptemBaseCrowdsale with a max amount of funds raised
201  */
202 contract ApolloSeptemCappedCrowdsale is ApolloSeptemBaseCrowdsale{
203     using SafeMath for uint256;
204 
205     // HARD_CAP = 30,000 ether 
206     uint256 public constant HARD_CAP = (3 ether)*(10**4);
207 
208     function ApolloSeptemCappedCrowdsale() public {}
209 
210     // overriding ApolloSeptemBaseCrowdsale#validPurchase to add extra cap logic
211     // @return true if investors can buy at the moment
212     function validPurchase() internal view returns (bool) {
213         bool withinCap = weiRaised.add(msg.value) <= HARD_CAP;
214 
215         return super.validPurchase() && withinCap;
216     }
217 
218     // overriding Crowdsale#hasEnded to add cap logic
219     // @return true if crowdsale event has ended
220     function hasEnded() public constant returns (bool) {
221         bool capReached = weiRaised >= HARD_CAP;
222         return super.hasEnded() || capReached;
223     }
224 }
225 
226 /**
227  * @title ApolloSeptemCrowdsaleExtended
228  * @dev This is ApolloSeptem's crowdsale contract.
229  */
230 contract ApolloSeptemCrowdsaleExtended is ApolloSeptemCappedCrowdsale, Ownable {
231 
232     bool public isFinalized = false;
233     bool public isStarted = false;
234 
235     event ApolloSeptemStarted();
236     event ApolloSeptemFinalized();
237 
238     function ApolloSeptemCrowdsaleExtended(address _wallet,address _tokensAddress) public
239         ApolloSeptemCappedCrowdsale()
240         ApolloSeptemBaseCrowdsale(_wallet,_tokensAddress) 
241     {}
242 	
243   	/**
244     * @dev Must be called to start the crowdsale. 
245     */
246     function start(uint256 _weiRaised) onlyOwner public {
247         require(!isStarted);
248 
249         starting(_weiRaised);
250         ApolloSeptemStarted();
251 
252         isStarted = true;
253     }
254 
255     function starting(uint256 _weiRaised) internal {
256         startTime = now;
257         weiRaised = _weiRaised;
258         endTime = startTime + ICO_PERIOD;
259     }
260 	
261     /**
262     * @dev Must be called after crowdsale ends, to do some extra finalization
263     * work. Calls the contract's finalization function.
264     */
265     function finalize() onlyOwner public {
266         require(!isFinalized);
267         require(hasEnded());
268 
269         ApolloSeptemFinalized();
270 
271         isFinalized = true;
272     }	
273 	
274     /**
275     * @dev Must be called only in special cases 
276     */
277     function apolloSpecialTransfer(address _beneficiary, uint _amount) onlyOwner public {		 
278         specialTransfer(_beneficiary, _amount);
279     }
280 	
281     /**
282     *@dev Must be called after the crowdsale ends, to send the remaining tokens back to owner
283     **/
284     function sendRemaningBalanceToOwner(address _tokenOwner) onlyOwner public {
285         require(_tokenOwner != address(0));
286         
287         sendAllToOwner(_tokenOwner);	
288     }
289 }