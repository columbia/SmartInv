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
14     // Events
15     event Transfer(address from, address to, uint256 tokenId);
16     event Approval(address owner, address approved, uint256 tokenId);
17 
18     // Optional
19     function name() public view returns (string _name);
20     function symbol() public view returns (string _symbol);
21     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
22     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
23 
24     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
25     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
26 }
27 
28 contract CryptoThreeKingdoms is ERC721{
29 
30   event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
31   event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
32   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
33   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
34 
35   address private owner;
36   mapping (address => bool) private admins;
37 
38   uint256[] private listedTokens;
39   mapping (uint256 => address) private ownerOfToken;
40   mapping (uint256 => address) private approvedOfToken;
41 
42   function CryptoThreeKingdoms() public {
43     owner = msg.sender;
44     admins[owner] = true;    
45   }
46 
47   /* Modifiers */
48   modifier onlyOwner() {
49     require(owner == msg.sender);
50     _;
51   }
52 
53   modifier onlyAdmins() {
54     require(admins[msg.sender]);
55     _;
56   }
57 
58   /* Owner */
59   function setOwner(address _owner) onlyOwner() public {
60     owner = _owner;
61   }
62 
63   function addAdmin(address _admin) onlyOwner() public {
64     admins[_admin] = true;
65   }
66 
67   function removeAdmin(address _admin) onlyOwner() public {
68     delete admins[_admin];
69   }
70 
71   /* Withdraw */
72   /*
73     NOTICE: These functions withdraw the developer's cut which is left
74     in the contract by `buy`. User funds are immediately sent to the old
75     owner in `buy`, no user funds are left in the contract.
76   */
77   function withdrawAll() onlyAdmins() public {
78    msg.sender.transfer(address(this).balance);
79   }
80 
81   function withdrawAmount(uint256 _amount) onlyAdmins() public {
82     msg.sender.transfer(_amount);
83   }
84 
85   /* ERC721 */
86 
87   function name() public view returns (string _name) {
88     return "cryptosanguo.pro";
89   }
90 
91   function symbol() public view returns (string _symbol) {
92     return "CSG";
93   }
94 
95   function totalSupply() public view returns (uint256 _totalSupply) {
96     return listedTokens.length;
97   }
98 
99   function balanceOf (address _owner) public view returns (uint256 _balance) {
100     uint256 counter = 0;
101 
102     for (uint256 i = 0; i < listedTokens.length; i++) {
103       if (ownerOf(listedTokens[i]) == _owner) {
104         counter++;
105       }
106     }
107 
108     return counter;
109   }
110 
111   function ownerOf (uint256 _tokenId) public view returns (address _owner) {
112     return ownerOfToken[_tokenId];
113   }
114 
115   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
116     uint256[] memory Tokens = new uint256[](balanceOf(_owner));
117 
118     uint256 TokenCounter = 0;
119     for (uint256 i = 0; i < listedTokens.length; i++) {
120       if (ownerOf(listedTokens[i]) == _owner) {
121         Tokens[TokenCounter] = listedTokens[i];
122         TokenCounter += 1;
123       }
124     }
125 
126     return Tokens;
127   }
128 
129   function approvedFor(uint256 _tokenId) public view returns (address _approved) {
130     return approvedOfToken[_tokenId];
131   }
132 
133   function approve(address _to, uint256 _tokenId) public {
134     require(msg.sender != _to);
135     require(ownerOf(_tokenId) == msg.sender);
136 
137     if (_to == 0) {
138       if (approvedOfToken[_tokenId] != 0) {
139         delete approvedOfToken[_tokenId];
140         emit Approval(msg.sender, 0, _tokenId);
141       }
142     } else {
143       approvedOfToken[_tokenId] = _to;
144       emit Approval(msg.sender, _to, _tokenId);
145     }
146   }
147 
148   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
149   function transfer(address _to, uint256 _tokenId) public {
150     require(msg.sender == ownerOf(_tokenId));
151     _transfer(msg.sender, _to, _tokenId);
152   }
153 
154   function transferFrom(address _from, address _to, uint256 _tokenId) public {
155     require(approvedFor(_tokenId) == msg.sender);
156     _transfer(_from, _to, _tokenId);
157   }
158 
159   function _transfer(address _from, address _to, uint256 _tokenId) internal {
160     require(ownerOf(_tokenId) == _from);
161     require(_to != address(0));
162     require(_to != address(this));
163 
164     ownerOfToken[_tokenId] = _to;
165     approvedOfToken[_tokenId] = 0;
166 
167     emit Transfer(_from, _to, _tokenId);
168   }
169 
170   /* Read */
171   function getListedTokens() public view returns (uint256[] _Tokens) {
172     return listedTokens;
173   }
174   
175   function isAdmin(address _admin) public view returns (bool _isAdmin) {
176     return admins[_admin];
177   }
178 
179   /* Issue */  
180   function issueToken(uint256 l, uint256 r) onlyAdmins() public {
181     for (uint256 i = l; i <= r; i++) {
182       if (ownerOf(i) == address(0)) {
183         ownerOfToken[i] = msg.sender;
184         listedTokens.push(i);
185       }
186     }      
187   }
188   function issueTokenAndTransfer(uint256 l, uint256 r, address to) onlyAdmins() public {
189     for (uint256 i = l; i <= r; i++) {
190       if (ownerOf(i) == address(0)) {
191         ownerOfToken[i] = to;
192         listedTokens.push(i);
193       }
194     }      
195   }     
196   function issueTokenAndApprove(uint256 l, uint256 r, address to) onlyAdmins() public {
197     for (uint256 i = l; i <= r; i++) {
198       if (ownerOf(i) == address(0)) {
199         ownerOfToken[i] = msg.sender;
200         approve(to, i);
201         listedTokens.push(i);
202       }
203     }          
204   }    
205 }