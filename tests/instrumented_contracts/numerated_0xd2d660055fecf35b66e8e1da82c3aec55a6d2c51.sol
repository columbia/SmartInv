1 pragma solidity ^0.4.24;
2 
3 // File: contracts/utility/interfaces/IOwned.sol
4 
5 /*
6     Owned contract interface
7 */
8 contract IOwned {
9     // this function isn't abstract since the compiler emits automatically generated getter functions as external
10     function owner() public view returns (address) {}
11 
12     function transferOwnership(address _newOwner) public;
13     function acceptOwnership() public;
14 }
15 
16 // File: contracts/utility/Owned.sol
17 
18 /*
19     Provides support and utilities for contract ownership
20 */
21 contract Owned is IOwned {
22     address public owner;
23     address public newOwner;
24 
25     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
26 
27     /**
28         @dev constructor
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     // allows execution by the owner only
35     modifier ownerOnly {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     /**
41         @dev allows transferring the contract ownership
42         the new owner still needs to accept the transfer
43         can only be called by the contract owner
44 
45         @param _newOwner    new contract owner
46     */
47     function transferOwnership(address _newOwner) public ownerOnly {
48         require(_newOwner != owner);
49         newOwner = _newOwner;
50     }
51 
52     /**
53         @dev used by a new owner to accept an ownership transfer
54     */
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 // File: contracts/bancorx/XTransferRerouter.sol
64 
65 contract XTransferRerouter is Owned {
66     bool public reroutingEnabled;
67 
68     // triggered when a rerouteTx is called
69     event TxReroute(
70         uint256 indexed _txId,
71         bytes32 _toBlockchain,
72         bytes32 _to
73     );
74 
75     /**
76         @dev constructor
77 
78         @param _reroutingEnabled    intializes transactions routing to enabled/disabled   
79      */
80     constructor(bool _reroutingEnabled) public {
81         reroutingEnabled = _reroutingEnabled;
82     }
83     /**
84         @dev allows the owner to disable/enable rerouting
85 
86         @param _enable     true to enable, false to disable
87      */
88     function enableRerouting(bool _enable) public ownerOnly {
89         reroutingEnabled = _enable;
90     }
91 
92     // allows execution only when rerouting enabled
93     modifier whenReroutingEnabled {
94         require(reroutingEnabled);
95         _;
96     }
97 
98     /**
99         @dev    allows a user to reroute a transaction to a new blockchain/target address
100 
101         @param _txId        the original transaction id
102         @param _blockchain  the new blockchain name
103         @param _to          the new target address/account
104      */
105     function rerouteTx(
106         uint256 _txId,
107         bytes32 _blockchain,
108         bytes32 _to
109     )
110         public
111         whenReroutingEnabled 
112     {
113         emit TxReroute(_txId, _blockchain, _to);
114     }
115 
116 }