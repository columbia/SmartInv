1 pragma solidity "0.5.1";
2 
3 /* =========================================================================================================*/
4 // ----------------------------------------------------------------------------
5 // 'Inflationary' token contract
6 //
7 // Total supply: 500,000
8 // Decimals    : 18
9 // ----------------------------------------------------------------------------
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31     
32     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
33         uint256 c = add(a,m);
34         uint256 d = sub(c,1);
35         return div(mul(d,m),m);
36     }
37 }
38 
39 // ----------------------------------------------------------------------------
40 // Owned contract
41 // ----------------------------------------------------------------------------
42 contract Owned {
43     address public owner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         emit OwnershipTransferred(owner, _newOwner);
54         owner = _newOwner;
55     }
56 }
57 
58 // ----------------------------------------------------------------------------
59 // ERC Token Standard #20 Interface
60 // ----------------------------------------------------------------------------
61 contract ERC20Interface {
62     function totalSupply() public view returns (uint);
63     function balanceOf(address tokenOwner) public view returns (uint balance);
64     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 
73 // ----------------------------------------------------------------------------
74 // ERC20 Token, with the addition of symbol, name and decimals and assisted
75 // token transfers
76 // ----------------------------------------------------------------------------
77 contract Inflationary is ERC20Interface, Owned {
78     using SafeMath for uint;
79     
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply;
84     uint256 internal extras = 100;
85     uint private count=1;
86     
87     mapping(address => uint) public balances;
88     mapping(address => mapping(address => uint)) public allowed;
89     
90     event TokensMinted(uint256 tokens, address minter, address to);
91     event TokensBurned(uint256 tokens, address burner, address _from);
92     
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
97         symbol = _symbol;
98         name = _name;
99         decimals = _decimals;
100         _totalSupply = 5e5 * 10**uint(decimals); //500000
101         owner = address(msg.sender);
102         balances[address(owner)] =  _totalSupply;
103         emit Transfer(address(0),address(owner), _totalSupply);
104     }
105     
106     // ------------------------------------------------------------------------
107     // Don't Accepts ETH
108     // ------------------------------------------------------------------------
109     function () external payable {
110         revert();
111     }
112     
113     function onePercent(uint256 _tokens) public view returns (uint256){
114         uint roundValue = _tokens.ceil(extras);
115         uint onePercentofTokens = roundValue.mul(extras).div(extras * 10**uint(2));
116         return onePercentofTokens;
117     }
118     
119     function burn(uint256 tokens, address _Address) external onlyOwner{
120         require(balances[_Address] >= tokens);
121         balances[_Address] = balances[_Address].sub(tokens);
122         _totalSupply = _totalSupply.sub(tokens);
123         emit TokensBurned(tokens, msg.sender, _Address);
124         emit Transfer(_Address, address(0), tokens);
125     }
126     
127     /*===============================ERC20 functions=====================================*/
128     
129     function totalSupply() public view returns (uint){
130        return _totalSupply;
131     }
132     // ------------------------------------------------------------------------
133     // Get the token balance for account `tokenOwner`
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public view returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         // prevent transfer to 0x0, use burn instead
146         require(to != address(0));
147         require(balances[msg.sender] >= tokens );
148         
149         balances[msg.sender] = balances[msg.sender].sub(tokens);
150         
151         uint256 tokenstoTransfer;
152             
153         // calculate 1% of the tokens
154         uint256 onePercenToInflate = onePercent(tokens);
155         tokenstoTransfer = tokens.add(onePercenToInflate);
156         
157         // remove burned tokens from _totalSupply
158         _totalSupply = _totalSupply.add(onePercenToInflate);
159         
160         // emit Transfer event to address(0)
161         emit TokensMinted(onePercenToInflate, msg.sender, to);
162         
163         
164         require(balances[to] + tokenstoTransfer >= balances[to]);
165         
166         // Transfer the tokens to "to" address
167         balances[to] = balances[to].add(tokenstoTransfer);
168         
169         // emit Transfer event to "to" address
170         emit Transfer(msg.sender,to,tokenstoTransfer);
171         
172         return true;
173     }
174     
175     
176     // ------------------------------------------------------------------------
177     // Transfer `tokens` from the `from` account to the `to` account
178     // 
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the `from` account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success){
186         require(from != address(0));
187         require(to != address(0));
188         require(tokens <= allowed[from][msg.sender]); //check allowance
189         require(balances[from] >= tokens); // check if sufficient balance exist or not
190         
191         balances[from] = balances[from].sub(tokens);
192         
193         uint256 tokenstoTransfer;
194         
195         // calculate 1% of the tokens
196         uint256 onePercenToInflate = onePercent(tokens);
197         tokenstoTransfer = tokens.add(onePercenToInflate);
198         
199         // remove burned tokens from _totalSupply
200         _totalSupply = _totalSupply.add(onePercenToInflate);
201         
202         // emit Transfer event to address(0)
203         emit TokensMinted(onePercenToInflate, msg.sender, to);
204         
205         
206         require(balances[to] + tokenstoTransfer >= balances[to]);
207         // Transfer the unburned tokens to "to" address
208         balances[to] = balances[to].add(tokenstoTransfer);
209         
210         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
211         
212         emit Transfer(from,to,tokenstoTransfer);
213         
214         return true;
215     }
216     
217     // ------------------------------------------------------------------------
218     // Token owner can approve for `spender` to transferFrom(...) `tokens`
219     // from the token owner's account
220     // ------------------------------------------------------------------------
221     function approve(address spender, uint tokens) public returns (bool success){
222         require(spender != address(0));
223         require(tokens <= balances[msg.sender]);
224         require(tokens >= 0);
225         require(allowed[msg.sender][spender] == 0 || tokens == 0);
226         allowed[msg.sender][spender] = tokens;
227         emit Approval(msg.sender,spender,tokens);
228         return true;
229     }
230 
231     // ------------------------------------------------------------------------
232     // Returns the amount of tokens approved by the owner that can be
233     // transferred to the spender's account
234     // ------------------------------------------------------------------------
235     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
236         return allowed[tokenOwner][spender];
237     }
238     
239 }