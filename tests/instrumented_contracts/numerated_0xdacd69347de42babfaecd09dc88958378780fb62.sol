1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.4.0 <0.7.0;
3 
4 // ----------------------------------------------------------------------------
5 // ERC Token Standard #20 Interface
6 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
7 // ----------------------------------------------------------------------------
8 interface ERC20Interface {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address tokenOwner) external view returns (uint balance);
11     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
12     function transfer(address to, uint tokens) external returns (bool success);
13     function approve(address spender, uint tokens) external returns (bool success);
14     function transferFrom(address from, address to, uint tokens) external returns (bool success);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 contract AtariToken is ERC20Interface {
21     
22     string public constant name = "AtariToken";
23     string public constant symbol = "ATRI";
24     uint8 public constant decimals = 0;
25     
26     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
27     event Transfer(address indexed from, address indexed to, uint tokens);
28     event RegistrationSuccessful(uint256 nonce);
29     event RegistrationFailed(uint256 nonce);
30     
31     mapping(address => uint256) balances;
32 
33     mapping(address => mapping (address => uint256)) allowed;
34     
35     uint256 totalSupply_ = 7771000000;
36     
37     mapping (string => address) addressTable;
38 
39     using SafeMath for uint256;
40     
41     constructor() public{
42 	    balances[msg.sender] = totalSupply_;
43     }
44     
45     function totalSupply() public override view returns (uint256) {
46 	    return totalSupply_;
47     }
48     
49     function balanceOf(address tokenOwner) public override view returns (uint) {
50         return balances[tokenOwner];
51     }
52     
53     function balanceOf(string memory tokenOwner) public view returns (uint) {
54         address userAddress;
55         userAddress = addressTable[tokenOwner];
56         return balances[userAddress];
57     }
58     
59     function transfer(address receiver, uint numTokens) public override returns (bool) {
60         require(numTokens <= balances[msg.sender]);
61         balances[msg.sender] = balances[msg.sender].sub(numTokens);
62         balances[receiver] = balances[receiver].add(numTokens);
63         emit Transfer(msg.sender, receiver, numTokens);
64         return true;
65     }
66     
67     function transfer(string memory receiver, uint numTokens) public returns (bool) {
68         address receiverAddress;
69         receiverAddress = addressTable[receiver];
70         require(numTokens <= balances[msg.sender]);
71         balances[msg.sender] = balances[msg.sender].sub(numTokens);
72         balances[receiverAddress] = balances[receiverAddress].add(numTokens);
73         emit Transfer(msg.sender, receiverAddress, numTokens);
74         return true;
75     }
76     
77     function approve(address delegate, uint numTokens) public override returns (bool) {
78         allowed[msg.sender][delegate] = numTokens;
79         emit Approval(msg.sender, delegate, numTokens);
80         return true;
81     }
82     
83     function approve(string memory delegate, uint numTokens) public returns (bool) {
84         address delegateAddress;
85         delegateAddress = addressTable[delegate];
86         allowed[msg.sender][delegateAddress] = numTokens;
87         emit Approval(msg.sender, delegateAddress, numTokens);
88         return true;
89     }
90     
91     function allowance(address owner, address delegate) public override view returns (uint) {
92         return allowed[owner][delegate];
93     }
94     
95     function allowance(string memory owner, string memory delegate) public view returns (uint) {
96         address ownerAddress;
97         ownerAddress = addressTable[owner];
98         address delegateAddress;
99         delegateAddress = addressTable[delegate];
100         return allowed[ownerAddress][delegateAddress];
101     }
102     
103      function transferFrom(address owner, address buyer, uint numTokens) public override returns (bool) {
104         require(numTokens <= balances[owner]);    
105         require(numTokens <= allowed[owner][msg.sender]);
106     
107         balances[owner] = balances[owner].sub(numTokens);
108         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
109         balances[buyer] = balances[buyer].add(numTokens);
110         emit Transfer(owner, buyer, numTokens);
111         return true;
112     }
113     
114     function transferFrom(string memory owner, string memory buyer, uint numTokens) public returns (bool) {
115         address ownerAddress;
116         ownerAddress = addressTable[owner];
117         address buyerAddress;
118         buyerAddress = addressTable[buyer];
119         
120         require(numTokens <= balances[ownerAddress]);    
121         require(numTokens <= allowed[ownerAddress][msg.sender]);
122     
123         balances[ownerAddress] = balances[ownerAddress].sub(numTokens);
124         allowed[ownerAddress][msg.sender] = allowed[ownerAddress][msg.sender].sub(numTokens);
125         balances[buyerAddress] = balances[buyerAddress].add(numTokens);
126         emit Transfer(ownerAddress, buyerAddress, numTokens);
127         return true;
128     }
129     
130     function registerUser(string memory user, uint256 nonce) public returns (bool) {
131         if (addressTable[user] == address(0)) {
132             addressTable[user] = msg.sender;
133             emit RegistrationSuccessful(nonce);
134             return true;
135         } else {
136             emit RegistrationFailed(nonce);
137             return false;
138         }
139     }
140 }
141 
142 library SafeMath { 
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144       assert(b <= a);
145       return a - b;
146     }
147     
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149       uint256 c = a + b;
150       assert(c >= a);
151       return c;
152     }
153 }