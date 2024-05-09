1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * 
6  * This contract is used to set admin to the contract  which has some additional features such as minting , burning etc
7  * 
8  */
9     contract Owned {
10         address public owner;
11 
12         function owned() public {
13             owner = msg.sender;
14         }
15 
16         modifier onlyOwner {
17             require(msg.sender == owner);
18             _;
19         }
20         
21         /* This function is used to transfer adminship to new owner
22          * @param  _newOwner - address of new admin or owner        
23          */
24 
25         function transferOwnership(address _newOwner) onlyOwner public {
26             owner = _newOwner;
27         }          
28     }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  This is interface to transfer Railz tokens , created by Railz token contract
66  */
67 interface RailzToken {
68     function transfer(address _to, uint256 _value) public returns (bool);
69 }
70 
71 
72 /**
73  * This is the main Railz Token Sale contract
74  */
75 contract RailzTokenSale is Owned {
76 	using SafeMath for uint256;
77 
78 	mapping (address=> uint256) contributors;
79 	mapping (address=> uint256) public tokensAllocated;
80     
81 	// start and end timestamps when contributions are allowed  (both inclusive)
82 	uint256 public presalestartTime =1528099200 ;     //4th June 8:00 am UTC
83 	uint256 public presaleendTime = 1530489599;       //1st July 23:59 pm UTC
84 	uint256 public publicsalestartTime = 1530518400;  //2nd July 8:00 am UTC
85 	uint256 public publicsalesendTime = 1532908799;   //29th July 23:59 pm UTC
86 
87 
88 	//token caps for each round
89 	uint256 public presalesCap = 120000000 * (1e18);
90 	uint256 public publicsalesCap = 350000000 * (1e18);
91 
92 	//token price for each round
93 	uint256 public presalesTokenPriceInWei =  80000000000000 ; // 0.00008 ether;
94 	uint256 public publicsalesTokenPriceInWei = 196000000000000 ;// 0.000196 ether;
95 
96 	// address where all funds collected from token sale are stored , this will ideally be address of MutliSig wallet
97 	address wallet;
98 
99 	// amount of raised money in wei
100 	uint256 public weiRaised=0;
101 
102 	//amount of tokens sold
103 	uint256 public numberOfTokensAllocated=0;
104 
105 	// maximum gas price for contribution transactions - 60 GWEI
106 	uint256 public maxGasPrice = 60000000000  wei;  
107 
108 	// The token being sold
109 	RailzToken public token;
110 
111 	bool hasPreTokenSalesCapReached = false;
112 	bool hasTokenSalesCapReached = false;
113 
114 	// events for funds received and tokens
115 	event ContributionReceived(address indexed contributor, uint256 value, uint256 numberOfTokens);
116 	event TokensTransferred(address indexed contributor, uint256 numberOfTokensTransferred);
117 	event ManualTokensTransferred(address indexed contributor, uint256 numberOfTokensTransferred);
118 	event PreTokenSalesCapReached(address indexed contributor);
119 	event TokenSalesCapReached(address indexed contributor);
120 
121 	function RailzTokenSale(RailzToken _addressOfRewardToken, address _wallet) public {        
122   		require(presalestartTime >= now); 
123   		require(_wallet != address(0));   
124         
125   		token = RailzToken (_addressOfRewardToken);
126   		wallet = _wallet;
127 		owner = msg.sender;
128 	}
129 
130 	// verifies that the gas price is lower than max gas price
131 	modifier validGasPrice() {
132 		assert(tx.gasprice <= maxGasPrice);
133 		_;
134 	}
135 
136 	// fallback function  used to buy tokens , this function is called when anyone sends ether to this contract
137 	function ()  payable public validGasPrice {  
138 		require(msg.sender != address(0));                      //contributor's address should not be zero00/80
139 		require(msg.value != 0);                                //amount should be greater then zero            
140         require(msg.value>=0.1 ether);                          //minimum contribution is 0.1 eth
141 		require(isContributionAllowed());                       //Valid time of contribution and cap has not been reached 11
142 	
143 		// Add to mapping of contributor
144 		contributors[msg.sender] = contributors[msg.sender].add(msg.value);
145 		weiRaised = weiRaised.add(msg.value);
146 		uint256 numberOfTokens = 0;
147 
148 		//calculate number of tokens to be given
149 		if (isPreTokenSaleActive()) {
150 			numberOfTokens = msg.value/presalesTokenPriceInWei;
151             numberOfTokens = numberOfTokens * (1e18);
152 			require((numberOfTokens + numberOfTokensAllocated) <= presalesCap);			//Check whether remaining tokens are greater than tokens to allocate
153 
154 			tokensAllocated[msg.sender] = tokensAllocated[msg.sender].add(numberOfTokens);
155 			numberOfTokensAllocated = numberOfTokensAllocated.add(numberOfTokens);
156 			
157 			//forward fund received to Railz multisig Account
158 		    forwardFunds(); 
159 
160 			//Notify server that an contribution has been received
161 			emit ContributionReceived(msg.sender, msg.value, numberOfTokens);
162 
163 		} else if (isTokenSaleActive()) {
164 			numberOfTokens = msg.value/publicsalesTokenPriceInWei;
165 			numberOfTokens = numberOfTokens * (1e18);
166 			require((numberOfTokens + numberOfTokensAllocated) <= (presalesCap + publicsalesCap));	//Check whether remaining tokens are greater than tokens to allocate
167 
168 			tokensAllocated[msg.sender] = tokensAllocated[msg.sender].add(numberOfTokens);
169 			numberOfTokensAllocated = numberOfTokensAllocated.add(numberOfTokens);
170 
171             //forward fund received to Railz multisig Account
172 		    forwardFunds();
173 
174 			//Notify server that an contribution has been received
175 		    emit ContributionReceived(msg.sender, msg.value, numberOfTokens);
176 		}        
177 
178 		// check if hard cap has been reached or not , if it has reached close the contract
179 		checkifCapHasReached();
180 	}
181 
182 	/**
183 	* This function is used to check if an contribution is allowed or not
184 	*/
185 	function isContributionAllowed() public view returns (bool) {    
186 		if (isPreTokenSaleActive())
187 			return  (!hasPreTokenSalesCapReached);
188 		else if (isTokenSaleActive())
189 			return (!hasTokenSalesCapReached);
190 		else
191 			return false;
192 	}
193 
194 	// send ether to the fund collection wallet  , this ideally would be an multisig wallet
195 	function forwardFunds() internal {
196 		wallet.transfer(msg.value);
197 	}
198 
199 	//Pre Token Sale time
200 	function isPreTokenSaleActive() internal view returns (bool) {
201 		return ((now >= presalestartTime) && (now <= presaleendTime));  
202 	}
203 
204 	//Token Sale time
205 	function isTokenSaleActive() internal view returns (bool) {
206 		return (now >= (publicsalestartTime) && (now <= publicsalesendTime));  
207 	}
208 
209 	// Called by owner when preico token cap has been reached
210 	function preTokenSalesCapReached() internal {
211 		hasPreTokenSalesCapReached = true;
212 		emit PreTokenSalesCapReached(msg.sender);
213 	}
214 
215 	// Called by owner when ico token cap has been reached
216 	function tokenSalesCapReached() internal {
217 		hasTokenSalesCapReached = true;
218 		emit TokenSalesCapReached(msg.sender);
219 	}
220 
221 	//This function is used to transfer token to contributor after successful audit
222 	function transferToken(address _contributor) public onlyOwner {
223 		require(_contributor != 0);
224         uint256 numberOfTokens = tokensAllocated[_contributor];
225         tokensAllocated[_contributor] = 0;    
226 		token.transfer(_contributor, numberOfTokens);
227 		emit TokensTransferred(_contributor, numberOfTokens);
228 	}
229 
230 
231 	//This function is used to do bulk transfer token to contributor after successful audit manually
232 	 function manualBatchTransferToken(uint256[] amount, address[] wallets) public onlyOwner {
233         for (uint256 i = 0; i < wallets.length; i++) {
234             token.transfer(wallets[i], amount[i]);
235 			emit TokensTransferred(wallets[i], amount[i]);
236         }
237     }
238 
239 	//This function is used to do bulk transfer token to contributor after successful audit
240 	 function batchTransferToken(address[] wallets) public onlyOwner {
241         for (uint256 i = 0; i < wallets.length; i++) {
242 			uint256 amountOfTokens = tokensAllocated[wallets[i]];
243 			require(amountOfTokens > 0);
244 			tokensAllocated[wallets[i]]=0;
245             token.transfer(wallets[i], amountOfTokens);
246 			emit TokensTransferred(wallets[i], amountOfTokens);
247         }
248     }
249 	
250 	//This function is used refund contribution of a contributor in case soft cap is not reached or audit of an contributor failed
251 	function refundContribution(address _contributor, uint256 _weiAmount) public onlyOwner returns (bool) {
252 		require(_contributor != 0);                                                                                                                                     
253 		if (!_contributor.send(_weiAmount)) {
254 			return false;
255 		} else {
256 			contributors[_contributor] = 0;
257 			return true;
258 		}
259 	}
260 
261 	// This function check whether ICO is currently active or not
262     function checkifCapHasReached() internal {
263     	if (isPreTokenSaleActive() && (numberOfTokensAllocated > presalesCap))  
264         	hasPreTokenSalesCapReached = true;
265      	else if (isTokenSaleActive() && (numberOfTokensAllocated > (presalesCap + publicsalesCap)))     
266         	hasTokenSalesCapReached = true;     	
267     }
268 
269   	//This function allows the owner to update the gas price limit public onlyOwner     
270     function setGasPrice(uint256 _gasPrice) public onlyOwner {
271     	maxGasPrice = _gasPrice;
272     }
273 }