1 pragma solidity ^0.4.21;
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author MinakoKojima (https://github.com/lychees)
5 contract ERC721 {
6     // Required methods
7     function totalSupply() public view returns (uint256 total);
8     function balanceOf(address _owner) public view returns (uint256 balance);
9     function ownerOf(uint256 _tokenId) public view returns (address owner);
10     function approve(address _to, uint256 _tokenId) public;
11     function transfer(address _to, uint256 _tokenId) public;
12     function transferFrom(address _from, address _to, uint256 _tokenId) public;
13 
14     // Optional
15     function name() public view returns (string _name);
16     function symbol() public view returns (string _symbol);
17     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
18     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
19 
20     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
21     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
22 }
23 
24 contract LuckyPackage is ERC721{
25 
26   event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
27   event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
28   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
29   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
30   event RollDice(address indexed playerAddr, address indexed prizeIssuer, uint prizeId);
31 
32   address private owner;
33   mapping (address => bool) private admins;
34 
35   uint256 private tokenSize;
36   mapping (uint256 => address) private ownerOfToken;
37   mapping (uint256 => address) private approvedOfToken;
38   
39   struct Package {
40       uint256 tokenId;
41       uint256 ratio;
42       address issuer;
43   }
44   Package[] private package;
45   uint256 private packageSize;
46   uint256 private sigmaRatio;
47   
48   function LuckyPackage() public {
49     owner = msg.sender;
50     admins[owner] = true;    
51     sigmaRatio = 0;
52   }
53 
54   /* Modifiers */
55   modifier onlyOwner() {
56     require(owner == msg.sender);
57     _;
58   }
59 
60   modifier onlyAdmins() {
61     require(admins[msg.sender]);
62     _;
63   }
64 
65   /* Owner */
66   function setOwner (address _owner) onlyOwner() public {
67     owner = _owner;
68   }
69 
70   function addAdmin (address _admin) onlyOwner() public {
71     admins[_admin] = true;
72   }
73 
74   function removeAdmin (address _admin) onlyOwner() public {
75     delete admins[_admin];
76   }
77 
78   /* Withdraw */
79   /*
80     NOTICE: These functions withdraw the developer's cut which is left
81     in the contract by `buy`. User funds are immediately sent to the old
82     owner in `buy`, no user funds are left in the contract.
83   */
84   function withdrawAll () onlyAdmins() public {
85      msg.sender.transfer(address(this).balance);
86   }
87 
88   function withdrawAmount (uint256 _amount) onlyAdmins() public {
89     msg.sender.transfer(_amount);
90   }
91 
92   /* ERC721 */
93 
94   function name() public view returns (string _name) {
95     return "luckyDraw";
96   }
97 
98   function symbol() public view returns (string _symbol) {
99     return "LCY";
100   }
101 
102   function totalSupply() public view returns (uint256 _totalSupply) {
103     return tokenSize;
104   }
105 
106   function balanceOf (address _owner) public view returns (uint256 _balance) {
107     uint256 counter = 0;
108 
109     for (uint256 i = 0; i < tokenSize; i++) {
110       if (ownerOf(i) == _owner) {
111         counter++;
112       }
113     }
114 
115     return counter;
116   }
117 
118   function ownerOf (uint256 _tokenId) public view returns (address _owner) {
119     return ownerOfToken[_tokenId];
120   }
121 
122   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
123     uint256[] memory Tokens = new uint256[](balanceOf(_owner));
124 
125     uint256 TokenCounter = 0;
126     for (uint256 i = 0; i < tokenSize; i++) {
127       if (ownerOf(i) == _owner) {
128         Tokens[TokenCounter] = i;
129         TokenCounter += 1;
130       }
131     }
132 
133     return Tokens;
134   }
135 
136   function approvedFor(uint256 _tokenId) public view returns (address _approved) {
137     return approvedOfToken[_tokenId];
138   }
139 
140   function approve(address _to, uint256 _tokenId) public {
141     require(msg.sender != _to);
142     require(ownerOf(_tokenId) == msg.sender);
143 
144     if (_to == 0) {
145       if (approvedOfToken[_tokenId] != 0) {
146         delete approvedOfToken[_tokenId];
147         emit Approval(msg.sender, 0, _tokenId);
148       }
149     } else {
150       approvedOfToken[_tokenId] = _to;
151       emit Approval(msg.sender, _to, _tokenId);
152     }
153   }
154 
155   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
156   function transfer(address _to, uint256 _tokenId) public {
157     require(msg.sender == ownerOf(_tokenId));
158     _transfer(msg.sender, _to, _tokenId);
159   }
160 
161   function transferFrom(address _from, address _to, uint256 _tokenId) public {
162     require(approvedFor(_tokenId) == msg.sender);
163     _transfer(_from, _to, _tokenId);
164   }
165 
166   function _transfer(address _from, address _to, uint256 _tokenId) internal {
167     require(ownerOf(_tokenId) == _from);
168     require(_to != address(0));
169     require(_to != address(this));
170 
171     ownerOfToken[_tokenId] = _to;
172     approvedOfToken[_tokenId] = 0;
173 
174     emit Transfer(_from, _to, _tokenId);
175   }
176 
177   /* Read */
178   function isAdmin (address _admin) public view returns (bool _isAdmin) {
179     return admins[_admin];
180   }
181 
182   function allOf (uint256 _tokenId) external view returns (address _owner) {
183     return (ownerOf(_tokenId));
184   }
185 
186   /* Read */
187   
188   function getAllPackage() public view returns (uint256[] _id, uint256[] _ratio, address[] _issuer) {
189     uint256[] memory ID = new uint[](packageSize);
190     uint256[] memory RATIO = new uint[](packageSize);
191     address[] memory ISSUER = new address[](packageSize);
192     for (uint i = 0; i < packageSize; i++) {
193       ID[i] = package[i].tokenId;
194       RATIO[i] = package[i].ratio;
195       ISSUER[i] = package[i].issuer;
196     }
197     return (ID, RATIO, ISSUER);
198   }
199 
200   /* Util */
201   function isContract(address addr) internal view returns (bool) {
202     uint size;
203     assembly { size := extcodesize(addr) } // solium-disable-line
204     return size > 0;
205   }
206   
207   function putIntoPackage(uint256 _tokenId, uint256 _ratio, address _issuer) onlyAdmins() public {      
208       Issuer issuer = Issuer(_issuer);
209       require(issuer.ownerOf(_tokenId) == msg.sender);
210       issuer.transferFrom(msg.sender, address(this), _tokenId);      
211       
212       if (packageSize >= package.length) {
213           package.push(Package(_tokenId, _ratio, _issuer));
214       } else {
215         package[packageSize].tokenId = _tokenId;
216         package[packageSize].ratio = _ratio;
217         package[packageSize].issuer = _issuer;
218       }
219 
220       packageSize += 1;
221       sigmaRatio += _ratio;
222   }
223   
224   function rollDice(uint256 _tokenId) public {
225       require(msg.sender == ownerOfToken[_tokenId]);
226       require(packageSize > 0);
227       
228       /* recycle the token. */
229       _transfer(msg.sender, owner, _tokenId);
230       
231       /* get a random number. */
232       uint256 result = uint(keccak256(block.timestamp + block.difficulty)); // assume result is the random number
233       result %= sigmaRatio;
234       uint256 rt;
235       for (uint256 i = 0; i < packageSize; i++) {
236           if (result >= package[i].ratio) {
237               result -= package[i].ratio;
238           } else {
239               rt = i;
240               break;
241           }
242       }
243       
244       /* transfer  */
245       Issuer issuer = Issuer(package[rt].issuer);
246       issuer.transfer(msg.sender, package[rt].tokenId);
247       
248       /* remove */
249       sigmaRatio -= package[rt].ratio;
250       package[rt] = package[packageSize-1];
251       packageSize -= 1;
252       
253       emit RollDice(msg.sender, package[rt].issuer, package[rt].tokenId);
254   }
255   
256   /* Issue */
257   function issueToken(uint256 _count) onlyAdmins() public {
258     uint256 l = tokenSize;
259     uint256 r = tokenSize + _count;
260     for (uint256 i = l; i < r; i++) {
261       ownerOfToken[i] = msg.sender;
262     } 
263     tokenSize += _count;    
264   }
265   function issueTokenAndTransfer(uint256 _count, address to) onlyAdmins() public {
266     uint256 l = tokenSize;
267     uint256 r = tokenSize + _count;
268     for (uint256 i = l; i < r; i++) {
269       ownerOfToken[i] = to;
270     }      
271     tokenSize += _count;    
272   }    
273   function issueTokenAndApprove(uint256 _count, address to) onlyAdmins() public {
274     uint256 l = tokenSize;
275     uint256 r = tokenSize + _count;
276     for (uint256 i = l; i < r; i++) {
277       ownerOfToken[i] = msg.sender;
278       approve(to, i);
279     }          
280     tokenSize += _count;
281   }    
282 }
283 
284 interface Issuer {
285   function transferFrom(address _from, address _to, uint256 _tokenId) external;  
286   function transfer(address _to, uint256 _tokenId) external;
287   function ownerOf (uint256 _tokenId) external view returns (address _owner);
288 }