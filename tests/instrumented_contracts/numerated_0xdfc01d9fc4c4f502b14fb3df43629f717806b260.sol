1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title User Auth
6  */
7 contract UserAuth {
8 
9     event LogSetOwner(address indexed owner, address setter);
10     address public owner;
11 
12     /**
13      * @dev Throws if not called by owner or contract itself
14      */
15     modifier auth {
16         require(msg.sender == owner, "permission-denied");
17         _;
18     }
19     
20     /**
21      * @dev sets new owner
22      * @param _owner is the new owner of this proxy contract
23      */
24     function setOwner(address _owner) public auth {
25         owner = _owner;
26         emit LogSetOwner(owner, msg.sender);
27     }
28 
29 }
30 
31 
32 /**
33  * @dev logging the execute events
34  */
35 contract UserNote {
36     event LogNote(
37         bytes4 indexed sig,
38         address indexed guy,
39         bytes32 indexed foo,
40         bytes32 bar,
41         uint wad,
42         bytes fax
43     );
44 
45     modifier note {
46         bytes32 foo;
47         bytes32 bar;
48         assembly {
49             foo := calldataload(4)
50             bar := calldataload(36)
51         }
52         emit LogNote(
53             msg.sig, 
54             msg.sender, 
55             foo, 
56             bar, 
57             msg.value, 
58             msg.data
59         );
60         _;
61     }
62 }
63 
64 
65 /**
66  * @title User Owned Contract Wallet
67  */
68 contract UserWallet is UserAuth, UserNote {
69 
70     event LogExecute(address target);
71 
72     /**
73      * @dev sets the initial owner
74      */
75     constructor() public {
76         owner = msg.sender; // will be changed in initial call
77     }
78 
79     function() external payable {}
80 
81     /**
82      * @dev execute authorised calls via delegate call
83      * @param _target logic proxy address
84      * @param _data delegate call data
85      */
86     function execute(address _target, bytes memory _data) 
87         public
88         payable
89         note
90         auth
91         returns (bytes memory response)
92     {
93         require(_target != address(0), "invalid-logic-proxy-address");
94         emit LogExecute(_target);
95         
96         // call contract in current context
97         assembly {
98             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 0)
99             let size := returndatasize
100 
101             response := mload(0x40)
102             mstore(0x40, add(response, and(add(add(size, 0x20), 0x1f), not(0x1f))))
103             mstore(response, size)
104             returndatacopy(add(response, 0x20), 0, size)
105 
106             switch iszero(succeeded)
107                 case 1 {
108                     // throw if delegatecall failed
109                     revert(add(response, 0x20), size)
110                 }
111         }
112     }
113 
114 }