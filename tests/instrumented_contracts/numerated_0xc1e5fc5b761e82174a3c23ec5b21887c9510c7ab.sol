1 pragma solidity ^0.4.18;
2 
3 contract ThisMustBeFirst {
4 
5   address public bts_address1;
6   address public bts_address2;
7   address public token_address;
8 
9 }
10 
11 contract AuthorizedList {
12 
13     bytes32 constant I_AM_ROOT = keccak256("I am root!");
14     bytes32 constant STAFF_MEMBER = keccak256("Staff Member.");
15     bytes32 constant ROUTER = keccak256("Router Contract.");
16     mapping (address => mapping(bytes32 => bool)) authorized;
17     mapping (bytes32 => bool) internal contractPermissions;
18 
19 }
20 
21 contract CodeTricks {
22 
23     function getCodeHash(address _addr) internal view returns (bytes32) {
24 
25         return keccak256(getCode(_addr));
26 
27     }
28 
29     function getCode(address _addr) internal view returns (bytes) {
30 
31         bytes memory code;
32         assembly {
33             // code size
34             let size := extcodesize(_addr)
35             // set code pointer value to free memory
36             code := mload(0x40)
37             // new "memory end" including padding
38             mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
39             // store length in memory
40             mstore(code, size)
41             // actually retrieve the code, this needs assembly
42             extcodecopy(_addr, add(code, 0x20), 0, size)
43         }
44         return code;
45 
46     }
47 
48 }
49 
50 contract Authorized is AuthorizedList {
51 
52     function Authorized() public {
53 
54        authorized[msg.sender][I_AM_ROOT] = true;
55 
56     }
57 
58     modifier ifAuthorized(address _address, bytes32 _authorization) {
59 
60        require(authorized[_address][_authorization] || authorized[_address][I_AM_ROOT]);
61        _;
62 
63     }
64 
65     function isAuthorized(address _address, bytes32 _authorization) public view returns (bool) {
66 
67        return authorized[_address][_authorization];
68 
69     }
70 
71     function toggleAuthorization(address _address, bytes32 _authorization) public ifAuthorized(msg.sender, I_AM_ROOT) {
72 
73        // Prevent inadvertent self locking out, cannot change own authority
74        require(_address != msg.sender);
75 
76        // No need for lower level authorization to linger
77        if (_authorization == I_AM_ROOT && !authorized[_address][I_AM_ROOT])
78            authorized[_address][STAFF_MEMBER] = false;
79 
80        authorized[_address][_authorization] = !authorized[_address][_authorization];
81 
82     }
83 
84 }
85 
86 contract Router is ThisMustBeFirst, AuthorizedList, CodeTricks, Authorized {
87 
88   function Router(address _token_address, address _storage_address) public Authorized() {
89 
90      require(_token_address != address(0));
91      require(_storage_address != address(0));
92      token_address = _token_address;
93      bts_address1 = _storage_address;
94 
95      // It is believed at this time that tampering with deployed contract's bytecode is not
96      // possible. Therefore the two lines below are  not necessary
97      // contractPermissions[getCodeHash(bts_address1)] = true;
98      // contractPermissions[getCodeHash(token_address)] = true;
99 
100   }
101 
102   function nameSuccessor(address _token_address) public ifAuthorized(msg.sender, I_AM_ROOT) {
103 
104      require(_token_address != address(0));
105      token_address = _token_address;
106 
107      // It is believed at this time that tampering with deployed contract's bytecode is not
108      // possible. Therefore the line below is not necessary
109      // contractPermissions[getCodeHash(token_address)] = true;
110 
111   }
112 
113   function setStorage(address _storage_address) public ifAuthorized(msg.sender, I_AM_ROOT) {
114 
115      require(_storage_address != address(0));
116      bts_address1 = _storage_address;
117 
118      // It is believed at this time that tampering with deployed contract's bytecode is not
119      // possible. Therefore the line below is not necessary
120      // contractPermissions[getCodeHash(bts_address1)] = true;
121 
122   }
123 
124   function setSecondaryStorage(address _storage_address) public ifAuthorized(msg.sender, I_AM_ROOT) {
125 
126      require(_storage_address != address(0));
127      bts_address2 = _storage_address;
128 
129      // It is believed at this time that tampering with deployed contract's bytecode is not
130      // possible. Therefore the line below is not necessary
131      // contractPermissions[getCodeHash(bts_address2)] = true;
132 
133   }
134 
135   function swapStorage() public ifAuthorized(msg.sender, I_AM_ROOT) {
136 
137      address temp = bts_address1;
138      bts_address1 = bts_address2;
139      bts_address2 = temp;
140 
141   }
142 
143 
144 
145   function() public payable {
146 
147       // It is believed at this time that tampering with deployed contract's bytecode is not
148       // possible. Therefore the two lines below are  not necessary
149       // require (contractPermissions[getCodeHash(token_address)]);
150       // require (contractPermissions[getCodeHash(bts_address1)]);
151 
152       var target = token_address;
153       assembly {
154           let _calldata := mload(0x40)
155           mstore(0x40, add(_calldata, calldatasize))
156           calldatacopy(_calldata, 0x0, calldatasize)
157           switch delegatecall(gas, target, _calldata, calldatasize, 0, 0)
158             case 0 { revert(0, 0) }
159             default {
160               let _returndata := mload(0x40)
161               returndatacopy(_returndata, 0, returndatasize)
162               mstore(0x40, add(_returndata, returndatasize))
163               return(_returndata, returndatasize)
164             }
165        }
166    }
167 
168 }