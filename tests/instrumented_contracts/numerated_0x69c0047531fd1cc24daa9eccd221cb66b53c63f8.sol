1 /**
2 Author: Authereum Labs, Inc.
3 */
4 
5 pragma solidity 0.5.12;
6 pragma experimental ABIEncoderV2;
7 
8 
9 contract Owned {
10 
11     // The owner
12     address public owner;
13 
14     event OwnerChanged(address indexed _newOwner);
15 
16     /// @dev Throws if the sender is not the owner
17     modifier onlyOwner {
18         require(msg.sender == owner, "Must be owner");
19         _;
20     }
21 
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /// @dev Return the ownership status of an address
27     /// @param _potentialOwner Address being checked
28     /// @return True if the _potentialOwner is the owner
29     function isOwner(address _potentialOwner) external view returns (bool) {
30         return owner == _potentialOwner;
31     }
32 
33     /// @dev Lets the owner transfer ownership of the contract to a new owner
34     /// @param _newOwner The new owner
35     function changeOwner(address _newOwner) external onlyOwner {
36         require(_newOwner != address(0), "Address must not be null");
37         owner = _newOwner;
38         emit OwnerChanged(_newOwner);
39     }
40 }
41 
42 contract AuthereumProxy {
43     string constant public authereumProxyVersion = "2019102500";
44 
45     /// @dev Storage slot with the address of the current implementation.
46     /// @notice This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted 
47     /// @notice by 1, and is validated in the constructor.
48     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
49 
50     /// @dev Set the implementation in the constructor
51     /// @param _logic Address of the logic contract
52     constructor(address _logic) public payable {
53         bytes32 slot = IMPLEMENTATION_SLOT;
54         assembly {
55             sstore(slot, _logic)
56         }
57     }
58 
59     /// @dev Fallback function
60     /// @notice A payable fallback needs to be implemented in the implementation contract
61     /// @notice This is a low level function that doesn't return to its internal call site.
62     /// @notice It will return to the external caller whatever the implementation returns.
63     function () external payable {
64         if (msg.data.length == 0) return;
65         address _implementation = implementation();
66 
67         assembly {
68             // Copy msg.data. We take full control of memory in this inline assembly
69             // block because it will not return to Solidity code. We overwrite the
70             // Solidity scratch pad at memory position 0.
71             calldatacopy(0, 0, calldatasize)
72 
73             // Call the implementation.
74             // out and outsize are 0 because we don't know the size yet.
75             let result := delegatecall(gas, _implementation, 0, calldatasize, 0, 0)
76 
77             // Copy the returned data.
78             returndatacopy(0, 0, returndatasize)
79 
80             switch result
81             // delegatecall returns 0 on error.
82             case 0 { revert(0, returndatasize) }
83             default { return(0, returndatasize) }
84         }
85     }
86 
87     /// @dev Returns the current implementation.
88     /// @return Address of the current implementation
89     function implementation() public view returns (address impl) {
90         bytes32 slot = IMPLEMENTATION_SLOT;
91         assembly {
92             impl := sload(slot)
93         }
94     }
95 }
96 
97 contract AuthereumEnsManager {
98     function register(string calldata _label, address _owner) external {}
99 }
100 
101 contract AuthereumProxyFactory is Owned {
102     string constant public authereumProxyFactoryVersion = "2019111500";
103     bytes private initCode;
104     address private authereumEnsManagerAddress;
105     
106     AuthereumEnsManager authereumEnsManager;
107 
108     event initCodeChanged(bytes initCode);
109     event authereumEnsManagerChanged(address indexed authereumEnsManager);
110 
111     /// @dev Constructor
112     /// @param _implementation Address of the Authereum implementation
113     /// @param _authereumEnsManagerAddress Address for the Authereum ENS Manager contract
114     constructor(address _implementation, address _authereumEnsManagerAddress) public {
115         initCode = abi.encodePacked(type(AuthereumProxy).creationCode, uint256(_implementation));
116         authereumEnsManagerAddress =  _authereumEnsManagerAddress;
117         authereumEnsManager = AuthereumEnsManager(authereumEnsManagerAddress);
118         emit initCodeChanged(initCode);
119         emit authereumEnsManagerChanged(authereumEnsManagerAddress);
120     }
121 
122     /**
123      * Setters
124      */
125 
126     /// @dev Setter for the proxy initCode
127     /// @param _initCode Init code off the AuthereumProxy and constructor
128     function setInitCode(bytes memory _initCode) public onlyOwner {
129         initCode = _initCode;
130         emit initCodeChanged(initCode);
131     }
132 
133     /// @dev Setter for the Authereum ENS Manager address
134     /// @param _authereumEnsManagerAddress Address of the new Authereum ENS Manager
135     function setAuthereumEnsManager(address _authereumEnsManagerAddress) public onlyOwner {
136         authereumEnsManagerAddress = _authereumEnsManagerAddress;
137         authereumEnsManager = AuthereumEnsManager(authereumEnsManagerAddress);
138         emit authereumEnsManagerChanged(authereumEnsManagerAddress);
139     }
140 
141     /**
142      *  Getters
143      */
144 
145     /// @dev Getter for the proxy initCode
146     /// @return Init code
147     function getInitCode() public view returns (bytes memory) {
148         return initCode;
149     }
150 
151     /// @dev Getter for the private authereumEnsManager variable
152     /// @return Authereum Ens Manager
153     function getAuthereumEnsManager() public view returns (address) {
154         return authereumEnsManagerAddress;
155     }
156 
157     /// @dev Create an Authereum Proxy and iterate through initialize data
158     /// @notice The bytes[] _initData is an array of initialize functions. 
159     /// @notice This is used when a user creates an account e.g. on V5, but V1,2,3, 
160     /// @notice etc. have state vars that need to be included.
161     /// @param _salt A uint256 value to add randomness to the account creation
162     /// @param _label Label for the user's Authereum ENS subdomain
163     /// @param _initData Array of initialize data
164     function createProxy(
165         uint256 _salt, 
166         string memory _label,
167         bytes[] memory _initData
168     ) 
169         public 
170         onlyOwner
171         returns (AuthereumProxy)
172     {
173         address payable addr;
174         bytes memory _initCode = initCode;
175         bytes32 salt = _getSalt(_salt, msg.sender);
176 
177         // Create proxy
178         assembly {
179             addr := create2(0, add(_initCode, 0x20), mload(_initCode), salt)
180             if iszero(extcodesize(addr)) {
181                 revert(0, 0)
182             }
183         }
184 
185         // Loop through initializations of each version of the logic contract
186         bool success;
187         for (uint256 i = 0; i < _initData.length; i++) {
188             if(_initData.length > 0) {
189                 (success,) = addr.call(_initData[i]);
190                 require(success);
191             }
192         }
193 
194         // Set ENS name
195         authereumEnsManager.register(_label, addr);
196 
197         return AuthereumProxy(addr);
198     }
199 
200     /// @dev Generate a salt out of a uint256 value and the sender
201     /// @param _salt A uint256 value to add randomness to the account creation
202     /// @param _sender Sender of the transaction
203     function _getSalt(uint256 _salt, address _sender) internal pure returns (bytes32) {
204         return keccak256(abi.encodePacked(_salt, _sender)); 
205     }
206 }