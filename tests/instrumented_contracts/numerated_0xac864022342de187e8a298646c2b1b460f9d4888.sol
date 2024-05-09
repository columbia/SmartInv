1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-25
3  */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-10
7  */
8 
9 // SPDX-License-Identifier: none
10 pragma solidity ^0.8.4;
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount)
18         external
19         returns (bool);
20 
21     function allowance(address owner, address spender)
22         external
23         view
24         returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42 
43 interface IToken {
44     function mint(address to, uint256 amount) external;
45 
46     function burn(address owner, uint256 amount) external;
47 
48     function changeOwnership(address _newOwner) external;
49 }
50 
51 contract MigrationETH {
52     address public admin;
53     IToken public token;
54     IERC20 public token_;
55     uint256 public nonce;
56     address public feepayer;
57     mapping(uint256 => bool) public processedNonces;
58     address fromAddr = address(this);
59 
60     enum Step {
61         TransferTo,
62         TransferFrom
63     }
64     event Transfer(
65         address from,
66         address to,
67         uint256 amount,
68         uint256 date,
69         uint256 nonce,
70         Step indexed step
71     );
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     constructor(address _token) {
76         admin = msg.sender;
77         token = IToken(_token);
78         token_ = IERC20(_token);
79     }
80 
81     // transfer Ownership to other address
82     function transferOwnership(address _newOwner) public {
83         require(_newOwner != address(0x0));
84         require(msg.sender == admin);
85         emit OwnershipTransferred(admin, _newOwner);
86         admin = _newOwner;
87     }
88 
89     // transfer Ownership to other address
90     function transferTokenOwnership(address _newOwner) public {
91         require(_newOwner != address(0x0));
92         require(msg.sender == admin);
93         token.changeOwnership(_newOwner);
94     }
95 
96     function transferFromContract(
97         address to,
98         uint256 amount,
99         uint256 otherChainNonce
100     ) external {
101         require(msg.sender == admin, "only admin");
102         require(
103             processedNonces[otherChainNonce] == false,
104             "transfer already processed"
105         );
106         processedNonces[otherChainNonce] = true;
107         token_.transfer(to, amount);
108         emit Transfer(
109             msg.sender,
110             to,
111             amount,
112             block.timestamp,
113             otherChainNonce,
114             Step.TransferFrom
115         );
116     }
117 }