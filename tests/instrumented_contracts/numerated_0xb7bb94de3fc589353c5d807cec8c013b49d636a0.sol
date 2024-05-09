1 // File: contracts/lib/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
8 
9     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
10     constructor() public { owner = msg.sender; }
11 
12     /// @dev Throws if called by any contract other than latest designated caller
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
19     /// @param newOwner The address to transfer ownership to.
20     function transferOwnership(address newOwner) public onlyOwner {
21         require(newOwner != address(0));
22         emit OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24     }
25 }
26 
27 // File: contracts/lib/token/FactoryTokenInterface.sol
28 
29 pragma solidity ^0.4.24;
30 
31 
32 contract FactoryTokenInterface is Ownable {
33     function balanceOf(address _owner) public view returns (uint256);
34     function transfer(address _to, uint256 _value) public returns (bool);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
36     function approve(address _spender, uint256 _value) public returns (bool);
37     function allowance(address _owner, address _spender) public view returns (uint256);
38     function mint(address _to, uint256 _amount) public returns (bool);
39     function burnFrom(address _from, uint256 _value) public;
40 }
41 
42 // File: contracts/lib/token/TokenFactoryInterface.sol
43 
44 pragma solidity ^0.4.24;
45 
46 
47 contract TokenFactoryInterface {
48     function create(string _name, string _symbol) public returns (FactoryTokenInterface);
49 }
50 
51 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
52 
53 pragma solidity ^0.4.24;
54 
55 
56 contract ZapCoordinatorInterface is Ownable {
57     function addImmutableContract(string contractName, address newAddress) external;
58     function updateContract(string contractName, address newAddress) external;
59     function getContractName(uint index) public view returns (string);
60     function getContract(string contractName) public view returns (address);
61     function updateAllDependencies() external;
62 }
63 
64 // File: contracts/platform/bondage/BondageInterface.sol
65 
66 pragma solidity ^0.4.24;
67 
68 contract BondageInterface {
69     function bond(address, bytes32, uint256) external returns(uint256);
70     function unbond(address, bytes32, uint256) external returns (uint256);
71     function delegateBond(address, address, bytes32, uint256) external returns(uint256);
72     function escrowDots(address, address, bytes32, uint256) external returns (bool);
73     function releaseDots(address, address, bytes32, uint256) external returns (bool);
74     function returnDots(address, address, bytes32, uint256) external returns (bool success);
75     function calcZapForDots(address, bytes32, uint256) external view returns (uint256);
76     function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
77     function getDotsIssued(address, bytes32) public view returns (uint256);
78     function getBoundDots(address, address, bytes32) public view returns (uint256);
79     function getZapBound(address, bytes32) public view returns (uint256);
80     function dotLimit( address, bytes32) public view returns (uint256);
81 }
82 
83 // File: contracts/platform/bondage/currentCost/CurrentCostInterface.sol
84 
85 pragma solidity ^0.4.24;
86 
87 contract CurrentCostInterface {
88     function _currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
89     function _dotLimit(address, bytes32) public view returns (uint256);
90     function _costOfNDots(address, bytes32, uint256, uint256) public view returns (uint256);
91 }
92 
93 // File: contracts/platform/registry/RegistryInterface.sol
94 
95 pragma solidity ^0.4.24;
96 
97 contract RegistryInterface {
98     function initiateProvider(uint256, bytes32) public returns (bool);
99     function initiateProviderCurve(bytes32, int256[], address) public returns (bool);
100     function setEndpointParams(bytes32, bytes32[]) public;
101     function getEndpointParams(address, bytes32) public view returns (bytes32[]);
102     function getProviderPublicKey(address) public view returns (uint256);
103     function getProviderTitle(address) public view returns (bytes32);
104     function setProviderParameter(bytes32, bytes) public;
105     function setProviderTitle(bytes32) public;
106     function clearEndpoint(bytes32) public;
107     function getProviderParameter(address, bytes32) public view returns (bytes);
108     function getAllProviderParams(address) public view returns (bytes32[]);
109     function getProviderCurveLength(address, bytes32) public view returns (uint256);
110     function getProviderCurve(address, bytes32) public view returns (int[]);
111     function isProviderInitiated(address) public view returns (bool);
112     function getAllOracles() external view returns (address[]);
113     function getProviderEndpoints(address) public view returns (bytes32[]);
114     function getEndpointBroker(address, bytes32) public view returns (address);
115 }
116 
117 // File: contracts/lib/platform/TokenDotFactory.sol
118 
119 contract TokenDotFactory is Ownable {
120 
121     CurrentCostInterface currentCost;
122     FactoryTokenInterface public reserveToken;
123     ZapCoordinatorInterface public coord;
124     TokenFactoryInterface public tokenFactory;
125     BondageInterface bondage;
126 
127     mapping(bytes32 => address) public curves;
128 
129     event DotTokenCreated(address tokenAddress);
130 
131     constructor(
132         address coordinator, 
133         address factory,
134         uint256 providerPubKey,
135         bytes32 providerTitle 
136     ){
137         coord = ZapCoordinatorInterface(coordinator); 
138         reserveToken = FactoryTokenInterface(coord.getContract("ZAP_TOKEN"));
139         //always allow bondage to transfer from wallet
140         reserveToken.approve(coord.getContract("BONDAGE"), ~uint256(0));
141         tokenFactory = TokenFactoryInterface(factory);
142 
143         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
144         registry.initiateProvider(providerPubKey, providerTitle);
145     }
146 
147     function initializeCurve(
148         bytes32 specifier, 
149         bytes32 symbol, 
150         int256[] curve
151     ) public returns(address) {
152         
153         require(curves[specifier] == 0, "Curve specifier already exists");
154         
155         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
156         require(registry.isProviderInitiated(address(this)), "Provider not intiialized");
157 
158         registry.initiateProviderCurve(specifier, curve, address(this));
159         curves[specifier] = newToken(bytes32ToString(specifier), bytes32ToString(symbol));
160         
161         registry.setProviderParameter(specifier, toBytes(curves[specifier]));
162         
163         DotTokenCreated(curves[specifier]);
164         return curves[specifier];
165     }
166 
167 
168     event Bonded(bytes32 indexed specifier, uint256 indexed numDots, address indexed sender); 
169 
170     //whether this contract holds tokens or coming from msg.sender,etc
171     function bond(bytes32 specifier, uint numDots) public  {
172 
173         bondage = BondageInterface(coord.getContract("BONDAGE"));
174         uint256 issued = bondage.getDotsIssued(address(this), specifier);
175 
176         CurrentCostInterface cost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
177         uint256 numReserve = cost._costOfNDots(address(this), specifier, issued + 1, numDots - 1);
178 
179         require(
180             reserveToken.transferFrom(msg.sender, address(this), numReserve),
181             "insufficient accepted token numDots approved for transfer"
182         );
183 
184         reserveToken.approve(address(bondage), numReserve);
185         bondage.bond(address(this), specifier, numDots);
186         FactoryTokenInterface(curves[specifier]).mint(msg.sender, numDots);
187         Bonded(specifier, numDots, msg.sender);
188 
189     }
190 
191     event Unbonded(bytes32 indexed specifier, uint256 indexed numDots, address indexed sender); 
192 
193     //whether this contract holds tokens or coming from msg.sender,etc
194     function unbond(bytes32 specifier, uint numDots) public {
195 
196         bondage = BondageInterface(coord.getContract("BONDAGE"));
197         uint issued = bondage.getDotsIssued(address(this), specifier);
198 
199         currentCost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
200         uint reserveCost = currentCost._costOfNDots(address(this), specifier, issued + 1 - numDots, numDots - 1);
201 
202         //unbond dots
203         bondage.unbond(address(this), specifier, numDots);
204         //burn dot backed token
205         FactoryTokenInterface curveToken = FactoryTokenInterface(curves[specifier]);
206         curveToken.burnFrom(msg.sender, numDots);
207 
208         require(reserveToken.transfer(msg.sender, reserveCost), "Error: Transfer failed");
209         Unbonded(specifier, numDots, msg.sender);
210 
211     }
212 
213     function newToken(
214         string name,
215         string symbol
216     ) 
217         public
218         returns (address tokenAddress) 
219     {
220         FactoryTokenInterface token = tokenFactory.create(name, symbol);
221         tokenAddress = address(token);
222         return tokenAddress;
223     }
224 
225     function getTokenAddress(bytes32 specifier) public view returns(address) {
226         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
227         return bytesToAddr(registry.getProviderParameter(address(this), specifier));
228     }
229 
230     // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
231     function toBytes(address x) public pure returns (bytes b) {
232         b = new bytes(20);
233         for (uint i = 0; i < 20; i++)
234             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
235     }
236 
237     //https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
238     function bytes32ToString(bytes32 x) public pure returns (string) {
239         bytes memory bytesString = new bytes(32);
240 
241         bytesString = abi.encodePacked(x);
242 
243         return string(bytesString);
244     }
245 
246     //https://ethereum.stackexchange.com/questions/15350/how-to-convert-an-bytes-to-address-in-solidity
247     function bytesToAddr (bytes b) public pure returns (address) {
248         uint result = 0;
249         for (uint i = b.length-1; i+1 > 0; i--) {
250             uint c = uint(b[i]);
251             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
252             result += to_inc;
253         }
254         return address(result);
255     }
256 
257 
258 }