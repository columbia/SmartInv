1 pragma solidity 0.5.8; // optimization enabled, 99999 runs
2 
3 
4 /**
5  * @title Immutable Create2 Contract Factory
6  * @author 0age
7  * @notice This contract provides a safeCreate2 function that takes a salt value
8  * and a block of initialization code as arguments and passes them into inline
9  * assembly. The contract prevents redeploys by maintaining a mapping of all
10  * contracts that have already been deployed, and prevents frontrunning or other
11  * collisions by requiring that the first 20 bytes of the salt are equal to the
12  * address of the caller (this can be bypassed by setting the first 20 bytes to
13  * the null address). There is also a view function that computes the address of
14  * the contract that will be created when submitting a given salt or nonce along
15  * with a given block of initialization code.
16  * @dev This contract has not yet been fully tested or audited - proceed with
17  * caution and please share any exploits or optimizations you discover.
18  */
19 contract ImmutableCreate2Factory {
20   // mapping to track which addresses have already been deployed.
21   mapping(address => bool) private _deployed;
22 
23   /**
24    * @dev Create a contract using CREATE2 by submitting a given salt or nonce
25    * along with the initialization code for the contract. Note that the first 20
26    * bytes of the salt must match those of the calling address, which prevents
27    * contract creation events from being submitted by unintended parties.
28    * @param salt bytes32 The nonce that will be passed into the CREATE2 call.
29    * @param initializationCode bytes The initialization code that will be passed
30    * into the CREATE2 call.
31    * @return Address of the contract that will be created, or the null address
32    * if a contract already exists at that address.
33    */
34   function safeCreate2(
35     bytes32 salt,
36     bytes calldata initializationCode
37   ) external payable containsCaller(salt) returns (address deploymentAddress) {
38     // move the initialization code from calldata to memory.
39     bytes memory initCode = initializationCode;
40 
41     // determine the target address for contract deployment.
42     address targetDeploymentAddress = address(
43       uint160(                    // downcast to match the address type.
44         uint256(                  // convert to uint to truncate upper digits.
45           keccak256(              // compute the CREATE2 hash using 4 inputs.
46             abi.encodePacked(     // pack all inputs to the hash together.
47               hex"ff",            // start with 0xff to distinguish from RLP.
48               address(this),      // this contract will be the caller.
49               salt,               // pass in the supplied salt value.
50               keccak256(          // pass in the hash of initialization code.
51                 abi.encodePacked(
52                   initCode
53                 )
54               )
55             )
56           )
57         )
58       )
59     );
60 
61     // ensure that a contract hasn't been previously deployed to target address.
62     require(
63       !_deployed[targetDeploymentAddress],
64       "Invalid contract creation - contract has already been deployed."
65     );
66 
67     // using inline assembly: load data and length of data, then call CREATE2.
68     assembly {                                // solhint-disable-line
69       let encoded_data := add(0x20, initCode) // load initialization code.
70       let encoded_size := mload(initCode)     // load the init code's length.
71       deploymentAddress := create2(           // call CREATE2 with 4 arguments.
72         callvalue,                            // forward any attached value.
73         encoded_data,                         // pass in initialization code.
74         encoded_size,                         // pass in init code's length.
75         salt                                  // pass in the salt value.
76       )
77     }
78 
79     // check address against target to ensure that deployment was successful.
80     require(
81       deploymentAddress == targetDeploymentAddress,
82       "Failed to deploy contract using provided salt and initialization code."
83     );
84 
85     // record the deployment of the contract to prevent redeploys.
86     _deployed[deploymentAddress] = true;
87   }
88 
89   /**
90    * @dev Compute the address of the contract that will be created when
91    * submitting a given salt or nonce to the contract along with the contract's
92    * initialization code. The CREATE2 address is computed in accordance with
93    * EIP-1014, and adheres to the formula therein of
94    * `keccak256( 0xff ++ address ++ salt ++ keccak256(init_code)))[12:]` when
95    * performing the computation. The computed address is then checked for any
96    * existing contract code - if so, the null address will be returned instead.
97    * @param salt bytes32 The nonce passed into the CREATE2 address calculation.
98    * @param initCode bytes The contract initialization code to be used.
99    * that will be passed into the CREATE2 address calculation.
100    * @return Address of the contract that will be created, or the null address
101    * if a contract has already been deployed to that address.
102    */
103   function findCreate2Address(
104     bytes32 salt,
105     bytes calldata initCode
106   ) external view returns (address deploymentAddress) {
107     // determine the address where the contract will be deployed.
108     deploymentAddress = address(
109       uint160(                      // downcast to match the address type.
110         uint256(                    // convert to uint to truncate upper digits.
111           keccak256(                // compute the CREATE2 hash using 4 inputs.
112             abi.encodePacked(       // pack all inputs to the hash together.
113               hex"ff",              // start with 0xff to distinguish from RLP.
114               address(this),        // this contract will be the caller.
115               salt,                 // pass in the supplied salt value.
116               keccak256(            // pass in the hash of initialization code.
117                 abi.encodePacked(
118                   initCode
119                 )
120               )
121             )
122           )
123         )
124       )
125     );
126 
127     // return null address to signify failure if contract has been deployed.
128     if (_deployed[deploymentAddress]) {
129       return address(0);
130     }
131   }
132 
133   /**
134    * @dev Compute the address of the contract that will be created when
135    * submitting a given salt or nonce to the contract along with the keccak256
136    * hash of the contract's initialization code. The CREATE2 address is computed
137    * in accordance with EIP-1014, and adheres to the formula therein of
138    * `keccak256( 0xff ++ address ++ salt ++ keccak256(init_code)))[12:]` when
139    * performing the computation. The computed address is then checked for any
140    * existing contract code - if so, the null address will be returned instead.
141    * @param salt bytes32 The nonce passed into the CREATE2 address calculation.
142    * @param initCodeHash bytes32 The keccak256 hash of the initialization code
143    * that will be passed into the CREATE2 address calculation.
144    * @return Address of the contract that will be created, or the null address
145    * if a contract has already been deployed to that address.
146    */
147   function findCreate2AddressViaHash(
148     bytes32 salt,
149     bytes32 initCodeHash
150   ) external view returns (address deploymentAddress) {
151     // determine the address where the contract will be deployed.
152     deploymentAddress = address(
153       uint160(                      // downcast to match the address type.
154         uint256(                    // convert to uint to truncate upper digits.
155           keccak256(                // compute the CREATE2 hash using 4 inputs.
156             abi.encodePacked(       // pack all inputs to the hash together.
157               hex"ff",              // start with 0xff to distinguish from RLP.
158               address(this),        // this contract will be the caller.
159               salt,                 // pass in the supplied salt value.
160               initCodeHash          // pass in the hash of initialization code.
161             )
162           )
163         )
164       )
165     );
166 
167     // return null address to signify failure if contract has been deployed.
168     if (_deployed[deploymentAddress]) {
169       return address(0);
170     }
171   }
172 
173   /**
174    * @dev Determine if a contract has already been deployed by the factory to a
175    * given address.
176    * @param deploymentAddress address The contract address to check.
177    * @return True if the contract has been deployed, false otherwise.
178    */
179   function hasBeenDeployed(
180     address deploymentAddress
181   ) external view returns (bool) {
182     // determine if a contract has been deployed to the provided address.
183     return _deployed[deploymentAddress];
184   }
185 
186   /**
187    * @dev Modifier to ensure that the first 20 bytes of a submitted salt match
188    * those of the calling account. This provides protection against the salt
189    * being stolen by frontrunners or other attackers. The protection can also be
190    * bypassed if desired by setting each of the first 20 bytes to zero.
191    * @param salt bytes32 The salt value to check against the calling address.
192    */
193   modifier containsCaller(bytes32 salt) {
194     // prevent contract submissions from being stolen from tx.pool by requiring
195     // that first 20 bytes of the submitted salt match msg.sender or are empty.
196     require(
197       (address(bytes20(salt)) == msg.sender) ||
198       (bytes20(salt) == bytes20(0)),
199       "Invalid salt - first 20 bytes of the salt must match calling address."
200     );
201     _;
202   }
203 }