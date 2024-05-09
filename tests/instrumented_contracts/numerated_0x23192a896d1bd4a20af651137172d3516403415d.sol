1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71     if (a == 0) {
72       return 0;
73     }
74     uint256 c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   /**
90   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256) {
101     uint256 c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 contract EternalStorageInterface {
108     function getShipById(uint256 _shipId) public view returns(uint256, string, uint256, uint256, uint256);
109     function buyItem(uint256 _itemId, address _newOwner, string _itemTitle, string _itemTypeTitle, string _itemIdTitle) public returns(uint256);
110     function getItemPriceById(string _itemType, uint256 _itemId) public view returns(uint256);
111     function getNumberOfItemsByTypeAndOwner(string _itemType, address _owner) public view returns(uint256);
112     function getItemsByTypeAndOwner(string _itemTypeTitle, address _owner) public view returns(uint256[]);
113     function getItemsIdsByTypeAndOwner(string _itemIdsTitle, address _owner) public view returns(uint256[]);
114     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public view returns(address);
115     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public;
116     function addReferrer(address _referrerWalletAddress, uint256 referrerPrize) public;
117     function widthdrawRefunds(address _referrerWalletAddress) public returns(uint256);
118     function checkRefundExistanceByOwner(address _ownerAddress) public view returns(uint256);
119 }
120 
121 contract ItemsStorageInterface {
122     function getShipsIds() public view returns(uint256[]);
123     function getRadarsIds() public view returns(uint256[]);
124     function getScannersIds() public view returns(uint256[]);
125     function getDroidsIds() public view returns(uint256[]);
126     function getFuelsIds() public view returns(uint256[]);
127     function getGeneratorsIds() public view returns(uint256[]);
128     function getEnginesIds() public view returns(uint256[]);
129     function getGunsIds() public view returns(uint256[]);
130     function getMicroModulesIds() public view returns(uint256[]);
131     function getArtefactsIds() public view returns(uint256[]);
132 
133     function getUsersShipsIds() public view returns(uint256[]);
134     function getUsersRadarsIds() public view returns(uint256[]);
135     function getUsersScannersIds() public view returns(uint256[]);
136     function getUsersDroidsIds() public view returns(uint256[]);
137     function getUsersEnginesIds() public view returns(uint256[]);
138     function getUsersFuelsIds() public view returns(uint256[]);
139     function getUsersGeneratorsIds() public view returns(uint256[]);
140     function getUsersGunsIds() public view returns(uint256[]);
141     function getUsersMicroModulesIds() public view returns(uint256[]);
142     function getUsersArtefactsIds() public view returns(uint256[]);
143 }
144 
145 contract LogicContract is Ownable {
146 
147     /* ------ EVENTS ------ */
148 
149     event ShipWasBought(uint256 shipId);
150 
151     EternalStorageInterface private eternalStorageContract;
152     ItemsStorageInterface private itemsStorageContract;
153 
154     constructor() public {
155         eternalStorageContract = EternalStorageInterface(0x1C3042BAA90D995Ea85C19d8a494218Fe5C48e72);
156         itemsStorageContract = ItemsStorageInterface(0xf1fd447DAc5AbEAba356cD0010Bac95daA37C265);
157     }
158 
159     /* ------ MODIFIERS ------ */
160 
161     modifier addressIsNotNull(address _newOwner) {
162 		require(_newOwner != address(0));
163 		_;
164 	}
165 
166     /* ------ FUNCTIONALITY FUNCTIONS ------ */
167 
168     // Buying new ship
169 	function buyShip(uint256 _shipId, address _referrerWalletAddress) public payable addressIsNotNull(msg.sender)  {
170         uint256 referrerPrize = 0;
171 
172         uint256 price = eternalStorageContract.getItemPriceById("ships", _shipId);
173         require(msg.value == price);
174 
175         if (_referrerWalletAddress != address(0) && _referrerWalletAddress != msg.sender && price > 0) {
176             referrerPrize = SafeMath.div(price, 10);
177             if (referrerPrize < price) {
178                 eternalStorageContract.addReferrer(_referrerWalletAddress, referrerPrize);
179             }
180         }
181 
182         _buyShip(_shipId, msg.sender);
183 	}
184 
185     function _buyShip(uint256 _shipId, address _newOwner) private {
186         uint256 myShipId = eternalStorageContract.buyItem(_shipId, _newOwner, "ship", "ship_types", "ship_ids");
187         emit ShipWasBought(myShipId);
188     }
189 
190     function withdrawRefund() external addressIsNotNull(msg.sender) {
191         uint256 curRefVal = eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
192         if (curRefVal > 0 && address(this).balance > curRefVal && SafeMath.sub(address(this).balance, curRefVal) > 0) {
193             uint256 refund = eternalStorageContract.widthdrawRefunds(msg.sender);
194             msg.sender.transfer(refund);
195         }
196     }
197 
198     function checkRefundExistanceByOwner() external addressIsNotNull(msg.sender) view returns(uint256) {
199         return eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
200     }
201 
202     /* ------ READING METHODS FOR USERS ITEMS ------ */
203 
204     function getNumberOfShipsByOwner() public view returns(uint256) {
205         return eternalStorageContract.getNumberOfItemsByTypeAndOwner("ship", msg.sender);
206     }
207 
208     function getShipsByOwner() public view returns(uint256[]) {
209         return eternalStorageContract.getItemsByTypeAndOwner("ship_types", msg.sender);
210     }
211     
212     function getShipIdsByOwner() public view returns(uint256[]) {
213         return eternalStorageContract.getItemsIdsByTypeAndOwner("ship_ids", msg.sender);
214     }
215 
216     function getOwnerByShipId(uint256 _shipId) public view returns(address) {
217         return eternalStorageContract.getOwnerByItemTypeAndId("ship", _shipId);
218     }
219 
220     /* ------ READING METHODS FOR ALL USERS ITEMS ------ */
221 
222     // Ships
223     function getUsersShipsIds() public view returns(uint256[]) {
224         return itemsStorageContract.getUsersShipsIds();
225     }
226 
227     /* ------ READING METHODS FOR ALL ITEMS ------ */
228 
229     // Get item price
230     function getShipPriceById(uint256 _shipId) public view returns(uint256) {
231         return eternalStorageContract.getItemPriceById("ships", _shipId);
232     }
233 
234     // Ships
235     function getShipsIds() public view returns(uint256[]) {
236         return itemsStorageContract.getShipsIds();
237     }
238 
239     function getShipById(uint256 _shipId) public view returns(
240         uint256,
241         string,
242         uint256,
243         uint256,
244         uint256
245     ) {
246         return eternalStorageContract.getShipById(_shipId);
247     }
248 
249     /* ------ DEV FUNCTIONS ------ */
250 
251     function getBalanceOfLogicContract() public onlyOwner view returns(uint256) {
252         return address(this).balance;
253     }
254 
255     function getPayOut() public onlyOwner returns(uint256) {
256 		_getPayOut();
257 	}
258 
259 	function _getPayOut() private returns(uint256){
260 		if (msg.sender != address(0)) {
261 			msg.sender.transfer(address(this).balance);
262             return address(this).balance;
263 		}
264 	}
265 
266     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyOwner {
267         eternalStorageContract.setNewPriceToItem(_itemType, _itemTypeId, _newPrice);
268     }
269 }