1 pragma solidity ^0.5.5;
2 
3 //WLC VERSION 11
4 
5 contract DreamCarToken {
6     function getForWLC(address _owner) public {}
7 }
8 
9 contract WishListToken {
10     string internal constant tokenName   = 'WishListCoin';
11     string internal constant tokenSymbol = 'WLC';
12     
13     uint256 public constant decimals = 0;
14     
15     //the total count of wishes
16     uint256 public totalTokenSupply;
17     
18     //this address is the CEO
19     address payable public CEO;
20     
21     // Mapping from owner to ids of owned tokens
22     mapping (address => uint256[]) internal tokensOwnedBy;
23     
24     // Mapping from owner to ids of exchanged tokens
25     mapping (address => uint256[]) internal tokensExchangedBy;
26     
27     //Token price in WEI
28     uint256 public tokenPrice;
29     
30     //A list of price admins; they can change price, in addition to the CEO
31     address[] public priceAdmins;
32     
33     //Next id that will be assigned to token
34     uint256 internal nextTokenId = 1;
35     
36     //DCC INTERACTION VARIABLES
37     
38     //A DreamCarToken contract address, which will be used to allow the exchange of WLC tokens for DCC tokens
39     DreamCarToken public dreamCarCoinExchanger;
40     
41     /**
42      * Gets the total amount of tokens stored by the contract
43      * @return uint256 representing the total amount of tokens
44      */
45     function totalSupply() public view returns (uint256 total) {
46         return totalTokenSupply;
47     }
48     
49     /**
50      * Gets the balance of the specified address
51      * @param _owner address to query the balance of
52      * @return uint256 representing the amount owned by the passed address
53      */
54     function balanceOf(address _owner) public view returns (uint256 balance) {
55         return tokensOwnedBy[_owner].length;
56     }
57     
58     /**
59      * Returns a list of the tokens ids, owned by the passed address
60      * @param _owner address the address to check
61      * @return the list of token ids
62      */
63     function tokensOfOwner(address _owner) external view returns (uint256[] memory tokenIds) {
64         return tokensOwnedBy[_owner];
65     }
66     
67     /**
68      * Checks if the provided token is owned by the provided address
69      * @param _tokenId uint256 the number of the token
70      * @param _owner address the address to check
71      * @return the token is owned or not
72      */
73     function tokenIsOwnedBy(uint256 _tokenId, address _owner) external view returns (bool isTokenOwner) {
74         for (uint256 i = 0; i < balanceOf(_owner); i++) {
75             if (tokensOwnedBy[_owner][i] == _tokenId) {
76                 return true;
77             }
78         }
79         
80         return false;
81     }
82     
83     /**
84      * Transfers the specified token to the specified address
85      * @param _to address the receiver
86      * @param _tokenId uint256 the id of the token
87      */
88     function transfer(address _to, uint256 _tokenId) external {
89         require(_to != address(0));
90         
91         uint256 tokenIndex = getTokenIndex(msg.sender, _tokenId);
92         
93         //swap token for the last one in the list
94         tokensOwnedBy[msg.sender][tokenIndex] = tokensOwnedBy[msg.sender][tokensOwnedBy[msg.sender].length - 1];
95         tokensOwnedBy[msg.sender].pop();
96         
97         tokensOwnedBy[_to].push(_tokenId);
98 
99         emit Transfer(msg.sender, _to, _tokenId);
100     }
101    
102     /**
103      * Gets the token name
104      * @return string representing the token name
105      */
106     function name() external pure returns (string memory _name) {
107         return tokenName;
108     }
109     
110     /**
111      * Gets the token symbol
112      * @return string representing the token symbol
113      */
114     function symbol() external pure returns (string memory _symbol) {
115         return tokenSymbol;
116     }
117     
118     event Transfer(address from, address to, uint256 tokenId);
119     
120     event Buy(address indexed from, uint256 amount, uint256 fromTokenId, uint256 toTokenId, uint256 timestamp);
121     
122     event Exchange(address indexed from, uint256 tokenId);
123     
124     event ExchangeForDCC(address indexed from, uint256 tokenId);
125     
126     /**
127      * Ensures that the caller of the function is the CEO of contract
128      */
129     modifier onlyCEO {
130         require(msg.sender == CEO, 'You need to be the CEO to do that!');
131         _;
132     }
133     
134     /**
135      * Constructor of the contract
136      * @param _ceo address the CEO (owner) of the contract
137      */
138     constructor (address payable _ceo) public {
139         CEO = _ceo;
140         
141         totalTokenSupply = 1000000;
142         
143         tokenPrice = 22250000000000000; // (if eth = 269USD, 6 USD for token)
144     }
145 
146     /**
147      * Gets an array of all tokens ids, exchanged by the specified address
148      * @param _owner address The exchanger of the tokens
149      * @return uint256[] The list of exchanged tokens ids
150      */
151     function exchangedBy(address _owner) external view returns (uint256[] memory tokenIds) {
152         return tokensExchangedBy[_owner];
153     }
154     
155     /**
156      * Gets the last existing token ids
157      * @return uint256 the id of the token
158      */
159     function lastTokenId() public view returns (uint256 tokenId) {
160         return nextTokenId - 1;
161     }
162     
163     /**
164      * Sets a new price for the tokensExchangedBy
165      * @param _newPrice uint256 the new price in WEI
166      */
167     function setTokenPriceInWEI(uint256 _newPrice) public {
168         bool transactionAllowed = false;
169         
170         if (msg.sender == CEO) {
171             transactionAllowed = true;
172         } else {
173             for (uint256 i = 0; i < priceAdmins.length; i++) {
174                 if (msg.sender == priceAdmins[i]) {
175                     transactionAllowed = true;
176                     break;
177                 }
178             }
179         }
180         
181         require((transactionAllowed == true), 'You cannot do that!');
182         tokenPrice = _newPrice;
183     }
184     
185     /**
186      * Add a new price admin address to the list
187      * @param _newPriceAdmin address the address of the new price admin
188      */
189     function addPriceAdmin(address _newPriceAdmin) onlyCEO public {
190         priceAdmins.push(_newPriceAdmin);
191     }
192     
193     /**
194      * Remove existing price admin address from the list
195      * @param _existingPriceAdmin address the address of the existing price admin
196      */
197     function removePriceAdmin(address _existingPriceAdmin) onlyCEO public {
198         for (uint256 i = 0; i < priceAdmins.length; i++) {
199             if (_existingPriceAdmin == priceAdmins[i]) {
200                 delete priceAdmins[i];
201                 break;
202             }
203         }
204     }
205     
206     /**
207      * Gets the index of the specified token from the owner's collection
208      * @param _owner address the address to check
209      * @param _tokenId uint256 the number of the token
210      * @return the token index
211      */
212     function getTokenIndex(address _owner, uint256 _tokenId) internal view returns (uint256 _index) {
213         for (uint256 i = 0; i < balanceOf(_owner); i++) {
214             if (tokensOwnedBy[_owner][i] == _tokenId) {
215                 return i;
216             }
217         }
218         
219         require(false, 'You do not own this token!');
220     }
221     
222     /**
223      * Adds the specified number of tokens to the specified address
224      * Internal method, used when creating new tokens
225      * @param _to address The address, which is going to own the tokens
226      * @param _amount uint256 The number of tokens
227      */
228     function _addTokensToAddress(address _to, uint256 _amount) internal {
229         for (uint256 i = 0; i < _amount; i++) {
230             tokensOwnedBy[_to].push(nextTokenId + i);
231         }
232         
233         nextTokenId += _amount;
234     }
235     
236     /**
237      * Scales the amount of tokens in a purchase, to ensure it will be less or equal to the amount of unsold tokens
238      * If there are no tokens left, it will return 0
239      * @param _amount uint256 the amount of tokens in the purchase attempt
240      * @return _exactAmount uint256
241      */
242     function scalePurchaseTokenAmountToMatchRemainingTokens(uint256 _amount) internal view returns (uint256 _exactAmount) {
243         if (nextTokenId + _amount - 1 > totalTokenSupply) {
244             _amount = totalTokenSupply - nextTokenId + 1;
245         }
246         
247         return _amount;
248     }
249     
250     /**
251     * Buy new tokens with ETH
252     * Calculates the number of tokens for the given ETH amount
253     * Creates the new tokens when they are purchased
254     * Returns the excessive ETH (if any) to the transaction sender
255     */
256     function buy() payable public {
257         require(msg.value >= tokenPrice, "You did't send enough ETH");
258         
259         uint256 amount = scalePurchaseTokenAmountToMatchRemainingTokens(msg.value / tokenPrice);
260         
261         require(amount > 0, "Not enough tokens are available for purchase!");
262         
263         _addTokensToAddress(msg.sender, amount);
264         
265         emit Buy(msg.sender, amount, nextTokenId - amount, nextTokenId - 1, now);
266         
267         //transfer ETH to CEO
268         CEO.transfer((amount * tokenPrice));
269         
270         //returns excessive ETH
271         msg.sender.transfer(msg.value - (amount * tokenPrice));
272     }
273     
274     /**
275      * Removes a token from the provided address balance and puts it in the tokensExchangedBy mapping
276      * @param _owner address the address of the token owner
277      * @param _tokenId uint256 the id of the token
278      */
279     function exchangeToken(address _owner, uint256 _tokenId) internal {
280         uint256 tokenIndex = getTokenIndex(_owner, _tokenId);
281         
282         //swap token for the last one in the list
283         tokensOwnedBy[msg.sender][tokenIndex] = tokensOwnedBy[msg.sender][tokensOwnedBy[msg.sender].length - 1];
284         tokensOwnedBy[msg.sender].pop();
285 
286         tokensExchangedBy[_owner].push(_tokenId);
287     }
288     
289     /**
290     * Allows user to destroy a specified token in order to claim his prize for it
291     * @param _tokenId uint256 ID of the token
292     */
293     function exchange(uint256 _tokenId) public {
294         exchangeToken(msg.sender, _tokenId);
295         
296         emit Exchange(msg.sender, _tokenId);
297     }
298     
299     /**
300      * Allows the CEO to increase the totalTokenSupply
301      * @param _amount uint256 the number of tokens to create
302      */
303     function mint(uint256 _amount) onlyCEO public {
304         require (_amount > 0, 'Amount must be bigger than 0!');
305         totalTokenSupply += _amount;
306     }
307     
308     //DCC INTERACTION FUNCTIONS
309     
310     /**
311      * Allows the CEO to set an address of DreamCarToken contract, which will be used to exchanger
312      * WLCs for DCCs
313      * @param _address address the address of the DreamCarToken contract
314      */
315     function setDreamCarCoinExchanger(address _address) public onlyCEO {
316         require (_address != address(0));
317         dreamCarCoinExchanger = DreamCarToken(_address);
318     }
319     
320     /**
321      * Allows the CEO to remove the address of DreamCarToken contract, which will be used to exchanger
322      * WLCs for DCCs
323      */
324     function removeDreamCarCoinExchanger() public onlyCEO {
325         dreamCarCoinExchanger = DreamCarToken(address(0));
326     }
327     
328     /**
329      * Allows a user to exchange any WLC coin token a DCC token
330      * @param _tokenId uint256 the id of the owned token
331      */
332     function exchangeForDCC(uint256 _tokenId) public {
333         require (address(dreamCarCoinExchanger) != address(0));
334         
335         dreamCarCoinExchanger.getForWLC(msg.sender);
336         
337         exchangeToken(msg.sender, _tokenId);
338         
339         emit ExchangeForDCC(msg.sender, _tokenId);
340     }
341 }