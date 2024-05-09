1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     function Owned() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         newOwner = _newOwner;
54     }
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 contract Petro is ERC20Interface, Owned, SafeMath {
64     string public symbol;
65     string public  name;
66     uint8 public decimals;
67     uint public _totalSupply;
68 
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71 
72     function Petro() public {
73         symbol = "PTR";
74         name = "Petro";
75         decimals = 18;
76         _totalSupply = 100000000000000000000000000;
77         balances[0xcC732F41A205Fe616E9Ed64674eF50B25F7d6859] = _totalSupply;
78         Transfer(address(0), 0xcC732F41A205Fe616E9Ed64674eF50B25F7d6859, _totalSupply);
79     }
80 
81     function totalSupply() public constant returns (uint) {
82         return _totalSupply  - balances[address(0)];
83     }
84 
85     function balanceOf(address tokenOwner) public constant returns (uint balance) {
86         return balances[tokenOwner];
87     }
88 
89     function transfer(address to, uint tokens) public returns (bool success) {
90         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
91         balances[to] = safeAdd(balances[to], tokens);
92         Transfer(msg.sender, to, tokens);
93         return true;
94     }
95 
96     function approve(address spender, uint tokens) public returns (bool success) {
97         allowed[msg.sender][spender] = tokens;
98         Approval(msg.sender, spender, tokens);
99         return true;
100     }
101 
102     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
103         balances[from] = safeSub(balances[from], tokens);
104         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
105         balances[to] = safeAdd(balances[to], tokens);
106         Transfer(from, to, tokens);
107         return true;
108     }
109 
110     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
111         return allowed[tokenOwner][spender];
112     }
113 
114     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
115         allowed[msg.sender][spender] = tokens;
116         Approval(msg.sender, spender, tokens);
117         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
118         return true;
119     }
120 
121     function () public payable {
122         revert();
123     }
124 
125     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
126         return ERC20Interface(tokenAddress).transfer(owner, tokens);
127     }
128 }