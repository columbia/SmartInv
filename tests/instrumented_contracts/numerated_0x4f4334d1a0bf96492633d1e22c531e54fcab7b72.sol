1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: UNLICENSED
5 contract KolectivDeposit {
6 
7     event Deposit(address indexed account, uint32 indexed orderId, uint256 amount);
8     event Paused(address account);
9     event Unpaused(address account);
10 
11     bool private _paused;
12     address private _owner;
13     mapping (uint32 => uint256) private orderToBalance;
14 
15     /**
16      * @dev Returns true if the contract is paused, and false otherwise.
17      */
18     function paused() public view returns (bool) {
19         return _paused;
20     }
21 
22     modifier whenNotPaused() {
23         require(!paused(), "Contract is paused.");
24         _;
25     }
26 
27     modifier whenPaused() {
28         require(paused(), "Contract is not paused.");
29         _;
30     }
31 
32     modifier onlyOwner() {
33         require(_owner == msg.sender, "Can only be called by owner.");
34         _;
35     }
36 
37     constructor() {
38         _owner = msg.sender;
39         _paused = false;
40     }
41 
42     function deposit(uint32 orderId) public payable whenNotPaused {
43         require(msg.value > 0, "No value provided to deposit.");
44         orderToBalance[orderId] = orderToBalance[orderId] + msg.value;
45         emit Deposit(msg.sender, orderId, msg.value);
46     }
47 
48     function getOrderBalance(uint32 orderId) public view returns (uint256) {
49         return orderToBalance[orderId];
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     // ------------------------------------------------------------------------------------------------------
57     // Only owner functionality below here
58     function pause() public whenNotPaused onlyOwner {
59         _paused = true;
60         emit Paused(msg.sender);
61     }
62 
63     function unpause() public whenPaused onlyOwner {
64         _paused = false;
65         emit Unpaused(msg.sender);
66     }
67 
68     function withdraw(address payable account, uint256 amount) public onlyOwner {
69         require(amount > 0, "No value provided to withdraw.");
70         sendValue(account, amount);
71     }
72 
73     function withdrawAll(address payable account) public onlyOwner {
74         sendValue(account, address(this).balance);
75     }
76 
77     function sendValue(address payable recipient, uint256 amount) private {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
81         (bool success, ) = recipient.call{ value: amount }("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 }