1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'ETU' token contract
5 //
6 // Deployed to : 0xfb58a9af395755a4e95805d76bae231feb01a192
7 // Symbol      : ETU
8 // Name        : Ethereum Union
9 // Total supply: 12500000000000
10 // Decimals    : 5
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52     function burn(uint256 _value) public returns (bool success);
53     function burnFrom(address _from, uint256 _value) public returns (bool success);
54     function increaseSupply(uint value, address to) public returns (bool success);
55     function decreaseSupply(uint value, address from) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59     event Burn(address indexed from, uint tokens);
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Contract function to receive approval and execute function in one call
65 //
66 // Borrowed from MiniMeToken
67 // ----------------------------------------------------------------------------
68 contract ApproveAndCallFallBack {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // Owned contract
75 // ----------------------------------------------------------------------------
76 contract Owned {
77     address public owner;
78     address public newOwner;
79 
80     event OwnershipTransferred(address indexed _from, address indexed _to);
81 
82     function Owned() public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address _newOwner) public onlyOwner {
92         newOwner = _newOwner;
93     }
94     function acceptOwnership() public {
95         require(msg.sender == newOwner);
96         OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98         newOwner = address(0);
99     }
100 }
101 
102 
103 // ----------------------------------------------------------------------------
104 // ERC20 Token, with the addition of symbol, name and decimals and assisted
105 // token transfers
106 // ----------------------------------------------------------------------------
107 contract EthereumUnionToken is ERC20Interface, Owned, SafeMath {
108     string public symbol;
109     string public  name;
110     uint8 public decimals;
111     uint public _totalSupply;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     function EthereumUnionToken() public {
121         symbol = "ETU";
122         name = "Ethereum Union";
123         decimals = 5;
124         _totalSupply = 12500000000000;
125         balances[0xfb58a9af395755a4e95805d76bae231feb01a192] = _totalSupply;
126         emit Transfer(address(0), 0xfb58a9af395755a4e95805d76bae231feb01a192, _totalSupply);
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Total supply
132     // ------------------------------------------------------------------------
133     function totalSupply() public constant returns (uint) {
134         return _totalSupply  - balances[address(0)];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account tokenOwner
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public constant returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to to account
148     // - Owner's account must have sufficient balance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transfer(address to, uint tokens) public returns (bool success) {
152         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
153         balances[to] = safeAdd(balances[to], tokens);
154         emit Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for spender to transferFrom(...) tokens
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces 
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint tokens) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer tokens from the from account to the to account
176     // 
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the from account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         balances[from] = safeSub(balances[from], tokens);
185         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
186         balances[to] = safeAdd(balances[to], tokens);
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
229     /**
230      * Destroy tokens
231      *
232      * Remove `_value` tokens from the system irreversibly
233      *
234      * @param _value the amount of money to burn
235      */
236     function burn(uint256 _value) public returns (bool success) {
237         require(balances[msg.sender] >= _value);   // Check if the sender has enough
238         balances[msg.sender] -= _value;            // Subtract from the sender
239         _totalSupply -= _value;                      // Updates totalSupply
240         emit Burn(msg.sender, _value);
241         return true;
242     }
243 
244     /**
245      * Destroy tokens from other account
246      *
247      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
248      *
249      * @param _from the address of the sender
250      * @param _value the amount of money to burn
251      */
252     function burnFrom(address _from, uint256 _value) public returns (bool success) {
253         require(balances[_from] >= _value);                // Check if the targeted balance is enough
254         require(_value <= allowed[_from][msg.sender]);    // Check allowance
255         balances[_from] -= _value;                         // Subtract from the targeted balance
256         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
257         _totalSupply -= _value;                              // Update totalSupply
258         emit Burn(_from, _value);
259         return true;
260     }
261 
262     function increaseSupply(uint value, address to) public returns (bool success) {
263         _totalSupply = safeAdd(_totalSupply, value);
264         balances[to] = safeAdd(balances[to], value);
265         emit Transfer(0, to, value);
266         return true;
267     }
268 
269     function decreaseSupply(uint value, address from) public returns (bool success) {
270         balances[from] = safeSub(balances[from], value);
271         _totalSupply = safeSub(_totalSupply, value);  
272         emit Transfer(from, 0, value);
273         return true;
274     }
275 }