1 pragma solidity ^0.4.18;
2 
3 /**
4  *  @title Smart City Crowdsale contract https://www.smartcitycoin.io
5  */
6 
7 
8 contract SmartCityToken {
9     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {}
10     
11     function setTokenStart(uint256 _newStartTime) public {}
12 
13     function burn() public {}
14 }
15 
16 contract SmartCityCrowdsale {
17     using SafeMath for uint256;
18 
19 	/// state
20     SmartCityToken public token; // Token Contract
21 	
22 	address public owner; // Owner address
23 
24 	mapping (address => bool) whitelist; // useers whithelist
25 
26     mapping(address => uint256) public balances; // the array of users along with amounts invested
27 	
28 	mapping(address => uint256) public purchases; // the array of users and tokens purchased
29 
30     uint256 public raisedEth; // Amount of Ether raised
31 
32     uint256 public startTime; // Crowdale start time
33 
34     uint256 public tokensSoldTotal = 0; // Sold Tolkens counter
35 
36     bool public crowdsaleEnded = false; // if the Campaign is over
37 	
38 	bool public paused = false; // if the Campaign is paused
39 
40     uint256 public positionPrice = 5730 finney; // Initially 1 investement position costs 5.73 ETH, might be changed by owner afterwards
41 	
42 	uint256 public usedPositions = 0; // Initial number of used investment positions
43 	
44 	uint256 public availablePositions = 100; // Initial number of open investment positions
45 
46     address walletAddress; // address of the wallet contract storing the funds
47 
48 	/// constants
49     uint256 constant public tokensForSale = 164360928100000; // Total amount of tokens allocated for the Crowdsale
50 
51 	uint256 constant public weiToTokenFactor = 10000000000000;
52 
53 	uint256 constant public investmentPositions = 4370; // Total number of investment positions
54 
55     uint256 constant public investmentLimit = 18262325344444; // the maximum amount of Ether an address is allowed to invest - limited to 1/9 of tokens allocated for sale
56 
57 	/// events
58     event FundTransfer(address indexed _investorAddr, uint256 _amount, uint256 _amountRaised); // fired on transfering funds from investors
59 	
60 	event Granted(address indexed party); // user is added to the whitelist
61 	
62 	event Revoked(address indexed party); // user is removed from the whitelist
63 	
64 	event Ended(uint256 raisedAmount); // Crowdsale is ended
65 
66 	/// modifiers
67 	modifier onlyWhenActive() {
68 		require(now >= startTime && !crowdsaleEnded && !paused);
69 		_;
70 	}
71 	
72 	modifier whenPositionsAvailable() {
73 		require(availablePositions > 0);
74 		_;
75 	}
76 
77 	modifier onlyWhitelisted(address party) {
78 		require(whitelist[party]);
79 		_; 
80 	}
81 	
82 	modifier onlyNotOnList(address party) {
83 		require(!whitelist[party]);
84 		_;
85 	}
86 
87 	modifier onlyOwner() {
88 		require(msg.sender == owner);
89 		_;
90 	}
91 
92     /**
93      *  @dev Crowdsale Contract initialization
94      *  @param _owner address Token owner address
95      *  @param _tokenAddress address Crowdsale end time
96      *  @param _walletAddress address Beneficiary address where the funds are collected
97      *  @param _start uint256 Crowdsale Start Time
98      */
99     function SmartCityCrowdsale (
100             address _tokenAddress,
101             address _owner,
102             address _walletAddress,
103             uint256 _start) public {
104 
105         owner = _owner;
106         token = SmartCityToken(_tokenAddress);
107         walletAddress = _walletAddress;
108 
109         startTime = _start; // Crowdsale Start Time
110     }
111 
112     /**
113      *  @dev Investment can be done just by sending Ether to Crowdsale Contract
114      */
115     function() public payable {
116         invest();
117     }
118 
119     /**
120      *  @dev Make an investment
121      */
122     function invest() public payable
123 				onlyWhitelisted(msg.sender)
124 				whenPositionsAvailable
125 				onlyWhenActive
126 	{
127 		address _receiver = msg.sender;
128         uint256 amount = msg.value; // Transaction value in Wei
129 
130         var (positionsCnt, tokensCnt) = getPositionsAndTokensCnt(amount); 
131 
132         require(positionsCnt > 0 && positionsCnt <= availablePositions && tokensCnt > 0);
133 
134 		require(purchases[_receiver].add(tokensCnt) <= investmentLimit); // Check the investment limit is not exceeded
135 
136         require(tokensSoldTotal.add(tokensCnt) <= tokensForSale);
137 
138         walletAddress.transfer(amount); // Send funds to the Wallet
139 		
140         balances[_receiver] = balances[_receiver].add(amount); // Add the amount invested to Investor's ballance
141 		purchases[_receiver] = purchases[_receiver].add(tokensCnt); // Add tokens to Investor's purchases
142         raisedEth = raisedEth.add(amount); // Increase raised funds counter
143 		availablePositions = availablePositions.sub(positionsCnt);
144 		usedPositions = usedPositions.add(positionsCnt);
145         tokensSoldTotal = tokensSoldTotal.add(tokensCnt); // Increase sold CITY counter
146 
147         require(token.transferFrom(owner, _receiver, tokensCnt)); // Transfer CITY purchased to Investor
148 
149         FundTransfer(_receiver, amount, raisedEth);
150 		
151 		if (usedPositions == investmentPositions) { // Sold Out
152 			token.burn();
153 			crowdsaleEnded = true; // mark Crowdsale ended
154 			
155 			Ended(raisedEth);
156 		}
157     }
158     
159     /**
160      *  @dev Calculate the amount of Tokens purchased based on the value sent and current Token price
161      *  @param _value uint256 Amount invested
162      */
163     function getPositionsAndTokensCnt(uint256 _value) public constant onlyWhenActive returns(uint256 positionsCnt, uint256 tokensCnt) {
164 			if (_value % positionPrice != 0 || usedPositions >= investmentPositions) {
165 				return(0, 0);
166 			}
167 			else {
168 				uint256 purchasedPositions = _value.div(positionPrice);
169 				uint256 purchasedTokens = ((tokensForSale.sub(tokensSoldTotal)).mul(purchasedPositions)).div(investmentPositions.sub(usedPositions));
170 				return(purchasedPositions, purchasedTokens);
171 			}
172     }
173 
174 	function getMinPurchase() public constant onlyWhenActive returns(uint256 minPurchase) {
175 		return positionPrice;
176 	}
177 	
178 	/// Owner functions
179 	
180     /**
181      *  @dev To increace/reduce number of Investment Positions released for sale
182      */
183     function setAvailablePositions(uint256 newAvailablePositions) public onlyOwner {
184         require(newAvailablePositions <= investmentPositions.sub(usedPositions));
185 		availablePositions = newAvailablePositions;
186     }
187 	
188 	/**
189      *  @dev Allows Investment Position price changes
190      */
191     function setPositionPrice(uint256 newPositionPrice) public onlyOwner {
192         require(newPositionPrice > 0);
193 		positionPrice = newPositionPrice;
194     }
195 	
196 	 /**
197      *  @dev Emergency function to pause Crowdsale.
198      */
199     function setPaused(bool _paused) public onlyOwner { paused = _paused; }
200 
201 	/**
202     *   @dev Emergency function to drain the contract of any funds.
203     */
204 	function drain() public onlyOwner { walletAddress.transfer(this.balance); }
205 	
206 	/**
207     *   @dev Function to manually finalize Crowdsale.
208     */
209 	function endCrowdsale() public onlyOwner {
210 		usedPositions = investmentPositions;
211 		availablePositions = 0;
212 		token.burn(); // burn all unsold tokens
213 		crowdsaleEnded = true; // mark Crowdsale ended
214 		
215 		Ended(raisedEth);
216 	}
217 
218 	/// Whitelist functions
219 	function grant(address _party) public onlyOwner onlyNotOnList(_party)
220 	{
221 		whitelist[_party] = true;
222 		Granted(_party);
223 	}
224 
225 	function revoke(address _party) public onlyOwner onlyWhitelisted(_party)
226 	{
227 		whitelist[_party] = false;
228 		Revoked(_party);
229 	}
230 	
231 	function massGrant(address[] _parties) public onlyOwner
232 	{
233 		uint len = _parties.length;
234 		
235 		for (uint i = 0; i < len; i++) {
236 			whitelist[_parties[i]] = true;
237 			Granted(_parties[i]);
238 		}
239 	}
240 
241 	function massRevoke(address[] _parties) public onlyOwner
242 	{
243 		uint len = _parties.length;
244 		
245 		for (uint i = 0; i < len; i++) {
246 			whitelist[_parties[i]] = false;
247 			Revoked(_parties[i]);
248 		}
249 	}
250 
251 	function isWhitelisted(address _party) public constant returns (bool) {
252 		return whitelist[_party];
253 	}
254 }
255 
256 /**
257  * @title SafeMath
258  * @dev Math operations with safety checks that throw on error
259  */
260 library SafeMath {
261 
262   /**
263   * @dev Multiplies two numbers, throws on overflow.
264   */
265   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266     if (a == 0) {
267       return 0;
268     }
269     uint256 c = a * b;
270     assert(c / a == b);
271     return c;
272   }
273 
274   /**
275   * @dev Integer division of two numbers, truncating the quotient.
276   */
277   function div(uint256 a, uint256 b) internal pure returns (uint256) {
278     uint256 c = a / b;
279     return c;
280   }
281 
282   /**
283   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
284   */
285   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286     assert(b <= a);
287     return a - b;
288   }
289 
290   /**
291   * @dev Adds two numbers, throws on overflow.
292   */
293   function add(uint256 a, uint256 b) internal pure returns (uint256) {
294     uint256 c = a + b;
295     assert(c >= a);
296     return c;
297   }
298 }
299 	
300     /**
301     *            CITY 2.0 token by www.SmartCityCoin.io
302     * 
303     *          .ossssss:                      `+sssss`      
304     *         ` +ssssss+` `.://++++++//:.`  .osssss+       
305     *            /sssssssssssssssssssssssss+ssssso`        
306     *             -sssssssssssssssssssssssssssss+`         
307     *            .+sssssssss+:--....--:/ossssssss+.        
308     *          `/ssssssssssso`         .sssssssssss/`      
309     *         .ossssss+sssssss-       :sssss+:ossssso.     
310     *        `ossssso. .ossssss:    `/sssss/  `/ssssss.    
311     *        ossssso`   `+ssssss+` .osssss:     /ssssss`   
312     *       :ssssss`      /sssssso:ssssso.       +o+/:-`   
313     *       osssss+        -sssssssssss+`                  
314     *       ssssss:         .ossssssss/                    
315     *       osssss/          `+ssssss-                     
316     *       /ssssso           :ssssss                      
317     *       .ssssss-          :ssssss                      
318     *        :ssssss-         :ssssss          `           
319     *         /ssssss/`       :ssssss        `/s+:`        
320     *          :sssssso:.     :ssssss      ./ssssss+`      
321     *           .+ssssssso/-.`:ssssss``.-/osssssss+.       
322     *             .+ssssssssssssssssssssssssssss+-         
323     *               `:+ssssssssssssssssssssss+:`           
324     *                  `.:+osssssssssssso+:.`              
325     *                        `/ssssss.`                    
326     *                         :ssssss                      
327     */