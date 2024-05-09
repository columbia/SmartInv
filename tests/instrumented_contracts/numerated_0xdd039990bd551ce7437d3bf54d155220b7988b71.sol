1 pragma solidity ^0.7.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "add overflow");
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "sub underflow");
14         uint256 c = a - b;
15         return c;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) return 0;
20         uint256 c = a * b;
21         require(c / a == b, "mul overflow");
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0, "div by zero");
27         uint256 c = a / b;
28         return c;
29     }
30 
31     function min(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a < b ? a : b;
33     }
34 }
35 
36 contract DegensToken {
37     using SafeMath for uint256;
38 
39     string public constant name = "Degens Token";
40     string public constant symbol = "DEGENS";
41     uint8 public constant decimals = 18;
42     uint256 immutable public totalSupply;
43 
44     mapping(address => uint256) public balanceOf;
45     mapping(address => mapping(address => uint256)) public allowance;
46     mapping(address => uint256) public nonces;
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
52     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
53 
54     constructor(uint256 amountToDistribute) {
55         totalSupply = amountToDistribute;
56         balanceOf[msg.sender] = amountToDistribute;
57         emit Transfer(address(0), msg.sender, amountToDistribute);
58     }
59 
60     function transfer(address recipient, uint256 amount) external returns (bool) {
61         return transferFrom(msg.sender, recipient, amount);
62     }
63 
64     function transferFrom(address from, address recipient, uint256 amount) public returns (bool) {
65         require(balanceOf[from] >= amount, "insufficient balance");
66         if (from != msg.sender && allowance[from][msg.sender] != uint256(-1)) {
67             require(allowance[from][msg.sender] >= amount, "insufficient allowance");
68             allowance[from][msg.sender] = allowance[from][msg.sender].sub(amount);
69         }
70         balanceOf[from] = balanceOf[from].sub(amount);
71         balanceOf[recipient] = balanceOf[recipient].add(amount);
72         emit Transfer(from, recipient, amount);
73         return true;
74     }
75 
76     function approve(address spender, uint256 amount) external returns (bool) {
77         allowance[msg.sender][spender] = amount;
78         emit Approval(msg.sender, spender, amount);
79         return true;
80     }
81 
82     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
83         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
84         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));
85         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
86 
87         address signatory = ecrecover(digest, v, r, s);
88         require(signatory != address(0), "permit: invalid signature");
89         require(signatory == owner, "permit: unauthorized");
90         require(block.timestamp <= deadline, "permit: signature expired");
91 
92         allowance[owner][spender] = value;
93         emit Approval(owner, spender, value);
94     }
95 
96     function getChainId() private pure returns (uint chainId) {
97         assembly { chainId := chainid() }
98     }
99 }
100 
101 contract DegensTokenDistributor {
102     using SafeMath for uint256;
103 
104     bytes32 immutable public merkleRoot;
105     uint256 public unclaimed;
106     mapping(uint256 => uint256) public claimed; // index -> tokens claimed
107 
108     DegensToken immutable public token;
109     uint64 immutable public timeDeployed;
110 
111     constructor(bytes32 merkleRoot_, uint256 unclaimed_) {
112         merkleRoot = merkleRoot_;
113         unclaimed = unclaimed_;
114 
115         token = new DegensToken(unclaimed_);
116         timeDeployed = uint64(block.timestamp);
117     }
118 
119     function amountClaimable(uint256 index, uint256 allocation, uint256 vestingYears) public view returns (uint256) {
120         uint256 yearsElapsed = block.timestamp.sub(timeDeployed).mul(1e18).div(86400 * 365);
121 
122         uint256 fractionVested = vestingYears == 0 ? 1e18 : yearsElapsed.div(vestingYears).min(1e18);
123 
124         uint256 amountVested = allocation.mul(fractionVested).div(1e18).min(allocation);
125 
126         return amountVested.sub(claimed[index]);
127     }
128 
129     function claim(uint256 index, address claimer, uint256 allocation, uint256 vestingYears, bytes32[] memory witnesses, uint256 path) public {
130         // Validate proof
131 
132         bytes32 node = keccak256(abi.encodePacked(index, claimer, allocation, vestingYears));
133 
134         for (uint256 i = 0; i < witnesses.length; i++) {
135             if ((path & 1) == 0) {
136                 node = keccak256(abi.encodePacked(node, witnesses[i]));
137             } else {
138                 node = keccak256(abi.encodePacked(witnesses[i], node));
139             }
140 
141             path >>= 1;
142         }
143 
144         require(node == merkleRoot, "incorrect proof");
145 
146         // Compute amount claimable
147 
148         uint256 toClaim = amountClaimable(index, allocation, vestingYears);
149         require(toClaim > 0, "nothing claimable");
150 
151         // Update distributor records
152 
153         claimed[index] = claimed[index].add(toClaim);
154         unclaimed = unclaimed.sub(toClaim);
155 
156         // Transfer tokens
157 
158         token.transfer(claimer, toClaim);
159     }
160 }