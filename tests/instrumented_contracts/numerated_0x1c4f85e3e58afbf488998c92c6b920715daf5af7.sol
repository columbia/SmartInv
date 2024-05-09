1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 
32 contract Owned {
33     address public owner;
34     address public newOwner;
35     
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46     
47 
48     
49     function transferOwnership(address _newOwner) public onlyOwner {
50        require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 contract ERC20Interface {
66     function totalSupply() public constant returns (uint);
67     function balanceOf(address tokenOwner) public constant returns (uint balance);
68     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
69     function transfer(address to, uint tokens) public returns (bool success);
70     function approve(address spender, uint tokens) public returns (bool success);
71     function transferFrom(address from, address to, uint tokens) public returns (bool success);
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 
77 contract CodexStandardToken is ERC20Interface, Owned {
78   using SafeMath for uint;
79 
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint _totalSupply;
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87     constructor() public {
88         name = "CODEXSTANDARD Token";
89         symbol = "CDX";
90         decimals = 0;
91         _totalSupply = 273728000;
92         balances[owner] = _totalSupply;
93         emit Transfer(address(0), owner, _totalSupply);
94     }
95 
96     function totalSupply() public view returns (uint) {
97         return _totalSupply.sub(balances[address(0)]);
98     }
99 
100     function balanceOf(address tokenOwner) public view returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104     function transfer(address to, uint tokens) public returns (bool success) {
105         balances[msg.sender] = balances[msg.sender].sub(tokens);
106         balances[to] = balances[to].add(tokens);
107         emit Transfer(msg.sender, to, tokens);
108         return true;
109     }
110 
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         emit Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = balances[from].sub(tokens);
119         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
120         balances[to] = balances[to].add(tokens);
121         emit Transfer(from, to, tokens);
122         return true;
123     }
124 
125     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
126         return allowed[tokenOwner][spender];
127     }
128 
129     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
130         allowed[msg.sender][spender] = tokens;
131         emit Approval(msg.sender, spender, tokens);
132         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
133         return true;
134     }
135 
136     function () public payable {
137         revert();
138     }
139 
140     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
141         return ERC20Interface(tokenAddress).transfer(owner, tokens);
142     }
143 }