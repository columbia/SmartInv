1 // File: contracts/Ownable.sol
2 
3 pragma solidity 0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11 
12     address private _owner;
13     address private _pendingOwner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     
17     /**
18      * @dev The constructor sets the original owner of the contract to the sender account.
19      */
20     constructor() public {
21         setOwner(msg.sender);
22     }
23 
24     /**
25      * @dev Modifier throws if called by any account other than the pendingOwner.
26      */
27     modifier onlyPendingOwner() {
28         require(msg.sender == _pendingOwner, "msg.sender should be onlyPendingOwner");
29         _;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(msg.sender == _owner, "msg.sender should be owner");
37         _;
38     }
39 
40     /**
41      * @dev Tells the address of the pendingOwner
42      * @return The address of the pendingOwner
43      */
44     function pendingOwner() public view returns (address) {
45         return _pendingOwner;
46     }
47     
48     /**
49      * @dev Tells the address of the owner
50      * @return the address of the owner
51      */
52     function owner() public view returns (address ) {
53         return _owner;
54     }
55     
56     /**
57     * @dev Sets a new owner address
58     * @param _newOwner The newOwner to set
59     */
60     function setOwner(address _newOwner) internal {
61         _owner = _newOwner;
62     }
63 
64     /**
65      * @dev Allows the current owner to set the pendingOwner address.
66      * @param _newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address _newOwner) public onlyOwner {
69         _pendingOwner = _newOwner;
70     }
71 
72     /**
73      * @dev Allows the pendingOwner address to finalize the transfer.
74      */
75     function claimOwnership() public onlyPendingOwner {
76         emit OwnershipTransferred(_owner, _pendingOwner);
77         _owner = _pendingOwner;
78         _pendingOwner = address(0); 
79     }
80     
81 }
82 
83 // File: contracts/Operable.sol
84 
85 pragma solidity 0.5.0;
86 
87 
88 contract Operable is Ownable {
89 
90     address private _operator; 
91 
92     event OperatorChanged(address indexed previousOperator, address indexed newOperator);
93 
94     /**
95      * @dev Tells the address of the operator
96      * @return the address of the operator
97      */
98     function operator() external view returns (address) {
99         return _operator;
100     }
101     
102     /**
103      * @dev Only the operator can operate store
104      */
105     modifier onlyOperator() {
106         require(msg.sender == _operator, "msg.sender should be operator");
107         _;
108     }
109 
110     /**
111      * @dev update the storgeOperator
112      * @param _newOperator The newOperator to update  
113      */
114     function updateOperator(address _newOperator) public onlyOwner {
115         require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
116         emit OperatorChanged(_operator, _newOperator);
117         _operator = _newOperator;
118     }
119 
120 }
121 
122 // File: contracts/BlacklistStore.sol
123 
124 pragma solidity 0.5.0;
125 
126 
127 contract BlacklistStore is Operable {
128 
129     mapping (address => uint256) public blacklisted;
130 
131     /**
132      * @dev Checks if account is blacklisted
133      * @param _account The address to check
134      * @param _status The address status    
135      */
136     function setBlacklist(address _account, uint256 _status) public onlyOperator {
137         blacklisted[_account] = _status;
138     }
139 
140 }