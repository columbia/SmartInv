1 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
2 
3 contract MyToken {
4     uint8 public decimals;
5     mapping (address => uint256) public balanceOf;
6     mapping (address => mapping (address => uint256)) public allowance;
7     function MyToken(
8         uint256 initialSupply,
9         string tokenName,
10         uint8 decimalUnits,
11         string tokenSymbol
12         );
13     function transfer(address _to, uint256 _value);
14     function approveAndCall(address _spender, uint256 _value, bytes _extraData);
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16 }
17 
18 contract DTE {
19     string public standard = 'Token 0.1';
20     string public name;
21     string public symbol;
22     uint8 public decimals;
23     uint256 public totalSupply;
24     uint public amountOfHolders;
25     uint public totalSellOrders;
26     uint public totalBuyOrders;
27     uint public totalTokens;
28     uint public totalDividendPayOuts;
29     string public solidityCompileVersion = "v0.3.6-2016-09-08-acd334c";
30     string public takerFeePercent = "1%";
31     string public tokenAddFee = "0.1 ether";
32 
33     struct sellOrder {
34         bool isOpen;
35         bool isTaken;
36         address seller;
37         uint soldTokenNo;
38         uint boughtTokenNo;
39         uint256 soldAmount;
40         uint256 boughtAmount;
41     }
42     
43     struct buyOrder {
44         bool isOpen;
45         bool isTaken;
46         address buyer;
47         uint soldTokenNo;
48         uint boughtTokenNo;
49         uint256 soldAmount;
50         uint256 boughtAmount;
51     }
52 
53     mapping (uint => MyToken) public tokensAddress;
54     mapping (address => uint) public tokenNoByAddress;
55     mapping (uint => sellOrder) public sellOrders;
56     mapping (uint => buyOrder) public buyOrders;
57     mapping (address => uint) public totalBuyOrdersOf;
58     mapping (address => uint) public totalSellOrdersOf;
59     mapping (address => mapping(uint => uint)) public BuyOrdersOf;
60     mapping (address => mapping(uint => uint)) public SellOrdersOf;
61     mapping (uint => uint256) public collectedFees;
62     mapping (address => mapping(uint => uint256)) public claimableFeesOf;
63     mapping (address => uint256) public balanceOf;
64     mapping (address => mapping (address => uint256)) public allowance;
65     mapping (uint => address) public shareHolderByNumber;
66     mapping (address => uint) public shareHolderByAddress;
67     mapping (address => bool) isHolder;
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event SellOrder(uint indexed OrderNo, address indexed Seller, uint SoldTokenNo, uint256 SoldAmount, uint BoughtTokenNo, uint256 BoughtAmount);
71     event BuyOrder(uint indexed OrderNo, address indexed Buyer, uint SoldTokenNo, uint256 SoldAmount, uint BoughtTokenNo, uint256 BoughtAmount);
72     event OrderTake(uint indexed OrderNo);
73     event CancelOrder(uint indexed OrderNo);
74     event TokenAdd(uint indexed TokenNumber, address indexed TokenAddress);
75     event DividendDistribution(uint indexed TokenNumber, uint256 totalAmount);
76 
77     function transfer(address _to, uint256 _value) {
78         if (balanceOf[msg.sender] < _value) throw;
79         if (_value == 0) throw;
80         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
81         if(isHolder[_to] && balanceOf[msg.sender] == _value) {
82             isHolder[msg.sender] = false;
83             shareHolderByAddress[_to] = shareHolderByAddress[msg.sender];
84             shareHolderByNumber[shareHolderByAddress[_to]] = _to;
85         } else if(isHolder[_to] == false && balanceOf[msg.sender] == _value) {
86             isHolder[msg.sender] = false;
87             isHolder[_to] = true;
88             shareHolderByAddress[_to] = shareHolderByAddress[msg.sender];
89             shareHolderByNumber[shareHolderByAddress[_to]] = _to;
90         } else if(isHolder[_to] == false) {
91             isHolder[_to] = true;
92             amountOfHolders = amountOfHolders + 1;
93             shareHolderByAddress[_to] = amountOfHolders;
94             shareHolderByNumber[amountOfHolders] = _to;
95         }
96         balanceOf[msg.sender] -= _value;
97         balanceOf[_to] += _value;
98         Transfer(msg.sender, _to, _value);
99     }
100 
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
102         returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         tokenRecipient spender = tokenRecipient(_spender);
105         spender.receiveApproval(msg.sender, _value, this, _extraData);
106         return true;
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         if (balanceOf[_from] < _value) throw;
111         if (_value == 0) throw;
112         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
113         if (_value > allowance[_from][msg.sender]) throw;
114         if(isHolder[_to] && balanceOf[_from] == _value) {
115             isHolder[_from] = false;
116             shareHolderByAddress[_to] = shareHolderByAddress[_from];
117             shareHolderByNumber[shareHolderByAddress[_to]] = _to;
118         } else if(isHolder[_to] == false && balanceOf[_from] == _value) {
119             isHolder[_from] = false;
120             isHolder[_to] = true;
121             shareHolderByAddress[_to] = shareHolderByAddress[_from];
122             shareHolderByNumber[shareHolderByAddress[_to]] = _to;
123         } else if(isHolder[_to] == false) {
124             isHolder[_to] = true;
125             amountOfHolders = amountOfHolders + 1;
126             shareHolderByAddress[_to] = amountOfHolders;
127             shareHolderByNumber[amountOfHolders] = _to;
128         }
129         balanceOf[_from] -= _value;
130         balanceOf[_to] += _value;
131         allowance[_from][msg.sender] -= _value;
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     function DTE() {
137         balanceOf[msg.sender] = 100000000000000000000;
138         amountOfHolders = amountOfHolders + 1;
139         shareHolderByNumber[amountOfHolders] = msg.sender;
140         shareHolderByAddress[msg.sender] = amountOfHolders;
141         isHolder[msg.sender] = true;
142         totalSupply = 100000000000000000000;
143         name = "DTE Shares";
144         symbol = "%";
145         decimals = 18;
146         tokensAddress[++totalTokens] = MyToken(this);
147         tokenNoByAddress[address(this)] = totalTokens;
148     }
149 
150     function DistributeDividends(uint token) {
151         if((collectedFees[token] / 100000000000000000000) < 1) throw;
152         for(uint i = 1; i < amountOfHolders+1; i++) {
153             if(shareHolderByNumber[i] == address(this)) {
154                 collectedFees[token] += (collectedFees[token] * balanceOf[shareHolderByNumber[i]]) / 100000000000000000000;
155             } else {
156                 claimableFeesOf[shareHolderByNumber[i]][token] += (collectedFees[token] * balanceOf[shareHolderByNumber[i]]) / 100000000000000000000;
157             }
158         }
159         DividendDistribution(token, collectedFees[token]);
160         collectedFees[token] = 0;
161     }
162 
163     function claimDividendShare(uint tokenNo) {
164         if(tokenNo == 0) {
165             msg.sender.send(claimableFeesOf[msg.sender][0]);
166             claimableFeesOf[msg.sender][0] = 0;
167         } else if(tokenNo != 0){
168             var token = MyToken(tokensAddress[tokenNo]);
169             token.transfer(msg.sender, claimableFeesOf[msg.sender][tokenNo]);
170             claimableFeesOf[msg.sender][0] = 0;
171         }
172     }
173 
174     function () {
175         if(msg.value > 0) collectedFees[0] += msg.value;
176     }
177 
178     function addToken(address tokenContractAddress) {
179         if(msg.value < 100 finney) throw;
180         if(tokenNoByAddress[tokenContractAddress] != 0) throw;
181         msg.sender.send(msg.value - 100 finney);
182         collectedFees[0] += 100 finney;
183         tokensAddress[++totalTokens] = MyToken(tokenContractAddress);
184         tokenNoByAddress[tokenContractAddress] = totalTokens;
185         TokenAdd(totalTokens, tokenContractAddress);
186     }
187 
188     function cancelOrder(bool isSellOrder, uint orderNo) {
189         if(isSellOrder) {
190             if(sellOrders[orderNo].seller != msg.sender) throw;
191             sellOrders[orderNo].isOpen = false;
192             tokensAddress[sellOrders[orderNo].soldTokenNo].transfer(msg.sender, sellOrders[orderNo].soldAmount);
193         } else {
194             if(buyOrders[orderNo].buyer != msg.sender) throw;
195             buyOrders[orderNo].isOpen = false;
196             if(buyOrders[orderNo].soldTokenNo == 0) {
197                 msg.sender.send(buyOrders[orderNo].soldAmount);
198             } else {
199                 tokensAddress[buyOrders[orderNo].soldTokenNo].transfer(msg.sender, buyOrders[orderNo].soldAmount);
200             }
201         }
202     }
203 
204     function takeOrder(bool isSellOrder, uint orderNo, uint256 amount) {
205         if(isSellOrder) {
206             if(sellOrders[orderNo].isOpen == false) throw;
207             var sorder = sellOrders[orderNo];
208             uint wantedToken = sorder.boughtTokenNo;
209             uint soldToken = sorder.soldTokenNo;
210             uint256 soldAmount = sorder.soldAmount;
211             uint256 wantedAmount = sorder.boughtAmount;
212             if(wantedToken == 0) {
213                 if(msg.value > (amount + (amount / 100)) || msg.value < amount || msg.value < (amount + (amount / 100)) || amount > wantedAmount) throw;
214                 if(amount == wantedAmount) {
215                     sorder.isTaken = true;
216                     sorder.isOpen = false;
217                     sorder.seller.send(amount);
218                     collectedFees[0] += amount / 100;
219                     tokensAddress[soldToken].transfer(msg.sender, sorder.soldAmount);
220                 } else {
221                     uint256 transferAmount = uint256((int(amount) * int(sorder.soldAmount)) / int(sorder.boughtAmount));
222                     sorder.soldAmount -= transferAmount;
223                     sorder.boughtAmount -= amount;
224                     sorder.seller.send(amount);
225                     collectedFees[0] += amount / 100;
226                     tokensAddress[soldToken].transfer(msg.sender, transferAmount);
227                 }
228             } else {
229                 if(msg.value > 0) throw;
230                 uint256 allowance = tokensAddress[wantedToken].allowance(msg.sender, this);
231                 if(allowance > (amount + (amount / 100)) || allowance < amount || allowance < (amount + (amount / 100)) || amount > wantedAmount) throw;
232                 if(amount == wantedAmount) {
233                     sorder.isTaken = true;
234                     sorder.isOpen = false;
235                     tokensAddress[wantedToken].transferFrom(msg.sender, sorder.seller, amount);
236                     tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
237                     collectedFees[wantedToken] += amount / 100;
238                     tokensAddress[soldToken].transfer(msg.sender, sorder.soldAmount);
239                 } else {
240                     transferAmount = uint256((int(amount) * int(sorder.soldAmount)) / int(sorder.boughtAmount));
241                     sorder.soldAmount -= transferAmount;
242                     sorder.boughtAmount -= amount;
243                     tokensAddress[wantedToken].transferFrom(msg.sender, sorder.seller, amount);
244                     tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
245                     collectedFees[wantedToken] += amount / 100;
246                     tokensAddress[soldToken].transfer(msg.sender, transferAmount);
247                 }
248             }
249         } else {
250             if(buyOrders[orderNo].isOpen == false) throw;
251             var border = buyOrders[orderNo];
252             wantedToken = border.boughtTokenNo;
253             soldToken = border.soldTokenNo;
254             soldAmount = border.soldAmount;
255             wantedAmount = border.boughtAmount;
256             if(wantedToken == 0) {
257                 if(msg.value > (amount + (amount / 100)) || msg.value < amount || msg.value < (amount + (amount / 100)) || amount > wantedAmount) throw;
258                 if(amount == wantedAmount) {
259                     border.isTaken = true;
260                     border.isOpen = false;
261                     border.buyer.send(amount);
262                     collectedFees[0] += amount / 100;
263                     tokensAddress[soldToken].transfer(msg.sender, border.soldAmount);
264                 } else {
265                     transferAmount = uint256((int(amount) * int(border.soldAmount)) / int(border.boughtAmount));
266                     border.soldAmount -= transferAmount;
267                     border.boughtAmount -= amount;
268                     border.buyer.send(amount);
269                     collectedFees[0] += amount / 100;
270                     tokensAddress[soldToken].transfer(msg.sender, transferAmount);
271                 }
272             } else {
273                 if(msg.value > 0) throw;
274                 allowance = tokensAddress[wantedToken].allowance(msg.sender, this);
275                 if(allowance > (amount + (amount / 100)) || allowance < amount || allowance < (amount + (amount / 100)) || amount > wantedAmount) throw;
276                 if(amount == wantedAmount) {
277                     border.isTaken = true;
278                     border.isOpen = false;
279                     tokensAddress[wantedToken].transferFrom(msg.sender, border.buyer, amount);
280                     tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
281                     collectedFees[wantedToken] += amount / 100;
282                     tokensAddress[soldToken].transfer(msg.sender, border.soldAmount);
283                 } else {
284                     transferAmount = uint256((int(amount) * int(border.soldAmount)) / int(border.boughtAmount));
285                     border.soldAmount -= transferAmount;
286                     border.boughtAmount -= amount;
287                     tokensAddress[wantedToken].transferFrom(msg.sender, border.buyer, amount);
288                     tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
289                     collectedFees[wantedToken] += amount / 100;
290                     tokensAddress[soldToken].transfer(msg.sender, transferAmount);
291                 }
292             }
293         }
294     }
295 
296     function newOrder(bool isSellOrder,
297                       uint soldTokenNo,
298                       uint boughtTokenNo,
299                       uint256 soldAmount,
300                       uint256 boughtAmount
301                       ) {
302         if(soldTokenNo == boughtTokenNo) throw;
303         if(isSellOrder) {
304             if(soldTokenNo == 0) throw;
305             MyToken token = tokensAddress[soldTokenNo];
306             uint256 allowance = token.allowance(msg.sender, this);
307             if(soldTokenNo > totalTokens || allowance < soldAmount) throw;
308             token.transferFrom(msg.sender, this, soldAmount);
309             sellOrders[++totalSellOrders] = sellOrder({
310                 isOpen: true,
311                 isTaken: false,
312                 seller: msg.sender,
313                 soldTokenNo: soldTokenNo,
314                 boughtTokenNo: boughtTokenNo,
315                 soldAmount: soldAmount,
316                 boughtAmount: boughtAmount
317             });
318             SellOrdersOf[msg.sender][++totalSellOrdersOf[msg.sender]] = totalSellOrders;
319             SellOrder(totalSellOrders, msg.sender, soldTokenNo, soldAmount, boughtTokenNo, boughtAmount);
320         } else {
321             if(soldTokenNo == 0)  {
322                 if(msg.value > soldAmount) throw;
323                 allowance = msg.value;
324             } else if(soldTokenNo > totalTokens) {
325                 throw;
326             } else {
327                 token = tokensAddress[soldTokenNo];
328                 allowance = token.allowance(msg.sender, this);
329                 if(soldAmount < allowance) throw;
330                 token.transferFrom(msg.sender, this, soldAmount);
331             }
332             buyOrders[++totalBuyOrders] = buyOrder({
333                 isOpen: true,
334                 isTaken: false,
335                 buyer: msg.sender,
336                 soldTokenNo: soldTokenNo,
337                 boughtTokenNo: boughtTokenNo,
338                 soldAmount: soldAmount,
339                 boughtAmount: boughtAmount
340             });
341             BuyOrdersOf[msg.sender][++totalBuyOrdersOf[msg.sender]] = totalBuyOrders;
342             BuyOrder(totalSellOrders, msg.sender, soldTokenNo, soldAmount, boughtTokenNo, boughtAmount);
343         }
344     }
345 }