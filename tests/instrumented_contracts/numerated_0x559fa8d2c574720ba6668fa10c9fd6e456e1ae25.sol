1 //----------------------------
2 //compiler on  0.5.17  pass
3 //----------------------------
4 
5 pragma solidity ^0.5.0;
6 
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 
28 contract ERC20Interface {
29     function totalSupply() public view returns (uint);
30     function balanceOf(address tokenOwner) public view returns (uint balance);
31     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
43 }
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 contract IFLYToken is ERC20Interface, Owned {
72     using SafeMath for uint;
73 
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82     constructor() public {
83         symbol = "IT";
84         name = "爱飞";
85         decimals = 10;
86         _totalSupply = 100000000 * 10**uint(decimals);
87         balances[0x22A829f28df148Ff84b338b4edF0128F5761D3F6] = _totalSupply;
88         emit Transfer(address(0), 0x22A829f28df148Ff84b338b4edF0128F5761D3F6, _totalSupply);
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