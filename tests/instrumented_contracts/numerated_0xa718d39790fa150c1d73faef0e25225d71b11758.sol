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
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 contract BLTCoin is ERC20Interface, Owned{
57     using SafeMath for uint;
58     
59     string public symbol;
60     string public name;
61     uint8 public decimals;
62     uint _totalSupply;
63     mapping(address => uint) balances;
64     mapping(address => mapping(address => uint)) allowed;
65     uint256 public rate; // How many token units a buyer gets per wei
66     uint256 public weiRaised;  // Amount of wei raised
67     uint value;
68     uint _ICOTokensLimit;
69     uint _ownerTokensLimit;
70     uint public bonusPercentage;
71     bool public icoOpen;
72     bool public bonusCompaignOpen;
73     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
74     /**
75     * Reverts if not in crowdsale time range. 
76     */
77     modifier onlyWhileOpen {
78         require(icoOpen);
79         _;
80     }
81     // ------------------------------------------------------------------------
82     // Constructor
83     // ------------------------------------------------------------------------
84     function BLTCoin(address _owner) public{
85         icoOpen = false;
86         bonusCompaignOpen = false;
87         symbol = "BLT";
88         name = "BrotherlyLend";
89         decimals = 18;
90         rate = 142857; //tokens per wei
91         owner = _owner;
92         _totalSupply = totalSupply();
93         _ICOTokensLimit = _icoTokens();
94         _ownerTokensLimit = _ownersTokens();
95         balances[owner] = _ownerTokensLimit;
96         balances[this] = _ICOTokensLimit;
97         emit Transfer(address(0),owner,_ownerTokensLimit);
98         emit Transfer(address(0),this,_ICOTokensLimit);
99     }
100     
101     function _icoTokens() internal constant returns(uint){
102         return 9019800000 * 10**uint(decimals);
103     }
104     
105     function _ownersTokens() internal constant returns(uint){
106         return 11024200000 * 10**uint(decimals);
107     }
108     
109     function totalSupply() public constant returns (uint){
110        return 20044000000 * 10**uint(decimals);
111     }
112     
113     function startICO() public onlyOwner{
114         require(!icoOpen);
115         icoOpen = true;
116     }
117     
118     function stopICO() public onlyOwner{
119         require(icoOpen);
120         icoOpen = false;
121     }
122 
123     function startBonusCompaign(uint _percentage) public onlyOwner{
124         bonusCompaignOpen = true;
125         bonusPercentage = _percentage;
126     }
127     
128     function stopBonusCompaign() public onlyOwner{
129         bonusCompaignOpen = false;
130     }
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public returns (bool success) {
144         // prevent transfer to 0x0, use burn instead
145         require(to != 0x0);
146         require(balances[msg.sender] >= tokens );
147         require(balances[to] + tokens >= balances[to]);
148         balances[msg.sender] = balances[msg.sender].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         emit Transfer(msg.sender,to,tokens);
151         return true;
152     }
153     
154     function _transfer(address _to, uint _tokens) internal returns (bool success){
155         // prevent transfer to 0x0, use burn instead
156         require(_to != 0x0);
157         require(balances[this] >= _tokens );
158         require(balances[_to] + _tokens >= balances[_to]);
159         balances[this] = balances[this].sub(_tokens);
160         balances[_to] = balances[_to].add(_tokens);
161         emit Transfer(this,_to,_tokens);
162         return true;
163     }
164     
165     // ------------------------------------------------------------------------
166     // Token owner can approve for `spender` to transferFrom(...) `tokens`
167     // from the token owner's account
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success){
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender,spender,tokens);
172         return true;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Transfer `tokens` from the `from` account to the `to` account
177     // 
178     // The calling account must already have sufficient tokens approve(...)-d
179     // for spending from the `from` account and
180     // - From account must have sufficient balance to transfer
181     // - Spender must have sufficient allowance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transferFrom(address from, address to, uint tokens) public returns (bool success){
185         require(tokens <= allowed[from][msg.sender]); //check allowance
186         require(balances[from] >= tokens);
187         balances[from] = balances[from].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
190         emit Transfer(from,to,tokens);
191         return true;
192     }
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200     
201     function () external payable{
202         buyTokens(msg.sender);
203     }
204     
205     function buyTokens(address _beneficiary) public payable onlyWhileOpen{
206         
207         uint256 weiAmount = msg.value;
208         _preValidatePurchase(_beneficiary, weiAmount);
209 
210         // calculate token amount to be created
211         uint256 tokens = _getTokenAmount(weiAmount);
212         
213         if(bonusCompaignOpen){
214             uint p = tokens.mul(bonusPercentage.mul(100));
215             p = p.div(10000);
216             tokens = tokens.add(p);
217         }
218         
219         // update state
220         weiRaised = weiRaised.add(weiAmount);
221 
222         _processPurchase(_beneficiary, tokens);
223         TokenPurchase(this, _beneficiary, weiAmount, tokens);
224 
225         _forwardFunds();
226     }
227   
228     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
229         require(_beneficiary != address(0x0));
230         require(_weiAmount != 0);
231     }
232   
233     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
234         return _weiAmount.mul(rate);
235     }
236   
237     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
238         _transfer(_beneficiary,_tokenAmount);
239     }
240 
241     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
242         _deliverTokens(_beneficiary, _tokenAmount);
243     }
244   
245     function _forwardFunds() internal {
246         owner.transfer(msg.value);
247     }
248 }