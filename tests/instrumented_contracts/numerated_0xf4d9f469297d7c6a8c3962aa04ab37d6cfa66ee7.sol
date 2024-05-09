1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     function Owned() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 contract AdviserCasperToken is ERC20Interface, Owned {
71     using SafeMath for uint;
72 
73     string public symbol;
74     string public name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     // ------------------------------------------------------------------------
83     // Constructor
84     // ------------------------------------------------------------------------
85     function AdviserCasperToken() public {
86         symbol = "ACST";
87         name = "Adviser Csper Token";
88         decimals = 18;
89         _totalSupply = 440000000 * 10**uint(decimals);
90         balances[owner] = _totalSupply;
91         Transfer(address(0), owner, _totalSupply);
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Total supply
97     // ------------------------------------------------------------------------
98     function totalSupply() public view returns (uint) {
99         return _totalSupply - balances[address(0)];
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Get the token balance for account `tokenOwner`
105     // ------------------------------------------------------------------------
106     function balanceOf(address tokenOwner) public view returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Transfer the balance from token owner's account to `to` account
113     // - Owner's account must have sufficient balance to transfer
114     // - 0 value transfers are allowed
115     // ------------------------------------------------------------------------
116     function transfer(address to, uint tokens) public onlyOwner returns (bool success) {
117         require(msg.sender == owner);
118         balances[msg.sender] = balances[msg.sender].sub(tokens);
119         balances[to] = balances[to].add(tokens);
120         Transfer(msg.sender, to, tokens);
121         return true;
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Token owner can approve for `spender` to transferFrom(...) `tokens`
127     // from the token owner's account
128     //
129     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
130     // recommends that there are no checks for the approval double-spend attack
131     // as this should be implemented in user interfaces 
132     // ------------------------------------------------------------------------
133     function approve(address spender, uint tokens) public returns (bool success) {
134         require(msg.sender == owner);
135         allowed[msg.sender][spender] = tokens;
136         Approval(msg.sender, spender, tokens);
137         return true;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer `tokens` from the `from` account to the `to` account
143     // 
144     // The calling account must already have sufficient tokens approve(...)-d
145     // for spending from the `from` account and
146     // - From account must have sufficient balance to transfer
147     // - Spender must have sufficient allowance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
151         require(msg.sender == owner);
152         balances[from] = balances[from].sub(tokens);
153         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
154         balances[to] = balances[to].add(tokens);
155         Transfer(from, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Returns the amount of tokens approved by the owner that can be
162     // transferred to the spender's account
163     // ------------------------------------------------------------------------
164     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167 }