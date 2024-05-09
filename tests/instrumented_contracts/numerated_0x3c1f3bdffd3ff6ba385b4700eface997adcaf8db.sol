1 pragma solidity 0.5.1;
2 
3 // ----------------------------------------------------------------------------
4 // 'HIPHOP' token contract
5 
6 // Symbol      : HIPHOP
7 // Name        : 4hiphop
8 // Total supply: 10000000000 // 100 billion
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33     function remainder(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a % b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public view returns (uint);
46     function balanceOf(address tokenOwner) public view returns (uint balance);
47     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and assisted
89 // token transfers
90 // ----------------------------------------------------------------------------
91 contract HIPHOP is ERC20Interface, Owned {
92     using SafeMath for uint256;
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint256 public _totalSupply;
97     bool    internal Open;
98     
99     mapping(address => uint256) balances;
100     mapping(address => mapping(address => uint256)) allowed;
101     
102     
103     uint256 public hardCap;
104     uint256 public softCap;
105     uint256 public fundsRaised;
106     uint256 internal firststageopeningTime;
107     uint256 internal firststageclosingTime;
108     uint256 internal secondstageopeningTime;
109     uint256 internal secondstageclosingTime;
110     uint256 internal laststageopeningTime;
111     uint256 internal laststageclosingTime;
112     uint256 internal purchasers;
113     address payable wallet;
114     uint256 internal minTx;
115     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
116     
117     modifier onlyWhileOpen {
118         require(Open);
119         _;
120     }
121     
122     // ------------------------------------------------------------------------
123     // Constructor
124     // ------------------------------------------------------------------------
125     constructor(address _owner, address payable _wallet) public {
126         symbol = "HIPHOP";
127         name = "4hiphop";
128         decimals = 18;
129         _totalSupply = 1e11 ; // 100 billion
130         owner = _owner;
131         wallet = _wallet;
132         balances[owner] = totalSupply();
133         Open = true;
134         
135         emit Transfer(address(0),owner, totalSupply());
136         
137         hardCap = 1e7; // 10 million
138         softCap = 0;   // 0
139         _setTimes();
140         minTx = 1 ether;
141     }
142     
143     
144     /** ERC20Interface function's implementation **/
145     
146     function totalSupply() public view returns (uint){
147        return _totalSupply * 1e18; // 100 billion 
148     }
149     
150     // ------------------------------------------------------------------------
151     // Get the token balance for account `tokenOwner`
152     // ------------------------------------------------------------------------
153     function balanceOf(address tokenOwner) public view returns (uint balance) {
154         return balances[tokenOwner];
155     }
156 
157     // ------------------------------------------------------------------------
158     // Transfer the balance from token owner's account to `to` account
159     // - Owner's account must have sufficient balance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transfer(address to, uint tokens) public returns (bool success) {
163         // prevent transfer to 0x0, use burn instead
164         require(address(to) != address(0));
165         require(balances[msg.sender] >= tokens );
166         require(balances[to] + tokens >= balances[to]);
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         emit Transfer(msg.sender,to,tokens);
170         return true;
171         
172     }
173     
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     // ------------------------------------------------------------------------
178     function approve(address spender, uint tokens) public returns (bool success){
179         allowed[msg.sender][spender] = tokens;
180         emit Approval(msg.sender,spender,tokens);
181         return true;
182     }
183 
184     // ------------------------------------------------------------------------
185     // Transfer `tokens` from the `from` account to the `to` account
186     // 
187     // The calling account must already have sufficient tokens approve(...)-d
188     // for spending from the `from` account and
189     // - From account must have sufficient balance to transfer
190     // - Spender must have sufficient allowance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transferFrom(address from, address to, uint tokens) public returns (bool success){
194         require(tokens <= allowed[from][msg.sender]); //check allowance
195         require(balances[from] >= tokens);
196         balances[from] = balances[from].sub(tokens);
197         balances[to] = balances[to].add(tokens);
198         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
199         emit Transfer(from,to,tokens);
200         return true;
201     }
202     
203     // ------------------------------------------------------------------------
204     // Returns the amount of tokens approved by the owner that can be
205     // transferred to the spender's account
206     // ------------------------------------------------------------------------
207     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
208         return allowed[tokenOwner][spender];
209     }
210     
211     function _setTimes() internal {
212         firststageopeningTime    = 1548979200; // 1st FEB 2019      00:00:00 GMT
213         firststageclosingTime    = 1551398400; // 1st MARCH 2019    00:00:00 GMT
214         secondstageopeningTime   = 1554076800; // 1st APR 2019      00:00:00 GMT 
215         secondstageclosingTime   = 1556668800; // 1st MAY 2019      00:00:00 GMT
216         laststageopeningTime     = 1559347200; // 1st JUN 2019      00:00:00 GMT
217         laststageclosingTime     = 1561939200; // 1st JULY 2019     00:00:00 GMT
218         
219     }
220     
221     function burnTokens(address account, uint256 value) public onlyOwner {
222         _burn(account, value);
223     }
224     
225     function pause() public onlyOwner {
226         Open = false;
227     }
228     
229     function unPause() public onlyOwner {
230         Open = true;
231     }
232     
233     /**
234      * @dev Internal function that burns an amount of the token of a given
235      * account.
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burn(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.sub(value);
243         balances[account] = balances[account].sub(value);
244         emit Transfer(account, address(0), value);
245     }
246     
247     function () external payable {
248         buyTokens(msg.sender);
249     }
250 
251     function buyTokens(address _beneficiary) public payable onlyWhileOpen {
252         require(msg.value >= minTx);
253     
254         uint256 weiAmount = msg.value;
255     
256         _preValidatePurchase(_beneficiary, weiAmount);
257         
258         uint256 tokens = _getTokenAmount(weiAmount);
259         
260         tokens = _getBonus(tokens);
261         
262         fundsRaised = fundsRaised.add(weiAmount);
263 
264         _processPurchase(_beneficiary, tokens);
265         emit TokenPurchase(address(this), _beneficiary, weiAmount, tokens);
266         purchasers++;
267         if(tokens != 0){
268             _forwardFunds(msg.value);
269         }
270         else {
271             revert();
272         }
273     }
274     
275     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure{
276         require(_beneficiary != address(0));
277         require(_weiAmount != 0);
278     }
279   
280     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
281         uint256 rate = _getRate(); //per wei 
282         return _weiAmount.mul(rate);
283     }
284     
285     function _getRate() internal view returns (uint256) {
286         uint256 rate;
287         // DURING FIRST STAGE
288         if(now >= firststageopeningTime && now <= firststageclosingTime) { 
289             rate = 1205; // 10 CENTS = USD 120
290         } 
291         // DURING SECOND STAGE
292         else if (now >= secondstageopeningTime && now <= secondstageclosingTime) {
293             rate = 240; // 50 CENTS = usd 120
294         } 
295         // DURING LAST STAGE
296         else if (now >= laststageopeningTime && now <= laststageclosingTime) {
297             rate = 120; // 1 dollar = usd 120
298         }
299         
300         return rate;
301     }
302     
303     function _getBonus(uint256 tokens) internal view returns (uint256) {
304         if(purchasers <= 1000){
305             // give 50% bonus
306             tokens = tokens.add((tokens.mul(50)).div(100));
307         }
308         return tokens;
309     }
310     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
311         _transfer(_beneficiary, _tokenAmount);
312     }
313         function _transfer(address to, uint tokens) internal returns (bool success) {
314         // prevent transfer to 0x0, use burn instead
315         require(to != address(0));
316         require(balances[address(this)] >= tokens );
317         require(balances[to] + tokens >= balances[to]);
318         balances[address(this)] = balances[address(this)].sub(tokens);
319         balances[to] = balances[to].add(tokens);
320         emit Transfer(address(this),to,tokens);
321         return true;
322     }
323 
324     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
325         _deliverTokens(_beneficiary, _tokenAmount);
326     }
327     
328     function _forwardFunds(uint256 _amount) internal {
329         wallet.transfer(_amount);
330     }
331     
332 }