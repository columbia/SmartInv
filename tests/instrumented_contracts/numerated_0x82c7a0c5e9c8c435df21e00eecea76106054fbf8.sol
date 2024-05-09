1 pragma solidity ^0.4.18;
2 
3 contract KimAccessControl {
4   // The addresses of the accounts (or contracts) that can execute actions within each roles.
5   address public ceoAddress;
6   address public cfoAddress;
7   address public cooAddress;
8 
9 
10   /// @dev Access modifier for CEO-only functionality
11   modifier onlyCEO() {
12       require(msg.sender == ceoAddress);
13       _;
14   }
15 
16   /// @dev Access modifier for CFO-only functionality
17   modifier onlyCFO() {
18       require(msg.sender == cfoAddress);
19       _;
20   }
21 
22   /// @dev Access modifier for COO-only functionality
23   modifier onlyCOO() {
24       require(msg.sender == cooAddress);
25       _;
26   }
27 
28   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
29   /// @param _newCEO The address of the new CEO
30   function setCEO(address _newCEO) external onlyCEO {
31       require(_newCEO != address(0));
32 
33       ceoAddress = _newCEO;
34   }
35 
36   /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
37   /// @param _newCFO The address of the new CFO
38   function setCFO(address _newCFO) external onlyCEO {
39       require(_newCFO != address(0));
40 
41       cfoAddress = _newCFO;
42   }
43 
44   /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
45   /// @param _newCOO The address of the new COO
46   function setCOO(address _newCOO) external onlyCEO {
47       require(_newCOO != address(0));
48 
49       cooAddress = _newCOO;
50   }
51 
52 
53 }
54 
55 
56 
57 contract KimContract is KimAccessControl{
58 
59   // DECLARING BASIC VARIABLES, TOKEN SYMBOLS, AND CONSTANTS
60   // Public variables of the token
61   string public name;
62   string public symbol;
63   // total supply of kims ever to be in circulation
64   uint256 public totalSupply;
65   // Total Kims "released" into the market
66   uint256 public kimsCreated;
67   // Total Kims on sale at any given time
68   uint256 public kimsOnAuction;
69   // This is the cut each seller will take on the sale of a KIM
70   uint256 public sellerCut;
71   // A variable to house mathematic function used in _computeCut function
72   uint constant feeDivisor = 100;
73 
74   // Map an owners address to the total amount of KIMS that they own
75   mapping (address => uint256) public balanceOf;
76   // Map the KIM to the owner, "Who owns this Kim?"
77   mapping (uint => address) public tokenToOwner;
78   // This creates a mapping of the tokenId to an Auction
79   mapping (uint256 => TokenAuction) public tokenAuction;
80   // How much ether does this wallet have to withdraw?
81   mapping (address => uint) public pendingWithdrawals;
82 
83   // This generates a public event on the blockchain that will notify clients
84   event Transfer(address indexed from, address indexed to, uint256 value);
85   event TokenAuctionCreated(uint256 tokenIndex, address seller, uint256 sellPrice);
86   event TokenAuctionCompleted(uint256 tokenIndex, address seller, address buyer, uint256 sellPrice);
87   event Withdrawal(address to, uint256 amount);
88 
89   /* Initializes contract with initial supply tokens to the creator of the contract */
90   function KimContract() public {
91     // the creator of the contract is the initial CEO
92     ceoAddress = msg.sender;
93     // the creator of the contract is also the initial COO
94     cooAddress = msg.sender;
95     // Initiate the contract with inital supply of Kims
96     totalSupply = 5000;
97     // Give all initial kims to the contract itself
98     balanceOf[this] = totalSupply;              // Give the creator all initial tokens
99     // This is what we will call KIMs
100     name = "KimJongCrypto";
101     symbol = "KJC";
102     // Declaring seller cut on initalization of the contract
103     sellerCut = 95;
104   }
105 
106   // contstruct the array struct
107   struct TokenAuction {
108     bool isForSale;
109     uint256 tokenIndex;
110     address seller;
111     uint256 sellPrice;
112     uint256 startedAt;
113   }
114 
115 
116   // Only the COO can release new KIMS into the market
117   // We do not have power over the MAXIMUM amount of KIMS that will exist in the future
118   // That was declared when we created the contract
119   // KIMJONGCRYPTO.COM will release KIMS periodically to maintain a healthy market flow
120   function releaseSomeKims(uint256 howMany) external onlyCOO {
121     // We promise not to manipulate the markets, so we take an
122     // average of all the KIMS on sale at any given time
123     uint256 marketAverage = averageKimSalePrice();
124     for(uint256 counter = 0; counter < howMany; counter++) {
125       // map the token to the tokenOwner
126       tokenToOwner[counter] = this;
127       // Put the KIM out on the market for sale
128       _tokenAuction(kimsCreated, this, marketAverage);
129       // Record the amount of KIMS released
130       kimsCreated++;
131     }
132   }
133 
134 
135   // Don't want to keep this KIM?
136   // Sell KIM then...
137   function sellToken(uint256 tokenIndex, uint256 sellPrice) public {
138     // Which KIM are you selling?
139     TokenAuction storage tokenOnAuction = tokenAuction[tokenIndex];
140     // Who's selling the KIM, stored into seller variable
141     address seller = msg.sender;
142     // Do you own this kim?
143     require(_owns(seller, tokenIndex));
144     // Is the KIM already on sale? Can't sell twice!
145     require(tokenOnAuction.isForSale == false);
146     // CLEAR! Send that KIM to Auction!
147     _tokenAuction(tokenIndex, seller, sellPrice);
148   }
149 
150 
151   // INTERNAL FUNCTION, USED ONLY FROM WITHIN THE CONTRACT
152   function _tokenAuction(uint256 tokenIndex, address seller, uint256 sellPrice) internal {
153     // Set the Auction Struct to ON SALE
154     tokenAuction[tokenIndex] = TokenAuction(true, tokenIndex, seller, sellPrice, now);
155     // Fire the Auction Created Event, tell the whole wide world!
156     TokenAuctionCreated(tokenIndex, seller, sellPrice);
157     // Increase the amount of KIMS being sold!
158     kimsOnAuction++;
159   }
160 
161   // Like a KIM?
162   // BUY IT!
163   function buyKim(uint256 tokenIndex) public payable {
164     // Store the KIM in question into tokenOnAuction variable
165     TokenAuction storage tokenOnAuction = tokenAuction[tokenIndex];
166     // How much is this KIM on sale for?
167     uint256 sellPrice = tokenOnAuction.sellPrice;
168     // Is the KIM even on sale? No monkey business!
169     require(tokenOnAuction.isForSale == true);
170     // You are going to have to pay for this KIM! make sure you send enough ether!
171     require(msg.value >= sellPrice);
172     // Who's selling their KIM?
173     address seller = tokenOnAuction.seller;
174     // Who's trying to buy this KIM?
175     address buyer = msg.sender;
176     // CLEAR!
177     // Complete the auction! And transfer the KIM!
178     _completeAuction(tokenIndex, seller, buyer, sellPrice);
179   }
180 
181 
182 
183   // INTERNAL FUNCTION, USED ONLY FROM WITHIN THE CONTRACT
184   function _completeAuction(uint256 tokenIndex, address seller, address buyer, uint256 sellPrice) internal {
185     // Store the contract address
186     address thisContract = this;
187     // How much commision will the Auction House take?
188     uint256 auctioneerCut = _computeCut(sellPrice);
189     // How much will the seller take home?
190     uint256 sellerProceeds = sellPrice - auctioneerCut;
191     // If the KIM is being sold by the Auction House, then do this...
192     if (seller == thisContract) {
193       // Give the funds to the House
194       pendingWithdrawals[seller] += sellerProceeds + auctioneerCut;
195       // Close the Auction
196       tokenAuction[tokenIndex] = TokenAuction(false, tokenIndex, 0, 0, 0);
197       // Anounce it to the world!
198       TokenAuctionCompleted(tokenIndex, seller, buyer, sellPrice);
199     } else { // If the KIM is being sold by an Individual, then do this...
200       // Give the funds to the seller
201       pendingWithdrawals[seller] += sellerProceeds;
202       // Give the funds to the House
203       pendingWithdrawals[this] += auctioneerCut;
204       // Close the Auction
205       tokenAuction[tokenIndex] = TokenAuction(false, tokenIndex, 0, 0, 0);
206       // Anounce it to the world!
207       TokenAuctionCompleted(tokenIndex, seller, buyer, sellPrice);
208     }
209     _transfer(seller, buyer, tokenIndex);
210     kimsOnAuction--;
211   }
212 
213 
214   // Don't want to sell KIM anymore?
215   // Cancel Auction
216   function cancelKimAuction(uint kimIndex) public {
217     require(_owns(msg.sender, kimIndex));
218     // Store the KIM in question into tokenOnAuction variable
219     TokenAuction storage tokenOnAuction = tokenAuction[kimIndex];
220     // Is the KIM even on sale? No monkey business!
221     require(tokenOnAuction.isForSale == true);
222     // Close the Auction
223     tokenAuction[kimIndex] = TokenAuction(false, kimIndex, 0, 0, 0);
224   }
225 
226 
227 
228 
229 
230 
231 
232 
233   // INTERNAL FUNCTION, USED ONLY FROM WITHIN THE CONTRACT
234   // Use this function to find out how much the AuctionHouse will take from this Transaction
235   // All funds go to KIMJONGCRYPTO BCD(BLOCKCHAIN DEVS)!
236   function _computeCut(uint256 sellPrice) internal view returns (uint) {
237     return sellPrice * sellerCut / 1000;
238   }
239 
240 
241 
242 
243 
244 // INTERNAL FUNCTION, USED ONLY FROM WITHIN THE CONTRACT
245   function _transfer(address _from, address _to, uint _value) internal {
246       // Prevent transfer to 0x0 address. Use burn() instead
247       require(_to != 0x0);
248       // Subtract from the sender
249       balanceOf[_from]--;
250       // Add to the reciever
251       balanceOf[_to]++;
252       // map the token to the tokenOwner
253       tokenToOwner[_value] = _to;
254       Transfer(_from, _to, 1);
255   }
256 
257 
258 
259   /**
260    * Transfer tokens
261    *
262    * Send `_value` tokens to `_to` from your account
263    *
264    * @param _to The address of the recipient
265    * @param _value the amount to send
266    */
267    // Go ahead and give away a KIM as a gift!
268   function transfer(address _to, uint256 _value) public {
269       require(_owns(msg.sender, _value));
270       _transfer(msg.sender, _to, _value);
271   }
272 
273 
274   // this function returns bool of owenrship over the token.
275   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
276     return tokenToOwner[_tokenId] == _claimant;
277   }
278 
279 
280   // How much are KIMS really going for now a days?
281   // Run this function and find out!
282   function averageKimSalePrice() public view returns (uint256) {
283     uint256 sumOfAllKimAuctions = 0;
284     if (kimsOnAuction == 0){
285       return 0;
286       } else {
287         for (uint256 i = 0; i <= kimsOnAuction; i++) {
288           sumOfAllKimAuctions += tokenAuction[i].sellPrice;
289         }
290         return sumOfAllKimAuctions / kimsOnAuction;
291       }
292   }
293 
294 
295 
296   // this function serves for users to withdraw their ethereum
297   function withdraw() {
298       uint amount = pendingWithdrawals[msg.sender];
299       require(amount > 0);
300       // Remember to zero the pending refund before
301       // sending to prevent re-entrancy attacks
302       pendingWithdrawals[msg.sender] = 0;
303       msg.sender.transfer(amount);
304       Withdrawal(msg.sender, amount);
305   }
306 
307 
308 
309   // @dev Allows the CFO to capture the balance available to the contract.
310   function withdrawBalance() external onlyCFO {
311       uint balance = pendingWithdrawals[this];
312       pendingWithdrawals[this] = 0;
313       cfoAddress.transfer(balance);
314       Withdrawal(cfoAddress, balance);
315   }
316 
317 
318 
319 
320 
321 
322 }