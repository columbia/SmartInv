1 pragma solidity ^0.4.24;
2 
3 contract Factory {
4   address developer = 0x0033F8dAcBc75F53549298100E85102be995CdBF59;
5 
6   event ContractCreated(address creator, address newcontract, uint timestamp, string contract_type);
7     
8   function setDeveloper (address _dev) public {
9     if(developer==address(0) || developer==msg.sender){
10        developer = _dev;
11     }
12   }
13   
14   function createContract (bool isbroker, string contract_type, bool _brokerrequired) 
15   public {
16     address newContract = new Broker(isbroker, developer, msg.sender, _brokerrequired);
17     emit ContractCreated(msg.sender, newContract, block.timestamp, contract_type);
18   } 
19 }
20 
21 contract Broker {
22   enum State { Created, Validated, Locked, Finished }
23   State public state;
24 
25   enum FileState { 
26     Created, 
27     Invalidated
28     // , Confirmed 
29   }
30 
31   struct File{
32     // The purpose of this file. Like, picture, license info., etc.
33     // to save the space, we better use short name.
34     // Dapps should match proper long name for this.
35     bytes32 purpose;
36     // name of the file
37     string name;
38     // ipfs id for this file
39     string ipfshash;
40     FileState state;
41   }
42 
43   struct Item{
44     string name;
45     // At least 0.1 Finney, because it's the fee to the developer
46     uint   price;
47     // this could be a link to an Web page explaining about this item
48     string detail;
49     File[] documents;
50   }
51   
52   struct BuyInfo{
53     address buyer;
54     bool completed;
55   }
56 
57   Item public item;
58   address public seller = address(0);
59   address public broker = address(0);
60   uint    public brokerFee;
61   // Minimum 0.1 Finney (0.0001 eth ~ 25Cent) to 0.01% of the price.
62   uint    public developerfee = 0.1 finney;
63   uint    minimumdeveloperfee = 0.1 finney;
64   address developer = 0x0033F8dAcBc75F53549298100E85102be995CdBF59;
65   // bool public validated;
66   address creator = 0x0;
67   address factory = 0x0;
68   
69   bool bBrokerRequired = true;
70   BuyInfo[] public buyinfo;
71 
72 
73   modifier onlySeller() {
74     require(msg.sender == seller);
75     _;
76   }
77 
78   modifier onlyCreator() {
79     require(msg.sender == creator);
80     _;
81   }
82 
83   modifier onlyBroker() {
84     require(msg.sender == broker);
85     _;
86   }
87 
88   modifier inState(State _state) {
89       require(state == _state);
90       _;
91   }
92 
93   modifier condition(bool _condition) {
94       require(_condition);
95       _;
96   }
97 
98   event AbortedBySeller();
99   event AbortedByBroker();
100   event PurchaseConfirmed(address buyer);
101   event ItemReceived();
102   event IndividualItemReceived(address buyer);
103   event Validated();
104   event ItemInfoChanged(string name, uint price, string detail, uint developerfee);
105   event SellerChanged(address seller);
106   event BrokerChanged(address broker);
107   event BrokerFeeChanged(uint fee);
108 
109   // The constructor
110   constructor(bool isbroker, address _dev, address _creator, bool _brokerrequired) 
111     public 
112   {
113     bBrokerRequired = _brokerrequired;
114     if(creator==address(0)){
115       //storedData = initialValue;
116       if(isbroker)
117         broker = _creator;
118       else
119         seller = _creator;
120       creator = _creator;
121       // value = msg.value / 2;
122       // require((2 * value) == msg.value);
123       state = State.Created;
124 
125       // validated = false;
126       brokerFee = 50;
127     }
128     if(developer==address(0) || developer==msg.sender){
129        developer = _dev;
130     }
131     if(factory==address(0)){
132        factory = msg.sender;
133     }
134   }
135 
136   function joinAsBroker() public {
137     if(broker==address(0)){
138       broker = msg.sender;
139     }
140   }
141 
142   function createOrSet(string name, uint price, string detail)
143     public 
144     inState(State.Created)
145     onlyCreator
146   {
147     require(price > minimumdeveloperfee);
148     item.name = name;
149     item.price = price;
150     item.detail = detail;
151     developerfee = (price/1000)<minimumdeveloperfee ? minimumdeveloperfee : (price/1000);
152     emit ItemInfoChanged(name, price, detail, developerfee);
153   }
154 
155   function getBroker()
156     public 
157     constant returns(address, uint)
158   {
159     return (broker, brokerFee);
160   }
161 
162   function getSeller()
163     public 
164     constant returns(address)
165   {
166     return (seller);
167   }
168   
169   function getBuyers()
170     public 
171     constant returns(address[])
172   {
173     address[] memory buyers = new address[](buyinfo.length);
174     //uint val = address(this).balance / buyinfo.length;
175     for (uint256 x = 0; x < buyinfo.length; x++) {
176       buyers[x] = buyinfo[x].buyer;
177     }
178     return (buyers);
179   }
180   
181   function getBuyerInfoAt(uint256 x)
182     public 
183     constant returns(address, bool)
184   {
185     return (buyinfo[x].buyer, buyinfo[x].completed);
186   }
187 
188   function setBroker(address _address)
189     public 
190     onlySeller
191     inState(State.Created)
192   {
193     broker = _address;
194     emit BrokerChanged(broker);
195   }
196 
197   function setBrokerFee(uint fee)
198     public 
199     onlyCreator
200     inState(State.Created)
201   {
202     brokerFee = fee;
203     emit BrokerFeeChanged(fee);
204   }
205 
206   function setSeller(address _address)
207     public 
208     onlyBroker
209     inState(State.Created)
210   {
211     seller = _address;
212     emit SellerChanged(seller);
213   }
214 
215   // We will have some 'peculiar' list of documents
216   // for each deals. 
217   // For ex, for House we will require
218   // proof of documents about the basic information of the House,
219   // and some insurance information.
220   // So we can make a template for each differene kind of deals.
221   // Deals for a house, deals for a Car, etc.
222   function addDocument(bytes32 _purpose, string _name, string _ipfshash)
223     public 
224   {
225     require(state != State.Finished);
226     require(state != State.Locked);
227     item.documents.push( File({
228       purpose:_purpose, name:_name, ipfshash:_ipfshash, state:FileState.Created}
229       ) 
230     );
231   }
232 
233   // deleting actual file on the IPFS network is very hard.
234   function deleteDocument(uint index)
235     public 
236   {
237     require(state != State.Finished);
238     require(state != State.Locked);
239     if(index<item.documents.length){
240       item.documents[index].state = FileState.Invalidated;
241     }
242   }
243 
244   function validate()
245     public 
246     onlyBroker
247     inState(State.Created)
248   {
249     // if(index<item.documents.length){
250     //   item.documents[index].state = FileState.Confirmed;
251     // }
252     emit Validated();
253     // validated = true;
254     state = State.Validated;
255   }
256   
257   function returnMoneyToBuyers()
258     private
259   {
260       require(state != State.Finished);
261       if(buyinfo.length>0){
262           uint val = address(this).balance / buyinfo.length;
263           for (uint256 x = 0; x < buyinfo.length; x++) {
264               if(buyinfo[x].completed==false){
265                 buyinfo[x].buyer.transfer(val);
266               }
267           }
268       }
269       state = State.Finished;
270   }
271 
272   /// Abort the purchase and reclaim the ether.
273   /// Can only be called by the seller before
274   /// the contract is locked.
275   function abort()
276     public 
277     onlySeller
278   {
279     returnMoneyToBuyers();
280     emit AbortedBySeller();
281     // validated = false;
282     seller.transfer(address(this).balance);
283   }
284 
285   function abortByBroker()
286     public 
287     onlyBroker
288   {
289     if(!bBrokerRequired)
290       return;
291     returnMoneyToBuyers();
292     emit AbortedByBroker();
293   }
294 
295   /// Confirm the purchase as buyer.
296   /// The ether will be locked until confirmReceived
297   /// is called.
298   function confirmPurchase()
299     public 
300     condition(msg.value == item.price)
301     payable
302   {
303       if(bBrokerRequired){
304         if(state != State.Validated && state != State.Locked){
305           return;
306         }
307       }
308       
309       if(state == State.Finished){
310         return;
311       }
312       
313       state = State.Locked;
314       emit PurchaseConfirmed(msg.sender);
315       bool complete = false;
316       if(!bBrokerRequired){
317     // send money right away
318         complete = true;
319         seller.transfer(item.price-developerfee);
320         developer.transfer(developerfee);
321       }
322       buyinfo.push(BuyInfo(msg.sender, complete));
323   }
324 
325   /// Confirm that you (the buyer) received the item.
326   /// This will release the locked ether.
327   function confirmReceived()
328     public 
329     onlyBroker
330     inState(State.Locked)
331   {
332       if(buyinfo.length>0){
333           for (uint256 x = 0; x < buyinfo.length; x++) {
334               confirmReceivedAt(x);
335           }
336       }
337       
338       // It is important to change the state first because
339       // otherwise, the contracts called using `send` below
340       // can call in again here.
341       state = State.Finished;
342   }
343   
344   //
345   function confirmReceivedAt(uint index)
346     public 
347     onlyBroker
348     inState(State.Locked)
349   {
350       // In this case the broker is confirming one by one,
351       // the other purchase should go on. So we don't change the status.
352       if(index>=buyinfo.length)
353         return;
354       if(buyinfo[index].completed)
355         return;
356 
357       // NOTE: This actually allows both the buyer and the seller to
358       // block the refund - the withdraw pattern should be used.
359       seller.transfer(item.price-brokerFee-developerfee);
360       broker.transfer(brokerFee);
361       developer.transfer(developerfee);
362       
363       buyinfo[index].completed = true;
364 
365       emit IndividualItemReceived(buyinfo[index].buyer);
366   }
367 
368   function getInfo() constant 
369     public 
370     returns (State, string, uint, string, uint, uint, address, address, bool)
371   {
372     return (state, item.name, item.price, item.detail, item.documents.length, 
373         developerfee, seller, broker, bBrokerRequired);
374   }
375   
376   function getBalance() constant
377     public
378     returns (uint256)
379   {
380     return address(this).balance;
381   }
382 
383   function getFileAt(uint index) 
384     public 
385     constant returns(uint, bytes32, string, string, FileState)
386   {
387     return (index,
388       item.documents[index].purpose,
389       item.documents[index].name,
390       item.documents[index].ipfshash,
391       item.documents[index].state);
392   }
393 }