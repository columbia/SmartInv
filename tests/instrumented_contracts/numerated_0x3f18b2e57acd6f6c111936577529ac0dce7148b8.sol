1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC721 Non-Fungible Token Standard basic interface
5  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
6  */
7 contract ERC721Basic {
8   event Transfer(
9     address indexed _from,
10     address indexed _to,
11     uint256 _tokenId
12   );
13   event Approval(
14     address indexed _owner,
15     address indexed _approved,
16     uint256 _tokenId
17   );
18   event ApprovalForAll(
19     address indexed _owner,
20     address indexed _operator,
21     bool _approved
22   );
23 
24   function balanceOf(address _owner) public view returns (uint256 _balance);
25   function ownerOf(uint256 _tokenId) public view returns (address _owner);
26   function exists(uint256 _tokenId) public view returns (bool _exists);
27 
28   function approve(address _to, uint256 _tokenId) public;
29   function getApproved(uint256 _tokenId)
30     public view returns (address _operator);
31 
32   function setApprovalForAll(address _operator, bool _approved) public;
33   function isApprovedForAll(address _owner, address _operator)
34     public view returns (bool);
35 
36   function transferFrom(address _from, address _to, uint256 _tokenId) public;
37   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
38     public;
39 
40   function safeTransferFrom(
41     address _from,
42     address _to,
43     uint256 _tokenId,
44     bytes _data
45   )
46     public;
47 }
48 
49 /**
50  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
51  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
52  */
53 contract ERC721Enumerable is ERC721Basic {
54   function totalSupply() public view returns (uint256);
55   function tokenOfOwnerByIndex(
56     address _owner,
57     uint256 _index
58   )
59     public
60     view
61     returns (uint256 _tokenId);
62 
63   function tokenByIndex(uint256 _index) public view returns (uint256);
64 }
65 
66 /**
67  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
68  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
69  */
70 contract ERC721Metadata is ERC721Basic {
71   function name() public view returns (string _name);
72   function symbol() public view returns (string _symbol);
73   function tokenURI(uint256 _tokenId) public view returns (string);
74 }
75 
76 /**
77  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
78  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
79  */
80 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
81 }
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipRenounced(address indexed previousOwner);
93   event OwnershipTransferred(
94     address indexed previousOwner,
95     address indexed newOwner
96   );
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   constructor() public {
104     owner = msg.sender;
105   }
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipRenounced(owner);
120     owner = address(0);
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param _newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address _newOwner) public onlyOwner {
128     _transferOwnership(_newOwner);
129   }
130 
131   /**
132    * @dev Transfers control of the contract to a newOwner.
133    * @param _newOwner The address to transfer ownership to.
134    */
135   function _transferOwnership(address _newOwner) internal {
136     require(_newOwner != address(0));
137     emit OwnershipTransferred(owner, _newOwner);
138     owner = _newOwner;
139   }
140 }
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable is Ownable {
147   event Pause();
148   event Unpause();
149 
150   bool public paused = false;
151 
152 
153   /**
154    * @dev Modifier to make a function callable only when the contract is not paused.
155    */
156   modifier whenNotPaused() {
157     require(!paused);
158     _;
159   }
160 
161   /**
162    * @dev Modifier to make a function callable only when the contract is paused.
163    */
164   modifier whenPaused() {
165     require(paused);
166     _;
167   }
168 
169   /**
170    * @dev called by the owner to pause, triggers stopped state
171    */
172   function pause() onlyOwner whenNotPaused public {
173     paused = true;
174     emit Pause();
175   }
176 
177   /**
178    * @dev called by the owner to unpause, returns to normal state
179    */
180   function unpause() onlyOwner whenPaused public {
181     paused = false;
182     emit Unpause();
183   }
184 }
185 
186 /**
187  * @title Destructible
188  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
189  */
190 contract Destructible is Ownable {
191 
192   constructor() public payable { }
193 
194   /**
195    * @dev Transfers the current balance to the owner and terminates the contract.
196    */
197   function destroy() onlyOwner public {
198     selfdestruct(owner);
199   }
200 
201   function destroyAndSend(address _recipient) onlyOwner public {
202     selfdestruct(_recipient);
203   }
204 }
205 
206 
207 /**
208  * @title CryptoArteSales
209  * CryptoArteSales - a sales contract for CryptoArte non-fungible tokens 
210  * corresponding to paintings from the www.cryptoarte.io collection
211  */
212 contract CryptoArteSales is Ownable, Pausable, Destructible {
213 
214     event Sent(address indexed payee, uint256 amount, uint256 balance);
215     event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);
216 
217     ERC721 public nftAddress;
218     uint256 public currentPrice;
219 
220     /**
221     * @dev Contract Constructor
222     * @param _nftAddress address for Crypto Arte non-fungible token contract 
223     * @param _currentPrice initial sales price
224     */
225     constructor(address _nftAddress, uint256 _currentPrice) public { 
226         require(_nftAddress != address(0) && _nftAddress != address(this));
227         require(_currentPrice > 0);
228         nftAddress = ERC721(_nftAddress);
229         currentPrice = _currentPrice;
230     }
231 
232     /**
233     * @dev Purchase _tokenId
234     * @param _tokenId uint256 token ID (painting number)
235     */
236     function purchaseToken(uint256 _tokenId) public payable whenNotPaused {
237         require(msg.sender != address(0) && msg.sender != address(this));
238         require(msg.value >= currentPrice);
239         require(nftAddress.exists(_tokenId));
240         address tokenSeller = nftAddress.ownerOf(_tokenId);
241         nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
242         emit Received(msg.sender, _tokenId, msg.value, address(this).balance);
243     }
244 
245     /**
246     * @dev send / withdraw _amount to _payee
247     */
248     function sendTo(address _payee, uint256 _amount) public onlyOwner {
249         require(_payee != address(0) && _payee != address(this));
250         require(_amount > 0 && _amount <= address(this).balance);
251         _payee.transfer(_amount);
252         emit Sent(_payee, _amount, address(this).balance);
253     }    
254 
255     /**
256     * @dev Updates _currentPrice
257     * @dev Throws if _currentPrice is zero
258     */
259     function setCurrentPrice(uint256 _currentPrice) public onlyOwner {
260         require(_currentPrice > 0);
261         currentPrice = _currentPrice;
262     }        
263 
264 }