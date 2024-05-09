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
73 // initial fixed supply of 0 units.
74 // The units will be created by demand using the create function reservated for trusted contract's address 
75 // ----------------------------------------------------------------------------
76 contract _Token is WhiteListAccess, _ERC20Interface {
77     using _SafeMath for uint;
78     
79     uint8   public   decimals;
80     uint    public   totSupply;
81     string  public   symbol;
82     string  public   name;
83 
84     mapping(address => uint) public balances;
85     mapping(address => mapping(address => uint)) public allowed;
86 
87 
88     // ------------------------------------------------------------------------
89     // Constructor
90     // ------------------------------------------------------------------------
91     function _Token(string _name, string _sym) public {
92         symbol = _sym;
93         name = _name;
94         decimals = 0;
95         totSupply = 0;
96     }
97 
98 
99     // ------------------------------------------------------------------------
100     // Total supply
101     // ------------------------------------------------------------------------
102     function totalSupply() public constant returns (uint) {
103         return totSupply;
104     }
105 
106 
107     // ------------------------------------------------------------------------
108     // Get the _token balance for account `_tokenOwner`
109     // ------------------------------------------------------------------------
110     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
111         return balances[_tokenOwner];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Transfer the balance from token owner's account to `to` account
117     // - Owner's account must have sufficient balance to transfer
118     // - 0 value transfers are allowed
119     // ------------------------------------------------------------------------
120     function transfer(address to, uint tokens) public returns (bool success) {
121         require(!freezed);
122         balances[msg.sender] = balances[msg.sender].sub(tokens);
123         balances[to] = balances[to].add(tokens);
124         Transfer(msg.sender, to, tokens);
125         return true;
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Token owner can approve for `spender` to transferFrom(...) `tokens`
131     // from the token owner's account
132     //
133     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
134     // recommends that there are no checks for the approval double-spend attack
135     // as this should be implemented in user interfaces 
136     // ------------------------------------------------------------------------
137     function approve(address spender, uint tokens) public returns (bool success) {
138         allowed[msg.sender][spender] = tokens;
139         Approval(msg.sender, spender, tokens);
140         return true;
141     }
142 
143     function desapprove(address spender) public returns (bool success) {
144         allowed[msg.sender][spender] = 0;
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer `tokens` from the `from` account to the `to` account
151     // 
152     // The calling account must already have sufficient tokens approve(...)-d
153     // for spending from the `from` account and
154     // - From account must have sufficient balance to transfer
155     // - Spender must have sufficient allowance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
159         require(!freezed);
160         balances[from] = balances[from].sub(tokens);
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         Transfer(from, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175 
176     // ------------------------------------------------------------------------
177     // Don't accept ETH
178     // ------------------------------------------------------------------------
179     function () public payable {
180         revert();
181     }
182 
183     // ------------------------------------------------------------------------
184     // FLC API 
185     // ------------------------------------------------------------------------
186     bool freezed;
187 
188     function create(uint units) public onlyWhitelisted() {
189         totSupply = totSupply + units;
190         balances[msg.sender] = balances[msg.sender] + units;
191     }
192 
193     function freeze() public onlyWhitelisted() {
194         freezed = true;
195     }
196     
197     function unfreeze() public onlyWhitelisted() {
198         freezed = false;
199     }
200 
201     // recover tokens sent accidentally
202     function _withdrawal(address _token) public {
203         uint _balance =  _ERC20Interface(_token).balanceOf(address(this));
204         if (_balance > 0) {
205             _ERC20Interface(_token).transfer(owner, _balance);
206         }
207         owner.transfer(this.balance);
208     }
209 }
210 
211 contract FourLeafClover is _Token("Four Leaf Clover", "FLC") {
212     function FourLeafClover() public {}
213 }