1 pragma solidity ^0.4.18;
2 
3 
4 contract Owned {
5     address public owner;
6     address public newOwner;
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function Owned() public {
10         owner = msg.sender;
11     }
12 
13  
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19 
20     function transferOwnership(address _newOwner) public onlyOwner {
21         newOwner = _newOwner;
22     }
23 
24 
25     function acceptOwnership() public {
26         require(msg.sender == newOwner);
27         emit OwnershipTransferred(owner, newOwner);
28         owner = newOwner;
29         newOwner = address(0);
30     }
31 }
32 
33 library SafeMath {
34     function add(uint a, uint b) internal pure returns (uint c) {
35         c = a + b;
36         require(c >= a);
37     }
38     function sub(uint a, uint b) internal pure returns (uint c) {
39         require(b <= a);
40         c = a - b;
41     }
42     function mul(uint a, uint b) internal pure returns (uint c) {
43         c = a * b;
44         require(a == 0 || c / a == b);
45     }
46     function div(uint a, uint b) internal pure returns (uint c) {
47         require(b > 0);
48         c = a / b;
49     }
50 }
51 
52 // ----------------------------------------------------------------------------
53 // ERC Token Standard #20 Interface
54 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
55 // ----------------------------------------------------------------------------
56 contract ERC20Interface {
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address tokenOwner) public constant returns (uint balance);
59     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 
69 
70 contract ApproveAndCallFallBack {
71     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
72 }
73 
74 
75 
76 
77 contract MJOYToken is ERC20Interface, Owned {
78 
79 
80     string  public  symbol;
81     string  public  name;
82     uint8 public decimals;
83     uint  _totalSupply;
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86     using SafeMath for uint;
87     function MJOYToken() public {
88         symbol = "JOY";
89         name = "MJOY TOKEN";
90         decimals = 18;
91         _totalSupply = 1 * (10 ** 9) * (10 ** uint(decimals));
92         balances[owner] = 6 * (10 ** 8) * (10 ** uint(decimals));
93         emit Transfer(address(0), owner, _totalSupply);
94     }
95     
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply - balances[address(0)];
98     }
99    
100     function balanceOf(address tokenOwner) public constant returns (uint balance) {
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
125     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
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
136     function() public payable {
137         revert();
138     }
139   
140     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
141         return ERC20Interface(tokenAddress).transfer(owner, tokens);
142     }
143 
144 }