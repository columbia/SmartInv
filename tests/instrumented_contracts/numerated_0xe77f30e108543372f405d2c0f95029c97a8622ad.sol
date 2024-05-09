1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint256);
43     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
45     function transfer(address to, uint256 tokens) public returns (bool success);
46     function approve(address spender, uint256 tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint256 tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
51 }
52 
53 /*
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 */
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and an
98 // initial fixed supply
99 // ----------------------------------------------------------------------------
100 contract StandardToken is ERC20Interface, Owned {
101     using SafeMath for uint256;
102 
103     string public constant symbol = "ast";
104     string public constant name = "AllStocks Token";
105     uint256 public constant decimals = 18;
106     uint256 public _totalSupply;
107 
108     bool public isFinalized;              // switched to true in operational state
109     mapping(address => uint256) balances;
110     mapping(address => mapping(address => uint256)) allowed;
111 
112     mapping(address => uint256) refunds;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function StandardToken() public {
119 
120         //_totalSupply = 1000000 * 10**uint(decimals);
121         //balances[owner] = _totalSupply;
122         //Transfer(address(0), owner, _totalSupply);
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public constant returns (uint256) {
130         return _totalSupply - balances[address(0)];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account `tokenOwner`
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint256 tokens) public returns (bool success) {
148         
149         // Prevent transfer to 0x0 address. Use burn() instead
150         require(to != 0x0);
151         
152         //allow trading in tokens only if sale fhined or by token creator (for bounty program)
153         if (msg.sender != owner)
154             require(isFinalized);
155         
156         balances[msg.sender] = balances[msg.sender].sub(tokens);
157         balances[to] = balances[to].add(tokens);
158         Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces 
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint256 tokens) public returns (bool success) {
171         //allow trading in token only if sale fhined 
172         require(isFinalized);
173 
174         allowed[msg.sender][spender] = tokens;
175         Approval(msg.sender, spender, tokens);
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
189     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
190         //allow trading in token only if sale fhined 
191         require(isFinalized);
192 
193         balances[from] = balances[from].sub(tokens);
194         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
195         balances[to] = balances[to].add(tokens);
196         Transfer(from, to, tokens);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Returns the amount of tokens approved by the owner that can be
203     // transferred to the spender's account
204     // ------------------------------------------------------------------------
205     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
206         //allow trading in token only if sale fhined 
207         require(isFinalized);
208         
209         return allowed[tokenOwner][spender];
210     }
211 
212 }
213 
214 // note introduced onlyPayloadSize in StandardToken.sol to protect against short address attacks
215 
216 contract AllstocksToken is StandardToken {
217     string public version = "1.0";
218 
219     // contracts
220     address public ethFundDeposit;        // deposit address for ETH for Allstocks Fund
221 
222     // crowdsale parameters
223     bool public isActive;                 // switched to true in after setup
224     uint256 public fundingStartTime = 0;
225     uint256 public fundingEndTime = 0;
226     uint256 public allstocksFund = 25 * (10**6) * 10**decimals;     // 25m reserved for Allstocks use
227     uint256 public tokenExchangeRate = 625;                         // 625 Allstocks tokens per 1 ETH
228     uint256 public tokenCreationCap =  50 * (10**6) * 10**decimals; // 50m hard cap
229     
230     //this is for production
231     uint256 public tokenCreationMin =  25 * (10**5) * 10**decimals; // 2.5m minimum
232 
233 
234     // events
235     event LogRefund(address indexed _to, uint256 _value);
236     event CreateAllstocksToken(address indexed _to, uint256 _value);
237 
238     // constructor
239     function AllstocksToken() public {
240       isFinalized = false;                         //controls pre through crowdsale state
241       owner = msg.sender;
242       _totalSupply = allstocksFund;
243       balances[owner] = allstocksFund;             // Deposit Allstocks share
244       CreateAllstocksToken(owner, allstocksFund);  // logs Allstocks fund
245     }
246 
247     function setup (
248         uint256 _fundingStartTime,
249         uint256 _fundingEndTime) onlyOwner external
250     {
251       require (isActive == false); 
252       require (isFinalized == false); 			        	   
253       require (msg.sender == owner);                 // locks finalize to the ultimate ETH owner
254       require (fundingStartTime == 0);              //run once
255       require (fundingEndTime == 0);                //first time 
256       require(_fundingStartTime > 0);
257       require(_fundingEndTime > 0 && _fundingEndTime > _fundingStartTime);
258 
259       isFinalized = false;                          //controls pre through crowdsale state
260       isActive = true;
261       ethFundDeposit = owner;                       // set ETH wallet owner 
262       fundingStartTime = _fundingStartTime;
263       fundingEndTime = _fundingEndTime;
264     }
265 
266     function () public payable {       
267       createTokens(msg.value);
268     }
269 
270     /// @dev Accepts ether and creates new Allstocks tokens.
271     function createTokens(uint256 _value)  internal {
272       require(isFinalized == false);    
273       require(now >= fundingStartTime);
274       require(now < fundingEndTime); 
275       require(msg.value > 0);         
276 
277       uint256 tokens = _value.mul(tokenExchangeRate); // check that we're not over totals
278       uint256 checkedSupply = _totalSupply.add(tokens);
279 
280       require(checkedSupply <= tokenCreationCap);
281 
282       _totalSupply = checkedSupply;
283       balances[msg.sender] += tokens;  // safeAdd not needed
284 
285       //add sent eth to refunds list
286       refunds[msg.sender] = _value.add(refunds[msg.sender]);  // safeAdd 
287 
288       CreateAllstocksToken(msg.sender, tokens);  // logs token creation
289       Transfer(address(0), owner, _totalSupply);
290     }
291 	
292 	//method for manageing bonus phases 
293 	function setRate(uint256 _value) external onlyOwner {
294       require (isFinalized == false);
295       require (isActive == true);
296       require (_value > 0);
297       require(msg.sender == owner); // Allstocks double chack 
298       tokenExchangeRate = _value;
299 
300     }
301 
302     /// @dev Ends the funding period and sends the ETH home
303     function finalize() external onlyOwner {
304       require (isFinalized == false);
305       require(msg.sender == owner); // Allstocks double chack  
306       require(_totalSupply >= tokenCreationMin + allstocksFund);  // have to sell minimum to move to operational
307       require(_totalSupply > 0);
308 
309       if (now < fundingEndTime) {    //if try to close before end time, check that we reach target
310         require(_totalSupply >= tokenCreationCap);
311       }
312       else 
313         require(now >= fundingEndTime);
314       
315 	    // move to operational
316       isFinalized = true;
317       ethFundDeposit.transfer(this.balance);  // send the eth to Allstocks
318     }
319 
320     /// @dev send funding to safe wallet if minimum is reached 
321     function vaultFunds() external onlyOwner {
322       require(msg.sender == owner);            // Allstocks double chack
323       require(_totalSupply >= tokenCreationMin + allstocksFund); // have to sell minimum to move to operational
324       ethFundDeposit.transfer(this.balance);  // send the eth to Allstocks
325     }
326 
327     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
328     function refund() external {
329       require (isFinalized == false);  // prevents refund if operational
330       require (isActive == true);
331       require (now > fundingEndTime); // prevents refund until sale period is over
332      
333       require(_totalSupply < tokenCreationMin + allstocksFund);  // no refunds if we sold enough
334       require(msg.sender != owner); // Allstocks not entitled to a refund
335       
336       uint256 allstocksVal = balances[msg.sender];
337       uint256 ethValRefund = refunds[msg.sender];
338      
339       require(allstocksVal > 0);   
340       require(ethValRefund > 0);  
341      
342       balances[msg.sender] = 0;
343       refunds[msg.sender] = 0;
344       
345       _totalSupply = _totalSupply.sub(allstocksVal); // extra safe
346       
347       uint256 ethValToken = allstocksVal / tokenExchangeRate;     // should be safe; previous throws covers edges
348 
349       require(ethValRefund <= ethValToken);
350       msg.sender.transfer(ethValRefund);                 // if you're using a contract; make sure it works with .send gas limits
351       LogRefund(msg.sender, ethValRefund);               // log it
352     }
353 }