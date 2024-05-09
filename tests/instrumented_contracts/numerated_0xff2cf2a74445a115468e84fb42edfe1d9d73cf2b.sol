1 pragma solidity ^0.4.24;
2 
3 // 'Vizcoin' token contract
4 //
5 // Deployed to : 0xaa58DFA232c181C0A43B3EAC44503e4B6cD479AA
6 // Symbol      : Viz
7 // Name        : Viz coin
8 // Total supply: 33000000
9 // Decimals    : 8
10 
11 contract SafeMath {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 contract Vizcoin is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81     function Vizcoin() public {
82         symbol = "Viz";
83         name = "Vizcoin";
84         decimals = 8;
85         _totalSupply = 3300000000000000;
86         balances[0xaa58DFA232c181C0A43B3EAC44503e4B6cD479AA] = _totalSupply;
87         emit Transfer(address(0), 0xaa58DFA232c181C0A43B3EAC44503e4B6cD479AA, _totalSupply);
88     }
89 
90     function totalSupply() public constant returns (uint) {
91         return _totalSupply  - balances[address(0)];
92     }
93 
94     function balanceOf(address tokenOwner) public constant returns (uint balance) {
95         return balances[tokenOwner];
96     }
97 
98     function transfer(address to, uint tokens) public returns (bool success) {
99         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
100         balances[to] = safeAdd(balances[to], tokens);
101         emit Transfer(msg.sender, to, tokens);
102         return true;
103     }
104 
105     function approve(address spender, uint tokens) public returns (bool success) {
106         allowed[msg.sender][spender] = tokens;
107         emit Approval(msg.sender, spender, tokens);
108         return true;
109     }
110 
111     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
112         balances[from] = safeSub(balances[from], tokens);
113         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
114         balances[to] = safeAdd(balances[to], tokens);
115         emit Transfer(from, to, tokens);
116         return true;
117     }
118 
119     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
120         return allowed[tokenOwner][spender];
121     }
122 
123       function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
124         allowed[msg.sender][spender] = tokens;
125         emit Approval(msg.sender, spender, tokens);
126         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
127         return true;
128     }
129 
130        function () public payable {
131         revert();
132     }
133 
134     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
135         return ERC20Interface(tokenAddress).transfer(owner, tokens);
136     }
137 }