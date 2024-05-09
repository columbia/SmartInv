1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8   function totalSupply() public constant returns (uint);
9   function balanceOf(address tokenOwner) public constant returns (uint balance);
10   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11   function transfer(address to, uint tokens) public returns (bool success);
12   function approve(address spender, uint tokens) public returns (bool success);
13   function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15   event Transfer(address indexed from, address indexed to, uint tokens);
16   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 contract SafeMath {
23   function safeAdd(uint a, uint b) public pure returns (uint c) {
24     c = a + b;
25     require(c >= a, "This addition will cause overflow!");
26   }
27 
28   function safeSub(uint a, uint b) public pure returns (uint c) {
29     require(b <= a, "This substraction will cause unsigned integer underflow!");
30     c = a - b;
31   }
32 
33   function safeMul(uint a, uint b) public pure returns (uint c) {
34     c = a * b;
35     require(a == 0 || c / a == b, "This multiplication will cause overflow!");
36   }
37   
38   function safeDiv(uint a, uint b) public pure returns (uint c) {
39     require(b > 0, "Negative divisor or division by zero!");
40     c = a / b;
41   }
42 }
43 
44 
45 
46 // ----------------------------------------------------------------------------
47 // Owned contract
48 // ----------------------------------------------------------------------------
49 contract Owned {
50   address public owner;
51   address public newOwner;
52 
53   event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55   constructor() public {
56     owner = msg.sender;
57   }
58 
59   modifier onlyOwner {
60     require(msg.sender == owner, "Sender is not the owner!");
61     _;
62   }
63 
64   function transferOwnership(address _newOwner) public onlyOwner {
65     newOwner = _newOwner;
66   }
67   
68   function acceptOwnership() public {
69     require(msg.sender == newOwner, "Sender is not the new owner!");
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72     newOwner = address(0);
73   }
74 }
75 
76 
77 
78 // ----------------------------------------------------------------------------
79 // 'HAPPY' token contract
80 //
81 // Deployed to : HappyTeamWallet
82 // Symbol      : HPT
83 // Name        : Happy Token
84 // Total supply: 1000000000
85 // Decimals    : 18
86 // ----------------------------------------------------------------------------
87 
88 
89 // ----------------------------------------------------------------------------
90 // Contract function to receive approval and execute function in one call
91 // ----------------------------------------------------------------------------
92 contract ApproveAndCallFallBack {
93   function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract HappyToken is ERC20Interface, Owned, SafeMath {
102   address public happyTeamWallet;
103   string public symbol;
104   string public  name;
105   uint8 public decimals;
106   uint public _totalSupply;
107 
108   mapping(address => uint) balances;
109   mapping(address => mapping(address => uint)) allowed;
110 
111   // ------------------------------------------------------------------------
112   // Constructor
113   // ------------------------------------------------------------------------
114   constructor() public {
115     symbol = "HPT";
116     name = "Happy Token";
117     decimals = 18;
118     _totalSupply = 1000000000000000000000000000;
119     balances[msg.sender] = _totalSupply;
120     emit Transfer(address(0), happyTeamWallet, _totalSupply);
121   }
122 
123 
124   // ------------------------------------------------------------------------
125   // Total supply
126   // ------------------------------------------------------------------------
127   function totalSupply() public view returns (uint) {
128     return _totalSupply - balances[address(0)];
129   }
130 
131 
132   // ------------------------------------------------------------------------
133   // Get the token balance for account tokenOwner
134   // ------------------------------------------------------------------------
135   function balanceOf(address tokenOwner) public view returns (uint balance) {
136     return balances[tokenOwner];
137   }
138 
139 
140   // ------------------------------------------------------------------------
141   // Transfer the balance from token owner's account to to account
142   // - Owner's account must have sufficient balance to transfer
143   // - 0 value transfers are allowed
144   // ------------------------------------------------------------------------
145   function transfer(address to, uint tokens) public returns (bool success) {
146     balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147     balances[to] = safeAdd(balances[to], tokens);
148     emit Transfer(msg.sender, to, tokens);
149     return true;
150   }
151 
152 
153   // ------------------------------------------------------------------------
154   // Token owner can approve for spender to transferFrom(...) tokens
155   // from the token owner's account
156   //
157   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158   // recommends that there are no checks for the approval double-spend attack
159   // as this should be implemented in user interfaces 
160   // ------------------------------------------------------------------------
161   function approve(address spender, uint tokens) public returns (bool success) {
162     allowed[msg.sender][spender] = tokens;
163     emit Approval(msg.sender, spender, tokens);
164     return true;
165   }
166 
167 
168   // ------------------------------------------------------------------------
169   // Transfer tokens from the from account to the to account
170   // 
171   // The calling account must already have sufficient tokens approve(...)-d
172   // for spending from the from account and
173   // - From account must have sufficient balance to transfer
174   // - Spender must have sufficient allowance to transfer
175   // - 0 value transfers are allowed
176   // ------------------------------------------------------------------------
177   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178     balances[from] = safeSub(balances[from], tokens);
179     allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180     balances[to] = safeAdd(balances[to], tokens);
181     emit Transfer(from, to, tokens);
182     return true;
183   }
184 
185 
186   // ------------------------------------------------------------------------
187   // Returns the amount of tokens approved by the owner that can be
188   // transferred to the spender's account
189   // ------------------------------------------------------------------------
190   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
191     return allowed[tokenOwner][spender];
192   }
193 
194 
195   // ------------------------------------------------------------------------
196   // Token owner can approve for spender to transferFrom(...) tokens
197   // from the token owner's account. The spender contract function
198   // receiveApproval(...) is then executed
199   // ------------------------------------------------------------------------
200   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
201     allowed[msg.sender][spender] = tokens;
202     emit Approval(msg.sender, spender, tokens);
203     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
204     return true;
205   }
206 
207 
208   // ------------------------------------------------------------------------
209   // Don't accept ETH
210   // ------------------------------------------------------------------------
211   function () public payable {
212     revert();
213   }
214 
215 
216   // ------------------------------------------------------------------------
217   // Owner can transfer out any accidentally sent ERC20 tokens
218   // ------------------------------------------------------------------------
219   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
220     return ERC20Interface(tokenAddress).transfer(owner, tokens);
221   }
222 }