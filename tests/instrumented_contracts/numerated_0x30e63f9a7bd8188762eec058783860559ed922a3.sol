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
24     // Some constant about our expected token distribution
25     uint public constant VRCOIN_DECIMALS = 9;
26     uint public constant TOTAL_TOKENS_TO_DISTRIBUTE = 750000 * (10 ** VRCOIN_DECIMALS); // 750000 VRtokenc
27     
28     uint public exchangeRate = 853;
29     
30     address public owner; // The owner of the crowdsale
31     bool public hasStarted; // Has the crowdsale started?
32     Period public sale; // The configured periods for this crowdsale
33     ERC20Interface public tokenWallet; // The token wallet contract used for this crowdsale
34 
35     // The multiplier necessary to change a coin amount to the token amount
36     uint coinToTokenFactor = 10 ** VRCOIN_DECIMALS;
37     
38     // Fired once the transfer tokens to contract was successfull
39     event Transfer(address to, uint amount);
40 
41     // Fired once the sale starts
42     event Start(uint timestamp);
43 
44     // Fired whenever a contribution is made
45     event Contribution(address indexed from, uint weiContributed, uint tokensReceived);
46 
47     function VRCoinCrowdsale(address walletAddress)
48     {
49          // Setup the owner and wallet
50          owner = msg.sender;
51          tokenWallet = ERC20Interface(walletAddress);
52 
53          // Make sure the provided token has the expected number of tokens to distribute
54          require(tokenWallet.totalSupply() >= TOTAL_TOKENS_TO_DISTRIBUTE);
55 
56          // Make sure the owner actually controls all the tokens
57          require(tokenWallet.balanceOf(owner) >= TOTAL_TOKENS_TO_DISTRIBUTE);
58 
59          // We haven't started yet
60          hasStarted = false;
61                  
62          sale.start = 1521234001; // 00:00:01, March 05, 2018 UTC
63          sale.end = 1525122001; // 00:00:01, Apl 30, 2018 UTC
64          sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor); // 1 ETH = 750 VRCoin
65          sale.tokenToDistibute = TOTAL_TOKENS_TO_DISTRIBUTE;
66     }
67     
68     function updatePrice() {
69          // Only the owner can do this
70          require(msg.sender == owner);
71         
72          // Update price
73          sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor);
74     }
75     
76     function setExchangeRate(uint256 _rate) {
77          // Only the owner can do this
78          require(msg.sender == owner);        
79         
80          // The ether in $ dollar 
81          exchangeRate = _rate;
82     }
83 
84     // Start the crowdsale
85     function startSale()
86     {
87          // Only the owner can do this
88          require(msg.sender == owner);
89          
90          // Cannot start if already started
91          require(hasStarted == false);
92 
93          // Attempt to transfer all tokens to the crowdsale contract
94          // The owner needs to approve() the transfer of all tokens to this contract
95          if (!tokenWallet.transferFrom(owner, this, sale.tokenToDistibute))
96          {
97             // Something has gone wrong, the owner no longer controls all the tokens?
98             // We cannot proceed
99             revert();
100          }else{
101             Transfer(this, sale.tokenToDistibute);
102          }
103 
104          // Sanity check: verify the crowdsale controls all tokens
105          require(tokenWallet.balanceOf(this) >= sale.tokenToDistibute);
106 
107          // The sale can begin
108          hasStarted = true;
109 
110          // Fire event that the sale has begun
111          Start(block.timestamp);
112     }
113 
114     // Allow the current owner to change the owner of the crowdsale
115     function changeOwner(address newOwner) public
116     {
117          // Only the owner can do this
118          require(msg.sender == owner);
119 
120          // Change the owner
121          owner = newOwner;
122     }
123 
124     // Allow the owner to change the tokens for sale number
125     // But only if the sale has not begun yet
126     function changeTokenForSale(uint newAmount) public
127     {
128          // Only the owner can do this
129          require(msg.sender == owner);
130          
131          // We can change period details as long as the sale hasn't started yet
132          require(hasStarted == false);
133          
134          // Make sure the provided token has the expected number of tokens to distribute
135          require(tokenWallet.totalSupply() >= newAmount);
136 
137          // Make sure the owner actually controls all the tokens
138          require(tokenWallet.balanceOf(owner) >= newAmount);
139 
140 
141          // Change the price for this period
142          sale.tokenToDistibute = newAmount;
143     }
144 
145     // Allow the owner to change the start/end time for a period
146     // But only if the sale has not begun yet
147     function changePeriodTime(uint start, uint end) public
148     {
149          // Only the owner can do this
150          require(msg.sender == owner);
151 
152          // We can change period details as long as the sale hasn't started yet
153          require(hasStarted == false);
154 
155          // Make sure the input is valid
156          require(start < end);
157 
158          // Everything checks out, update the period start/end time
159          sale.start = start;
160          sale.end = end;
161     }
162 
163     // Allow the owner to withdraw all the tokens remaining after the
164     // crowdsale is over
165     function withdrawTokensRemaining() public
166          returns (bool)
167     {
168          // Only the owner can do this
169          require(msg.sender == owner);
170 
171          // Get the ending timestamp of the crowdsale
172          uint crowdsaleEnd = sale.end;
173 
174          // The crowsale must be over to perform this operation
175          require(block.timestamp > crowdsaleEnd);
176 
177          // Get the remaining tokens owned by the crowdsale
178          uint tokensRemaining = getTokensRemaining();
179 
180          // Transfer them all to the owner
181          return tokenWallet.transfer(owner, tokensRemaining);
182     }
183 
184     // Allow the owner to withdraw all ether from the contract after the
185     // crowdsale is over
186     function withdrawEtherRemaining() public
187          returns (bool)
188     {
189          // Only the owner can do this
190          require(msg.sender == owner);
191 
192          // Transfer them all to the owner
193          owner.transfer(this.balance);
194 
195          return true;
196     }
197 
198     // Check how many tokens are remaining for distribution
199     function getTokensRemaining() public constant
200          returns (uint256)
201     {
202          return tokenWallet.balanceOf(this);
203     }
204 
205     // Calculate how many tokens can be distributed for the given contribution
206     function getTokensForContribution(uint weiContribution) public constant 
207          returns(uint tokenAmount, uint weiRemainder)
208     {
209          // The bonus for contributor
210          uint256 bonus = 0;
211          
212          // Get the ending timestamp of the crowdsale
213          uint crowdsaleEnd = sale.end;
214         
215          // The crowsale must be going to perform this operation
216          require(block.timestamp <= crowdsaleEnd);
217 
218          // Get the price for this current period
219          uint periodPriceInWei = sale.priceInWei;
220 
221          // Return the amount of tokens that can be purchased
222          
223          tokenAmount = weiContribution / periodPriceInWei;
224          
225 	 	
226             if (block.timestamp < 1521234001) {
227                 // bonus for contributor from 5.03.2018 to 16.03.2018 
228                 bonus = tokenAmount * 20 / 100;
229             } else if (block.timestamp < 1521925201) {
230                 // bonus for contributor from 17.03.2018 to 24.03.2018 
231                 bonus = tokenAmount * 15 / 100;
232             } else {
233                 // bonus for contributor
234                 bonus = tokenAmount * 10 / 100;
235             }
236 		 
237 
238             
239         tokenAmount = tokenAmount + bonus;
240         
241          // Return the amount of wei that would be left over
242          weiRemainder = weiContribution % periodPriceInWei;
243     }
244     
245     // Allow a user to contribute to the crowdsale
246     function contribute() public payable
247     {
248          // Cannot contribute if the sale hasn't started
249          require(hasStarted == true);
250 
251          // Calculate the tokens to be distributed based on the contribution amount
252          var (tokenAmount, weiRemainder) = getTokensForContribution(msg.value);
253 
254          // Need to contribute enough for at least 1 token
255          require(tokenAmount > 0);
256          
257          // Sanity check: make sure the remainder is less or equal to what was sent to us
258          require(weiRemainder <= msg.value);
259 
260          // Make sure there are enough tokens left to buy
261          uint tokensRemaining = getTokensRemaining();
262          require(tokensRemaining >= tokenAmount);
263 
264          // Transfer the token amount from the crowd sale's token wallet to the
265          // sender's token wallet
266          if (!tokenWallet.transfer(msg.sender, tokenAmount))
267          {
268             // Unable to transfer funds, abort transaction
269             revert();
270          }
271 
272          // Return the remainder to the sender
273          msg.sender.transfer(weiRemainder);
274 
275          // Since we refunded the remainder, the actual contribution is the amount sent
276          // minus the remainder
277          uint actualContribution = msg.value - weiRemainder;
278 
279          // Record the event
280          Contribution(msg.sender, actualContribution, tokenAmount);
281     }
282     
283     function() payable
284     {
285         contribute();
286     } 
287 }