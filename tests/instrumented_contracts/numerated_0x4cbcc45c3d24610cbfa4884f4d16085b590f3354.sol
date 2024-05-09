1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // Open0x Ownable (by 0xInuarashi)
5 abstract contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
8     constructor() { owner = msg.sender; }
9     modifier onlyOwner {
10         require(owner == msg.sender, "Ownable: caller is not the owner");
11         _;
12     }
13     function _transferOwnership(address newOwner_) internal virtual {
14         address _oldOwner = owner;
15         owner = newOwner_;
16         emit OwnershipTransferred(_oldOwner, newOwner_);    
17     }
18     function transferOwnership(address newOwner_) public virtual onlyOwner {
19         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
20         _transferOwnership(newOwner_);
21     }
22     function renounceOwnership() public virtual onlyOwner {
23         _transferOwnership(address(0x0));
24     }
25 }
26 
27 interface iCT {
28 
29     struct ownerAndStake {
30         address owner;
31         uint40 timestamp;
32     }
33     
34     function totalSupply() external view returns (uint256);
35     function _ownerOf(uint256 tokenId_) external view returns (ownerAndStake memory);
36     function ownerOf(uint256 tokenId_) external view returns (address);
37     function isStaked(uint256 tokenId_) external view returns (bool);
38     function tokenIdStartsAt() external view returns (uint256);
39 
40     function validateOwnershipOfTokens(address owner_, uint256[] calldata tokenIds_) 
41     external view returns (bool);
42     function validateOwnershipOfStakedTokens(address owner_,
43     uint256[] calldata tokenIds_) external view returns (bool);
44 
45     function stakeTurtles(uint256[] calldata tokenIds_) external;
46     function updateTurtles(uint256[] calldata tokenIds_) external;
47     function unstakeTurtles(uint256[] calldata tokenIds_) external;
48 
49     function tokenURI(uint256 tokenId_) external view returns (string memory);
50 }
51 
52 interface iShell {
53     function mint(address to_, uint256 amount_) external;
54 }
55 
56 // This is a proof-of-stake (token represents stake) contract
57 // Custom made with love by 0xInuarashi.eth
58 contract sCyberTurtles is Ownable {
59     string public name = "Staked Cyber Turtles";
60     string public symbol = "sCyber";
61 
62     // We largely interface with CyberTurtles
63     iCT public CT = iCT(0x81BC389D02c3054649643E590ce57fAAAB3BF38B); // note: change
64     function setCT(address address_) external onlyOwner {
65         CT = iCT(address_);
66     }
67 
68     iShell public SHELL = iShell(0x81BC389D02c3054649643E590ce57fAAAB3BF38B); // note: c
69     function setShell(address address_) external onlyOwner {
70         SHELL = iShell(address_);
71     }
72 
73     // Yield Info
74     uint256 public yieldStartTime = 1643670000; // 2021-01-31_18-00_EST
75     uint256 public yieldEndTime = 1959202800; // 10 years
76     uint256 public yieldRate = 100 ether;
77 
78     // Magic Events
79     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
80 
81     // Magic Logic
82     function totalSupply() public view returns (uint256) {
83         uint256 _totalSupply;
84         uint256 _startId = CT.tokenIdStartsAt();
85         for (uint256 i = _startId; i <= CT.totalSupply() + _startId; i++) {
86             if (CT.isStaked(i)) { _totalSupply++; }
87         }
88         return _totalSupply;
89     }
90 
91     function ownerOf(uint256 tokenId_) public view returns (address) {
92         iCT.ownerAndStake memory _ownerAndStake = CT._ownerOf(tokenId_);
93         address _owner = _ownerAndStake.timestamp > 0 ?
94              _ownerAndStake.owner : address(0);
95         return _owner;
96     }
97 
98     function balanceOf(address address_) public view returns (uint256) {
99         uint256 _startId = CT.tokenIdStartsAt();
100         uint256 _balance;
101         for (uint256 i = _startId; i <= CT.totalSupply() + _startId; i++) {
102             if (ownerOf(i) == address_) { _balance++; }
103         }
104         return _balance;
105     }
106 
107     // Internal Claim Function
108     function _getPendingTokens(uint256 tokenId_) internal view returns (uint256) {
109         uint256 _timestamp = uint256(CT._ownerOf(tokenId_).timestamp);
110         if (_timestamp == 0 || _timestamp > yieldEndTime) return 0;
111 
112         uint256 _timeCurrentOrEnded = yieldEndTime > block.timestamp ? 
113             block.timestamp : yieldEndTime;
114         uint256 _timeElapsed = _timeCurrentOrEnded - _timestamp;
115 
116         return (_timeElapsed * yieldRate) / 1 days;
117     }
118     function _getPendingTokensMany(uint256[] memory tokenIds_) internal view
119     returns (uint256) {
120         uint256 _pendingTokens;
121         for (uint256 i = 0; i < tokenIds_.length; i++) {
122             _pendingTokens += _getPendingTokens(tokenIds_[i]);
123         }
124         return _pendingTokens;
125     }
126 
127     function getPendingTokens(uint256 tokenId_) public view returns (uint256) {
128         return _getPendingTokens(tokenId_);
129     }
130     function getPendingTokensMany(uint256[] calldata tokenIds_) public view 
131     returns (uint256) {
132         return _getPendingTokensMany(tokenIds_);
133     }
134     function getPendingTokensOfAddress(address address_) public view 
135     returns (uint256) {
136         uint256[] memory _tokensOfAddress = walletOfOwner(address_);
137         return _getPendingTokensMany(_tokensOfAddress);
138     }
139 
140     function _claim(address to_, uint256[] memory tokenIds_) internal {
141         uint256 _pendingTokens;
142         for (uint256 i = 0; i < tokenIds_.length; i++) {
143             _pendingTokens += _getPendingTokens(tokenIds_[i]);
144         }
145         SHELL.mint(to_, _pendingTokens);
146     }
147 
148     function claim(uint256[] calldata tokenIds_) external {
149         require(CT.validateOwnershipOfStakedTokens(msg.sender, tokenIds_),
150             "You are not the owner or token is unstaked!");
151 
152         _claim(msg.sender, tokenIds_);
153         CT.updateTurtles(tokenIds_); // This updates the timestamp
154     }
155     function stakeTurtles(uint256[] calldata tokenIds_) external {
156         require(CT.validateOwnershipOfTokens(msg.sender, tokenIds_),
157             "You are not the owner or token is already staked!");
158 
159         CT.stakeTurtles(tokenIds_); // Set timestamp to block.timestamp
160 
161         for (uint256 i = 0; i < tokenIds_.length; i++) {
162             emit Transfer(address(0), msg.sender, tokenIds_[i]); // Mint sToken
163         }
164     }   
165     function unstakeTurtles(uint256[] calldata tokenIds_) external {
166         require(CT.validateOwnershipOfStakedTokens(msg.sender, tokenIds_),
167             "You are not the owner or token is unstaked!");
168 
169         _claim(msg.sender, tokenIds_);
170         CT.unstakeTurtles(tokenIds_); // Set timestamp to 0
171 
172         for (uint256 i = 0; i < tokenIds_.length; i++) {
173             emit Transfer(msg.sender, address(0), tokenIds_[i]); // Burn sToken
174         }
175     }
176 
177     function mintStakedTokenAsCyberTurtles(address to_, uint256 tokenId_) external {
178         require(msg.sender == address(CT), "You are not CT!");
179         emit Transfer(address(0), to_, tokenId_);
180     }
181 
182     function walletOfOwner(address address_) public virtual view 
183     returns (uint256[] memory) {
184         uint256 _balance = balanceOf(address_);
185         if (_balance == 0) return new uint256[](0);
186 
187         uint256[] memory _tokens = new uint256[] (_balance);
188         uint256 _index;
189         uint256 _loopThrough = CT.totalSupply() + 1;
190         for (uint256 i = 0; i < _loopThrough; i++) {
191             if (ownerOf(i) == address(0x0) && _tokens[_balance - 1] == 0) {
192                 _loopThrough++; 
193             }
194             if (ownerOf(i) == address_) { 
195                 _tokens[_index] = i; _index++; 
196             }
197         }
198         return _tokens;
199     }
200 
201     // TokenURI Stuff
202     string internal baseTokenURI; string internal baseTokenURI_EXT;
203     function _toString(uint256 value_) internal pure returns (string memory) {
204         if (value_ == 0) { return "0"; }
205         uint256 _iterate = value_; uint256 _digits;
206         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
207         bytes memory _buffer = new bytes(_digits);
208         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
209             48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
210         return string(_buffer); // return string converted bytes of value_
211     }
212     function setBaseTokenURI(string memory uri_) external onlyOwner {
213         baseTokenURI = uri_;
214     }
215     function setBaseTokenURI_EXT(string memory ext_) external onlyOwner {
216         baseTokenURI_EXT = ext_;
217     }
218     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
219         require(ownerOf(tokenId_) != address(0), 
220             "ERC721I: tokenURI() Token does not exist!");
221 
222         return string(abi.encodePacked(baseTokenURI, 
223             _toString(tokenId_), baseTokenURI_EXT));
224     }
225 
226     // OZ ERC721 Stuff
227     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
228         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
229     }
230 }