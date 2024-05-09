1 pragma solidity ^0.4.24;
2 
3 // File: contracts/lib/ownership/Ownable.sol
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
29 contract FactoryTokenInterface is Ownable {
30     function balanceOf(address _owner) public view returns (uint256);
31     function transfer(address _to, uint256 _value) public returns (bool);
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
33     function approve(address _spender, uint256 _value) public returns (bool);
34     function allowance(address _owner, address _spender) public view returns (uint256);
35     function mint(address _to, uint256 _amount) public returns (bool);
36     function burnFrom(address _from, uint256 _value) public;
37 }
38 
39 // File: contracts/lib/token/TokenFactoryInterface.sol
40 
41 contract TokenFactoryInterface {
42     function create(string _name, string _symbol) public returns (FactoryTokenInterface);
43 }
44 
45 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
46 
47 contract ZapCoordinatorInterface is Ownable {
48     function addImmutableContract(string contractName, address newAddress) external;
49     function updateContract(string contractName, address newAddress) external;
50     function getContractName(uint index) public view returns (string);
51     function getContract(string contractName) public view returns (address);
52     function updateAllDependencies() external;
53 }
54 
55 // File: contracts/platform/bondage/BondageInterface.sol
56 
57 contract BondageInterface {
58     function bond(address, bytes32, uint256) external returns(uint256);
59     function unbond(address, bytes32, uint256) external returns (uint256);
60     function delegateBond(address, address, bytes32, uint256) external returns(uint256);
61     function escrowDots(address, address, bytes32, uint256) external returns (bool);
62     function releaseDots(address, address, bytes32, uint256) external returns (bool);
63     function returnDots(address, address, bytes32, uint256) external returns (bool success);
64     function calcZapForDots(address, bytes32, uint256) external view returns (uint256);
65     function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
66     function getDotsIssued(address, bytes32) public view returns (uint256);
67     function getBoundDots(address, address, bytes32) public view returns (uint256);
68     function getZapBound(address, bytes32) public view returns (uint256);
69     function dotLimit( address, bytes32) public view returns (uint256);
70 }
71 
72 // File: contracts/platform/bondage/currentCost/CurrentCostInterface.sol
73 
74 contract CurrentCostInterface {
75     function _currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
76     function _dotLimit(address, bytes32) public view returns (uint256);
77     function _costOfNDots(address, bytes32, uint256, uint256) public view returns (uint256);
78 }
79 
80 // File: contracts/platform/registry/RegistryInterface.sol
81 
82 contract RegistryInterface {
83     function initiateProvider(uint256, bytes32) public returns (bool);
84     function initiateProviderCurve(bytes32, int256[], address) public returns (bool);
85     function setEndpointParams(bytes32, bytes32[]) public;
86     function getEndpointParams(address, bytes32) public view returns (bytes32[]);
87     function getProviderPublicKey(address) public view returns (uint256);
88     function getProviderTitle(address) public view returns (bytes32);
89     function setProviderParameter(bytes32, bytes) public;
90     function setProviderTitle(bytes32) public;
91     function clearEndpoint(bytes32) public;
92     function getProviderParameter(address, bytes32) public view returns (bytes);
93     function getAllProviderParams(address) public view returns (bytes32[]);
94     function getProviderCurveLength(address, bytes32) public view returns (uint256);
95     function getProviderCurve(address, bytes32) public view returns (int[]);
96     function isProviderInitiated(address) public view returns (bool);
97     function getAllOracles() external view returns (address[]);
98     function getProviderEndpoints(address) public view returns (bytes32[]);
99     function getEndpointBroker(address, bytes32) public view returns (address);
100 }
101 
102 // File: contracts/lib/platform/TokenDotFactory.sol
103 
104 contract TokenDotFactory is Ownable {
105 
106     CurrentCostInterface currentCost;
107     FactoryTokenInterface public reserveToken;
108     ZapCoordinatorInterface public coord;
109     TokenFactoryInterface public tokenFactory;
110     BondageInterface bondage;
111 
112     bytes32 providerTitle; 
113     mapping(bytes32 => address) public curves;
114 
115     event DotTokenCreated(address tokenAddress);
116 
117     constructor(
118         address coordinator, 
119         address factory,
120         uint256 providerPubKey,
121         bytes32 providerTitle 
122     ){
123         coord = ZapCoordinatorInterface(coordinator); 
124         reserveToken = FactoryTokenInterface(coord.getContract("ZAP_TOKEN"));
125         //always allow bondage to transfer from wallet
126         reserveToken.approve(coord.getContract("BONDAGE"), ~uint256(0));
127         tokenFactory = TokenFactoryInterface(factory);
128 
129         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
130         registry.initiateProvider(providerPubKey, providerTitle);
131     }
132 
133     function initializeCurve(
134         bytes32 specifier, 
135         bytes32 symbol, 
136         int256[] curve
137     ) public returns(address) {
138         
139         require(curves[specifier] == 0, "Curve specifier already exists");
140         
141         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
142         require(registry.isProviderInitiated(address(this)), "Provider not intiialized");
143 
144         registry.initiateProviderCurve(specifier, curve, address(this));
145         curves[specifier] = newToken(bytes32ToString(specifier), bytes32ToString(symbol));
146         
147         registry.setProviderParameter(specifier, toBytes(curves[specifier]));
148         
149         DotTokenCreated(curves[specifier]);
150         return curves[specifier];
151     }
152 
153 
154     event Bonded(bytes32 indexed specifier, uint256 indexed numDots, address indexed sender); 
155 
156     //whether this contract holds tokens or coming from msg.sender,etc
157     function bond(bytes32 specifier, uint numDots) public  {
158 
159         bondage = BondageInterface(coord.getContract("BONDAGE"));
160         uint256 issued = bondage.getDotsIssued(address(this), specifier);
161 
162         CurrentCostInterface cost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
163         uint256 numReserve = cost._costOfNDots(address(this), specifier, issued + 1, numDots - 1);
164 
165         require(
166             reserveToken.transferFrom(msg.sender, address(this), numReserve),
167             "insufficient accepted token numDots approved for transfer"
168         );
169 
170         reserveToken.approve(address(bondage), numReserve);
171         bondage.bond(address(this), specifier, numDots);
172         FactoryTokenInterface(curves[specifier]).mint(msg.sender, numDots);
173         Bonded(specifier, numDots, msg.sender);
174 
175     }
176 
177     event Unbonded(bytes32 indexed specifier, uint256 indexed numDots, address indexed sender); 
178 
179     //whether this contract holds tokens or coming from msg.sender,etc
180     function unbond(bytes32 specifier, uint numDots) public {
181 
182         bondage = BondageInterface(coord.getContract("BONDAGE"));
183         uint issued = bondage.getDotsIssued(address(this), specifier);
184 
185         currentCost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
186         uint reserveCost = currentCost._costOfNDots(address(this), specifier, issued + 1 - numDots, numDots - 1);
187 
188         //unbond dots
189         bondage.unbond(address(this), specifier, numDots);
190         //burn dot backed token
191         FactoryTokenInterface curveToken = FactoryTokenInterface(curves[specifier]);
192         curveToken.burnFrom(msg.sender, numDots);
193 
194         require(reserveToken.transfer(msg.sender, reserveCost), "Error: Transfer failed");
195         Unbonded(specifier, numDots, msg.sender);
196 
197     }
198 
199     function newToken(
200         string name,
201         string symbol
202     ) 
203         public
204         returns (address tokenAddress) 
205     {
206         FactoryTokenInterface token = tokenFactory.create(name, symbol);
207         tokenAddress = address(token);
208         return tokenAddress;
209     }
210 
211     function getTokenAddress(bytes32 specifier) public view returns(address) {
212         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
213         return bytesToAddr(registry.getProviderParameter(address(this), specifier));
214     }
215 
216     function getProviderTitle() public view returns(bytes32) {
217         return providerTitle;
218     }
219 
220     // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
221     function toBytes(address x) public pure returns (bytes b) {
222         b = new bytes(20);
223         for (uint i = 0; i < 20; i++)
224             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
225     }
226 
227     //https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
228     function bytes32ToString(bytes32 x) public pure returns (string) {
229         bytes memory bytesString = new bytes(32);
230 
231         bytesString = abi.encodePacked(x);
232 
233         return string(bytesString);
234     }
235 
236     //https://ethereum.stackexchange.com/questions/15350/how-to-convert-an-bytes-to-address-in-solidity
237     function bytesToAddr (bytes b) public pure returns (address) {
238         uint result = 0;
239         for (uint i = b.length-1; i+1 > 0; i--) {
240             uint c = uint(b[i]);
241             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
242             result += to_inc;
243         }
244         return address(result);
245     }
246 
247 
248 }