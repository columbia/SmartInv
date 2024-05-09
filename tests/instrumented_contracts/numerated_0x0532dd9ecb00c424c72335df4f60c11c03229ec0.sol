1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract token {
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
38     function setStartTime(uint _startTime) external;
39 }
40 
41 /**
42  * @title Obirum Crowdsale
43  */
44 contract ObirumCrowdsale{
45     using SafeMath for uint256;
46 
47     /** Constants
48     * ----------
49     * kRate - Ether to Obirum rate. 1 ether is 20000 tokens.
50     * kMinStake - Min amount of Ether that can be contributed.
51     * kMaxStake - Max amount of Ether that can be contributed.
52     */
53     uint256 public constant kRate = 20000;
54     uint256 public constant kMinStake = 0.1 ether;
55     uint256 public constant kMaxStake = 200 ether;
56 
57     uint256[9] internal stageLimits = [
58         100 ether,
59         300 ether,
60         1050 ether,
61         3050 ether,
62         8050 ether,
63         18050 ether,
64         28050 ether,
65         38050 ether,
66         48050 ether
67     ];
68     uint128[9] internal stageDiscounts = [
69         300,
70         250,
71         200,
72         150,
73         135,
74         125,
75         115,
76         110,
77         105
78     ];
79 
80     // Investor contributions
81     mapping(address => uint256) balances;
82 
83     uint256 public weiRaised;
84     uint8 public currentStage = 0;
85 
86     // The token being sold
87     token public reward;
88 
89     // Owner of the token
90     address public owner;
91 
92     // Start and end timestamps
93     uint public startTime;
94     uint public endTime;
95 
96     // Address where funds are collected
97     address public wallet;
98 
99     // Amount of tokens that were sold
100     uint256 public tokensSold;
101 
102     // Soft cap in OBR tokens
103     uint256 constant public softCap = 106000000 * (10**18);
104 
105     // Hard cap in OBR tokens
106     uint256 constant public hardCap = 1151000000 * (10**18);
107 
108     // Switched to true once token contract is notified of when to enable token transfers
109     bool private isStartTimeSet = false;
110 
111     /**
112      * @dev Event for token purchase logging
113      * @param purchaser Address that paid for the tokens
114      * @param beneficiary Address that got the tokens
115      * @param value The amount that was paid (in wei)
116      * @param amount The amount of tokens that were bought
117      */
118     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
119 
120     /**
121      * @dev Event for refund logging
122      * @param receiver The address that received the refund
123      * @param amount The amount that is being refunded (in wei)
124      */
125     event Refund(address indexed receiver, uint256 amount);
126 
127     /**
128      * @param _startTime Unix timestamp for the start of the token sale
129      * @param _endTime Unix timestamp for the end of the token sale
130      * @param _wallet Ethereum address to which the invested funds are forwarded
131      * @param _token Address of the token that will be rewarded for the investors
132      * @param _owner Address of the owner of the smart contract who can execute restricted functions
133      */
134     function ObirumCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet, address _token, address _owner)  public {
135         require(_startTime >= now);
136         require(_endTime >= _startTime);
137         require(_wallet != address(0));
138         require(_token != address(0));
139         require(_owner != address(0));
140 
141         startTime = _startTime;
142         endTime = _endTime;
143         wallet = _wallet;
144         owner = _owner;
145         reward = token(_token);
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         require(msg.sender == owner);
153         _;
154     }
155 
156     /**
157      * @dev Fallback function that can be used to buy tokens. Or in case of the owner, return ether to allow refunds.
158      */
159     function () external payable {
160         if(msg.sender == wallet) {
161             require(hasEnded() && tokensSold < softCap);
162         } else {
163             buyTokens(msg.sender);
164         }
165     }
166 
167     /**
168      * @dev Function for buying tokens
169      * @param beneficiary The address that should receive bought tokens
170      */
171     function buyTokens(address beneficiary) public payable {
172         require(beneficiary != address(0));
173         require(validPurchase());
174         require(currentStage < getStageCount());
175         
176         uint256 value = msg.value;
177         weiRaised = weiRaised.add(value);
178         uint256 limit = getStageLimit(currentStage);
179         uint256 dif = 0;
180         uint256 returnToSender = 0;
181     
182         if(weiRaised > limit){
183             dif = weiRaised.sub(limit);
184             value = value.sub(dif);
185             
186             if(currentStage == getStageCount() - 1){
187                 returnToSender = dif;
188                 weiRaised = weiRaised.sub(dif);
189                 dif = 0;
190             }
191         }
192         
193         mintTokens(value, beneficiary);
194         
195         if(dif > 0){
196             currentStage = currentStage + 1;
197             mintTokens(dif, beneficiary);
198         }
199 
200         // Allow transfers 2 weeks after hard cap is reached
201         if(tokensSold == hardCap) {
202             reward.setStartTime(now + 2 weeks);
203         }
204 
205         // // Return funds that are over hard cap
206         if(returnToSender > 0) {
207             msg.sender.transfer(returnToSender);
208         }
209     }
210     
211     function mintTokens(uint256 value, address sender) private{
212         uint256 tokens = value.mul(kRate).mul(getStageDiscount(currentStage)).div(100);
213         
214         // update state
215         tokensSold = tokensSold.add(tokens);
216         
217         // update balance
218         balances[sender] = balances[sender].add(value);
219         reward.transferFrom(owner, sender, tokens);
220         
221         TokenPurchase(msg.sender, sender, value, tokens);
222         
223         // Forward funds
224         wallet.transfer(value);
225     }
226 
227     /**
228      * @dev Internal function that is used to check if the incoming purchase should be accepted.
229      * @return True if the transaction can buy tokens
230      */
231     function validPurchase() internal constant returns (bool) {
232         bool withinPeriod = now >= startTime && now <= endTime;
233         bool nonZeroPurchase = msg.value != 0 && msg.value >= kMinStake && msg.value <= kMaxStake;
234         bool hardCapNotReached = tokensSold < hardCap;
235         return withinPeriod && nonZeroPurchase && hardCapNotReached;
236     }
237 
238     /**
239      * @return True if crowdsale event has ended
240      */
241     function hasEnded() public constant returns (bool) {
242         return now > endTime || tokensSold >= hardCap;
243     }
244 
245     /**
246      * @dev Returns ether to token holders in case soft cap is not reached.
247      */
248     function claimRefund() external {
249         require(hasEnded());
250         require(tokensSold < softCap);
251 
252         uint256 amount = balances[msg.sender];
253 
254         if(address(this).balance >= amount) {
255             balances[msg.sender] = 0;
256             if (amount > 0) {
257                 msg.sender.transfer(amount);
258                 Refund(msg.sender, amount);
259             }
260         }
261     }
262 
263     /**
264     * @dev Gets the balance of the specified address.
265     * @param _owner The address to query the the balance of.
266     * @return An uint256 representing the amount owned by the passed address.
267     */
268     function balanceOf(address _owner) external constant returns (uint256 balance) {
269         return balances[_owner];
270     }
271 
272     function getStageLimit(uint8 _stage) public view returns (uint256) {
273         return stageLimits[_stage];
274     }
275 
276     function getStageDiscount(uint8 _stage) public view returns (uint128) {
277         return stageDiscounts[_stage];
278     }
279 
280     function getStageCount() public view returns (uint8) {
281         return uint8(stageLimits.length);
282     }
283 }