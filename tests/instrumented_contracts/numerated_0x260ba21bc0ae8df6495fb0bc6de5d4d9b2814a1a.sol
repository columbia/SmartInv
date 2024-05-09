1 /**
2 Author: Authereum Labs, Inc.
3 */
4 
5 pragma solidity 0.5.17;
6 pragma experimental ABIEncoderV2;
7 
8 
9 /**
10  * @title Owned
11  * @author Authereum Labs, Inc.
12  * @dev Basic contract to define an owner.
13  */
14 contract Owned {
15 
16     // The owner
17     address public owner;
18 
19     event OwnerChanged(address indexed _newOwner);
20 
21     /// @dev Throws if the sender is not the owner
22     modifier onlyOwner {
23         require(msg.sender == owner, "O: Must be owner");
24         _;
25     }
26 
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     /// @dev Return the ownership status of an address
32     /// @param _potentialOwner Address being checked
33     /// @return True if the _potentialOwner is the owner
34     function isOwner(address _potentialOwner) external view returns (bool) {
35         return owner == _potentialOwner;
36     }
37 
38     /// @dev Lets the owner transfer ownership of the contract to a new owner
39     /// @param _newOwner The new owner
40     function changeOwner(address _newOwner) external onlyOwner {
41         require(_newOwner != address(0), "O: Address must not be null");
42         owner = _newOwner;
43         emit OwnerChanged(_newOwner);
44     }
45 }
46 
47 /**
48  * @title AuthereumProxy
49  * @author Authereum Labs, Inc.
50  * @dev The Authereum Proxy.
51  */
52 contract AuthereumProxy {
53 
54     // We do not include a name or a version for this contract as this
55     // is a simple proxy. Including them here would overwrite the declaration
56     // of these variables in the implementation.
57 
58     /// @dev Storage slot with the address of the current implementation.
59     /// @notice This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
60     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
61 
62     /// @dev Set the implementation in the constructor
63     /// @param _logic Address of the logic contract
64     constructor(address _logic) public payable {
65         bytes32 slot = IMPLEMENTATION_SLOT;
66         assembly {
67             sstore(slot, _logic)
68         }
69     }
70 
71     /// @dev Fallback function
72     /// @notice A payable fallback needs to be implemented in the implementation contract
73     /// @notice This is a low level function that doesn't return to its internal call site.
74     /// @notice It will return to the external caller whatever the implementation returns.
75     function () external payable {
76         if (msg.data.length == 0) return;
77 
78         assembly {
79             // Load the implementation address from the IMPLEMENTATION_SLOT
80             let impl := sload(IMPLEMENTATION_SLOT)
81 
82             // Copy msg.data. We take full control of memory in this inline assembly
83             // block because it will not return to Solidity code. We overwrite the
84             // Solidity scratch pad at memory position 0.
85             calldatacopy(0, 0, calldatasize)
86 
87             // Call the implementation.
88             // out and outsize are 0 because we don't know the size yet.
89             let result := delegatecall(gas, impl, 0, calldatasize, 0, 0)
90 
91             // Copy the returned data.
92             returndatacopy(0, 0, returndatasize)
93 
94             switch result
95             // delegatecall returns 0 on error.
96             case 0 { revert(0, returndatasize) }
97             default { return(0, returndatasize) }
98         }
99     }
100 }
101 
102 contract AuthereumEnsManager {
103     function register(string calldata _label, address _owner) external {}
104 }
105 
106 /**
107  * @title AuthereumProxyFactory
108  * @author Authereum Labs, Inc.
109  * @dev A factory that creates Authereum Proxies.
110  */
111 contract AuthereumProxyFactory is Owned {
112 
113     string constant public name = "Authereum Proxy Factory";
114     string constant public version = "2020070100";
115 
116     bytes private initCode;
117     address private authereumEnsManagerAddress;
118     
119     AuthereumEnsManager authereumEnsManager;
120 
121     event InitCodeChanged(bytes initCode);
122     event AuthereumEnsManagerChanged(address indexed authereumEnsManager);
123 
124     /// @dev Constructor
125     /// @param _initCode Init code of the AuthereumProxy without the constructor arguments
126     /// @param _authereumEnsManagerAddress Address for the Authereum ENS Manager contract
127     constructor(bytes memory _initCode, address _authereumEnsManagerAddress) public {
128         initCode = _initCode;
129         authereumEnsManagerAddress =  _authereumEnsManagerAddress;
130         authereumEnsManager = AuthereumEnsManager(authereumEnsManagerAddress);
131         emit InitCodeChanged(initCode);
132         emit AuthereumEnsManagerChanged(authereumEnsManagerAddress);
133     }
134 
135     /**
136      * Setters
137      */
138 
139     /// @dev Setter for the proxy initCode without the constructor arguments
140     /// @param _initCode Init code of the AuthereumProxy without the constructor arguments
141     function setInitCode(bytes memory _initCode) public onlyOwner {
142         initCode = _initCode;
143         emit InitCodeChanged(initCode);
144     }
145 
146     /// @dev Setter for the Authereum ENS Manager address
147     /// @param _authereumEnsManagerAddress Address of the new Authereum ENS Manager
148     function setAuthereumEnsManager(address _authereumEnsManagerAddress) public onlyOwner {
149         authereumEnsManagerAddress = _authereumEnsManagerAddress;
150         authereumEnsManager = AuthereumEnsManager(authereumEnsManagerAddress);
151         emit AuthereumEnsManagerChanged(authereumEnsManagerAddress);
152     }
153 
154     /**
155      *  Getters
156      */
157 
158     /// @dev Getter for the proxy initCode without the constructor arguments
159     /// @return Init code
160     function getInitCode() public view returns (bytes memory) {
161         return initCode;
162     }
163 
164     /// @dev Getter for the private authereumEnsManager variable
165     /// @return Authereum Ens Manager
166     function getAuthereumEnsManager() public view returns (address) {
167         return authereumEnsManagerAddress;
168     }
169 
170     /// @dev Create an Authereum Proxy and iterate through initialize data
171     /// @notice The bytes[] _initData is an array of initialize functions. 
172     /// @notice This is used when a user creates an account e.g. on V5, but V1,2,3, 
173     /// @notice etc. have state vars that need to be included.
174     /// @param _salt A uint256 value to add randomness to the account creation
175     /// @param _label Label for the user's Authereum ENS subdomain
176     /// @param _initData Array of initialize data
177     /// @param _implementation Address of the logic contract that the proxy will point to
178     function createProxy(
179         uint256 _salt, 
180         string memory _label,
181         bytes[] memory _initData,
182         address _implementation
183     ) 
184         public 
185         onlyOwner
186         returns (AuthereumProxy)
187     {
188         address payable addr;
189         bytes32 create2Salt = _getCreate2Salt(_salt, _initData, _implementation);
190         bytes memory initCodeWithConstructor = abi.encodePacked(initCode, uint256(_implementation));
191 
192         // Create proxy
193         assembly {
194             addr := create2(0, add(initCodeWithConstructor, 0x20), mload(initCodeWithConstructor), create2Salt)
195             if iszero(extcodesize(addr)) {
196                 revert(0, 0)
197             }
198         }
199 
200         // Loop through initializations of each version of the logic contract
201         bool success;
202         for (uint256 i = 0; i < _initData.length; i++) {
203             require(_initData[i].length != 0, "APF: Empty initialization data");
204             (success,) = addr.call(_initData[i]);
205             require(success, "APF: Unsuccessful account initialization");
206         }
207 
208         // Set ENS name
209         authereumEnsManager.register(_label, addr);
210 
211         return AuthereumProxy(addr);
212     }
213 
214     /// @dev Generate a salt out of a uint256 value and the init data
215     /// @param _salt A uint256 value to add randomness to the account creation
216     /// @param _initData Array of initialize data
217     /// @param _implementation Address of the logic contract that the proxy will point to
218     function _getCreate2Salt(
219         uint256 _salt,
220         bytes[] memory _initData,
221         address _implementation
222     )
223         internal
224         pure
225         returns (bytes32)
226     {
227         bytes32 _initDataHash = keccak256(abi.encode(_initData));
228         return keccak256(abi.encodePacked(_salt, _initDataHash, _implementation));
229     }
230 }