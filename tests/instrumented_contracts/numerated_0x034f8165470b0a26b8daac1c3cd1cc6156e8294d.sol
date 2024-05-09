1 pragma solidity >=0.5.4 <0.6.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'ERCT' 'Eracoin Token' token contract
5 //
6 // Symbol      : ERCT
7 // Name        : Eracoin Token
8 // Total supply: 300,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public view returns (uint);
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     function burn(uint256 value) public returns (bool success);
50     function burnFrom(address from, uint256 value) public returns (bool success);
51     
52     function mint(address recipient, uint256 value) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56     event Burn(address indexed from, uint256 value);
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Contract function to receive approval and execute function in one call
62 //
63 // Borrowed from MiniMeToken
64 // ----------------------------------------------------------------------------
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // Owned contract
72 // ----------------------------------------------------------------------------
73 contract Owned {
74     address public owner;
75     address public newOwner;
76 
77     event OwnershipTransferred(address indexed _from, address indexed _to);
78 
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function transferOwnership(address _newOwner) public onlyOwner {
89         newOwner = _newOwner;
90     }
91     function acceptOwnership() public {
92         require(msg.sender == newOwner);
93         emit OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95         newOwner = address(0);
96     }
97 }
98 
99 
100 // ----------------------------------------------------------------------------
101 // ERC20 Token, with the addition of symbol, name and decimals and a
102 // fixed supply
103 // ----------------------------------------------------------------------------
104 contract EracoinToken is ERC20Interface, Owned {
105     using SafeMath for uint;
106 
107     string public symbol;
108     string public  name;
109     uint8 public decimals;
110     uint _totalSupply;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114     
115     event Transfer(address indexed from, address indexed to, uint tokens);
116     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
117     event Burn(address indexed from, uint256 tokens);
118 
119 
120     // ------------------------------------------------------------------------
121     // Constructor
122     // ------------------------------------------------------------------------
123     constructor() public {
124         symbol = "ERCT";
125         name = "Eracoin Token";
126         decimals = 18;
127         _totalSupply = 300000000 * 10**uint(decimals);
128         balances[owner] = _totalSupply;
129         emit Transfer(address(0), owner, _totalSupply);
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public view returns (uint) {
137         return _totalSupply.sub(balances[address(0)]);
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account `tokenOwner`
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public view returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to `to` account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transfer(address to, uint tokens) public returns (bool success) {
155         balances[msg.sender] = balances[msg.sender].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157         emit Transfer(msg.sender, to, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         emit Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer `tokens` from the `from` account to the `to` account
179     //
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the `from` account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
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
216     /**
217      * Destroy tokens
218      *
219      * Remove `_value` tokens from the system irreversibly
220      *
221      * @param _value the amount of money to burn
222      */
223     function burn(uint256 _value) public returns (bool success) {
224         require(balances[msg.sender] >= _value);   // Check if the sender has enough
225         balances[msg.sender] -= _value;            // Subtract from the sender
226         _totalSupply -= _value;                      // Updates totalSupply
227         emit Burn(msg.sender, _value);
228         return true;
229     }
230 
231     /**
232      * Destroy tokens from other account
233      *
234      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
235      *
236      * @param _from the address of the sender
237      * @param _value the amount of money to burn
238      */
239     function burnFrom(address _from, uint256 _value) public returns (bool success) {
240         require(balances[_from] >= _value);                // Check if the targeted balance is enough
241         require(_value <= allowed[_from][msg.sender]);    // Check allowance
242         balances[_from] -= _value;                         // Subtract from the targeted balance
243         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
244         _totalSupply -= _value;                              // Update totalSupply
245         emit Burn(_from, _value);
246         return true;
247     }
248     
249     /**
250      * This increases the total token supply and grants ownership of the new tokens to the specified recipient:
251      *
252      *
253      * @param _recipient the address of the recipient
254      * @param _value the amount of money to mint
255      */
256     function mint(address _recipient, uint256 _value) public returns (bool success) {
257         require(msg.sender == owner);
258         require(_totalSupply + _value >= _totalSupply); // Overflow check
259     
260         _totalSupply += _value;
261         balances[_recipient] += _value;
262         emit Transfer(address(0), _recipient, _value);
263         return true;
264     }
265 
266     // ------------------------------------------------------------------------
267     // Don't accept ETH
268     // ------------------------------------------------------------------------
269     function () external payable {
270         revert();
271     }
272 
273 
274     // ------------------------------------------------------------------------
275     // Owner can transfer out any accidentally sent ERC20 tokens
276     // ------------------------------------------------------------------------
277     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
278         return ERC20Interface(tokenAddress).transfer(owner, tokens);
279     }
280 }