1 pragma solidity 0.8.18;
2 
3 //SPDX-License-Identifier: MIT Licensed
4 
5 interface IERC20 {
6     function name() external view returns (string memory);
7 
8     function symbol() external view returns (string memory);
9 
10     function decimals() external view returns (uint8);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address owner) external view returns (uint256);
15 
16     function allowance(
17         address owner,
18         address spender
19     ) external view returns (uint256);
20 
21     function approve(address spender, uint256 value) external;
22 
23     function transfer(address to, uint256 value) external;
24 
25     function transferFrom(address from, address to, uint256 value) external;
26 
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract ClaimContract {
36     IERC20 public TOKEN;
37 
38     address public owner;
39     uint256 public totalTokenClaimed;
40     bool public enableClaim;
41     mapping(address => uint256) public wallets;
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner, " Not an owner");
45         _;
46     }
47 
48     constructor(address _owner, address _TOKEN) {
49         owner = _owner;
50         TOKEN = IERC20(_TOKEN);
51     }
52 
53     function addData(
54         address[] memory wallet,
55         uint256[] memory amount
56     ) public onlyOwner {
57         for (uint256 i = 0; i < wallet.length; i++) {
58             wallets[wallet[i]] += amount[i];
59         }
60     }
61 
62     function Claim() public {
63         require(enableClaim == true, "wait for owner to start claim");
64         require(wallets[msg.sender] > 0, "already claimed");
65         TOKEN.transfer(msg.sender, wallets[msg.sender] * 1e18);
66         wallets[msg.sender] = 0;
67     }
68 
69     // transfer ownership
70     function EnableClaim(bool _state) external onlyOwner {
71         enableClaim = _state;
72     }
73 
74     // transfer ownership
75     function changeOwner(address payable _newOwner) external onlyOwner {
76         owner = _newOwner;
77     }
78 
79     // change tokens
80     function changeToken(address _token) external onlyOwner {
81         TOKEN = IERC20(_token);
82     }
83 
84     // to draw out tokens
85     function transferStuckTokens(
86         IERC20 token,
87         uint256 _value
88     ) external onlyOwner {
89         token.transfer(msg.sender, _value);
90     }
91  
92 }