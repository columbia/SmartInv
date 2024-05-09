1 pragma solidity 0.5.11;
2 
3 
4 contract Context {
5     
6     
7     constructor () internal { }
8     
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; 
16         return msg.data;
17     }
18 }
19 
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     
26     constructor () internal {
27         _owner = _msgSender();
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     
32     function owner() public view returns (address) {
33         return _owner;
34     }
35 
36     
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     
43     function isOwner() public view returns (bool) {
44         return _msgSender() == _owner;
45     }
46 
47     
48     function renounceOwnership() public onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52 
53     
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     
59     function _transferOwnership(address newOwner) internal {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         emit OwnershipTransferred(_owner, newOwner);
62         _owner = newOwner;
63     }
64 }
65 
66 interface IERC165 {
67     
68     function supportsInterface(bytes4 interfaceId) external view returns (bool);
69 }
70 
71 contract IERC721 is IERC165 {
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
74     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
75 
76     
77     function balanceOf(address owner) public view returns (uint256 balance);
78 
79     
80     function ownerOf(uint256 tokenId) public view returns (address owner);
81 
82     
83     function safeTransferFrom(address from, address to, uint256 tokenId) public;
84     
85     function transferFrom(address from, address to, uint256 tokenId) public;
86     function approve(address to, uint256 tokenId) public;
87     function getApproved(uint256 tokenId) public view returns (address operator);
88 
89     function setApprovalForAll(address operator, bool _approved) public;
90     function isApprovedForAll(address owner, address operator) public view returns (bool);
91 
92 
93     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
94 }
95 
96 contract ICards is IERC721 {
97 
98     struct Batch {
99         uint48 userID;
100         uint16 size;
101     }
102 
103     function batches(uint index) public view returns (uint48 userID, uint16 size);
104 
105     function userIDToAddress(uint48 id) public view returns (address);
106 
107     function getDetails(
108         uint tokenId
109     )
110         public
111         view
112         returns (
113         uint16 proto,
114         uint8 quality
115     );
116 
117     function setQuality(
118         uint tokenId,
119         uint8 quality
120     ) public;
121 
122     function mintCards(
123         address to,
124         uint16[] memory _protos,
125         uint8[] memory _qualities
126     )
127         public
128         returns (uint);
129 
130     function mintCard(
131         address to,
132         uint16 _proto,
133         uint8 _quality
134     )
135         public
136         returns (uint);
137 
138     function burn(uint tokenId) public;
139 
140     function batchSize()
141         public
142         view
143         returns (uint);
144 }
145 
146 contract Fusing is Ownable {
147 
148     ICards public cards;
149 
150     mapping (address => bool) approvedMinters;
151 
152     event MinterAdded(
153         address indexed minter
154     );
155 
156     event MinterRemoved(
157         address indexed minter
158     );
159 
160     event CardFused(
161         address owner,
162         address tokenAddress,
163         uint[] references,
164         uint indexed tokenId,
165         uint indexed lowestReference
166     );
167 
168     
169     modifier onlyMinter(address _minter) {
170         require(
171             approvedMinters[_minter] == true,
172             "Fusing: invalid minter"
173         );
174         _;
175     }
176 
177     constructor(ICards _cards) public {
178         cards = ICards(_cards);
179     }
180 
181     
182     function addMinter(
183         address _minter
184     )
185         public
186         onlyOwner
187     {
188         approvedMinters[_minter] = true;
189 
190         emit MinterAdded(_minter);
191     }
192 
193     
194     function removeMinter(
195         address _minter
196     )
197         public
198         onlyOwner
199     {
200         approvedMinters[_minter] = false;
201         delete approvedMinters[_minter];
202 
203         emit MinterRemoved(_minter);
204     }
205 
206     
207     function fuse(
208         uint16 _proto,
209         uint8 _quality,
210         address _to,
211         uint[] memory _references
212     )
213         public
214         onlyMinter(msg.sender)
215         returns (uint tokenId)
216     {
217 
218         require(
219             _to != address(0),
220             "Fusing: to address cannot be 0"
221         );
222 
223         require(
224             _references.length > 0,
225             "Fusing must have more than one reference"
226         );
227 
228         tokenId = cards.mintCard(_to, _proto, _quality);
229 
230         uint lowestReference = _references[0];
231         for (uint i = 0; i < _references.length; i++) {
232             if (_references[i] < lowestReference) {
233                 lowestReference = _references[i];
234             }
235         }
236 
237         emit CardFused(_to, address(cards), _references, tokenId, lowestReference);
238     }
239 
240     
241     function isApprovedMinter(
242         address _minter
243     )
244         public
245         returns
246         (bool)
247     {
248         return approvedMinters[_minter];
249     }
250 
251 }