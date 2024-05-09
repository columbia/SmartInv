1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     require(newOwner != address(0));      
36     owner = newOwner;
37   }
38 
39 }
40 
41 interface AbstractENS {
42     function owner(bytes32 node) constant returns(address);
43     function resolver(bytes32 node) constant returns(address);
44     function ttl(bytes32 node) constant returns(uint64);
45     function setOwner(bytes32 node, address owner);
46     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
47     function setResolver(bytes32 node, address resolver);
48     function setTTL(bytes32 node, uint64 ttl);
49 
50     // Logged when the owner of a node assigns a new owner to a subnode.
51     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
52 
53     // Logged when the owner of a node transfers ownership to a new account.
54     event Transfer(bytes32 indexed node, address owner);
55 
56     // Logged when the resolver for a node changes.
57     event NewResolver(bytes32 indexed node, address resolver);
58 
59     // Logged when the TTL of a node changes
60     event NewTTL(bytes32 indexed node, uint64 ttl);
61 }
62 
63 interface InterCrypto_Interface {
64     // EVENTS
65     event ConversionStarted(uint indexed conversionID);
66     event ConversionSentToShapeShift(uint indexed conversionID, address indexed returnAddress, address indexed depositAddress, uint amount);
67     event ConversionAborted(uint indexed conversionID, string reason);
68     event Recovered(address indexed recoveredTo, uint amount);
69 
70     // FUNCTIONS
71     function getInterCryptoPrice() constant public returns (uint);
72     function convert1(string _coinSymbol, string _toAddress) external payable returns (uint conversionID);
73     function convert2(string _coinSymbol, string _toAddress, address _returnAddress) external payable returns(uint conversionID);
74     function recover() external;
75     function recoverable(address myAddress) constant public returns (uint);
76     function cancelConversion(uint conversionID) external;
77 }
78 
79 interface AbstractPublicResolver {
80     function PublicResolver(address ensAddr);
81     function supportsInterface(bytes4 interfaceID) constant returns (bool);
82     function addr(bytes32 node) constant returns (address ret);
83     function setAddr(bytes32 node, address addr);
84     function hash(bytes32 node) constant returns (bytes32 ret);
85     function setHash(bytes32 node, bytes32 hash);
86 }
87 
88 contract usingInterCrypto is Ownable {
89     AbstractENS public abstractENS;
90     AbstractPublicResolver public abstractResolver;
91     InterCrypto_Interface public interCrypto;
92     
93     bytes32 public ResolverNode; // ENS Node name
94     bytes32 public InterCryptoNode; // ENS Node name
95     
96     function usingInterCrypto() public {
97         setNetwork();
98         updateResolver();
99         updateInterCrypto();
100         
101     }
102     
103     function setNetwork() internal returns(bool) {
104         if (getCodeSize(0x314159265dD8dbb310642f98f50C066173C1259b)>0){ //mainnet
105             abstractENS = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);
106             ResolverNode = 0xfdd5d5de6dd63db72bbc2d487944ba13bf775b50a80805fe6fcaba9b0fba88f5; // resolver.eth
107             InterCryptoNode = 0x921a56636fce44f7cbd33eed763c940f580add9ffb4da7007f8ff6e99804a7c8; // intercrypto.jacksplace.eth
108         }
109         else if (getCodeSize(0xe7410170f87102df0055eb195163a03b7f2bff4a)>0){ //rinkeby
110             abstractENS = AbstractENS(0xe7410170f87102df0055eb195163a03b7f2bff4a);
111             ResolverNode = 0xf2cf3eab504436e1b5a541dd9fbc5ac8547b773748bbf2bb81b350ee580702ca; // jackdomain.test
112             InterCryptoNode = 0xbe93c9e419d658afd89a8650dd90e37e763e75da1e663b9d57494aedf27f3eaa; // intercrypto.jackdomain.test
113         }
114         else if (getCodeSize(0x112234455c3a32fd11230c42e7bccd4a84e02010)>0){ //ropsten
115             abstractENS = AbstractENS(0x112234455c3a32fd11230c42e7bccd4a84e02010);
116             ResolverNode = 0xf2cf3eab504436e1b5a541dd9fbc5ac8547b773748bbf2bb81b350ee580702ca; // jackdomain.test
117             InterCryptoNode = 0xbe93c9e419d658afd89a8650dd90e37e763e75da1e663b9d57494aedf27f3eaa; // intercrypto.jackdomain.test
118         }
119         else {
120             revert();
121         }
122     }
123     
124     function updateResolver() onlyOwner public {
125         abstractResolver = AbstractPublicResolver(abstractENS.resolver(ResolverNode));
126     }
127         
128     function updateInterCrypto() onlyOwner public {
129         interCrypto = InterCrypto_Interface(abstractResolver.addr(InterCryptoNode));
130     }
131     
132     function updateInterCryptonode(bytes32 newNodeName) onlyOwner public {
133         InterCryptoNode = newNodeName;
134     }
135         
136     function getCodeSize(address _addr) constant internal returns(uint _size) {
137         assembly {
138             _size := extcodesize(_addr)
139         }
140         return _size;
141     }
142     
143     function intercrypto_convert(uint amount, string _coinSymbol, string _toAddress) internal returns (uint conversionID) {
144         return interCrypto.convert1.value(amount)(_coinSymbol, _toAddress);
145     }
146     
147     function intercrypto_convert(uint amount, string _coinSymbol, string _toAddress, address _returnAddress) internal returns(uint conversionID) {
148         return interCrypto.convert2.value(amount)(_coinSymbol, _toAddress, _returnAddress);
149     }
150     
151     // If you want to allow public use of functions getInterCryptoPrice(), recover(), recoverable() or cancelConversion() then please copy the following as necessary
152     // into your smart contract. They are not included by default for security reasons.
153     
154     // function intercrypto_getInterCryptoPrice() constant public returns (uint) {
155     //     return interCrypto.getInterCryptoPrice();
156     // }
157     // function intercrypto_recover() onlyOwner public {
158     //     interCrypto.recover();
159     // }
160     // function intercrypto_recoverable() constant public returns (uint) {
161     //     return interCrypto.recoverable(this);
162     // }
163     // function intercrypto_cancelConversion(uint conversionID) onlyOwner external {
164     //     interCrypto.cancelConversion(conversionID);
165     // }
166 }
167 
168 contract InterCrypto_Wallet is usingInterCrypto {
169 
170     event Deposit(address indexed deposit, uint amount);
171     event WithdrawalNormal(address indexed withdrawal, uint amount);
172     event WithdrawalInterCrypto(uint indexed conversionID);
173 
174     mapping (address => uint) public funds;
175     
176     function InterCrypto_Wallet() {}
177 
178     function () payable {}
179     
180     function deposit() payable {
181       if (msg.value > 0) {
182           funds[msg.sender] += msg.value;
183           Deposit(msg.sender, msg.value);
184       }
185     }
186     
187     function intercrypto_getInterCryptoPrice() constant public returns (uint) {
188         return interCrypto.getInterCryptoPrice();
189     }
190     
191     function withdrawalNormal() payable external {
192         uint amount = funds[msg.sender] + msg.value;
193         funds[msg.sender] = 0;
194         if(msg.sender.send(amount)) {
195             WithdrawalNormal(msg.sender, amount);
196         }
197         else {
198             funds[msg.sender] = amount;
199         }
200     }
201     
202     function withdrawalInterCrypto(string _coinSymbol, string _toAddress) external payable {
203         uint amount = funds[msg.sender] + msg.value;
204         funds[msg.sender] = 0;
205         uint conversionID = intercrypto_convert(amount, _coinSymbol, _toAddress);
206         WithdrawalInterCrypto(conversionID);
207     }
208     
209     
210     function intercrypto_recover() onlyOwner public {
211         interCrypto.recover();
212     }
213     
214     function intercrypto_recoverable() constant public returns (uint) {
215         return interCrypto.recoverable(this);
216     }
217     
218     function intercrypto_cancelConversion(uint conversionID) onlyOwner external {
219         interCrypto.cancelConversion(conversionID);
220     }
221     
222     function kill() onlyOwner external {
223         selfdestruct(owner);
224     }
225 }