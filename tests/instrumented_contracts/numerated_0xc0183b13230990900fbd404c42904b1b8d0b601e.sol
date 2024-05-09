1 pragma solidity "0.5.1";
2 
3 /* =========================================================================================================*/
4 // ----------------------------------------------------------------------------
5 // 'eden.best' token contract
6 //
7 // Symbol      : EDE
8 // Name        : eden.best
9 // Total supply: 450000000
10 // Decimals    : 0
11 // ----------------------------------------------------------------------------
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
33 }
34 
35 // ----------------------------------------------------------------------------
36 // Owned contract
37 // ----------------------------------------------------------------------------
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 
60 // ----------------------------------------------------------------------------
61 // ERC Token Standard #20 Interface
62 // ----------------------------------------------------------------------------
63 contract ERC20Interface {
64     function totalSupply() public view returns (uint);
65     function balanceOf(address tokenOwner) public view returns (uint balance);
66     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
67     function transfer(address to, uint tokens) public returns (bool success);
68     function approve(address spender, uint tokens) public returns (bool success);
69     function transferFrom(address from, address to, uint tokens) public returns (bool success);
70 
71     event Transfer(address indexed from, address indexed to, uint tokens);
72     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
73 }
74 
75 // ----------------------------------------------------------------------------
76 // ERC20 Token, with the addition of symbol, name and decimals and assisted
77 // token transfers
78 // ----------------------------------------------------------------------------
79 contract EDE is ERC20Interface, Owned {
80     using SafeMath for uint;
81 
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86     uint private _teamsTokens;
87     uint private _reserveTokens;
88     uint256 public fundsRaised;
89     uint private maximumCap;
90     address payable wallet;
91     address [] holders;
92 
93     uint256 private presaleopeningtime;
94     uint256 private firstsaleopeningtime;
95     uint256 private secondsaleopeningtime;
96     uint256 private secondsaleclosingtime;
97 
98 	string public HardCap;
99 	string public SoftCap;
100 
101 
102     mapping(address => uint) balances;
103     mapping(address => bool) whitelist;
104     mapping(address => mapping(address => uint)) allowed;
105 
106     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
107 
108     modifier onlyWhileOpen {
109         require((now >= presaleopeningtime && now <= secondsaleclosingtime) && fundsRaised != maximumCap); // should be open
110         _;
111     }
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "EDE";
118         name = "eden.best";
119         decimals = 0;
120         _totalSupply = 45e7;
121         balances[address(this)] = 3375e5 * 10**uint(decimals); // 75% to ICO
122         emit Transfer(address(0),address(this), 3375e5 * 10**uint(decimals));
123         balances[address(0x687abe81c44c982394EED1b0Fc6911e5338A6421)] = 66150000 * 10**uint(decimals); // 14,7% to reserve
124         emit Transfer(address(0),address(0x687abe81c44c982394EED1b0Fc6911e5338A6421), 66150000 * 10**uint(decimals));
125         balances[address(0xd903846cF43aC9046CAE50C36ac1Aa18e630A1bB)] = 45000000 * 10**uint(decimals); // 10% to Team
126         emit Transfer(address(0),address(0xd903846cF43aC9046CAE50C36ac1Aa18e630A1bB), 45000000 * 10**uint(decimals));
127         balances[address(0x7341459eCdABC42C7493D923F5bb0992616d30A7)] = 1350000 * 10**uint(decimals); // 0,3% to airdrop
128         emit Transfer(address(0),address(0x7341459eCdABC42C7493D923F5bb0992616d30A7), 1350000 * 10**uint(decimals));
129         owner = address(0xEfA2CcE041aEB143678F8f310F3977F3EB61251E);
130         wallet = address(0xEfA2CcE041aEB143678F8f310F3977F3EB61251E);
131 		    HardCap = "16875 ETH";
132         SoftCap = "300 ETH";
133         maximumCap = 16875000000000000000000; // 16875 eth, written in wei here
134         presaleopeningtime = 1554120000; // 1st april 2019, 12pm
135         firstsaleopeningtime = 1555329601; // 15 april 2019, 12:00:01pm
136         secondsaleopeningtime = 1559304001; // 31 may 2019, 12:00:01pm
137         secondsaleclosingtime = 1561896001; // 30 june 2019, 12:00:01pm
138     }
139 
140     // ------------------------------------------------------------------------
141     // Accepts ETH
142     // ------------------------------------------------------------------------
143     function () external payable {
144         buyTokens(msg.sender);
145     }
146 
147     function buyTokens(address _beneficiary) public payable onlyWhileOpen {
148         _preValidatePurchase(_beneficiary, msg.value);
149         _continueTokenPurchase(_beneficiary, msg.value);
150     }
151 
152     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view{
153         require(_beneficiary != address(0));
154         require(_weiAmount != 0);
155         require(_weiAmount >= 50000000000000000 && _weiAmount <= 1000000000000000000000); // min 0.05 ETH, max 1000 ETH
156         require(whitelist[_beneficiary]);
157     }
158 
159     function _insertWhitelist(address[] memory _beneficiary) public onlyOwner{
160         for(uint256 i = 0; i< _beneficiary.length; i++)
161         {
162             if(whitelist[_beneficiary[i]] == false)
163                 whitelist[_beneficiary[i]] = true;
164         }
165     }
166 
167     function _continueTokenPurchase(address _beneficiary, uint256 _weiAmount) internal{
168         uint256 _tokens = _getTokenAmount(_weiAmount).div(1e18);
169         uint256 bonus = _calculateBonus();
170         _tokens = _tokens.add((_tokens.mul(bonus.mul(100))).div(10000));
171 
172         fundsRaised = fundsRaised.add(_weiAmount);
173 
174         _processPurchase(_beneficiary, _tokens);
175 
176         wallet.transfer(_weiAmount);
177         emit TokenPurchase(address(this), _beneficiary, _weiAmount, _tokens);
178     }
179 
180     function _getTokenAmount(uint256 _weiAmount) internal pure returns (uint256) {
181         uint256 rate = 2e4; // 1 eth = 20,000T
182         return _weiAmount.mul(rate);
183     }
184 
185     function _calculateBonus() internal view returns (uint256){
186         if(now >= presaleopeningtime && now < firstsaleopeningtime){
187             return 30;
188         } else if(now >=firstsaleopeningtime && now <secondsaleopeningtime){
189             return 20;
190         } else if(now >= secondsaleopeningtime && now <secondsaleclosingtime){
191             return 0;
192         }
193     }
194 
195     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
196         _deliverTokens(_beneficiary, _tokenAmount);
197     }
198 
199     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
200         _transfer(_beneficiary, _tokenAmount);
201     }
202 
203     /*===========================================================*/
204 
205     function totalSupply() public view returns (uint){
206        return _totalSupply* 10**uint(decimals);
207     }
208     // ------------------------------------------------------------------------
209     // Get the token balance for account `tokenOwner`
210     // ------------------------------------------------------------------------
211     function balanceOf(address tokenOwner) public view returns (uint balance) {
212         return balances[tokenOwner];
213     }
214 
215     // ------------------------------------------------------------------------
216     // Transfer the balance from token owner's account to `to` account
217     // - Owner's account must have sufficient balance to transfer
218     // - 0 value transfers are allowed
219     // ------------------------------------------------------------------------
220     function transfer(address to, uint tokens) public returns (bool success) {
221         // prevent transfer to 0x0, use burn instead
222         require(to != address(0));
223         require(whitelist[to]);
224         require(balances[msg.sender] >= tokens );
225         require(balances[to] + tokens >= balances[to]);
226         balances[msg.sender] = balances[msg.sender].sub(tokens);
227         if(balances[to] == 0)
228             holders.push(to);
229         balances[to] = balances[to].add(tokens);
230         emit Transfer(msg.sender,to,tokens);
231         return true;
232     }
233 
234     // ------------------------------------------------------------------------
235     // Token owner can approve for `spender` to transferFrom(...) `tokens`
236     // from the token owner's account
237     // ------------------------------------------------------------------------
238     function approve(address spender, uint tokens) public returns (bool success){
239         allowed[msg.sender][spender] = tokens;
240         emit Approval(msg.sender,spender,tokens);
241         return true;
242     }
243 
244     // ------------------------------------------------------------------------
245     // Transfer `tokens` from the `from` account to the `to` account
246     //
247     // The calling account must already have sufficient tokens approve(...)-d
248     // for spending from the `from` account and
249     // - From account must have sufficient balance to transfer
250     // - Spender must have sufficient allowance to transfer
251     // - 0 value transfers are allowed
252     // ------------------------------------------------------------------------
253     function transferFrom(address from, address to, uint tokens) public returns (bool success){
254         require(tokens <= allowed[from][msg.sender]); //check allowance
255         require(balances[from] >= tokens);
256         require(whitelist[to]);
257         balances[from] = balances[from].sub(tokens);
258         if(balances[to] == 0)
259             holders.push(to);
260         balances[to] = balances[to].add(tokens);
261         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
262         emit Transfer(from,to,tokens);
263         return true;
264     }
265     // ------------------------------------------------------------------------
266     // Returns the amount of tokens approved by the owner that can be
267     // transferred to the spender's account
268     // ------------------------------------------------------------------------
269     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
270         return allowed[tokenOwner][spender];
271     }
272 
273     function _transfer(address to, uint tokens) internal returns (bool success) {
274         // prevent transfer to 0x0, use burn instead
275         require(to != address(0));
276         require(balances[address(this)] >= tokens );
277         require(balances[to] + tokens >= balances[to]);
278         balances[address(this)] = balances[address(this)].sub(tokens);
279         if(balances[to] == 0)
280             holders.push(to);
281         balances[to] = balances[to].add(tokens);
282         emit Transfer(address(this),to,tokens);
283         return true;
284     }
285 
286     function _hardCapNotReached() external onlyOwner {
287         uint eightyPercent = (balances[address(this)].mul(80)).div(100); // 80% of remaining tokens
288         uint twentyPercent = balances[address(this)].sub(eightyPercent); // 20% of remaining tokens
289         uint share = eightyPercent.div(holders.length);
290 
291         for(uint i = 0; i<holders.length; i++ ){
292             address holder = holders[i];
293             balances[holder] = balances[holder].add(share);
294             emit Transfer(address(this),holder,share);
295         }
296 
297         balances[address(0x687abe81c44c982394EED1b0Fc6911e5338A6421)] = twentyPercent;
298         emit Transfer(address(this),address(0x687abe81c44c982394EED1b0Fc6911e5338A6421),twentyPercent);
299 
300         balances[address(this)] = 0;
301 
302 
303 
304     }
305 }