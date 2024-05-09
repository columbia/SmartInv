1 pragma solidity ^0.4.18;
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
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
44 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
45 contract ERC721 {
46     // Required methods
47     function totalSupply() public view returns (uint256 total);
48     function balanceOf(address _owner) public view returns (uint256 balance);
49     function ownerOf(uint256 _tokenId) external view returns (address owner);
50     function approve(address _to, uint256 _tokenId) external;
51     function transfer(address _to, uint256 _tokenId) external;
52     function transferFrom(address _from, address _to, uint256 _tokenId) external;
53     // Events
54     event Transfer(address from, address to, uint256 tokenId);
55     event Approval(address owner, address approved, uint256 tokenId);
56 
57     // Optional
58     // function name() public view returns (string name);
59     // function symbol() public view returns (string symbol);
60     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
61     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
62     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
63     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
64 }
65 
66 
67 
68   
69 
70 
71 
72 contract Exchange is Ownable {
73 
74     
75     //between 0-10000
76     //Default 0
77     uint256 public transFeeCut =  0;
78 
79     enum Errors {
80         ORDER_EXPIRED,
81         ORDER_FILLED,
82         ORDER_CACELD,
83         INSUFFICIENT_BALANCE_OR_ALLOWANCE
84     }
85 
86 
87     struct Order {
88         address maker; //买方
89         address taker;//卖方
90         address contractAddr; //买房商品合约地址
91         uint256 nftTokenId;//买房商品ID
92         uint256 tokenAmount;//价格
93         uint expirationTimestampInSec; //到期时间
94         bytes32 orderHash;
95     }
96 
97     event LogFill(
98         address indexed maker,
99         address taker,
100         address contractAddr,
101         uint256 nftTokenId,
102         uint tokenAmount,
103         bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair
104         bytes32 orderHash
105     );
106 
107     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
108 
109     function getOrderHash(address[3] orderAddresses, uint[4] orderValues)
110         public
111         constant
112         returns (bytes32)
113     {
114         return keccak256(
115             address(this),
116             orderAddresses[0], // maker
117             orderAddresses[1], // taker
118             orderAddresses[2], // contractAddr
119             orderValues[0],    // nftTokenId
120             orderValues[1],    // tokenAmount
121             orderValues[2],    // expirationTimestampInSec
122             orderValues[3]    // salt
123         );
124     }
125 
126 
127 
128     function isValidSignature(
129         address signer,
130         bytes32 hash,
131         uint8 v,
132         bytes32 r,
133         bytes32 s)
134         public
135         pure
136         returns (bool)
137     {
138         return signer == ecrecover(
139             keccak256("\x19Ethereum Signed Message:\n32", hash),
140             v,
141             r,
142             s
143         );
144     }
145 
146 
147 
148     function fillOrder(
149           address[3] orderAddresses,
150           uint[4] orderValues,
151           uint8 v,
152           bytes32 r,
153           bytes32 s)
154           public
155           payable
156     {
157 
158         Order memory order = Order({
159             maker: orderAddresses[0],
160             taker: orderAddresses[1],
161             contractAddr: orderAddresses[2],
162             nftTokenId: orderValues[0],
163             tokenAmount : orderValues[1],
164             expirationTimestampInSec: orderValues[2],
165             orderHash: getOrderHash(orderAddresses, orderValues)
166         });
167 
168 
169         if (msg.value < order.tokenAmount) {
170             LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);
171             return ;
172         }
173 
174 
175         require(msg.value >= order.tokenAmount);
176         require(order.taker == address(0) || order.taker == msg.sender);
177 
178 
179         require(order.tokenAmount > 0 );
180         require(isValidSignature(
181             order.maker,
182             order.orderHash,
183             v,
184             r,
185             s
186         ));
187 
188         if (block.timestamp >= order.expirationTimestampInSec) {
189             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
190             return ;
191         }
192 
193 
194         require( transferViaProxy ( order.contractAddr , order.maker,msg.sender , order.nftTokenId )  );
195 
196         uint256 transCut = _computeCut(order.tokenAmount);
197         order.maker.transfer(order.tokenAmount - transCut);
198         uint256 bidExcess = msg.value - order.tokenAmount;
199         //return
200         msg.sender.transfer(bidExcess);
201         LogFill(order.maker,msg.sender,order.contractAddr,order.nftTokenId,order.tokenAmount, keccak256(order.contractAddr),order.orderHash );
202     }
203 
204 
205     function transferViaProxy( address nftAddr, address maker ,address taker , uint256 nftId ) internal returns(bool) 
206     {
207     
208        ERC721(nftAddr).transferFrom( maker, taker , nftId ) ;
209        return true;
210     }
211 
212     function withdrawBalance() external onlyOwner{
213         uint256 balance = this.balance;
214         owner.transfer(balance);
215     }
216 
217     function setTransFeeCut(uint256 val) external onlyOwner {
218         require(val <= 10000);
219         transFeeCut = val;
220     }
221 
222     function _computeCut(uint256 _price) internal view returns (uint256) {
223         return _price * transFeeCut / 10000;
224     }
225 
226 }