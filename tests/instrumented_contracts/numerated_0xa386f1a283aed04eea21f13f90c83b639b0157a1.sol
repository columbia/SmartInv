1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5 interface IBEP20 {
6 
7     function name() external view returns (string memory);
8     function symbol() external view returns (string memory);
9     function decimals() external view returns (uint8);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender)
16     external
17     view
18     returns (uint256);
19 
20     function transfer(address to, uint256 value) external returns (bool);
21 
22     function approve(address spender, uint256 value) external returns (bool);
23 
24     function transferFrom(
25         address from,
26         address to,
27         uint256 value
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable {
40     address private _owner;
41 
42     event OwnershipRenounced(address indexed previousOwner);
43     event TransferOwnerShip(address indexed previousOwner);
44 
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     constructor() {
51         _owner = msg.sender;
52     }
53 
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     modifier onlyOwner() {
59         require(msg.sender == _owner, 'Not owner');
60         _;
61     }
62 
63     function renounceOwnership() public onlyOwner {
64         emit OwnershipRenounced(_owner);
65         _owner = address(0);
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         emit TransferOwnerShip(newOwner);
70         _transferOwnership(newOwner);
71     }
72 
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0),
75             'Owner can not be 0');
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 contract Claim is Ownable {
82 
83     address public tokenAddress;
84 
85     mapping (address => uint256) public claimableAmount;
86     mapping (address => uint256) public claimedAmount;
87 
88     event Claimed(address indexed user, uint256 amount);
89 
90     constructor() {
91         tokenAddress = 0x95ac4ffA46C25dBCe18C53F5EdAf088b53c160D1;
92     }
93 
94     // only owner functions here
95 
96     function setTokenAddress(address _tokenAddress) public onlyOwner {
97         tokenAddress = _tokenAddress;
98     }
99 
100     function setClaimableAmount(address[] memory _users, uint256[] memory _amounts) public onlyOwner {
101         require(_users.length == _amounts.length, 'Invalid input');
102         for (uint256 i = 0; i < _users.length; i++) {
103             claimableAmount[_users[i]] = _amounts[i];
104         }
105     }
106 
107 
108     // public functions here
109 
110     function claim () public {
111         require(claimableAmount[msg.sender] > 0, 'No claimable amount');
112         uint256 amount = claimableAmount[msg.sender];
113         claimedAmount[msg.sender] += amount;
114         claimableAmount[msg.sender] = 0;
115         IBEP20(tokenAddress).transfer(msg.sender, amount);
116         emit Claimed(msg.sender, amount);
117     }
118 
119     // this function is to withdraw BNB sent to this address by mistake
120     function withdrawEth(uint256 amount) external onlyOwner returns (bool) {
121         (bool success, ) = payable(msg.sender).call{value: amount}("");
122         return success;
123     }
124 
125     // this function is to withdraw BEP20 tokens sent to this address by mistake
126     function withdrawBEP20(
127         address _tokenAddress,
128         uint256 amount
129     ) external onlyOwner returns (bool) {
130         IBEP20 token = IBEP20(_tokenAddress);
131         bool success = token.transfer(msg.sender, amount);
132         return success;
133     }
134 
135     receive() external payable {}
136 
137 }