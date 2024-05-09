1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-06
3 */
4 
5 pragma solidity "0.5.10";
6 
7 /* =========================================================================================================*/
8 // ----------------------------------------------------------------------------
9 // 'Inflationary' token contract
10 //
11 // Total supply: 500,000
12 // Decimals    : 18
13 // ----------------------------------------------------------------------------
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35     
36     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
37         uint256 c = add(a,m);
38         uint256 d = sub(c,1);
39         return div(mul(d,m),m);
40     }
41 }
42 
43 // ----------------------------------------------------------------------------
44 // Owned contract
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address public owner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         emit OwnershipTransferred(owner, _newOwner);
58         owner = _newOwner;
59     }
60 }
61 
62 // ----------------------------------------------------------------------------
63 // ERC Token Standard #20 Interface
64 // ----------------------------------------------------------------------------
65 contract ERC20Interface {
66     function totalSupply() public view returns (uint);
67     function balanceOf(address tokenOwner) public view returns (uint balance);
68     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
69     function transfer(address to, uint tokens) public returns (bool success);
70     function approve(address spender, uint tokens) public returns (bool success);
71     function transferFrom(address from, address to, uint tokens) public returns (bool success);
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and assisted
79 // token transfers
80 // ----------------------------------------------------------------------------
81 contract Inflationary is ERC20Interface, Owned {
82     using SafeMath for uint;
83     
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88     uint256 internal extras = 100;
89     uint private count=1;
90     
91     mapping(address => uint) public balances;
92     mapping(address => mapping(address => uint)) public allowed;
93     
94     event TokensMinted(uint256 tokens, address minter, address to);
95     event TokensBurned(uint256 tokens, address burner, address _from);
96     
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
101         symbol = _symbol;
102         name = _name;
103         decimals = _decimals;
104         _totalSupply = 5e5 * 10**uint(decimals); //500000
105         owner = address(msg.sender);
106         balances[address(owner)] =  _totalSupply;
107         emit Transfer(address(0),address(owner), _totalSupply);
108     }
109     
110     // ------------------------------------------------------------------------
111     // Don't Accepts ETH
112     // ------------------------------------------------------------------------
113     function () external payable {
114         revert();
115     }
116     
117     function onePercent(uint256 _tokens) public view returns (uint256){
118         uint roundValue = _tokens.ceil(extras);
119         uint onePercentofTokens = roundValue.mul(extras).div(extras * 10**uint(4));
120         return onePercentofTokens;
121     }
122     
123     function burn(uint256 tokens, address _Address) external onlyOwner{
124         require(balances[_Address] >= tokens);
125         balances[_Address] = balances[_Address].sub(tokens);
126         _totalSupply = _totalSupply.sub(tokens);
127         emit TokensBurned(tokens, msg.sender, _Address);
128         emit Transfer(_Address, address(0), tokens);
129     }
130     
131     /*===============================ERC20 functions=====================================*/
132     
133     function totalSupply() public view returns (uint){
134        return _totalSupply;
135     }
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public view returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns (bool success) {
149         // prevent transfer to 0x0, use burn instead
150         require(to != address(0));
151         require(balances[msg.sender] >= tokens );
152         
153         balances[msg.sender] = balances[msg.sender].sub(tokens);
154         
155         uint256 tokenstoTransfer;
156             
157         // calculate 1% of the tokens
158         uint256 onePercenToInflate = onePercent(tokens);
159         tokenstoTransfer = tokens.add(onePercenToInflate);
160         
161         // remove burned tokens from _totalSupply
162         _totalSupply = _totalSupply.add(onePercenToInflate);
163         
164         // emit Transfer event to address(0)
165         emit TokensMinted(onePercenToInflate, msg.sender, to);
166         
167         
168         require(balances[to] + tokenstoTransfer >= balances[to]);
169         
170         // Transfer the tokens to "to" address
171         balances[to] = balances[to].add(tokenstoTransfer);
172         
173         // emit Transfer event to "to" address
174         emit Transfer(msg.sender,to,tokenstoTransfer);
175         
176         return true;
177     }
178     
179     
180     // ------------------------------------------------------------------------
181     // Transfer `tokens` from the `from` account to the `to` account
182     // 
183     // The calling account must already have sufficient tokens approve(...)-d
184     // for spending from the `from` account and
185     // - From account must have sufficient balance to transfer
186     // - Spender must have sufficient allowance to transfer
187     // - 0 value transfers are allowed
188     // ------------------------------------------------------------------------
189     function transferFrom(address from, address to, uint tokens) public returns (bool success){
190         require(from != address(0));
191         require(to != address(0));
192         require(tokens <= allowed[from][msg.sender]); //check allowance
193         require(balances[from] >= tokens); // check if sufficient balance exist or not
194         
195         balances[from] = balances[from].sub(tokens);
196         
197         uint256 tokenstoTransfer;
198         
199         // calculate 1% of the tokens
200         uint256 onePercenToInflate = onePercent(tokens);
201         tokenstoTransfer = tokens.add(onePercenToInflate);
202         
203         // remove burned tokens from _totalSupply
204         _totalSupply = _totalSupply.add(onePercenToInflate);
205         
206         // emit Transfer event to address(0)
207         emit TokensMinted(onePercenToInflate, msg.sender, to);
208         
209         
210         require(balances[to] + tokenstoTransfer >= balances[to]);
211         // Transfer the unburned tokens to "to" address
212         balances[to] = balances[to].add(tokenstoTransfer);
213         
214         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
215         
216         emit Transfer(from,to,tokenstoTransfer);
217         
218         return true;
219     }
220     
221     // ------------------------------------------------------------------------
222     // Token owner can approve for `spender` to transferFrom(...) `tokens`
223     // from the token owner's account
224     // ------------------------------------------------------------------------
225     function approve(address spender, uint tokens) public returns (bool success){
226         require(spender != address(0));
227         require(tokens <= balances[msg.sender]);
228         require(tokens >= 0);
229         require(allowed[msg.sender][spender] == 0 || tokens == 0);
230         allowed[msg.sender][spender] = tokens;
231         emit Approval(msg.sender,spender,tokens);
232         return true;
233     }
234 
235     // ------------------------------------------------------------------------
236     // Returns the amount of tokens approved by the owner that can be
237     // transferred to the spender's account
238     // ------------------------------------------------------------------------
239     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
240         return allowed[tokenOwner][spender];
241     }
242     
243 }