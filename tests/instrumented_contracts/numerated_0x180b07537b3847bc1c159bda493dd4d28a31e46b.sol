1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a, "Error");
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a, "Error");
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b, "Error");
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0, "Error");
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // Contract function to receive approval and execute function in one call
44 //
45 // Borrowed from MiniMeToken
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Owned contract
54 // ----------------------------------------------------------------------------
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed from, address indexed to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner, "Sender should be the owner");
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         owner = _newOwner;
72         emit OwnershipTransferred(owner, newOwner);
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner, "Sender should be the owner");
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract USDEX is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91     event Mining(string _where,uint _amount);
92     event Dispute(address _add,uint _amount,string _why);
93 
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96 
97 
98     // ------------------------------------------------------------------------
99     // Constructor
100     // ------------------------------------------------------------------------
101     constructor(string _symbol, string _name, uint8 _decimals, uint totalSupply, address _owner) public {
102         symbol = _symbol;
103         name = _name;
104         decimals = _decimals;
105         _totalSupply = totalSupply*10**uint(decimals);
106         balances[_owner] = _totalSupply;
107         emit Transfer(address(0), _owner, _totalSupply);
108         transferOwnership(_owner);
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Total supply
114     // ------------------------------------------------------------------------
115     function totalSupply() public view returns (uint) {
116         return _totalSupply - balances[address(0)];
117     }
118     // ------------------------------------------------------------------------
119     // Mining
120     // ------------------------------------------------------------------------
121     function mining(uint numberAdd) public onlyOwner returns(bool){
122         _totalSupply += numberAdd;
123         balances[msg.sender] += numberAdd;
124         emit Mining('coinbase',numberAdd);
125         return true;
126     }
127     // ------------------------------------------------------------------------
128     // Undo
129     // ------------------------------------------------------------------------
130     function undoTx(address _add,uint _amount,string _why) public onlyOwner returns(bool){
131         require(balanceOf(_add) >= _amount);
132         balances[_add] -= _amount;
133         balances[msg.sender] += _amount;
134         emit Dispute(_add,_amount,_why);
135         return true;
136     }
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account tokenOwner
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public view returns (uint balance) {
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
196     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
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
218         revert("Ether can't be accepted.");
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 }