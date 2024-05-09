1 pragma solidity ^0.4.11;
2 
3 contract Factory {
4   address developer = 0x007C67F0CDBea74592240d492Aef2a712DAFa094c3;
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
52   Item public item;
53   address public seller = address(0);
54   address public broker = address(0);
55   uint    public brokerFee;
56   // Minimum 0.1 Finney (0.0001 eth ~ 25Cent) to 0.01% of the price.
57   uint    public developerfee = 0.1 finney;
58   uint    minimumdeveloperfee = 0.1 finney;
59   address developer = 0x007C67F0CDBea74592240d492Aef2a712DAFa094c3;
60   // bool public validated;
61   address creator = 0x0;
62   address factory = 0x0;
63   
64   bool bBrokerRequired = true;
65   address[] public buyers;
66 
67 
68   modifier onlySeller() {
69     require(msg.sender == seller);
70     _;
71   }
72 
73   modifier onlyCreator() {
74     require(msg.sender == creator);
75     _;
76   }
77 
78   modifier onlyBroker() {
79     require(msg.sender == broker);
80     _;
81   }
82 
83   modifier inState(State _state) {
84       require(state == _state);
85       _;
86   }
87 
88   modifier condition(bool _condition) {
89       require(_condition);
90       _;
91   }
92 
93   event AbortedBySeller();
94   event AbortedByBroker();
95   event PurchaseConfirmed(address buyer);
96   event ItemReceived();
97   event Validated();
98   event ItemInfoChanged(string name, uint price, string detail, uint developerfee);
99   event SellerChanged(address seller);
100   event BrokerChanged(address broker);
101   event BrokerFeeChanged(uint fee);
102 
103   // The constructor
104   constructor(bool isbroker, address _dev, address _creator, bool _brokerrequired) 
105     public 
106   {
107     bBrokerRequired = _brokerrequired;
108     if(creator==address(0)){
109       //storedData = initialValue;
110       if(isbroker)
111         broker = _creator;
112       else
113         seller = _creator;
114       creator = _creator;
115       // value = msg.value / 2;
116       // require((2 * value) == msg.value);
117       state = State.Created;
118 
119       // validated = false;
120       brokerFee = 50;
121     }
122     if(developer==address(0) || developer==msg.sender){
123        developer = _dev;
124     }
125     if(factory==address(0)){
126        factory = msg.sender;
127     }
128   }
129 
130   function joinAsBroker() public {
131     if(broker==address(0)){
132       broker = msg.sender;
133     }
134   }
135 
136   function createOrSet(string name, uint price, string detail)
137     public 
138     inState(State.Created)
139     onlyCreator
140   {
141     require(price > minimumdeveloperfee);
142     item.name = name;
143     item.price = price;
144     item.detail = detail;
145     developerfee = (price/1000)<minimumdeveloperfee ? minimumdeveloperfee : (price/1000);
146     emit ItemInfoChanged(name, price, detail, developerfee);
147   }
148 
149   function getBroker()
150     public 
151     constant returns(address, uint)
152   {
153     return (broker, brokerFee);
154   }
155 
156   function getSeller()
157     public 
158     constant returns(address)
159   {
160     return (seller);
161   }
162   
163   function getBuyers()
164     public 
165     constant returns(address[])
166   {
167     return (buyers);
168   }
169 
170   function setBroker(address _address)
171     public 
172     onlySeller
173     inState(State.Created)
174   {
175     broker = _address;
176     emit BrokerChanged(broker);
177   }
178 
179   function setBrokerFee(uint fee)
180     public 
181     onlyCreator
182     inState(State.Created)
183   {
184     brokerFee = fee;
185     emit BrokerFeeChanged(fee);
186   }
187 
188   function setSeller(address _address)
189     public 
190     onlyBroker
191     inState(State.Created)
192   {
193     seller = _address;
194     emit SellerChanged(seller);
195   }
196 
197   // We will have some 'peculiar' list of documents
198   // for each deals. 
199   // For ex, for House we will require
200   // proof of documents about the basic information of the House,
201   // and some insurance information.
202   // So we can make a template for each differene kind of deals.
203   // Deals for a house, deals for a Car, etc.
204   function addDocument(bytes32 _purpose, string _name, string _ipfshash)
205     public 
206   {
207     require(state != State.Finished);
208     require(state != State.Locked);
209     item.documents.push( File({
210       purpose:_purpose, name:_name, ipfshash:_ipfshash, state:FileState.Created}
211       ) 
212     );
213   }
214 
215   // deleting actual file on the IPFS network is very hard.
216   function deleteDocument(uint index)
217     public 
218   {
219     require(state != State.Finished);
220     require(state != State.Locked);
221     if(index<item.documents.length){
222       item.documents[index].state = FileState.Invalidated;
223     }
224   }
225 
226   function validate()
227     public 
228     onlyBroker
229     inState(State.Created)
230   {
231     // if(index<item.documents.length){
232     //   item.documents[index].state = FileState.Confirmed;
233     // }
234     emit Validated();
235     // validated = true;
236     state = State.Validated;
237   }
238 
239   /// Abort the purchase and reclaim the ether.
240   /// Can only be called by the seller before
241   /// the contract is locked.
242   function abort()
243     public 
244     onlySeller
245     inState(State.Created)
246   {
247       emit AbortedBySeller();
248       state = State.Finished;
249       // validated = false;
250       seller.transfer(address(this).balance);
251   }
252 
253   function abortByBroker()
254     public 
255     onlyBroker
256   {
257       if(!bBrokerRequired)
258         return;
259         
260       require(state != State.Finished);
261       state = State.Finished;
262       emit AbortedByBroker();
263       
264       if(buyers.length>0){
265           uint val = address(this).balance / buyers.length;
266           for (uint256 x = 0; x < buyers.length; x++) {
267               buyers[x].transfer(val);
268           }
269       }
270   }
271 
272   /// Confirm the purchase as buyer.
273   /// The ether will be locked until confirmReceived
274   /// is called.
275   function confirmPurchase()
276     public 
277     condition(msg.value == item.price)
278     payable
279   {
280       if(bBrokerRequired){
281         if(state != State.Validated){
282           return;
283         }
284       }
285       
286       state = State.Locked;
287       buyers.push(msg.sender);
288       emit PurchaseConfirmed(msg.sender);
289       
290       if(!bBrokerRequired){
291 		// send money right away
292         seller.transfer(item.price-developerfee);
293         developer.transfer(developerfee);
294       }
295   }
296 
297   /// Confirm that you (the buyer) received the item.
298   /// This will release the locked ether.
299   function confirmReceived()
300     public 
301     onlyBroker
302     inState(State.Locked)
303   {
304       // It is important to change the state first because
305       // otherwise, the contracts called using `send` below
306       // can call in again here.
307       state = State.Finished;
308 
309       // NOTE: This actually allows both the buyer and the seller to
310       // block the refund - the withdraw pattern should be used.
311       seller.transfer(address(this).balance-brokerFee-developerfee);
312       broker.transfer(brokerFee);
313       developer.transfer(developerfee);
314 
315       emit ItemReceived();
316   }
317 
318   function getInfo() constant 
319     public 
320     returns (State, string, uint, string, uint, uint, address, address, bool)
321   {
322     return (state, item.name, item.price, item.detail, item.documents.length, 
323         developerfee, seller, broker, bBrokerRequired);
324   }
325 
326   function getFileAt(uint index) 
327     public 
328     constant returns(uint, bytes32, string, string, FileState)
329   {
330     return (index,
331       item.documents[index].purpose,
332       item.documents[index].name,
333       item.documents[index].ipfshash,
334       item.documents[index].state);
335   }
336 }