1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 }
41 
42 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
43 
44 /**
45  * @title Claimable
46  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
47  * This allows the new owner to accept the transfer.
48  */
49 contract Claimable is Ownable {
50     address public pendingOwner;
51 
52     /**
53      * @dev Modifier throws if called by any account other than the pendingOwner.
54      */
55     modifier onlyPendingOwner() {
56         require(msg.sender == pendingOwner);
57         _;
58     }
59 
60     /**
61      * @dev Allows the current owner to set the pendingOwner address.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) onlyOwner public {
65         pendingOwner = newOwner;
66     }
67 
68     /**
69      * @dev Allows the pendingOwner address to finalize the transfer.
70      */
71     function claimOwnership() onlyPendingOwner public {
72         emit OwnershipTransferred(owner, pendingOwner);
73         owner = pendingOwner;
74         pendingOwner = address(0);
75     }
76 }
77 
78 // File: contracts/AddressList.sol
79 
80 contract AddressList is Claimable {
81     string public name;
82     mapping(address => bool) public onList;
83 
84     constructor(string _name, bool nullValue) public {
85         name = _name;
86         onList[0x0] = nullValue;
87     }
88 
89     event ChangeWhiteList(address indexed to, bool onList);
90 
91     // Set whether _to is on the list or not. Whether 0x0 is on the list
92     // or not cannot be set here - it is set once and for all by the constructor.
93     function changeList(address _to, bool _onList) onlyOwner public {
94         require(_to != 0x0);
95         if (onList[_to] != _onList) {
96             onList[_to] = _onList;
97             emit ChangeWhiteList(_to, _onList);
98         }
99     }
100 }
101 
102 // File: contracts/NamableAddressList.sol
103 
104 contract NamableAddressList is AddressList {
105     constructor(string _name, bool nullValue)
106     AddressList(_name, nullValue) public {}
107 
108     function changeName(string _name) onlyOwner public {
109         name = _name;
110     }
111 }