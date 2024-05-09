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
33   function addMinter(address _minter) onlyOwner() public {
34     minters[_minter] = true;
35   }
36 
37   function removeMinter(address _minter) onlyOwner() public {
38     delete minters[_minter];
39   }
40 
41   /* Internal */
42   function _addTokenToOwnersList(address _owner, uint256 _tokenId) internal {
43     ownerToTokenIds[_owner].push(_tokenId);
44     tokenIdToOwnerArrayIndex[_tokenId] = ownerToTokenIds[_owner].length - 1;
45   }
46 
47   function _removeTokenFromOwnersList(address _owner, uint256 _tokenId) internal {
48     uint256 length = ownerToTokenIds[_owner].length;
49     uint256 index = tokenIdToOwnerArrayIndex[_tokenId];
50     uint256 swapToken = ownerToTokenIds[_owner][length - 1];
51 
52     ownerToTokenIds[_owner][index] = swapToken;
53     tokenIdToOwnerArrayIndex[swapToken] = index;
54 
55     delete ownerToTokenIds[_owner][length - 1];
56     ownerToTokenIds[_owner].length--;
57   }
58 
59   function _transfer(address _from, address _to, uint256 _tokenId) internal {
60     require(tokenExists(_tokenId));
61     require(ownerOf(_tokenId) == _from);
62     require(_to != address(0));
63     require(_to != address(this));
64 
65     tokenIdToOwner[_tokenId] = _to;
66     delete tokenIdToApproved[_tokenId];
67 
68     _removeTokenFromOwnersList(_from, _tokenId);
69     _addTokenToOwnersList(_to, _tokenId);
70 
71     Transfer(msg.sender, _to, _tokenId);
72   }
73 
74   /* Minting */
75   function mint(address _owner, bytes32 _data) onlyMinters() public returns (uint256 tokenId) {
76     tokenId = tokenIdCounter;
77     tokenIdCounter += 1;
78     tokenIdToOwner[tokenId] = _owner;
79     tokenIdToData[tokenId] = _data;
80     _addTokenToOwnersList(_owner, tokenId);
81     Mint(_owner, tokenId);
82   }
83 
84   /* ERC721 */
85   function name() public pure returns (string) {
86     return "Ledger Legends Cards";
87   }
88 
89   function symbol() public pure returns (string) {
90     return "LLC";
91   }
92 
93   function totalSupply() public view returns (uint256) {
94     return tokenIdCounter - 1;
95   }
96 
97   function balanceOf(address _owner) public view returns (uint256) {
98     return ownerToTokenIds[_owner].length;
99   }
100 
101   function ownerOf(uint256 _tokenId) public view returns (address) {
102     return tokenIdToOwner[_tokenId];
103   }
104 
105   function approvedFor(uint256 _tokenId) public view returns (address) {
106     return tokenIdToApproved[_tokenId];
107   }
108 
109   function tokenExists(uint256 _tokenId) public view returns (bool) {
110     return _tokenId < tokenIdCounter;
111   }
112 
113   function tokenData(uint256 _tokenId) public view returns (bytes32) {
114     return tokenIdToData[_tokenId];
115   }
116 
117   function tokensOfOwner(address _owner) public view returns (uint256[]) {
118     return ownerToTokenIds[_owner];
119   }
120 
121   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
122     return ownerToTokenIds[_owner][_index];
123   }
124 
125   function approve(address _to, uint256 _tokenId) public {
126     require(msg.sender != _to);
127     require(tokenExists(_tokenId));
128     require(ownerOf(_tokenId) == msg.sender);
129 
130     if (_to == 0) {
131       if (tokenIdToApproved[_tokenId] != 0) {
132         delete tokenIdToApproved[_tokenId];
133         Approval(msg.sender, 0, _tokenId);
134       }
135     } else {
136       tokenIdToApproved[_tokenId] = _to;
137       Approval(msg.sender, _to, _tokenId);
138     }
139   }
140 
141   function transfer(address _to, uint256 _tokenId) public {
142     _transfer(msg.sender, _to, _tokenId);
143   }
144 
145   function transferFrom(address _from, address _to, uint256 _tokenId) public {
146     require(tokenIdToApproved[_tokenId] == msg.sender);
147     _transfer(_from, _to, _tokenId);
148   }
149 }