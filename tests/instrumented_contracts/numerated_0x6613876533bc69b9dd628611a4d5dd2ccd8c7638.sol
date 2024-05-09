1 pragma solidity ^0.5.0;
2 
3 // library that we use in this contract for valuation
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         assert(b > 0); 
12         uint256 c = a / b;
13         assert(a == b * c + a % b); 
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 // interface of your Customize token
28 interface ToqqnInterface {
29     
30     function totalSupply() external view returns (uint);
31     function balanceOf(address tokenOwner) external view returns (uint balance);
32     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
33     function transfer(address to, uint tokens) external returns (bool success);
34     function approve(address spender, uint tokens) external returns (bool success);
35     function transferFrom(address from, address to, uint tokens) external returns (bool success);
36     
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 }
41 // ----------------------------------------------------------------------------
42 // Contract function to receive approval and execute function in one call
43 //
44 // Borrowed from MiniMeToken
45 // ----------------------------------------------------------------------------
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
48 }
49 
50 // ----------------------------------------------------------------------------
51 // ERC20 Token, with the addition of symbol, name and decimals and assisted
52 // token transfers
53 // ----------------------------------------------------------------------------
54 contract Toqqn is ToqqnInterface {
55     using SafeMath for uint256;
56 
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint256 internal _totalSupply;
61     
62     address owner;
63     
64     mapping(address => uint256) balances;
65     mapping(address => mapping(address => uint256)) allowed;
66 
67     // functions with this modifier can only be executed by the owner
68     modifier onlyOwner() {
69         if (msg.sender != owner) {
70             revert();
71         }
72          _;
73     }
74 	
75     // ------------------------------------------------------------------------
76     // Constructor
77     // ------------------------------------------------------------------------
78     constructor() public {
79         symbol = "TQN";
80         name = "Toqqn";
81         decimals = 18;
82         owner = msg.sender;
83         _totalSupply = 1000000000 * 10**uint(decimals); //1 billion
84         balances[owner] = _totalSupply;
85 		emit Transfer(address(0),owner,_totalSupply);
86     }
87 
88     
89 
90     // ------------------------------------------------------------------------
91     // Total supply
92     // ------------------------------------------------------------------------
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply.sub(balances[address(0)]);
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // The balanceOf() function provides the number of tokens held by a given address.
100     // ------------------------------------------------------------------------
101     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
102         return balances[tokenOwner];
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Transfer the balance from token owner's account to `to` account
108     // - Owner's account must have sufficient balance to transfer
109     // - 0 value transfers are allowed
110     // ------------------------------------------------------------------------
111     function transfer(address to, uint256 tokens) public returns (bool success) {
112         balances[msg.sender] = balances[msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Token owner can approve for `spender` to transferFrom(...) `tokens`
121     // from the token owner's account
122     //
123     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
124     // recommends that there are no checks for the approval double-spend attack
125     // as this should be implemented in user interfaces
126     // ------------------------------------------------------------------------
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer `tokens` from the `from` account to the `to` account
136     //
137     // The calling account must already have sufficient tokens approve(...)-d
138     // for spending from the `from` account and
139     // - From account must have sufficient balance to transfer
140     // - Spender must have sufficient allowance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
144         balances[from] = balances[from].sub(tokens);
145         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
146         balances[to] = balances[to].add(tokens);
147         emit Transfer(from, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Returns the amount of tokens approved by the owner that can be
154     // transferred to the spender's account
155     // ------------------------------------------------------------------------
156     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
157         return allowed[tokenOwner][spender];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account. The `spender` contract function
164     // `receiveApproval(...)` is then executed
165     // ------------------------------------------------------------------------
166     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
170         return true;
171     }
172 
173     // ------------------------------------------------------------------------
174     // Don't Accept ETH
175     // ------------------------------------------------------------------------
176     function () external payable {
177         revert();
178     }
179     
180     // ------------------------------------------------------------------------
181     // Owner can transfer out any accidentally sent Toqqns
182     // ------------------------------------------------------------------------
183     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
184         return ToqqnInterface(tokenAddress).transfer(owner, tokens);
185     }
186     
187     // ------------------------------------------------------------------------
188     // Owner can transfer out any accidentally sent Toqqns
189     // ------------------------------------------------------------------------
190     function transferReserveToken(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
191         return this.transferFrom(owner,tokenAddress, tokens);
192     }
193     
194 }