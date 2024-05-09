1 pragma solidity ^0.4.18;
2 
3 contract ERC721 {
4 
5     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
6 
7     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
8 
9     function balanceOf(address _owner) public view returns (uint256 _balance);
10 
11     function ownerOf(uint256 _tokenId) public view returns (address _owner);
12 
13     function transfer(address _to, uint256 _tokenId) public;
14 
15     function approve(address _to, uint256 _tokenId) public;
16 
17     function takeOwnership(uint256 _tokenId) public;
18 }
19 
20 contract CryptoMemes is ERC721 {
21 
22     event Transfer(address from, address to, uint256 tokenId);
23     event Created(address owner, uint256 tokenId, string url, uint256 hash, uint256 createdAt);
24     event UrlUpdated(address owner, uint256 tokenId, string url);
25 
26     modifier onlyOwnerOf(uint256 tokenId) {
27         require(memeIndexToOwner[tokenId] == msg.sender);
28         _;
29     }
30 
31     modifier onlyOwnerOfContract() {
32         require(msg.sender == contractOwner);
33         _;
34     }
35 
36     struct Meme {
37         string url;
38         uint256 hash;
39         uint256 createdAt;
40     }
41 
42     Meme[] memes;
43 
44     //the owner can adjust the meme price
45     address contractOwner;
46 
47     //the price user must pay to create a meme
48     uint price;
49 
50     mapping(uint256 => address) memeIndexToOwner;
51     mapping(address => uint256) ownershipTokenCount;
52     mapping(uint => address) memeApprovals;
53 
54     function CryptoMemes() public {
55         contractOwner = msg.sender;
56         price = 0.005 ether;
57     }
58 
59     function getPrice() external view returns (uint) {
60         return price;
61     }
62 
63     function getContractOwner() external view returns (address) {
64         return contractOwner;
65     }
66 
67     function _transfer(address _from, address _to, uint256 _tokenId) internal {
68         ownershipTokenCount[_to]++;
69         ownershipTokenCount[_from]--;
70         memeIndexToOwner[_tokenId] = _to;
71         delete memeApprovals[_tokenId];
72         Transfer(_from, _to, _tokenId);
73     }
74 
75     function _createMeme(string _url, uint256 _hash, address _owner) internal returns (uint256) {
76         uint256 newMemeId = memes.push(Meme({url : _url, hash : _hash, createdAt : now})) - 1;
77         Created(_owner, newMemeId, _url, _hash, now);
78         _transfer(0, _owner, newMemeId);
79         return newMemeId;
80     }
81 
82     function createMeme(string _url, uint256 _hash) payable external {
83         _validateUrl(_url);
84         require(msg.value == price);
85         _createMeme(_url, _hash, msg.sender);
86     }
87 
88     //validates the url cannot be of ambiguous length
89     function _validateUrl(string _url) pure internal {
90         require(bytes(_url).length < 1024);
91     }
92 
93     function getMeme(uint256 _tokenId) public view returns (
94         string url,
95         uint256 hash,
96         uint256 createdAt
97     ) {
98         Meme storage meme = memes[_tokenId];
99         url = meme.url;
100         hash = meme.hash;
101         createdAt = meme.createdAt;
102     }
103 
104     function updateMemeUrl(uint256 _tokenId, string _url) external onlyOwnerOf(_tokenId) {
105         _validateUrl(_url);
106         memes[_tokenId].url = _url;
107         UrlUpdated(msg.sender, _tokenId, _url);
108     }
109 
110     function totalSupply() public view returns (uint256 total) {
111         return memes.length;
112     }
113 
114     function balanceOf(address _owner) public view returns (uint256 balance) {
115         return ownershipTokenCount[_owner];
116     }
117 
118     function ownerOf(uint256 _tokenId) public view returns (address owner) {
119         return memeIndexToOwner[_tokenId];
120     }
121 
122     function approve(address _to, uint256 _tokenId) onlyOwnerOf(_tokenId) public {
123         memeApprovals[_tokenId] = _to;
124         Approval(msg.sender, _to, _tokenId);
125     }
126 
127     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
128         _transfer(msg.sender, _to, _tokenId);
129     }
130 
131     function takeOwnership(uint256 _tokenId) public {
132         require(memeApprovals[_tokenId] == msg.sender);
133         address owner = ownerOf(_tokenId);
134         _transfer(owner, msg.sender, _tokenId);
135     }
136 
137     function updatePrice(uint _price) external onlyOwnerOfContract() {
138         price = _price;
139     }
140 
141     function transferContractOwnership(address _newOwner) external onlyOwnerOfContract() {
142         contractOwner = _newOwner;
143     }
144 
145     function withdraw() external onlyOwnerOfContract() {
146         contractOwner.transfer(address(this).balance);
147     }
148 }