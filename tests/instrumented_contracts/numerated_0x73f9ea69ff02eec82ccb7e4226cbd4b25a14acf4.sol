1 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 pragma solidity ^0.4.21;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 //File: contracts\ARTIDDigitalSign.sol
46 pragma solidity ^0.4.18;
47 
48 
49 
50 contract ARTIDDigitalSign is Ownable{
51     
52     //archive of digital certificates, every certificate combine signer 
53     //address and arts guid 
54     mapping(bytes32 => Version[]) digitalCertificateArchive;
55     
56     
57     struct Version {
58         uint8 version;
59         bytes32 sign;
60         uint256 timestamp;
61     }
62 
63     function Sign(string guid, string hash) public onlyWhitelisted {
64         address _signer = msg.sender;
65         string memory addressString = toString(_signer);
66         //combine signer with guid of arts to create an archive managed by the signer
67         string memory concatenatedData = strConcat(addressString,guid);
68         bytes32 hashed = keccak256(concatenatedData);
69         
70         uint8 version = 1;
71         Version[] memory versions = digitalCertificateArchive[hashed];
72         uint length =  versions.length;
73         for(uint8 i = 0; i < length; i++)
74         {
75             version = i+2;
76         }
77 
78         bytes32 hashedSign = keccak256(hash); 
79         Version memory v = Version(version,hashedSign,now);
80         digitalCertificateArchive[hashed].push(v);
81         
82     }
83 
84     function GetSign(string guid, address signer) public view returns(bytes32 sign, uint8 signedVersion,uint256 timestamp){
85         address _signer = signer;
86         string memory addressString = toString(_signer);
87         //combine signer with guid of arts to create an archive managed by the signer
88         string memory concatenatedData = strConcat(addressString,guid);
89         bytes32 hashed = keccak256(concatenatedData);
90         uint length =  digitalCertificateArchive[hashed].length;
91         Version memory v = digitalCertificateArchive[hashed][length-1];
92         return (v.sign, v.version, v.timestamp);
93     }
94 
95     function GetSignVersion(string guid, address signer, uint version) public view returns(bytes32 sign, uint8 signedVersion,uint256 timestamp){
96         address _signer = signer;
97         string memory addressString = toString(_signer);
98         //combine signer with guid of arts to create an archive managed by the signer
99         string memory concatenatedData = strConcat(addressString,guid);
100         bytes32 hashed = keccak256(concatenatedData);
101         Version memory v = digitalCertificateArchive[hashed][version-1];
102         return (v.sign, v.version, v.timestamp);
103     }
104 
105     
106     
107     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
108         bytes memory _ba = bytes(_a);
109         bytes memory _bb = bytes(_b);
110         bytes memory _bc = bytes(_c);
111         bytes memory _bd = bytes(_d);
112         bytes memory _be = bytes(_e);
113         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
114         bytes memory babcde = bytes(abcde);
115         uint k = 0;
116         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
117         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
118         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
119         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
120         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
121         return string(babcde);
122     }
123 
124     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
125         return strConcat(_a, _b, _c, _d, "");
126     }
127     
128     function strConcat(string _a, string _b, string _c) internal returns (string) {
129         return strConcat(_a, _b, _c, "", "");
130     }
131     
132     function strConcat(string _a, string _b) internal returns (string) {
133         return strConcat(_a, _b, "", "", "");
134     }
135     
136     function toString(address x) returns (string) {
137         bytes memory b = new bytes(20);
138         for (uint i = 0; i < 20; i++)
139             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
140         return string(b);
141     }
142     
143     function bytes32ToString(bytes32 x) constant returns (string) {
144         bytes memory bytesString = new bytes(32);
145         uint charCount = 0;
146         for (uint j = 0; j < 32; j++) {
147             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
148             if (char != 0) {
149                 bytesString[charCount] = char;
150                 charCount++;
151             }
152         }
153         bytes memory bytesStringTrimmed = new bytes(charCount);
154         for (j = 0; j < charCount; j++) {
155             bytesStringTrimmed[j] = bytesString[j];
156         }
157     return string(bytesStringTrimmed);
158 }
159 
160     mapping (address => bool) whitelist;
161 
162   event WhitelistedAddressAdded(address addr);
163   event WhitelistedAddressRemoved(address addr);
164 
165   /**
166    * @dev Throws if called by any account that's not whitelisted.
167    */
168   modifier onlyWhitelisted() {
169     whitelist[msg.sender] == true;
170     _;
171   }
172 
173   /**
174    * @dev add an address to the whitelist
175    * @param addr address
176    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
177    */
178   function addAddressToWhitelist(address addr)
179     onlyOwner
180     public
181   {
182     whitelist[addr] = true;
183     emit WhitelistedAddressAdded(addr);
184   }
185 
186   /**
187    * @dev getter to determine if address is in whitelist
188    */
189   function isInWhitelist(address addr)
190     public
191     view
192     returns (bool)
193   {
194     return whitelist[addr] == true;
195   }
196 
197   /**
198    * @dev add addresses to the whitelist
199    * @param addrs addresses
200    * @return true if at least one address was added to the whitelist,
201    * false if all addresses were already in the whitelist
202    */
203   function addAddressesToWhitelist(address[] addrs)
204     onlyOwner
205     public
206   {
207     for (uint256 i = 0; i < addrs.length; i++) {
208       addAddressToWhitelist(addrs[i]);
209     }
210   }
211 
212   /**
213    * @dev remove an address from the whitelist
214    * @param addr address
215    * @return true if the address was removed from the whitelist,
216    * false if the address wasn't in the whitelist in the first place
217    */
218   function removeAddressFromWhitelist(address addr)
219     onlyOwner
220     public
221   {
222     whitelist[addr] = false;
223     emit WhitelistedAddressRemoved(addr);
224   }
225 
226   /**
227    * @dev remove addresses from the whitelist
228    * @param addrs addresses
229    * @return true if at least one address was removed from the whitelist,
230    * false if all addresses weren't in the whitelist in the first place
231    */
232   function removeAddressesFromWhitelist(address[] addrs)
233     onlyOwner
234     public
235   {
236     for (uint256 i = 0; i < addrs.length; i++) {
237       removeAddressFromWhitelist(addrs[i]);
238     }
239   }
240     
241 }