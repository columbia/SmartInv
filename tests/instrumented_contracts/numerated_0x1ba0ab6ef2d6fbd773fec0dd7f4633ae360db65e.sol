1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Contract function to receive approval and execute function in one call
6 //
7 // Borrowed from MiniMeToken
8 // ----------------------------------------------------------------------------
9 contract ApproveAndCallFallBack {
10   function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
11 }
12 
13 
14 // ----------------------------------------------------------------------------
15 // ERC Token Standard #20 Interface
16 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
17 // ----------------------------------------------------------------------------
18 contract ERC20Interface {
19   function totalSupply() public view returns (uint);
20   function balanceOf(address tokenOwner) public view returns (uint balance);
21   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
22   function transfer(address to, uint tokens) public returns (bool success);
23   function approve(address spender, uint tokens) public returns (bool success);
24   function transferFrom(address from, address to, uint tokens) public returns (bool success);
25 
26   event Transfer(address indexed from, address indexed to, uint tokens);
27   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // Owned contract
33 // ----------------------------------------------------------------------------
34 contract Owned {
35   address public owner;
36   address public newOwner;
37 
38   event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   modifier onlyNewOwner {
50     require(msg.sender == newOwner);
51     _;
52   }
53 
54   function transferOwnership(address _newOwner) public onlyOwner {
55     newOwner = _newOwner;
56   }
57 
58   function acceptOwnership() public onlyNewOwner {
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61     newOwner = address(0);
62   }
63 
64   function disown() public onlyOwner {
65     owner = address(0);
66     newOwner = msg.sender;
67     emit OwnershipTransferred(msg.sender, address(0));
68   }
69 
70   function rejectOwnership() public onlyNewOwner {
71     newOwner = address(0);
72   }
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 //
78 // Symbol      : Chowe
79 // Name        : Chowe Fermi-Dirac Token
80 // Total supply: 1
81 // Decimals    : 0
82 //
83 // Share. Enjoy.
84 //
85 // (c) by Chris Howe 2018. The MIT Licence.
86 // ----------------------------------------------------------------------------
87 
88 
89 
90 
91 
92 
93 // ----------------------------------------------------------------------------
94 // ERC20 Token, with the addition of symbol, name and decimals and assisted
95 // token transfers
96 // ----------------------------------------------------------------------------
97 contract ChoweToken is ERC20Interface, Owned {
98   string public symbol;
99   string public  name;
100   uint8 public decimals;
101   uint public _totalSupply;
102 
103   mapping(address => uint) balances;
104   mapping(address => mapping(address => uint)) allowed;
105 
106   // ------------------------------------------------------------------------
107   // Constructor
108   // ------------------------------------------------------------------------
109   constructor() public {
110     symbol = "Chowe";
111     name = "Chowe Fermi-Dirac Token";
112     decimals = 0;
113     _totalSupply = 1;
114     balances[msg.sender] = 1;
115     balances[address(0)] = 0;
116     emit Transfer(address(0), msg.sender, _totalSupply);
117   }
118 
119 
120   // ------------------------------------------------------------------------
121   // Total supply
122   // ------------------------------------------------------------------------
123   function totalSupply() public view returns (uint) {
124     return _totalSupply;
125   }
126 
127 
128   // ------------------------------------------------------------------------
129   // Get the token balance for account tokenOwner
130   // ------------------------------------------------------------------------
131   function balanceOf(address tokenOwner) public view returns (uint balance) {
132     return balances[tokenOwner];
133   }
134 
135 
136   // ------------------------------------------------------------------------
137   // Transfer the balance from token owner's account to to account
138   // - Owner's account must have sufficient balance to transfer
139   // - 0 value transfers are allowed
140   // ------------------------------------------------------------------------
141   function transfer(address to, uint tokens) public returns (bool success) {
142     require(balances[to]==0 && tokens==1);
143 
144     if (msg.sender != owner) {
145       require(balances[msg.sender] > 0);
146       balances[msg.sender] = balances[msg.sender] - 1;
147     } else {
148       _totalSupply = _totalSupply + 1;
149     }
150 
151     if (to != address(0)) {
152       balances[to] = 1;
153     } else {
154       _totalSupply = _totalSupply-1;
155     }
156 
157     emit Transfer(msg.sender, to, 1);
158     return true;
159   }
160 
161   // ------------------------------------------------------------------------
162   // Token owner can approve for spender to transferFrom(...) tokens
163   // from the token owner's account
164   //
165   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166   // recommends that there are no checks for the approval double-spend attack
167   // as this should be implemented in user interfaces 
168   // ------------------------------------------------------------------------
169   function approve(address spender, uint tokens) public returns (bool success) {
170     allowed[msg.sender][spender] = tokens;
171     emit Approval(msg.sender, spender, tokens);
172     return true;
173   }
174 
175 
176   // ------------------------------------------------------------------------
177   // Transfer tokens from the from account to the to account
178   // ------------------------------------------------------------------------
179   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180     require(balances[to]==0 && tokens==1);
181 
182     if (from != owner) {
183       require(balances[from]>0);
184       balances[from] = balances[from] - 1;
185     } else {
186       _totalSupply = _totalSupply + 1;
187     }
188       
189     require(allowed[from][msg.sender]>0);
190     allowed[from][msg.sender] = allowed[from][msg.sender] - 1;
191 
192     if (to != address(0)) {
193       balances[to] = 1;
194     } else {
195       _totalSupply = _totalSupply + 1;
196     }
197 
198     emit Transfer(from, to, 1);
199     return true;
200   }
201   
202   // ------------------------------------------------------------------------
203   // This override of the Owned contract ensures that the new owner of the 
204   // contract has a token
205   // ------------------------------------------------------------------------
206   
207   function acceptOwnership() public {
208     address oldOwner = owner;
209     super.acceptOwnership();
210     
211     // The owner MUST have a token, so create one if needed
212     if( balances[msg.sender] == 0) {
213       balances[msg.sender] = 1;
214       _totalSupply = _totalSupply + 1;
215       emit Transfer(oldOwner, msg.sender, 1);
216     }
217   }
218 
219   // ------------------------------------------------------------------------
220   // Returns the amount of tokens approved by the owner that can be
221   // transferred to the spender's account
222   // ------------------------------------------------------------------------
223   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
224     return allowed[tokenOwner][spender];
225   }
226 
227   // ------------------------------------------------------------------------
228   // Token owner can approve for spender to transferFrom(...) tokens
229   // from the token owner's account. The spender contract function
230   // receiveApproval(...) is then executed
231   // ------------------------------------------------------------------------
232   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
233     allowed[msg.sender][spender] = tokens;
234     emit Approval(msg.sender, spender, tokens);
235     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
236     return true;
237   }
238 
239   // ------------------------------------------------------------------------
240   // Don't accept ETH
241   // ------------------------------------------------------------------------
242   function () public payable {
243     revert();
244   }
245 
246   // ------------------------------------------------------------------------
247   // Owner can transfer out any accidentally sent ERC20 tokens
248   // ------------------------------------------------------------------------
249   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250     return ERC20Interface(tokenAddress).transfer(owner, tokens);
251   }
252 }