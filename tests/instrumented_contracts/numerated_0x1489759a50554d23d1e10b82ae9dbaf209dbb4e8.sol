1 pragma solidity ^0.4.25;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function sub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function div(uint a, uint b) internal pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 
21 contract Owned {
22 
23     address public owner;
24     address public proposedOwner = address(0);
25 
26     event OwnershipTransferInitiated(address indexed _proposedOwner);
27     event OwnershipTransferCompleted(address indexed _newOwner);
28     event OwnershipTransferCanceled();
29 
30 
31     constructor() public
32     {
33         owner = msg.sender;
34     }
35 
36 
37     modifier onlyOwner() {
38         require(isOwner(msg.sender));
39         _;
40     }
41 
42 
43     function isOwner(address _address) public view returns (bool) {
44         return (_address == owner);
45     }
46 
47 
48     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
49         require(_proposedOwner != address(0));
50         require(_proposedOwner != address(this));
51         require(_proposedOwner != owner);
52 
53         proposedOwner = _proposedOwner;
54 
55         emit OwnershipTransferInitiated(proposedOwner);
56 
57         return true;
58     }
59 
60 
61     function cancelOwnershipTransfer() public onlyOwner returns (bool) {
62         //if proposedOwner address already address(0) then it will return true.
63         if (proposedOwner == address(0)) {
64             return true;
65         }
66         //if not then first it will do address(0( then it will return true.
67         proposedOwner = address(0);
68 
69         emit OwnershipTransferCanceled();
70 
71         return true;
72     }
73 
74 
75     function completeOwnershipTransfer() public returns (bool) {
76 
77         require(msg.sender == proposedOwner);
78 
79         owner = msg.sender;
80         proposedOwner = address(0);
81 
82         emit OwnershipTransferCompleted(owner);
83 
84         return true;
85     }
86 }
87 
88 contract TokenTransfer {
89     // minimal subset of ERC20
90     function transfer(address _to, uint256 _value) public returns (bool success);
91     function decimals() public view returns (uint8 tokenDecimals);
92     function balanceOf(address _owner) public view returns (uint256 balance);
93 }
94 
95 contract FlexibleTokenSale is  Owned {
96 
97     using SafeMath for uint256;
98 
99     //
100     // Lifecycle
101     //
102     bool public suspended;
103 
104     //
105     // Pricing
106     //
107     uint256 public tokenPrice;
108     uint256 public tokenPerEther;
109     uint256 public contributionMin;
110     uint256 public tokenConversionFactor;
111 
112     //
113     // Wallets
114     //
115     address public walletAddress;
116 
117     //
118     // Token
119     //
120     TokenTransfer token;
121 
122 
123     //
124     // Counters
125     //
126     uint256 public totalTokensSold;
127     uint256 public totalEtherCollected;
128     
129     //
130     // Price Update Address
131     //
132     address public priceUpdateAddress;
133 
134 
135     //
136     // Events
137     //
138     event Initialized();
139     event TokenPriceUpdated(uint256 _newValue);
140     event TokenPerEtherUpdated(uint256 _newValue);
141     event TokenMinUpdated(uint256 _newValue);
142     event WalletAddressUpdated(address indexed _newAddress);
143     event SaleSuspended();
144     event SaleResumed();
145     event TokensPurchased(address indexed _beneficiary, uint256 _cost, uint256 _tokens);
146     event TokensReclaimed(uint256 _amount);
147     event PriceAddressUpdated(address indexed _newAddress);
148 
149 
150     constructor(address _tokenAddress,address _walletAddress,uint _tokenPerEther,address _priceUpdateAddress) public
151     Owned()
152     {
153 
154         require(_walletAddress != address(0));
155         require(_walletAddress != address(this));
156         require(address(token) == address(0));
157         require(address(_tokenAddress) != address(0));
158         require(address(_tokenAddress) != address(this));
159         require(address(_tokenAddress) != address(walletAddress));
160 
161         walletAddress = _walletAddress;
162         priceUpdateAddress = _priceUpdateAddress;
163         token = TokenTransfer(_tokenAddress);
164         suspended = false;
165         tokenPrice = 100;
166         tokenPerEther = _tokenPerEther;
167         contributionMin     = 5 * 10**18;//minimum 5 DOC token
168         totalTokensSold     = 0;
169         totalEtherCollected = 0;
170         // This factor is used when converting cost <-> tokens.
171        // 18 is because of the ETH -> Wei conversion.
172       // 2 because toekn price  and etherPerToken Price are expressed as 100 for $1.00  and 100000 for $1000.00 (with 2 decimals).
173        tokenConversionFactor = 10**(uint256(18).sub(token.decimals()).add(2));
174         assert(tokenConversionFactor > 0);
175     }
176 
177 
178     //
179     // Owner Configuation
180     //
181 
182     // Allows the owner to change the wallet address which is used for collecting
183     // ether received during the token sale.
184     function setWalletAddress(address _walletAddress) external onlyOwner returns(bool) {
185         require(_walletAddress != address(0));
186         require(_walletAddress != address(this));
187         require(_walletAddress != address(token));
188         require(isOwner(_walletAddress) == false);
189 
190         walletAddress = _walletAddress;
191 
192         emit WalletAddressUpdated(_walletAddress);
193 
194         return true;
195     }
196 
197     //set token price in between $1 to $1000, pass 111 for $1.11, 100000 for $1000
198     function setTokenPrice(uint _tokenPrice) external onlyOwner returns (bool) {
199         require(_tokenPrice >= 100 && _tokenPrice <= 100000);
200 
201         tokenPrice=_tokenPrice;
202 
203         emit TokenPriceUpdated(_tokenPrice);
204         return true;
205     }
206 
207     function setMinToken(uint256 _minToken) external onlyOwner returns(bool) {
208         require(_minToken > 0);
209 
210         contributionMin = _minToken;
211 
212         emit TokenMinUpdated(_minToken);
213 
214         return true;
215     }
216 
217     // Allows the owner to suspend the sale until it is manually resumed at a later time.
218     function suspend() external onlyOwner returns(bool) {
219         if (suspended == true) {
220             return false;
221         }
222 
223         suspended = true;
224 
225         emit SaleSuspended();
226 
227         return true;
228     }
229 
230     // Allows the owner to resume the sale.
231     function resume() external onlyOwner returns(bool) {
232         if (suspended == false) {
233             return false;
234         }
235 
236         suspended = false;
237 
238         emit SaleResumed();
239 
240         return true;
241     }
242 
243 
244     //
245     // Contributions
246     //
247 
248     // Default payable function which can be used to purchase tokens.
249     function () payable public {
250         buyTokens(msg.sender);
251     }
252 
253 
254     // Allows the caller to purchase tokens for a specific beneficiary (proxy purchase).
255     function buyTokens(address _beneficiary) public payable returns (uint256) {
256         require(!suspended);
257 
258         require(address(token) !=  address(0));
259         require(_beneficiary != address(0));
260         require(_beneficiary != address(this));
261         require(_beneficiary != address(token));
262 
263 
264         // We don't want to allow the wallet collecting ETH to
265         // directly be used to purchase tokens.
266         require(msg.sender != address(walletAddress));
267 
268         // Check how many tokens are still available for sale.
269         uint256 saleBalance = token.balanceOf(address(this));
270         assert(saleBalance > 0);
271 
272 
273         return buyTokensInternal(_beneficiary);
274     }
275 
276     function updateTokenPerEther(uint _etherPrice) public returns(bool){
277         require(_etherPrice > 0);
278         require(msg.sender == priceUpdateAddress || msg.sender == owner);
279         tokenPerEther=_etherPrice;
280         emit TokenPerEtherUpdated(_etherPrice);
281         return true;
282     }
283     
284     function updatePriceAddress(address _newAddress) public onlyOwner returns(bool){
285         require(_newAddress != address(0));
286         priceUpdateAddress=_newAddress;
287         emit PriceAddressUpdated(_newAddress);
288         return true;
289     }
290 
291 
292     function buyTokensInternal(address _beneficiary) internal returns (uint256) {
293 
294         // Calculate how many tokens the contributor could purchase based on ETH received.
295         uint256 tokens =msg.value.mul(tokenPerEther.mul(100).div(tokenPrice)).div(tokenConversionFactor);
296         require(tokens >= contributionMin);
297 
298         // This is the actual amount of ETH that can be sent to the wallet.
299         uint256 contribution =msg.value;
300         walletAddress.transfer(contribution);
301         totalEtherCollected = totalEtherCollected.add(contribution);
302 
303         // Update our stats counters.
304         totalTokensSold = totalTokensSold.add(tokens);
305 
306         // Transfer tokens to the beneficiary.
307         require(token.transfer(_beneficiary, tokens));
308 
309         emit TokensPurchased(_beneficiary, msg.value, tokens);
310 
311         return tokens;
312     }
313 
314 
315     // Allows the owner to take back the tokens that are assigned to the sale contract.
316     function reclaimTokens() external onlyOwner returns (bool) {
317 
318         uint256 tokens = token.balanceOf(address(this));
319 
320         if (tokens == 0) {
321             return false;
322         }
323 
324         require(token.transfer(owner, tokens));
325 
326         emit TokensReclaimed(tokens);
327 
328         return true;
329     }
330 }
331 
332 contract HCXTokenSaleConfig {
333     address WALLET_ADDRESS = 0x6E22277b9A32a88cba52d5108ca7E836d994859f;
334     address TOKEN_ADDRESS = 0x44F2cEF73E136E97Abc7923634ebEB447F8a48Ed;
335     address UPDATE_PRICE_ADDRESS = 0x29b997d4b41b9840E60b86F32BE029382b14BDCd;
336     uint ETHER_PRICE = 14000;//set current ether price. if current price 1000.00 then write 100000
337 }
338 
339 contract  HCXTokenSale is FlexibleTokenSale, HCXTokenSaleConfig {
340 
341     constructor() public
342     FlexibleTokenSale(TOKEN_ADDRESS,WALLET_ADDRESS,ETHER_PRICE,UPDATE_PRICE_ADDRESS)
343     {
344 
345     }
346 
347 }