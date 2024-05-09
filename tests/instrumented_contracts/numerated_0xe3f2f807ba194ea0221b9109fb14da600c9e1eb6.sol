1 pragma solidity ^0.4.24;
2 
3 interface ERC721Receiver {
4 
5     function onERC721Received(address operator, address from, uint tokenId, bytes data) external returns (bytes4);
6 }
7 
8 contract Emojisan {
9 
10     event Transfer(address indexed from, address indexed to, uint indexed tokenId);
11     event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
12     event ApprovalForAll(address indexed owner, address indexed operator, bool value);
13 
14     string public constant name = "emojisan.github.io";
15     string public constant symbol = "EMJS";
16     address public minter;
17     mapping (bytes4 => bool) public supportsInterface;
18     mapping (uint => address) private tokenToOwner;
19     uint public totalSupply;
20     uint[] public tokenByIndex;
21     mapping (address => uint[]) public tokenOfOwnerByIndex;
22     mapping (address => mapping (uint => uint)) private indexInTokenOfOwnerByIndex;
23     mapping (uint => address) public getApproved;
24     mapping (address => mapping (address => bool)) public isApprovedForAll;
25 
26     constructor() public {
27         minter = msg.sender;
28         supportsInterface[0x01ffc9a7] = true;
29         supportsInterface[0x80ac58cd] = true;
30         supportsInterface[0x780e9d63] = true;
31         supportsInterface[0x5b5e139f] = true;
32     }
33 
34     function ownerOf(uint tokenId) external view returns (address) {
35         address owner = tokenToOwner[tokenId];
36         require(owner != 0);
37         return owner;
38     }
39 
40     function tokens() external view returns (uint[]) {
41         return tokenByIndex;
42     }
43 
44     function tokensOfOwner(address owner) external view returns (uint[]) {
45         return tokenOfOwnerByIndex[owner];
46     }
47 
48     function balanceOf(address owner) external view returns (uint) {
49         return tokenOfOwnerByIndex[owner].length;
50     }
51 
52     function tokenURI(uint tokenId) public view returns (string) {
53         require(tokenToOwner[tokenId] != 0);
54         bytes memory base = "https://raw.githubusercontent.com/emojisan/data/master/tkn/";
55         uint length = 0;
56         uint tmp = tokenId;
57         do {
58             tmp /= 62;
59             length++;
60         } while (tmp != 0);
61         bytes memory uri = new bytes(base.length + length);
62         for (uint i = 0; i < base.length; i++) {
63             uri[i] = base[i];
64         }
65         do {
66             length--;
67             tmp = tokenId % 62;
68             if (tmp < 10) tmp += 48;
69             else if (tmp < 36) tmp += 55;
70             else tmp += 61;
71             uri[base.length + length] = bytes1(tmp);
72             tokenId /= 62;
73         } while (length != 0);
74         return string(uri);
75     }
76 
77     function transferFrom(address from, address to, uint tokenId) public {
78         require(to != address(this));
79         require(to != 0);
80         address owner = tokenToOwner[tokenId];
81         address approved = getApproved[tokenId];
82         require(from == owner);
83         require(msg.sender == owner || msg.sender == approved || isApprovedForAll[owner][msg.sender]);
84         tokenToOwner[tokenId] = to;
85         uint index = indexInTokenOfOwnerByIndex[from][tokenId];
86         uint lastIndex = tokenOfOwnerByIndex[from].length - 1;
87         if (index != lastIndex) {
88             uint lastTokenId = tokenOfOwnerByIndex[from][lastIndex];
89             tokenOfOwnerByIndex[from][index] = lastTokenId;
90             indexInTokenOfOwnerByIndex[from][lastTokenId] = index;
91         }
92         tokenOfOwnerByIndex[from].length--;
93         uint length = tokenOfOwnerByIndex[to].push(tokenId);
94         indexInTokenOfOwnerByIndex[to][tokenId] = length - 1;
95         if (approved != 0) {
96             delete getApproved[tokenId];
97         }
98         emit Transfer(from, to, tokenId);
99     }
100 
101     function safeTransferFrom(address from, address to, uint tokenId, bytes data) public {
102         transferFrom(from, to, tokenId);
103         uint size;
104         assembly { size := extcodesize(to) }
105         if (size != 0) {
106             bytes4 magic = ERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data);
107             require(magic == 0x150b7a02);
108         }
109     }
110 
111     function safeTransferFrom(address from, address to, uint tokenId) external {
112         safeTransferFrom(from, to, tokenId, "");
113     }
114 
115     function approve(address approved, uint tokenId) external {
116         address owner = tokenToOwner[tokenId];
117         require(msg.sender == owner || isApprovedForAll[owner][msg.sender]);
118         getApproved[tokenId] = approved;
119         emit Approval(owner, approved, tokenId);
120     }
121 
122     function setApprovalForAll(address operator, bool value) external {
123         isApprovedForAll[msg.sender][operator] = value;
124         emit ApprovalForAll(msg.sender, operator, value);
125     }
126 
127     function mint(uint tokenId) external {
128         require(msg.sender == minter);
129         require(tokenToOwner[tokenId] == 0);
130         tokenToOwner[tokenId] = msg.sender;
131         totalSupply++;
132         tokenByIndex.push(tokenId);
133         uint length = tokenOfOwnerByIndex[msg.sender].push(tokenId);
134         indexInTokenOfOwnerByIndex[msg.sender][tokenId] = length - 1;
135         emit Transfer(0, msg.sender, tokenId);
136     }
137 
138     function setMinter(address newMinter) external {
139         require(msg.sender == minter);
140         minter = newMinter;
141     }
142 }