1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address _newOwner) public onlyOwner {
18         newOwner = _newOwner;
19     }
20     function acceptOwnership() public {
21         require(msg.sender == newOwner);
22         emit OwnershipTransferred (owner, newOwner);
23         owner = newOwner;
24         newOwner = address(0);
25     }
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Safe maths
30 // ----------------------------------------------------------------------------
31 library SafeMath {
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function sub(uint a, uint b) internal pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     function mul(uint a, uint b) internal pure returns (uint c) {
41         c = a * b;
42         require(a == 0 || c / a == b);
43     }
44     function div(uint a, uint b) internal pure returns (uint c) {
45         require(b > 0);
46         c = a / b;
47     }
48 }
49 
50 // ----------------------------------------------------------------------------
51 // ERC Token Standard #20 Interface
52 // ----------------------------------------------------------------------------
53 contract ERC20Interface {
54     function totalSupply() public constant returns (uint);
55     function balanceOf(address tokenOwner) public constant returns (uint balance);
56     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
57     function transfer(address to, uint tokens) public returns (bool success);
58     function approve(address spender, uint tokens) public returns (bool success);
59     function transferFrom(address from, address to, uint tokens) public returns (bool success);
60 
61     event Transfer(address indexed from, address indexed to, uint tokens);
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 }
64 
65 contract Aeroneum is ERC20Interface, Owned {
66     using SafeMath for uint;
67     string public symbol;
68     string public name;
69     uint8 public decimals;
70     uint _totalSupply;
71     uint8 mintx;
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74     uint256 public rate; // How many token units a buyer gets per wei
75     uint256 public weiRaised;  // Amount of wei raised
76     address wallet;
77     uint _tokenToSale;
78     uint _ownersTokens;
79     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
80     
81     // ------------------------------------------------------------------------
82     // Constructor
83     // ------------------------------------------------------------------------
84     function Aeroneum(address _owner,address _wallet) public{
85         symbol = "ARM";
86         name = "Aeroneum";
87         decimals = 18;
88         rate = 5000000; //per wei
89         mintx = 16;
90         wallet = _wallet; // to send funds to
91         owner = _owner; //owner of the contract
92         _totalSupply = totalSupply();
93         _tokenToSale = (_totalSupply.mul(95)).div(100); // 95% kept for sales
94         _ownersTokens = _totalSupply - _tokenToSale; // 5% send to owner
95         balances[this] = _tokenToSale;
96         balances[owner] = _ownersTokens;
97         emit Transfer(address(0),this,_tokenToSale);
98         emit Transfer(address(0),owner,_ownersTokens);
99     }
100 
101     function totalSupply() public constant returns (uint){
102        return 11000000000 * 10**uint(decimals);
103     }
104 
105     // ------------------------------------------------------------------------
106     // Get the token balance for account `tokenOwner`
107     // ------------------------------------------------------------------------
108     function balanceOf(address tokenOwner) public constant returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112     // ------------------------------------------------------------------------
113     // Transfer the balance from token owner's account to `to` account
114     // - Owner's account must have sufficient balance to transfer
115     // - 0 value transfers are allowed
116     // ------------------------------------------------------------------------
117     function transfer(address to, uint tokens) public returns (bool success) {
118         // prevent transfer to 0x0, use burn instead
119         require(to != 0x0);
120         require(balances[msg.sender] >= tokens );
121         require(balances[to] + tokens >= balances[to]);
122         balances[msg.sender] = balances[msg.sender].sub(tokens);
123         balances[to] = balances[to].add(tokens);
124         emit Transfer(msg.sender,to,tokens);
125         return true;
126     }
127     
128     function _transfer(address _to, uint _tokens) internal returns (bool success){
129         // prevent transfer to 0x0, use burn instead
130         require(_to != 0x0);
131         require(balances[this] >= _tokens);
132         require(balances[_to] + _tokens >= balances[_to]);
133         balances[this] = balances[this].sub(_tokens);
134         balances[_to] = balances[_to].add(_tokens);
135         emit Transfer(this,_to,_tokens);
136         return true;
137     }
138     
139     // ------------------------------------------------------------------------
140     // Token owner can approve for `spender` to transferFrom(...) `tokens`
141     // from the token owner's account
142     // ------------------------------------------------------------------------
143     function approve(address spender, uint tokens) public returns (bool success){
144         allowed[msg.sender][spender] = tokens;
145         emit Approval(msg.sender,spender,tokens);
146         return true;
147     }
148 
149     // ------------------------------------------------------------------------
150     // Transfer `tokens` from the `from` account to the `to` account
151     // 
152     // The calling account must already have sufficient tokens approve(...)-d
153     // for spending from the `from` account and
154     // - From account must have sufficient balance to transfer
155     // - Spender must have sufficient allowance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transferFrom(address from, address to, uint tokens) public returns (bool success){
159         require(tokens <= allowed[from][msg.sender]); //check allowance
160         require(balances[from] >= tokens);
161         balances[from] = balances[from].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
164         emit Transfer(from,to,tokens);
165         return true;
166     }
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174     
175     function () external payable {
176         buyTokens(msg.sender);
177     }
178     
179     function buyTokens(address _beneficiary) public payable {
180         
181         uint256 weiAmount = msg.value;
182         _preValidatePurchase(_beneficiary, weiAmount);
183 
184         // calculate token amount to be created
185         uint256 tokens = _getTokenAmount(weiAmount);
186     
187         // update state
188         weiRaised = weiRaised.add(weiAmount);
189 
190         _processPurchase(_beneficiary, tokens);
191         TokenPurchase(this, _beneficiary, weiAmount, tokens);
192 
193         _forwardFunds();
194     }
195   
196     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
197         require(_beneficiary != address(0x0));
198         // require(_weiAmount != 0);
199     }
200   
201     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
202         if(_weiAmount < 1 * 10**uint(mintx)){return 50 * 10**uint(decimals);}
203         else{return _weiAmount.mul(rate);}
204     }
205   
206     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
207         _transfer(_beneficiary,_tokenAmount);
208     }
209 
210     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
211         _deliverTokens(_beneficiary, _tokenAmount);
212     }
213   
214     function _forwardFunds() internal {
215         wallet.transfer(msg.value);
216     }
217 }