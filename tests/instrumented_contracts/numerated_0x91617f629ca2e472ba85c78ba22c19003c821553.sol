1 pragma solidity 0.5.7;
2 
3 
4 /**
5  * @title Data Exchange Marketplace
6  * @notice This contract allows Notaries to register themselves and buyers to
7  *         publish data orders, acording to the Wibson Protocol.
8  *         For more information: https://wibson.org
9  */
10 contract DataExchange {
11   event NotaryRegistered(address indexed notary, string notaryUrl);
12   event NotaryUpdated(address indexed notary, string oldNotaryUrl, string newNotaryUrl);
13   event NotaryUnregistered(address indexed notary, string oldNotaryUrl);
14   event DataOrderCreated(uint256 indexed orderId, address indexed buyer);
15   event DataOrderClosed(uint256 indexed orderId, address indexed buyer);
16 
17   struct DataOrder {
18     address buyer;
19     string audience;
20     uint256 price;
21     string requestedData;
22     bytes32 termsAndConditionsHash;
23     string buyerUrl;
24     uint32 createdAt;
25     uint32 closedAt;
26   }
27 
28   DataOrder[] internal dataOrders;
29   mapping(address => string) internal notaryUrls;
30 
31   /**
32    * @notice Registers sender as a notary.
33    * @param notaryUrl Public URL of the notary where the notary info can be obtained.
34    *                  This URL should serve a JSON signed by the sender to prove
35    *                  authenticity. It is highly recommended to check the signature
36    *                  with the sender's address before using the notary's services.
37    * @return true if the notary was successfully registered, reverts otherwise.
38    */
39   function registerNotary(string calldata notaryUrl) external returns (bool) {
40     require(_isNotEmpty(notaryUrl), "notaryUrl must not be empty");
41     require(!_isSenderNotary(), "Notary already registered (use updateNotaryUrl to update)");
42     notaryUrls[msg.sender] = notaryUrl;
43     emit NotaryRegistered(msg.sender, notaryUrl);
44     return true;
45   }
46 
47   /**
48    * @notice Updates notary public URL of sender.
49    * @param newNotaryUrl Public URL of the notary where the notary info can be obtained.
50    *                     This URL should serve a JSON signed by the sender to prove
51    *                     authenticity. It is highly recommended to check the signature
52    *                     with the sender's address before using the notary's services.
53    * @return true if the notary public URL was successfully updated, reverts otherwise.
54    */
55   function updateNotaryUrl(string calldata newNotaryUrl) external returns (bool) {
56     require(_isNotEmpty(newNotaryUrl), "notaryUrl must not be empty");
57     require(_isSenderNotary(), "Notary not registered");
58     string memory oldNotaryUrl = notaryUrls[msg.sender];
59     notaryUrls[msg.sender] = newNotaryUrl;
60     emit NotaryUpdated(msg.sender, oldNotaryUrl, newNotaryUrl);
61     return true;
62   }
63 
64   /**
65    * @notice Unregisters sender as notary. Once unregistered, the notary does not
66    *         have any obligation to maintain the old public URL.
67    * @return true if the notary was successfully unregistered, reverts otherwise.
68    */
69   function unregisterNotary() external returns (bool) {
70     require(_isSenderNotary(), "sender must be registered");
71     string memory oldNotaryUrl = notaryUrls[msg.sender];
72     delete notaryUrls[msg.sender];
73     emit NotaryUnregistered(msg.sender, oldNotaryUrl);
74     return true;
75   }
76 
77   /**
78    * @notice Creates a DataOrder.
79    * @dev The `msg.sender` will become the buyer of the order.
80    * @param audience Target audience of the order.
81    * @param price Price that sellers will receive in exchange of their data.
82    * @param requestedData Requested data type (Geolocation, Facebook, etc).
83    * @param termsAndConditionsHash Hash of the Buyer's terms and conditions for the order.
84    * @param buyerUrl Public URL of the buyer where more information about the DataOrder
85    *        can be obtained.
86    * @return The index of the newly created DataOrder. If the DataOrder could
87    *         not be created, reverts.
88    */
89   function createDataOrder(
90     string calldata audience,
91     uint256 price,
92     string calldata requestedData,
93     bytes32 termsAndConditionsHash,
94     string calldata buyerUrl
95   ) external returns (uint256) {
96     require(_isNotEmpty(audience), "audience must not be empty");
97     require(price > 0, "price must be greater than zero");
98     require(_isNotEmpty(requestedData), "requestedData must not be empty");
99     require(termsAndConditionsHash != 0, "termsAndConditionsHash must not be empty");
100     require(_isNotEmpty(buyerUrl), "buyerUrl must not be empty");
101 
102     uint256 orderId = dataOrders.length;
103     dataOrders.push(DataOrder(
104       msg.sender,
105       audience,
106       price,
107       requestedData,
108       termsAndConditionsHash,
109       buyerUrl,
110       uint32(now),
111       uint32(0)
112     ));
113 
114     emit DataOrderCreated(orderId, msg.sender);
115     return orderId;
116   }
117 
118   /**
119    * @notice Closes the DataOrder.
120    * @dev The `msg.sender` must be the buyer of the order.
121    * @param orderId Index of the order to close.
122    * @return true if the DataOrder was successfully closed, reverts otherwise.
123    */
124   function closeDataOrder(uint256 orderId) external returns (bool) {
125     require(orderId < dataOrders.length, "invalid order index");
126     DataOrder storage dataOrder = dataOrders[orderId];
127     require(dataOrder.buyer == msg.sender, "sender can't close the order");
128     require(dataOrder.closedAt == 0, "order already closed");
129     dataOrder.closedAt = uint32(now);
130 
131     emit DataOrderClosed(orderId, msg.sender);
132     return true;
133   }
134 
135   function getNotaryUrl(address notaryAddress) external view returns (string memory) {
136     return notaryUrls[notaryAddress];
137   }
138 
139   function getDataOrder(uint256 orderId) external view returns (
140     address,
141     string memory,
142     uint256,
143     string memory,
144     bytes32,
145     string memory,
146     uint32,
147     uint32
148   ) {
149     DataOrder storage dataOrder = dataOrders[orderId];
150     return (
151       dataOrder.buyer,
152       dataOrder.audience,
153       dataOrder.price,
154       dataOrder.requestedData,
155       dataOrder.termsAndConditionsHash,
156       dataOrder.buyerUrl,
157       dataOrder.createdAt,
158       dataOrder.closedAt
159     );
160   }
161 
162   function getDataOrdersLength() external view returns (uint) {
163     return dataOrders.length;
164   }
165 
166   function _isSenderNotary() private view returns (bool) {
167     return _isNotEmpty(notaryUrls[msg.sender]);
168   }
169 
170   function _isNotEmpty(string memory s) private pure returns (bool) {
171     return bytes(s).length > 0;
172   }
173 }