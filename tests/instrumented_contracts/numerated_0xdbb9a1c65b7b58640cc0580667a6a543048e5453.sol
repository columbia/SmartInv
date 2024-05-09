1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     function Owned() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 contract AriesToken is ERC20Interface, Owned, SafeMath {
69     string public symbol;
70     string public  name;
71     uint8 public decimals;
72     uint public _totalSupply;
73 
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76 
77     function AriesToken() public {
78         symbol = "ARS";
79         name = "Aries Token";
80         decimals = 18;
81         _totalSupply = 10000000000000000000000000000;
82         balances[0x18C74021Db7d89d5341Eed94665B210439DA6E32] = _totalSupply;
83         Transfer(address(0), 0x18C74021Db7d89d5341Eed94665B210439DA6E32, _totalSupply);
84     }
85 
86     function totalSupply() public constant returns (uint) {
87         return _totalSupply  - balances[address(0)];
88     }
89 
90     function balanceOf(address tokenOwner) public constant returns (uint balance) {
91         return balances[tokenOwner];
92     }
93 
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101     function approve(address spender, uint tokens) public returns (bool success) {
102         allowed[msg.sender][spender] = tokens;
103         Approval(msg.sender, spender, tokens);
104         return true;
105     }
106 
107     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108         balances[from] = safeSub(balances[from], tokens);
109         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
110         balances[to] = safeAdd(balances[to], tokens);
111         Transfer(from, to, tokens);
112         return true;
113     }
114 
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
116         return allowed[tokenOwner][spender];
117     }
118 
119     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
123         return true;
124     }
125 
126     function () public payable {
127         revert();
128     }
129 
130     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
131         return ERC20Interface(tokenAddress).transfer(owner, tokens);
132     }
133 }