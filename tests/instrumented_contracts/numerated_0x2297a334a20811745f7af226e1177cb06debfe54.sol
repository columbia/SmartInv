1 pragma solidity ^0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 // 'IVNT3' token contract
5 //
6 // Deployed to : 0x46a95d3d6109f5e697493ea508d6d20aff1cc13e
7 // Symbol      : IVNT3
8 // Name        : IVNT3 Token
9 // Total supply: 96900000000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48     function burn(uint256 _value) public returns (bool success);
49     function burnFrom(address _from, uint256 _value) public returns (bool success);
50     function freezeAccount(address target, bool freeze) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54     event Burn(address indexed from, uint256 value);
55     event FrozenFunds(address target, bool frozen);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // Contract function to receive approval and execute function in one call
91 //
92 // Borrowed from MiniMeToken
93 // ----------------------------------------------------------------------------
94 contract ApproveAndCallFallBack {
95     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract IVNT3Token is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     address public ownerAddress;
107     uint8 public decimals;
108     uint public _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112     mapping(address => bool) public frozenAccount;
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "IVNT3";
119         name = "IVNT3 Token";
120         decimals = 18;
121         _totalSupply = 969 * 10 ** 26;
122         ownerAddress = 0x46a95d3d6109f5e697493ea508d6d20aff1cc13e;
123         balances[ownerAddress] = _totalSupply;
124         emit Transfer(address(0), ownerAddress, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply - balances[address(0)];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account tokenOwner
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to to account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         require(!frozenAccount[msg.sender]);
153         emit Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for spender to transferFrom(...) tokens
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces 
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer tokens from the from account to the to account
175     // 
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the from account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = safeSub(balances[from], tokens);
184         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
185         balances[to] = safeAdd(balances[to], tokens);
186         require(!frozenAccount[from]);
187         emit Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for spender to transferFrom(...) tokens
203     // from the token owner's account. The spender contract function
204     // receiveApproval(...) is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         emit Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Don't accept ETH
216     // ------------------------------------------------------------------------
217     function () public payable {
218         revert();
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Destroy tokens
232     // Remove `_value` tokens from the system irreversibly
233     // @param _value the amount of money to burn
234     // ------------------------------------------------------------------------
235     function burn(uint256 _value) public returns (bool success) {
236         require(balances[msg.sender] >= _value);   // Check if the sender has enough
237         balances[msg.sender] -= _value;            // Subtract from the sender
238         _totalSupply -= _value;                    // Updates totalSupply
239         emit Burn(msg.sender, _value);
240         return true;
241     }
242 
243     // ------------------------------------------------------------------------
244     // Destroy tokens from other account
245     // 
246     // Remove `_value` tokens from the system irreversibly on behalf of `_from`.
247     // 
248     // @param _from the address of the sender
249     // @param _value the amount of money to burn
250     // ------------------------------------------------------------------------
251     function burnFrom(address _from, uint256 _value) public returns (bool success) {
252         require(balances[_from] >= _value);               // Check if the targeted balance is enough
253         require(_value <= allowed[_from][msg.sender]);    // Check allowance
254         balances[_from] -= _value;                        // Subtract from the targeted balance
255         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
256         _totalSupply -= _value;                           // Update totalSupply
257         emit Burn(_from, _value);
258         return true;
259     }
260 
261     // ------------------------------------------------------------------------
262     // Owner can freeze an account
263     // ------------------------------------------------------------------------
264     function freezeAccount(address target, bool freeze) public onlyOwner returns (bool success) {
265         frozenAccount[target] = freeze;
266         emit FrozenFunds(target, freeze);
267         return true;
268     }
269 }