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
42  * @title BitDegree Crowdsale
43  */
44 contract BitDegreeCrowdsale {
45     using SafeMath for uint256;
46 
47     // Investor contributions
48     mapping(address => uint256) balances;
49 
50     // The token being sold
51     token public reward;
52 
53     // Owner of the token
54     address public owner;
55 
56     // Start and end timestamps
57     uint public startTime;
58     uint public endTime;
59 
60     // Address where funds are collected
61     address public wallet;
62 
63     // Amount of tokens that were sold
64     uint256 public tokensSold;
65 
66     // Soft cap in BDG tokens
67     uint256 constant public softCap = 6250000 * (10**18);
68 
69     // Hard cap in BDG tokens
70     uint256 constant public hardCap = 336600000 * (10**18);
71 
72     // Switched to true once token contract is notified of when to enable token transfers
73     bool private isStartTimeSet = false;
74 
75     /**
76      * @dev Event for token purchase logging
77      * @param purchaser Address that paid for the tokens
78      * @param beneficiary Address that got the tokens
79      * @param value The amount that was paid (in wei)
80      * @param amount The amount of tokens that were bought
81      */
82     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
83 
84     /**
85      * @dev Event for refund logging
86      * @param receiver The address that received the refund
87      * @param amount The amount that is being refunded (in wei)
88      */
89     event Refund(address indexed receiver, uint256 amount);
90 
91     /**
92      * @param _startTime Unix timestamp for the start of the token sale
93      * @param _endTime Unix timestamp for the end of the token sale
94      * @param _wallet Ethereum address to which the invested funds are forwarded
95      * @param _token Address of the token that will be rewarded for the investors
96      * @param _owner Address of the owner of the smart contract who can execute restricted functions
97      */
98     function BitDegreeCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet, address _token, address _owner)  public {
99         require(_startTime >= now);
100         require(_endTime >= _startTime);
101         require(_wallet != address(0));
102         require(_token != address(0));
103         require(_owner != address(0));
104 
105         startTime = _startTime;
106         endTime = _endTime;
107         wallet = _wallet;
108         owner = _owner;
109         reward = token(_token);
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOwner() {
116         require(msg.sender == owner);
117         _;
118     }
119 
120     /**
121      * @dev Fallback function that can be used to buy tokens. Or in case of the owner, return ether to allow refunds.
122      */
123     function () external payable {
124         if(msg.sender == wallet) {
125             require(hasEnded() && tokensSold < softCap);
126         } else {
127             buyTokens(msg.sender);
128         }
129     }
130 
131     /**
132      * @dev Function for buying tokens
133      * @param beneficiary The address that should receive bought tokens
134      */
135     function buyTokens(address beneficiary) public payable {
136         require(beneficiary != address(0));
137         require(validPurchase());
138 
139         uint256 weiAmount = msg.value;
140         uint256 returnToSender = 0;
141 
142         // Retrieve the current token rate
143         uint256 rate = getRate();
144 
145         // Calculate token amount to be transferred
146         uint256 tokens = weiAmount.mul(rate);
147 
148         // Distribute only the remaining tokens if final contribution exceeds hard cap
149         if(tokensSold.add(tokens) > hardCap) {
150             tokens = hardCap.sub(tokensSold);
151             weiAmount = tokens.div(rate);
152             returnToSender = msg.value.sub(weiAmount);
153         }
154 
155         // update state
156         tokensSold = tokensSold.add(tokens);
157 
158         // update balance
159         balances[beneficiary] = balances[beneficiary].add(weiAmount);
160 
161         assert(reward.transferFrom(owner, beneficiary, tokens));
162         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
163 
164         // Forward funds
165         wallet.transfer(weiAmount);
166 
167         // Allow transfers 2 weeks after hard cap is reached
168         if(tokensSold == hardCap) {
169             reward.setStartTime(now + 2 weeks);
170         }
171 
172         // Notify token contract about sale end time
173         if(!isStartTimeSet) {
174             isStartTimeSet = true;
175             reward.setStartTime(endTime + 2 weeks);
176         }
177 
178         // Return funds that are over hard cap
179         if(returnToSender > 0) {
180             msg.sender.transfer(returnToSender);
181         }
182     }
183 
184     /**
185      * @dev Internal function that is used to determine the current rate for token / ETH conversion
186      * @return The current token rate
187      */
188     function getRate() internal constant returns (uint256) {
189         if(now < (startTime + 1 weeks)) {
190             return 11500;
191         }
192 
193         if(now < (startTime + 2 weeks)) {
194             return 11000;
195         }
196 
197         if(now < (startTime + 3 weeks)) {
198             return 10500;
199         }
200 
201         return 10000;
202     }
203 
204     /**
205      * @dev Internal function that is used to check if the incoming purchase should be accepted.
206      * @return True if the transaction can buy tokens
207      */
208     function validPurchase() internal constant returns (bool) {
209         bool withinPeriod = now >= startTime && now <= endTime;
210         bool nonZeroPurchase = msg.value != 0;
211         bool hardCapNotReached = tokensSold < hardCap;
212         return withinPeriod && nonZeroPurchase && hardCapNotReached;
213     }
214 
215     /**
216      * @return True if crowdsale event has ended
217      */
218     function hasEnded() public constant returns (bool) {
219         return now > endTime || tokensSold >= hardCap;
220     }
221 
222     /**
223      * @dev Returns ether to token holders in case soft cap is not reached.
224      */
225     function claimRefund() external {
226         require(hasEnded());
227         require(tokensSold < softCap);
228 
229         uint256 amount = balances[msg.sender];
230 
231         if(address(this).balance >= amount) {
232             balances[msg.sender] = 0;
233             if (amount > 0) {
234                 msg.sender.transfer(amount);
235                 Refund(msg.sender, amount);
236             }
237         }
238     }
239 
240     /**
241     * @dev Gets the balance of the specified address.
242     * @param _owner The address to query the the balance of.
243     * @return An uint256 representing the amount owned by the passed address.
244     */
245     function balanceOf(address _owner) external constant returns (uint256 balance) {
246         return balances[_owner];
247     }
248 
249 }