1 pragma solidity ^0.4.15;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8     function add(uint a, uint b) internal returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12 
13     function sub(uint a, uint b) internal returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17 
18     function mul(uint a, uint b) internal returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22 
23     function div(uint a, uint b) internal returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // ----------------------------------------------------------------------------
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35     function balanceOf(address tokenOwner) public constant returns (uint balance);
36     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Contract function to receive approval and execute function in one call
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // ERC20 Token, with the addition of symbol, name and decimals and an
73 // initial fixed supply
74 // ----------------------------------------------------------------------------
75 contract MuxeToken is ERC20Interface, Owned {
76     using SafeMath for uint;
77 
78     string public symbol;
79     string public  name;
80     uint8 public decimals;
81     uint public _totalSupply;
82     uint public tokensBurnt;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87     event Burn(uint tokens);
88 
89     function MuxeToken() public {
90         symbol = "MUXE";
91         name = "MUXE Token";
92         decimals = 18;
93         _totalSupply = 10000000000 * 10**uint(decimals);
94         tokensBurnt = 0;
95         balances[owner] = _totalSupply;
96         Transfer(address(0), owner, _totalSupply);
97     }
98 
99     // ------------------------------------------------------------------------
100     // Total supply
101     // ------------------------------------------------------------------------
102     function totalSupply() public constant returns (uint) {
103         return _totalSupply - tokensBurnt;
104     }
105 
106     // ------------------------------------------------------------------------
107     // Get the token balance for account `tokenOwner`
108     // ------------------------------------------------------------------------
109     function balanceOf(address tokenOwner) public constant returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113     function transfer(address to, uint tokens) public returns (bool success) {
114         balances[msg.sender] = balances[msg.sender].sub(tokens);
115         balances[to] = balances[to].add(tokens);
116         Transfer(msg.sender, to, tokens);
117         return true;
118     }
119 
120     function burn(uint tokens) onlyOwner public returns (bool success) {
121         balances[msg.sender] = balances[msg.sender].sub(tokens);
122         tokensBurnt = tokensBurnt.add(tokens);
123         Burn(tokens);
124         return true;
125     }
126 
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = balances[from].sub(tokens);
135         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
136         balances[to] = balances[to].add(tokens);
137         Transfer(from, to, tokens);
138         return true;
139     }
140 
141     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
142         return allowed[tokenOwner][spender];
143     }
144 
145     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         Approval(msg.sender, spender, tokens);
148         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
149         return true;
150     }
151 
152     // ------------------------------------------------------------------------
153     // Don't accept ETH
154     // ------------------------------------------------------------------------
155     function () public payable {
156         revert();
157     }
158 
159     // ------------------------------------------------------------------------
160     // Owner can transfer out any accidentally sent ERC20 tokens
161     // ------------------------------------------------------------------------
162     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
163         return ERC20Interface(tokenAddress).transfer(owner, tokens);
164     }
165 }