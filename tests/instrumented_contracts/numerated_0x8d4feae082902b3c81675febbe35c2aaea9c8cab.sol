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
24 /// Represents a listing on the ProWallet Marketboard
25 contract MarketboardERC20Listing {
26 
27     /// Contract version
28     function _version() pure public returns(uint32) {
29         return 2;
30     }
31 
32     /// Notifies when the listing has been completed
33     event MarketboardListingComplete(address indexed tokenContract, uint256 numTokensSold, uint256 totalEtherPrice, uint256 fee, uint256 pricePerToken);
34 
35     /// Notifies when the listing was cancelled by the seller
36     event MarketboardListingBuyback(address indexed tokenContract, uint256 numTokens);
37 
38 	/// Notifies when the listing has been destroyed
39 	event MarketboardListingDestroyed();
40 
41     /// Notifies that the seller has changed the price on this listing
42     event MarketboardListingPriceChanged(uint256 oldPricePerToken, uint256 newPricePerToken);
43 
44 
45     /// This function modifier fails if the caller is not the contract creator.
46     modifier moderatorOnly {
47         require(msg.sender == moderator);
48         _;
49     }
50 
51     /// This function modifier fails if the caller is not the contract creator or token seller.
52     modifier moderatorOrSellerOnly {
53         require(moderator == msg.sender || seller == msg.sender);
54         _;
55     }
56 
57     /// The Ethereum price per token
58 	uint256 public tokenPrice = 0;
59 
60     /// The ERC20 token contract address that we are selling
61     address public tokenContract;
62 
63     /// The account which is moderating this transaction. This is also the account which receives the fee profits.
64     address moderator;
65 
66     /// The account which will receive the money if someone buys this listing. This is the account which created the listing.
67     address seller;
68 
69     /// This is a fixed Ethereum fee added to the transaction. The fee is
70     /// sent back to the contract creator after successful purchase.
71     uint256 public feeFixed;
72 
73     /// This fee is a percentage of the total price with a base of 100,000, ie. 1,000 is 1%. The fee is
74     /// sent back to the contract creator after successful purchase.
75     uint32 public feePercentage;
76 	uint32 constant public feePercentageMax = 100000;
77 
78     /// Constructor
79     function MarketboardERC20Listing(address _moderator, uint256 _feeFixed, uint32 _feePercentage, address _erc20Token, uint256 _tokenPrice) public {
80 
81         // Store the contract creator (the automated server account)
82         seller = msg.sender;
83         moderator = _moderator;
84         feeFixed = _feeFixed;
85         feePercentage = _feePercentage;
86         tokenContract = _erc20Token;
87         tokenPrice = _tokenPrice;
88 
89     }
90 
91     /// Get the total amount of ERC20 tokens we are sending
92     function tokenCount() public view returns(uint256) {
93 
94         // Fetch token balance
95         ERC20 erc = ERC20(tokenContract);
96         return erc.balanceOf(this);
97 
98     }
99 
100     /// Get the number of tokens that equals 1 TOKEN in it's base denomination
101     function tokenBase() public view returns(uint256) {
102 
103         // Fetch token balance
104         ERC20 erc = ERC20(tokenContract);
105         uint256 decimals = erc.decimals();
106         return 10 ** decimals;
107 
108     }
109 
110     /// Get the total amount of Ether needed to successfully purchase this item.
111     function totalPrice() public view returns(uint256) {
112 
113         // Return price required
114         return tokenPrice * tokenCount() / tokenBase() + fee();
115 
116     }
117 
118     /// Get the fee this transaction will cost.
119     function fee() public view returns(uint256) {
120 
121         // Get total raw price, item cost * item count
122         uint256 price = tokenPrice * tokenCount() / tokenBase();
123 
124         // Calculate fee
125         return price * feePercentage / feePercentageMax + feeFixed;
126 
127     }
128 
129     /// Allows the seller to change the price of this listing
130     function setPrice(uint256 newTokenPrice) moderatorOrSellerOnly public {
131 
132         // Store old price
133         uint256 oldPrice = tokenPrice;
134 
135         // Set new price
136         tokenPrice = newTokenPrice;
137 
138         // Notify
139         MarketboardListingPriceChanged(oldPrice, newTokenPrice);
140 
141     }
142 
143     /// Perform a buyback, ie. retrieve the item for free. Only the creator or the seller can do this.
144     function buyback(address recipient) moderatorOrSellerOnly public {
145 
146         // Send tokens to the recipient
147         ERC20 erc = ERC20(tokenContract);
148 		uint256 balance = erc.balanceOf(this);
149         erc.transfer(recipient, balance);
150 
151         // Send event
152         MarketboardListingBuyback(tokenContract, balance);
153 
154         // We are done, reset and send remaining Ether (if any) back to the moderator
155         reset();
156 
157     }
158 
159 	/// Purchase the item(s) represented by this listing, and send the tokens to
160     /// another address instead of the sender.
161     function purchase(address recipient) public payable {
162 
163         // Check if the right amount of Ether was sent
164         require(msg.value >= totalPrice());
165 
166         // Send event
167         MarketboardListingComplete(tokenContract, balance, msg.value, fee(), tokenPrice);
168 
169         // Send tokens to the recipient
170         ERC20 erc = ERC20(tokenContract);
171 		uint256 balance = erc.balanceOf(this);
172         erc.transfer(recipient, balance);
173 
174 		// Get the amount of Ether to send to the seller
175 		uint256 basePrice = tokenPrice * balance / tokenBase();
176 		require(basePrice > 0);
177 		require(basePrice < this.balance);
178 
179 		// Send Ether to the seller
180 		seller.transfer(basePrice);
181 
182         // We are done, reset and send remaining Ether back to the moderator as fee
183         reset();
184 
185     }
186 
187     /// If somehow another unrelated type of token was sent to this contract, this can be used to claim those tokens back.
188     function claimUnrelatedTokens(address unrelatedTokenContract, address recipient) moderatorOrSellerOnly public {
189 
190         // Make sure we're not dealing with the known token
191         require(tokenContract != unrelatedTokenContract);
192 
193         // Send tokens to the recipient
194         ERC20 erc = ERC20(unrelatedTokenContract);
195         uint256 balance = erc.balanceOf(this);
196         erc.transfer(recipient, balance);
197 
198     }
199 
200 	/// Destroys the listing. Also transfers profits to the moderator.
201 	function reset() internal {
202 
203         // Notify
204         MarketboardListingDestroyed();
205 
206 		// Send remaining Ether (the fee from the last transaction) to the creator as profits
207 		selfdestruct(moderator);
208 
209 	}
210 
211 }