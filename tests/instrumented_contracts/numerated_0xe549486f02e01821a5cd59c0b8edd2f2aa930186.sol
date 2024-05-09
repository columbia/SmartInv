1 pragma solidity ^0.4.24;
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
37 contract ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
39 }
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 contract ASIEX is ERC20Interface, Owned {
68     using SafeMath for uint;
69 
70     string public symbol;
71     string public  name;
72     uint8 public decimals;
73     uint _totalSupply;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78     constructor() public {
79         symbol = "ASI";
80         name = "ASIEX.IO";
81         decimals = 18;
82         _totalSupply = 100000000 * 10**uint(decimals);
83         balances[owner] = _totalSupply;
84         emit Transfer(address(0), owner, _totalSupply);
85     }
86 
87     function totalSupply() public view returns (uint) {
88         return _totalSupply.sub(balances[address(0)]);
89     }
90 
91     function balanceOf(address tokenOwner) public view returns (uint balance) {
92         return balances[tokenOwner];
93     }
94 
95     function transfer(address to, uint tokens) public returns (bool success) {
96         balances[msg.sender] = balances[msg.sender].sub(tokens);
97         balances[to] = balances[to].add(tokens);
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
109         balances[from] = balances[from].sub(tokens);
110         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
111         balances[to] = balances[to].add(tokens);
112         emit Transfer(from, to, tokens);
113         return true;
114     }
115 
116     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
117         return allowed[tokenOwner][spender];
118     }
119 
120     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender, spender, tokens);
123         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
124         return true;
125     }
126 
127     function () public payable {
128         revert();
129     }
130 
131     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
132         return ERC20Interface(tokenAddress).transfer(owner, tokens);
133     }
134 }