1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : TRN
6 // Name        : Treelion
7 // Total supply: 1,000,000,000.000000000000000000
8 // Decimals    : 18
9 //
10 // Borrowed and Edited from
11 //
12 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public view returns (uint);
45     function balanceOf(address tokenOwner) public view returns (uint balance);
46     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53     event Burn(address indexed tokenOwner, uint tokens);
54     event FrozenFunds(address indexed target, bool freeze);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and a
100 // 
101 // ----------------------------------------------------------------------------
102 contract Treelion is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112     mapping(address => bool) public frozenAccount;
113  
114  
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor() public {
119         symbol = "TRN";
120         name = "Treelion";
121         decimals = 18;
122         _totalSupply = 1000000000 * 10**uint(decimals);
123         balances[owner] = _totalSupply;
124         emit Transfer(address(0), owner, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public view returns (uint) {
132         return _totalSupply.sub(balances[address(0)]);
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public view returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         require(!frozenAccount[msg.sender]);
151         require(!frozenAccount[to]);
152         balances[msg.sender] = balances[msg.sender].sub(tokens);
153         balances[to] = balances[to].add(tokens);
154         emit Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for `spender` to transferFrom(...) `tokens`
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
175     // Transfer `tokens` from the `from` account to the `to` account
176     //
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the `from` account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         require(!frozenAccount[from]);
185         require(!frozenAccount[to]);
186         require(!frozenAccount[msg.sender]);
187         balances[from] = balances[from].sub(tokens);
188         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
189         balances[to] = balances[to].add(tokens);
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
205     // Token owner can approve for `spender` to transferFrom(...) `tokens`
206     // from the token owner's account. The `spender` contract function
207     // `receiveApproval(...)` is then executed
208     // ------------------------------------------------------------------------
209     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         emit Approval(msg.sender, spender, tokens);
212         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Don't accept ETH
219     // ------------------------------------------------------------------------
220     function () external payable {
221         revert();
222     }
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230     
231     // ------------------------------------------------------------------------
232     // Burn
233     // ------------------------------------------------------------------------
234     function burn(uint value)public returns(bool success){
235         require(balances[msg.sender]>=value);
236     
237         balances[msg.sender]=balances[msg.sender].sub(value);
238         _totalSupply=_totalSupply.sub(value);
239         emit Burn(msg.sender,value);
240         return true;
241         
242     }
243     
244 
245     function burnFrom(address from, uint value)public returns(bool success){
246         require(balances[from]>=value);
247         require(allowed[from][msg.sender] >= value);
248         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
249         balances[from]=balances[from].sub(value);
250         _totalSupply=_totalSupply.sub(value);
251         emit Burn(from,value);
252         return true;
253         
254     }
255     
256     // ------------------------------------------------------------------------
257     // Freeze
258     // ------------------------------------------------------------------------
259     function freezeAccount(address target, bool freeze) onlyOwner public{
260         frozenAccount[target] = freeze;
261         emit FrozenFunds(target, freeze);
262     }
263 
264 }