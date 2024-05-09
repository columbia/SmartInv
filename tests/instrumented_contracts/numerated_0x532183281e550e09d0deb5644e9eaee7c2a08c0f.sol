1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipRenounced(address indexed previousOwner);
15     event OwnershipTransferred(
16         address indexed previousOwner,
17         address indexed newOwner
18     );
19 
20 
21     /**
22      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23      * account.
24      */
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     /**
38      * @dev Allows the current owner to relinquish control of the contract.
39      */
40     function renounceOwnership() public onlyOwner {
41         emit OwnershipRenounced(owner);
42         owner = address(0);
43     }
44 
45     /**
46      * @dev Allows the current owner to transfer control of the contract to a newOwner.
47      * @param _newOwner The address to transfer ownership to.
48      */
49     function transferOwnership(address _newOwner) public onlyOwner {
50         _transferOwnership(_newOwner);
51     }
52 
53     /**
54      * @dev Transfers control of the contract to a newOwner.
55      * @param _newOwner The address to transfer ownership to.
56      */
57     function _transferOwnership(address _newOwner) internal {
58         require(_newOwner != address(0));
59         emit OwnershipTransferred(owner, _newOwner);
60         owner = _newOwner;
61     }
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
72     /**
73      * @dev Magic value to be returned upon successful reception of an NFT
74      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
75      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
76      */
77     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
78 
79     /**
80      * @notice Handle the receipt of an NFT
81      * @dev The ERC721 smart contract calls this function on the recipient
82      *  after a `safetransfer`. This function MAY throw to revert and reject the
83      *  transfer. This function MUST use 50,000 gas or less. Return of other
84      *  than the magic value MUST result in the transaction being reverted.
85      *  Note: the contract address is always the message sender.
86      * @param _from The sending address
87      * @param _tokenId The NFT identifier which is being transfered
88      * @param _data Additional data with no specified format
89      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
90      */
91     function onERC721Received(
92         address _from,
93         uint256 _tokenId,
94         bytes _data
95     )
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
107     event Transfer(
108         address indexed _from,
109         address indexed _to,
110         uint256 _tokenId
111     );
112     event Approval(
113         address indexed _owner,
114         address indexed _approved,
115         uint256 _tokenId
116     );
117     event ApprovalForAll(
118         address indexed _owner,
119         address indexed _operator,
120         bool _approved
121     );
122 
123     function balanceOf(address _owner) public view returns (uint256 _balance);
124     function ownerOf(uint256 _tokenId) public view returns (address _owner);
125     function exists(uint256 _tokenId) public view returns (bool _exists);
126 
127     function approve(address _to, uint256 _tokenId) public;
128     function getApproved(uint256 _tokenId)
129     public view returns (address _operator);
130 
131     function setApprovalForAll(address _operator, bool _approved) public;
132     function isApprovedForAll(address _owner, address _operator)
133     public view returns (bool);
134 
135     function transferFrom(address _from, address _to, uint256 _tokenId) public;
136     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
137     public;
138 
139     function safeTransferFrom(
140         address _from,
141         address _to,
142         uint256 _tokenId,
143         bytes _data
144     )
145     public;
146 }
147 
148 // File: contracts/BBMarketplace.sol
149 
150 contract BBMarketplace is Ownable, ERC721Receiver {
151     address public owner;
152     address public wallet;
153     uint public fee_percentage;
154     mapping (address => bool) public tokens;
155     mapping(address => bool) public managers;
156 
157     mapping(address => mapping(uint => uint)) public priceList;
158     mapping(address => mapping(uint => address)) public holderList;
159 
160     event Stored(uint indexed id, uint price, address seller, address token);
161     event Cancelled(uint indexed id, address seller, address token);
162     event Sold(uint indexed id, uint price, address seller, address buyer, address token);
163 
164     event TokenChanged(address token, bool enabled);
165     event WalletChanged(address old_wallet, address new_wallet);
166     event FeeChanged(uint old_fee, uint new_fee);
167 
168     modifier onlyOwnerOrManager() {
169         require(msg.sender == owner || managers[msg.sender]);
170         _;
171     }
172 
173     constructor(address _BBArtefactAddress, address _BBPackAddress, address _wallet, address _manager, uint _fee) public {
174         owner = msg.sender;
175         tokens[_BBArtefactAddress] = true;
176         tokens[_BBPackAddress] = true;
177         wallet = _wallet;
178         fee_percentage = _fee;
179         managers[_manager] = true;
180     }
181 
182     function setToken(address _token, bool enabled) public onlyOwnerOrManager {
183         tokens[_token] = enabled;
184         emit TokenChanged(_token, enabled);
185     }
186 
187     function setWallet(address _wallet) public onlyOwnerOrManager {
188         address old = wallet;
189         wallet = _wallet;
190         emit WalletChanged(old, wallet);
191     }
192 
193     function changeFeePercentage(uint _percentage) public onlyOwnerOrManager {
194         uint old = fee_percentage;
195         fee_percentage = _percentage;
196         emit FeeChanged(old, fee_percentage);
197     }
198 
199     function onERC721Received(address _from, uint _tokenId, bytes _data) public returns(bytes4) {
200         require(tokens[msg.sender]);
201 
202         uint _price = uint(convertBytesToBytes32(_data));
203 
204         require(_price > 0);
205 
206         priceList[msg.sender][_tokenId] = _price;
207         holderList[msg.sender][_tokenId] = _from;
208 
209         emit Stored(_tokenId, _price, _from, msg.sender);
210 
211         return ERC721Receiver.ERC721_RECEIVED;
212     }
213 
214     function cancel(uint _id, address _token) public returns (bool) {
215         require(holderList[_token][_id] == msg.sender || managers[msg.sender]);
216 
217         delete holderList[_token][_id];
218         delete priceList[_token][_id];
219 
220         ERC721Basic(_token).safeTransferFrom(this, msg.sender, _id);
221 
222         emit Cancelled(_id, msg.sender, _token);
223 
224         return true;
225     }
226 
227     function buy(uint _id, address _token) public payable returns (bool) {
228         require(priceList[_token][_id] == msg.value);
229 
230         address oldHolder = holderList[_token][_id];
231         uint price = priceList[_token][_id];
232 
233         uint toWallet = price / 100 * fee_percentage;
234         uint toHolder = price - toWallet;
235 
236         delete holderList[_token][_id];
237         delete priceList[_token][_id];
238 
239         ERC721Basic(_token).safeTransferFrom(this, msg.sender, _id);
240         wallet.transfer(toWallet);
241         oldHolder.transfer(toHolder);
242 
243         emit Sold(_id, price, oldHolder, msg.sender, _token);
244 
245         return true;
246     }
247 
248     function getPrice(uint _id, address _token) public view returns(uint) {
249         return priceList[_token][_id];
250     }
251 
252     function convertBytesToBytes32(bytes inBytes) internal returns (bytes32 out) {
253         if (inBytes.length == 0) {
254             return 0x0;
255         }
256 
257         assembly {
258             out := mload(add(inBytes, 32))
259         }
260     }
261 
262     function setManager(address _manager, bool enable) public onlyOwner {
263         managers[_manager] = enable;
264     }
265 }