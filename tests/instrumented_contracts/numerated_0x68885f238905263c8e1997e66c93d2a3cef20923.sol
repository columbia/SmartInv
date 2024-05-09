1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10         require(a == c - b);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15         require(a == c + b );
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24         require(a == b * c);
25     }
26 }
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
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     constructor() public {
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
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // HappyEx Token
73 // ----------------------------------------------------------------------------
74 contract HappyToken is ERC20Interface, Owned {
75     using SafeMath for uint;
76 
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint _totalSupply;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85 
86     // ------------------------------------------------------------------------
87     // Constructor
88     // ------------------------------------------------------------------------
89     constructor() public {
90         symbol = "Happy";
91         name = "HappyEx";
92         decimals = 18;
93         _totalSupply = 500000000 * 10**uint(decimals);
94         balances[owner] = _totalSupply;
95         emit Transfer(address(0), owner, _totalSupply);
96     }
97 
98 
99     // ------------------------------------------------------------------------
100     // Total supply
101     // ------------------------------------------------------------------------
102     function totalSupply() public view returns (uint) {
103         return _totalSupply.sub(balances[address(0)]);
104     }
105 
106 
107     // ------------------------------------------------------------------------
108     // Get the token balance for account `tokenOwner`
109     // ------------------------------------------------------------------------
110     function balanceOf(address tokenOwner) public view returns (uint balance) {
111         return balances[tokenOwner];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Transfer the balance from token owner's account to `to` account
117     // - Owner's account must have sufficient balance to transfer
118     // - 0 value transfers are allowed
119     // ------------------------------------------------------------------------
120     function transfer(address to, uint tokens) public returns (bool success) {
121         balances[msg.sender] = balances[msg.sender].sub(tokens);
122         balances[to] = balances[to].add(tokens);
123         emit Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Token owner can approve for `spender` to transferFrom(...) `tokens`
130     // from the token owner's account
131     // ------------------------------------------------------------------------
132     function approve(address spender, uint tokens) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer `tokens` from the `from` account to the `to` account
141     //
142     // The calling account must already have sufficient tokens approve(...)-d
143     // for spending from the `from` account and
144     // - From account must have sufficient balance to transfer
145     // - Spender must have sufficient allowance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
149         require(allowed[from][msg.sender] >= tokens); 
150 
151         balances[from] = balances[from].sub(tokens);
152         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
153         balances[to] = balances[to].add(tokens);
154         emit Transfer(from, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Returns the amount of tokens approved by the owner that can be
161     // transferred to the spender's account
162     // ------------------------------------------------------------------------
163     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
164         return allowed[tokenOwner][spender];
165     }
166 }