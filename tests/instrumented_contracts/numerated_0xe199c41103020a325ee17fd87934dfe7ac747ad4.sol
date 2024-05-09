1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // FWD 'BitFwd' token contract
5 //
6 // FWD tokens are mintable by the owner until the `disableMinting()` function
7 // is executed. Tokens can be burnt by sending them to address 0x0
8 //
9 // Deployed to : 0xe199C41103020a325Ee17Fd87934dfe7Ac747AD4
10 // Symbol      : FWD
11 // Name        : BitFwd
12 // Total supply: mintable
13 // Decimals    : 18
14 //
15 // http://www.bitfwd.xyz
16 // https://github.com/bokkypoobah/Tokens/blob/master/contracts/BitFwdToken.sol
17 //
18 // Enjoy.
19 //
20 // (c) BokkyPooBah / Bok Consulting Pty Ltd for BitFwd 2017. The MIT Licence.
21 // ----------------------------------------------------------------------------
22 
23 
24 // ----------------------------------------------------------------------------
25 // Safe maths
26 // ----------------------------------------------------------------------------
27 library SafeMath {
28     function add(uint a, uint b) public pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32     function sub(uint a, uint b) public pure returns (uint c) {
33         require(b <= a);
34         c = a - b;
35     }
36     function mul(uint a, uint b) public pure returns (uint c) {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40     function div(uint a, uint b) public pure returns (uint c) {
41         require(b > 0);
42         c = a / b;
43     }
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
50 // ----------------------------------------------------------------------------
51 contract ERC20Interface {
52     function totalSupply() public constant returns (uint);
53     function balanceOf(address tokenOwner) public constant returns (uint balance);
54     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
55     function transfer(address to, uint tokens) public returns (bool success);
56     function approve(address spender, uint tokens) public returns (bool success);
57     function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Contract function to receive approval and execute function in one call
66 //
67 // Borrowed from MiniMeToken
68 // ----------------------------------------------------------------------------
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Owned contract
76 // ----------------------------------------------------------------------------
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     function Owned() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95 
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98         OwnershipTransferred(owner, newOwner);
99         owner = newOwner;
100         newOwner = address(0);
101     }
102 }
103 
104 
105 // ----------------------------------------------------------------------------
106 // ERC20 Token, with the addition of symbol, name and decimals and assisted
107 // token transfers
108 // ----------------------------------------------------------------------------
109 contract BitFwdToken is ERC20Interface, Owned {
110     using SafeMath for uint;
111 
112     string public symbol;
113     string public  name;
114     uint8 public decimals;
115     uint public _totalSupply;
116     bool public mintable;
117 
118     mapping(address => uint) balances;
119     mapping(address => mapping(address => uint)) allowed;
120 
121     event MintingDisabled();
122 
123 
124     // ------------------------------------------------------------------------
125     // Constructor
126     // ------------------------------------------------------------------------
127     function BitFwdToken() public {
128         symbol = "FWD";
129         name = "BitFwd Token";
130         decimals = 18;
131         mintable = true;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public constant returns (uint) {
139         return _totalSupply  - balances[address(0)];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Disable minting
145     // ------------------------------------------------------------------------
146     function disableMinting() public onlyOwner {
147         require(mintable);
148         mintable = false;
149         MintingDisabled();
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Get the token balance for account `tokenOwner`
155     // ------------------------------------------------------------------------
156     function balanceOf(address tokenOwner) public constant returns (uint balance) {
157         return balances[tokenOwner];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer the balance from token owner's account to `to` account
163     // - Owner's account must have sufficient balance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transfer(address to, uint tokens) public returns (bool success) {
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         Transfer(msg.sender, to, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     //
178     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
179     // recommends that there are no checks for the approval double-spend attack
180     // as this should be implemented in user interfaces 
181     // ------------------------------------------------------------------------
182     function approve(address spender, uint tokens) public returns (bool success) {
183         allowed[msg.sender][spender] = tokens;
184         Approval(msg.sender, spender, tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Transfer `tokens` from the `from` account to the `to` account
191     // 
192     // The calling account must already have sufficient tokens approve(...)-d
193     // for spending from the `from` account and
194     // - From account must have sufficient balance to transfer
195     // - Spender must have sufficient allowance to transfer
196     // - 0 value transfers are allowed
197     // ------------------------------------------------------------------------
198     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
199         balances[from] = balances[from].sub(tokens);
200         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
201         balances[to] = balances[to].add(tokens);
202         Transfer(from, to, tokens);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Returns the amount of tokens approved by the owner that can be
209     // transferred to the spender's account
210     // ------------------------------------------------------------------------
211     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
212         return allowed[tokenOwner][spender];
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Token owner can approve for `spender` to transferFrom(...) `tokens`
218     // from the token owner's account. The `spender` contract function
219     // `receiveApproval(...)` is then executed
220     // ------------------------------------------------------------------------
221     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
222         allowed[msg.sender][spender] = tokens;
223         Approval(msg.sender, spender, tokens);
224         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
225         return true;
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Mint tokens
231     // ------------------------------------------------------------------------
232     function mint(address tokenOwner, uint tokens) public onlyOwner returns (bool success) {
233         require(mintable);
234         balances[tokenOwner] = balances[tokenOwner].add(tokens);
235         _totalSupply = _totalSupply.add(tokens);
236         Transfer(address(0), tokenOwner, tokens);
237         return true;
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Don't accept ethers
243     // ------------------------------------------------------------------------
244     function () public payable {
245         revert();
246     }
247 
248 
249     // ------------------------------------------------------------------------
250     // Owner can transfer out any accidentally sent ERC20 tokens
251     // ------------------------------------------------------------------------
252     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
253         return ERC20Interface(tokenAddress).transfer(owner, tokens);
254     }
255 }