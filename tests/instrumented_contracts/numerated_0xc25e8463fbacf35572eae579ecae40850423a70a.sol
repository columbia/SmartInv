1 pragma solidity ^ 0.4 .24;
2 
3 // ----------------------------------------------------------------------------
4 // 'SLD' 'Solid Sources Token' contract
5 //
6 // Symbol      : SLD
7 // Name        : Solid Sources Token
8 // Total supply: 500,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns(uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22 
23     function sub(uint a, uint b) internal pure returns(uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27 
28     function mul(uint a, uint b) internal pure returns(uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32 
33     function div(uint a, uint b) internal pure returns(uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 
38 }
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // ----------------------------------------------------------------------------
43 
44 contract ERC20Interface {
45     function totalSupply() public constant returns(uint);
46 
47     function balanceOf(address tokenOwner) public constant returns(uint balance);
48 
49     function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
50 
51     function transfer(address to, uint tokens) public returns(bool success);
52 
53     function approve(address spender, uint tokens) public returns(bool success);
54 
55     function transferFrom(address from, address to, uint tokens) public returns(bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 // ----------------------------------------------------------------------------
62 // Contract function to receive approval and execute function in one call
63 // ----------------------------------------------------------------------------
64 
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67 }
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 
73 contract Owned {
74     address public owner;
75     address public newOwner;
76 
77     event OwnershipTransferred(address indexed _from, address indexed _to);
78 
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88 
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92 
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 // ----------------------------------------------------------------------------
102 // ERC20 Token, with the addition of symbol, name and decimals and a
103 // fixed supply
104 // ----------------------------------------------------------------------------
105 
106 contract SolidSourcesToken is ERC20Interface, Owned {
107     using SafeMath
108     for uint;
109 
110     string public symbol;
111     string public name;
112     uint8 public decimals;
113     uint _totalSupply;
114 
115     mapping(address => uint) balances;
116     mapping(address => mapping(address => uint)) allowed;
117 
118     event Burn(address indexed burner, uint256 value);
119 
120     // ------------------------------------------------------------------------
121     // Constructor
122     // ------------------------------------------------------------------------
123 
124     constructor() public {
125         symbol = "SLD";
126         name = "Solid Sources Token";
127         decimals = 18;
128         _totalSupply = 500000000 * 10 ** uint(decimals);
129         balances[owner] = _totalSupply;
130         emit Transfer(address(0), owner, _totalSupply);
131     }
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136 
137     function totalSupply() public view returns(uint) {
138         return _totalSupply.sub(balances[address(0)]);
139     }
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account `tokenOwner`
143     // ------------------------------------------------------------------------
144 
145     function balanceOf(address tokenOwner) public view returns(uint balance) {
146         return balances[tokenOwner];
147     }
148 
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to `to` account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154 
155     function transfer(address to, uint tokens) public returns(bool success) {
156         balances[msg.sender] = balances[msg.sender].sub(tokens);
157         balances[to] = balances[to].add(tokens);
158         emit Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     // ------------------------------------------------------------------------
166 
167     function approve(address spender, uint tokens) public returns(bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173     // ------------------------------------------------------------------------
174     // Transfer `tokens` from the `from` account to the `to` account
175     // 
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the `from` account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182 
183     function transferFrom(address from, address to, uint tokens) public returns(bool success) {
184         balances[from] = balances[from].sub(tokens);
185         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
186         balances[to] = balances[to].add(tokens);
187         emit Transfer(from, to, tokens);
188         return true;
189     }
190 
191     //Burn tokens
192 
193     function burn(uint256 _value) public returns (bool success) {
194         require(balances[msg.sender] >= _value);   // Check if the sender has enough
195         balances[msg.sender] -= _value;            // Subtract from the sender
196         _totalSupply -= _value;                      // Updates totalSupply
197         emit Burn(msg.sender, _value);
198         return true;
199     }
200 
201     // ------------------------------------------------------------------------
202     // Returns the amount of tokens approved by the owner that can be
203     // transferred to the spender's account
204     // ------------------------------------------------------------------------
205 
206     function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
207         return allowed[tokenOwner][spender];
208     }
209 
210     // ------------------------------------------------------------------------
211     // Token owner can approve for `spender` to transferFrom(...) `tokens`
212     // from the token owner's account. The `spender` contract function
213     // `receiveApproval(...)` is then executed
214     // ------------------------------------------------------------------------
215 
216     function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
217         allowed[msg.sender][spender] = tokens;
218         emit Approval(msg.sender, spender, tokens);
219         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
220         return true;
221     }
222 
223     // ------------------------------------------------------------------------
224     // Don't accept ETH
225     // ------------------------------------------------------------------------
226 
227     function() public payable {
228         revert();
229     }
230 
231     // ------------------------------------------------------------------------
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ------------------------------------------------------------------------
234 
235     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
236         return ERC20Interface(tokenAddress).transfer(owner, tokens);
237     }
238 }