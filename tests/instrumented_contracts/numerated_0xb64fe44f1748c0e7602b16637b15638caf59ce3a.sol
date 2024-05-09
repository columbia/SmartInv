1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Prismacoin' token contract
5 //
6 // Deployed to : 0x29B80F75900cC7F7BCe06D8282D64f6949c3a7f2
7 // Symbol      : PRIS
8 // Name        : Prismacoin
9 // Total supply: 1900000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 contract SafeMath {
14     function safeAdd(uint a, uint b) public pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function safeSub(uint a, uint b) public pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function safeMul(uint a, uint b) public pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function safeDiv(uint a, uint b) public pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     function Owned() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         newOwner = address(0);
71     }
72 }
73 
74 contract Prismacoin is ERC20Interface, Owned, SafeMath {
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public _totalSupply;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83 
84     function Prismacoin() public {
85         symbol = "PRIS";
86         name = "Prismacoin";
87         decimals = 18;
88         _totalSupply = 19000000000000000000000000;
89         balances[0x29B80F75900cC7F7BCe06D8282D64f6949c3a7f2] = _totalSupply;
90         Transfer(address(0), 0x29B80F75900cC7F7BCe06D8282D64f6949c3a7f2, _totalSupply);
91     }
92 
93 
94     function totalSupply() public constant returns (uint) {
95         return _totalSupply  - balances[address(0)];
96     }
97 
98 
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103 
104     function transfer(address to, uint tokens) public returns (bool success) {
105         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
106         balances[to] = safeAdd(balances[to], tokens);
107         Transfer(msg.sender, to, tokens);
108         return true;
109     }
110 
111 
112     function approve(address spender, uint tokens) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         Approval(msg.sender, spender, tokens);
115         return true;
116     }
117 
118 
119     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
120         balances[from] = safeSub(balances[from], tokens);
121         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
122         balances[to] = safeAdd(balances[to], tokens);
123         Transfer(from, to, tokens);
124         return true;
125     }
126 
127 
128     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
129         return allowed[tokenOwner][spender];
130     }
131 
132 
133     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         Approval(msg.sender, spender, tokens);
136         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
137         return true;
138     }
139 
140 
141     function () public payable {
142         revert();
143     }
144 
145 
146     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
147         return ERC20Interface(tokenAddress).transfer(owner, tokens);
148     }
149 }