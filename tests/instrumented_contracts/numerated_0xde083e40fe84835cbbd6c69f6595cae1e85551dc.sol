1 pragma solidity ^0.4.11;
2 
3 contract LedgerLegendsToken {
4   address public owner;
5   mapping(address => bool) public minters;
6 
7   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
8   event Transfer(address indexed from, address indexed to, uint256 tokenId);
9   event Mint(address indexed owner, uint256 tokenId);
10 
11   uint256 public tokenIdCounter = 1;
12   mapping (uint256 => address) public tokenIdToOwner;
13   mapping (uint256 => bytes32) public tokenIdToData;
14   mapping (uint256 => address) public tokenIdToApproved;
15   mapping (address => uint256[]) public ownerToTokenIds;
16   mapping (uint256 => uint256) public tokenIdToOwnerArrayIndex;
17 
18   function LedgerLegendsToken() public {
19     owner = msg.sender;
20   }
21 
22   /* Admin */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   modifier onlyMinters() {
29     require(minters[msg.sender]);
30     _;
31   }
32   
33   function setOwner(address _owner) onlyOwner() public {
34     owner = _owner;
35   }
36 
37   function addMinter(address _minter) onlyOwner() public {
38     minters[_minter] = true;
39   }
40 
41   function removeMinter(address _minter) onlyOwner() public {
42     delete minters[_minter];
43   }
44 
45   /* Internal */
46   function _addTokenToOwnersList(address _owner, uint256 _tokenId) internal {
47     ownerToTokenIds[_owner].push(_tokenId);
48     tokenIdToOwnerArrayIndex[_tokenId] = ownerToTokenIds[_owner].length - 1;
49   }
50 
51   function _removeTokenFromOwnersList(address _owner, uint256 _tokenId) internal {
52     uint256 length = ownerToTokenIds[_owner].length;
53     uint256 index = tokenIdToOwnerArrayIndex[_tokenId];
54     uint256 swapToken = ownerToTokenIds[_owner][length - 1];
55 
56     ownerToTokenIds[_owner][index] = swapToken;
57     tokenIdToOwnerArrayIndex[swapToken] = index;
58 
59     delete ownerToTokenIds[_owner][length - 1];
60     ownerToTokenIds[_owner].length--;
61   }
62 
63   function _transfer(address _from, address _to, uint256 _tokenId) internal {
64     require(tokenExists(_tokenId));
65     require(ownerOf(_tokenId) == _from);
66     require(_to != address(0));
67     require(_to != address(this));
68 
69     tokenIdToOwner[_tokenId] = _to;
70     delete tokenIdToApproved[_tokenId];
71 
72     _removeTokenFromOwnersList(_from, _tokenId);
73     _addTokenToOwnersList(_to, _tokenId);
74 
75     Transfer(msg.sender, _to, _tokenId);
76   }
77 
78   /* Minting */
79   function mint(address _owner, bytes32 _data) onlyMinters() public returns (uint256 tokenId) {
80     tokenId = tokenIdCounter;
81     tokenIdCounter += 1;
82     tokenIdToOwner[tokenId] = _owner;
83     tokenIdToData[tokenId] = _data;
84     _addTokenToOwnersList(_owner, tokenId);
85     Mint(_owner, tokenId);
86   }
87 
88   /* ERC721 */
89   function name() public pure returns (string) {
90     return "Ledger Legends Cards";
91   }
92 
93   function symbol() public pure returns (string) {
94     return "LLC";
95   }
96 
97   function totalSupply() public view returns (uint256) {
98     return tokenIdCounter - 1;
99   }
100 
101   function balanceOf(address _owner) public view returns (uint256) {
102     return ownerToTokenIds[_owner].length;
103   }
104 
105   function ownerOf(uint256 _tokenId) public view returns (address) {
106     return tokenIdToOwner[_tokenId];
107   }
108 
109   function approvedFor(uint256 _tokenId) public view returns (address) {
110     return tokenIdToApproved[_tokenId];
111   }
112 
113   function tokenExists(uint256 _tokenId) public view returns (bool) {
114     return _tokenId < tokenIdCounter;
115   }
116 
117   function tokenData(uint256 _tokenId) public view returns (bytes32) {
118     return tokenIdToData[_tokenId];
119   }
120 
121   function tokensOfOwner(address _owner) public view returns (uint256[]) {
122     return ownerToTokenIds[_owner];
123   }
124 
125   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
126     return ownerToTokenIds[_owner][_index];
127   }
128 
129   function approve(address _to, uint256 _tokenId) public {
130     require(msg.sender != _to);
131     require(tokenExists(_tokenId));
132     require(ownerOf(_tokenId) == msg.sender);
133 
134     if (_to == 0) {
135       if (tokenIdToApproved[_tokenId] != 0) {
136         delete tokenIdToApproved[_tokenId];
137         Approval(msg.sender, 0, _tokenId);
138       }
139     } else {
140       tokenIdToApproved[_tokenId] = _to;
141       Approval(msg.sender, _to, _tokenId);
142     }
143   }
144 
145   function transfer(address _to, uint256 _tokenId) public {
146     _transfer(msg.sender, _to, _tokenId);
147   }
148 
149   function transferFrom(address _from, address _to, uint256 _tokenId) public {
150     require(tokenIdToApproved[_tokenId] == msg.sender);
151     _transfer(_from, _to, _tokenId);
152   }
153 }