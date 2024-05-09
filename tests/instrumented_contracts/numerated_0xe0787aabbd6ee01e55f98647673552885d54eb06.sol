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
58  * @title HydrogenBlueICO
59  * @dev   HydrogenBlueICO accepting contributions only within a time frame.
60  */
61 contract HydrogenBlueICO is ERC20Interface, Owned {
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
73   uint256 internal firststageopeningTime;
74   uint256 internal secondstageopeningTime;
75   uint256 internal laststageopeningTime;
76   bool    internal Open;
77   bool internal distributionFinished;
78   
79   mapping(address => uint) balances;
80   mapping(address => mapping(address => uint)) allowed;
81   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
82   event Burned(address burner, uint burnedAmount);
83 
84     modifier onlyWhileOpen {
85         require(now >= firststageopeningTime && Open);
86         _;
87     }
88     
89     modifier canDistribut {
90         require(!distributionFinished);
91         _;
92     }
93   
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     constructor (address _owner, address _wallet) public {
98         Open = true;
99         symbol = "HydroB";
100         name = " HydrogenBlue";
101         decimals = 18;
102         owner = _owner;
103         wallet = _wallet;
104         _totalSupply = 2700000000; // 2.7 billion
105         _totalRemaining = totalSupply();
106         balances[0xEA40d7bEF6ae216c4218E9bA28f92aF06cC77886] = 2e21;
107         emit Transfer(address(0),0xEA40d7bEF6ae216c4218E9bA28f92aF06cC77886, 2e21);
108         _totalRemaining = _totalRemaining.sub(2e21);
109         balances[0x30D344806E8c13A592F54a123f560ad1976f5eC2] = 2e21;
110         emit Transfer(address(0),0x30D344806E8c13A592F54a123f560ad1976f5eC2, 2e21);
111         _totalRemaining = _totalRemaining.sub(2e21);
112         _allocateTokens();
113         _setTimes();
114         distributionFinished = false;
115     }
116     
117     function _setTimes() internal {
118         firststageopeningTime    = 1539561600; // 15th OCT 2018 00:00:00 GMT
119         secondstageopeningTime   = 1540166400; // 22nd OCT 2018 00:00:00 GMT 
120         laststageopeningTime     = 1540771200; // 29th OCT 2018 00:00:00 GMT
121     }
122   
123     function _allocateTokens() internal {
124         reserveTokens         = (_totalSupply.mul(5)).div(100) *10 **uint(decimals);  // 5% of totalSupply
125         saleTokens            = (_totalSupply.mul(95)).div(100) *10 **uint(decimals); // 95% of totalSupply
126         TokenPrice            = "0.00000023 ETH";
127     }
128     
129     function () external payable {
130         buyTokens(msg.sender);
131     }
132 
133     function buyTokens(address _beneficiary) public payable onlyWhileOpen {
134     
135         uint256 weiAmount = msg.value;
136     
137         _preValidatePurchase(_beneficiary, weiAmount);
138         
139         uint256 tokens = _getTokenAmount(weiAmount);
140         
141         tokens = _getBonus(tokens, weiAmount);
142         
143         fundsRaised = fundsRaised.add(weiAmount);
144 
145         _processPurchase(_beneficiary, tokens);
146         emit TokenPurchase(this, _beneficiary, weiAmount, tokens);
147 
148         _forwardFunds(msg.value);
149     }
150     
151     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{
152         require(_beneficiary != address(0));
153         require(_weiAmount != 0);
154     }
155   
156     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
157         uint256 rate = 4347826; //per wei
158         return _weiAmount.mul(rate);
159     }
160     
161     function _getBonus(uint256 tokens, uint256 weiAmount) internal returns (uint256) {
162         // DURING FIRST STAGE
163         if(now >= firststageopeningTime && now <= secondstageopeningTime) { 
164             if(weiAmount >= 10e18) { // greater than 10 eths 
165                 // give 80% bonus
166                 tokens = tokens.add((tokens.mul(80)).div(100));
167             } else {
168                 // give 60% bonus
169                 tokens = tokens.add((tokens.mul(60)).div(100));
170             }
171         } 
172         // DURING SECOND STAGE
173         else if (now >= secondstageopeningTime && now <= laststageopeningTime) { 
174             if(weiAmount >= 10e18) { // greater than 10 eths 
175                 // give 60% bonus
176                 tokens = tokens.add((tokens.mul(60)).div(100));
177             } else {
178                 // give 30% bonus
179                 tokens = tokens.add((tokens.mul(30)).div(100));
180             }
181         } 
182         // DURING LAST STAGE
183         else { 
184             if(weiAmount >= 10e18) { // greater than 10 eths 
185                 // give 30% bonus
186                 tokens = tokens.add((tokens.mul(30)).div(100));
187             } else {
188                 // give 10% bonus
189                 tokens = tokens.add((tokens.mul(10)).div(100));
190             }
191         }
192         
193         return tokens;
194     }
195     
196     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
197         if(_totalRemaining != 0 && _totalRemaining >= _tokenAmount) {
198             balances[_beneficiary] = _tokenAmount;
199             emit Transfer(address(0),_beneficiary, _tokenAmount);
200             _totalRemaining = _totalRemaining.sub(_tokenAmount);
201         }
202         
203         if(_totalRemaining <= 0) {
204             distributionFinished = true;
205         }
206     }
207 
208     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
209         _deliverTokens(_beneficiary, _tokenAmount);
210     }
211     
212     function _forwardFunds(uint256 _amount) internal {
213         wallet.transfer(_amount);
214     }
215     
216     function stopICO() public onlyOwner{
217         Open = false;
218         if(_totalRemaining != 0){
219             uint tenpercentTokens = (_totalRemaining.mul(10)).div(100);
220             uint twentypercentTokens = (_totalRemaining.mul(20)).div(100);
221             _totalRemaining = _totalRemaining.sub(tenpercentTokens.add(twentypercentTokens));
222             emit Transfer(address(0), owner, tenpercentTokens);
223             emit Transfer(address(0), wallet, twentypercentTokens);
224             _burnRemainingTokens(); // burn the remaining tokens
225         }
226     }
227     
228     function _burnRemainingTokens() internal {
229         _totalSupply = _totalSupply.sub(_totalRemaining.div(1e18));
230     }
231     /* ERC20Interface function's implementation */
232     function totalSupply() public constant returns (uint){
233        return _totalSupply* 10**uint(decimals);
234     }
235     
236     // ------------------------------------------------------------------------
237     // Get the token balance for account `tokenOwner`
238     // ------------------------------------------------------------------------
239     function balanceOf(address tokenOwner) public constant returns (uint balance) {
240         return balances[tokenOwner];
241     }
242 
243     // ------------------------------------------------------------------------
244     // Transfer the balance from token owner's account to `to` account
245     // - Owner's account must have sufficient balance to transfer
246     // - 0 value transfers are allowed
247     // ------------------------------------------------------------------------
248     function transfer(address to, uint tokens) public returns (bool success) {
249         // prevent transfer to 0x0, use burn instead
250         require(to != 0x0);
251         require(balances[msg.sender] >= tokens );
252         require(balances[to] + tokens >= balances[to]);
253         balances[msg.sender] = balances[msg.sender].sub(tokens);
254         balances[to] = balances[to].add(tokens);
255         emit Transfer(msg.sender,to,tokens);
256         return true;
257     }
258     
259     // ------------------------------------------------------------------------
260     // Token owner can approve for `spender` to transferFrom(...) `tokens`
261     // from the token owner's account
262     // ------------------------------------------------------------------------
263     function approve(address spender, uint tokens) public returns (bool success){
264         allowed[msg.sender][spender] = tokens;
265         emit Approval(msg.sender,spender,tokens);
266         return true;
267     }
268 
269     // ------------------------------------------------------------------------
270     // Transfer `tokens` from the `from` account to the `to` account
271     // 
272     // The calling account must already have sufficient tokens approve(...)-d
273     // for spending from the `from` account and
274     // - From account must have sufficient balance to transfer
275     // - Spender must have sufficient allowance to transfer
276     // - 0 value transfers are allowed
277     // ------------------------------------------------------------------------
278     function transferFrom(address from, address to, uint tokens) public returns (bool success){
279         require(tokens <= allowed[from][msg.sender]); //check allowance
280         require(balances[from] >= tokens);
281         balances[from] = balances[from].sub(tokens);
282         balances[to] = balances[to].add(tokens);
283         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
284         emit Transfer(from,to,tokens);
285         return true;
286     }
287     // ------------------------------------------------------------------------
288     // Returns the amount of tokens approved by the owner that can be
289     // transferred to the spender's account
290     // ------------------------------------------------------------------------
291     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
292         return allowed[tokenOwner][spender];
293     }
294 
295 }