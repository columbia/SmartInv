1 pragma solidity ^0.4.19;
2 
3 contract SmzTradingContract
4 {
5     address public constant RECEIVER_ADDRESS = 0xf3eB3CA356c111ECb418D457e55A3A3D185faf61;
6     uint256 public constant ACCEPTED_AMOUNT = 3 ether;
7     uint256 public RECEIVER_PAYOUT_THRESHOLD = 10 ether;
8     
9     address public constant END_ADDRESS = 0x3559e34004b944906Bc727a40d7568a98bDc42d3;
10     uint256 public constant END_AMOUNT = 0.39 ether;
11     
12     bool public ended = false;
13     
14     mapping(address => bool) public addressesAllowed;
15     mapping(address => bool) public addressesDeposited;
16     
17     // The manager can allow and disallow addresses to deposit
18     address public manager;
19     
20     function SmzTradingContract() public
21     {
22         manager = msg.sender;
23     }
24     function setManager(address _newManager) external
25     {
26         require(msg.sender == manager);
27         manager = _newManager;
28     }
29     
30     function () payable external
31     {
32         // If the ending address sends the ending amount, block all deposits
33         if (msg.sender == END_ADDRESS && msg.value == END_AMOUNT)
34         {
35             ended = true;
36             RECEIVER_ADDRESS.transfer(this.balance);
37             return;
38         }
39         
40         // Only allow deposits if the process has not been ended yet
41         require(!ended);
42         
43         // Only allow deposits of one exact amount
44         require(msg.value == ACCEPTED_AMOUNT);
45         
46         // Only explicitly allowed addresses can deposit
47         require(addressesAllowed[msg.sender] == true);
48         
49         // Each address can only despoit once
50         require(addressesDeposited[msg.sender] == false);
51         addressesDeposited[msg.sender] = true;
52         
53         // When an address has deposited, we set their allowed state to 0.
54         // This refunds approximately 15000 gas.
55         addressesAllowed[msg.sender] = false;
56         
57         // If we have crossed the payout threshold,
58         // transfer all the deposited amounts to the receiver address
59         if (this.balance >= RECEIVER_PAYOUT_THRESHOLD)
60         {
61             RECEIVER_ADDRESS.transfer(this.balance);
62         }
63     }
64     
65     // The receiver may add and remove each address' permission to deposit
66     function addAllowedAddress(address _allowedAddress) public
67     {
68         require(msg.sender == manager);
69         addressesAllowed[_allowedAddress] = true;
70     }
71     function removeAllowedAddress(address _disallowedAddress) public
72     {
73         require(msg.sender == manager);
74         addressesAllowed[_disallowedAddress] = false;
75     }
76     
77     function addMultipleAllowedAddresses(address[] _allowedAddresses) external
78     {
79         require(msg.sender == manager);
80         for (uint256 i=0; i<_allowedAddresses.length; i++)
81         {
82             addressesAllowed[_allowedAddresses[i]] = true;
83         }
84     }
85     function removeMultipleAllowedAddresses(address[] _disallowedAddresses) external
86     {
87         require(msg.sender == manager);
88         for (uint256 i=0; i<_disallowedAddresses.length; i++)
89         {
90             addressesAllowed[_disallowedAddresses[i]] = false;
91         }
92     }
93 }