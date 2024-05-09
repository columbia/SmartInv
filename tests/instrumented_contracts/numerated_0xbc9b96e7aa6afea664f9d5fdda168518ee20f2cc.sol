1 pragma solidity ^0.4.2;
2 
3 contract ERC721 {
4     function isERC721() public pure returns (bool b);
5     function implementsERC721() public pure returns (bool b);
6     function name() public pure returns (string name);
7     function symbol() public pure returns (string symbol);
8     function totalSupply() public view returns (uint256 totalSupply);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function ownerOf(uint256 _tokenId) public view returns (address owner);
11     function approve(address _to, uint256 _tokenId) public;
12     function takeOwnership(uint256 _tokenId) public;
13     function transferFrom(address _from, address _to, uint256 _tokenId) public;
14     function transfer(address _to, uint256 _tokenId) public;
15     function tokenOfOwnerByIndex(address _owner, uint256 _index) constant returns (uint tokenId);
16     function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
19     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
20 }
21 
22 contract HumanityCard is ERC721 {
23 
24     ///////////////////////////////////////////////////////////////
25     /// Modifiers
26 
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     event Mined(address indexed owner, uint16 human);
33 
34     ///////////////////////////////////////////////////////////////
35     /// Structures
36 
37     struct Human {
38         string name;
39         uint8 max;
40         uint mined;
41     }
42 
43     struct Card {
44         uint16 human;
45         address owner;
46         uint indexUser;
47     }
48 
49     struct SellOrder {
50         address seller;
51         uint card;
52         uint price;
53     }
54 
55     ///////////////////////////////////////////////////////////////
56     /// Constants
57 
58     string constant NAME = "HumanityCards";
59     string constant SYMBOL = "HCX";
60 
61     ///////////////////////////////////////////////////////////////
62     /// Attributes
63 
64     address owner;
65     uint cardPrice;
66     uint humanNumber;
67     Human[] humanArray;
68     uint cardNumber;
69     uint cardMined;
70     Card[] cardArray;
71     mapping (address => uint256) cardCount;
72     mapping (uint256 => address) approveMap;
73     SellOrder[] sellOrderList;
74 
75     // Index of the card for the user
76     mapping (address => mapping (uint => uint)) indexCard;
77 
78     ///////////////////////////////////////////////////////////////
79     /// Constructor
80 
81     function HumanityCard() public {
82         owner = msg.sender;
83         cardPrice = 1 finney;
84         humanNumber = 0;
85         cardNumber = 0;
86         cardMined = 0;
87     }
88 
89     ///////////////////////////////////////////////////////////////
90     /// Admin functions
91 
92     function addHuman(string name, uint8 max) public onlyOwner {
93         Human memory newHuman = Human(name, max, 0);
94         humanArray.push(newHuman);
95         humanNumber += 1;
96         cardNumber += max;
97     }
98 
99     // Used only if ether price increase (decrease the price card)
100     function changeCardPrice(uint newPrice) public onlyOwner {
101         cardPrice = newPrice;
102     }
103 
104     ///////////////////////////////////////////////////////////////
105     /// Implementation ERC721
106 
107     function isERC721() public pure returns (bool b) {
108         return true;
109     }
110 
111     function implementsERC721() public pure returns (bool b) {
112         return true;
113     }
114 
115     function name() public pure returns (string _name) {
116         return NAME;
117     }
118 
119     function symbol() public pure returns (string _symbol) {
120         return SYMBOL;
121     }
122 
123     function totalSupply() public view returns (uint256 _totalSupply) {
124         return cardMined;
125     }
126 
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         return cardCount[_owner];
129     }
130 
131     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
132         require(_tokenId < cardMined);
133         Card c = cardArray[_tokenId];
134         return c.owner;
135     }
136 
137     function approve(address _to, uint256 _tokenId) public {
138         require(msg.sender == ownerOf(_tokenId));
139         require(msg.sender != _to);
140         approveMap[_tokenId] = _to;
141         Approval(msg.sender, _to, _tokenId);
142     }
143 
144     function transferFrom(address _from, address _to, uint256 _tokenId) public {
145         require(_tokenId < cardMined);
146         require(_from == ownerOf(_tokenId));
147         require(_from != _to);
148         require(approveMap[_tokenId] == _to);
149 
150         cardCount[_from] -= 1;
151 
152         // Change the indexCard of _from
153         indexCard[_from][cardArray[_tokenId].indexUser] = indexCard[_from][cardCount[_from]];
154         cardArray[indexCard[_from][cardCount[_from]]].indexUser = cardArray[_tokenId].indexUser;
155 
156         // This card is the last one for the new owner
157         cardArray[_tokenId].indexUser = cardCount[_to];
158         indexCard[_to][cardCount[_to]] = _tokenId;
159 
160         cardArray[_tokenId].owner = _to;
161         cardCount[_to] += 1;
162         Transfer(_from, _to, _tokenId);
163     }
164 
165     function takeOwnership(uint256 _tokenId) public {
166         require(_tokenId < cardMined);
167         address oldOwner = ownerOf(_tokenId);
168         address newOwner = msg.sender;
169         require(newOwner != oldOwner);
170         require(approveMap[_tokenId] == msg.sender);
171 
172         cardCount[oldOwner] -= 1;
173 
174         // Change the indexCard of _from
175         indexCard[oldOwner][cardArray[_tokenId].indexUser] = indexCard[oldOwner][cardCount[oldOwner]];
176         cardArray[indexCard[oldOwner][cardCount[oldOwner]]].indexUser = cardArray[_tokenId].indexUser;
177 
178         // This card is the last one for the new owner
179         cardArray[_tokenId].indexUser = cardCount[newOwner];
180         indexCard[newOwner][cardCount[newOwner]] = _tokenId;
181 
182         cardArray[_tokenId].owner = newOwner;
183         cardCount[newOwner] += 1;
184         Transfer(oldOwner, newOwner, _tokenId);
185     }
186 
187     function transfer(address _to, uint256 _tokenId) public {
188         require(_tokenId < cardMined);
189         address oldOwner = msg.sender;
190         address newOwner = _to;
191         require(oldOwner == ownerOf(_tokenId));
192         require(oldOwner != newOwner);
193         require(newOwner != address(0));
194 
195         cardCount[oldOwner] -= 1;
196 
197         // Change the indexCard of _from
198         indexCard[oldOwner][cardArray[_tokenId].indexUser] = indexCard[oldOwner][cardCount[oldOwner]];
199         cardArray[indexCard[oldOwner][cardCount[oldOwner]]].indexUser = cardArray[_tokenId].indexUser;
200 
201         // This card is the last one for the new owner
202         cardArray[_tokenId].indexUser = cardCount[newOwner];
203         indexCard[newOwner][cardCount[newOwner]] = _tokenId;
204 
205         cardArray[_tokenId].owner = newOwner;
206         cardCount[newOwner] += 1;
207         Transfer(oldOwner, newOwner, _tokenId);
208     }
209 
210     function tokenOfOwnerByIndex(address _owner, uint256 _index) constant returns (uint tokenId) {
211         require(_index < cardCount[_owner]);
212 
213         return indexCard[_owner][_index];
214     }
215 
216     // For this case the only metadata is the name of the human
217     function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl) {
218         require(_tokenId < cardMined);
219 
220         uint16 humanId = cardArray[_tokenId].human;
221         return humanArray[humanId].name;
222     }
223 
224     ///////////////////////////////////////////////////////////////
225     /// HumanityCard functions
226 
227     // Mine a new card
228     function mineCard() public payable returns(bool success) {
229         require(msg.value == cardPrice);
230         require(cardMined < cardNumber);
231 
232         int remaining = (int)(cardNumber - cardMined);
233 
234         // Choosing the card
235         int numero = int(keccak256(block.timestamp))%remaining;
236         if(numero < 0) {
237             numero *= -1;
238         }
239         uint16 chosenOne = 0;
240         while (numero >= 0) {
241             numero -= (int)(humanArray[chosenOne].max-humanArray[chosenOne].mined);
242             if (numero >= 0) {
243                 chosenOne += 1;
244             }
245         }
246 
247         // Adding the card to the user
248         address newOwner = msg.sender;
249         Card memory newCard = Card(chosenOne, newOwner, cardCount[newOwner]);
250         cardArray.push(newCard);
251 
252         // This card is the last one
253         indexCard[newOwner][cardCount[newOwner]] = cardMined;
254         cardCount[newOwner] += 1;
255 
256         // Updating cards informations
257         cardMined += 1;
258         humanArray[chosenOne].mined += 1;
259 
260         // Sending the fund to the owner
261         if(!owner.send(cardPrice)) {
262            revert();
263         }
264 
265          Mined(newOwner, chosenOne);
266 
267         return true;
268     }
269 
270     // Sale functions
271     function createSellOrder(uint256 _tokenId, uint price) public {
272         require(_tokenId < cardMined);
273         require(msg.sender == ownerOf(_tokenId));
274 
275         SellOrder memory newOrder = SellOrder(msg.sender, _tokenId, price);
276         sellOrderList.push(newOrder);
277 
278         cardArray[_tokenId].owner = address(0);
279         cardCount[msg.sender] -= 1;
280 
281         // Change the indexCard of sender
282         indexCard[msg.sender][cardArray[_tokenId].indexUser] = indexCard[msg.sender][cardCount[msg.sender]];
283         cardArray[indexCard[msg.sender][cardCount[msg.sender]]].indexUser = cardArray[_tokenId].indexUser;
284     }
285 
286     function processSellOrder(uint id, uint256 _tokenId) payable public {
287         require(id < sellOrderList.length);
288 
289         SellOrder memory order = sellOrderList[id];
290         require(order.card == _tokenId);
291         require(msg.value == order.price);
292         require(msg.sender != order.seller);
293 
294         // Sending fund to the seller
295         if(!order.seller.send(msg.value)) {
296            revert();
297         }
298 
299         // Adding card to the buyer
300         cardArray[_tokenId].owner = msg.sender;
301 
302         // This card is the last one for the new owner
303         cardArray[_tokenId].indexUser = cardCount[msg.sender];
304         indexCard[msg.sender][cardCount[msg.sender]] = _tokenId;
305 
306         cardCount[msg.sender] += 1;
307 
308         // Update list
309         sellOrderList[id] = sellOrderList[sellOrderList.length-1];
310         delete sellOrderList[sellOrderList.length-1];
311         sellOrderList.length--;
312     }
313 
314     function cancelSellOrder(uint id, uint256 _tokenId) public {
315         require(id < sellOrderList.length);
316 
317         SellOrder memory order = sellOrderList[id];
318         require(order.seller == msg.sender);
319         require(order.card == _tokenId);
320 
321         // Give back card to seller
322         cardArray[_tokenId].owner = msg.sender;
323 
324         // This card is the last one for the new owner
325         cardArray[_tokenId].indexUser = cardCount[msg.sender];
326         indexCard[msg.sender][cardCount[msg.sender]] = _tokenId;
327 
328         cardCount[msg.sender] += 1;
329 
330         // Update list
331         sellOrderList[id] = sellOrderList[sellOrderList.length-1];
332         delete sellOrderList[sellOrderList.length-1];
333         sellOrderList.length--;
334     }
335 
336     function getSellOrder(uint id) public view returns(address seller, uint card, uint price) {
337         require(id < sellOrderList.length);
338 
339         SellOrder memory ret = sellOrderList[id];
340         return(ret.seller, ret.card, ret.price);
341     }
342 
343     function getNbSellOrder() public view returns(uint nb) {
344         return sellOrderList.length;
345     }
346 
347 
348     // Get functions
349     function getOwner() public view returns(address ret) {
350         return owner;
351     }
352 
353     function getCardPrice() public view returns(uint ret) {
354         return cardPrice;
355     }
356 
357     function getHumanNumber() public view returns(uint ret) {
358         return humanNumber;
359     }
360 
361     function getHumanInfo(uint i) public view returns(string name, uint8 max, uint mined) {
362         require(i < humanNumber);
363         Human memory h = humanArray[i];
364         return (h.name, h.max, h.mined);
365     }
366 
367     function getCardNumber() public view returns(uint ret) {
368         return cardNumber;
369     }
370 
371     function getCardInfo(uint256 _tokenId) public view returns(uint16 human, address owner) {
372         require(_tokenId < cardMined);
373         Card memory c = cardArray[_tokenId];
374         return (c.human, c.owner);
375     }
376 }