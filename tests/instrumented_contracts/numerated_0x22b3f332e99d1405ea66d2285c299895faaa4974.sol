1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract ERC721Basic {
39   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
40   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
41   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
42 
43   function balanceOf(address _owner) public view returns (uint256 _balance);
44   function ownerOf(uint256 _tokenId) public view returns (address _owner);
45   function exists(uint256 _tokenId) public view returns (bool _exists);
46   
47   function approve(address _to, uint256 _tokenId) public;
48   function getApproved(uint256 _tokenId) public view returns (address _operator);
49   
50   function setApprovalForAll(address _operator, bool _approved) public;
51   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
52 
53   function transferFrom(address _from, address _to, uint256 _tokenId) public;
54   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
55   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
56 }
57 
58 contract ERC721Receiver {
59   /**
60    * @dev Magic value to be returned upon successful reception of an NFT
61    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
62    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
63    */
64   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
65 
66   /**
67    * @notice Handle the receipt of an NFT
68    * @dev The ERC721 smart contract calls this function on the recipient
69    *  after a `safetransfer`. This function MAY throw to revert and reject the
70    *  transfer. This function MUST use 50,000 gas or less. Return of other
71    *  than the magic value MUST result in the transaction being reverted.
72    *  Note: the contract address is always the message sender.
73    * @param _from The sending address 
74    * @param _tokenId The NFT identifier which is being transfered
75    * @param _data Additional data with no specified format
76    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
77    */
78   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
79 }
80 
81 contract DeusMarketplace is Ownable, ERC721Receiver {
82   address public owner;
83   address public wallet;
84   uint256 public fee_percentage;
85   ERC721Basic public token;
86   
87   mapping(uint256 => uint256) public priceList;
88   mapping(uint256 => address) public holderList;
89   
90   event Stored(uint256 indexed id, uint256 price, address seller);
91   event Cancelled(uint256 indexed id, address seller);
92   event Sold(uint256 indexed id, uint256 price, address seller, address buyer);
93   
94   event TokenChanged(address old_token, address new_token);
95   event WalletChanged(address old_wallet, address new_wallet);
96   event FeeChanged(uint256 old_fee, uint256 new_fee);
97   
98   function DeusMarketplace(address _token, address _wallet) public {
99     owner = msg.sender;
100     token = ERC721Basic(_token);
101     wallet = _wallet;
102     fee_percentage = 10;
103   }
104   
105   function setToken(address _token) public onlyOwner {
106     address old = token;
107     token = ERC721Basic(_token);
108     emit TokenChanged(old, token);
109   }
110   
111   function setWallet(address _wallet) public onlyOwner {
112     address old = wallet;
113     wallet = _wallet;
114     emit WalletChanged(old, wallet);
115   }
116   
117   function changeFeePercentage(uint256 _percentage) public onlyOwner {
118     uint256 old = fee_percentage;
119     fee_percentage = _percentage;
120     emit FeeChanged(old, fee_percentage);
121   }
122   
123   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4) {
124     require(msg.sender == address(token));
125     
126     uint256 _price = uint256(convertBytesToBytes32(_data));
127     
128     require(_price > 0);
129     
130     priceList[_tokenId] = _price;
131     holderList[_tokenId] = _from;
132   
133     emit Stored(_tokenId, _price, _from);
134     
135     return ERC721Receiver.ERC721_RECEIVED;
136   }
137   
138   function cancel(uint256 _id) public returns (bool) {
139     require(holderList[_id] == msg.sender);
140     
141     holderList[_id] = 0x0;
142     priceList[_id] = 0;
143     
144     token.safeTransferFrom(this, msg.sender, _id);
145   
146     emit Cancelled(_id, msg.sender);
147     
148     return true;
149   }
150   
151   function buy(uint256 _id) public payable returns (bool) {
152     require(priceList[_id] == msg.value);
153     
154     address oldHolder = holderList[_id];
155     uint256 price = priceList[_id];
156     
157     uint256 toWallet = price / 100 * fee_percentage;
158     uint256 toHolder = price - toWallet;
159     
160     holderList[_id] = 0x0;
161     priceList[_id] = 0;
162     
163     token.safeTransferFrom(this, msg.sender, _id);
164     wallet.transfer(toWallet);
165     oldHolder.transfer(toHolder);
166     
167     emit Sold(_id, price, oldHolder, msg.sender);
168     
169     return true;
170   }
171   
172   function getPrice(uint _id) public view returns(uint256) {
173     return priceList[_id];
174   }
175   
176   function convertBytesToBytes32(bytes inBytes) internal returns (bytes32 out) {
177     if (inBytes.length == 0) {
178       return 0x0;
179     }
180     
181     assembly {
182       out := mload(add(inBytes, 32))
183     }
184   }
185 }