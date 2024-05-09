1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : MOV
5 // Name        : MOVEO Token
6 // Total supply: 500,000,000
7 // Decimals    : 6
8 // (c) Moveo 
9 // ----------------------------------------------------------------------------
10 
11 library SafeMath {
12     function add(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function mul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function div(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 contract ERC20Interface {
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
72 contract Moveo is ERC20Interface, Owned {
73     using SafeMath for uint;
74 
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint _totalSupply;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83     constructor() public {
84         symbol = "MOV";
85         name = "Moveo Token";
86         decimals = 6;
87         _totalSupply = 500000000 * 10**uint(decimals);
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0), owner, _totalSupply);
90     }
91 
92     function totalSupply() public view returns (uint) {
93         return _totalSupply.sub(balances[address(0)]);
94     }
95 
96     function balanceOf(address tokenOwner) public view returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100     function transfer(address to, uint tokens) public returns (bool success) {
101         balances[msg.sender] = balances[msg.sender].sub(tokens);
102         balances[to] = balances[to].add(tokens);
103         emit Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107     function approve(address spender, uint tokens) public returns (bool success) {
108         allowed[msg.sender][spender] = tokens;
109         emit Approval(msg.sender, spender, tokens);
110         return true;
111     }
112 
113     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
114         balances[from] = balances[from].sub(tokens);
115         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         emit Transfer(from, to, tokens);
118         return true;
119     }
120 
121     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
122         return allowed[tokenOwner][spender];
123     }
124 
125     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         emit Approval(msg.sender, spender, tokens);
128         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
129         return true;
130     }
131 
132     function () external payable {
133         revert();
134     }
135 
136     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
137         return ERC20Interface(tokenAddress).transfer(owner, tokens);
138     }
139 }