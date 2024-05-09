1 pragma solidity ^0.4.25;
2 
3 // Burning Token (BURN)
4 
5 contract SafeMath {
6     function safeAdd(uint a, uint b) public pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) public pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) public pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 contract Owned {
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 contract BurningToken is ERC20Interface, Owned, SafeMath {
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint public _totalSupply;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     constructor() public {
76         symbol = "BURN";
77         name = "Burning Token";
78         decimals = 18;
79         _totalSupply = 100000000000000000000000000;
80         balances[0x0282a6739b16E6d27C522db7680fD0BF6e965408] = _totalSupply;
81         emit Transfer(address(0), 0x0282a6739b16E6d27C522db7680fD0BF6e965408, _totalSupply);
82     }
83 
84     function totalSupply() public constant returns (uint) {
85         return _totalSupply  - balances[address(0)];
86     }
87 
88     function balanceOf(address tokenOwner) public constant returns (uint balance) {
89         return balances[tokenOwner];
90     }
91 
92     function transfer(address to, uint tokens) public returns (bool success) {
93         uint burnedTokens = safeDiv(tokens, 100);
94         uint newTokens = safeSub(tokens, burnedTokens);
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], newTokens);
97         _totalSupply = safeSub(_totalSupply, burnedTokens);
98         emit Transfer(msg.sender, to, tokens);
99         return true;
100     }
101 
102     function approve(address spender, uint tokens) public returns (bool success) {
103         allowed[msg.sender][spender] = tokens;
104         emit Approval(msg.sender, spender, tokens);
105         return true;
106     }
107 
108     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
109         uint burnedTokens = safeDiv(tokens, 100);
110         uint newTokens = safeSub(tokens, burnedTokens);
111         balances[from] = safeSub(balances[from], tokens);
112         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
113         balances[to] = safeAdd(balances[to], newTokens);
114         _totalSupply = safeSub(_totalSupply, burnedTokens);
115         emit Transfer(from, to, tokens);
116         return true;
117     }
118 
119     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
120         return allowed[tokenOwner][spender];
121     }
122 
123     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
124         allowed[msg.sender][spender] = tokens;
125         emit Approval(msg.sender, spender, tokens);
126         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
127         return true;
128     }
129 
130     function burn(uint256 _value) public returns (bool success) {
131       require(balances[msg.sender] >= _value);
132       balances[msg.sender] = safeSub(balances[msg.sender], _value);
133       _totalSupply = safeSub(_totalSupply, _value);
134       return true;
135     }
136 
137     function () public payable {
138         revert();
139     }
140 
141     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
142         return ERC20Interface(tokenAddress).transfer(owner, tokens);
143     }
144 }