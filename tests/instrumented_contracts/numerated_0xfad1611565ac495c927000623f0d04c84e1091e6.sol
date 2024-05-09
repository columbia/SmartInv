1 pragma solidity ^0.4.24;
2 
3 contract SecuredTokenTransfer {
4 
5     /// @dev Transfers a token and returns if it was a success
6     /// @param token Token that should be transferred
7     /// @param receiver Receiver to whom the token should be transferred
8     /// @param amount The amount of tokens that should be transferred
9     function transferToken (
10         address token, 
11         address receiver,
12         uint256 amount
13     )
14         internal
15         returns (bool transferred)
16     {
17         bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", receiver, amount);
18         // solium-disable-next-line security/no-inline-assembly
19         assembly {
20             let success := call(sub(gas, 10000), token, 0, add(data, 0x20), mload(data), 0, 0)
21             let ptr := mload(0x40)
22             returndatacopy(ptr, 0, returndatasize)
23             switch returndatasize 
24             case 0 { transferred := success }
25             case 0x20 { transferred := iszero(or(iszero(success), iszero(mload(ptr)))) }
26             default { transferred := 0 }
27         }
28     }
29 }
30 
31 contract Proxy {
32 
33     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
34     address masterCopy;
35 
36     /// @dev Constructor function sets address of master copy contract.
37     /// @param _masterCopy Master copy address.
38     constructor(address _masterCopy)
39         public
40     {
41         require(_masterCopy != 0, "Invalid master copy address provided");
42         masterCopy = _masterCopy;
43     }
44 
45     /// @dev Fallback function forwards all transactions and returns all received return data.
46     function ()
47         external
48         payable
49     {
50         // solium-disable-next-line security/no-inline-assembly
51         assembly {
52             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
53             calldatacopy(0, 0, calldatasize())
54             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
55             returndatacopy(0, 0, returndatasize())
56             if eq(success, 0) { revert(0, returndatasize()) }
57             return(0, returndatasize())
58         }
59     }
60 
61     function implementation()
62         public
63         view
64         returns (address)
65     {
66         return masterCopy;
67     }
68 
69     function proxyType()
70         public
71         pure
72         returns (uint256)
73     {
74         return 2;
75     }
76 }
77 
78 contract DelegateConstructorProxy is Proxy {
79 
80     /// @dev Constructor function sets address of master copy contract.
81     /// @param _masterCopy Master copy address.
82     /// @param initializer Data used for a delegate call to initialize the contract.
83     constructor(address _masterCopy, bytes initializer) Proxy(_masterCopy)
84         public
85     {
86         if (initializer.length > 0) {
87             // solium-disable-next-line security/no-inline-assembly
88             assembly {
89                 let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
90                 let success := delegatecall(sub(gas, 10000), masterCopy, add(initializer, 0x20), mload(initializer), 0, 0)
91                 let ptr := mload(0x40)
92                 returndatacopy(ptr, 0, returndatasize)
93                 if eq(success, 0) { revert(ptr, returndatasize) }
94             }
95         }
96     }
97 }
98 
99 contract PayingProxy is DelegateConstructorProxy, SecuredTokenTransfer {
100 
101     /// @dev Constructor function sets address of master copy contract.
102     /// @param _masterCopy Master copy address.
103     /// @param initializer Data used for a delegate call to initialize the contract.
104     /// @param funder Address that should be paid for the execution of this call
105     /// @param paymentToken Token that should be used for the payment (0 is ETH)
106     /// @param payment Value that should be paid
107     constructor(address _masterCopy, bytes initializer, address funder, address paymentToken, uint256 payment) 
108         DelegateConstructorProxy(_masterCopy, initializer)
109         public
110     {
111         if (payment > 0) {
112             if (paymentToken == address(0)) {
113                  // solium-disable-next-line security/no-send
114                 require(funder.send(payment), "Could not pay safe creation with ether");
115             } else {
116                 require(transferToken(paymentToken, funder, payment), "Could not pay safe creation with token");
117             }
118         } 
119     }
120 }