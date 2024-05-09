1 pragma solidity ^0.4.21;
2 
3 /*************************/
4 /* Blocksquare Series A  */
5 /*************************/
6 
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
18         uint256 c = a / b;
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract owned {
35     address public owner;
36 
37     function owned() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function tranferOwnership(address _newOwner) public onlyOwner() {
47         owner = _newOwner;
48     }
49 }
50 
51 contract Token {
52     function mintTokens(address _atAddress, uint256 _amount) public;
53 }
54 
55 contract Whitelist {
56     function isWhitelisted(address _user) constant public returns(bool);
57 }
58 
59 
60 /****************************************/
61 /* BLOCKSQUARE SERIES A IMPLEMENTATION  */
62 /****************************************/
63 contract BlocksquareSeriesA is owned {
64     using SafeMath for uint256;
65 
66     /** Events **/
67     event Received(address indexed _from, uint256 _amount);
68     event FundsReturned(address indexed _to, uint256 _amount);
69     event TokensGiven(address indexed _to, uint256 _amount);
70     event ErrorReturningEth(address _to, uint256 _amount);
71 
72     /** Public variables **/
73     uint256 public currentAmountRaised;
74     uint256 public currentAmountOfTokensWithNoBonus;
75     uint256 public valueInUSD;
76     uint256 public startTime;
77     uint256 public endTime;
78     address public recipient;
79 
80     /** Private variables **/
81     uint256 nextParticipantIndex;
82     uint256 currentAmountOfTokens;
83     bool icoHasStarted;
84     bool icoHasClosed;
85     Token reward;
86     Whitelist whitelist;
87 
88     /** Constants **/
89     uint256 BONUS25 = 60*60;
90     uint256 BONUS15 = BONUS25.add(60*60*24*4);
91     uint256 BONUS7 = BONUS15.add(60*60*24*5);
92     uint256 PRICEOFTOKEN = 25; // It means 0.25 USD
93     uint256 MAXAMOUNTOFTOKENS = (1200000 * 10 ** 18);
94 
95     /** Mappings **/
96     mapping(address => uint256) contributed;
97     mapping(uint256 => address) participantIndex;
98 
99     function BlocksquareSeriesA() public {
100         owner = msg.sender;
101         recipient = msg.sender;
102         reward = Token(0x509A38b7a1cC0dcd83Aa9d06214663D9eC7c7F4a);
103         whitelist = Whitelist(0xCB641F6B46e1f2970dB003C19515018D0338550a);
104     }
105 
106     /**
107     * Basic payment
108     **/
109     function () payable public {
110         require(reward != address(0));
111         require(whitelist != address(0));
112         require(msg.value >= (2 ether / 10));
113         require(icoHasStarted);
114         require(!icoHasClosed);
115         require(valueInUSD != 0);
116         require(whitelist.isWhitelisted(msg.sender));
117         if(contributed[msg.sender] == 0) {
118             participantIndex[nextParticipantIndex] = msg.sender;
119             nextParticipantIndex += 1;
120         }
121 
122         uint256 amountOfWei = msg.value;
123 
124         contributed[msg.sender] = contributed[msg.sender].add(amountOfWei);
125         currentAmountRaised = currentAmountRaised.add(amountOfWei);
126         uint256 tokens = tokensToMint(amountOfWei);
127 
128         reward.mintTokens(msg.sender, tokens);
129         currentAmountOfTokens = currentAmountOfTokens.add(tokens);
130         emit Received(msg.sender, msg.value);
131         emit TokensGiven(msg.sender, tokens);
132 
133         if(address(this).balance >= 50 ether) {
134             if(!address(recipient).send(address(this).balance)) {
135                 emit ErrorReturningEth(recipient, address(this).balance);
136             }
137         }
138     }
139 
140 
141     /**
142     * Calculate tokens to mint.
143     *
144     * Calculets how much tokens sender will get based on _amountOfWei he sent.
145     *
146     * @param _amountOfWei Amount of wei sender has sent to the contract.
147     * @return Number of tokens sender will recieve.
148     **/
149     function tokensToMint(uint256 _amountOfWei) private returns (uint256) {
150         uint256 tokensPerEth = valueInUSD.div(PRICEOFTOKEN);
151 
152         uint256 rewardAmount = tokensPerEth.mul(_amountOfWei);
153         if(currentAmountOfTokensWithNoBonus.add(rewardAmount) > MAXAMOUNTOFTOKENS) {
154             icoHasClosed = true;
155             uint256 over = currentAmountOfTokensWithNoBonus.add(rewardAmount).sub(MAXAMOUNTOFTOKENS);
156             rewardAmount = rewardAmount.sub(over);
157             uint256 weiToReturn = over.div(tokensPerEth);
158             currentAmountRaised = currentAmountRaised.sub(weiToReturn);
159             contributed[msg.sender] = contributed[msg.sender].sub(weiToReturn);
160             if(address(msg.sender).send(weiToReturn)) {
161                 emit ErrorReturningEth(msg.sender, weiToReturn);
162             }
163         }
164         currentAmountOfTokensWithNoBonus = currentAmountOfTokensWithNoBonus.add(rewardAmount);
165 
166         if(block.timestamp <= startTime.add(BONUS25)) {
167             rewardAmount = rewardAmount.add(rewardAmount.mul(25).div(100));
168         }
169         else if(block.timestamp <= startTime.add(BONUS15)) {
170             rewardAmount = rewardAmount.add(rewardAmount.mul(15).div(100));
171         }
172         else if(block.timestamp <= startTime.add(BONUS7)) {
173             rewardAmount = rewardAmount.add(rewardAmount.mul(7).div(100));
174         }
175 
176         return rewardAmount;
177     }
178 
179     /**
180     * Change USD value
181     *
182     * Change value of ETH in USD
183     *
184     * @param _value New value of ETH in USD
185     **/
186     function changeETHUSD(uint256 _value) public onlyOwner {
187         valueInUSD = _value;
188     }
189 
190     /**
191     * Start Series A
192     *
193     * Starts Series A and sets value of ETH in USD.
194     *
195     * @param _value Value of ETH in USD.
196     **/
197     function start(uint256 _value) public onlyOwner {
198         require(!icoHasStarted);
199         valueInUSD = _value;
200         startTime = block.timestamp;
201         endTime = startTime.add(60*60).add(60*60*24*16);
202         icoHasStarted = true;
203     }
204 
205     /**
206     * Close Series A
207     *
208     * Closes Series A.
209     **/
210     function closeICO() public onlyOwner {
211         require(icoHasStarted);
212         icoHasClosed = true;
213     }
214 
215     /**
216     * Withdraw Ether
217     *
218     * Withdraw Ether from contract.
219     **/
220     function withdrawEther() public onlyOwner {
221         if(!address(recipient).send(address(this).balance)) {
222             emit ErrorReturningEth(recipient, address(this).balance);
223         }
224     }
225 
226     /** Getters functions for info **/
227     function getToken() constant public returns (address _tokenAddress) {
228         return address(reward);
229     }
230 
231     function isCrowdsaleOpen() constant public returns (bool _isOpened) {
232         return (!icoHasClosed && icoHasStarted);
233     }
234 
235     function amountContributed(address _contributor) constant public returns(uint256 _contributedUntilNow){
236         return contributed[_contributor];
237     }
238 
239     function numberOfContributors() constant public returns(uint256 _numOfContributors){
240         return nextParticipantIndex;
241     }
242 
243     function numberOfTokens() constant public returns(uint256) {
244         return currentAmountOfTokens;
245     }
246 
247     function hasAllowanceToRecieveTokens(address _address) constant public returns(bool) {
248         return whitelist.isWhitelisted(_address);
249     }
250 }