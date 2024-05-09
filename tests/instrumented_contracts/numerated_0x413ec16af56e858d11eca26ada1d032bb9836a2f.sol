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
112     function buyItem(uint256 _itemId, address _newOwner, string _itemTitle, string _itemTypeTitle) public returns(uint256);
113     function getItemPriceById(string _itemType, uint256 _itemId) public view returns(uint256);
114     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public view returns(address);
115     function getItemTypeIdByTypeAndId(string _itemType, uint256 _itemId) public view returns(uint256);
116     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public;
117     function addReferrer(address _referrerWalletAddress, uint256 referrerPrize) public;
118     function widthdrawRefunds(address _referrerWalletAddress) public returns(uint256);
119     function checkRefundExistanceByOwner(address _ownerAddress) public view returns(uint256);
120 }
121 
122 
123 contract ItemsStorageInterface {
124     function getShipsIds() public view returns(uint256[]);
125     function getRadarsIds() public view returns(uint256[]);
126     function getScannersIds() public view returns(uint256[]);
127     function getDroidsIds() public view returns(uint256[]);
128     function getFuelsIds() public view returns(uint256[]);
129     function getGeneratorsIds() public view returns(uint256[]);
130     function getEnginesIds() public view returns(uint256[]);
131     function getGunsIds() public view returns(uint256[]);
132     function getMicroModulesIds() public view returns(uint256[]);
133     function getArtefactsIds() public view returns(uint256[]);
134 
135     function getUsersShipsIds() public view returns(uint256[]);
136     function getUsersRadarsIds() public view returns(uint256[]);
137     function getUsersScannersIds() public view returns(uint256[]);
138     function getUsersDroidsIds() public view returns(uint256[]);
139     function getUsersEnginesIds() public view returns(uint256[]);
140     function getUsersFuelsIds() public view returns(uint256[]);
141     function getUsersGeneratorsIds() public view returns(uint256[]);
142     function getUsersGunsIds() public view returns(uint256[]);
143     function getUsersMicroModulesIds() public view returns(uint256[]);
144     function getUsersArtefactsIds() public view returns(uint256[]);
145 }
146 
147 contract LogicContract is Ownable {
148 
149     /* ------ EVENTS ------ */
150 
151     event ShipWasBought(uint256 shipId);
152 
153     EternalStorageInterface private eternalStorageContract;
154     ItemsStorageInterface private itemsStorageContract;
155 
156     constructor() public {
157         eternalStorageContract = EternalStorageInterface(0x5E415bD4946679C083A22F7369dD20317A2881A1);
158         itemsStorageContract = ItemsStorageInterface(0x504c53cBd44B68001Ec8A2728679c07BB78283f0);
159     }
160 
161     /* ------ MODIFIERS ------ */
162 
163     modifier addressIsNotNull(address _newOwner) {
164 		require(_newOwner != address(0));
165 		_;
166 	}
167 
168     /* ------ FUNCTIONALITY FUNCTIONS ------ */
169 
170     function destroyLogicContract() public onlyOwner {
171         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
172     }
173 
174     // Buying new ship
175 	function buyShip(uint256 _shipId, address _referrerWalletAddress) public payable addressIsNotNull(msg.sender)  {
176         uint256 referrerPrize = 0;
177 
178         uint256 price = eternalStorageContract.getItemPriceById("ships", _shipId);
179         require(msg.value == price);
180 
181         if (_referrerWalletAddress != address(0) && _referrerWalletAddress != msg.sender && price > 0) {
182             referrerPrize = SafeMath.div(price, 10);
183             if (referrerPrize < price) {
184                 eternalStorageContract.addReferrer(_referrerWalletAddress, referrerPrize);
185             }
186         }
187 
188         _buyShip(_shipId, msg.sender);
189 	}
190 
191     function _buyShip(uint256 _shipId, address _newOwner) private {
192         uint256 myShipId = eternalStorageContract.buyItem(_shipId, _newOwner, "ship", "ship_types");
193         emit ShipWasBought(myShipId);
194     }
195 
196     function withdrawRefund() external addressIsNotNull(msg.sender) {
197         uint256 curRefVal = eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
198         if (curRefVal > 0 && address(this).balance > curRefVal && SafeMath.sub(address(this).balance, curRefVal) > 0) {
199             uint256 refund = eternalStorageContract.widthdrawRefunds(msg.sender);
200             msg.sender.transfer(refund);
201         }
202     }
203 
204     function checkRefundExistanceByOwner() external addressIsNotNull(msg.sender) view returns(uint256) {
205         return eternalStorageContract.checkRefundExistanceByOwner(msg.sender);
206     }
207 
208     /* ------ READING METHODS FOR USERS ITEMS ------ */
209 
210     function getOwnerByShipId(uint256 _shipId) public view returns(address) {
211         return eternalStorageContract.getOwnerByItemTypeAndId("ship", _shipId);
212     }
213 
214     function getShipType(uint256 _shipId) public view returns(uint256) {
215         return eternalStorageContract.getItemTypeIdByTypeAndId("ship_types", _shipId);
216     }
217 
218     /* ------ READING METHODS FOR ALL USERS ITEMS ------ */
219 
220     // Ships
221     function getUsersShipsIds() public view returns(uint256[]) {
222         return itemsStorageContract.getUsersShipsIds();
223     }
224 
225     /* ------ READING METHODS FOR ALL ITEMS ------ */
226 
227     // Get item price
228     function getShipPriceById(uint256 _shipId) public view returns(uint256) {
229         return eternalStorageContract.getItemPriceById("ships", _shipId);
230     }
231 
232     // Ships
233     function getShipsIds() public view returns(uint256[]) {
234         return itemsStorageContract.getShipsIds();
235     }
236 
237     function getShipById(uint256 _shipId) public view returns(
238         uint256,
239         string,
240         uint256,
241         uint256,
242         uint256
243     ) {
244         return eternalStorageContract.getShipById(_shipId);
245     }
246 
247     /* ------ DEV FUNCTIONS ------ */
248 
249     function getBalanceOfLogicContract() public onlyOwner view returns(uint256) {
250         return address(this).balance;
251     }
252 
253     function getPayOut() public onlyOwner returns(uint256) {
254 		_getPayOut();
255 	}
256 
257 	function _getPayOut() private returns(uint256){
258 		if (msg.sender != address(0)) {
259 			msg.sender.transfer(address(this).balance);
260             return address(this).balance;
261 		}
262 	}
263 
264     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyOwner {
265         eternalStorageContract.setNewPriceToItem(_itemType, _itemTypeId, _newPrice);
266     }
267 }