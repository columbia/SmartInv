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
85     uint public startTime = 1519916400; //1 March 2018 15:00:00 GMT
86 
87     //initial token price
88     uint public price0 = 0.005 ether / 1000;
89     uint public price1 = price0 * 2;
90     uint public price2 = price1 * 2;
91     uint public price3 = price2 * 2;
92     uint public price4 = price3 * 2;
93     uint public price5 = price4 * 2;
94 
95     //max tokens could be sold during ico
96     uint public hardCap = 1000000000 * 1000;
97     uint public tokensSold = 0;
98     uint[6] public tokensSoldInPeriod;
99 
100     uint public periodDuration = 30 days;
101 
102     uint public period0End = startTime + 31 days;
103     uint public period1End = period0End + 30 days;
104     uint public period2End = period1End + 31 days;
105     uint public period3End = period2End + 30 days;
106     uint public period4End = period3End + 31 days;
107 
108     bool public paused = false;
109 
110     address withdrawAddress1;
111     address withdrawAddress2;
112 
113     TempusToken token;
114 
115     mapping(address => bool) public sellers;
116 
117     modifier onlySellers() {
118         require(sellers[msg.sender]);
119         _;
120     }
121 
122     function TempusIco (address tokenAddress, address _withdrawAddress1,
123     address _withdrawAddress2) public {
124         token = TempusToken(tokenAddress);
125         withdrawAddress1 = _withdrawAddress1;
126         withdrawAddress2 = _withdrawAddress2;
127     }
128 
129     function periodByDate() public view returns (uint periodNum) {
130         if(now < period0End) {
131             return 0;
132         }
133         if(now < period1End) {
134             return 1;
135         }
136         if(now < period2End) {
137             return 2;
138         }
139         if(now < period3End) {
140             return 3;
141         }
142         if(now < period4End) {
143             return 4;
144         }
145         return 5;
146     }
147 
148     function priceByPeriod() public view returns (uint price) {
149         uint periodNum = periodByDate();
150         if(periodNum == 0) {
151             return price0;
152         }
153         if(periodNum == 1) {
154             return price1;
155         }
156         if(periodNum == 2) {
157             return price2;
158         }
159         if(periodNum == 3) {
160             return price3;
161         }
162         if(periodNum == 4) {
163             return price4;
164         }
165         return price5;
166     }
167 
168     /**
169     * @dev Function that indicates whether pre ico is active or not
170     */
171     function isActive() public view returns (bool active) {
172         bool withinPeriod = now >= startTime;
173         bool capIsNotMet = tokensSold < hardCap;
174         return capIsNotMet && withinPeriod && !paused;
175     }
176 
177     function() external payable {
178         buyFor(msg.sender);
179     }
180 
181     /**
182     * @dev Low-level purchase function. Purchases tokens for specified address
183     * @param beneficiary Address that will get tokens
184     */
185     function buyFor(address beneficiary) public payable {
186         require(msg.value != 0);
187         uint amount = msg.value;
188         require(amount >= 0.1 ether);
189         uint price = priceByPeriod();
190         uint tokenAmount = amount.div(price);
191         makePurchase(beneficiary, tokenAmount);
192     }
193 
194     /**
195     * @dev Function that is called by our robot to allow users
196     * to buy tonkens for various cryptos.
197     * @param beneficiary An address that will get tokens
198     * @param amount Amount of tokens that address will get
199     */
200     function externalPurchase(address beneficiary, uint amount) external onlySellers {
201         makePurchase(beneficiary, amount);
202     }
203 
204     function makePurchase(address beneficiary, uint amount) private {
205         require(beneficiary != 0x0);
206         require(isActive());
207         uint minimumTokens = 1000;
208         if(tokensSold < hardCap.sub(minimumTokens)) {
209             require(amount >= minimumTokens);
210         }
211         require(amount.add(tokensSold) <= hardCap);
212         tokensSold = tokensSold.add(amount);
213         token.mint(beneficiary, amount);
214         updatePeriodStat(amount);
215     }
216 
217     function updatePeriodStat(uint amount) private {
218         uint periodNum = periodByDate();
219         tokensSoldInPeriod[periodNum] = tokensSoldInPeriod[periodNum] + amount;
220         if(periodNum == 5) {
221             return;
222         }
223         uint amountOnStart = hardCap - tokensSold + tokensSoldInPeriod[periodNum];
224         uint percentSold = (tokensSoldInPeriod[periodNum] * 100) / amountOnStart;
225         if(percentSold >= 20) {
226             resetPeriodDates(periodNum);
227         }
228     }
229 
230     function resetPeriodDates(uint periodNum) private {
231         if(periodNum == 0) {
232             period0End = now;
233             period1End = period0End + periodDuration;
234             period2End = period1End + periodDuration;
235             period3End = period2End + periodDuration;
236             period4End = period3End + periodDuration;
237             return;
238         }
239         if(periodNum == 1) {
240             period1End = now;
241             period2End = period1End + periodDuration;
242             period3End = period2End + periodDuration;
243             period4End = period3End + periodDuration;
244             return;
245         }
246         if(periodNum == 2) {
247             period2End = now;
248             period3End = period2End + periodDuration;
249             period4End = period3End + periodDuration;
250             return;
251         }
252         if(periodNum == 3) {
253             period3End = now;
254             period4End = period3End + periodDuration;
255             return;
256         }
257         if(periodNum == 4) {
258             period4End = now;
259             return;
260         }
261     }
262 
263     function setPaused(bool isPaused) external onlyOwner {
264         paused = isPaused;
265     }
266 
267     /**
268     * @dev Sets address of seller robot
269     * @param seller Address of seller robot to set
270     * @param isSeller Parameter whether set as seller or not
271     */
272     function setAsSeller(address seller, bool isSeller) external onlyOwner {
273         sellers[seller] = isSeller;
274     }
275 
276     /**
277     * @dev Set start time of ICO
278     * @param _startTime Start of ICO (unix time)
279     */
280     function setStartTime(uint _startTime) external onlyOwner {
281         startTime = _startTime;
282     }
283 
284     /**
285     * @dev Function to get ether from contract
286     * @param amount Amount in wei to withdraw
287     */
288     function withdrawEther(uint amount) external onlyOwner {
289         withdrawAddress1.transfer(amount / 2);
290         withdrawAddress2.transfer(amount / 2);
291     }
292 }