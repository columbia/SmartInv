1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   // state variables
31   address owner;
32 
33   // modifiers
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   // constructor
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44   /**
45      * @dev Allows the current owner to transfer control of the contract to a newOwner.
46      * @param newOwner The address to transfer ownership to.
47      */
48   function transferOwnership(address newOwner) onlyOwner {
49     owner = newOwner;
50   }
51 
52 }
53 
54 contract Transaction is Ownable {
55   // custom types
56   struct TransactionNeoPlace {
57     uint id;
58     address seller;
59     address buyer;
60     bytes16 itemId;
61     bytes8 typeItem;
62     string location;
63     string pictureHash;
64     bytes16 receiptHash;
65     string comment;
66     bytes8 status;
67     uint256 _price;
68   }
69 
70   // state variables
71   mapping(uint => TransactionNeoPlace) public transactions;
72   mapping(bytes16 => uint256) public fundsLocked;
73 
74   uint transactionCounter;
75 
76   // events
77   event BuyItem(
78     uint indexed _id,
79     bytes16 indexed _itemId,
80     address _seller,
81     address _buyer,
82     uint256 _price
83   );
84 
85   function kill() public onlyOwner {
86     selfdestruct(owner);
87   }
88 
89   // fetch the number of transactions in the contract
90   function getNumberOfTransactions() public view returns (uint) {
91     return transactionCounter;
92   }
93 
94   // fetch and return all sales of the seller
95   function getSales() public view returns (uint[]) {
96     // prepare output array
97     uint[] memory transactionIds = new uint[](transactionCounter);
98 
99     uint numberOfSales = 0;
100 
101     // iterate over transactions
102     for(uint i = 1; i <= transactionCounter; i++) {
103       // keep the ID if the transaction owns to the seller
104       if(transactions[i].seller == msg.sender) {
105         transactionIds[numberOfSales] = transactions[i].id;
106         numberOfSales++;
107       }
108     }
109 
110     // copy the transactionIds array into a smaller getSales array
111     uint[] memory sales = new uint[](numberOfSales);
112     for(uint j = 0; j < numberOfSales; j++) {
113       sales[j] = transactionIds[j];
114     }
115     return sales;
116   }
117 
118   // fetch and return all purchases of the buyer
119   function getPurchases() public view returns (uint[]) {
120     // prepare output array
121     uint[] memory transactionIds = new uint[](transactionCounter);
122 
123     uint numberOfBuy = 0;
124 
125     // iterate over transactions
126     for(uint i = 1; i <= transactionCounter; i++) {
127       // keep the ID if the transaction owns to the seller
128       if(transactions[i].buyer == msg.sender) {
129         transactionIds[numberOfBuy] = transactions[i].id;
130         numberOfBuy++;
131       }
132     }
133 
134     // copy the transactionIds array into a smaller getBuy array
135     uint[] memory buy = new uint[](numberOfBuy);
136     for(uint j = 0; j < numberOfBuy; j++) {
137       buy[j] = transactionIds[j];
138     }
139     return buy;
140   }
141 
142   // new transaction / buy item
143   function buyItem(address _seller, bytes16 _itemId, bytes8 _typeItem, string _location, string _pictureHash, string _comment, bytes8 _status, uint256 _price) payable public {
144     // address not null
145     require(_seller != 0x0);
146     // seller don't allow to buy his own item
147     require(msg.sender != _seller);
148 
149     require(_itemId.length > 0);
150     require(_typeItem.length > 0);
151     require(bytes(_location).length > 0);
152     require(bytes(_pictureHash).length > 0);
153     //require(bytes(_comment).length > 0);
154 
155     require(msg.value == _price);
156 
157 
158     // lock and put the funds in escrow
159     //_seller.transfer(msg.value);
160     fundsLocked[_itemId]=fundsLocked[_itemId] + _price;
161 
162     // new transaction
163     transactionCounter++;
164 
165     // store the new transaction
166     transactions[transactionCounter] = TransactionNeoPlace(
167       transactionCounter,
168       _seller,
169       msg.sender,
170       _itemId,
171       _typeItem,
172       _location,
173       _pictureHash,
174       "",
175       _comment,
176       _status,
177       _price
178     );
179 
180     // trigger the new transaction
181     BuyItem(transactionCounter, _itemId, _seller, msg.sender, _price);
182   }
183 
184   // send additional funds
185   //TODO merge with unlockFunds
186   function sendAdditionalFunds(address _seller, bytes16 _itemId, uint256 _price) payable public {
187     // address not null
188     require(_seller != 0x0);
189     // seller don't allow to buy his own item
190     require(msg.sender != _seller);
191 
192     require(_itemId.length > 0);
193 
194     require(msg.value == _price);
195 
196     for(uint i = 0; i <= transactionCounter; i++) {
197       if(transactions[i].itemId == _itemId) {
198 
199         require(msg.sender == transactions[i].buyer);
200         require(stringToBytes8("paid") == transactions[i].status);
201         address seller = transactions[i].seller;
202         transactions[i]._price = transactions[i]._price + msg.value;
203 
204         //transfer fund from client to vendor
205         seller.transfer(msg.value);
206 
207         break;
208       }
209     }
210   }
211 
212   function unlockFunds(bytes16 _itemId) public {
213 
214     for(uint i = 0; i <= transactionCounter; i++) {
215       if(transactions[i].itemId == _itemId) {
216 
217         require(msg.sender == transactions[i].buyer);
218         require(stringToBytes8("paid") != transactions[i].status);
219         address buyer = transactions[i].buyer;
220         address seller = transactions[i].seller;
221         uint256 priceTransaction = transactions[i]._price;
222 
223         require(fundsLocked[_itemId]>0);
224         fundsLocked[_itemId]=fundsLocked[_itemId] - (priceTransaction);
225 
226         //transfer fund from client to vendor
227         seller.transfer(priceTransaction);
228 
229         transactions[i].status = stringToBytes8('paid');
230 
231         break;
232       }
233     }
234   }
235 
236    function sendAmount(address seller) payable public {
237       // address not null
238       require(seller != 0x0);
239       // seller don't allow to buy his own item
240       require(msg.sender != seller);
241 
242       seller.transfer(msg.value);
243    }
244 
245   function stringToBytes8(string memory source) returns (bytes8 result) {
246     bytes memory tempEmptyStringTest = bytes(source);
247     if (tempEmptyStringTest.length == 0) {
248       return 0x0;
249     }
250 
251     assembly {
252       result := mload(add(source, 8))
253     }
254   }
255 
256 }