1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
65 
66 /**
67  * @title ERC721 token receiver interface
68  * @dev Interface for any contract that wants to support safeTransfers
69  *  from ERC721 asset contracts.
70  */
71 contract ERC721Receiver {
72   /**
73    * @dev Magic value to be returned upon successful reception of an NFT
74    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
75    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
76    */
77   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
78 
79   /**
80    * @notice Handle the receipt of an NFT
81    * @dev The ERC721 smart contract calls this function on the recipient
82    *  after a `safetransfer`. This function MAY throw to revert and reject the
83    *  transfer. This function MUST use 50,000 gas or less. Return of other
84    *  than the magic value MUST result in the transaction being reverted.
85    *  Note: the contract address is always the message sender.
86    * @param _from The sending address
87    * @param _tokenId The NFT identifier which is being transfered
88    * @param _data Additional data with no specified format
89    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
90    */
91   function onERC721Received(
92     address _from,
93     uint256 _tokenId,
94     bytes _data
95   )
96     public
97     returns(bytes4);
98 }
99 
100 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
101 
102 /**
103  * @title ERC721 Non-Fungible Token Standard basic interface
104  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
105  */
106 contract ERC721Basic {
107   event Transfer(
108     address indexed _from,
109     address indexed _to,
110     uint256 _tokenId
111   );
112   event Approval(
113     address indexed _owner,
114     address indexed _approved,
115     uint256 _tokenId
116   );
117   event ApprovalForAll(
118     address indexed _owner,
119     address indexed _operator,
120     bool _approved
121   );
122 
123   function balanceOf(address _owner) public view returns (uint256 _balance);
124   function ownerOf(uint256 _tokenId) public view returns (address _owner);
125   function exists(uint256 _tokenId) public view returns (bool _exists);
126 
127   function approve(address _to, uint256 _tokenId) public;
128   function getApproved(uint256 _tokenId)
129     public view returns (address _operator);
130 
131   function setApprovalForAll(address _operator, bool _approved) public;
132   function isApprovedForAll(address _owner, address _operator)
133     public view returns (bool);
134 
135   function transferFrom(address _from, address _to, uint256 _tokenId) public;
136   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
137     public;
138 
139   function safeTransferFrom(
140     address _from,
141     address _to,
142     uint256 _tokenId,
143     bytes _data
144   )
145     public;
146 }
147 
148 // File: contracts/MTMarketplace.sol
149 
150 contract TVCrowdsale {
151     uint256 public currentRate;
152     function buyTokens(address _beneficiary) public payable;
153 }
154 
155 contract TVToken {
156     function transfer(address _to, uint256 _value) public returns (bool);
157     function safeTransfer(address _to, uint256 _value, bytes _data) public;
158 }
159 
160 contract MTMarketplace is Ownable {
161     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
162     address public wallet;
163     uint256 public fee_percentage;
164     ERC721Basic public token;
165     address public manager;
166     address internal checkAndBuySender;
167     address public TVTokenAddress;
168     address public TVCrowdsaleAddress;
169     bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
170 
171     modifier onlyOwnerOrManager() {
172         require(msg.sender == owner || manager == msg.sender);
173         _;
174     }
175 
176     mapping(uint256 => uint256) public priceList;
177     mapping(uint256 => address) public holderList;
178 
179     event Stored(uint256 indexed id, uint256 price, address seller);
180     event Cancelled(uint256 indexed id, address seller);
181     event Sold(uint256 indexed id, uint256 price, address seller, address buyer);
182 
183     event TokenChanged(address old_token, address new_token);
184     event WalletChanged(address old_wallet, address new_wallet);
185     event FeeChanged(uint256 old_fee, uint256 new_fee);
186 
187     constructor(
188         address _TVTokenAddress,
189         address _TVCrowdsaleAddress,
190         address _token,
191         address _wallet,
192         address _manager,
193         uint _fee_percentage
194     ) public {
195         TVTokenAddress = _TVTokenAddress;
196         TVCrowdsaleAddress = _TVCrowdsaleAddress;
197         token = ERC721Basic(_token);
198         wallet = _wallet;
199         fee_percentage = _fee_percentage;
200         manager = _manager;
201     }
202 
203     function setToken(address _token) public onlyOwnerOrManager {
204         address old = token;
205         token = ERC721Basic(_token);
206         emit TokenChanged(old, token);
207     }
208 
209     function setWallet(address _wallet) public onlyOwnerOrManager {
210         address old = wallet;
211         wallet = _wallet;
212         emit WalletChanged(old, wallet);
213     }
214 
215     function changeFeePercentage(uint256 _percentage) public onlyOwnerOrManager {
216         uint256 old = fee_percentage;
217         fee_percentage = _percentage;
218         emit FeeChanged(old, fee_percentage);
219     }
220 
221     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4) {
222         require(msg.sender == address(token));
223 
224         uint256 _price = uint256(convertBytesToBytes32(_data));
225 
226         require(_price > 0);
227 
228         priceList[_tokenId] = _price;
229         holderList[_tokenId] = _from;
230 
231         emit Stored(_tokenId, _price, _from);
232 
233         return ERC721_RECEIVED;
234     }
235 
236     function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
237         require(msg.sender == TVTokenAddress);
238         uint _id = uint256(convertBytesToBytes32(_data));
239         require(priceList[_id] == _value);
240 
241         address oldHolder = holderList[_id];
242         uint256 price = priceList[_id];
243 
244         uint256 toWallet = price / 100 * fee_percentage;
245         uint256 toHolder = price - toWallet;
246 
247         holderList[_id] = 0x0;
248         priceList[_id] = 0;
249 
250         _from = this == _from ? checkAndBuySender : _from;
251         checkAndBuySender = address(0);
252         token.safeTransferFrom(this, _from, _id);
253 
254         TVToken(TVTokenAddress).transfer(wallet, toWallet);
255         TVToken(TVTokenAddress).transfer(_from, toHolder);
256 
257         emit Sold(_id, price, oldHolder, msg.sender);
258         return TOKEN_RECEIVED;
259     }
260 
261     function cancel(uint256 _id) public returns (bool) {
262         require(holderList[_id] == msg.sender);
263 
264         holderList[_id] = 0x0;
265         priceList[_id] = 0;
266 
267         token.safeTransferFrom(this, msg.sender, _id);
268 
269         emit Cancelled(_id, msg.sender);
270 
271         return true;
272     }
273 
274     function changeAndBuy(uint256 _id) public payable returns (bool) {
275         uint rate = TVCrowdsale(TVCrowdsaleAddress).currentRate();
276         uint priceWei = priceList[_id] / rate;
277         require(priceWei == msg.value);
278 
279         TVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
280         bytes memory data = toBytes(_id);
281         checkAndBuySender = msg.sender;
282         TVToken(TVTokenAddress).safeTransfer(this, priceList[_id], data);
283         return true;
284     }
285 
286     function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
287         TVTokenAddress = newAddress;
288     }
289 
290     function changeTVCrowdsaleAddress(address newAddress) public onlyOwnerOrManager {
291         TVCrowdsaleAddress = newAddress;
292     }
293 
294     function setManager(address _manager) public onlyOwner {
295         manager = _manager;
296     }
297 
298     function convertBytesToBytes32(bytes inBytes) internal pure returns (bytes32 out) {
299         if (inBytes.length == 0) {
300             return 0x0;
301         }
302 
303         assembly {
304             out := mload(add(inBytes, 32))
305         }
306     }
307 
308     function toBytes(uint256 x) internal pure returns (bytes b) {
309         b = new bytes(32);
310         assembly {mstore(add(b, 32), x)}
311     }
312 }