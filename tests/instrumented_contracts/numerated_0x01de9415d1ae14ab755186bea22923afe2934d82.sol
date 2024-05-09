1 pragma solidity ^0.4.24;
2 
3 interface ERC721 /* is ERC165 */ {
4     /// @dev This emits when ownership of any NFT changes by any mechanism.
5     ///  This event emits when NFTs are created (`from` == 0) and destroyed
6     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
7     ///  may be created and assigned without emitting Transfer. At the time of
8     ///  any transfer, the approved address for that NFT (if any) is reset to none.
9     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
10 
11     /// @dev This emits when the approved address for an NFT is changed or
12     ///  reaffirmed. The zero address indicates there is no approved address.
13     ///  When a Transfer event emits, this also indicates that the approved
14     ///  address for that NFT (if any) is reset to none.
15     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
16 
17     /// @dev This emits when an operator is enabled or disabled for an owner.
18     ///  The operator can manage all NFTs of the owner.
19     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
20 
21     /// @notice Count all NFTs assigned to an owner
22     /// @dev NFTs assigned to the zero address are considered invalid, and this
23     ///  function throws for queries about the zero address.
24     /// @param _owner An address for whom to query the balance
25     /// @return The number of NFTs owned by `_owner`, possibly zero
26     function balanceOf(address _owner) external view returns (uint256);
27 
28     /// @notice Find the owner of an NFT
29     /// @dev NFTs assigned to zero address are considered invalid, and queries
30     ///  about them do throw.
31     /// @param _tokenId The identifier for an NFT
32     /// @return The address of the owner of the NFT
33     function ownerOf(uint256 _tokenId) external view returns (address);
34 
35     /// @notice Transfers the ownership of an NFT from one address to another address
36     /// @dev Throws unless `msg.sender` is the current owner, an authorized
37     ///  operator, or the approved address for this NFT. Throws if `_from` is
38     ///  not the current owner. Throws if `_to` is the zero address. Throws if
39     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
40     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
41     ///  `onERC721Received` on `_to` and throws if the return value is not
42     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
43     /// @param _from The current owner of the NFT
44     /// @param _to The new owner
45     /// @param _tokenId The NFT to transfer
46     /// @param data Additional data with no specified format, sent in call to `_to`
47     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
48 
49     /// @notice Transfers the ownership of an NFT from one address to another address
50     /// @dev This works identically to the other function with an extra data parameter,
51     ///  except this function just sets data to "".
52     /// @param _from The current owner of the NFT
53     /// @param _to The new owner
54     /// @param _tokenId The NFT to transfer
55     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
56 
57     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
58     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
59     ///  THEY MAY BE PERMANENTLY LOST
60     /// @dev Throws unless `msg.sender` is the current owner, an authorized
61     ///  operator, or the approved address for this NFT. Throws if `_from` is
62     ///  not the current owner. Throws if `_to` is the zero address. Throws if
63     ///  `_tokenId` is not a valid NFT.
64     /// @param _from The current owner of the NFT
65     /// @param _to The new owner
66     /// @param _tokenId The NFT to transfer
67     function transferFrom(address _from, address _to, uint256 _tokenId) external;
68 
69     /// @notice Change or reaffirm the approved address for an NFT
70     /// @dev The zero address indicates there is no approved address.
71     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
72     ///  operator of the current owner.
73     /// @param _approved The new approved NFT controller
74     /// @param _tokenId The NFT to approve
75     function approve(address _approved, uint256 _tokenId) external;
76 
77     /// @notice Enable or disable approval for a third party ("operator") to manage
78     ///  all of `msg.sender`'s assets
79     /// @dev Emits the ApprovalForAll event. The contract MUST allow
80     ///  multiple operators per owner.
81     /// @param _operator Address to add to the set of authorized operators
82     /// @param _approved True if the operator is approved, false to revoke approval
83     function setApprovalForAll(address _operator, bool _approved) external;
84 
85     /// @notice Get the approved address for a single NFT
86     /// @dev Throws if `_tokenId` is not a valid NFT.
87     /// @param _tokenId The NFT to find the approved address for
88     /// @return The approved address for this NFT, or the zero address if there is none
89     function getApproved(uint256 _tokenId) external view returns (address);
90 
91     /// @notice Query if an address is an authorized operator for another address
92     /// @param _owner The address that owns the NFTs
93     /// @param _operator The address that acts on behalf of the owner
94     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
95     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
96 }
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157   }
158 }
159 
160 /**
161  * @title Operator
162  * @dev Allow two roles: 'owner' or 'operator'
163  *      - owner: admin/superuser (e.g. with financial rights)
164  *      - operator: can update configurations
165  */
166 contract Operator is Ownable {
167     address[] public operators;
168 
169     uint public MAX_OPS = 20; // Default maximum number of operators allowed
170 
171     mapping(address => bool) public isOperator;
172 
173     event OperatorAdded(address operator);
174     event OperatorRemoved(address operator);
175 
176     // @dev Throws if called by any non-operator account. Owner has all ops rights.
177     modifier onlyOperator() {
178         require(
179             isOperator[msg.sender] || msg.sender == owner,
180             "Permission denied. Must be an operator or the owner."
181         );
182         _;
183     }
184 
185     /**
186      * @dev Allows the current owner or operators to add operators
187      * @param _newOperator New operator address
188      */
189     function addOperator(address _newOperator) public onlyOwner {
190         require(
191             _newOperator != address(0),
192             "Invalid new operator address."
193         );
194 
195         // Make sure no dups
196         require(
197             !isOperator[_newOperator],
198             "New operator exists."
199         );
200 
201         // Only allow so many ops
202         require(
203             operators.length < MAX_OPS,
204             "Overflow."
205         );
206 
207         operators.push(_newOperator);
208         isOperator[_newOperator] = true;
209 
210         emit OperatorAdded(_newOperator);
211     }
212 
213     /**
214      * @dev Allows the current owner or operators to remove operator
215      * @param _operator Address of the operator to be removed
216      */
217     function removeOperator(address _operator) public onlyOwner {
218         // Make sure operators array is not empty
219         require(
220             operators.length > 0,
221             "No operator."
222         );
223 
224         // Make sure the operator exists
225         require(
226             isOperator[_operator],
227             "Not an operator."
228         );
229 
230         // Manual array manipulation:
231         // - replace the _operator with last operator in array
232         // - remove the last item from array
233         address lastOperator = operators[operators.length - 1];
234         for (uint i = 0; i < operators.length; i++) {
235             if (operators[i] == _operator) {
236                 operators[i] = lastOperator;
237             }
238         }
239         operators.length -= 1; // remove the last element
240 
241         isOperator[_operator] = false;
242         emit OperatorRemoved(_operator);
243     }
244 
245     // @dev Remove ALL operators
246     function removeAllOps() public onlyOwner {
247         for (uint i = 0; i < operators.length; i++) {
248             isOperator[operators[i]] = false;
249         }
250         operators.length = 0;
251     }
252 }
253 
254 interface BitizenCarService {
255   function isBurnedCar(uint256 _carId) external view returns (bool);
256   function getOwnerCars(address _owner) external view returns(uint256[]);
257   function getBurnedCarIdByIndex(uint256 _index) external view returns (uint256);
258   function getCarInfo(uint256 _carId) external view returns(string, uint8, uint8);
259   function createCar(address _owner, string _foundBy, uint8 _type, uint8 _ext) external returns(uint256);
260   function updateCar(uint256 _carId, string _newFoundBy, uint8 _newType, uint8 _ext) external;
261   function burnCar(address _owner, uint256 _carId) external;
262 }
263 
264 contract BitizenCarOperator is Operator {
265 
266   event CreateCar(address indexed _owner, uint256 _carId);
267   
268   BitizenCarService internal carService;
269 
270   ERC721 internal ERC721Service;
271 
272   uint16 PER_USER_MAX_CAR_COUNT = 1;
273 
274   function injectCarService(BitizenCarService _service) public onlyOwner {
275     carService = BitizenCarService(_service);
276     ERC721Service = ERC721(_service);
277   }
278 
279   function setMaxCount(uint16 _count) public onlyOwner {
280     PER_USER_MAX_CAR_COUNT = _count;
281   }
282 
283   function getOwnerCars() external view returns(uint256[]) {
284     return carService.getOwnerCars(msg.sender);
285   }
286 
287   function getCarInfo(uint256 _carId) external view returns(string, uint8, uint8){
288     return carService.getCarInfo(_carId);
289   }
290   
291   function createCar(string _foundBy) external returns(uint256) {
292     require(ERC721Service.balanceOf(msg.sender) < PER_USER_MAX_CAR_COUNT,"user owned car count overflow");
293     uint256 carId = carService.createCar(msg.sender, _foundBy, 1, 1);
294     emit CreateCar(msg.sender, carId);
295     return carId;
296   }
297 
298   function createCarByOperator(address _owner, string _foundBy, uint8 _type, uint8 _ext) external onlyOperator returns (uint256) {
299     uint256 carId = carService.createCar(_owner, _foundBy, _type, _ext);
300     emit CreateCar(msg.sender, carId);
301     return carId;
302   }
303 
304 }