1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.13;
3 
4 error CallerNotOwner();
5 error NewOwnerAddressZero();
6 
7 abstract contract ERC1155SingleTokenPausable {
8 
9     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 amount);
10     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
11     event URI(string value, uint256 indexed id);
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     mapping(address => mapping(uint256 => uint256)) private _balanceOf;
15     mapping(address => mapping(address => bool)) private _isApprovedForAll;
16 
17     string public name;
18     string public symbol;
19     address public owner;
20     bool public isPaused;
21 
22     constructor (string memory _name, string memory _symbol){
23         name = _name;
24         symbol = _symbol;
25         _transferOwnership(msg.sender);
26     }
27 
28     function uri(uint256 id) public view virtual returns (string memory);
29 
30     function balanceOf(address _address, uint256 id) public view returns (uint256) {
31         return _balanceOf[_address][id];
32     }
33     
34     function isApprovedForAll(address _owner, address operator) public view returns (bool) {
35         return  _isApprovedForAll[_owner][operator];
36     }
37 
38     function setApprovalForAll(address operator, bool approved) public {
39         _isApprovedForAll[msg.sender][operator] = approved;
40         emit ApprovalForAll(msg.sender, operator, approved);
41     }
42 
43     function transferFrom(address from, address to, uint256 id, uint256 amount) public {
44         require(!isPaused, "RocketPass is currently locked.");
45         require(msg.sender == from || _isApprovedForAll[from][msg.sender], "Lacks Permissions");
46 
47         _balanceOf[from][id] -= amount;
48         _balanceOf[to][id] += amount;
49 
50         emit TransferSingle(msg.sender, from, to, 1, amount);
51     }
52 
53     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) public {
54         transferFrom(from, to, id, amount);
55         require(to.code.length == 0 ? to != address(0)
56                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) ==
57                     ERC1155TokenReceiver.onERC1155Received.selector,
58             "Unsafe Destination"
59         );
60     }
61 
62     function _mint(address to, uint256 amount) internal {
63         _balanceOf[to][1] += amount;
64         emit TransferSingle(msg.sender, address(0), to, 1, amount);
65     }
66 
67     function _safeMint(address to, uint256 amount, bytes memory data) internal {
68         _mint(to, amount);
69         require(to.code.length == 0 ? to != address(0)
70                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), 1, amount, data) ==
71                     ERC1155TokenReceiver.onERC1155Received.selector,
72             "Unsafe Destination"
73         );
74     }
75 
76     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
77         return
78             interfaceId == 0x01ffc9a7 ||
79             interfaceId == 0xd9b67a26 ||
80             interfaceId == 0x0e89341c;
81     }
82 
83     function flipPauseState() external onlyOwner {
84         if (isPaused){
85             delete isPaused; 
86         } else {
87             isPaused = true;
88         }
89     }
90 
91     function renounceOwnership() public onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     function transferOwnership(address newOwner) public onlyOwner {
96         if (newOwner == address(0)) revert NewOwnerAddressZero();
97         _transferOwnership(newOwner);
98     }
99 
100     function _transferOwnership(address newOwner) internal {
101         address oldOwner = owner;
102         owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 
106     modifier onlyOwner() {
107         if (owner != msg.sender) revert CallerNotOwner();
108         _;
109     }
110 
111 }
112 
113 abstract contract ERC1155TokenReceiver {
114     function onERC1155Received(address, address, uint256, uint256, bytes calldata) external virtual returns (bytes4) {
115         return ERC1155TokenReceiver.onERC1155Received.selector;
116     }
117 
118 }
119 
120 interface IOGMiner {
121     function balanceOf(address owner) external view returns (uint256);
122 }
123 
124 interface IHASH{
125     function balanceOf(address account) external view returns (uint256);
126     function burnHash(uint256 _amount) external;
127     function approve(address spender, uint256 amount) external returns (bool);
128     function allowance(address owner, address spender) external view returns (uint256);
129     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
130 }
131 
132 contract RocketPass is ERC1155SingleTokenPausable {
133 
134     uint256 public constant hashPrice = 600 ether;
135     uint256 public constant ethOGPrice = .05 ether;
136     uint256 public constant ethRLPrice = .069 ether;
137 
138     uint256 public stateHashMint;
139     uint256 public stateEthMint;
140 
141     bytes32 public RLMerkleRoot;
142     string public passURI = "ipfs://QmbtHrneD8JnBtS5YFPfjaiXKexhs3DkYzP3SKg9ypqpVY";
143     bool public permanentlyClosedMint;
144 
145     IOGMiner public og;
146     IHASH public hashpower;
147 
148     mapping(address => uint256) public OGMints;
149     mapping(address => uint256) public RLMints;
150 
151     constructor(address _hContract, address _ogContract) ERC1155SingleTokenPausable("BMC Rocket Pass", "RKTPASS"){
152         og = IOGMiner(_ogContract);
153         hashpower = IHASH(_hContract);
154         _mint(msg.sender, 100);
155     }
156 
157     modifier onlyHuman() {
158         require(tx.origin == msg.sender && msg.sender.code.length == 0, "No Contracts");
159         _;
160     }
161 
162     function mintWithHash(uint256 _amount) external onlyHuman {
163         require(stateHashMint > 0, "Sale Closed");
164         uint256 hashToBurn = hashPrice*_amount;
165         require(hashpower.balanceOf(msg.sender)>=hashToBurn, "Not enough Hash Owned");
166         require(hashpower.allowance(msg.sender, address(this)) >= hashToBurn, "Insufficient allowed hash");
167 
168         hashpower.transferFrom(msg.sender, address(this), hashToBurn);
169         _mint(msg.sender, _amount);
170     }
171 
172     function mintWithOG(uint256 _amount) external payable onlyHuman {
173         require(stateEthMint > 0, "Sale Closed");
174         require(og.balanceOf(msg.sender) - OGMints[msg.sender] > 0, "No Remaining OG Mints");
175         uint256 costEth = ethOGPrice * _amount;
176 
177         require(msg.value >= costEth, "Not enough Eth attached");
178         unchecked { // Cannot overflow since we checked they have sufficient OG balance and ETH
179             OGMints[msg.sender] += _amount;
180         }
181         _mint(msg.sender, _amount);
182 
183     }
184 
185     function mintRL(bytes32[] calldata _proof) external payable onlyHuman {
186         require(stateEthMint > 0, "Sale Closed");
187         require(verifyRL(_proof, RLMerkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not on ML");
188         require(RLMints[msg.sender] == 0, "Already ML Minted");
189         require(msg.value >= ethRLPrice, "Not enough Eth attached");
190 
191         RLMints[msg.sender]++;
192         _mint(msg.sender, 1);
193     }
194 
195     function setState(uint256 _category, uint256 _value) external onlyOwner {
196         bool adjusted;
197         require(!permanentlyClosedMint, "Mint states permanently locked");
198         if (_category == 0){
199             stateHashMint = _value;
200             adjusted = true;
201         }
202 
203         if (_category == 1){
204             stateEthMint = _value;
205             adjusted = true;
206         }
207         require(adjusted, "Incorrect parameters");
208     }
209 
210     function permanentlyCloseMint() external onlyOwner {
211         require(!permanentlyClosedMint, "Already permanently locked");
212         delete stateHashMint;
213         delete stateEthMint;
214         permanentlyClosedMint = true;
215     }
216 
217     function BurnTheHash() external onlyOwner {
218         hashpower.burnHash(hashpower.balanceOf(address(this)));
219     }
220 
221     function setURI(string calldata _newURI) external onlyOwner {
222         passURI = _newURI;
223         emit URI(_newURI, 1);
224     }
225 
226     function setRoot(bytes32 _newROOT) external onlyOwner {
227         RLMerkleRoot = _newROOT;
228     }
229 
230     function setHASHPOWER(address _address) external onlyOwner {
231         hashpower = IHASH(_address);
232     }
233 
234     function setOG(address _address) external onlyOwner {
235         og = IOGMiner(_address);
236     }
237 
238     function verifyHashBalance(address _address) public view returns (bool){
239         return (hashpower.balanceOf(_address) - hashPrice) > 0;
240     }
241 
242     function verifyHashApproved(address _address) public view returns (bool){
243         return hashpower.allowance(_address, address(this)) >= hashPrice;
244     }
245     
246     function verifyOG(address _address) public view returns (bool){
247         return (og.balanceOf(_address) - OGMints[_address]) > 0;
248     }
249 
250     function verifyRL(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
251         bytes32 computedHash = leaf;
252 
253         uint256 iterations = proof.length;
254         for (uint256 i; i < iterations; i++) {
255             bytes32 proofElement = proof[i];
256 
257             if (computedHash <= proofElement) {
258                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
259             } else {
260                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
261             }
262         }
263         return computedHash == root;
264     }
265 
266     function uri(uint256 id) public view override returns (string memory){
267         return passURI;
268     }
269 
270     function withdrawFunding() external onlyOwner {
271         uint256 currentBalance = address(this).balance;
272         (bool sent, ) = address(msg.sender).call{value: currentBalance}('');
273         require(sent,"Error while transferring balance");    
274   }
275 
276 }