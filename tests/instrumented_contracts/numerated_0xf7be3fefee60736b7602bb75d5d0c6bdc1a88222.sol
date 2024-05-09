1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 contract ERC20Interface {
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
66 contract DanpiaTestTokens is ERC20Interface, Owned {
67     using SafeMath for uint;
68 
69     string public symbol;
70     string public  name;
71     uint8 public decimals;
72     uint _totalSupply;
73 
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76 
77     constructor() public {
78         symbol = "DONT";
79         name = "DONpia Test";
80         decimals = 18;
81         _totalSupply = 12000000000 * 10**uint(decimals);
82         balances[owner] = _totalSupply;
83         emit Transfer(address(0), owner, _totalSupply);
84     }
85 
86     function totalSupply() public view returns (uint) {
87         return _totalSupply.sub(balances[address(0)]);
88     }
89 
90     function balanceOf(address tokenOwner) public view returns (uint balance) {
91         return balances[tokenOwner];
92     }
93 
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = balances[msg.sender].sub(tokens);
96         balances[to] = balances[to].add(tokens);
97         emit Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101     function approve(address spender, uint tokens) public returns (bool success) {
102         allowed[msg.sender][spender] = tokens;
103         emit Approval(msg.sender, spender, tokens);
104         return true;
105     }
106 
107     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108         balances[from] = balances[from].sub(tokens);
109         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         emit Transfer(from, to, tokens);
112         return true;
113     }
114 
115 
116     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
117         return allowed[tokenOwner][spender];
118     }
119 
120 
121     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
122         allowed[msg.sender][spender] = tokens;
123         emit Approval(msg.sender, spender, tokens);
124         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
125         return true;
126     }
127 
128     function () external payable {
129         revert();
130     }
131 
132 
133     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
134         return ERC20Interface(tokenAddress).transfer(owner, tokens);
135     }
136 }