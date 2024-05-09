1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public view returns (uint);
26     function balanceOf(address tokenOwner) public view returns (uint balance);
27     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 contract ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
39 }
40 
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     constructor() public {
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
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 
69 contract SampleToken is ERC20Interface, Owned {
70 
71     using SafeMath for uint;
72 
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     constructor() public {
83         symbol = "STEP"; 
84         name = "1Step.finance"; 
85         decimals = 8;   
86         _totalSupply = 20000000 * 10**uint(decimals);     
87         balances[owner] = _totalSupply;
88         emit Transfer(address(0), owner, _totalSupply);
89     }
90 
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
121 
122     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
123         return allowed[tokenOwner][spender];
124     }
125 
126     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
130         return true;
131     }
132 
133     function () external payable {
134         revert();
135     }
136 
137     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
138         return ERC20Interface(tokenAddress).transfer(owner, tokens);
139     }
140 }