1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() public{
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Throws if called by any account other than the owner.
21      */
22     modifier onlyOwner(){
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param newOwner The address to transfer ownership to.
30      */
31     function transferOwnership(address newOwner) public onlyOwner{
32         require(newOwner != address(0));
33         owner = newOwner;
34     }
35 }
36 
37 contract ERC721Interface {
38     // Required methods
39     // function totalSupply() public view returns (uint256 total);
40     // function balanceOf(address _owner) public view returns (uint256 balance);
41     function ownerOf(uint256 _tokenId) external view returns (address owner);
42     // function approve(address _to, uint256 _tokenId) external;
43     // function transfer(address _to, uint256 _tokenId) external;
44     // function transferFrom(address _from, address _to, uint256 _tokenId) external;
45 }
46 
47 /** 
48  * @dev Name provider contract
49  * Allows saving names and descriptons for specified addresses and tokens
50  */
51 contract NameProvider is Ownable {
52     
53     uint256 public FEE = 1 finney;
54     
55     //name storage for addresses
56     mapping(bytes32 => mapping(address => string)) addressNames;
57     
58     //marks namespaces as already used on first name save to specified namespace
59     mapping(bytes32 => bool) takenNamespaces;
60     
61     //name storage for tokens
62     mapping(address => mapping(uint256 => string)) tokenNames;
63     
64     //description storage for tokens
65     mapping(address => mapping(uint256 => string)) tokenDescriptions;
66     
67     /* EVENTS */
68     
69     event NameChanged(bytes32 namespace, address account, string name);
70     
71     event TokenNameChanged(address tokenProvider, uint256 tokenId, string name);
72     
73     event TokenDescriptionChanged(address tokenProvider, uint256 tokenId, string description);
74     
75     function NameProvider(address _owner) public {
76         require(_owner != address(0));
77         owner = _owner;
78     }
79     
80     modifier setTokenText(address _tokenInterface, uint256 _tokenId, string _text){
81         //check fee
82         require(msg.value >= FEE);
83         //no empty strings allowed
84         require(bytes(_text).length > 0);
85         
86         ERC721Interface tokenInterface = ERC721Interface(_tokenInterface);
87         //only token owner can set its name
88         require(msg.sender == tokenInterface.ownerOf(_tokenId));
89         
90         _;//set text code
91         
92         //return excess
93         if (msg.value > FEE) {
94             msg.sender.transfer(msg.value - FEE);
95         }
96     }
97     
98     //@dev set name for specified token,
99     // NB msg.sender must be owner of the specified token.
100     //@param _tokenInterface ERC721 protocol provider address
101     //@param _tokenId id of the token, whose name will be set
102     //@param _name string that will be set as new token name
103     function setTokenName(address _tokenInterface, uint256 _tokenId, string _name) 
104     setTokenText(_tokenInterface, _tokenId, _name) external payable {
105         _setTokenName(_tokenInterface, _tokenId, _name);
106     }
107     
108     //@dev set description for specified token,
109     // NB msg.sender must be owner of the specified token.
110     //@param _tokenInterface ERC721 protocol provider address
111     //@param _tokenId id of the token, whose description will be set
112     //@param _description string that will be set as new token description
113     function setTokenDescription(address _tokenInterface, uint256 _tokenId, string _description)
114     setTokenText(_tokenInterface, _tokenId, _description) external payable {
115         _setTokenDescription(_tokenInterface, _tokenId, _description);
116     }
117     
118     //@dev get name of specified token,
119     //@param _tokenInterface ERC721 protocol provider address
120     //@param _tokenId id of the token, whose name will be returned
121     function getTokenName(address _tokenInterface, uint256 _tokenId) external view returns(string) {
122         return tokenNames[_tokenInterface][_tokenId];
123     }
124     
125     //@dev get description of specified token,
126     //@param _tokenInterface ERC721 protocol provider address
127     //@param _tokenId id of the token, whose description will be returned
128     function getTokenDescription(address _tokenInterface, uint256 _tokenId) external view returns(string) {
129         return tokenDescriptions[_tokenInterface][_tokenId];
130     }
131     
132     //@dev set global name for msg.sender,
133     // NB msg.sender must be owner of the specified token.
134     //@param _name string that will be set as new address name
135     function setName(string _name) external payable {
136         setServiceName(bytes32(0), _name);
137     }
138     
139     //@dev set name for msg.sender in cpecified namespace,
140     // NB msg.sender must be owner of the specified token.
141     //@param _namespace bytes32 service identifier
142     //@param _name string that will be set as new address name
143     function setServiceName(bytes32 _namespace, string memory _name) public payable {
144         //check fee
145         require(msg.value >= FEE);
146         //set name
147         _setName(_namespace, _name);
148         //return excess
149         if (msg.value > FEE) {
150             msg.sender.transfer(msg.value - FEE);
151         }
152     }
153     
154     //@dev get global name for specified address,
155     //@param _address the address for whom name string will be returned
156     function getNameByAddress(address _address) external view returns(string) {
157         return addressNames[bytes32(0)][_address];
158     }
159     
160     //@dev get global name for msg.sender,
161     function getName() external view returns(string) {
162         return addressNames[bytes32(0)][msg.sender];
163     }
164     
165     //@dev get name for specified address and namespace,
166     //@param _namespace bytes32 service identifier
167     //@param _address the address for whom name string will be returned
168     function getServiceNameByAddress(bytes32 _namespace, address _address) external view returns(string) {
169         return addressNames[_namespace][_address];
170     }
171     
172     //@dev get name for specified namespace and msg.sender,
173     //@param _namespace bytes32 service identifier
174     function getServiceName(bytes32 _namespace) external view returns(string) {
175         return addressNames[_namespace][msg.sender];
176     }
177     
178     //@dev get names for specified addresses in global namespace (bytes32(0))
179     //@param _address address[] array of addresses for whom names will be returned
180     //@return namesData bytes32 
181     //@return nameLength number of bytes32 in address name, sum of nameLength values equals namesData.length (1 to 1 with _address) 
182     function getNames(address[] _address) external view returns(bytes32[] namesData, uint256[] nameLength) {
183         return getServiceNames(bytes32(0), _address);
184 	}
185 	
186 	//@dev get names for specified tokens 
187     //@param _tokenIds uint256[] array of ids for whom names will be returned
188     //@return namesData bytes32 
189     //@return nameLength number of bytes32 in token name, sum of nameLength values equals namesData.length (1 to 1 with _tokenIds) 
190 	function getTokenNames(address _tokenInterface, uint256[] _tokenIds) external view returns(bytes32[] memory namesData, uint256[] memory nameLength) {
191         return _getTokenTexts(_tokenInterface, _tokenIds, true);
192 	}
193 	
194 	//@dev get names for specified tokens 
195     //@param _tokenIds uint256[] array of ids for whom descriptons will be returned
196     //@return descriptonData bytes32 
197     //@return descriptionLength number of bytes32 in token name, sum of nameLength values equals namesData.length (1 to 1 with _tokenIds) 
198 	function getTokenDescriptions(address _tokenInterface, uint256[] _tokenIds) external view returns(bytes32[] memory descriptonData, uint256[] memory descriptionLength) {
199         return _getTokenTexts(_tokenInterface, _tokenIds, false);
200 	}
201 	
202 	//@dev get names for specified addresses and namespace
203 	//@param _namespace bytes32 namespace identifier
204     //@param _address address[] array of addresses for whom names will be returned
205     //@return namesData bytes32 
206     //@return nameLength number of bytes32 in address name, sum of nameLength values equals namesData.length (1 to 1 with _address) 
207     function getServiceNames(bytes32 _namespace, address[] _address) public view returns(bytes32[] memory namesData, uint256[] memory nameLength) {
208         uint256 length = _address.length;
209         nameLength = new uint256[](length);
210         
211         bytes memory stringBytes;
212         uint256 size = 0;
213         uint256 i;
214         for (i = 0; i < length; i ++) {
215             stringBytes = bytes(addressNames[_namespace][_address[i]]);
216             size += nameLength[i] = stringBytes.length % 32 == 0 ? stringBytes.length / 32 : stringBytes.length / 32 + 1;
217         }
218         namesData = new bytes32[](size);
219         size = 0;
220         for (i = 0; i < length; i ++) {
221             size += _stringToBytes32(addressNames[_namespace][_address[i]], namesData, size);
222         }
223     }
224     
225     function namespaceTaken(bytes32 _namespace) external view returns(bool) {
226         return takenNamespaces[_namespace];
227     }
228     
229     function setFee(uint256 _fee) onlyOwner external {
230         FEE = _fee;
231     }
232     
233     function withdraw() onlyOwner external {
234         owner.transfer(this.balance);
235     }
236     
237     function _setName(bytes32 _namespace, string _name) internal {
238         addressNames[_namespace][msg.sender] = _name;
239         if (!takenNamespaces[_namespace]) {
240             takenNamespaces[_namespace] = true;
241         }
242         NameChanged(_namespace, msg.sender, _name);
243     }
244     
245     function _setTokenName(address _tokenInterface, uint256 _tokenId, string _name) internal {
246         tokenNames[_tokenInterface][_tokenId] = _name;
247         TokenNameChanged(_tokenInterface, _tokenId, _name);
248     }
249     
250     function _setTokenDescription(address _tokenInterface, uint256 _tokenId, string _description) internal {
251         tokenDescriptions[_tokenInterface][_tokenId] = _description;
252         TokenDescriptionChanged(_tokenInterface, _tokenId, _description);
253     }
254     
255     function _getTokenTexts(address _tokenInterface, uint256[] memory _tokenIds, bool names) internal view returns(bytes32[] memory namesData, uint256[] memory nameLength) {
256         uint256 length = _tokenIds.length;
257         nameLength = new uint256[](length);
258         mapping(address => mapping(uint256 => string)) textMap = names ? tokenNames : tokenDescriptions;
259         
260         bytes memory stringBytes;
261         uint256 size = 0;
262         uint256 i;
263         for (i = 0; i < length; i ++) {
264             stringBytes = bytes(textMap[_tokenInterface][_tokenIds[i]]);
265             size += nameLength[i] = stringBytes.length % 32 == 0 ? stringBytes.length / 32 : stringBytes.length / 32 + 1;
266         }
267         namesData = new bytes32[](size);
268         size = 0;
269         for (i = 0; i < length; i ++) {
270             size += _stringToBytes32(textMap[_tokenInterface][_tokenIds[i]], namesData, size);
271         }
272     }
273     
274         
275     function _stringToBytes32(string memory source, bytes32[] memory namesData, uint256 _start) internal pure returns (uint256) {
276         bytes memory stringBytes = bytes(source);
277         uint256 length = stringBytes.length;
278         bytes32[] memory result = new bytes32[](length % 32 == 0 ? length / 32 : length / 32 + 1);
279         
280         bytes32 word;
281         uint256 index = 0;
282         uint256 limit = 0;
283         for (uint256 i = 0; i < length; i += 32) {
284             limit = i + 32;
285             assembly {
286                 word := mload(add(source, limit))
287             }
288             namesData[_start + index++] = word;
289         }
290         return result.length;
291     }
292 }