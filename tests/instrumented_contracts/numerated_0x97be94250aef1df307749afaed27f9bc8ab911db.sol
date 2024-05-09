1 // SPDX-License-Identifier: MIT
2 // File: contracts/ICounterfactualNFT.sol
3 
4 // Copyright 2017 Loopring Technology Limited.
5 
6 pragma solidity ^0.8.2;
7 
8 
9 /**
10  * @title ICounterfactualNFT
11  */
12 abstract contract ICounterfactualNFT
13 {
14     function initialize(address owner, string memory _uri)
15         public
16         virtual;
17 }
18 
19 // File: @openzeppelin/contracts-upgradeable/utils/Create2Upgradeable.sol
20 
21 // OpenZeppelin Contracts v4.4.1 (utils/Create2.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
27  * `CREATE2` can be used to compute in advance the address where a smart
28  * contract will be deployed, which allows for interesting new mechanisms known
29  * as 'counterfactual interactions'.
30  *
31  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
32  * information.
33  */
34 library Create2Upgradeable {
35     /**
36      * @dev Deploys a contract using `CREATE2`. The address where the contract
37      * will be deployed can be known in advance via {computeAddress}.
38      *
39      * The bytecode for a contract can be obtained from Solidity with
40      * `type(contractName).creationCode`.
41      *
42      * Requirements:
43      *
44      * - `bytecode` must not be empty.
45      * - `salt` must have not been used for `bytecode` already.
46      * - the factory must have a balance of at least `amount`.
47      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
48      */
49     function deploy(
50         uint256 amount,
51         bytes32 salt,
52         bytes memory bytecode
53     ) internal returns (address) {
54         address addr;
55         require(address(this).balance >= amount, "Create2: insufficient balance");
56         require(bytecode.length != 0, "Create2: bytecode length is zero");
57         assembly {
58             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
59         }
60         require(addr != address(0), "Create2: Failed on deploy");
61         return addr;
62     }
63 
64     /**
65      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
66      * `bytecodeHash` or `salt` will result in a new destination address.
67      */
68     function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
69         return computeAddress(salt, bytecodeHash, address(this));
70     }
71 
72     /**
73      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
74      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
75      */
76     function computeAddress(
77         bytes32 salt,
78         bytes32 bytecodeHash,
79         address deployer
80     ) internal pure returns (address) {
81         bytes32 _data = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash));
82         return address(uint160(uint256(_data)));
83     }
84 }
85 
86 // File: contracts/external/CloneFactory.sol
87 
88 // This code is taken from https://eips.ethereum.org/EIPS/eip-1167
89 // Modified to a library and generalized to support create/create2.
90 pragma solidity ^0.8.2;
91 
92 /*
93 The MIT License (MIT)
94 
95 Copyright (c) 2018 Murray Software, LLC.
96 
97 Permission is hereby granted, free of charge, to any person obtaining
98 a copy of this software and associated documentation files (the
99 "Software"), to deal in the Software without restriction, including
100 without limitation the rights to use, copy, modify, merge, publish,
101 distribute, sublicense, and/or sell copies of the Software, and to
102 permit persons to whom the Software is furnished to do so, subject to
103 the following conditions:
104 
105 The above copyright notice and this permission notice shall be included
106 in all copies or substantial portions of the Software.
107 
108 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
109 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
110 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
111 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
112 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
113 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
114 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
115 */
116 //solhint-disable max-line-length
117 //solhint-disable no-inline-assembly
118 
119 library CloneFactory {
120   function getByteCode(address target) internal pure returns (bytes memory byteCode) {
121     bytes20 targetBytes = bytes20(target);
122     assembly {
123       byteCode := mload(0x40)
124       mstore(byteCode, 0x37)
125 
126       let clone := add(byteCode, 0x20)
127       mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
128       mstore(add(clone, 0x14), targetBytes)
129       mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
130 
131       mstore(0x40, add(byteCode, 0x60))
132     }
133   }
134 }
135 
136 // File: ../contracts/NFTFactory.sol
137 
138 // Copyright 2017 Loopring Technology Limited.
139 pragma solidity ^0.8.2;
140 pragma experimental ABIEncoderV2;
141 
142 
143 
144 /// @title NFTFactory
145 /// @author Brecht Devos - <brecht@loopring.org>
146 contract NFTFactory
147 {
148     event NFTContractCreated (address nftContract, address owner, string baseURI);
149 
150     string public constant NFT_CONTRACT_CREATION = "NFT_CONTRACT_CREATION";
151     address public immutable implementation;
152 
153     constructor(
154         address _implementation
155         )
156     {
157         implementation = _implementation;
158     }
159 
160     /// @dev Create a new NFT contract.
161     /// @param owner The NFT contract owner.
162     /// @param baseURI The base token URI (empty string allowed/encouraged to use IPFS mode)
163     /// @return nftContract The new NFT contract address
164     function createNftContract(
165         address            owner,
166         string    calldata baseURI
167         )
168         external
169         payable
170         returns (address nftContract)
171     {
172         // Deploy the proxy contract
173         nftContract = Create2Upgradeable.deploy(
174             0,
175             keccak256(abi.encodePacked(NFT_CONTRACT_CREATION, owner, baseURI)),
176             CloneFactory.getByteCode(implementation)
177         );
178 
179         // Initialize
180         ICounterfactualNFT(nftContract).initialize(owner, baseURI);
181 
182         emit NFTContractCreated(nftContract, owner, baseURI);
183     }
184 
185     function computeNftContractAddress(
186         address          owner,
187         string  calldata baseURI
188         )
189         public
190         view
191         returns (address)
192     {
193         return _computeAddress(owner, baseURI);
194     }
195 
196     function getNftContractCreationCode()
197         public
198         view
199         returns (bytes memory)
200     {
201         return CloneFactory.getByteCode(implementation);
202     }
203 
204     function _computeAddress(
205         address          owner,
206         string  calldata baseURI
207         )
208         private
209         view
210         returns (address)
211     {
212         return Create2Upgradeable.computeAddress(
213             keccak256(abi.encodePacked(NFT_CONTRACT_CREATION, owner, baseURI)),
214             keccak256(CloneFactory.getByteCode(implementation))
215         );
216     }
217 }