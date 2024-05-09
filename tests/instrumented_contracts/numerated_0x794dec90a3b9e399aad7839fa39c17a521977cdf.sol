1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title RegistryInterface Interface 
5  */
6 interface RegistryInterface {
7     function logic(address logicAddr) external view returns (bool);
8     function record(address currentOwner, address nextOwner) external;
9 }
10 
11 
12 /**
13  * @title Address Registry Record
14  */
15 contract AddressRecord {
16 
17     /**
18      * @dev address registry of system, logic and wallet addresses
19      */
20     address public registry;
21 
22     /**
23      * @dev Throws if the logic is not authorised
24      */
25     modifier logicAuth(address logicAddr) {
26         require(logicAddr != address(0), "logic-proxy-address-required");
27         require(RegistryInterface(registry).logic(logicAddr), "logic-not-authorised");
28         _;
29     }
30 
31 }
32 
33 
34 /**
35  * @title User Auth
36  */
37 contract UserAuth is AddressRecord {
38 
39     event LogSetOwner(address indexed owner);
40     address public owner;
41 
42     /**
43      * @dev Throws if not called by owner or contract itself
44      */
45     modifier auth {
46         require(isAuth(msg.sender), "permission-denied");
47         _;
48     }
49 
50     /**
51      * @dev sets new owner
52      */
53     function setOwner(address nextOwner) public auth {
54         RegistryInterface(registry).record(owner, nextOwner);
55         owner = nextOwner;
56         emit LogSetOwner(nextOwner);
57     }
58 
59     /**
60      * @dev checks if called by owner or contract itself
61      * @param src is the address initiating the call
62      */
63     function isAuth(address src) public view returns (bool) {
64         if (src == owner) {
65             return true;
66         } else if (src == address(this)) {
67             return true;
68         }
69         return false;
70     }
71 }
72 
73 
74 /**
75  * @dev logging the execute events
76  */
77 contract UserNote {
78     event LogNote(
79         bytes4 indexed sig,
80         address indexed guy,
81         bytes32 indexed foo,
82         bytes32 bar,
83         uint wad,
84         bytes fax
85     );
86 
87     modifier note {
88         bytes32 foo;
89         bytes32 bar;
90         assembly {
91             foo := calldataload(4)
92             bar := calldataload(36)
93         }
94         emit LogNote(
95             msg.sig, 
96             msg.sender, 
97             foo, 
98             bar, 
99             msg.value,
100             msg.data
101         );
102         _;
103     }
104 }
105 
106 
107 /**
108  * @title User Owned Contract Wallet
109  */
110 contract UserWallet is UserAuth, UserNote {
111 
112     event LogExecute(address target, uint srcNum, uint sessionNum);
113 
114     /**
115      * @dev sets the "address registry", owner's last activity, owner's active period and initial owner
116      */
117     constructor() public {
118         registry = msg.sender;
119         owner = msg.sender;
120     }
121 
122     function() external payable {}
123 
124     /**
125      * @dev Execute authorised calls via delegate call
126      * @param _target logic proxy address
127      * @param _data delegate call data
128      * @param _src to find the source
129      * @param _session to find the session
130      */
131     function execute(
132         address _target,
133         bytes memory _data,
134         uint _src,
135         uint _session
136     ) 
137         public
138         payable
139         note
140         auth
141         logicAuth(_target)
142         returns (bytes memory response)
143     {
144         emit LogExecute(
145             _target,
146             _src,
147             _session
148         );
149         
150         // call contract in current context
151         assembly {
152             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 0)
153             let size := returndatasize
154 
155             response := mload(0x40)
156             mstore(0x40, add(response, and(add(add(size, 0x20), 0x1f), not(0x1f))))
157             mstore(response, size)
158             returndatacopy(add(response, 0x20), 0, size)
159 
160             switch iszero(succeeded)
161                 case 1 {
162                     // throw if delegatecall failed
163                     revert(add(response, 0x20), size)
164                 }
165         }
166     }
167 
168 }