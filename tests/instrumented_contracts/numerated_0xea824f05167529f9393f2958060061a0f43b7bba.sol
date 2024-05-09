1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CLC' token contract
5 //
6 // Deployed to : 0x58d77F6F45613FD669c576a84E980Da82379416a
7 // Symbol      : CLC
8 // Name        : Cryptessa Liquid Coin
9 // Total supply: 100000000
10 // Decimals    : 18
11 contract SafeMath {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     function Owned() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 contract CryptessaLiquidCoin is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82 
83     function CryptessaLiquidCoin() public {
84         symbol = "CLC";
85         name = "Cryptessa Liquid Coin";
86         decimals = 18;
87         _totalSupply = 2000000000000000000000000000000;
88         balances[0x58d77F6F45613FD669c576a84E980Da82379416a] = _totalSupply;
89         Transfer(address(0), 0x58d77F6F45613FD669c576a84E980Da82379416a, _totalSupply);
90     }
91 
92     function totalSupply() public constant returns (uint) {
93         return _totalSupply  - balances[address(0)];
94     }
95 
96     function balanceOf(address tokenOwner) public constant returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100     function transfer(address to, uint tokens) public returns (bool success) {
101         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
102         balances[to] = safeAdd(balances[to], tokens);
103         Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107 
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
115         balances[from] = safeSub(balances[from], tokens);
116         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         Transfer(from, to, tokens);
119         return true;
120     }
121 
122     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
123         return allowed[tokenOwner][spender];
124     }
125 
126     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         Approval(msg.sender, spender, tokens);
129         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
130         return true;
131     }
132 
133     function () public payable {
134         revert();
135     }
136 
137     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
138         return ERC20Interface(tokenAddress).transfer(owner, tokens);
139     }
140 }