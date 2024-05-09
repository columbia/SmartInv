1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers, truncating the quotient.
83   */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90 
91   /**
92   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
93   */
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   /**
100   * @dev Adds two numbers, throws on overflow.
101   */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 
110 contract EternalStorageInterface {
111     function getShipById(uint256 _shipId) public view returns(uint256, string, uint256, uint256, uint256);
112     function buyItem(uint256 _itemId, address _newOwner, string _itemTitle, string _itemTypeTitle, string _itemIdTitle) public returns(uint256);
113     function getItemPriceById(string _itemType, uint256 _itemId) public view returns(uint256);
114     function getNumberOfItemsByTypeAndOwner(string _itemType, address _owner) public view returns(uint256);
115     function getItemsByTypeAndOwner(string _itemTypeTitle, address _owner) public view returns(uint256[]);
116     function getItemsIdsByTypeAndOwner(string _itemIdsTitle, address _owner) public view returns(uint256[]);
117     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public view returns(address);
118     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public;
119     function addReferrer(address _referrerWalletAddress, uint256 referrerPrize) public;
120     function widthdrawRefunds(address _referrerWalletAddress) public returns(uint256);
121     function checkRefundExistanceByOwner(address _ownerAddress) public view returns(uint256);
122 }
123 
124 contract ItemsStorageInterface {
125     function getShipsIds() public view returns(uint256[]);
126     function getRadarsIds() public view returns(uint256[]);
127     function getScannersIds() public view returns(uint256[]);
128     function getDroidsIds() public view returns(uint256[]);
129     function getFuelsIds() public view returns(uint256[]);
130     function getGeneratorsIds() public view returns(uint256[]);
131     function getEnginesIds() public view returns(uint256[]);
132     function getGunsIds() public view returns(uint256[]);
133     function getMicroModulesIds() public view returns(uint256[]);
134     function getArtefactsIds() public view returns(uint256[]);
135 
136     function getUsersShipsIds() public view returns(uint256[]);
137     function getUsersRadarsIds() public view returns(uint256[]);
138     function getUsersScannersIds() public view returns(uint256[]);
139     function getUsersDroidsIds() public view returns(uint256[]);
140     function getUsersEnginesIds() public view returns(uint256[]);
141     function getUsersFuelsIds() public view returns(uint256[]);
142     function getUsersGeneratorsIds() public view returns(uint256[]);
143     function getUsersGunsIds() public view returns(uint256[]);
144     function getUsersMicroModulesIds() public view returns(uint256[]);
145     function getUsersArtefactsIds() public view returns(uint256[]);
146 }
147 
148 contract LogicContract is Ownable {
149 
150     /* ------ EVENTS ------ */
151 
152     event ShipWasBought(uint256 shipId);
153 
154     EternalStorageInterface private eternalStorageContract;
155     ItemsStorageInterface private itemsStorageContract;
156 
157     constructor() public {
158         eternalStorageContract = EternalStorageInterface(0xFdc3eCed80556A6d1352185E339F20ff501Fbbeb);
159         itemsStorageContract = ItemsStorageInterface(0x600c9892B294ef4cB7D22c1f6045C972C0a086e5);
160     }
161 
162     /* ------ MODIFIERS ------ */
163 
164     modifier addressIsNotNull(address _newOwner) {
165 		require(_newOwner != address(0));
166 		_;
167 	}
168 
169     /* ------ FUNCTIONALITY FUNCTIONS ------ */
170 
171     function destroyLogicContract() public onlyOwner {
172         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
173     }
174 
175     // Buying new ship
176 	function buyShip(uint256 _shipId, address _referrerWalletAddress) public payable addressIsNotNull(msg.sender)  {
177         uint256 referrerPrize = 0;
178 
179         uint256 price = eternalStorageContract.getItemPriceById("ships", _shipId);
180         require(msg.value == price);
181 
182         if (_referrerWalletAddress != address(0) && _referrerWalletAddress != msg.sender && price > 0) {
183             referrerPrize = SafeMath.div(price, 10);
184             if (referrerPrize < price) {
185                 eternalStorageContract.addReferrer(_referrerWalletAddress, referrerPrize);
186             }
187         }
188 
189         _buyShip(_shipId, msg.sender);
190 	}
191 
192     function _buyShip(uint256 _shipId, address _newOwner) private {
193         uint256 myShipId = eternalStorageContract.buyItem(_shipId, _newOwner, "ship", "ship_types", "ship_ids");
194         emit ShipWasBought(myShipId);
195     }
196 
197     function withdrawRefund() external addressIsNotNull(msg.sender) {
198         uint256 curRefVal = eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
199         if (curRefVal > 0 && address(this).balance > curRefVal && SafeMath.sub(address(this).balance, curRefVal) > 0) {
200             uint256 refund = eternalStorageContract.widthdrawRefunds(msg.sender);
201             msg.sender.transfer(refund);
202         }
203     }
204 
205     function checkRefundExistanceByOwner() external addressIsNotNull(msg.sender) view returns(uint256) {
206         return eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
207     }
208 
209     /* ------ READING METHODS FOR USERS ITEMS ------ */
210 
211     function getNumberOfShipsByOwner() public view returns(uint256) {
212         return eternalStorageContract.getNumberOfItemsByTypeAndOwner("ship", msg.sender);
213     }
214 
215     function getShipsByOwner() public view returns(uint256[]) {
216         return eternalStorageContract.getItemsByTypeAndOwner("ship_types", msg.sender);
217     }
218     
219     function getShipIdsByOwner() public view returns(uint256[]) {
220         return eternalStorageContract.getItemsIdsByTypeAndOwner("ship_ids", msg.sender);
221     }
222 
223     function getOwnerByShipId(uint256 _shipId) public view returns(address) {
224         return eternalStorageContract.getOwnerByItemTypeAndId("ship", _shipId);
225     }
226 
227     /* ------ READING METHODS FOR ALL USERS ITEMS ------ */
228 
229     // Ships
230     function getUsersShipsIds() public view returns(uint256[]) {
231         return itemsStorageContract.getUsersShipsIds();
232     }
233 
234     /* ------ READING METHODS FOR ALL ITEMS ------ */
235 
236     // Get item price
237     function getShipPriceById(uint256 _shipId) public view returns(uint256) {
238         return eternalStorageContract.getItemPriceById("ships", _shipId);
239     }
240 
241     // Ships
242     function getShipsIds() public view returns(uint256[]) {
243         return itemsStorageContract.getShipsIds();
244     }
245 
246     function getShipById(uint256 _shipId) public view returns(
247         uint256,
248         string,
249         uint256,
250         uint256,
251         uint256
252     ) {
253         return eternalStorageContract.getShipById(_shipId);
254     }
255 
256     /* ------ DEV FUNCTIONS ------ */
257 
258     function getBalanceOfLogicContract() public onlyOwner view returns(uint256) {
259         return address(this).balance;
260     }
261 
262     function getPayOut() public onlyOwner returns(uint256) {
263 		_getPayOut();
264 	}
265 
266 	function _getPayOut() private returns(uint256){
267 		if (msg.sender != address(0)) {
268 			msg.sender.transfer(address(this).balance);
269             return address(this).balance;
270 		}
271 	}
272 
273     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyOwner {
274         eternalStorageContract.setNewPriceToItem(_itemType, _itemTypeId, _newPrice);
275     }
276 }