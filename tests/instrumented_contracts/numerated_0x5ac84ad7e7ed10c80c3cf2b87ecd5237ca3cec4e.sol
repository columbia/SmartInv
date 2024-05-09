1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library _SafeMath {
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
25 
26 // ----------------------------------------------------------------------------
27 // contract WhiteListAccess
28 // ----------------------------------------------------------------------------
29 contract WhiteListAccess {
30     
31     function WhiteListAccess() public {
32         owner = msg.sender;
33         whitelist[owner] = true;
34         whitelist[address(this)] = true;
35     }
36     
37     address public owner;
38     mapping (address => bool) whitelist;
39 
40     modifier onlyOwner {require(msg.sender == owner); _;}
41     modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}
42 
43     function addToWhiteList(address trusted) public onlyOwner() {
44         whitelist[trusted] = true;
45     }
46 
47     function removeFromWhiteList(address untrusted) public onlyOwner() {
48         whitelist[untrusted] = false;
49     }
50 
51 }
52 
53 // ----------------------------------------------------------------------------
54 // ERC Token Standard #20 Interface
55 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
56 // ----------------------------------------------------------------------------
57 contract _ERC20Interface {
58     function totalSupply() public constant returns (uint);
59     function balanceOf(address tokenOwner) public constant returns (uint balance);
60     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
61     function transfer(address to, uint tokens) public returns (bool success);
62     function approve(address spender, uint tokens) public returns (bool success);
63     function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 
65     event Transfer(address indexed from, address indexed to, uint tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67 }
68 
69 
70 
71 // ----------------------------------------------------------------------------
72 // ERC20 Token, with the addition of symbol, name and decimals and an
73 // initial fixed supply
74 // ----------------------------------------------------------------------------
75 contract _Token is WhiteListAccess, _ERC20Interface {
76     using _SafeMath for uint;
77     
78     uint8   public   decimals;
79     uint    public   totSupply;
80     string  public   symbol;
81     string  public   name;
82 
83     mapping(address => uint) public balances;
84     mapping(address => mapping(address => uint)) public allowed;
85 
86 
87     // ------------------------------------------------------------------------
88     // Constructor
89     // ------------------------------------------------------------------------
90     function _Token(string _name, string _sym) public {
91         symbol = _sym;
92         name = _name;
93         decimals = 0;
94         totSupply = 0;
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Total supply
100     // ------------------------------------------------------------------------
101     function totalSupply() public constant returns (uint) {
102         return totSupply;
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Get the _token balance for account `_tokenOwner`
108     // ------------------------------------------------------------------------
109     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
110         return balances[_tokenOwner];
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Transfer the balance from token owner's account to `to` account
116     // - Owner's account must have sufficient balance to transfer
117     // - 0 value transfers are allowed
118     // ------------------------------------------------------------------------
119     function transfer(address to, uint tokens) public returns (bool success) {
120         require(!freezed);
121         balances[msg.sender] = balances[msg.sender].sub(tokens);
122         balances[to] = balances[to].add(tokens);
123         Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Token owner can approve for `spender` to transferFrom(...) `tokens`
130     // from the token owner's account
131     //
132     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
133     // recommends that there are no checks for the approval double-spend attack
134     // as this should be implemented in user interfaces 
135     // ------------------------------------------------------------------------
136     function approve(address spender, uint tokens) public returns (bool success) {
137         allowed[msg.sender][spender] = tokens;
138         Approval(msg.sender, spender, tokens);
139         return true;
140     }
141 
142     function desapprove(address spender) public returns (bool success) {
143         allowed[msg.sender][spender] = 0;
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer `tokens` from the `from` account to the `to` account
150     // 
151     // The calling account must already have sufficient tokens approve(...)-d
152     // for spending from the `from` account and
153     // - From account must have sufficient balance to transfer
154     // - Spender must have sufficient allowance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         require(!freezed);
159         balances[from] = balances[from].sub(tokens);
160         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         Transfer(from, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Don't accept ETH
178     // ------------------------------------------------------------------------
179     function () public payable {
180         revert();
181     }
182 
183 
184 
185     // ------------------------------------------------------------------------
186     // FLC API 
187     // ------------------------------------------------------------------------
188     bool freezed;
189 
190     function create(uint units) public onlyWhitelisted() {
191         totSupply = totSupply + units;
192         balances[msg.sender] = balances[msg.sender] + units;
193     }
194 
195     function freeze() public onlyWhitelisted() {
196         freezed = true;
197     }
198     
199     function unfreeze() public onlyWhitelisted() {
200         freezed = false;
201     }
202 }
203 
204 contract FourLeafClover is _Token("Four Leaf Clover", "FLC") {
205     function FourLeafClover() public {}
206 }