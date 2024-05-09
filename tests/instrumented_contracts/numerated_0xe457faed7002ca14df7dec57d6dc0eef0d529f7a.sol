1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55 }
56 
57 /**
58  * @title ArconexICO
59  * @dev   ArconexICO accepting contributions only within a time frame.
60  */
61 contract ArconexICO is ERC20Interface, Owned {
62   using SafeMath for uint256;
63   string  public symbol; 
64   string  public name;
65   uint8   public decimals;
66   uint256 public fundsRaised;
67   uint256 public reserveTokens;
68   string  public TokenPrice;
69   uint256 public saleTokens;
70   uint    internal _totalSupply;
71   uint internal _totalRemaining;
72   address public wallet;
73   bool internal distributionFinished;
74   
75   mapping(address => uint) balances;
76   mapping(address => mapping(address => uint)) allowed;
77   mapping(address => bool) zeroInvestors;
78   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
79     
80     modifier canDistribut {
81         require(!distributionFinished);
82         _;
83     }
84   
85     // ------------------------------------------------------------------------
86     // Constructor
87     // ------------------------------------------------------------------------
88     constructor (address _owner, address _wallet) public {
89         symbol = "ACX";
90         name = " Arconex";
91         decimals = 18;
92         owner = _owner;
93         wallet = _wallet;
94         _totalSupply = 200000000; // 200 M
95         _allocateTokens();
96         // send the reserve tokens to the creator of the contract
97         balances[owner] = reserveTokens;
98         emit Transfer(address(0),owner, reserveTokens); 
99         // make total remaining equal to saleTokens
100         _totalRemaining = saleTokens;
101         distributionFinished = false;
102     }
103 
104     function _allocateTokens() internal {
105         reserveTokens         = (_totalSupply.mul(5)).div(100) *10 **uint(decimals);  // 5% of totalSupply
106         saleTokens            = (_totalSupply.mul(95)).div(100) *10 **uint(decimals); // 95% of totalSupply
107         TokenPrice            = "0.0000004 ETH";
108     }
109     
110     function () external payable {
111         buyTokens(msg.sender);
112     }
113 
114     function buyTokens(address _beneficiary) public payable canDistribut {
115     
116         uint256 weiAmount = msg.value;
117     
118         _preValidatePurchase(_beneficiary, weiAmount);
119         
120         uint256 tokens = _getTokenAmount(_beneficiary, weiAmount);
121         
122         fundsRaised = fundsRaised.add(weiAmount);
123 
124         _processPurchase(_beneficiary, tokens);
125         emit TokenPurchase(this, _beneficiary, weiAmount, tokens);
126 
127         _forwardFunds(msg.value);
128     }
129     
130     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) view internal{
131         require(_beneficiary != address(0));
132         if(_weiAmount == 0){
133             require(!(zeroInvestors[_beneficiary]));
134         }
135     }
136   
137     function _getTokenAmount(address _beneficiary, uint256 _weiAmount) internal returns (uint256) {
138         if(_weiAmount == 0){
139             zeroInvestors[_beneficiary] = true;
140             return 50e18; 
141         }
142         else{
143             uint256 rate = 2500000; //per wei
144             return _weiAmount.mul(rate);
145         }
146     }
147     
148     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
149         if(_totalRemaining != 0 && _totalRemaining >= _tokenAmount) {
150             balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
151             emit Transfer(address(0),_beneficiary, _tokenAmount);
152             _totalRemaining = _totalRemaining.sub(_tokenAmount);
153         }
154         
155         if(_totalRemaining <= 0) {
156             distributionFinished = true;
157         }
158     }
159 
160     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
161         _deliverTokens(_beneficiary, _tokenAmount);
162     }
163     
164     function _forwardFunds(uint256 _amount) internal {
165         wallet.transfer(_amount);
166     }
167     
168     /* ERC20Interface function's implementation */
169     function totalSupply() public constant returns (uint){
170        return _totalSupply* 10**uint(decimals);
171     }
172     
173     // ------------------------------------------------------------------------
174     // Get the token balance for account `tokenOwner`
175     // ------------------------------------------------------------------------
176     function balanceOf(address tokenOwner) public constant returns (uint balance) {
177         return balances[tokenOwner];
178     }
179 
180     // ------------------------------------------------------------------------
181     // Transfer the balance from token owner's account to `to` account
182     // - Owner's account must have sufficient balance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transfer(address to, uint tokens) public returns (bool success) {
186         // prevent transfer to 0x0, use burn instead
187         require(to != 0x0);
188         require(balances[msg.sender] >= tokens );
189         require(balances[to] + tokens >= balances[to]);
190         balances[msg.sender] = balances[msg.sender].sub(tokens);
191         balances[to] = balances[to].add(tokens);
192         emit Transfer(msg.sender,to,tokens);
193         return true;
194     }
195     
196     // ------------------------------------------------------------------------
197     // Token owner can approve for `spender` to transferFrom(...) `tokens`
198     // from the token owner's account
199     // ------------------------------------------------------------------------
200     function approve(address spender, uint tokens) public returns (bool success){
201         allowed[msg.sender][spender] = tokens;
202         emit Approval(msg.sender,spender,tokens);
203         return true;
204     }
205 
206     // ------------------------------------------------------------------------
207     // Transfer `tokens` from the `from` account to the `to` account
208     // 
209     // The calling account must already have sufficient tokens approve(...)-d
210     // for spending from the `from` account and
211     // - From account must have sufficient balance to transfer
212     // - Spender must have sufficient allowance to transfer
213     // - 0 value transfers are allowed
214     // ------------------------------------------------------------------------
215     function transferFrom(address from, address to, uint tokens) public returns (bool success){
216         require(tokens <= allowed[from][msg.sender]); //check allowance
217         require(balances[from] >= tokens);
218         balances[from] = balances[from].sub(tokens);
219         balances[to] = balances[to].add(tokens);
220         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
221         emit Transfer(from,to,tokens);
222         return true;
223     }
224     // ------------------------------------------------------------------------
225     // Returns the amount of tokens approved by the owner that can be
226     // transferred to the spender's account
227     // ------------------------------------------------------------------------
228     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
229         return allowed[tokenOwner][spender];
230     }
231 
232 }