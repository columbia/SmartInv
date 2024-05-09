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
124 
125 contract ItemsStorageInterface {
126     function getShipsIds() public view returns(uint256[]);
127     function getRadarsIds() public view returns(uint256[]);
128     function getScannersIds() public view returns(uint256[]);
129     function getDroidsIds() public view returns(uint256[]);
130     function getFuelsIds() public view returns(uint256[]);
131     function getGeneratorsIds() public view returns(uint256[]);
132     function getEnginesIds() public view returns(uint256[]);
133     function getGunsIds() public view returns(uint256[]);
134     function getMicroModulesIds() public view returns(uint256[]);
135     function getArtefactsIds() public view returns(uint256[]);
136 
137     function getUsersShipsIds() public view returns(uint256[]);
138     function getUsersRadarsIds() public view returns(uint256[]);
139     function getUsersScannersIds() public view returns(uint256[]);
140     function getUsersDroidsIds() public view returns(uint256[]);
141     function getUsersEnginesIds() public view returns(uint256[]);
142     function getUsersFuelsIds() public view returns(uint256[]);
143     function getUsersGeneratorsIds() public view returns(uint256[]);
144     function getUsersGunsIds() public view returns(uint256[]);
145     function getUsersMicroModulesIds() public view returns(uint256[]);
146     function getUsersArtefactsIds() public view returns(uint256[]);
147 }
148 
149 contract LogicContract is Ownable {
150 
151     /* ------ EVENTS ------ */
152 
153     event ShipWasBought(uint256 shipId);
154 
155     EternalStorageInterface private eternalStorageContract;
156     ItemsStorageInterface private itemsStorageContract;
157 
158     constructor() public {
159         eternalStorageContract = EternalStorageInterface(0x89eB6e29d81B98A4b88111e0d82924E6CBDc4AE4);
160         itemsStorageContract = ItemsStorageInterface(0xf1fd447DAc5AbEAba356cD0010Bac95daA37C265);
161     }
162 
163     /* ------ MODIFIERS ------ */
164 
165     modifier addressIsNotNull(address _newOwner) {
166 		require(_newOwner != address(0));
167 		_;
168 	}
169 
170     /* ------ FUNCTIONALITY FUNCTIONS ------ */
171 
172     function destroyLogicContract() public onlyOwner {
173         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
174     }
175 
176     // Buying new ship
177 	function buyShip(uint256 _shipId, address _referrerWalletAddress) public payable addressIsNotNull(msg.sender)  {
178         uint256 referrerPrize = 0;
179 
180         uint256 price = eternalStorageContract.getItemPriceById("ships", _shipId);
181         require(msg.value == price);
182 
183         if (_referrerWalletAddress != address(0) && _referrerWalletAddress != msg.sender && price > 0) {
184             referrerPrize = SafeMath.div(price, 10);
185             if (referrerPrize < price) {
186                 eternalStorageContract.addReferrer(_referrerWalletAddress, referrerPrize);
187             }
188         }
189 
190         _buyShip(_shipId, msg.sender);
191 	}
192 
193     function _buyShip(uint256 _shipId, address _newOwner) private {
194         uint256 myShipId = eternalStorageContract.buyItem(_shipId, _newOwner, "ship", "ship_types", "ship_ids");
195         emit ShipWasBought(myShipId);
196     }
197 
198     function withdrawRefund() external addressIsNotNull(msg.sender) {
199         uint256 curRefVal = eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
200         if (curRefVal > 0 && address(this).balance > curRefVal && SafeMath.sub(address(this).balance, curRefVal) > 0) {
201             uint256 refund = eternalStorageContract.widthdrawRefunds(msg.sender);
202             msg.sender.transfer(refund);
203         }
204     }
205 
206     function checkRefundExistanceByOwner() external addressIsNotNull(msg.sender) view returns(uint256) {
207         return eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
208     }
209 
210     /* ------ READING METHODS FOR USERS ITEMS ------ */
211 
212     function getNumberOfShipsByOwner() public view returns(uint256) {
213         return eternalStorageContract.getNumberOfItemsByTypeAndOwner("ship", msg.sender);
214     }
215 
216     function getShipsByOwner() public view returns(uint256[]) {
217         return eternalStorageContract.getItemsByTypeAndOwner("ship_types", msg.sender);
218     }
219     
220     function getShipIdsByOwner() public view returns(uint256[]) {
221         return eternalStorageContract.getItemsIdsByTypeAndOwner("ship_ids", msg.sender);
222     }
223 
224     function getOwnerByShipId(uint256 _shipId) public view returns(address) {
225         return eternalStorageContract.getOwnerByItemTypeAndId("ship", _shipId);
226     }
227 
228     /* ------ READING METHODS FOR ALL USERS ITEMS ------ */
229 
230     // Ships
231     function getUsersShipsIds() public view returns(uint256[]) {
232         return itemsStorageContract.getUsersShipsIds();
233     }
234 
235     /* ------ READING METHODS FOR ALL ITEMS ------ */
236 
237     // Get item price
238     function getShipPriceById(uint256 _shipId) public view returns(uint256) {
239         return eternalStorageContract.getItemPriceById("ships", _shipId);
240     }
241 
242     // Ships
243     function getShipsIds() public view returns(uint256[]) {
244         return itemsStorageContract.getShipsIds();
245     }
246 
247     function getShipById(uint256 _shipId) public view returns(
248         uint256,
249         string,
250         uint256,
251         uint256,
252         uint256
253     ) {
254         return eternalStorageContract.getShipById(_shipId);
255     }
256 
257     /* ------ DEV FUNCTIONS ------ */
258 
259     function getBalanceOfLogicContract() public onlyOwner view returns(uint256) {
260         return address(this).balance;
261     }
262 
263     function getPayOut() public onlyOwner returns(uint256) {
264 		_getPayOut();
265 	}
266 
267 	function _getPayOut() private returns(uint256){
268 		if (msg.sender != address(0)) {
269 			msg.sender.transfer(address(this).balance);
270             return address(this).balance;
271 		}
272 	}
273 
274     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyOwner {
275         eternalStorageContract.setNewPriceToItem(_itemType, _itemTypeId, _newPrice);
276     }
277 }