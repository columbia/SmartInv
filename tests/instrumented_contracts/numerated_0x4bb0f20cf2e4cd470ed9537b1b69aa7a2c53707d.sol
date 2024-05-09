1 // The list below in the array listTINAmotley is recited in the video
2 // "List, Glory" by Greg Smith. The elements of listTINAmotley can be 
3 // claimed, transferred, bought, and sold. Users can also add to the 
4 // original list.
5 
6 // Code is based on CryptoPunks, by Larva Labs.
7 
8 // List elements in listTINAmotley contain text snippets from 
9 // Margaret Thatcher, Donna Haraway (A Cyborg Manfesto), Francois 
10 // Rabelias (Gargantua and Pantagruel), Walt Whitman (Germs), and 
11 // Miguel de Cervantes (Don Quixote).
12 
13 // This is part of exhibitions at the John Michael Kohler Art Center in
14 // Sheboygan, WI, and at Susan Inglett Gallery in New York, NY.
15 
16 // A list element associated with _index can be claimed if 
17 // gift_CanBeClaimed(_index) returns true. For inquiries
18 // about receiving lines owned by info_ownerOfContract for free, 
19 // email ListTINAmotley@gmail.com. 
20 
21 // In general, the functions that begin with "gift_" are used for 
22 // claiming, transferring, and creating script lines without cost beyond 
23 // the transaction fee. For example, to claim an available list element 
24 // associated with _index, execute the gift_ClaimTINAmotleyLine(_index) 
25 // function.
26 
27 // The functions that begin with "info_" are used to obtain information 
28 // about aspects of the program state, including the address that owns 
29 // a list element, and the "for sale" or "bid" status of a list element. 
30 
31 // The functions that begin with "market_" are used for buying, selling, and
32 // placing bids on a list element. For example, to bid on the list element
33 // associated with _index, send the bid (in wei, not ether) along with
34 // the function execution of market_DeclareBid(_index).
35 
36 // Note that if there's a transaction involving ether (successful sale, 
37 // accepted bid, etc..), the ether (don't forget: in units of wei) is not
38 // automatically credited to an account; it has to be withdrawn by
39 // calling market_WithdrawWei().
40 
41 // Source code and code used to test the contract are available at 
42 // https://github.com/ListTINAmotley/_List_Glory_
43 
44 // EVERYTHING IS IN UNITS OF WEI, NOT ETHER!
45 
46 
47 pragma solidity ^0.4.24;
48 
49 contract _List_Glory_{
50 
51     string public info_Name;
52     string public info_Symbol;
53 
54     address public info_OwnerOfContract;
55     // Contains the list
56     string[] private listTINAmotley;
57     // Contains the total number of elements in the list
58     uint256 private listTINAmotleyTotalSupply;
59     
60     mapping (uint => address) private listTINAmotleyIndexToAddress;
61     mapping(address => uint256) private listTINAmotleyBalanceOf;
62  
63     // Put list element up for sale by owner. Can be linked to specific 
64     // potential buyer
65     struct forSaleInfo {
66         bool isForSale;
67         uint256 tokenIndex;
68         address seller;
69         uint256 minValue;          //in wei.... everything in wei
70         address onlySellTo;     // specify to sell only to a specific person
71     }
72 
73     // Place bid for specific list element
74     struct bidInfo {
75         bool hasBid;
76         uint256 tokenIndex;
77         address bidder;
78         uint256 value;
79     }
80 
81     // Public info about tokens for sale.
82     mapping (uint256 => forSaleInfo) public info_ForSaleInfoByIndex;
83     // Public info about highest bid for each token.
84     mapping (uint256 => bidInfo) public info_BidInfoByIndex;
85     // Information about withdrawals (in units of wei) available  
86     //  ... for addresses due to failed bids, successful sales, etc...
87     mapping (address => uint256) public info_PendingWithdrawals;
88 
89 //Events
90 
91 
92     event Claim(uint256 tokenId, address indexed to);
93     event Transfer(uint256 tokenId, address indexed from, address indexed to);
94     event ForSaleDeclared(uint256 indexed tokenId, address indexed from, 
95         uint256 minValue,address indexed to);
96     event ForSaleWithdrawn(uint256 indexed tokenId, address indexed from);
97     event ForSaleBought(uint256 indexed tokenId, uint256 value, 
98         address indexed from, address indexed to);
99     event BidDeclared(uint256 indexed tokenId, uint256 value, 
100         address indexed from);
101     event BidWithdrawn(uint256 indexed tokenId, uint256 value, 
102         address indexed from);
103     event BidAccepted(uint256 indexed tokenId, uint256 value, 
104         address indexed from, address indexed to);
105     
106     constructor () public {
107         info_OwnerOfContract = msg.sender;
108 	    info_Name = "List, Glory";
109 	    info_Symbol = "L, G";
110         listTINAmotley.push("Now that, that there, that's for everyone");
111         listTINAmotleyIndexToAddress[0] = address(0);
112         listTINAmotley.push("Everyone's invited");
113         listTINAmotleyIndexToAddress[1] = address(0);
114         listTINAmotley.push("Just bring your lists");
115         listTINAmotleyIndexToAddress[2] = address(0);
116  	listTINAmotley.push("The for godsakes of surveillance");
117         listTINAmotleyIndexToAddress[3] = address(0);
118  	listTINAmotley.push("The shitabranna of there is no alternative");
119         listTINAmotleyIndexToAddress[4] = address(0);
120  	listTINAmotley.push("The clew-bottom of trustless memorials");
121         listTINAmotleyIndexToAddress[5] = address(0);
122 	listTINAmotley.push("The churning ballock of sadness");
123         listTINAmotleyIndexToAddress[6] = address(0);
124 	listTINAmotley.push("The bagpiped bravado of TINA");
125         listTINAmotleyIndexToAddress[7] = address(0);
126 	listTINAmotley.push("There T");
127         listTINAmotleyIndexToAddress[8] = address(0);
128 	listTINAmotley.push("Is I");
129         listTINAmotleyIndexToAddress[9] = address(0);
130 	listTINAmotley.push("No N");
131         listTINAmotleyIndexToAddress[10] = address(0);
132 	listTINAmotley.push("Alternative A");
133         listTINAmotleyIndexToAddress[11] = address(0);
134 	listTINAmotley.push("TINA TINA TINA");
135         listTINAmotleyIndexToAddress[12] = address(0);
136 	listTINAmotley.push("Motley");
137         listTINAmotleyIndexToAddress[13] = info_OwnerOfContract;
138 	listTINAmotley.push("There is no alternative");
139         listTINAmotleyIndexToAddress[14] = info_OwnerOfContract;
140 	listTINAmotley.push("Machines made of sunshine");
141         listTINAmotleyIndexToAddress[15] = info_OwnerOfContract;
142 	listTINAmotley.push("Infidel heteroglossia");
143         listTINAmotleyIndexToAddress[16] = info_OwnerOfContract;
144 	listTINAmotley.push("TINA and the cyborg, Margaret and motley");
145         listTINAmotleyIndexToAddress[17] = info_OwnerOfContract;
146 	listTINAmotley.push("Motley fecundity, be fruitful and multiply");
147         listTINAmotleyIndexToAddress[18] = info_OwnerOfContract;
148 	listTINAmotley.push("Perverts! Mothers! Leninists!");
149         listTINAmotleyIndexToAddress[19] = info_OwnerOfContract;
150 	listTINAmotley.push("Space!");
151         listTINAmotleyIndexToAddress[20] = info_OwnerOfContract;
152 	listTINAmotley.push("Over the exosphere");
153         listTINAmotleyIndexToAddress[21] = info_OwnerOfContract;
154 	listTINAmotley.push("On top of the stratosphere");
155         listTINAmotleyIndexToAddress[22] = info_OwnerOfContract;
156 	listTINAmotley.push("On top of the troposphere");
157         listTINAmotleyIndexToAddress[23] = info_OwnerOfContract;
158 	listTINAmotley.push("Over the chandelier");
159         listTINAmotleyIndexToAddress[24] = info_OwnerOfContract;
160 	listTINAmotley.push("On top of the lithosphere");
161         listTINAmotleyIndexToAddress[25] = info_OwnerOfContract;
162 	listTINAmotley.push("Over the crust");
163         listTINAmotleyIndexToAddress[26] = info_OwnerOfContract;
164 	listTINAmotley.push("You're the top");
165         listTINAmotleyIndexToAddress[27] = info_OwnerOfContract;
166 	listTINAmotley.push("You're the top");
167         listTINAmotleyIndexToAddress[28] = info_OwnerOfContract;
168 	listTINAmotley.push("Be fruitful!");
169         listTINAmotleyIndexToAddress[29] = info_OwnerOfContract;
170 	listTINAmotley.push("Fill the atmosphere, the heavens, the ether");
171         listTINAmotleyIndexToAddress[30] = info_OwnerOfContract;
172 	listTINAmotley.push("Glory! Glory. TINA TINA Glory.");
173         listTINAmotleyIndexToAddress[31] = info_OwnerOfContract;
174 	listTINAmotley.push("Over the stratosphere");
175         listTINAmotleyIndexToAddress[32] = info_OwnerOfContract;
176 	listTINAmotley.push("Over the mesosphere");
177         listTINAmotleyIndexToAddress[33] = info_OwnerOfContract;
178 	listTINAmotley.push("Over the troposphere");
179         listTINAmotleyIndexToAddress[34] = info_OwnerOfContract;
180 	listTINAmotley.push("On top of bags of space");
181         listTINAmotleyIndexToAddress[35] = info_OwnerOfContract;
182 	listTINAmotley.push("Over backbones and bags of ether");
183         listTINAmotleyIndexToAddress[36] = info_OwnerOfContract;
184 	listTINAmotley.push("Now TINA, TINA has a backbone");
185         listTINAmotleyIndexToAddress[37] = info_OwnerOfContract;
186 	listTINAmotley.push("And motley confetti lists");
187         listTINAmotleyIndexToAddress[38] = info_OwnerOfContract;
188 	listTINAmotley.push("Confetti arms, confetti feet, confetti mouths, confetti faces");
189         listTINAmotleyIndexToAddress[39] = info_OwnerOfContract;
190 	listTINAmotley.push("Confetti assholes");
191         listTINAmotleyIndexToAddress[40] = info_OwnerOfContract;
192 	listTINAmotley.push("Confetti cunts and confetti cocks");
193         listTINAmotleyIndexToAddress[41] = info_OwnerOfContract;
194 	listTINAmotley.push("Confetti offspring, splendid suns");
195         listTINAmotleyIndexToAddress[42] = info_OwnerOfContract;
196 	listTINAmotley.push("The moon and rings, the countless combinations and effects");
197         listTINAmotleyIndexToAddress[43] = info_OwnerOfContract;
198 	listTINAmotley.push("Such-like, and good as such-like");
199         listTINAmotleyIndexToAddress[44] = info_OwnerOfContract;
200 	listTINAmotley.push("(Mumbled)");
201         listTINAmotleyIndexToAddress[45] = info_OwnerOfContract;
202 	listTINAmotley.push("Everything's for sale");
203         listTINAmotleyIndexToAddress[46] = info_OwnerOfContract;
204 	listTINAmotley.push("Just bring your lists");
205         listTINAmotleyIndexToAddress[47] = info_OwnerOfContract;
206 	listTINAmotley.push("Micro resurrections");
207         listTINAmotleyIndexToAddress[48] = info_OwnerOfContract;
208 	listTINAmotley.push("Paddle steamers");
209         listTINAmotleyIndexToAddress[49] = info_OwnerOfContract;
210 	listTINAmotley.push("Windmills");
211         listTINAmotleyIndexToAddress[50] = info_OwnerOfContract;
212 	listTINAmotley.push("Anti-anti-utopias");
213         listTINAmotleyIndexToAddress[51] = info_OwnerOfContract;
214 	listTINAmotley.push("Rocinante lists");
215         listTINAmotleyIndexToAddress[52] = info_OwnerOfContract;
216 	listTINAmotley.push("In memoriam lists");
217         listTINAmotleyIndexToAddress[53] = info_OwnerOfContract;
218 	listTINAmotley.push("TINA TINA TINA");
219         listTINAmotleyIndexToAddress[54] = info_OwnerOfContract;
220        
221 
222         listTINAmotleyBalanceOf[info_OwnerOfContract] = 42;
223         listTINAmotleyBalanceOf[address(0)] = 13;
224         listTINAmotleyTotalSupply = 55;
225      }
226      
227     function info_TotalSupply() public view returns (uint256 total){
228         total = listTINAmotleyTotalSupply;
229         return total;
230     }
231 
232     //Number of list elements owned by an account.
233     function info_BalanceOf(address _owner) public view 
234             returns (uint256 balance){
235         balance = listTINAmotleyBalanceOf[_owner];
236         return balance;
237     }
238     
239     //Shows text of a list element.
240     function info_SeeTINAmotleyLine(uint256 _tokenId) external view 
241             returns(string){
242         require(_tokenId < listTINAmotleyTotalSupply);
243         return listTINAmotley[_tokenId];
244     }
245     
246     function info_OwnerTINAmotleyLine(uint256 _tokenId) external view 
247             returns (address owner){
248         require(_tokenId < listTINAmotleyTotalSupply);
249         owner = listTINAmotleyIndexToAddress[_tokenId];
250         return owner;
251     }
252 
253     // Is the line available to be claimed?
254     function info_CanBeClaimed(uint256 _tokenId) external view returns(bool){
255  	require(_tokenId < listTINAmotleyTotalSupply);
256 	if (listTINAmotleyIndexToAddress[_tokenId] == address(0))
257 	  return true;
258 	else
259 	  return false;
260 	  }
261 	
262     // Claim line owned by address(0).
263     function gift_ClaimTINAmotleyLine(uint256 _tokenId) external returns(bool){
264         require(_tokenId < listTINAmotleyTotalSupply);
265         require(listTINAmotleyIndexToAddress[_tokenId] == address(0));
266         listTINAmotleyIndexToAddress[_tokenId] = msg.sender;
267         listTINAmotleyBalanceOf[msg.sender]++;
268         listTINAmotleyBalanceOf[address(0)]--;
269         emit Claim(_tokenId, msg.sender);
270         return true;
271     }
272 
273    // Create new list element. 
274     function gift_CreateTINAmotleyLine(string _text) external returns(bool){ 
275         require (msg.sender != address(0));
276         uint256  oldTotalSupply = listTINAmotleyTotalSupply;
277         listTINAmotleyTotalSupply++;
278         require (listTINAmotleyTotalSupply > oldTotalSupply);
279         listTINAmotley.push(_text);
280         uint256 _tokenId = listTINAmotleyTotalSupply - 1;
281         listTINAmotleyIndexToAddress[_tokenId] = msg.sender;
282         listTINAmotleyBalanceOf[msg.sender]++;
283         return true;
284     }
285 
286     // Transfer by owner to address. Transferring to address(0) will
287     // make line available to be claimed.
288     function gift_Transfer(address _to, uint256 _tokenId) public returns(bool) {
289         address initialOwner = listTINAmotleyIndexToAddress[_tokenId];
290         require (initialOwner == msg.sender);
291         require (_tokenId < listTINAmotleyTotalSupply);
292         // Remove for sale.
293         market_WithdrawForSale(_tokenId);
294         rawTransfer (initialOwner, _to, _tokenId);
295         // Remove new owner's bid, if it exists.
296         clearNewOwnerBid(_to, _tokenId);
297         return true;
298     }
299 
300     // Let anyone interested know that the owner put a token up for sale. 
301     // Anyone can obtain it by sending an amount of wei equal to or
302     // larger than  _minPriceInWei. 
303     function market_DeclareForSale(uint256 _tokenId, uint256 _minPriceInWei) 
304             external returns (bool){
305         require (_tokenId < listTINAmotleyTotalSupply);
306         address tokenOwner = listTINAmotleyIndexToAddress[_tokenId];
307         require (msg.sender == tokenOwner);
308         info_ForSaleInfoByIndex[_tokenId] = forSaleInfo(true, _tokenId, 
309             msg.sender, _minPriceInWei, address(0));
310         emit ForSaleDeclared(_tokenId, msg.sender, _minPriceInWei, address(0));
311         return true;
312     }
313     
314     // Let anyone interested know that the owner put a token up for sale. 
315     // Only the address _to can obtain it by sending an amount of wei equal 
316     // to or larger than _minPriceInWei.
317     function market_DeclareForSaleToAddress(uint256 _tokenId, uint256 
318             _minPriceInWei, address _to) external returns(bool){
319         require (_tokenId < listTINAmotleyTotalSupply);
320         address tokenOwner = listTINAmotleyIndexToAddress[_tokenId];
321         require (msg.sender == tokenOwner);
322         info_ForSaleInfoByIndex[_tokenId] = forSaleInfo(true, _tokenId, 
323             msg.sender, _minPriceInWei, _to);
324         emit ForSaleDeclared(_tokenId, msg.sender, _minPriceInWei, _to);
325         return true;
326     }
327 
328     // Owner no longer wants token for sale, or token has changed owner, 
329     // so previously posted for sale is no longer valid.
330     function market_WithdrawForSale(uint256 _tokenId) public returns(bool){
331         require (_tokenId < listTINAmotleyTotalSupply);
332         require (msg.sender == listTINAmotleyIndexToAddress[_tokenId]);
333         info_ForSaleInfoByIndex[_tokenId] = forSaleInfo(false, _tokenId, 
334             address(0), 0, address(0));
335         emit ForSaleWithdrawn(_tokenId, msg.sender);
336         return true;
337     }
338     
339     // I'll take it. Must send at least as many wei as minValue in 
340     // forSale structure.
341     function market_BuyForSale(uint256 _tokenId) payable external returns(bool){
342         require (_tokenId < listTINAmotleyTotalSupply);
343         forSaleInfo storage existingForSale = info_ForSaleInfoByIndex[_tokenId];
344         require(existingForSale.isForSale);
345         require(existingForSale.onlySellTo == address(0) || 
346             existingForSale.onlySellTo == msg.sender);
347         require(msg.value >= existingForSale.minValue); 
348         require(existingForSale.seller == 
349             listTINAmotleyIndexToAddress[_tokenId]); 
350         address seller = listTINAmotleyIndexToAddress[_tokenId];
351         rawTransfer(seller, msg.sender, _tokenId);
352         // must withdrawal for sale after transfer to make sure msg.sender
353         //  is the current owner.
354         market_WithdrawForSale(_tokenId);
355         // clear bid of new owner, if it exists
356         clearNewOwnerBid(msg.sender, _tokenId);
357         info_PendingWithdrawals[seller] += msg.value;
358         emit ForSaleBought(_tokenId, msg.value, seller, msg.sender);
359         return true;
360     }
361     
362     // Let anyone interested know that potential buyer put up money for a token.
363     function market_DeclareBid(uint256 _tokenId) payable external returns(bool){
364         require (_tokenId < listTINAmotleyTotalSupply);
365         require (listTINAmotleyIndexToAddress[_tokenId] != address(0));
366         require (listTINAmotleyIndexToAddress[_tokenId] != msg.sender);
367         require (msg.value > 0);
368         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
369         // Keep only the highest bid.
370         require (msg.value > existingBid.value);
371         if (existingBid.value > 0){
372             info_PendingWithdrawals[existingBid.bidder] += existingBid.value;
373         }
374         info_BidInfoByIndex[_tokenId] = bidInfo(true, _tokenId, 
375             msg.sender, msg.value);
376         emit BidDeclared(_tokenId, msg.value, msg.sender);
377         return true;
378     }
379     
380     // Potential buyer changes mind and withdrawals bid.
381     function market_WithdrawBid(uint256 _tokenId) external returns(bool){
382         require (_tokenId < listTINAmotleyTotalSupply);
383         require (listTINAmotleyIndexToAddress[_tokenId] != address(0));
384         require (listTINAmotleyIndexToAddress[_tokenId] != msg.sender);
385         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
386         require (existingBid.hasBid);
387         require (existingBid.bidder == msg.sender);
388         uint256 amount = existingBid.value;
389         // Refund
390         info_PendingWithdrawals[existingBid.bidder] += amount;
391         info_BidInfoByIndex[_tokenId] = bidInfo(false, _tokenId, address(0), 0);
392         emit BidWithdrawn(_tokenId, amount, msg.sender);
393         return true;
394     }
395     
396     // Accept bid, and transfer money and token. All money in wei.
397     function market_AcceptBid(uint256 _tokenId, uint256 minPrice) 
398             external returns(bool){
399         require (_tokenId < listTINAmotleyTotalSupply);
400         address seller = listTINAmotleyIndexToAddress[_tokenId];
401         require (seller == msg.sender);
402         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
403         require (existingBid.hasBid);
404         //Bid must be larger than minPrice
405         require (existingBid.value > minPrice);
406         address buyer = existingBid.bidder;
407         // Remove for sale.
408         market_WithdrawForSale(_tokenId);
409         rawTransfer (seller, buyer, _tokenId);
410         uint256 amount = existingBid.value;
411         // Remove bid.
412         info_BidInfoByIndex[_tokenId] = bidInfo(false, _tokenId, address(0),0);
413         info_PendingWithdrawals[seller] += amount;
414         emit BidAccepted(_tokenId, amount, seller, buyer);
415         return true;
416     }
417     
418     // Retrieve money to successful sale, failed bid, withdrawn bid, etc.
419     //  All in wei. Note that refunds, income, etc. are NOT automatically
420     // deposited in the user's address. The user must withdraw the funds.
421     function market_WithdrawWei() external returns(bool) {
422        uint256 amount = info_PendingWithdrawals[msg.sender];
423        require (amount > 0);
424        info_PendingWithdrawals[msg.sender] = 0;
425        msg.sender.transfer(amount);
426        return true;
427     } 
428     
429     function clearNewOwnerBid(address _to, uint256 _tokenId) internal {
430         // clear bid when become owner via transfer or forSaleBuy
431         bidInfo storage existingBid = info_BidInfoByIndex[_tokenId];
432         if (existingBid.bidder == _to){
433             uint256 amount = existingBid.value;
434             info_PendingWithdrawals[_to] += amount;
435             info_BidInfoByIndex[_tokenId] = bidInfo(false, _tokenId, 
436                 address(0), 0);
437             emit BidWithdrawn(_tokenId, amount, _to);
438         }
439       
440     }
441     
442     function rawTransfer(address _from, address _to, uint256 _tokenId) 
443             internal {
444         listTINAmotleyBalanceOf[_from]--;
445         listTINAmotleyBalanceOf[_to]++;
446         listTINAmotleyIndexToAddress[_tokenId] = _to;
447         emit Transfer(_tokenId, _from, _to);
448     }
449     
450     
451 }