1 pragma solidity ^0.5.1;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC20Interface {
26     function totalSupply() public view returns (uint);
27     function balanceOf(address tokenOwner) public view returns (uint balance);
28     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
39     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
40 }
41 
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 contract TestToken is ERC20Interface, Owned {
70     using SafeMath for uint;
71 
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80     constructor() public {
81         symbol = "TESTIG";
82         name = "TEST IG Token";
83         decimals = 18;
84         _totalSupply = 1000000 * 10**uint(decimals);
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88 
89 
90     function totalSupply() public view returns (uint) {
91         return _totalSupply.sub(balances[address(0)]);
92     }
93 
94 
95     function balanceOf(address tokenOwner) public view returns (uint balance) {
96         return balances[tokenOwner];
97     }
98 
99     function transfer(address to, uint tokens) public returns (bool success) {
100         balances[msg.sender] = balances[msg.sender].sub(tokens);
101         balances[to] = balances[to].add(tokens);
102         emit Transfer(msg.sender, to, tokens);
103         return true;
104     }
105 
106     function approve(address spender, uint tokens) public returns (bool success) {
107         allowed[msg.sender][spender] = tokens;
108         emit Approval(msg.sender, spender, tokens);
109         return true;
110     }
111 
112     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
113         balances[from] = balances[from].sub(tokens);
114         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
115         balances[to] = balances[to].add(tokens);
116         emit Transfer(from, to, tokens);
117         return true;
118     }
119 
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