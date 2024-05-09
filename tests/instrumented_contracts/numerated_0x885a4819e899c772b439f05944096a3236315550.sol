1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ----------------------------------------------------------------------------
7 contract ERC20 {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 
18     string public constant name = "Token Name";
19     string public constant symbol = "SYM";
20     uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
21 
22 }
23 
24 /**
25  *
26  *	# Marketboard Listing
27  *
28  *	This contract represents an item listed on marketboard.io
29  *
30  */
31 
32 /// Represents a listing on the ProWallet Marketboard
33 contract MarketboardERC20Listing {
34 
35     /// Contract version
36     function _version() pure public returns(uint32) {
37         return 2;
38     }
39 
40     /// Notifies when the listing has been completed
41     event MarketboardListingComplete(address indexed tokenContract, uint256 numTokensSold, uint256 totalEtherPrice, uint256 fee);
42 
43     /// Notifies when the listing was cancelled by the seller
44     event MarketboardListingBuyback(address indexed tokenContract, uint256 numTokens);
45 
46 	/// Notifies when the listing has been destroyed
47 	event MarketboardListingDestroyed();
48 
49     /// Notifies that the seller has changed the price on this listing
50     event MarketboardListingPriceChanged(uint256 oldPricePerToken, uint256 newPricePerToken);
51 
52 
53     /// This function modifier fails if the caller is not the contract creator.
54     modifier moderatorOnly {
55         require(msg.sender == moderator);
56         _;
57     }
58 
59     /// This function modifier fails if the caller is not the contract creator or token seller.
60     modifier moderatorOrSellerOnly {
61         require(moderator == msg.sender || seller == msg.sender);
62         _;
63     }
64 
65     /// The Ethereum price per token
66 	uint256 public tokenPrice = 0;
67 
68     /// The ERC20 token contract address that we are selling
69     address public tokenContract;
70 
71     /// The account which is moderating this transaction. This is also the account which receives the fee profits.
72     address moderator;
73 
74     /// The account which will receive the money if someone buys this listing. This is the account which created the listing.
75     address seller;
76 
77     /// This is a fixed Ethereum fee added to the transaction. The fee is
78     /// sent back to the contract creator after successful purchase.
79     uint256 public feeFixed;
80 
81     /// This fee is a percentage of the total price with a base of 100,000, ie. 1,000 is 1%. The fee is
82     /// sent back to the contract creator after successful purchase.
83     uint32 public feePercentage;
84 	uint32 constant public feePercentageMax = 100000;
85 
86     /// Constructor
87     function MarketboardERC20Listing(address _moderator, uint256 _feeFixed, uint32 _feePercentage, address _erc20Token, uint256 _tokenPrice) public {
88 
89         // Store the contract creator (the automated server account)
90         seller = msg.sender;
91         moderator = _moderator;
92         feeFixed = _feeFixed;
93         feePercentage = _feePercentage;
94         tokenContract = _erc20Token;
95         tokenPrice = _tokenPrice;
96 
97     }
98 
99     /// Get the total amount of ERC20 tokens we are sending
100     function tokenCount() public view returns(uint256) {
101 
102         // Fetch token balance
103         ERC20 erc = ERC20(tokenContract);
104         return erc.balanceOf(this);
105 
106     }
107 
108     /// Get the number of tokens that equals 1 TOKEN in it's base denomination
109     function tokenBase() public view returns(uint256) {
110 
111         // Fetch token balance
112         ERC20 erc = ERC20(tokenContract);
113         uint256 decimals = erc.decimals();
114         return 10 ** decimals;
115 
116     }
117 
118     /// Get the total amount of Ether needed to successfully purchase this item.
119     function totalPrice() public view returns(uint256) {
120 
121         // Return price required
122         return tokenPrice * tokenCount() / tokenBase() + fee();
123 
124     }
125 
126     /// Get the fee this transaction will cost.
127     function fee() public view returns(uint256) {
128 
129         // Get total raw price, item cost * item count
130         uint256 price = tokenPrice * tokenCount() / tokenBase();
131 
132         // Calculate fee
133         return price * feePercentage / feePercentageMax + feeFixed;
134 
135     }
136 
137     /// Allows the seller to change the price of this listing
138     function setPrice(uint256 newTokenPrice) moderatorOrSellerOnly public {
139 
140         // Store old price
141         uint256 oldPrice = tokenPrice;
142 
143         // Set new price
144         tokenPrice = newTokenPrice;
145 
146         // Notify
147         MarketboardListingPriceChanged(oldPrice, newTokenPrice);
148 
149     }
150 
151     /// Perform a buyback, ie. retrieve the item for free. Only the creator or the seller can do this.
152     function buyback(address recipient) moderatorOrSellerOnly public {
153 
154         // Send tokens to the recipient
155         ERC20 erc = ERC20(tokenContract);
156 		uint256 balance = erc.balanceOf(this);
157         erc.transfer(recipient, balance);
158 
159         // Send event
160         MarketboardListingBuyback(tokenContract, balance);
161 
162         // We are done, reset and send remaining Ether (if any) back to the moderator
163         reset();
164 
165     }
166 
167 	/// Purchase the item(s) represented by this listing, and send the tokens to
168     /// another address instead of the sender.
169     function purchase(address recipient) public payable {
170 
171         // Check if the right amount of Ether was sent
172         require(msg.value >= totalPrice());
173 
174         // Send tokens to the recipient
175         ERC20 erc = ERC20(tokenContract);
176 		uint256 balance = erc.balanceOf(this);
177         erc.transfer(recipient, balance);
178 
179 		// Get the amount of Ether to send to the seller
180 		uint256 basePrice = tokenPrice * balance;
181 		require(basePrice > 0);
182 		require(basePrice < this.balance);
183 
184 		// Send Ether to the seller
185 		seller.transfer(basePrice);
186 
187         // Send event
188         MarketboardListingComplete(tokenContract, balance, 0, 0);
189 
190         // We are done, reset and send remaining Ether back to the moderator as fee
191         reset();
192 
193     }
194 
195     /// If somehow another unrelated type of token was sent to this contract, this can be used to claim those tokens back.
196     function claimUnrelatedTokens(address unrelatedTokenContract, address recipient) moderatorOrSellerOnly public {
197 
198         // Make sure we're not dealing with the known token
199         require(tokenContract != unrelatedTokenContract);
200 
201         // Send tokens to the recipient
202         ERC20 erc = ERC20(unrelatedTokenContract);
203         uint256 balance = erc.balanceOf(this);
204         erc.transfer(recipient, balance);
205 
206     }
207 
208 	/// Destroys the listing. Also transfers profits to the moderator.
209 	function reset() internal {
210 
211         // Notify
212         MarketboardListingDestroyed();
213 
214 		// Send remaining Ether (the fee from the last transaction) to the creator as profits
215 		selfdestruct(moderator);
216 
217 	}
218 
219 }