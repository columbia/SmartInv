1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
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
57     
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 contract TokenMintGeneral is ERC20Interface, Owned, SafeMath {
67     string public symbol = "BitCat";
68     string public name = "BitCat";
69     uint8 public decimals = 18;
70     uint public _totalSupply = 210000000000 * 10 ** uint(decimals);
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     function TokenMintGeneral() public {
76         balances[msg.sender] = _totalSupply;
77         emit Transfer(address(0), msg.sender, _totalSupply);
78     }
79 
80     function totalSupply() public constant returns (uint) {
81         return _totalSupply  - balances[address(0)];
82     }
83 
84     function balanceOf(address tokenOwner) public constant returns (uint balance) {
85         return balances[tokenOwner];
86     }
87 
88     function transfer(address to, uint tokens) public returns (bool success) {
89         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
90         balances[to] = safeAdd(balances[to], tokens);
91         emit Transfer(msg.sender, to, tokens);
92         return true;
93     }
94 
95     function approve(address spender, uint tokens) public returns (bool success) {
96         allowed[msg.sender][spender] = tokens;
97         emit Approval(msg.sender, spender, tokens);
98         return true;
99     }
100 
101     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
102         balances[from] = safeSub(balances[from], tokens);
103         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(from, to, tokens);
106         return true;
107     }
108 
109     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
110         return allowed[tokenOwner][spender];
111     }
112 
113     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
114         allowed[msg.sender][spender] = tokens;
115         emit Approval(msg.sender, spender, tokens);
116         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
117         return true;
118     }
119 
120     function () public payable {
121         revert();
122     }
123 
124     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
125         return ERC20Interface(tokenAddress).transfer(owner, tokens);
126     }
127 }