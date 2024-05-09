1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Creator : Bounty Hunter Gambang One
5 // ----------------------------------------------------------------------------
6 
7 contract SafeMath {
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 contract ApproveAndCallFallBack {
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42 }
43 
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     function Owned() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 
71 contract GambangCoin is ERC20Interface, Owned, SafeMath {
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80     function GambangCoin() public {
81         symbol = "GMBC";
82         name = "GambangCoin";
83         decimals = 3;
84         _totalSupply = 99999999000;
85         balances[owner] = _totalSupply;
86         Transfer(address(0), owner, _totalSupply);
87     }
88 
89 
90     function totalSupply() public constant returns (uint) {
91         return _totalSupply  - balances[address(0)];
92     }
93 
94     function balanceOf(address tokenOwner) public constant returns (uint balance) {
95         return balances[tokenOwner];
96     }
97 
98 
99 
100     function transfer(address to, uint tokens) public returns (bool success) {
101         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
102         balances[to] = safeAdd(balances[to], tokens);
103         Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107 
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114 
115     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
116         balances[from] = safeSub(balances[from], tokens);
117         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
118         balances[to] = safeAdd(balances[to], tokens);
119         Transfer(from, to, tokens);
120         return true;
121     }
122 
123     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
124         return allowed[tokenOwner][spender];
125     }
126 
127     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         Approval(msg.sender, spender, tokens);
130         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
131         return true;
132     }
133 
134     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
135         return ERC20Interface(tokenAddress).transfer(owner, tokens);
136     }
137 }