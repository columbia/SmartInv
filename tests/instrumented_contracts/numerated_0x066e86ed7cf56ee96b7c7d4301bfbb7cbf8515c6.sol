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
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) onlyOwner public {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a * b;
52         assert(a == 0 || c / a == b);
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 }
74 
75 
76 contract TempusToken {
77 
78     function mint(address receiver, uint256 amount) public returns (bool success);
79 
80 }
81 
82 contract TempusIco is Ownable {
83     using SafeMath for uint256;
84 
85     uint public startTime = 1519894800; //1 March 2018 09:00:00 GMT
86 
87     //initial token price
88     uint public price0 = 0.005 ether / 1000;
89     uint public price1 = price0 * 2;
90     uint public price2 = price1 * 2;
91     uint public price3 = price2 * 2;
92     uint public price4 = price3 * 2;
93 
94     //max tokens could be sold during ico
95     uint public hardCap = 1000000000 * 1000;
96     uint public tokensSold = 0;
97     uint[5] public tokensSoldInPeriod;
98 
99     uint public periodDuration = 30 days;
100 
101     uint public period0End = startTime + periodDuration;
102     uint public period1End = period0End + periodDuration;
103     uint public period2End = period1End + periodDuration;
104     uint public period3End = period2End + periodDuration;
105 
106     bool public paused = false;
107 
108     address withdrawAddress1;
109     address withdrawAddress2;
110 
111     TempusToken token;
112 
113     mapping(address => bool) public sellers;
114 
115     modifier onlySellers() {
116         require(sellers[msg.sender]);
117         _;
118     }
119 
120     function TempusIco (address tokenAddress, address _withdrawAddress1,
121     address _withdrawAddress2) public {
122         token = TempusToken(tokenAddress);
123         withdrawAddress1 = _withdrawAddress1;
124         withdrawAddress2 = _withdrawAddress2;
125     }
126 
127     function periodByDate() public view returns (uint periodNum) {
128         if(now < period0End) {
129             return 0;
130         }
131         if(now < period1End) {
132             return 1;
133         }
134         if(now < period2End) {
135             return 2;
136         }
137         if(now < period3End) {
138             return 3;
139         }
140         return 4;
141     }
142 
143     function priceByPeriod() public view returns (uint price) {
144         uint periodNum = periodByDate();
145         if(periodNum == 0) {
146             return price0;
147         }
148         if(periodNum == 1) {
149             return price1;
150         }
151         if(periodNum == 2) {
152             return price2;
153         }
154         if(periodNum == 3) {
155             return price3;
156         }
157         return price4;
158     }
159 
160     /**
161     * @dev Function that indicates whether pre ico is active or not
162     */
163     function isActive() public view returns (bool active) {
164         bool withinPeriod = now >= startTime;
165         bool capIsNotMet = tokensSold < hardCap;
166         return capIsNotMet && withinPeriod && !paused;
167     }
168 
169     function() external payable {
170         buyFor(msg.sender);
171     }
172 
173     /**
174     * @dev Low-level purchase function. Purchases tokens for specified address
175     * @param beneficiary Address that will get tokens
176     */
177     function buyFor(address beneficiary) public payable {
178         require(msg.value != 0);
179         uint amount = msg.value;
180         require(amount >= 0.1 ether);
181         uint price = priceByPeriod();
182         uint tokenAmount = amount.div(price);
183         makePurchase(beneficiary, tokenAmount);
184     }
185 
186     /**
187     * @dev Function that is called by our robot to allow users
188     * to buy tonkens for various cryptos.
189     * @param beneficiary An address that will get tokens
190     * @param amount Amount of tokens that address will get
191     */
192     function externalPurchase(address beneficiary, uint amount) external onlySellers {
193         makePurchase(beneficiary, amount);
194     }
195 
196     function makePurchase(address beneficiary, uint amount) private {
197         require(beneficiary != 0x0);
198         require(isActive());
199         uint minimumTokens = 1000;
200         if(tokensSold < hardCap.sub(minimumTokens)) {
201             require(amount >= minimumTokens);
202         }
203         require(amount.add(tokensSold) <= hardCap);
204         tokensSold = tokensSold.add(amount);
205         token.mint(beneficiary, amount);
206         updatePeriodStat(amount);
207     }
208 
209     function updatePeriodStat(uint amount) private {
210         uint periodNum = periodByDate();
211         tokensSoldInPeriod[periodNum] = tokensSoldInPeriod[periodNum] + amount;
212         if(periodNum == 5) {
213             return;
214         }
215         uint amountOnStart = hardCap - tokensSold + tokensSoldInPeriod[periodNum];
216         uint percentSold = (tokensSoldInPeriod[periodNum] * 100) / amountOnStart;
217         if(percentSold >= 20) {
218             resetPeriodDates(periodNum);
219         }
220     }
221 
222     function resetPeriodDates(uint periodNum) private {
223         if(periodNum == 0) {
224             period0End = now;
225             period1End = period0End + periodDuration;
226             period2End = period1End + periodDuration;
227             period3End = period2End + periodDuration;
228             return;
229         }
230         if(periodNum == 1) {
231             period1End = now;
232             period2End = period1End + periodDuration;
233             period3End = period2End + periodDuration;
234             return;
235         }
236         if(periodNum == 2) {
237             period2End = now;
238             period3End = period2End + periodDuration;
239             return;
240         }
241         if(periodNum == 3) {
242             period3End = now;
243             return;
244         }
245     }
246 
247     function setPaused(bool isPaused) external onlyOwner {
248         paused = isPaused;
249     }
250 
251     /**
252     * @dev Sets address of seller robot
253     * @param seller Address of seller robot to set
254     * @param isSeller Parameter whether set as seller or not
255     */
256     function setAsSeller(address seller, bool isSeller) external onlyOwner {
257         sellers[seller] = isSeller;
258     }
259 
260     /**
261     * @dev Set start time of ICO
262     * @param _startTime Start of ICO (unix time)
263     */
264     function setStartTime(uint _startTime) external onlyOwner {
265         startTime = _startTime;
266     }
267 
268     /**
269     * @dev Function to get ether from contract
270     * @param amount Amount in wei to withdraw
271     */
272     function withdrawEther(uint amount) external onlyOwner {
273         withdrawAddress1.transfer(amount / 2);
274         withdrawAddress2.transfer(amount / 2);
275     }
276 }