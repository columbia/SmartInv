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
85     // start and end timestamps where investments are allowed (both inclusive)
86 //    uint public startTime = 1519894800; //1 March 2018 09:00:00 GMT
87     uint public startTime = 1519635600; //26 Feb 2018 09:00:00 GMT
88 
89     //initial token price
90     uint public price0 = 0.005 ether / 1000;
91     uint public price1 = price0 * 2;
92     uint public price2 = price1 * 2;
93     uint public price3 = price2 * 2;
94     uint public price4 = price3 * 2;
95 
96     //max tokens could be sold during ico
97     uint public hardCap = 1000000000 * 1000;
98     uint public tokensSold = 0;
99     uint[5] public tokensSoldInPeriod;
100 
101     uint public periodDuration = 30 days;
102 
103     uint public period0End = startTime + periodDuration;
104     uint public period1End = period0End + periodDuration;
105     uint public period2End = period1End + periodDuration;
106     uint public period3End = period2End + periodDuration;
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
142         return 4;
143     }
144 
145     function priceByPeriod() public view returns (uint price) {
146         uint periodNum = periodByDate();
147         if(periodNum == 0) {
148             return price0;
149         }
150         if(periodNum == 1) {
151             return price1;
152         }
153         if(periodNum == 2) {
154             return price2;
155         }
156         if(periodNum == 3) {
157             return price3;
158         }
159         return price4;
160     }
161 
162     /**
163     * @dev Function that indicates whether pre ico is active or not
164     */
165     function isActive() public view returns (bool active) {
166         bool withinPeriod = now >= startTime;
167         bool capIsNotMet = tokensSold < hardCap;
168         return capIsNotMet && withinPeriod && !paused;
169     }
170 
171     function() external payable {
172         buyFor(msg.sender);
173     }
174 
175     /**
176     * @dev Low-level purchase function. Purchases tokens for specified address
177     * @param beneficiary Address that will get tokens
178     */
179     function buyFor(address beneficiary) public payable {
180         require(msg.value != 0);
181         uint amount = msg.value;
182         require(amount >= 0.1 ether);
183         uint price = priceByPeriod();
184         uint tokenAmount = amount.div(price);
185         makePurchase(beneficiary, tokenAmount);
186     }
187 
188     /**
189     * @dev Function that is called by our robot to allow users
190     * to buy tonkens for various cryptos.
191     * @param beneficiary An address that will get tokens
192     * @param amount Amount of tokens that address will get
193     */
194     function externalPurchase(address beneficiary, uint amount) external onlySellers {
195         makePurchase(beneficiary, amount);
196     }
197 
198     function makePurchase(address beneficiary, uint amount) private {
199         require(beneficiary != 0x0);
200         require(isActive());
201         uint minimumTokens = 1000;
202         if(tokensSold < hardCap.sub(minimumTokens)) {
203             require(amount >= minimumTokens);
204         }
205         require(amount.add(tokensSold) <= hardCap);
206         tokensSold = tokensSold.add(amount);
207         token.mint(beneficiary, amount);
208         updatePeriodStat(amount);
209     }
210 
211     function updatePeriodStat(uint amount) private {
212         uint periodNum = periodByDate();
213         tokensSoldInPeriod[periodNum] = tokensSoldInPeriod[periodNum] + amount;
214         if(periodNum == 5) {
215             return;
216         }
217         uint amountOnStart = hardCap - tokensSold + tokensSoldInPeriod[periodNum];
218         uint percentSold = (tokensSoldInPeriod[periodNum] * 100) / amountOnStart;
219         if(percentSold >= 20) {
220             resetPeriodDates(periodNum);
221         }
222     }
223 
224     function resetPeriodDates(uint periodNum) private {
225         if(periodNum == 0) {
226             period0End = now;
227             period1End = period0End + periodDuration;
228             period2End = period1End + periodDuration;
229             period3End = period2End + periodDuration;
230             return;
231         }
232         if(periodNum == 1) {
233             period1End = now;
234             period2End = period1End + periodDuration;
235             period3End = period2End + periodDuration;
236             return;
237         }
238         if(periodNum == 2) {
239             period2End = now;
240             period3End = period2End + periodDuration;
241             return;
242         }
243         if(periodNum == 3) {
244             period3End = now;
245             return;
246         }
247     }
248 
249     function setPaused(bool isPaused) external onlyOwner {
250         paused = isPaused;
251     }
252 
253     /**
254     * @dev Sets address of seller robot
255     * @param seller Address of seller robot to set
256     * @param isSeller Parameter whether set as seller or not
257     */
258     function setAsSeller(address seller, bool isSeller) external onlyOwner {
259         sellers[seller] = isSeller;
260     }
261 
262     /**
263     * @dev Set start time of ICO
264     * @param _startTime Start of ICO (unix time)
265     */
266     function setStartTime(uint _startTime) external onlyOwner {
267         startTime = _startTime;
268     }
269 
270     /**
271     * @dev Function to get ether from contract
272     * @param amount Amount in wei to withdraw
273     */
274     function withdrawEther(uint amount) external onlyOwner {
275         withdrawAddress1.transfer(amount / 2);
276         withdrawAddress2.transfer(amount / 2);
277     }
278 }