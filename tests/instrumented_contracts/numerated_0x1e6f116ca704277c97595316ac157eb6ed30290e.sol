1 pragma solidity ^0.4.24;
2 
3 /*
4     @title Provides support and utilities for contract ownership
5 */
6 contract Ownable {
7     address public owner;
8     address public newOwner;
9 
10     event OwnerUpdate(address _prevOwner, address _newOwner);
11 
12     /*
13         @dev constructor
14     */
15     constructor(address _owner) public {
16         owner = _owner;
17     }
18 
19     /*
20         @dev allows execution by the owner only
21     */
22     modifier ownerOnly {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /*
28         @dev allows transferring the contract ownership
29         the new owner still needs to accept the transfer
30         can only be called by the contract owner
31 
32         @param _newOwner    new contract owner
33     */
34     function transferOwnership(address _newOwner) public ownerOnly {
35         require(_newOwner != owner);
36         newOwner = _newOwner;
37     }
38 
39     /*
40         @dev used by a new owner to accept an ownership transfer
41     */
42     function acceptOwnership() public {
43         require(msg.sender == newOwner);
44         emit OwnerUpdate(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 contract BatchTransfer is Ownable {
51 
52     /*
53         @dev constructor
54 
55     */
56     constructor () public Ownable(msg.sender) {}
57 
58     function batchTransfer(address[] _destinations, uint256[] _amounts) 
59         public
60         ownerOnly()
61         {
62             require(_destinations.length == _amounts.length);
63 
64             for (uint i = 0; i < _destinations.length; i++) {
65                 if (_destinations[i] != 0x0) {
66                     _destinations[i].transfer(_amounts[i]);
67                 }
68             }
69         }
70 
71     function batchTransfer(address[] _destinations, uint256 _amount) 
72         public
73         ownerOnly()
74         {
75             require(_destinations.length > 0);
76 
77             for (uint i = 0; i < _destinations.length; i++) {
78                 if (_destinations[i] != 0x0) {
79                     _destinations[i].transfer(_amount);
80                 }
81             }
82         }
83         
84     function transfer(address _destination, uint256 _amount)
85         public
86         ownerOnly()
87         {
88             require(_destination != 0x0 && _amount > 0);
89             _destination.transfer(_amount);
90         }
91 
92     function transferAllToOwner()
93         public
94         ownerOnly()
95         {
96             address(this).transfer(address(this).balance);
97         }
98         
99     function() public payable { }
100 }