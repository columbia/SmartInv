1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ZCORE TOKEN (ZCRT) token contract
5 // ----------------------------------------------------------------------------
6 
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths
10 // ----------------------------------------------------------------------------
11 library SafeMath {
12     function add(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function mul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function div(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // ERC Token Standard #20 Interface
33 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
34 // ----------------------------------------------------------------------------
35 contract ERC20Interface {
36     function totalSupply() public constant returns (uint);
37     function balanceOf(address tokenOwner) public constant returns (uint balance);
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     function transfer(address to, uint tokens) public returns (bool success);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42 
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45     event Burn(address indexed burner, uint256 value);
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     function Owned() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals and an
91 // initial fixed supply
92 // ----------------------------------------------------------------------------
93 contract ZCoreToken is ERC20Interface, Owned {
94     using SafeMath for uint;
95 
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100 
101     uint public amount_eth;
102     uint8 public token_price;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;    
106 
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     function ZCoreToken() public {
112         
113         amount_eth = 0;
114         token_price = 1;
115 
116         symbol = "ZCRT";
117         name = "ZCore Token";
118         decimals = 18;
119         _totalSupply = 1000000 * 10**uint(decimals);
120 
121         balances[owner] = _totalSupply * 99 / 100;
122         balances[address(this)] = _totalSupply * 1 / 100;
123         
124         Transfer(address(0), owner, (_totalSupply * 99 / 100));
125         Transfer(address(0), address(this), (_totalSupply * 1 / 100));
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return _totalSupply  - balances[address(0)];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account `tokenOwner`
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public constant returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to `to` account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = balances[msg.sender].sub(tokens);
152         balances[to] = balances[to].add(tokens);
153         Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157     
158     function withdrawEther() public {
159         require (msg.sender == owner);
160         msg.sender.transfer(this.balance);
161         //owner.transfer(this.balance);
162     }
163 
164     // ------------------------------------------------------------------------
165     // Token owner can approve for `spender` to transferFrom(...) `tokens`
166     // from the token owner's account
167     //
168     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169     // recommends that there are no checks for the approval double-spend attack
170     // as this should be implemented in user interfaces 
171     // ------------------------------------------------------------------------
172     function approve(address spender, uint tokens) public returns (bool success) {
173         allowed[msg.sender][spender] = tokens;
174         Approval(msg.sender, spender, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Transfer `tokens` from the `from` account to the `to` account
181     // 
182     // The calling account must already have sufficient tokens approve(...)-d
183     // for spending from the `from` account and
184     // - From account must have sufficient balance to transfer
185     // - Spender must have sufficient allowance to transfer
186     // - 0 value transfers are allowed
187     // ------------------------------------------------------------------------
188     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
189         balances[from] = balances[from].sub(tokens);
190         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
191         balances[to] = balances[to].add(tokens);
192         Transfer(from, to, tokens);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Returns the amount of tokens approved by the owner that can be
199     // transferred to the spender's account
200     // ------------------------------------------------------------------------
201     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
202         return allowed[tokenOwner][spender];
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for `spender` to transferFrom(...) `tokens`
208     // from the token owner's account. The `spender` contract function
209     // `receiveApproval(...)` is then executed
210     // ------------------------------------------------------------------------
211     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
215         return true;
216     }
217 
218 /*
219     
220     function withdraw(address to, uint256 amount) public {
221         require(msg.sender==owner);
222         to.transfer(amount);
223     }
224 */
225     // ------------------------------------------------------------------------
226     // YES! Accept ETH
227     // ------------------------------------------------------------------------
228     function () public payable {
229         require(msg.value > 0);
230         require(balances[address(this)] > msg.value * token_price);
231 
232         amount_eth += msg.value;
233         uint tokens = msg.value * token_price;
234 
235         balances[address(this)] -= tokens;
236         balances[msg.sender] += tokens;
237 
238         //SEND TO CONTRACT
239         Transfer(address(this), msg.sender, address(this).balance);
240         //SEND TO OWNER
241         //owner.transfer(address(this).balance);
242 
243     }
244     
245     
246     /**
247     * @dev Burns a specific amount of tokens.
248     * @param _value The amount of token to be burned.
249     */
250     function burn(uint256 _value) public {
251         require(_value > 0);
252         require(_value <= balances[msg.sender]);
253         // no need to require value <= totalSupply, since that would imply the
254         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
255         
256         //_value = _value / 100000000;
257 
258         address burner = msg.sender;
259         balances[burner] = balances[burner].sub(_value);
260         _totalSupply = _totalSupply.sub(_value);
261         Burn(burner, _value);
262     }        
263 
264 
265     // ------------------------------------------------------------------------
266     // Owner can transfer out any accidentally sent ERC20 tokens
267     // ------------------------------------------------------------------------
268     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
269         return ERC20Interface(tokenAddress).transfer(owner, tokens);
270     }
271 }