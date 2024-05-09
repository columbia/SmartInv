1 pragma solidity ^0.4.23;
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
22         emit OwnershipTransferred(owner, newOwner);
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
65 contract MannaCoin is ERC20Interface, Owned{
66     using SafeMath for uint;
67     string public symbol;
68     string public name;
69     uint8 public decimals;
70     uint _totalSupply;
71     mapping(address => uint) balances;
72     mapping(address => mapping(address => uint)) allowed;
73     uint256 public rate; // How many token units a buyer gets per wei
74     uint256 public weiRaised;  // Amount of wei raised
75     address wallet;
76     uint _tokenToSale;
77     uint _ownersTokens;
78     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
79     
80     // ------------------------------------------------------------------------
81     // Constructor
82     // ------------------------------------------------------------------------
83     function MannaCoin(address _owner,address _wallet) public{
84         symbol = "MAN";
85         name = "MANNA TOKEN";
86         decimals = 18;
87         rate = 600;
88         wallet = _wallet;
89         owner = _owner;
90         _totalSupply = totalSupply();
91         _tokenToSale = 20000000 * 10**uint(decimals);
92         _ownersTokens = _totalSupply - _tokenToSale;
93         balances[this] = _tokenToSale;
94         balances[owner] = _ownersTokens;
95         emit Transfer(address(0),this,_tokenToSale);
96         emit Transfer(address(0),owner,_ownersTokens);
97     }
98 
99     function totalSupply() public constant returns (uint){
100        return 45000000 * 10**uint(decimals);
101     }
102 
103     // ------------------------------------------------------------------------
104     // Get the token balance for account `tokenOwner`
105     // ------------------------------------------------------------------------
106     function balanceOf(address tokenOwner) public constant returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110     // ------------------------------------------------------------------------
111     // Transfer the balance from token owner's account to `to` account
112     // - Owner's account must have sufficient balance to transfer
113     // - 0 value transfers are allowed
114     // ------------------------------------------------------------------------
115     function transfer(address to, uint tokens) public returns (bool success) {
116         // prevent transfer to 0x0, use burn instead
117         require(to != 0x0);
118         require(balances[msg.sender] >= tokens );
119         require(balances[to] + tokens >= balances[to]);
120         balances[msg.sender] = balances[msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(msg.sender,to,tokens);
123         return true;
124     }
125     
126     function _transfer(address _to, uint _tokens) internal returns (bool success){
127         // prevent transfer to 0x0, use burn instead
128         require(_to != 0x0);
129         require(balances[this] >= _tokens);
130         require(balances[_to] + _tokens >= balances[_to]);
131         balances[this] = balances[this].sub(_tokens);
132         balances[_to] = balances[_to].add(_tokens);
133         emit Transfer(this,_to,_tokens);
134         return true;
135     }
136     
137     // ------------------------------------------------------------------------
138     // Token owner can approve for `spender` to transferFrom(...) `tokens`
139     // from the token owner's account
140     // ------------------------------------------------------------------------
141     function approve(address spender, uint tokens) public returns (bool success){
142         allowed[msg.sender][spender] = tokens;
143         emit Approval(msg.sender,spender,tokens);
144         return true;
145     }
146 
147     // ------------------------------------------------------------------------
148     // Transfer `tokens` from the `from` account to the `to` account
149     // 
150     // The calling account must already have sufficient tokens approve(...)-d
151     // for spending from the `from` account and
152     // - From account must have sufficient balance to transfer
153     // - Spender must have sufficient allowance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transferFrom(address from, address to, uint tokens) public returns (bool success){
157         require(tokens <= allowed[from][msg.sender]); //check allowance
158         require(balances[from] >= tokens);
159         balances[from] = balances[from].sub(tokens);
160         balances[to] = balances[to].add(tokens);
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162         emit Transfer(from,to,tokens);
163         return true;
164     }
165     // ------------------------------------------------------------------------
166     // Returns the amount of tokens approved by the owner that can be
167     // transferred to the spender's account
168     // ------------------------------------------------------------------------
169     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
170         return allowed[tokenOwner][spender];
171     }
172     
173     function () external payable {
174         buyTokens(msg.sender);
175     }
176     
177     function buyTokens(address _beneficiary) public payable {
178         
179         uint256 weiAmount = msg.value;
180         _preValidatePurchase(_beneficiary, weiAmount);
181 
182         // calculate token amount to be created
183         uint256 tokens = _getTokenAmount(weiAmount);
184     
185         // update state
186         weiRaised = weiRaised.add(weiAmount);
187 
188         _processPurchase(_beneficiary, tokens);
189         TokenPurchase(this, _beneficiary, weiAmount, tokens);
190 
191         _forwardFunds();
192     }
193   
194     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
195         require(_beneficiary != address(0x0));
196         require(_weiAmount != 0);
197     }
198   
199     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
200         return _weiAmount.mul(rate);
201     }
202   
203     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
204         _transfer(_beneficiary,_tokenAmount);
205     }
206 
207     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
208         _deliverTokens(_beneficiary, _tokenAmount);
209     }
210   
211     function _forwardFunds() internal {
212         wallet.transfer(msg.value);
213     }
214 }