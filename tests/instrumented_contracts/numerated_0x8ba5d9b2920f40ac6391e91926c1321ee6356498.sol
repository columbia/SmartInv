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
21 contract ERC20Interface {
22     function totalSupply() public view returns (uint);
23     function balanceOf(address tokenOwner) public view returns (uint balance);
24     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwner(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract fubicai is ERC20Interface, Owned {
65     using SafeMath for uint;
66 
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint _totalSupply;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     constructor() public {
76         symbol = "FBC";
77         name = "Fubicai";
78         decimals = 8;
79         _totalSupply = 1000000000 * 10**uint(decimals);
80         balances[owner] = _totalSupply;
81         emit Transfer(address(0), owner, _totalSupply);
82     }
83     function totalSupply() public view returns (uint) {
84         return _totalSupply.sub(balances[address(0)]);
85     }
86 
87     function balanceOf(address tokenOwner) public view returns (uint balance) {
88         return balances[tokenOwner];
89     }
90 
91     function transfer(address to, uint tokens) public returns (bool success) {
92         balances[msg.sender] = balances[msg.sender].sub(tokens);
93         balances[to] = balances[to].add(tokens);
94         emit Transfer(msg.sender, to, tokens);
95         return true;
96     }
97 
98     function approve(address spender, uint tokens) public returns (bool success) {
99         allowed[msg.sender][spender] = tokens;
100         emit Approval(msg.sender, spender, tokens);
101         return true;
102     }
103 
104     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
105         balances[from] = balances[from].sub(tokens);
106         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
107         balances[to] = balances[to].add(tokens);
108         emit Transfer(from, to, tokens);
109         return true;
110     }
111 
112     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
113         return allowed[tokenOwner][spender];
114     }
115 
116     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         emit Approval(msg.sender, spender, tokens);
119         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
120         return true;
121     }
122 
123     function () external payable {
124         revert();
125     }
126 
127     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
128         return ERC20Interface(tokenAddress).transfer(owner, tokens);
129     }
130     
131     function burn(uint tokens ) public onlyOwner returns (bool success) {
132         require( balances[msg.sender] >=tokens);
133          balances[msg.sender] -= tokens;
134          _totalSupply -=tokens;
135         return true;
136     }
137 }