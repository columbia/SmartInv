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
22 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
23 contract ERC20Interface {
24     function totalSupply() public constant returns (uint);
25     function balanceOf(address tokenOwner) public constant returns (uint balance);
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37 }
38 
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     function Owned() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract VormaToken is ERC20Interface, Owned, SafeMath {
66     string public symbol;
67     string public  name;
68     uint8 public decimals;
69     uint public _totalSupply;
70 
71     mapping(address => uint) balances;
72     mapping(address => mapping(address => uint)) allowed;
73 
74     function VormaToken() public {
75         symbol = "VOC";
76         name = "VORMACOIN";
77         decimals = 18;
78         _totalSupply = 30000000000000000000000000;
79         balances[0xc73e847d6d13468E3c3D37AA84de4feae9039d6C] = _totalSupply;
80         Transfer(address(0), 0xc73e847d6d13468E3c3D37AA84de4feae9039d6C, _totalSupply);
81     }
82 
83     function totalSupply() public constant returns (uint) {
84         return _totalSupply  - balances[address(0)];
85     }
86 
87     function balanceOf(address tokenOwner) public constant returns (uint balance) {
88         return balances[tokenOwner];
89     }
90 
91     function transfer(address to, uint tokens) public returns (bool success) {
92         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
93         balances[to] = safeAdd(balances[to], tokens);
94         Transfer(msg.sender, to, tokens);
95         return true;
96     }
97 
98     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
99      function approve(address spender, uint tokens) public returns (bool success) {
100         allowed[msg.sender][spender] = tokens;
101         Approval(msg.sender, spender, tokens);
102         return true;
103     }
104 
105     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
106         balances[from] = safeSub(balances[from], tokens);
107         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
108         balances[to] = safeAdd(balances[to], tokens);
109         Transfer(from, to, tokens);
110         return true;
111     }
112 
113     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
114         return allowed[tokenOwner][spender];
115     }
116 
117     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119         Approval(msg.sender, spender, tokens);
120         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
121         return true;
122     }
123 
124     function () public payable {
125         revert();
126     }
127 
128     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
129         return ERC20Interface(tokenAddress).transfer(owner, tokens);
130     }
131 }