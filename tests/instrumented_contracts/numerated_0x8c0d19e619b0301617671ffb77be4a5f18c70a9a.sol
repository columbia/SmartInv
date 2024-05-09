1 pragma solidity ^0.5.7;
2 
3 interface MarmoStork {
4     function reveal(address _signer) external payable;
5     function marmoOf(address _signer) external view;
6     function hash() external view returns (bytes32);
7 }
8 
9 interface Marmo {
10     function relayedBy(bytes32 _id) external view returns (address _relayer);
11     function relay(
12         address _implementation,
13         bytes calldata _data,
14         bytes calldata _signature
15     ) external;
16 }
17 
18 contract MarmoRelayerHelper {
19     bytes1 private constant CREATE2_PREFIX = byte(0xff);
20     bytes32 private hash;
21 
22     MarmoStork public stork;
23 
24     constructor(MarmoStork _stork) public {
25         hash = _stork.hash();
26         stork = _stork;
27     }
28 
29     // Calculates the Marmo wallet for a given signer
30     // the wallet contract will be deployed in a deterministic manner
31     function _marmoOf(address _signer) internal view returns (address) {
32         // CREATE2 address
33         return address(
34             uint256(
35                 keccak256(
36                     abi.encodePacked(
37                         CREATE2_PREFIX,
38                         stork,
39                         bytes32(uint256(_signer)),
40                         hash
41                     )
42                 )
43             )
44         );
45     }
46     
47     function _isNotContract(address _address) internal view returns (bool v) {
48         assembly {
49             v := iszero(extcodesize(_address))
50         }
51     }
52     
53     function wasRelayed(
54         address _signer,
55         bytes32 _id
56     ) external view returns (bool) {
57         Marmo marmo = Marmo(_marmoOf(_signer));
58 
59         if (_isNotContract(address(marmo))) {
60             return false;
61         }
62         
63         return marmo.relayedBy(_id) != address(0);
64     }
65     
66     function depsReady(
67         bytes calldata _data
68     ) external view returns (bool) {
69         // Retrieve inputs from data
70         (bytes memory dependency) = abi.decode(_data, (bytes));
71         return _checkDependency(dependency);
72     }
73     
74     function revealAndRelay(
75         address _signer,
76         address _implementation,
77         bytes calldata _data,
78         bytes calldata _signature
79     ) external {
80         Marmo marmo = Marmo(_marmoOf(_signer));
81 
82         if (_isNotContract(address(marmo))) {
83             stork.reveal(_signer);
84         }
85         
86         marmo.relay(
87             _implementation,
88             _data,
89             _signature
90         );
91     }
92     
93     // internal
94     
95     // The dependency is a 'staticcall' to a 'target'
96     //  when the call succeeds and it does not return false, the dependency is satisfied.
97     // [160 bits (target) + n bits (data)]
98     function _checkDependency(bytes memory _dependency) internal view returns (bool result) {
99         if (_dependency.length == 0) {
100             result = true;
101         } else {
102             assembly {
103                 let response := mload(0x40)
104                 let success := staticcall(
105                     gas,
106                     mload(add(_dependency, 20)),
107                     add(52, _dependency),
108                     sub(mload(_dependency), 20),
109                     response,
110                     32
111                 )
112 
113                 result := and(gt(success, 0), gt(mload(response), 0))
114             }
115         }
116     }
117 }