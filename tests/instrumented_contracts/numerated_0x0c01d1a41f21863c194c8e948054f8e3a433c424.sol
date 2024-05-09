1 pragma solidity ^0.4.13;
2 
3 contract ERC721 {
4     function implementsERC721() public pure returns (bool);
5     function totalSupply() public view returns (uint256 total);
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function ownerOf(uint256 _tokenId) public view returns (address owner);
8     function approve(address _to, uint256 _tokenId) public;
9     function transferFrom(address _from, address _to, uint256 _tokenId) public;
10     function transfer(address _to, uint256 _tokenId) public;
11     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
12     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
13 
14     // Optional
15     // function name() public view returns (string name);
16     // function symbol() public view returns (string symbol);
17     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
18     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
19 }
20 
21 library SafeMath {
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two numbers, truncating the quotient.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return c;
42     }
43 
44     /**
45     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 contract TombAccessControl {
63     address public ownerAddress;
64 
65     modifier onlyOwner() {
66         require(msg.sender == ownerAddress);
67         _;
68     }
69 
70     function withdrawBalance() external onlyOwner {
71         address contractAddress = this;
72         ownerAddress.transfer(contractAddress.balance);
73     }
74 }
75 
76 contract TombBase is TombAccessControl {
77     using SafeMath for uint256;
78 
79     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
80     struct Tomb {
81         // The timestamp from the block when this tomb came into existence.
82         address sculptor;
83         string data;
84     }
85 
86     // An array containing all existing tomb
87     Tomb[] tombs;
88     mapping (uint => address) public tombToOwner;
89     mapping (address => uint) ownerTombCount;
90     mapping (uint => address) tombApprovals;
91 
92     function _transfer(address _from, address _to, uint256 _tokenId) internal {
93         tombToOwner[_tokenId] = _to;
94         ownerTombCount[_to] = ownerTombCount[_to].add(1);
95         if (_from != address(0)) {
96             ownerTombCount[_from] = ownerTombCount[_from].sub(1);
97             delete tombApprovals[_tokenId];
98         }
99         emit Transfer(_from, _to, _tokenId);
100     }
101 
102     function _createTombWithData(address _owner, string givenData) internal returns (uint) {
103         Tomb memory _tomb = Tomb({
104             data: givenData,
105             sculptor: _owner
106         });
107         uint256 newTombId = (tombs.push(_tomb)).sub(1);
108         _transfer(0, _owner, newTombId);
109         return newTombId;
110     }
111 
112     function getTombByOwner(address _owner) external view returns(uint[]) {
113         uint[] memory result = new uint[](ownerTombCount[_owner]);
114         uint counter = 0;
115         for (uint i = 0; i < tombs.length; i++) {
116             if (tombToOwner[i] == _owner) {
117                 result[counter] = i;
118                 counter++;
119             }
120         }
121         return result;
122     }
123 
124     function getAllTombs() external view returns(uint[]) {
125         uint[] memory result = new uint[](tombs.length);
126         for (uint i = 0; i < tombs.length; i++) {
127             result[i] = i;
128         }
129         return result;
130     }
131 
132     function getTombDetail(uint index) external view returns(address, address, string) {
133         return (tombToOwner[index], tombs[index].sculptor, tombs[index].data);
134     }
135 }
136 
137 contract TombOwnership is ERC721, TombBase {
138     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
139     string public name = "EtherFen";
140     string public symbol = "ETF";
141 
142     function implementsERC721() public pure returns (bool) {
143         return true;
144     }
145 
146     function totalSupply() public view returns (uint) {
147         return tombs.length;
148     }
149 
150     function balanceOf(address _owner) public view returns (uint256 _balance) {
151         return ownerTombCount[_owner];
152     }
153 
154     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
155         return tombToOwner[_tokenId];
156     }
157 
158     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
159         _transfer(msg.sender, _to, _tokenId);
160     }
161 
162     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
163         tombApprovals[_tokenId] = _to;
164         emit Approval(msg.sender, _to, _tokenId);
165     }
166 
167     function transferFrom(address _from, address _to, uint256 _tokenId) public
168     {
169         require(_to != address(0));
170         require(_to != address(this));
171         require(tombApprovals[_tokenId] == msg.sender);
172         require(tombToOwner[_tokenId] == _from);
173         _transfer(_from, _to, _tokenId);
174     }
175 
176     modifier onlyOwnerOf(uint256 _tokenId) {
177         require(tombToOwner[_tokenId] == msg.sender);
178         _;
179     }
180 }
181 
182 contract TombAction is TombOwnership {
183     uint256 currentPrice;
184 
185     function buyAndCrave(string data) payable external {
186         if (msg.value < currentPrice) revert();
187         _createTombWithData(msg.sender, data);
188     }
189  
190     function changePrice(uint256 newPrice) external onlyOwner {
191         //gwei to ether
192         uint256 gweiUnit = 1000000000;
193         currentPrice = newPrice.mul(gweiUnit);
194     }
195 
196     function getPrice() external view returns(uint256) {
197         return currentPrice;
198     }
199 }
200 
201 contract TombCore is TombAction {
202     function TombCore() public {
203         ownerAddress = msg.sender;
204         currentPrice = 0.02 ether;
205     }
206 }