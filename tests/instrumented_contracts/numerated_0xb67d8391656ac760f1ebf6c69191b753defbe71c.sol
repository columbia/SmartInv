1 pragma solidity ^0.4.24;
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
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
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
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and a
85 // fixed supply
86 // ----------------------------------------------------------------------------
87 contract MCK is ERC20Interface, Owned {
88     using SafeMath for uint;
89 
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint _totalSupply;
94 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97 
98     // ------------------------------------------------------------------------
99     // airdrop params
100     // ------------------------------------------------------------------------
101     uint256 public _airdropAmount;
102     uint256 public _airdropTotal;
103     uint256 public _airdropSupply;
104     mapping(address => bool) initialized;
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     constructor() public {
110         symbol = "MCK";
111         name = "Maker Chain";
112         decimals = 18;
113         _totalSupply = 1000000000 * 10 ** uint256(decimals);
114         _airdropAmount = 15000 * 10 ** uint256(decimals);
115         _airdropSupply =  300000000 * 10 ** uint256(decimals);
116 
117         balances[owner] = _totalSupply.sub(_airdropSupply);
118         initialized[owner] = true;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public view returns (uint) {
127         return _totalSupply.sub(balances[address(0)]);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public view returns (uint balance) {
135         return getBalance(tokenOwner); // balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145 
146         // active first
147         initialize(msg.sender);
148 
149         require(tokens <= balances[msg.sender]);
150         require(to != address(0));
151 
152         // initialize(to);
153 
154         balances[msg.sender] = balances[msg.sender].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156         emit Transfer(msg.sender, to, tokens);
157         return true;
158 
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         emit Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer `tokens` from the `from` account to the `to` account
179     //
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the `from` account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
187         // active
188         initialize(from);
189 
190         require(tokens <= balances[from]);
191         require(tokens <= allowed[from][msg.sender]);
192         require(to != address(0));
193 
194         // initialize(to);
195 
196         balances[from] = balances[from].sub(tokens);
197         balances[to] = balances[to].add(tokens);
198         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
199         emit Transfer(from, to, tokens);
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Returns the amount of tokens approved by the owner that can be
206     // transferred to the spender's account
207     // ------------------------------------------------------------------------
208     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
209         return allowed[tokenOwner][spender];
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Token owner can approve for `spender` to transferFrom(...) `tokens`
215     // from the token owner's account. The `spender` contract function
216     // `receiveApproval(...)` is then executed
217     // ------------------------------------------------------------------------
218     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);
221         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
222         return true;
223     }
224 
225     // ------------------------------------------------------------------------
226     // Owner can transfer out any accidentally sent ERC20 tokens
227     // ------------------------------------------------------------------------
228     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
229         return ERC20Interface(tokenAddress).transfer(owner, tokens);
230     }
231 
232     // ------------------------------------------------------------------------
233     // Get the airdrop token balance for account `tokenOwner`
234     // ------------------------------------------------------------------------
235     function getBalance(address _address) internal returns (uint256) {
236         if (_airdropTotal < _airdropSupply && !initialized[_address]) {
237             return balances[_address] + _airdropAmount;
238         } else {
239             return balances[_address];
240         }
241     }
242 
243     // ------------------------------------------------------------------------
244     // internal private functions
245     // ------------------------------------------------------------------------
246     function initialize(address _address) internal returns (bool success) {
247         if (_airdropTotal <= _airdropSupply && !initialized[_address]) {
248             initialized[_address] = true;
249             balances[_address] = _airdropAmount;
250             _airdropTotal = _airdropTotal.add(_airdropAmount);
251         }
252         return true;
253     }
254 
255 }