1 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: contracts\LAND\ILANDRegistry.sol
80 
81 // solium-disable linebreak-style
82 pragma solidity ^0.5.0;
83 
84 interface ILANDRegistry {
85 
86   // LAND can be assigned by the owner
87   function assignNewParcel(int x, int y, address beneficiary) external;
88   function assignMultipleParcels(int[] calldata x, int[] calldata y, address beneficiary) external;
89 
90   // After one year, LAND can be claimed from an inactive public key
91   function ping() external;
92 
93   // LAND-centric getters
94   function encodeTokenId(int x, int y) external pure returns (uint256);
95   function decodeTokenId(uint value) external pure returns (int, int);
96   function exists(int x, int y) external view returns (bool);
97   function ownerOfLand(int x, int y) external view returns (address);
98   function ownerOfLandMany(int[] calldata x, int[] calldata y) external view returns (address[] memory);
99   function landOf(address owner) external view returns (int[] memory, int[] memory);
100   function landData(int x, int y) external view returns (string memory);
101 
102   // Transfer LAND
103   function transferLand(int x, int y, address to) external;
104   function transferManyLand(int[] calldata x, int[] calldata y, address to) external;
105 
106   // Update LAND
107   function updateLandData(int x, int y, string calldata data) external;
108   function updateManyLandData(int[] calldata x, int[] calldata y, string calldata data) external;
109 
110   //operators
111   function setUpdateOperator(uint256 assetId, address operator) external;
112 
113   // Events
114 
115   event Update(
116     uint256 indexed assetId,
117     address indexed holder,
118     address indexed operator,
119     string data
120   );
121 
122   event UpdateOperator(
123     uint256 indexed assetId,
124     address indexed operator
125   );
126 
127   event DeployAuthorized(
128     address indexed _caller,
129     address indexed _deployer
130   );
131 
132   event DeployForbidden(
133     address indexed _caller,
134     address indexed _deployer
135   );
136 }
137 
138 // File: contracts\AetheriaFirstStageProxy.sol
139 
140 pragma solidity ^0.5.0;
141 
142 
143 
144 contract AetheriaFirstStageProxy is Ownable {
145     ILANDRegistry private landContract;
146 	address private delegatedSigner;
147 	mapping(uint256 => uint) private replayProtection;
148 	uint public currentNonce;
149 
150 	constructor (address landContractAddress) public {
151         landContract = ILANDRegistry(landContractAddress);
152 		delegatedSigner = owner();
153 		currentNonce = 1;
154     }
155 
156 	function setDelegatedSigner(address newDelegate) external onlyOwner {
157 		delegatedSigner = newDelegate;
158 		emit DelegateChanged(delegatedSigner);
159 	}
160 
161 	function getDelegatedSigner() public view returns (address ){
162 		return delegatedSigner;
163 	}
164 
165 	function getMessageHash(address userAddress, uint256[] memory plotIds, uint nonce) public pure returns (bytes32)
166 	{
167 		return keccak256(abi.encode(userAddress, plotIds, nonce));
168 	}
169 
170 	function buildPrefixedHash(bytes32 msgHash) public pure returns (bytes32)
171 	{
172 		bytes memory prefix = "\x19Ethereum Signed Message:\n32";
173 		return keccak256(abi.encodePacked(prefix, msgHash));
174 	}
175 
176 	function verifySender(bytes32 msgHash, uint8 _v, bytes32 _r, bytes32 _s) private view returns (bool)
177 	{
178 		bytes32 prefixedHash = buildPrefixedHash(msgHash);
179 		return ecrecover(prefixedHash, _v, _r, _s) == delegatedSigner;
180 	}
181 
182 	function updatePlot(address userAddress, uint256[] calldata plotIds, uint nonce, uint8 _v, bytes32 _r, bytes32 _s) external {
183 		bytes32 msgHash = getMessageHash(userAddress, plotIds, nonce);
184 		require(verifySender(msgHash, _v, _r, _s), "Invalid Sig");
185         for (uint i = 0; i<plotIds.length; i++) {
186 			if(replayProtection[plotIds[i]] > nonce) {
187 				landContract.setUpdateOperator(plotIds[i], userAddress);
188 				replayProtection[plotIds[i]]++;
189 			}
190         }
191         if (currentNonce <= nonce)
192         {
193             currentNonce = nonce+1;
194         }
195 		emit PlotOwnerUpdate(
196 			userAddress,
197 			plotIds
198 		);
199 	}
200 
201 	event DelegateChanged(
202 		address newDelegatedAddress
203 	);
204 
205 	event PlotOwnerUpdate(
206 		address newOperator,
207 		uint256[] plotIds
208 	);
209 }