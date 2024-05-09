1 pragma solidity 0.5.8;
2 
3 /**
4  * @title Graceful
5  *
6  * This contract provides informative `require` with optional ability to `revert`.
7  *
8  * _softRequire is used when it's enough to return `false` in case if condition isn't fulfilled.
9  * _hardRequire is used when it's necessary to make revert in case if condition isn't fulfilled.
10  */
11 contract Graceful {
12     event Error(bytes32 message);
13 
14     // Only for functions that return bool success before any changes made.
15     function _softRequire(bool _condition, bytes32 _message) internal {
16         if (_condition) {
17             return;
18         }
19         emit Error(_message);
20         // Return bytes32(0).
21         assembly {
22             mstore(0, 0)
23             return(0, 32)
24         }
25     }
26 
27     // Generic substitution for require().
28     function _hardRequire(bool _condition, bytes32 _message) internal pure {
29         if (_condition) {
30             return;
31         }
32         // Revert with bytes32(_message).
33         assembly {
34             mstore(0, _message)
35             revert(0, 32)
36         }
37     }
38 
39     function _not(bool _condition) internal pure returns(bool) {
40         return !_condition;
41     }
42 }
43 
44 
45 /**
46  * @title Owned
47  *
48  * This contract keeps and transfers contract ownership.
49  *
50  * After deployment msg.sender becomes an owner which is checked in modifier onlyContractOwner().
51  *
52  * Features:
53  * Modifier onlyContractOwner() restricting access to function for all callers except the owner.
54  * Functions of transferring ownership to another address.
55  *
56  * Note:
57  * Function forceChangeContractOwnership allows to
58  * transfer the ownership to an address without confirmation.
59  * Which is very convenient in case the ownership transfers to a contract.
60  * But when using this function, it's important to be very careful when entering the address.
61  * Check address three times to make sure that this is the address that you need
62  * because you can't cancel this operation.
63  */
64 contract Owned is Graceful {
65     bool public isConstructedOwned;
66     address public contractOwner;
67     address public pendingContractOwner;
68 
69     event ContractOwnerChanged(address newContractOwner);
70     event PendingContractOwnerChanged(address newPendingContractOwner);
71 
72     constructor() public {
73         constructOwned();
74     }
75 
76     function constructOwned() public returns(bool) {
77         if (isConstructedOwned) {
78             return false;
79         }
80         isConstructedOwned = true;
81         contractOwner = msg.sender;
82         emit ContractOwnerChanged(msg.sender);
83         return true;
84     }
85 
86     modifier onlyContractOwner() {
87         _softRequire(contractOwner == msg.sender, 'Not a contract owner');
88         _;
89     }
90 
91     function changeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
92         pendingContractOwner = _to;
93         emit PendingContractOwnerChanged(_to);
94         return true;
95     }
96 
97     function claimContractOwnership() public returns(bool) {
98         _softRequire(pendingContractOwner == msg.sender, 'Not a pending contract owner');
99         contractOwner = pendingContractOwner;
100         delete pendingContractOwner;
101         emit ContractOwnerChanged(contractOwner);
102         return true;
103     }
104 
105     function forceChangeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
106         contractOwner = _to;
107         emit ContractOwnerChanged(contractOwner);
108         return true;
109     }
110 }
111 
112 
113 contract AddressList is Owned {
114     string public name;
115 
116     mapping (address => bool) public onList;
117 
118     constructor(string memory _name, bool nullValue) public {
119         name = _name;
120         onList[address(0x0)] = nullValue;
121     }
122 
123     event ChangeWhiteList(address indexed to, bool onList);
124 
125     // Set whether _to is on the list or not. Whether 0x0 is on the list
126     // or not cannot be set here - it is set once and for all by the constructor.
127     function changeList(address _to, bool _onList) public onlyContractOwner returns (bool success) {
128         _softRequire(_to != address(0x0), 'Cannot set zero address');
129         if (onList[_to] != _onList) {
130             onList[_to] = _onList;
131             emit ChangeWhiteList(_to, _onList);
132         }
133         return true;
134     }
135 }