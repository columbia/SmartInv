1 pragma solidity ^0.4.16; 
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address owner) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     function transferFrom(address from, address to, uint256 value) public returns (bool);
8     function approve(address spender, uint256 value) public returns (bool);
9     function allowance(address owner, address spender) public constant returns (uint256);
10 }
11 
12 
13 
14 contract VRCoinCrowdsale {
15     // Information about a single period
16     struct Period
17     {
18          uint start;
19          uint end;
20          uint priceInWei;
21          uint tokenToDistibute;
22     }
23 
24 
25 
26     // Some constant about our expected token distribution
27     uint public constant VRCOIN_DECIMALS = 9;
28     uint public constant TOTAL_TOKENS_TO_DISTRIBUTE = 750000 * (10 ** VRCOIN_DECIMALS); // 750000 VRtokenc
29     
30     uint public exchangeRate = 610;
31     
32     address public owner; // The owner of the crowdsale
33     bool public hasStarted; // Has the crowdsale started?
34     Period public sale; // The configured periods for this crowdsale
35     ERC20Interface public tokenWallet; // The token wallet contract used for this crowdsale
36 
37     // The multiplier necessary to change a coin amount to the token amount
38     uint coinToTokenFactor = 10 ** VRCOIN_DECIMALS;
39     
40     // Fired once the transfer tokens to contract was successfull
41     event Transfer(address to, uint amount);
42 
43     // Fired once the sale starts
44     event Start(uint timestamp);
45 
46     // Fired whenever a contribution is made
47     event Contribution(address indexed from, uint weiContributed, uint tokensReceived);
48 
49     function VRCoinCrowdsale(address walletAddress)
50     {
51          // Setup the owner and wallet
52          owner = msg.sender;
53          tokenWallet = ERC20Interface(walletAddress);
54 
55          // Make sure the provided token has the expected number of tokens to distribute
56          require(tokenWallet.totalSupply() >= TOTAL_TOKENS_TO_DISTRIBUTE);
57 
58          // Make sure the owner actually controls all the tokens
59          require(tokenWallet.balanceOf(owner) >= TOTAL_TOKENS_TO_DISTRIBUTE);
60 
61          // We haven't started yet
62          hasStarted = false;
63                  
64          sale.start = 1521234001; // 00:00:01, March 05, 2018 UTC
65          sale.end = 1525122001; // 00:00:01, Apl 30, 2018 UTC
66          sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor); // 1 ETH = 750 VRCoin
67          sale.tokenToDistibute = TOTAL_TOKENS_TO_DISTRIBUTE;
68     }
69     
70     function updatePrice() {
71          // Only the owner can do this
72          require(msg.sender == owner);
73         
74          // Update price
75          sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor);
76     }
77     
78     function setExchangeRate(uint256 _rate) {
79          // Only the owner can do this
80          require(msg.sender == owner);        
81         
82          // The ether in $ dollar 
83          exchangeRate = _rate;
84     }
85 
86     // Start the crowdsale
87     function startSale()
88     {
89          // Only the owner can do this
90          require(msg.sender == owner);
91          
92          // Cannot start if already started
93          require(hasStarted == false);
94 
95          // Attempt to transfer all tokens to the crowdsale contract
96          // The owner needs to approve() the transfer of all tokens to this contract
97          if (!tokenWallet.transferFrom(owner, this, sale.tokenToDistibute))
98          {
99             // Something has gone wrong, the owner no longer controls all the tokens?
100             // We cannot proceed
101             revert();
102          }else{
103             Transfer(this, sale.tokenToDistibute);
104          }
105 
106          // Sanity check: verify the crowdsale controls all tokens
107          require(tokenWallet.balanceOf(this) >= sale.tokenToDistibute);
108 
109          // The sale can begin
110          hasStarted = true;
111 
112          // Fire event that the sale has begun
113          Start(block.timestamp);
114     }
115 
116     // Allow the current owner to change the owner of the crowdsale
117     function changeOwner(address newOwner) public
118     {
119          // Only the owner can do this
120          require(msg.sender == owner);
121 
122          // Change the owner
123          owner = newOwner;
124     }
125 
126     // Allow the owner to change the tokens for sale number
127     // But only if the sale has not begun yet
128     function changeTokenForSale(uint newAmount) public
129     {
130          // Only the owner can do this
131          require(msg.sender == owner);
132          
133          // We can change period details as long as the sale hasn't started yet
134          require(hasStarted == false);
135          
136          // Make sure the provided token has the expected number of tokens to distribute
137          require(tokenWallet.totalSupply() >= newAmount);
138 
139          // Make sure the owner actually controls all the tokens
140          require(tokenWallet.balanceOf(owner) >= newAmount);
141 
142 
143          // Change the price for this period
144          sale.tokenToDistibute = newAmount;
145     }
146 
147     // Allow the owner to change the start/end time for a period
148     // But only if the sale has not begun yet
149     function changePeriodTime(uint start, uint end) public
150     {
151          // Only the owner can do this
152          require(msg.sender == owner);
153 
154          // We can change period details as long as the sale hasn't started yet
155          require(hasStarted == false);
156 
157          // Make sure the input is valid
158          require(start < end);
159 
160          // Everything checks out, update the period start/end time
161          sale.start = start;
162          sale.end = end;
163     }
164 
165     // Allow the owner to withdraw all the tokens remaining after the
166     // crowdsale is over
167     function withdrawTokensRemaining() public
168          returns (bool)
169     {
170          // Only the owner can do this
171          require(msg.sender == owner);
172 
173          // Get the ending timestamp of the crowdsale
174          uint crowdsaleEnd = sale.end;
175 
176          // The crowsale must be over to perform this operation
177          require(block.timestamp > crowdsaleEnd);
178 
179          // Get the remaining tokens owned by the crowdsale
180          uint tokensRemaining = getTokensRemaining();
181 
182          // Transfer them all to the owner
183          return tokenWallet.transfer(owner, tokensRemaining);
184     }
185 
186     // Allow the owner to withdraw all ether from the contract after the
187     // crowdsale is over
188     function withdrawEtherRemaining() public
189          returns (bool)
190     {
191          // Only the owner can do this
192          require(msg.sender == owner);
193 
194          // Transfer them all to the owner
195          owner.transfer(this.balance);
196 
197          return true;
198     }
199 
200     // Check how many tokens are remaining for distribution
201     function getTokensRemaining() public constant
202          returns (uint256)
203     {
204          return tokenWallet.balanceOf(this);
205     }
206 
207     // Calculate how many tokens can be distributed for the given contribution
208     function getTokensForContribution(uint weiContribution) public constant 
209          returns(uint tokenAmount, uint weiRemainder)
210     {
211          // The bonus for contributor
212          uint256 bonus = 0;
213          
214          // Get the ending timestamp of the crowdsale
215          uint crowdsaleEnd = sale.end;
216         
217          // The crowsale must be going to perform this operation
218          require(block.timestamp <= crowdsaleEnd);
219 
220          // Get the price for this current period
221          uint periodPriceInWei = sale.priceInWei;
222 
223          // Return the amount of tokens that can be purchased
224          
225          tokenAmount = weiContribution / periodPriceInWei;
226          
227 	 	
228             if (block.timestamp < 1522270801) {
229                 // bonus for contributor from 5.03.2018 to 28.03.2018 
230                 bonus = tokenAmount * 20 / 100;
231             } else if (block.timestamp < 1523739601) {
232                 // bonus for contributor from 29.03.2018 to 14.04.2018 
233                 bonus = tokenAmount * 15 / 100;
234             } else {
235                 // bonus for contributor
236                 bonus = tokenAmount * 10 / 100;
237             }
238 		 
239 
240             
241         tokenAmount = tokenAmount + bonus;
242         
243          // Return the amount of wei that would be left over
244          weiRemainder = weiContribution % periodPriceInWei;
245     }
246     
247     // Allow a user to contribute to the crowdsale
248     function contribute() public payable
249     {
250          // Cannot contribute if the sale hasn't started
251          require(hasStarted == true);
252 
253          // Calculate the tokens to be distributed based on the contribution amount
254          var (tokenAmount, weiRemainder) = getTokensForContribution(msg.value);
255 
256          // Need to contribute enough for at least 1 token
257          require(tokenAmount > 0);
258          
259          // Sanity check: make sure the remainder is less or equal to what was sent to us
260          require(weiRemainder <= msg.value);
261 
262          // Make sure there are enough tokens left to buy
263          uint tokensRemaining = getTokensRemaining();
264          require(tokensRemaining >= tokenAmount);
265 
266          // Transfer the token amount from the crowd sale's token wallet to the
267          // sender's token wallet
268          if (!tokenWallet.transfer(msg.sender, tokenAmount))
269          {
270             // Unable to transfer funds, abort transaction
271             revert();
272          }
273 
274          // Return the remainder to the sender
275          msg.sender.transfer(weiRemainder);
276 
277          // Since we refunded the remainder, the actual contribution is the amount sent
278          // minus the remainder
279          uint actualContribution = msg.value - weiRemainder;
280 
281          // Record the event
282          Contribution(msg.sender, actualContribution, tokenAmount);
283     }
284     
285     function() payable
286     {
287         contribute();
288     } 
289 }