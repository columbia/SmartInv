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
25 // ----------------------------------------------------------------------------
26 // Owned contract
27 // ----------------------------------------------------------------------------
28 contract Owned {
29     address public owner;
30     address public newOwner;
31 
32     event OwnershipTransferred(address indexed _from, address indexed _to);
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
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
56 /**
57  * @title ViteCoinICO
58  * @dev   ViteCoinICO accepting contributions only within a time frame.
59  */
60 contract ViteCoinICO is ERC20Interface, Owned {
61   using SafeMath for uint256;
62   string  public symbol; 
63   string  public name;
64   uint8   public decimals;
65   uint256 public fundsRaised;         
66   uint256 public privateSaleTokens;
67   uint256 public preSaleTokens;
68   uint256 public saleTokens;
69   uint256 public teamAdvTokens;
70   uint256 public reserveTokens;
71   uint256 public bountyTokens;
72   uint256 public hardCap;
73   string  internal minTxSize;
74   string  internal maxTxSize;
75   string  public TokenPrice;
76   uint    internal _totalSupply;
77   address public wallet;
78   uint256 internal privatesaleopeningTime;
79   uint256 internal privatesaleclosingTime;
80   uint256 internal presaleopeningTime;
81   uint256 internal presaleclosingTime;
82   uint256 internal saleopeningTime;
83   uint256 internal saleclosingTime;
84   bool    internal privatesaleOpen;
85   bool    internal presaleOpen;
86   bool    internal saleOpen;
87   bool    internal Open;
88   
89   mapping(address => uint) balances;
90   mapping(address => mapping(address => uint)) allowed;
91   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
92   event Burned(address burner, uint burnedAmount);
93 
94     modifier onlyWhileOpen {
95         require(now >= privatesaleopeningTime && now <= (saleclosingTime + 30 days) && Open);
96         _;
97     }
98   
99     // ------------------------------------------------------------------------
100     // Constructor
101     // ------------------------------------------------------------------------
102     constructor (address _owner, address _wallet) public {
103         _allocateTokens();
104         _setTimes();
105     
106         symbol = "VT";
107         name = "Vitecoin";
108         decimals = 18;
109         owner = _owner;
110         wallet = _wallet;
111         _totalSupply = 200000000;
112         Open = true;
113         balances[this] = totalSupply();
114         emit Transfer(address(0),this, totalSupply());
115     }
116     
117     function _setTimes() internal{
118         privatesaleopeningTime    = 1534723200; // 20th Aug 2018 00:00:00 GMT 
119         privatesaleclosingTime    = 1541462399; // 05th Nov 2018 23:59:59 GMT   
120         presaleopeningTime        = 1541462400; // 06th Nov 2018 00:00:00 GMT 
121         presaleclosingTime        = 1546214399; // 30th Dec 2018 23:59:59 GMT
122         saleopeningTime           = 1546214400; // 31st Dec 2018 00:00:00 GMT
123         saleclosingTime           = 1553990399; // 30th Mar 2019 23:59:59 GMT
124     }
125   
126     function _allocateTokens() internal{
127         privateSaleTokens     = 10000000;   // 5%
128         preSaleTokens         = 80000000;   // 40%
129         saleTokens            = 60000000;   // 30%
130         teamAdvTokens         = 24000000;   // 12%
131         reserveTokens         = 20000000;   // 10%
132         bountyTokens          = 6000000;    // 3%
133         hardCap               = 36825;      // 36825 eths or 36825*10^18 weis 
134         minTxSize             = "0,5 ETH"; // (0,5 ETH)
135         maxTxSize             = "1000 ETH"; // (1000 ETH)
136         TokenPrice            = "$0.05";
137         privatesaleOpen       = true;
138     }
139 
140     function totalSupply() public constant returns (uint){
141        return _totalSupply* 10**uint(decimals);
142     }
143     
144     // ------------------------------------------------------------------------
145     // Get the token balance for account `tokenOwner`
146     // ------------------------------------------------------------------------
147     function balanceOf(address tokenOwner) public constant returns (uint balance) {
148         return balances[tokenOwner];
149     }
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to `to` account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint tokens) public returns (bool success) {
157         // prevent transfer to 0x0, use burn instead
158         require(to != 0x0);
159         require(balances[msg.sender] >= tokens );
160         require(balances[to] + tokens >= balances[to]);
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(msg.sender,to,tokens);
164         return true;
165     }
166     
167     // ------------------------------------------------------------------------
168     // Token owner can approve for `spender` to transferFrom(...) `tokens`
169     // from the token owner's account
170     // ------------------------------------------------------------------------
171     function approve(address spender, uint tokens) public returns (bool success){
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender,spender,tokens);
174         return true;
175     }
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
186     function transferFrom(address from, address to, uint tokens) public returns (bool success){
187         require(tokens <= allowed[from][msg.sender]); //check allowance
188         require(balances[from] >= tokens);
189         balances[from] = balances[from].sub(tokens);
190         balances[to] = balances[to].add(tokens);
191         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
192         emit Transfer(from,to,tokens);
193         return true;
194     }
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202     
203     function _checkOpenings() internal{
204         if(now >= privatesaleopeningTime && now <= privatesaleclosingTime){
205           privatesaleOpen = true;
206           presaleOpen = false;
207           saleOpen = false;
208         }
209         else if(now >= presaleopeningTime && now <= presaleclosingTime){
210           privatesaleOpen = false;
211           presaleOpen = true;
212           saleOpen = false;
213         }
214         else if(now >= saleopeningTime && now <= (saleclosingTime + 30 days)){
215             privatesaleOpen = false;
216             presaleOpen = false;
217             saleOpen = true;
218         }
219         else{
220           privatesaleOpen = false;
221           presaleOpen = false;
222           saleOpen = false;
223         }
224     }
225     
226         function () external payable {
227         buyTokens(msg.sender);
228     }
229 
230     function buyTokens(address _beneficiary) public payable onlyWhileOpen {
231     
232         uint256 weiAmount = msg.value;
233     
234         _preValidatePurchase(_beneficiary, weiAmount);
235     
236         _checkOpenings();
237         
238         if(privatesaleOpen){
239             require(weiAmount >= 5e17  && weiAmount <= 1e21 ,"FUNDS should be MIN 0,5 ETH and Max 1000 ETH");
240         }
241         else {
242             require(weiAmount >= 1e17  && weiAmount <= 5e21 ,"FUNDS should be MIN 0,1 ETH and Max 5000 ETH");
243         }
244         
245         uint256 tokens = _getTokenAmount(weiAmount);
246         
247         if(weiAmount > 50e18){ // greater than 50 eths
248             // 10% extra discount
249             tokens = tokens.add((tokens.mul(10)).div(100));
250         }
251         
252         // update state
253         fundsRaised = fundsRaised.add(weiAmount);
254 
255         _processPurchase(_beneficiary, tokens);
256         emit TokenPurchase(this, _beneficiary, weiAmount, tokens);
257 
258         _forwardFunds(msg.value);
259     }
260     
261         function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{
262         require(_beneficiary != address(0));
263         require(_weiAmount != 0);
264         // require(_weiAmount >= 5e17  && _weiAmount <= 1e21 ,"FUNDS should be MIN 0,5 ETH and Max 1000 ETH");
265     }
266   
267     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
268         uint256 rate;
269         if(privatesaleOpen){
270            rate = 10000; //per wei
271         }
272         else if(presaleOpen){
273             rate = 8000; //per wei
274         }
275         else if(saleOpen){
276             rate = 8000; //per wei
277         }
278         
279         return _weiAmount.mul(rate);
280     }
281     
282     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
283         _transfer(_beneficiary, _tokenAmount);
284     }
285 
286     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
287         _deliverTokens(_beneficiary, _tokenAmount);
288     }
289     
290     function _forwardFunds(uint256 _amount) internal {
291         wallet.transfer(_amount);
292     }
293     
294     function _transfer(address to, uint tokens) internal returns (bool success) {
295         // prevent transfer to 0x0, use burn instead
296         require(to != 0x0);
297         require(balances[this] >= tokens );
298         require(balances[to] + tokens >= balances[to]);
299         balances[this] = balances[this].sub(tokens);
300         balances[to] = balances[to].add(tokens);
301         emit Transfer(this,to,tokens);
302         return true;
303     }
304     
305     function freeTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner{
306        _transfer(_beneficiary, _tokenAmount);
307     }
308     
309     function stopICO() public onlyOwner{
310         Open = false;
311     }
312     
313     function multipleTokensSend (address[] _addresses, uint256[] _values) public onlyOwner{
314         for (uint i = 0; i < _addresses.length; i++){
315             _transfer(_addresses[i], _values[i]*10**uint(decimals));
316         }
317     }
318     
319     function burnRemainingTokens() public onlyOwner{
320         balances[this] = 0;
321     }
322 
323 }