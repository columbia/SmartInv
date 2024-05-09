1 pragma solidity ^0.4.21;
2 
3 contract TokenInterface {
4     function transfer(address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Kitty {
8     function ownerOf(uint256 _tokenId) external view returns (address owner);
9     function getKitty(uint256 _id) external view returns (
10         bool isGestating,
11         bool isReady,
12         uint256 cooldownIndex,
13         uint256 nextActionAt,
14         uint256 siringWithId,
15         uint256 birthTime,
16         uint256 matronId,
17         uint256 sireId,
18         uint256 generation,
19         uint256 genes
20     );
21 }
22 
23 contract Ownable {
24     address owner;
25     Kitty kitty;
26 
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address _newOwner) external onlyOwner {
37         require(_newOwner != address(0));
38         owner = _newOwner;
39     }
40 
41     function () external payable {
42         owner.transfer(address(this).balance);
43     }
44 
45     function getTokens(address _contract, uint256 _amount) external {
46         TokenInterface(_contract).transfer(owner, _amount);
47     }
48 
49     function setKitty(address _contract) external onlyOwner {
50         kitty = Kitty(_contract);
51     }
52 }
53 
54 contract Token {
55     string public constant name = "Crypto Shrooms"; // ERC-721
56     string public constant symbol = "SHRM"; // ERC-721
57     uint256[] public tokenIdToDna;
58     mapping (address => uint256) public balanceOf; // ERC-721
59     mapping (uint256 => address) public tokenIdToApproved;
60     mapping (uint256 => address) tokenIdToOwner;
61 
62     event Transfer(address from, address to, uint256 tokenId); // ERC-721
63     event Approval(address owner, address approved, uint256 tokenId); // ERC-721
64 
65     constructor() public {
66         tokenIdToDna.push(0);
67     }
68 
69     // ERC-721
70     function totalSupply() public view returns(uint256) {
71         return tokenIdToDna.length - 1;
72     }
73 
74     // ERC-721
75     function ownerOf(uint256 _tokenId) external view returns (address owner) {
76         owner = tokenIdToOwner[_tokenId];
77         require(owner != address(0));
78     }
79 
80     // ERC-721
81     function approve(address _to, uint256 _tokenId) external {
82         require(msg.sender != address(0));
83         require(tokenIdToOwner[_tokenId] == msg.sender);
84         tokenIdToApproved[_tokenId] = _to;
85         emit Approval(msg.sender, _to, _tokenId);
86     }
87 
88     // ERC-721
89     function transfer(address _to, uint256 _tokenId) external {
90         require(msg.sender != address(0));
91         require(tokenIdToOwner[_tokenId] == msg.sender);
92         require(_to != address(0));
93         balanceOf[msg.sender]--;
94         tokenIdToOwner[_tokenId] = _to;
95         balanceOf[_to]++;
96         delete tokenIdToApproved[_tokenId];
97         emit Transfer(msg.sender, _to, _tokenId);
98     }
99 
100     // ERC-721
101     function transferFrom(address _from, address _to, uint256 _tokenId) external {
102         require(msg.sender != address(0));
103         require(tokenIdToApproved[_tokenId] == msg.sender);
104         require(_from != address(0));
105         require(tokenIdToOwner[_tokenId] == _from);
106         require(_to != address(0));
107         balanceOf[_from]--;
108         tokenIdToOwner[_tokenId] = _to;
109         balanceOf[_to]++;
110         delete tokenIdToApproved[_tokenId];
111         emit Transfer(_from, _to, _tokenId);
112     }
113 
114     // ERC-721
115     function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds) {
116         uint256 tokenCount = balanceOf[_owner];
117         if (tokenCount == 0) {
118             return new uint256[](0);
119         } else {
120             uint256[] memory result = new uint256[](tokenCount);
121             uint256 total = tokenIdToDna.length - 1;
122             uint256 resultIndex = 0;
123             for (uint i = 1; i <= total; i++) {
124                 if (tokenIdToOwner[i] == _owner) {
125                     result[resultIndex] = i;
126                     resultIndex++;
127                 }
128             }
129             return result;
130         }
131     }
132 
133     function _create(uint256 _dna, address _owner) internal {
134         uint256 tokenId = tokenIdToDna.push(_dna) - 1;
135         tokenIdToOwner[tokenId] = _owner;
136         balanceOf[_owner]++;
137         emit Transfer(address(this), _owner, tokenId);
138     }
139 
140     function _move(uint256 _tokenId, address _from, address _to) internal {
141         balanceOf[_from]--;
142         tokenIdToOwner[_tokenId] = _to;
143         balanceOf[_to]++;
144         delete tokenIdToApproved[_tokenId];
145         emit Transfer(_from, _to, _tokenId);
146     }
147 }
148 
149 contract Shroom is Ownable, Token {
150     mapping (uint256 => bool) public kittyIdToDead;
151     mapping (uint256 => uint256) shroomIdToPrice;
152     uint256 salt;
153 
154     event SaleCreated(uint256 shroomId, uint256 price);
155     event SaleSuccessful(uint256 shroomId);
156     event SaleCancelled(uint256 shroomId);
157 
158     constructor() public {
159         salt = now;
160     }
161 
162     function getNewShroom(uint256 _kittyId) external {
163         require(msg.sender != address(0));
164         require(!kittyIdToDead[_kittyId]);
165         require(kitty.ownerOf(_kittyId) == msg.sender);
166         uint256 dna;
167         (,,,,,,,,,dna) = kitty.getKitty(_kittyId);
168         require(dna != 0);
169         salt++;
170         dna = uint256(keccak256(dna + salt + now));
171         kittyIdToDead[_kittyId] = true;
172         _create(dna, msg.sender);
173     }
174 
175     function createSale(uint256 _shroomId, uint256 _price) external {
176         address currentOwner = tokenIdToOwner[_shroomId];
177         require(currentOwner != address(0));
178         require(currentOwner == msg.sender);
179         shroomIdToPrice[_shroomId] = _price;
180         emit SaleCreated(_shroomId, _price);
181     }
182 
183     function buy(uint256 _shroomId) external payable {
184         address newOwner = msg.sender;
185         require(newOwner != address(0));
186         address currentOwner = tokenIdToOwner[_shroomId];
187         require(currentOwner != address(0));
188         uint256 price = shroomIdToPrice[_shroomId];
189         require(price > 0);
190         require(msg.value >= price);
191         delete shroomIdToPrice[_shroomId];
192         currentOwner.transfer(price);
193         emit SaleSuccessful(_shroomId);
194         _move(_shroomId, currentOwner, newOwner);
195     }
196 
197     function cancelSale(uint256 _shroomId) external {
198         address currentOwner = tokenIdToOwner[_shroomId];
199         require(currentOwner != address(0));
200         require(currentOwner == msg.sender);
201         require(shroomIdToPrice[_shroomId] > 0);
202         delete shroomIdToPrice[_shroomId];
203         emit SaleCancelled(_shroomId);
204     }
205 
206     function getPrice(uint256 _shroomId) external view returns (uint256) {
207         uint256 price = shroomIdToPrice[_shroomId];
208         require(price > 0);
209         return price;
210     }
211 }