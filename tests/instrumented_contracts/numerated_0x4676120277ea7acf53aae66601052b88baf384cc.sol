1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 contract ERC20 {
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 contract ApproveAndCallFallBack {
33     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
34 }
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 contract SACT is ERC20, Owned, SafeMath {
61     string public symbol;
62     string public  name;
63     uint8 public decimals;
64     uint public _totalSupply;
65 
66     mapping(address => uint) balances;
67     mapping(address => mapping(address => uint)) allowed;
68 
69 
70     function SACT() public {
71         symbol = "SACT";
72         name = "Southeast Asian Cash Tokens";
73         decimals = 8;
74         _totalSupply = 70000000000000000;
75 
76     }
77     function totalSupply()
78         public constant returns (uint) {
79         return _totalSupply  - balances[address(0)];
80     }
81     function balanceOf(address tokenOwner)
82         public constant returns (uint balance) {
83         return balances[tokenOwner];
84     }
85     function transfer(address to, uint tokens)
86         public returns (bool success) {
87         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
88         balances[to] = safeAdd(balances[to], tokens);
89         Transfer(msg.sender, to, tokens);
90         return true;
91     }
92     function approve(address spender, uint tokens)
93         public returns (bool success) {
94         allowed[msg.sender][spender] = tokens;
95         Approval(msg.sender, spender, tokens);
96         return true;
97     }
98     function transferFrom(address from, address to, uint tokens)
99         public returns (bool success) {
100         balances[from] = safeSub(balances[from], tokens);
101         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
102         balances[to] = safeAdd(balances[to], tokens);
103         Transfer(from, to, tokens);
104         return true;
105     }
106     function allowance(address tokenOwner, address spender)
107         public constant returns (uint remaining) {
108         return allowed[tokenOwner][spender];
109     }
110     function approveAndCall(address spender, uint tokens, bytes data)
111         public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         Approval(msg.sender, spender, tokens);
114         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
115         return true;
116     }
117     function () public payable {
118         uint tokens;
119         {
120             tokens = msg.value * 1000;
121         }
122         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
123         _totalSupply = safeAdd(_totalSupply, tokens);
124         Transfer(address(0), msg.sender, tokens);
125         owner.transfer(msg.value);
126     }
127 function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
128         return ERC20(tokenAddress).transfer(owner, tokens);
129     }
130 }