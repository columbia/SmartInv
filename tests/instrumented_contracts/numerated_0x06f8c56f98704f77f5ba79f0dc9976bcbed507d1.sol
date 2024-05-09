1 // The elements of the array listTINAmotley can be claimed, 
2 // transferred, bought, and sold on the ethereum network. 
3 // Users can also add to the original array.
4 
5 // The elements in listTINAmotley below are recited in a video
6 // by Greg Smith. Both the video and this program will be part of
7 // exhibitions at the John Michael Kohler Art Center in
8 // Sheboygan, WI, and at Susan Inglett Gallery in New York, NY.
9 
10 // This program is based on CryptoPunks, by Larva Labs.
11 
12 // List elements in listTINAmotley contain text snippets from 
13 // Margaret Thatcher, Donna Haraway (A Cyborg Manfesto), Francois 
14 // Rabelias (Gargantua and Pantagruel), Walt Whitman (Germs), and 
15 // Miguel de Cervantes (Don Quixote).
16 
17 // A list element associated with _index can be claimed if 
18 // gift_CanBeClaimed(_index) returns true. For inquiries
19 // about receiving lines owned by info_ownerOfContract for free, 
20 // email ListTINAmotley@gmail.com. 
21 
22 // In general, the functions that begin with "gift_" are used for 
23 // claiming, transferring, and creating script lines without cost beyond 
24 // the transaction fee. For example, to claim an available list element 
25 // associated with _index, execute the gift_ClaimTINAmotleyLine(_index) 
26 // function.
27 
28 // The functions that begin with "info_" are used to obtain information 
29 // about aspects of the program state, including the address that owns 
30 // a list element, and the "for sale" or "bid" status of a list element. 
31 
32 // The functions that begin with "market_" are used for buying, selling, and
33 // placing bids on a list element. For example, to bid on the list element
34 // associated with _index, send the bid (in wei, not ether) along with
35 // the function execution of market_DeclareBid(_index).
36 
37 // Note that if there's a transaction involving ether (successful sale, 
38 // accepted bid, etc..), the ether (don't forget: in units of wei) is not
39 // automatically credited to an account; it has to be withdrawn by
40 // calling market_WithdrawWei().
41 
42 // Source code and code used to test the contract are available at 
43 // https://github.com/ListTINAmotley/LcommaG
44 
45 // EVERYTHING IS IN UNITS OF WEI, NOT ETHER!
46 
47 // Contract is deployed at  on the 
48 // mainnet.
49 
50 
51 pragma solidity ^0.4.24;
52 
53 contract LcommaG {
54 
55     string public info_Name;
56     string public info_Symbol;
57 
58     address public info_OwnerOfContract;
59     // Contains the list
60     string[] private listTINAmotley;
61     // Contains the total number of elements in the list
62     uint256 private listTINAmotleyTotalSupply;
63     
64     mapping (uint => address) private listTINAmotleyIndexToAddress;
65     mapping(address => uint256) private listTINAmotleyBalanceOf;
66  
67     // Put list element up for sale by owner. Can be linked to specific 
68     // potential buyer
69     struct forSaleInfo {
70         bool isForSale;
71         uint256 tokenIndex;
72         address seller;
73         uint256 minValue;          //in wei.... everything in wei
74         address onlySellTo;     // specify to sell only to a specific person
75     }
76 
77     // Place bid for specific list element
78     struct bidInfo {
79         bool hasBid;
80         uint256 tokenIndex;
81         address bidder;
82         uint256 value;
83     }
84 
85     // Public info about tokens for sale.
86     mapping (uint256 => forSaleInfo) public info_ForSaleInfoByIndex;
87     // Public info about highest bid for each token.
88     mapping (uint256 => bidInfo) public info_BidInfoByIndex;
89     // Information about withdrawals (in units of wei) available  
90     //  ... for addresses due to failed bids, successful sales, etc...
91     mapping (address => uint256) public info_PendingWithdrawals;
92 
93 //Events
94 
95 
96     event Claim(uint256 tokenId, address indexed to);
97     event Transfer(uint256 tokenId, address indexed from, address indexed to);
98     event ForSaleDeclared(uint256 indexed tokenId, address indexed from, 
99         uint256 minValue,address indexed to);
100     event ForSaleWithdrawn(uint256 indexed tokenId, address indexed from);
101     event ForSaleBought(uint256 indexed tokenId, uint256 value, 
102         address indexed from, address indexed to);
103     event BidDeclared(uint256 indexed tokenId, uint256 value, 
104         address indexed from);
105     event BidWithdrawn(uint256 indexed tokenId, uint256 value, 
106         address indexed from);
107     event BidAccepted(uint256 indexed tokenId, uint256 value, 
108         address indexed from, address indexed to);
109     
110     constructor () public {
111     	info_OwnerOfContract = msg.sender;
112 	info_Name = "LcommaG";
113 	info_Symbol = "L, G";
114 	listTINAmotley.push("Now that, that there, that's for everyone");
115 	listTINAmotleyIndexToAddress[0] = address(0);
116 	listTINAmotley.push("Everyone's invited");
117 	listTINAmotleyIndexToAddress[1] = address(0);
118 	listTINAmotley.push("Just bring your lists");
119 	listTINAmotleyIndexToAddress[2] = address(0);
120 	listTINAmotley.push("The for godsakes of surveillance");
121 	listTINAmotleyIndexToAddress[3] = address(0);
122 	listTINAmotley.push("The shitabranna of there is no alternative");
123 	listTINAmotleyIndexToAddress[4] = address(0);
124 	listTINAmotley.push("The clew-bottom of trustless memorials");
125 	listTINAmotleyIndexToAddress[5] = address(0);
126 	listTINAmotley.push("The churning ballock of sadness");
127 	listTINAmotleyIndexToAddress[6] = address(0);
128 	listTINAmotley.push("The bagpiped bravado of TINA");
129 	listTINAmotleyIndexToAddress[7] = address(0);
130 	listTINAmotley.push("There T");
131 	listTINAmotleyIndexToAddress[8] = address(0);
132 	listTINAmotley.push("Is I");
133 	listTINAmotleyIndexToAddress[9] = address(0);
134 	listTINAmotley.push("No N");
135 	listTINAmotleyIndexToAddress[10] = address(0);
136 	listTINAmotley.push("Alternative A");
137 	listTINAmotleyIndexToAddress[11] = address(0);
138 	listTINAmotley.push("TINA TINA TINA");
139 	listTINAmotleyIndexToAddress[12] = address(0);
140 	listTINAmotley.push("Motley");
141 	listTINAmotleyIndexToAddress[13] = info_OwnerOfContract;
142 	listTINAmotley.push("There is no alternative");
143 	listTINAmotleyIndexToAddress[14] = info_OwnerOfContract;
144 	listTINAmotley.push("Machines made of sunshine");
145 	listTINAmotleyIndexToAddress[15] = info_OwnerOfContract;
146 	listTINAmotley.push("Infidel heteroglossia");
147 	listTINAmotleyIndexToAddress[16] = info_OwnerOfContract;
148 	listTINAmotley.push("TINA and the cyborg, Margaret and motley");
149 	listTINAmotleyIndexToAddress[17] = info_OwnerOfContract;
150 	listTINAmotley.push("Motley fecundity, be fruitful and multiply");
151 	listTINAmotleyIndexToAddress[18] = info_OwnerOfContract;
152 	listTINAmotley.push("Perverts! Mothers! Leninists!");
153 	listTINAmotleyIndexToAddress[19] = info_OwnerOfContract;
154 	listTINAmotley.push("Space!");
155 	listTINAmotleyIndexToAddress[20] = info_OwnerOfContract;
156 	listTINAmotley.push("Over the exosphere");
157 	listTINAmotleyIndexToAddress[21] = info_OwnerOfContract;
158 	listTINAmotley.push("On top of the stratosphere");
159 	listTINAmotleyIndexToAddress[22] = info_OwnerOfContract;
160 	listTINAmotley.push("On top of the troposphere");
161 	listTINAmotleyIndexToAddress[23] = info_OwnerOfContract;
162 	listTINAmotley.push("Over the chandelier");
163 	listTINAmotleyIndexToAddress[24] = info_OwnerOfContract;
164 	listTINAmotley.push("On top of the lithosphere");
165 	listTINAmotleyIndexToAddress[25] = info_OwnerOfContract;
166 	listTINAmotley.push("Over the crust");
167 	listTINAmotleyIndexToAddress[26] = info_OwnerOfContract;
168 	listTINAmotley.push("You're the top");
169 	listTINAmotleyIndexToAddress[27] = info_OwnerOfContract;
170 	listTINAmotley.push("You're the top");
171 	listTINAmotleyIndexToAddress[28] = info_OwnerOfContract;
172 	listTINAmotley.push("Be fruitful!");
173 	listTINAmotleyIndexToAddress[29] = info_OwnerOfContract;
174 	listTINAmotley.push("Fill the atmosphere, the heavens, the ether");
175 	listTINAmotleyIndexToAddress[30] = info_OwnerOfContract;
176 	listTINAmotley.push("Glory! Glory. TINA TINA Glory.");
177 	listTINAmotleyIndexToAddress[31] = info_OwnerOfContract;
178 	listTINAmotley.push("Over the stratosphere");
179 	listTINAmotleyIndexToAddress[32] = info_OwnerOfContract;
180 	listTINAmotley.push("Over the mesosphere");
181 	listTINAmotleyIndexToAddress[33] = info_OwnerOfContract;
182 	listTINAmotley.push("Over the troposphere");
183 	listTINAmotleyIndexToAddress[34] = info_OwnerOfContract;
184 	listTINAmotley.push("On top of bags of space");
185 	listTINAmotleyIndexToAddress[35] = info_OwnerOfContract;
186 	listTINAmotley.push("Over backbones and bags of ether");
187 	listTINAmotleyIndexToAddress[36] = info_OwnerOfContract;
188 	listTINAmotley.push("Now TINA, TINA has a backbone");
189 	listTINAmotleyIndexToAddress[37] = info_OwnerOfContract;
190 	listTINAmotley.push("And motley confetti lists");
191 	listTINAmotleyIndexToAddress[38] = info_OwnerOfContract;
192 	listTINAmotley.push("Confetti arms, confetti feet, confetti mouths, confetti faces");
193 	listTINAmotleyIndexToAddress[39] = info_OwnerOfContract;
194 	listTINAmotley.push("Confetti assholes");
195 	listTINAmotleyIndexToAddress[40] = info_OwnerOfContract;
196 	listTINAmotley.push("Confetti cunts and confetti cocks");
197 	listTINAmotleyIndexToAddress[41] = info_OwnerOfContract;
198 	listTINAmotley.push("Confetti offspring, splendid suns");
199 	listTINAmotleyIndexToAddress[42] = info_OwnerOfContract;
200 	listTINAmotley.push("The moon and rings, the countless combinations and effects");
201 	listTINAmotleyIndexToAddress[43] = info_OwnerOfContract;
202 	listTINAmotley.push("Such-like, and good as such-like");
203 	listTINAmotleyIndexToAddress[44] = info_OwnerOfContract;
204 	listTINAmotley.push("(Mumbled)");
205 	listTINAmotleyIndexToAddress[45] = info_OwnerOfContract;
206 	listTINAmotley.push("Everything's for sale");
207 	listTINAmotleyIndexToAddress[46] = info_OwnerOfContract;
208 	listTINAmotley.push("Just bring your lists");
209 	listTINAmotleyIndexToAddress[47] = info_OwnerOfContract;
210 	listTINAmotley.push("Micro resurrections");
211 	listTINAmotleyIndexToAddress[48] = info_OwnerOfContract;
212 	listTINAmotley.push("Paddle steamers");
213 	listTINAmotleyIndexToAddress[49] = info_OwnerOfContract;
214 	listTINAmotley.push("Windmills");
215 	listTINAmotleyIndexToAddress[50] = info_OwnerOfContract;
216 	listTINAmotley.push("Anti-anti-utopias");
217 	listTINAmotleyIndexToAddress[51] = info_OwnerOfContract;
218 	listTINAmotley.push("Rocinante lists");
219 	listTINAmotleyIndexToAddress[52] = info_OwnerOfContract;
220 	listTINAmotley.push("In memoriam lists");
221 	listTINAmotleyIndexToAddress[53] = info_OwnerOfContract;
222 	listTINAmotley.push("TINA TINA TINA");
223 	listTINAmotleyIndexToAddress[54] = info_OwnerOfContract;
224        
225 	listTINAmotleyBalanceOf[info_OwnerOfContract] = 42;
226 	listTINAmotleyBalanceOf[address(0)] = 13;
227 	listTINAmotleyTotalSupply = 55;
228      }
229      
230     function info_TotalSupply() public view returns (uint256 total){
231         total = listTINAmotleyTotalSupply;
232         return total;
233     }
234 
235     //Number of list elements owned by an account.
236     function info_BalanceOf(address _owner) public view 
237             returns (uint256 balance){
238         balance = listTINAmotleyBalanceOf[_owner];
239         return balance;
240     }
241     
242     //Shows text of a list element.
243     function info_SeeTINAmotleyLine(uint256 _tokenId) external view 
244             returns(string){
245         require(_tokenId < listTINAmotleyTotalSupply);
246         return listTINAmotley[_tokenId];
247     }
248     
249     function info_OwnerTINAmotleyLine(uint256 _tokenId) external view 
250             returns (address owner){
251         require(_tokenId < listTINAmotleyTotalSupply);
252         owner = listTINAmotleyIndexToAddress[_tokenId];
253         return owner;
254     }
255 
256     // Is the line available to be claimed?
257     function info_CanBeClaimed(uint256 _tokenId) external view returns(bool){
258  	require(_tokenId < listTINAmotleyTotalSupply);
259 	if (listTINAmotleyIndexToAddress[_tokenId] == address(0))
260 	  return true;
261 	else
262 	  return false;
263 	  }
264 	
265     // Claim line owned by address(0).
266     function gift_ClaimTINAmotleyLine(uint256 _tokenId) external returns(bool){
267         require(_tokenId < listTINAmotleyTotalSupply);
268         require(listTINAmotleyIndexToAddress[_tokenId] == address(0));
269         listTINAmotleyIndexToAddress[_tokenId] = msg.sender;
270         listTINAmotleyBalanceOf[msg.sender]++;
271         listTINAmotleyBalanceOf[address(0)]--;
272         emit Claim(_tokenId, msg.sender);
273         return true;
274     }
275 
276    // Create new list element. 
277     function gift_CreateTINAmotleyLine(string _text) external returns(bool){ 
278         require (msg.sender != address(0));
279         uint256  oldTotalSupply = listTINAmotleyTotalSupply;
280         listTINAmotleyTotalSupply++;
281         require (listTINAmotleyTotalSupply > oldTotalSupply);
282         listTINAmotley.push(_text);
283         uint256 _tokenId = listTINAmotleyTotalSupply - 1;
284         listTINAmotleyIndexToAddress[_tokenId] = msg.sender;
285         listTINAmotleyBalanceOf[msg.sender]++;
286         return true;
287     }
288 
289     // Transfer by owner to address. Transferring to address(0) will
290     // make line available to be claimed.
291     function gift_Transfer(address _to, uint256 _tokenId) public returns(bool) {
292         address initialOwner = listTINAmotleyIndexToAddress[_tokenId];
293         require (initialOwner == msg.sender);
294         require (_tokenId < listTINAmotleyTotalSupply);
295         // Remove for sale.
296         market_WithdrawForSale(_tokenId);
297         rawTransfer (initialOwner, _to, _tokenId);
298         // Remove new owner's bid, if it exists.
299         clearNewOwnerBid(_to, _tokenId);
300         return true;
301     }
302 
303     // Let anyone interested know that the owner put a token up for sale. 
304     // Anyone can obtain it by sending an amount of wei equal to or
305     // larger than  _minPriceInWei. 
306     function market_DeclareForSale(uint256 _tokenId, uint256 _minPriceInWei) 
307             external returns (bool){
308         require (_tokenId < listTINAmotleyTotalSupply);
309         address tokenOwner = listTINAmotleyIndexToAddress[_tokenId];
310         require (msg.sender == tokenOwner);
311         info_ForSaleInfoByIndex[_tokenId] = forSaleInfo(true, _tokenId, 
312             msg.sender, _minPriceInWei, address(0));
313         emit ForSaleDeclared(_tokenId, msg.sender, _minPriceInWei, address(0));
314         return true;
315     }
316     
317     // Let anyone interested know that the owner put a token up for sale. 
318     // Only the address _to can obtain it by sending an amount of wei equal 
319     // to or larger than _minPriceInWei.
320     function market_DeclareForSaleToAddress(uint256 _tokenId, uint256 
321             _minPriceInWei, address _to) external returns(bool){
322         require (_tokenId < listTINAmotleyTotalSupply);
323         address tokenOwner = listTINAmotleyIndexToAddress[_tokenId];
324         require (msg.sender == tokenOwner);
325         info_ForSaleInfoByIndex[_tokenId] = forSaleInfo(true, _tokenId, 
326             msg.sender, _minPriceInWei, _to);
327         emit ForSaleDeclared(_tokenId, msg.sender, _minPriceInWei, _to);
328         return true;
329     }
330 
331     // Owner no longer wants token for sale, or token has changed owner, 
332     // so previously posted for sale is no longer valid.
333     function market_WithdrawForSale(uint256 _tokenId) public returns(bool){
334         require (_tokenId < listTINAmotleyTotalSupply);
335         require (msg.sender == listTINAmotleyIndexToAddress[_tokenId]);
336         info_ForSaleInfoByIndex[_tokenId] = forSaleInfo(false, _tokenId, 
337             address(0), 0, address(0));
338         emit ForSaleWithdrawn(_tokenId, msg.sender);
339         return true;
340     }
341     
342     // I'll take it. Must send at least as many wei as minValue in 
343     // forSale structure.
344     function market_BuyForSale(uint256 _tokenId) payable external returns(bool){
345         require (_tokenId < listTINAmotleyTotalSupply);
346         forSaleInfo storage existingForSale = info_ForSaleInfoByIndex[_tokenId];
347         require(existingForSale.isForSale);
348         require(existingForSale.onlySellTo == address(0) || 
349             existingForSale.onlySellTo == msg.sender);
350         require(msg.value >= existingForSale.minValue); 
351         require(existingForSale.seller == 
352             listTINAmotleyIndexToAddress[_tokenId]); 
353         address seller = listTINAmotleyIndexToAddress[_tokenId];
354         rawTransfer(seller, msg.sender, _tokenId);
355         // must withdrawal for sale after transfer to make sure msg.sender
356         //  is the current owner.
357         market_WithdrawForSale(_tokenId);
358         // clear bid of new owner, if it exists
359         clearNewOwnerBid(msg.sender, _tokenId);
360         info_PendingWithdrawals[seller] += msg.value;
361         emit ForSaleBought(_tokenId, msg.value, seller, msg.sender);
362         return true;
363     }
364     
365     // Let anyone interested know that potential buyer put up money for a token.
366     function market_DeclareBid(uint256 _tokenId) payable external returns(bool){
367         require (_tokenId < listTINAmotleyTotalSupply);
368         require (listTINAmotleyIndexToAddress[_tokenId] != address(0));
369         require (listTINAmotleyIndexToAddress[_tokenId] != msg.sender);
370         require (msg.value > 0);
371         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
372         // Keep only the highest bid.
373         require (msg.value > existingBid.value);
374         if (existingBid.value > 0){
375             info_PendingWithdrawals[existingBid.bidder] += existingBid.value;
376         }
377         info_BidInfoByIndex[_tokenId] = bidInfo(true, _tokenId, 
378             msg.sender, msg.value);
379         emit BidDeclared(_tokenId, msg.value, msg.sender);
380         return true;
381     }
382     
383     // Potential buyer changes mind and withdrawals bid.
384     function market_WithdrawBid(uint256 _tokenId) external returns(bool){
385         require (_tokenId < listTINAmotleyTotalSupply);
386         require (listTINAmotleyIndexToAddress[_tokenId] != address(0));
387         require (listTINAmotleyIndexToAddress[_tokenId] != msg.sender);
388         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
389         require (existingBid.hasBid);
390         require (existingBid.bidder == msg.sender);
391         uint256 amount = existingBid.value;
392         // Refund
393         info_PendingWithdrawals[existingBid.bidder] += amount;
394         info_BidInfoByIndex[_tokenId] = bidInfo(false, _tokenId, address(0), 0);
395         emit BidWithdrawn(_tokenId, amount, msg.sender);
396         return true;
397     }
398     
399     // Accept bid, and transfer money and token. All money in wei.
400     function market_AcceptBid(uint256 _tokenId, uint256 minPrice) 
401             external returns(bool){
402         require (_tokenId < listTINAmotleyTotalSupply);
403         address seller = listTINAmotleyIndexToAddress[_tokenId];
404         require (seller == msg.sender);
405         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
406         require (existingBid.hasBid);
407         //Bid must be larger than minPrice
408         require (existingBid.value > minPrice);
409         address buyer = existingBid.bidder;
410         // Remove for sale.
411         market_WithdrawForSale(_tokenId);
412         rawTransfer (seller, buyer, _tokenId);
413         uint256 amount = existingBid.value;
414         // Remove bid.
415         info_BidInfoByIndex[_tokenId] = bidInfo(false, _tokenId, address(0),0);
416         info_PendingWithdrawals[seller] += amount;
417         emit BidAccepted(_tokenId, amount, seller, buyer);
418         return true;
419     }
420     
421     // Retrieve money to successful sale, failed bid, withdrawn bid, etc.
422     //  All in wei. Note that refunds, income, etc. are NOT automatically
423     // deposited in the user's address. The user must withdraw the funds.
424     function market_WithdrawWei() external returns(bool) {
425        uint256 amount = info_PendingWithdrawals[msg.sender];
426        require (amount > 0);
427        info_PendingWithdrawals[msg.sender] = 0;
428        msg.sender.transfer(amount);
429        return true;
430     } 
431     
432     function clearNewOwnerBid(address _to, uint256 _tokenId) internal {
433         // clear bid when become owner via transfer or forSaleBuy
434         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
435         if (existingBid.bidder == _to){
436             uint256 amount = existingBid.value;
437             info_PendingWithdrawals[_to] += amount;
438             info_BidInfoByIndex[_tokenId] = bidInfo(false, _tokenId, 
439                 address(0), 0);
440             emit BidWithdrawn(_tokenId, amount, _to);
441         }
442       
443     }
444     
445     function rawTransfer(address _from, address _to, uint256 _tokenId) 
446             internal {
447         listTINAmotleyBalanceOf[_from]--;
448         listTINAmotleyBalanceOf[_to]++;
449         listTINAmotleyIndexToAddress[_tokenId] = _to;
450         emit Transfer(_tokenId, _from, _to);
451     }
452     
453     
454 }