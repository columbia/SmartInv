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
21        require(newOwner != address(0));
22        emit OwnershipTransferred(owner, newOwner);
23        owner = newOwner;
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
48 	function addImmutableContract(string contractName, address newAddress) external;
49 	function updateContract(string contractName, address newAddress) external;
50 	function getContractName(uint index) public view returns (string);
51 	function getContract(string contractName) public view returns (address);
52 	function updateAllDependencies() external;
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
82 // Technically an abstract contract, not interface (solidity compiler devs are working to fix this right now)
83 
84 contract RegistryInterface {
85     function initiateProvider(uint256, bytes32) public returns (bool);
86     function initiateProviderCurve(bytes32, int256[], address) public returns (bool);
87     function setEndpointParams(bytes32, bytes32[]) public;
88     function getEndpointParams(address, bytes32) public view returns (bytes32[]);
89     function getProviderPublicKey(address) public view returns (uint256);
90     function getProviderTitle(address) public view returns (bytes32);
91     function setProviderParameter(bytes32, bytes) public;
92     function setProviderTitle(bytes32) public;
93     function clearEndpoint(bytes32) public;
94     function getProviderParameter(address, bytes32) public view returns (bytes);
95     function getAllProviderParams(address) public view returns (bytes32[]);
96     function getProviderCurveLength(address, bytes32) public view returns (uint256);
97     function getProviderCurve(address, bytes32) public view returns (int[]);
98     function isProviderInitiated(address) public view returns (bool);
99     function getAllOracles() external view returns (address[]);
100     function getProviderEndpoints(address) public view returns (bytes32[]);
101     function getEndpointBroker(address, bytes32) public view returns (address);
102 }
103 
104 // File: contracts/lib/platform/TokenDotFactory.sol
105 
106 contract TokenDotFactory is Ownable {
107 
108     CurrentCostInterface currentCost;
109     FactoryTokenInterface public reserveToken;
110     ZapCoordinatorInterface public coord;
111     TokenFactoryInterface public tokenFactory;
112     BondageInterface bondage;
113 
114     mapping(bytes32 => address) public curves;
115 
116     event DotTokenCreated(address tokenAddress);
117 
118     constructor(
119         address coordinator, 
120         address factory,
121         uint256 providerPubKey,
122         bytes32 providerTitle 
123     ){
124         coord = ZapCoordinatorInterface(coordinator); 
125         reserveToken = FactoryTokenInterface(coord.getContract("ZAP_TOKEN"));
126         //always allow bondage to transfer from wallet
127         reserveToken.approve(coord.getContract("BONDAGE"), ~uint256(0));
128         tokenFactory = TokenFactoryInterface(factory);
129 
130         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
131         registry.initiateProvider(providerPubKey, providerTitle);
132     }
133 
134     function initializeCurve(
135         bytes32 specifier, 
136         bytes32 symbol, 
137         int256[] curve
138     ) public returns(address) {
139         
140         require(curves[specifier] == 0, "Curve specifier already exists");
141         
142         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
143         require(registry.isProviderInitiated(address(this)), "Provider not intiialized");
144 
145         registry.initiateProviderCurve(specifier, curve, address(this));
146         curves[specifier] = newToken(bytes32ToString(specifier), bytes32ToString(symbol));
147         
148         registry.setProviderParameter(specifier, toBytes(curves[specifier]));
149         
150         DotTokenCreated(curves[specifier]);
151         return curves[specifier];
152     }
153 
154 
155     event Bonded(bytes32 indexed specifier, uint256 indexed numDots, address indexed sender); 
156 
157     //whether this contract holds tokens or coming from msg.sender,etc
158     function bond(bytes32 specifier, uint numDots) public  {
159 
160         bondage = BondageInterface(coord.getContract("BONDAGE"));
161         uint256 issued = bondage.getDotsIssued(address(this), specifier);
162 
163         CurrentCostInterface cost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
164         uint256 numReserve = cost._costOfNDots(address(this), specifier, issued + 1, numDots - 1);
165 
166         require(
167             reserveToken.transferFrom(msg.sender, address(this), numReserve),
168             "insufficient accepted token numDots approved for transfer"
169         );
170 
171         reserveToken.approve(address(bondage), numReserve);
172         bondage.bond(address(this), specifier, numDots);
173         FactoryTokenInterface(curves[specifier]).mint(msg.sender, numDots);
174         Bonded(specifier, numDots, msg.sender);
175 
176     }
177 
178     event Unbonded(bytes32 indexed specifier, uint256 indexed numDots, address indexed sender); 
179 
180     //whether this contract holds tokens or coming from msg.sender,etc
181     function unbond(bytes32 specifier, uint numDots) public {
182 
183         bondage = BondageInterface(coord.getContract("BONDAGE"));
184         uint issued = bondage.getDotsIssued(address(this), specifier);
185 
186         currentCost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
187         uint reserveCost = currentCost._costOfNDots(address(this), specifier, issued + 1 - numDots, numDots - 1);
188 
189         //unbond dots
190         bondage.unbond(address(this), specifier, numDots);
191         //burn dot backed token
192         FactoryTokenInterface curveToken = FactoryTokenInterface(curves[specifier]);
193         curveToken.burnFrom(msg.sender, numDots);
194 
195         require(reserveToken.transfer(msg.sender, reserveCost), "Error: Transfer failed");
196         Unbonded(specifier, numDots, msg.sender);
197 
198     }
199 
200     function newToken(
201         string name,
202         string symbol
203     ) 
204         public
205         returns (address tokenAddress) 
206     {
207         FactoryTokenInterface token = tokenFactory.create(name, symbol);
208         tokenAddress = address(token);
209         return tokenAddress;
210     }
211 
212     function getTokenAddress(bytes32 specifier) public view returns(address) {
213         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
214         return bytesToAddr(registry.getProviderParameter(address(this), specifier));
215     }
216 
217     // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
218     function toBytes(address x) public pure returns (bytes b) {
219         b = new bytes(20);
220         for (uint i = 0; i < 20; i++)
221             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
222     }
223 
224     //https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
225     function bytes32ToString(bytes32 x) public pure returns (string) {
226         bytes memory bytesString = new bytes(32);
227 
228         bytesString = abi.encodePacked(x);
229 
230         return string(bytesString);
231     }
232 
233     //https://ethereum.stackexchange.com/questions/15350/how-to-convert-an-bytes-to-address-in-solidity
234     function bytesToAddr (bytes b) public pure returns (address) {
235         uint result = 0;
236         for (uint i = b.length-1; i+1 > 0; i--) {
237             uint c = uint(b[i]);
238             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
239             result += to_inc;
240         }
241         return address(result);
242     }
243 
244 
245 }