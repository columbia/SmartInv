1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Viral Cash' Contract
5 //
6 // Deployed to : 0x8D3CC1287Cb3DDD2F4674f0ceBE85cDf2703BaC5
7 // Symbol      : VCH
8 // Name        : Viral Cash
9 // Total supply: 95000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) public pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) public pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         newOwner = address(0);
71     }
72 }
73 
74 contract VIRALCASH is ERC20Interface, Owned, SafeMath {
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public _totalSupply;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83     constructor() public {
84         symbol = "VCH";
85         name = "Viral Cash";
86         decimals = 18;
87         _totalSupply = 95000000e18;
88         balances[0x8D3CC1287Cb3DDD2F4674f0ceBE85cDf2703BaC5] = _totalSupply;
89         emit Transfer(address(0), 0x8D3CC1287Cb3DDD2F4674f0ceBE85cDf2703BaC5, _totalSupply);
90     }
91     function totalSupply() public constant returns (uint) {
92         return _totalSupply  - balances[address(0)];
93     }
94     function balanceOf(address tokenOwner) public constant returns (uint balance) {
95         return balances[tokenOwner];
96     }
97     function transfer(address to, uint tokens) public returns (bool success) {
98         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
99         balances[to] = safeAdd(balances[to], tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103     function approve(address spender, uint tokens) public returns (bool success) {
104         allowed[msg.sender][spender] = tokens;
105         emit Approval(msg.sender, spender, tokens);
106         return true;
107     }
108     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
109         balances[from] = safeSub(balances[from], tokens);
110         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
111         balances[to] = safeAdd(balances[to], tokens);
112         emit Transfer(from, to, tokens);
113         return true;
114     }
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
116         return allowed[tokenOwner][spender];
117     }
118     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
119         allowed[msg.sender][spender] = tokens;
120         emit Approval(msg.sender, spender, tokens);
121         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
122         return true;
123     }
124     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
125         return ERC20Interface(tokenAddress).transfer(owner, tokens);
126     }
127 }