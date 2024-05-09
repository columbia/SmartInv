1 pragma solidity ^0.4.11;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8     function div(uint256 a, uint256 b) internal constant returns (uint256) {
9         // assert(b > 0); // Solidity automatically throws when dividing by 0
10         uint256 c = a / b;
11         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12         return c;
13     }
14     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18     function add(uint256 a, uint256 b) internal constant returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }
24 
25 contract SynToken {
26     string public name = "TEST TOKEN";
27     string public symbol = "TEST";
28     uint256 public decimals = 18;
29     
30     uint256 public totalSupply;
31     address public owner;
32     using SafeMath for uint256;
33     mapping(address => uint256) balances;
34 
35     mapping (address => mapping (address => uint256)) allowed;
36 
37     bool public mintingFinished = false;
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47 
48     /**
49     * @dev transfer token for a specified address
50     * @param _to The address to transfer to.
51     * @param _value The amount to be transferred.
52     */
53     function transfer(address _to, uint256 _value) public returns (bool) ;
54     
55     /**
56     * @dev Gets the balance of the specified address.
57     * @param _owner The address to query the the balance of.
58     * @return An uint256 representing the amount owned by the passed address.
59     */
60     function balanceOf(address _owner) public constant returns (uint256 balance) ;
61     
62 
63     /**
64      * @dev Transfer tokens from one address to another
65      * @param _from address The address which you want to send tokens from
66      * @param _to address The address which you want to transfer to
67      * @param _value uint256 the amount of tokens to be transferred
68      */
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
70 
71         /**
72      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
73      *
74      * Beware that changing an allowance with this method brings the risk that someone may use both the old
75      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
76      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      * @param _spender The address which will spend the funds.
79      * @param _value The amount of tokens to be spent.
80      */
81     function approve(address _spender, uint256 _value) public returns (bool) ;
82     
83     /**
84      * @dev Function to check the amount of tokens that an owner allowed to a spender.
85      * @param _owner address The address which owns the funds.
86      * @param _spender address The address which will spend the funds.
87      * @return A uint256 specifying the amount of tokens still available for the spender.
88      */
89     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
90 
91      /**
92      * approve should be called when allowed[_spender] == 0. To increment
93      * allowed value is better to use this function to avoid 2 calls (and wait until
94      * the first transaction is mined)
95      * From MonolithDAO Token.sol
96      */
97     function increaseApproval (address _spender, uint _addedValue) returns (bool success);
98 
99     function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
100 
101     /**
102      * @dev Function to mint tokens
103      * @param _to The address that will receive the minted tokens.
104      * @param _amount The amount of tokens to mint.
105      * @return A boolean that indicates if the operation was successful.
106      */
107     function mint(address _to, uint256 _amount)  public returns (bool);
108 
109     /**
110      * @dev Function to stop minting new tokens.
111      * @return True if the operation was successful.
112      */
113     function finishMinting() public returns (bool);
114 
115 
116     /**
117      * @dev Allows the current owner to transfer control of the contract to a newOwner.
118      * @param newOwner The address to transfer ownership to.
119      */
120     function transferOwnership(address newOwner) public;
121 }
122 
123 
124 /**
125  * @title Crowdsale
126  * @dev Crowdsale is a base contract for managing a token crowdsale.
127  * Crowdsales have a start and end timestamps, where investors can make
128  * token purchases and the crowdsale will assign them tokens based
129  * on a token per ETH rate. Funds collected are forwarded to a wallet
130  * as they arrive.
131  */
132 contract SynTokenCrowdsale {
133     using SafeMath for uint256;
134 
135     // The token being sold
136     SynToken public token;
137 
138     // start and end timestamps where investments are allowed (both inclusive)
139     uint256 public startTime;
140     uint256 public endTime;
141 
142     // address where funds are collected
143     address public wallet;
144 
145     // how many token units a buyer gets per wei
146     uint256 public rate;
147 
148     // amount of raised money in wei
149     uint256 public weiRaised;
150 
151     /*
152     Custom vars
153    */
154 
155     uint256 public cap = 500*10**24;//500milllion SYN
156     uint256 public foundationAmount = (2*cap)/3;// 2/3s of cap
157     address public tokenWallet = 0x2411350f3bCAFd33a9C162a6672a93575ec151DC;
158     uint256 public tokensSold = 0;//for ether raised, call weiRaised and convert to ether
159     address public admin = 0x2411350f3bCAFd33a9C162a6672a93575ec151DC;
160     uint[] public salesRates = [2000,2250,2500]; 
161     address public constant SynTokenAddress = 0x2411350f3bCAFd33a9C162a6672a93575ec151DC;  
162 
163     bool public crowdsaleLive = false;
164     bool public crowdsaleInit = false;
165     bool public appliedPresale = false;
166 
167     event NextRate(uint256 _rate);
168 
169     /**
170      * event for token purchase logging
171      * @param purchaser who paid for the tokens
172      * @param beneficiary who got the tokens
173      * @param value weis paid for purchase
174      * @param amount amount of tokens purchased
175      */
176     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
177 
178 
179     function SynTokenCrowdsale() {
180     }
181 
182     // fallback function can be used to buy tokens
183     function () payable {
184         buyTokens(msg.sender);
185     }
186 
187     // @return true if crowdsale event has ended
188     function hasEnded() public constant returns (bool) {
189         return now > endTime;
190     }
191 
192     // send ether to the fund collection wallet
193     // override to create custom fund forwarding mechanisms
194     function forwardFunds() internal {
195         wallet.transfer(msg.value);
196     }
197 
198 //OVERLOADED/CUSTOM METHODS
199   modifier adminOnly{
200     if(msg.sender == admin) //    SHOULD THIS BE MSG.SENDER NOT MSG.SEND
201     _;
202     
203   } 
204 
205 
206     // low level token purchase function
207 function buyTokens(address beneficiary) public payable {
208 require(beneficiary != 0x0);
209 require(validPurchase());
210 
211 uint256 weiAmount = msg.value;
212 
213 // calculate token amount to be created
214 uint256 tokens = weiAmount.mul(rate);
215 
216 //revert purchase attempts beyond token supply
217 require(tokens <= cap - tokensSold); 
218 
219 // update state
220 weiRaised = weiRaised.add(weiAmount);
221 tokensSold = tokensSold.add(tokens);
222 
223 token.mint(beneficiary, tokens);
224 TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
225 forwardFunds();
226 }
227 // @return true if the transaction can buy tokens
228 function validPurchase() internal constant returns (bool) {
229 
230 bool capNotReached = tokensSold <= cap;   
231 bool withinPeriod = now >= startTime && now <= endTime;
232 bool nonZeroPurchase = msg.value != 0;
233     if(now >= startTime){
234         forwardRemaining();
235     }
236 return (nonZeroPurchase && withinPeriod && capNotReached) ;
237 }
238 
239 //forward all remaining tokens to the foundation address
240 function forwardRemaining() internal {
241     require(crowdsaleLive);
242 require(now > endTime);
243 uint256 remaining = cap - tokensSold;
244 require(remaining < cap);
245 tokensSold += remaining;
246 token.mint(tokenWallet, remaining);
247     token.finishMinting();
248     crowdsaleLive = false;
249 }
250 
251 function nextRate(uint _rate) adminOnly {
252 require(now > endTime);
253 require(salesRates[_rate] < rate );
254 rate = salesRates[_rate];
255 }
256 
257 function setToken(address _tokenAddress){
258     token = SynToken(_tokenAddress);
259 }
260 
261 
262 function initCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenAddress) adminOnly {
263     require(!crowdsaleInit);    
264     require(_startTime >= now);
265     require(_endTime >= _startTime);
266     require(_rate > 0);
267     require(_wallet != 0x0);
268 
269     startTime = _startTime;
270     endTime = _endTime;
271     rate = _rate;
272     wallet = _wallet;
273     crowdsaleInit=true;
274 }
275 
276 
277 function applyPresale() adminOnly{
278 
279     require(crowdsaleInit);
280     require(!appliedPresale);
281 
282     token.mint(0x3de1483fda9f3383c422d8713008e5d272aa73ee, 35448897500000000000000);
283 	token.mint(0xe695e2d9243303dccff5a26731cc0083f3b10c8b, 100000000000000000000000);
284 	token.mint(0x1bf45eb62434a0dac0de59753e431210d2b33f24, 32500000000000000000000);
285 	token.mint(0x92009d954ff9efd69708e2dd2166f7e60124ce09, 22500000000000000000000);
286 	token.mint(0xe579c7b478d40c85871ac5553d488b65be9a9264, 1250000000000000000000);
287 	token.mint(0xa576e704a1c1d8d7e2fdfdd251b15a3265397121, 2500000000000000000000);
288 	token.mint(0x9e40c7ee30cefb4327ea2c83869cd161ff5fa71f, 250000000000000000000);
289 	token.mint(0xcc6b7ed85bf68ee9def96b95f3356a8072a01030, 50008790160000000000000);
290 	token.mint(0xf406317925ad6a9ea40cdf40cc1c9b0dd65ca10c, 250000000000000000000000);
291 	token.mint(0x69965bb6487178234ddcc835cb2ceccadd4e1431, 1250000000000000000000);
292 	token.mint(0xe7558aa60d1135410f03479df94ea439e782d541, 1950000000000000000000);
293 	token.mint(0x75360cbe8c7cb8174b1b623a6d9aacf952c117e3, 50000000000000000000000);
294 	token.mint(0x001a1a6ccf3b97b983d709c0d34a0de574b90a19, 2500000000000000000000);
295 	token.mint(0x56488a1d3dc8bb20b75e8317448f1a1fbadcb999, 2725000000000000000000);
296 	token.mint(0xf16e0aa06d745026bc80686e492b0f9b0578b5bd, 3200000000000000000000);
297 	token.mint(0xc046b59484843b2af6ca105afd88a3ab60e9b7cd, 1250000000000000000000);
298 	token.mint(0x479a8f11ee100a1cc99cd06e67dba639aaec56f7, 12489500000000000000000);
299 	token.mint(0x9369263b70dec0b65064bd6967e6b01c3a9377ec, 750000000000000000000);
300 	token.mint(0x89560c2b6b343ad4f6e47b19b9577bfce938ce98, 10000000000000000000000);
301 	token.mint(0xdcc719cf97c9cbc06e4e8f05ed8d9b2132fe7f31, 12500000000000000000000);
302 	token.mint(0x5ac855600754de7fc9796add50b82554324424bb, 20362000000000000000000);
303 	token.mint(0xa1b710593ed03670c9424c941130b3a073a694cc, 3016378887500000000000);
304 	token.mint(0x8186bda406b950da9690e58199479aa008160709, 150000000000000000000);
305 	token.mint(0xb87b8dc38f027b1ce89a6519dbeb705bdd251ea5, 2500000000000000000000);
306 	token.mint(0x294751d928994780f6db76af14e343d4eb9c3a46, 1354326960000000000000000);
307 	token.mint(0x339d2fbaf46acb13ffc43636c5ae5b81d442e1e2, 124999876147500000000000);
308 	token.mint(0xdfcf69c8fed25f5150db719bad4efab64f628d31, 10000000000000000000000);
309 	token.mint(0x0460529cea44e59fb7e45a6cd6ff0b8b17b680c3, 125000000000000000000000);
310 
311 	tokensSold+=2233427402695000000000000;
312 
313 	token.mint(tokenWallet, foundationAmount);
314 
315 	tokensSold = tokensSold + foundationAmount;
316 	appliedPresale=true;
317     }
318 }