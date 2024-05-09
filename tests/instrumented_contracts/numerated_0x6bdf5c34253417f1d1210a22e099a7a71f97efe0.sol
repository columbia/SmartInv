1 //solium-disable linebreak-style
2 pragma solidity ^0.4.22;
3 
4 // ----------------------------------------------------------------------------
5 // 'WTXT' token Test contract
6 //
7 // Deployed to : 0xEF871E2F799bbF939964E9b707Cb2805EB4Bd515
8 // Symbol      : WTXT
9 // Name        : WTXT Token
10 // Total supply: 100000000
11 // Decimals    : 18
12 //
13 // Enjoy.
14 //
15 // (c) by World Trip Singapore Pte Ltd 2018. The MIT Licence.
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 contract SafeMath {
23     function safeAdd(uint a, uint b) public pure returns (uint c) {
24         c = a + b;
25         require(c >= a,"safeAdd Failed");
26     }
27     function safeSub(uint a, uint b) public pure returns (uint c) {
28         require(b <= a,"safeSub Failed");
29         c = a - b;
30     }
31     function safeMul(uint a, uint b) public pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b,"safeMul Failed");
34     }
35     function safeDiv(uint a, uint b) public pure returns (uint c) {
36         require(b > 0,"safeDiv Failed");
37         c = a / b;
38     }
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public view returns (uint);
48     function balanceOf(address tokenOwner) public view returns (uint balance);
49     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // Borrowed from MiniMeToken
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner,"msg.sender is not the owner");
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner,"transferOwnership is not success");
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract WTXTToken is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112     mapping (address => bool) public frozenAccount;
113 
114     /* This generates a public event on the blockchain that will notify clients */
115     event FrozenFunds(address target, bool frozen);
116 
117 
118     // ------------------------------------------------------------------------
119     // Constructor
120     // ------------------------------------------------------------------------
121     constructor() public {
122         symbol = "WTXT";
123         name = "WTXT Token";
124         decimals = 18;
125         _totalSupply = 100000000000000000000000000;
126         balances[0xEF871E2F799bbF939964E9b707Cb2805EB4Bd515] = _totalSupply;
127         emit Transfer(address(0), 0xEF871E2F799bbF939964E9b707Cb2805EB4Bd515, _totalSupply);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public view returns (uint) {
135         return _totalSupply - balances[address(0)];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account tokenOwner
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public view returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to to account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) public returns (bool success) {
153         require(!frozenAccount[msg.sender],"sender is frozen");                  
154         require(!frozenAccount[to],"recipient is frozen");                       
155         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
156         balances[to] = safeAdd(balances[to], tokens);
157         emit Transfer(msg.sender, to, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for spender to transferFrom(...) tokens
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
178     // Transfer tokens from the from account to the to account
179     // 
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the from account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
187         balances[from] = safeSub(balances[from], tokens);
188         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
189         balances[to] = safeAdd(balances[to], tokens);
190         emit Transfer(from, to, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Token owner can approve for spender to transferFrom(...) tokens
206     // from the token owner's account. The spender contract function
207     // receiveApproval(...) is then executed
208     // ------------------------------------------------------------------------
209     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         emit Approval(msg.sender, spender, tokens);
212         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Don't accept ETH
219     // ------------------------------------------------------------------------
220     function () public payable {
221         revert("");
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Owner can transfer out any accidentally sent ERC20 tokens
227     // ------------------------------------------------------------------------
228     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
229         return ERC20Interface(tokenAddress).transfer(owner, tokens);
230     }
231 
232     // ------------------------------------------------------------------------
233     // @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
234     // @param target Address to be frozen
235     // @param freeze either to freeze it or not
236     // ------------------------------------------------------------------------
237     function freezeAccount(address target, bool freeze) public onlyOwner returns (bool success)  {
238         frozenAccount[target] = freeze;
239         emit FrozenFunds(target, freeze);
240         return true;
241     }
242 
243     // ---------------------------------------------------------------------------
244     // Distribute airdrop to airdrop wallets, best practice 100 wallets per array
245     // ---------------------------------------------------------------------------
246     function distributeToken(address[] addresses, uint256 _value) public onlyOwner {
247         uint total = _value * addresses.length;
248         require(total/_value == addresses.length,"Overflow check"); // Overflow check
249         require(balances[owner] >= total,"Underflow check"); // Underflow check
250         balances[owner] -= total;
251         for (uint i = 0; i < addresses.length; i++) {
252             balances[addresses[i]] += _value;
253             require(balances[addresses[i]] >= _value,"Overflow check"); // Overflow check
254             emit Transfer(owner, addresses[i], _value);
255         }
256     }
257 }