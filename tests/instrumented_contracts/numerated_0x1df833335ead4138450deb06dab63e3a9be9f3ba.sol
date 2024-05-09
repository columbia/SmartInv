1 pragma solidity ^0.5.13;
2 
3 // ----------------------------------------------------------------------------
4 // 'GFT' 'GasFarm' token contract
5 //
6 // Symbol      : GFT
7 // Deployed to : // TODO: 0x32ec729bc57ae046bd4590a892a4306d0ebf3bee
8 // Name        : GasFarm Token
9 // Total supply: 100,000,000.000000000000000000
10 // Decimals    : 18
11 //
12 //
13 //
14 // Updated by Guang Nguyen - GasFarm Ltd (c) 2021. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 library SafeMath {
22   function add(uint a, uint b) internal pure returns (uint c) {
23     c = a + b;
24     require(c >= a);
25   }
26   function sub(uint a, uint b) internal pure returns (uint c) {
27     require(b <= a);
28     c = a - b;
29   }
30   function mul(uint a, uint b) internal pure returns (uint c) {
31     c = a * b;
32     require(a == 0 || c / a == b);
33   }
34   function div(uint a, uint b) internal pure returns (uint c) {
35     require(b > 0);
36     c = a / b;
37   }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46   function totalSupply() public view returns (uint);
47   function balanceOf(address tokenOwner) public view returns (uint balance);
48   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
49   function transfer(address to, uint tokens) public returns (bool success);
50   function approve(address spender, uint tokens) public returns (bool success);
51   function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53   event Transfer(address indexed from, address indexed to, uint tokens);
54   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 //
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72 
73   address payable public owner;
74   address payable public newOwner;
75 
76   event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   modifier onlyOwner {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   function transferOwnership(address payable _newOwner) public onlyOwner {
88     newOwner = _newOwner;
89   }
90   function acceptOwnership() public {
91     require(msg.sender == newOwner);
92     emit OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94     newOwner = address(0);
95   }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and a
101 // GFT supply
102 // ----------------------------------------------------------------------------
103 contract GasFarmToken is ERC20Interface, Owned {
104 
105   using SafeMath for uint;
106 
107   string public symbol;
108   string public  name;
109   uint8 public decimals;
110   uint _totalSupply;
111 
112   // pre-sale bonus
113   uint public startDate;
114   uint public bonusEnds;
115   uint public endDate;
116 
117   mapping(address => uint) balances;
118   mapping(address => mapping(address => uint)) allowed;
119 
120 
121   // ------------------------------------------------------------------------
122   // Constructor
123   // ------------------------------------------------------------------------
124   constructor() public {
125     symbol = "GFT";
126     name = "GasFarm Token";
127     decimals = 18;
128     _totalSupply = 70000000 * 10**uint(decimals);
129     balances[owner] = _totalSupply;
130     bonusEnds = now + 32 days;
131     startDate = now + 15 days;
132     endDate = now + 32 days;
133     emit Transfer(address(0), owner, _totalSupply);
134   }
135 
136 
137   // ------------------------------------------------------------------------
138   // Total supply
139   // ------------------------------------------------------------------------
140   function totalSupply() public view returns (uint) {
141     return _totalSupply.sub(balances[address(0)]);
142   }
143 
144 
145   // ------------------------------------------------------------------------
146   // Get the token balance for account `tokenOwner`
147   // ------------------------------------------------------------------------
148   function balanceOf(address tokenOwner) public view returns (uint balance) {
149     return balances[tokenOwner];
150   }
151 
152 
153   // ------------------------------------------------------------------------
154   // Transfer the balance from token owner's account to `to` account
155   // - Owner's account must have sufficient balance to transfer
156   // - 0 value transfers are allowed
157   // ------------------------------------------------------------------------
158   function transfer(address to, uint tokens) public returns (bool success) {
159     balances[msg.sender] = balances[msg.sender].sub(tokens);
160     balances[to] = balances[to].add(tokens);
161     emit Transfer(msg.sender, to, tokens);
162     return true;
163   }
164 
165 
166   // ------------------------------------------------------------------------
167   // Token owner can approve for `spender` to transferFrom(...) `tokens`
168   // from the token owner's account
169   //
170   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
171   // recommends that there are no checks for the approval double-spend attack
172   // as this should be implemented in user interfaces
173   // ------------------------------------------------------------------------
174   function approve(address spender, uint tokens) public returns (bool success) {
175     allowed[msg.sender][spender] = tokens;
176     emit Approval(msg.sender, spender, tokens);
177     return true;
178   }
179 
180 
181   // ------------------------------------------------------------------------
182   // Transfer `tokens` from the `from` account to the `to` account
183   //
184   // The calling account must already have sufficient tokens approve(...)-d
185   // for spending from the `from` account and
186   // - From account must have sufficient balance to transfer
187   // - Spender must have sufficient allowance to transfer
188   // - 0 value transfers are allowed
189   // ------------------------------------------------------------------------
190   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
191     balances[from] = balances[from].sub(tokens);
192     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
193     balances[to] = balances[to].add(tokens);
194     emit Transfer(from, to, tokens);
195     return true;
196   }
197 
198 
199   // ------------------------------------------------------------------------
200   // Returns the amount of tokens approved by the owner that can be
201   // transferred to the spender's account
202   // ------------------------------------------------------------------------
203   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
204     return allowed[tokenOwner][spender];
205   }
206 
207 
208   // ------------------------------------------------------------------------
209   // Token owner can approve for `spender` to transferFrom(...) `tokens`
210   // from the token owner's account. The `spender` contract function
211   // `receiveApproval(...)` is then executed
212   // ------------------------------------------------------------------------
213   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
214     allowed[msg.sender][spender] = tokens;
215     emit Approval(msg.sender, spender, tokens);
216     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
217     return true;
218   }
219 
220   // ------------------------------------------------------------------------
221   // TODO: 26,000 GFT Tokens per 1 ETH 
222   // ------------------------------------------------------------------------
223   function () external payable {
224     require(now >= startDate && now <= endDate);
225     uint tokens;
226     if (now <= bonusEnds) {
227       tokens = msg.value * 26000; // TODO: define how many people will get within the BONUS.
228     } else {
229       tokens = msg.value * 26000; // TODO: define how many people will get without the BONUS.
230     }
231     balances[msg.sender] = SafeMath.add(balances[msg.sender], tokens);
232     _totalSupply = SafeMath.add(_totalSupply, tokens);
233     // sent to investor
234     emit Transfer(address(0), msg.sender, tokens);
235     // sent ETH to owner
236     owner.transfer(msg.value);
237   }
238 
239 
240   // ------------------------------------------------------------------------
241   // Owner can transfer out any accidentally sent ERC20 tokens
242   // ------------------------------------------------------------------------
243   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
244     return ERC20Interface(tokenAddress).transfer(owner, tokens);
245   }
246 }