1 interface IYeekFormula {
2     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) external view returns (uint256);
3     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) external view returns (uint256);
4 }
5 
6 interface ITradeableAsset {
7     function totalSupply() external view returns (uint256);
8     function approve(address spender, uint tokens) external returns (bool success);
9     function transferFrom(address from, address to, uint tokens) external returns (bool success);
10     function decimals() external view returns (uint256);
11     function transfer(address _to, uint256 _value) external;
12     function balanceOf(address _address) external view returns (uint256);
13 }
14 
15 /* A basic permissions hierarchy (Owner -> Admin -> Everyone else). One owner may appoint and remove any number of admins
16    and may transfer ownership to another individual address */
17 contract Administered {
18     address public creator;
19     uint public commission = 1;
20     mapping (address => bool) public admins;
21     
22     constructor()  public {
23         creator = msg.sender;
24         admins[creator] = true;
25     }
26 
27     //Restrict to the current owner. There may be only 1 owner at a time, but 
28     //ownership can be transferred.
29     modifier onlyOwner {
30         require(creator == msg.sender);
31         _;
32     }
33     
34     //Restrict to any admin. Not sufficient for highly sensitive methods
35     //since basic admin can be granted programatically regardless of msg.sender
36     modifier onlyAdmin {
37         require(admins[msg.sender] || creator == msg.sender);
38         _;
39     }
40 
41     //Add an admin with basic privileges. Can be done by any superuser (or the owner)
42     function grantAdmin(address newAdmin) onlyOwner  public {
43         _grantAdmin(newAdmin);
44     }
45 
46     function _grantAdmin(address newAdmin) internal
47     {
48         admins[newAdmin] = true;
49     }
50 
51     //Transfer ownership
52     function changeOwner(address newOwner) onlyOwner public {
53         creator = newOwner;
54     }
55 
56     //Remove an admin
57     function revokeAdminStatus(address user) onlyOwner public {
58         admins[user] = false;
59     }
60 }
61 
62 /* A liqudity pool that executes buy and sell orders for an ETH / Token Pair */
63 /* The owner deploys it and then adds tokens / ethereum in the desired ratio */
64 
65 contract Exchanger is Administered {
66     bool public enabled = false;    //Owner can turn off and on
67 
68     //The token which is being bought and sold
69     ITradeableAsset public tokenContract;
70     //The contract that does the calculations to determine buy and sell pricing
71     IYeekFormula public formulaContract;
72     //The reserve pct of this exchanger, expressed in ppm
73     uint32 public weight;
74 
75     /** 
76         @dev Deploys an exchanger contract for a given token / Ether pairing
77         @param _token An ERC20 token
78         @param _weight The reserve fraction of this exchanger, in ppm
79         @param _formulaContract The contract with the algorithms to calculate price
80      */
81 
82     constructor(address _token, 
83                 uint32 _weight,
84                 address _formulaContract) {
85         require (_weight > 0 && weight <= 1000000);
86         
87         weight = _weight;
88         tokenContract = ITradeableAsset(_token);
89         formulaContract = IYeekFormula(_formulaContract);
90     }
91 
92     //Events raised on completion of buy and sell orders. 
93     //The web client can use this info to provide users with their trading history for a given token
94     //and also to notify when a trade has completed.
95 
96     event Buy(address indexed purchaser, uint256 amountInWei, uint256 amountInToken);
97     event Sell(address indexed seller, uint256 amountInToken, uint256 amountInWei);
98 
99 
100     // The following methods are for the owner and admins to manage the Exchanger
101     
102     /**
103      @dev Deposit tokens to the reserve.
104      */
105     function depositTokens(uint amount) onlyOwner public {
106         tokenContract.transferFrom(msg.sender, this, amount);
107     }
108         
109     /**
110      @dev Deposit ether to the reserve
111      */
112      function depositEther() onlyOwner public payable {
113         //return getQuotePrice(); 
114      }
115 
116     /**  
117      @dev Withdraw tokens from the reserve
118      */
119     function withdrawTokens(uint amount) onlyOwner public {
120         tokenContract.transfer(msg.sender, amount);
121     }
122 
123     /**  
124      @dev Withdraw ether from the reserve
125      */
126     function withdrawEther(uint amountInWei) onlyOwner public {
127         msg.sender.transfer(amountInWei); //Transfers in wei
128     }
129 
130     /**
131      @dev Enable trading
132      */
133      function enable() onlyAdmin public {
134          enabled = true;
135      }
136 
137      /**
138       @dev Disable trading
139      */
140      function disable() onlyAdmin public {
141          enabled = false;
142      }
143 
144      /**
145       @dev Play central banker and set the fractional reserve ratio, from 1 to 1000000 ppm.
146       It is highly disrecommended to do this while trading is enabled! If you don't know what 
147       a fractional reserve is, please put this contract away and go work for your local government.
148      */
149      function setReserveWeight(uint32 ppm) onlyAdmin public {
150          require (ppm>0 && ppm<=1000000);
151          weight = ppm;
152      }
153 
154     //These methods return information about the exchanger, and the buy / sell rates offered on the Token / ETH pairing.
155     //They can be called without gas from any client.
156 
157     /**  
158      @dev Audit the reserve balances, in the base token and in ether
159      */
160     function getReserveBalances() public view returns (uint256, uint256) {
161         return (tokenContract.balanceOf(this), address(this).balance);
162     }
163 
164 
165     /**
166      @dev Gets price based on a sample 1 ether BUY order
167      */
168     function getQuotePrice() public view returns(uint) {
169         uint tokensPerEther = 
170         formulaContract.calculatePurchaseReturn(
171             tokenContract.totalSupply(),
172             address(this).balance,
173             weight,
174             1 ether 
175         ); 
176 
177         return tokensPerEther;
178     }
179 
180     /**
181      @dev Get the BUY price based on the order size. Returned as the number of tokens that the amountInWei will buy.
182      */
183     function getPurchasePrice(uint256 amountInWei) public view returns(uint) {
184         uint tokensPerEther =  formulaContract.calculatePurchaseReturn(
185             tokenContract.totalSupply(),
186             address(this).balance,
187             weight,
188             amountInWei 
189         ); 
190         
191         return tokensPerEther - (tokensPerEther * commission / 100);
192     }
193 
194     /**
195      @dev Get the SELL price based on the order size. Returned as amount (in wei) that you'll get for your tokens.
196      */
197     function getSalePrice(uint256 tokensToSell) public view returns(uint) {
198         uint weiRaw= formulaContract.calculateSaleReturn(
199             tokenContract.totalSupply(),
200             address(this).balance,
201             weight,
202             tokensToSell 
203         ); 
204         
205         return weiRaw - (weiRaw * commission / 100);
206     }
207 
208     //buy and sell execute live trades against the exchanger. For either method, 
209     //you must specify your minimum return (in total tokens or ether that you expect to receive for your trade)
210     //this protects the trader against slippage due to other orders that make it into earlier blocks after they 
211     //place their order. 
212     //
213     //With buy, send the amount of ether you want to spend on the token - you'll get it back immediately if minPurchaseReturn
214     //is not met or if this Exchanger is not in a condition to service your order (usually this happens when there is not a full 
215     //reserve of tokens to satisfy the stated weight)
216     //
217     //With sell, first approve the exchanger to spend the number of tokens you want to sell
218     //Then call sell with that number and your minSaleReturn. The token transfer will not happen 
219     //if the minSaleReturn is not met.
220     //
221     //Sales always go through, as long as there is any ether in the reserve... but those dumping massive quantities of tokens
222     //will naturally be given the shittest rates.
223 
224     /**
225      @dev Buy tokens with ether. 
226      @param minPurchaseReturn The minimum number of tokens you will accept.
227      */
228     function buy(uint minPurchaseReturn) public payable {
229         uint amount = formulaContract.calculatePurchaseReturn(
230             tokenContract.totalSupply(),
231             address(this).balance - msg.value,
232             weight,
233             msg.value);
234         require (enabled);
235         require (amount >= minPurchaseReturn);
236         require (tokenContract.balanceOf(this) >= amount);
237         emit Buy(msg.sender, msg.value, amount);
238         tokenContract.transfer(msg.sender, amount);
239     }
240     /**
241      @dev Sell tokens for ether
242      @param quantity Number of tokens to sell
243      @param minSaleReturn Minimum amount of ether (in wei) you will accept for your tokens
244      */
245      function sell(uint quantity, uint minSaleReturn) public {
246          uint amountInWei = formulaContract.calculateSaleReturn(
247              tokenContract.totalSupply(),
248              address(this).balance,
249              weight,
250              quantity
251          );
252          require (enabled);
253          require (amountInWei >= minSaleReturn);
254          require (amountInWei <= address(this).balance);
255          require (tokenContract.transferFrom(msg.sender, this, quantity));
256          emit Sell(msg.sender, quantity, amountInWei);
257          msg.sender.transfer(amountInWei); //Always send ether last
258      }
259 }