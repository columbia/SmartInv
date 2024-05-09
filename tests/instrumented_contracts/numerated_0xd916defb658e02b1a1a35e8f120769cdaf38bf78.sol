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
122 contract ItemsStorageInterface {
123     function getShipsIds() public view returns(uint256[]);
124     function getRadarsIds() public view returns(uint256[]);
125     function getScannersIds() public view returns(uint256[]);
126     function getDroidsIds() public view returns(uint256[]);
127     function getFuelsIds() public view returns(uint256[]);
128     function getGeneratorsIds() public view returns(uint256[]);
129     function getEnginesIds() public view returns(uint256[]);
130     function getGunsIds() public view returns(uint256[]);
131     function getMicroModulesIds() public view returns(uint256[]);
132     function getArtefactsIds() public view returns(uint256[]);
133 
134     function getUsersShipsIds() public view returns(uint256[]);
135     function getUsersRadarsIds() public view returns(uint256[]);
136     function getUsersScannersIds() public view returns(uint256[]);
137     function getUsersDroidsIds() public view returns(uint256[]);
138     function getUsersEnginesIds() public view returns(uint256[]);
139     function getUsersFuelsIds() public view returns(uint256[]);
140     function getUsersGeneratorsIds() public view returns(uint256[]);
141     function getUsersGunsIds() public view returns(uint256[]);
142     function getUsersMicroModulesIds() public view returns(uint256[]);
143     function getUsersArtefactsIds() public view returns(uint256[]);
144 }
145 
146 contract LogicContract is Ownable {
147 
148     /* ------ EVENTS ------ */
149 
150     event ShipWasBought(uint256 shipId);
151 
152     EternalStorageInterface private eternalStorageContract;
153     ItemsStorageInterface private itemsStorageContract;
154 
155     constructor() public {
156         eternalStorageContract = EternalStorageInterface(0xdb289A6c489Ea324564E64783eCCcb0d7fa9d00f);
157         itemsStorageContract = ItemsStorageInterface(0x27B95A9231a022923e9b52d71bEB662Fdd5d6cbc);
158     }
159 
160     /* ------ MODIFIERS ------ */
161 
162     modifier addressIsNotNull(address _newOwner) {
163 		require(_newOwner != address(0));
164 		_;
165 	}
166 
167     /* ------ FUNCTIONALITY FUNCTIONS ------ */
168 
169     function destroyLogicContract() public onlyOwner {
170         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
171     }
172 
173     // Buying new ship
174 	function buyShip(uint256 _shipId, address _referrerWalletAddress) public payable addressIsNotNull(msg.sender)  {
175         uint256 referrerPrize = 0;
176 
177         uint256 price = eternalStorageContract.getItemPriceById("ships", _shipId);
178         require(msg.value == price);
179 
180         if (_referrerWalletAddress != address(0) && _referrerWalletAddress != msg.sender && price > 0) {
181             referrerPrize = SafeMath.div(price, 10);
182             if (referrerPrize < price) {
183                 eternalStorageContract.addReferrer(_referrerWalletAddress, referrerPrize);
184             }
185         }
186 
187         _buyShip(_shipId, msg.sender);
188 	}
189 
190     function _buyShip(uint256 _shipId, address _newOwner) private {
191         uint256 myShipId = eternalStorageContract.buyItem(_shipId, _newOwner, "ship", "ship_types");
192         emit ShipWasBought(myShipId);
193     }
194 
195     function withdrawRefund(address _owner) public addressIsNotNull(_owner) {
196         uint256 curRefVal = eternalStorageContract.checkRefundExistanceByOwner(_owner);
197         if (curRefVal > 0 && address(this).balance > curRefVal && SafeMath.sub(address(this).balance, curRefVal) > 0) {
198             uint256 refund = eternalStorageContract.widthdrawRefunds(_owner);
199             _owner.transfer(refund);
200         }
201     }
202 
203     function checkRefundExistanceByOwner(address _owner) public addressIsNotNull(_owner) view returns(uint256) {
204         return eternalStorageContract.checkRefundExistanceByOwner(_owner);
205     }
206 
207     /* ------ READING METHODS FOR USERS ITEMS ------ */
208 
209     function getOwnerByShipId(uint256 _shipId) public view returns(address) {
210         return eternalStorageContract.getOwnerByItemTypeAndId("ship", _shipId);
211     }
212 
213     function getShipType(uint256 _shipId) public view returns(uint256) {
214         return eternalStorageContract.getItemTypeIdByTypeAndId("ship_types", _shipId);
215     }
216 
217     /* ------ READING METHODS FOR ALL USERS ITEMS ------ */
218 
219     // Ships
220     function getUsersShipsIds() public view returns(uint256[]) {
221         return itemsStorageContract.getUsersShipsIds();
222     }
223 
224     /* ------ READING METHODS FOR ALL ITEMS ------ */
225 
226     // Get item price
227     function getShipPriceById(uint256 _shipId) public view returns(uint256) {
228         return eternalStorageContract.getItemPriceById("ships", _shipId);
229     }
230 
231     // Ships
232     function getShipsIds() public view returns(uint256[]) {
233         return itemsStorageContract.getShipsIds();
234     }
235 
236     function getShipById(uint256 _shipId) public view returns(
237         uint256,
238         string,
239         uint256,
240         uint256,
241         uint256
242     ) {
243         return eternalStorageContract.getShipById(_shipId);
244     }
245 
246     /* ------ DEV FUNCTIONS ------ */
247 
248     function getBalanceOfLogicContract() public onlyOwner view returns(uint256) {
249         return address(this).balance;
250     }
251 
252     function getPayOut() public onlyOwner returns(uint256) {
253 		_getPayOut();
254 	}
255 
256 	function _getPayOut() private returns(uint256){
257 		if (msg.sender != address(0)) {
258 			msg.sender.transfer(address(this).balance);
259             return address(this).balance;
260 		}
261 	}
262 
263     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyOwner {
264         eternalStorageContract.setNewPriceToItem(_itemType, _itemTypeId, _newPrice);
265     }
266 }