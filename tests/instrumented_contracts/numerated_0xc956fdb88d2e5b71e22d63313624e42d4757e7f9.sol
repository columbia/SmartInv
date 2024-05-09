1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'APEc' 'ApeCash Coin' token contract
5 //
6 // Symbol      : APEc
7 // Name        : ApeCash Coin
8 // Total supply: 250,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Save Primates.
12 //
13 // (c) The ApeCash Project. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (_a == 0) {
34       return 0;
35     }
36 
37     c = _a * _b;
38     assert(c / _a == _b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // assert(_b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = _a / _b;
48     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
49     return _a / _b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     assert(_b <= _a);
57     return _a - _b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
64     c = _a + _b;
65     assert(c >= _a);
66     return c;
67   }
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // ERC Token Standard #20 Interface
73 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
74 // ----------------------------------------------------------------------------
75 contract ERC20Interface {
76     function totalSupply() public view returns (uint);
77     function balanceOf(address tokenOwner) public view returns (uint balance);
78     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
79     function transfer(address to, uint tokens) public returns (bool success);
80     function approve(address spender, uint tokens) public returns (bool success);
81     function transferFrom(address from, address to, uint tokens) public returns (bool success);
82 
83     event Transfer(address indexed from, address indexed to, uint tokens);
84     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // Contract function to receive approval and execute function in one call
90 //
91 // Borrowed from MiniMeToken
92 // ----------------------------------------------------------------------------
93 contract ApproveAndCallFallBack {
94     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // Owned contract
100 // ----------------------------------------------------------------------------
101 contract Owned {
102     address public owner;
103     address public newOwner;
104 
105     event OwnershipTransferred(address indexed _from, address indexed _to);
106 
107     constructor() public {
108         owner = msg.sender;
109     }
110 
111     modifier onlyOwner {
112         require(msg.sender == owner);
113         _;
114     }
115 
116     function transferOwnership(address _newOwner) public onlyOwner {
117         newOwner = _newOwner;
118     }
119     function acceptOwnership() public {
120         require(msg.sender == newOwner);
121         emit OwnershipTransferred(owner, newOwner);
122         owner = newOwner;
123         newOwner = address(0);
124     }
125 }
126 
127 
128 // ----------------------------------------------------------------------------
129 // ERC20 Token, with the addition of symbol, name and decimals and a
130 // fixed supply
131 // ----------------------------------------------------------------------------
132 contract apeCashCoin is ERC20Interface, Owned {
133     using SafeMath for uint;
134 
135     string public symbol;
136     string public name;
137     uint8 public decimals;
138     uint public _totalSupply = 250000000000000000000000000;
139 
140     mapping(address => uint) balances;
141     mapping(address => mapping(address => uint)) allowed;
142 
143 
144     // ------------------------------------------------------------------------
145     // Constructor
146     // ------------------------------------------------------------------------
147     constructor() public payable {
148         symbol = "APEc";
149         name = "ApeCash Coin";
150         decimals = 18;
151         _totalSupply = 250000000000000000000000000;
152         balances[owner] = _totalSupply;
153         emit Transfer(address(0), owner, _totalSupply);
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Total supply
159     // ------------------------------------------------------------------------
160     function totalSupply() public view returns (uint) {
161         return _totalSupply.sub(balances[address(0)]);
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Get the token balance for account `tokenOwner`
167     // ------------------------------------------------------------------------
168     function balanceOf(address tokenOwner) public view returns (uint balance) {
169         return balances[tokenOwner];
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer the balance from token owner's account to `to` account
175     // - Owner's account must have sufficient balance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transfer(address to, uint tokens) public returns (bool success) {
179         balances[msg.sender] = balances[msg.sender].sub(tokens);
180         balances[to] = balances[to].add(tokens);
181         emit Transfer(msg.sender, to, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for `spender` to transferFrom(...) `tokens`
188     // from the token owner's account
189     //
190     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
191     // recommends that there are no checks for the approval double-spend attack
192     // as this should be implemented in user interfaces 
193     // ------------------------------------------------------------------------
194     function approve(address spender, uint tokens) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         emit Approval(msg.sender, spender, tokens);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Transfer `tokens` from the `from` account to the `to` account
203     // 
204     // The calling account must already have sufficient tokens approve(...)-d
205     // for spending from the `from` account and
206     // - From account must have sufficient balance to transfer
207     // - Spender must have sufficient allowance to transfer
208     // - 0 value transfers are allowed
209     // ------------------------------------------------------------------------
210     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
211         balances[from] = balances[from].sub(tokens);
212         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
213         balances[to] = balances[to].add(tokens);
214         emit Transfer(from, to, tokens);
215         return true;
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Returns the amount of tokens approved by the owner that can be
221     // transferred to the spender's account
222     // ------------------------------------------------------------------------
223     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
224         return allowed[tokenOwner][spender];
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Token owner can approve for `spender` to transferFrom(...) `tokens`
230     // from the token owner's account. The `spender` contract function
231     // `receiveApproval(...)` is then executed
232     // ------------------------------------------------------------------------
233     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
234         allowed[msg.sender][spender] = tokens;
235         emit Approval(msg.sender, spender, tokens);
236         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
237         return true;
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Don't accept ETH
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