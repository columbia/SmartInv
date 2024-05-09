1 pragma solidity 0.8.7;
2 
3 interface WnsRegistryInterface {
4     function owner() external view returns (address);
5     function getWnsAddress(string memory _label) external view returns (address);
6     function setRecord(bytes32 _hash, uint256 _tokenId, string memory _name) external;
7     function setRecord(uint256 _tokenId, string memory _name) external;
8     function getRecord(bytes32 _hash) external view returns (uint256);
9     
10 }
11 
12 pragma solidity 0.8.7;
13 
14 interface WnsErc721Interface {
15     function mintErc721(address to) external;
16     function getNextTokenId() external view returns (uint256);
17     function ownerOf(uint256 tokenId) external view returns (address);
18 
19 }
20 
21 
22 pragma solidity 0.8.7;
23 
24 contract Computation {
25     function computeNamehash(string memory _name) public pure returns (bytes32 namehash) {
26         namehash = 0x0000000000000000000000000000000000000000000000000000000000000000;
27         namehash = keccak256(
28         abi.encodePacked(namehash, keccak256(abi.encodePacked('eth')))
29         );
30         namehash = keccak256(
31         abi.encodePacked(namehash, keccak256(abi.encodePacked(_name)))
32         );
33     }
34 }
35 
36 pragma solidity 0.8.7;
37 
38 
39 abstract contract Signatures {
40 
41     struct Register {
42         string name;
43         string extension;
44         address registrant;
45         uint256 cost;
46         uint256 expiration;
47         address[] splitAddresses;
48         uint256[] splitAmounts;
49     }
50      
51    function verifySignature(Register memory _register, bytes memory sig) internal pure returns(address) {
52         bytes32 message = keccak256(abi.encode(_register.name, _register.extension, _register.registrant, _register.cost, _register.expiration, _register.splitAddresses, _register.splitAmounts));
53         return recoverSigner(message, sig);
54    }
55 
56    function recoverSigner(bytes32 message, bytes memory sig)
57        public
58        pure
59        returns (address)
60      {
61        uint8 v;
62        bytes32 r;
63        bytes32 s;
64        (v, r, s) = splitSignature(sig);
65        return ecrecover(message, v, r, s);
66    }
67 
68    function splitSignature(bytes memory sig)
69        internal
70        pure
71        returns (uint8, bytes32, bytes32)
72      {
73        require(sig.length == 65);
74 
75        bytes32 r;
76        bytes32 s;
77        uint8 v;
78 
79        assembly {
80            // first 32 bytes, after the length prefix
81            r := mload(add(sig, 32))
82            // second 32 bytes
83            s := mload(add(sig, 64))
84            // final byte (first byte of the next 32 bytes)
85            v := byte(0, mload(add(sig, 96)))
86        }
87  
88        return (v, r, s);
89    }
90 }
91 
92 // SPDX-License-Identifier: MIT
93 
94 pragma solidity 0.8.7;
95 
96 contract WnsRegistrar is Computation, Signatures {
97 
98     address private WnsRegistry;
99     WnsRegistryInterface wnsRegistry;
100 
101     constructor(address registry_) {
102         WnsRegistry = registry_;
103         wnsRegistry = WnsRegistryInterface(WnsRegistry);
104     }
105 
106     function setRegistry(address _registry) public {
107         require(msg.sender == wnsRegistry.owner(), "Not authorized.");
108         WnsRegistry = _registry;
109         wnsRegistry = WnsRegistryInterface(WnsRegistry);
110     }
111 
112     bool public isActive = false;
113 
114     function wnsRegister(Register[] memory register, bytes[] memory sig) public payable {
115         require(isActive, "Registration must be active.");
116         require(register.length == sig.length, "Invalid parameters.");
117         require(calculateCost(register) <= msg.value, "Ether value is not correct.");
118         for(uint256 i=0; i<register.length; i++) {
119             _register(register[i], sig[i]);
120         }
121     }
122 
123     function _register(Register memory register, bytes memory sig) internal {
124         WnsErc721Interface wnsErc721 = WnsErc721Interface(wnsRegistry.getWnsAddress("_wnsErc721"));
125         require(verifySignature(register,sig) == wnsRegistry.getWnsAddress("_wnsSigner"), "Not authorized.");
126         require(register.expiration >= block.timestamp, "Expired credentials.");
127         bytes32 _hash = computeNamehash(register.name);
128         require(wnsRegistry.getRecord(_hash) == 0, "Name already exists.");
129         
130         wnsErc721.mintErc721(register.registrant);
131         wnsRegistry.setRecord(_hash, wnsErc721.getNextTokenId(), string(abi.encodePacked(register.name, register.extension)));
132         settleSplits(register.splitAddresses, register.splitAmounts);
133     }
134 
135     function migrateExtension(string memory _name, string memory _extension, bytes memory sig) public {
136         WnsErc721Interface wnsErc721 = WnsErc721Interface(wnsRegistry.getWnsAddress("_wnsErc721"));
137         bytes32 message = keccak256(abi.encode(_name, _extension));
138         require(recoverSigner(message, sig) == wnsRegistry.getWnsAddress("_wnsSigner"), "Not authorized.");
139         uint256 _tokenId = wnsRegistry.getRecord(computeNamehash(_name)) - 1;
140         require(wnsErc721.ownerOf(_tokenId) == msg.sender, "Not owned by caller");
141         wnsRegistry.setRecord(_tokenId + 1, string(abi.encodePacked(_name, _extension)));
142     }
143 
144     function calculateCost(Register[] memory register) internal pure returns (uint256) {
145         uint256 cost;
146         for(uint256 i=0; i<register.length; i++) {
147             cost = cost + register[i].cost;
148         }
149         return cost;
150     }
151 
152     function settleSplits(address[] memory splitAddresses, uint256[] memory splitAmounts) internal {
153         uint256 addLength = splitAddresses.length;
154         uint256 amountLength = splitAmounts.length;
155         require(addLength == amountLength, "Invalid parameters.");
156         if(addLength > 0) {
157             for(uint256 i=0; i<addLength; i++) {
158                 payable(splitAddresses[i]).transfer(splitAmounts[i]);
159             }
160         }
161     }
162 
163     function withdraw(address to, uint256 amount) public {
164         require(msg.sender == wnsRegistry.owner());
165         require(amount <= address(this).balance);
166         payable(to).transfer(amount);
167     }
168     
169     function flipActiveState() public {
170         require(msg.sender == wnsRegistry.owner());
171         isActive = !isActive;
172     }
173 
174 }