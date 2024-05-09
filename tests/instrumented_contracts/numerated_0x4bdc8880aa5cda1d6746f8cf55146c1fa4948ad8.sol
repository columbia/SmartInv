1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51   
52 }
53 
54 contract SSTXCOIN {
55     
56     using SafeMath for uint256;
57 
58     string public name      = "Speed Shopper Token";                                    // Token name
59     string public symbol    = "SSTX";                                                   // Token symbol
60     uint256 public decimals = 18;                                                       // Token decimal points
61     uint256 private _totalSupply = 500000000;                                           // Token total supply
62     uint256 public totalSupply  = _totalSupply.mul(10 ** uint256(decimals));            // Token total supply with decimals
63     
64     
65     // Balances for each account
66     mapping (address => uint256) public balances;
67     
68     // Owner of account approves the transfer of an amount to another account
69     mapping (address => mapping (address => uint256)) public allowance;
70 
71 
72     // event to 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 
76     // contract constructor
77     constructor() public {
78         balances[0xa6052FB9334942A7e3B21c55f95af973B6b12918] = totalSupply;
79     }
80     
81     // Transfer the balance from owner's account to another account
82     function transfer(address _to, uint256 _value) public  returns (bool success) {
83         require(_to != address(0));
84         require(balances[msg.sender] >= _value);
85         require(balances[_to].add(_value) >= balances[_to]);
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         emit Transfer(msg.sender, _to, _value);
89         return true;
90     }
91     
92     // function to get the balance of a specific address
93     function balanceOf(address _address) public view returns (uint256 balance) {
94         // Return the balance for the specific address
95         return balances[_address];
96     }
97 
98     // Send `tokens` amount of tokens from address `from` to address `to`
99     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
100     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
101     // fees in sub-currencies; the command should fail unless the _from account has
102     // deliberately authorized the sender of the message via some mechanism; we propose
103     // these standardized APIs for approval:
104     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
105         require(_from != address(0) && _to != address(0));
106         require(balances[_from] >= _value);
107         require(balances[_to].add(_value) >= balances[_to]);
108         require(allowance[_from][msg.sender] >= _value);
109         balances[_to] = balances[_to].add(_value);
110         balances[_from] = balances[_from].sub(_value);
111         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
112         emit Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
117     // If this function is called again it overwrites the current allowance with _value.
118     function approve(address _spender, uint256 _value) public  returns (bool success) {
119         require(_spender != address(0));
120         require(_value <= balances[msg.sender]);
121         require(_value == 0 || allowance[msg.sender][_spender] == 0);
122         allowance[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127 
128 }
129 
130 contract SpeedShopper is SSTXCOIN {
131     
132     using SafeMath for uint256;
133     
134     // SSTXCOIN TokenAddress  = SSTXCOIN(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
135     
136     // variable to start and stop ico
137     bool public stopped = false;
138     uint public minEth  = 0.2 ether;
139 
140     // contract owner
141     address public owner;
142     
143     // wallet address ethereum will going
144     address public wallet;
145     
146     // number token we are going to provide in one ethereum
147     uint256 public tokenPerEth = 2500;
148     
149     // struct to set ico stage detail
150     struct icoData {
151         uint256 icoStage;
152         uint256 icoStartDate;
153         uint256 icoEndDate;
154         uint256 icoFund;
155         uint256 icoBonus;
156         uint256 icoSold;
157     }
158     
159     // ico struct alias
160     icoData public ico;
161 
162 
163     // modifier to check sender is owner ot not
164     modifier isOwner {
165         assert(owner == msg.sender);
166         _;
167     }
168 
169     // modifier to check ico is running ot not
170     modifier isRunning {
171         assert (!stopped);
172         _;
173     }
174 
175     // modifier to check ico is stopped ot not
176     modifier isStopped {
177         assert (stopped);
178         _;
179     }
180 
181     // modifier to check sender is valid or not
182     modifier validAddress {
183         assert(0x0 != msg.sender);
184         _;
185     }
186 
187     // contract constructor
188     constructor() public {
189         
190         wallet = 0xa6052FB9334942A7e3B21c55f95af973B6b12918;
191         owner = 0xa6052FB9334942A7e3B21c55f95af973B6b12918;
192     }
193     
194     function() payable public   {
195         //revert if any ethereum  sent
196         revert();
197     }
198 
199     // payable to send tokens who is paying to the contract
200     function participate() payable public isRunning validAddress  {
201         
202         // sender must send atleast 0.02 ETH
203         require(msg.value > minEth);
204         // check for ico is active or not
205         require(now >= ico.icoStartDate && now <= ico.icoEndDate );
206 
207         // calculate the tokens amount
208         uint tokens = msg.value * tokenPerEth;
209         // calculate the bounus
210         uint bonus  = ( tokens.mul(ico.icoBonus) ).div(100);
211         // add the bonus tokens to actual token amount
212         uint total  = tokens + bonus;
213 
214         // ico must have the fund to send
215         require(ico.icoFund >= total);
216         // contract must have the balance to send
217         require(balanceOf(address(this)) >= total);
218         
219         // sender's new balance must be greate then old balance
220         require(balanceOf(msg.sender).add(total) >= balanceOf(msg.sender));
221         
222         // update ico fund and sold token count
223         ico.icoFund      = ico.icoFund.sub(total);
224         ico.icoSold      = ico.icoSold.add(total);
225         
226         // send the tokens from contract to msg.sender
227       
228         transfer(msg.sender, total);
229         
230         // transfer ethereum to the withdrawal address
231         wallet.transfer( msg.value );
232         
233     }
234     
235     // set new ico stage
236     function setStage(uint256 _stage, uint256 _startDate, uint256 _endDate, uint256 _fund, uint256 _bonus) external isOwner returns(bool) {
237         
238         // current time must be greater then previous ico stage end time
239         //require(now > ico.icoEndDate);
240         // current stage must be greater then previous ico stage 
241         //require(_stage > ico.icoStage);
242         // current time must be less then start new ico time
243         require(now < _startDate);
244         // new ico start time must be less then new ico stage end date
245         require(_startDate < _endDate);
246         // owner must have fund to start the ico stage
247         require(balanceOf(msg.sender) >= _fund);
248         
249         // calculate the token
250         uint tokens = _fund;
251         
252         // set ico data
253         ico.icoStage        = _stage;
254         ico.icoStartDate    = _startDate;
255         ico.icoEndDate      = _endDate;
256         ico.icoFund         = tokens;
257         ico.icoBonus        = _bonus;
258         ico.icoSold         = 0;
259         
260         // transfer tokens to the contract
261         //need to call allowance on the owner account approve(address ICO ADDRESS, uint256 _value)
262         
263         transferFrom(msg.sender, address(this), tokens);
264         
265         return true;
266     }
267     
268     // set withdrawal wallet address
269     function setWithdrawalWallet(address _newWallet) external isOwner {
270         
271         // new and old address should not be same
272         require( _newWallet != wallet );
273         // new balance is valid or not
274         require( _newWallet != address(0) );
275         
276         // set new withdrawal wallet
277         wallet = _newWallet;
278         
279     }
280 
281     // function to get back the token from contract to owner
282     function withdrawTokens(address _address, uint256 _value) external isOwner validAddress {
283         
284         // check for valid address
285         require(_address != address(0) && _address != address(this));
286         
287         // calculate the tokens
288         uint256 tokens = _value * 10 ** uint256(18);
289         
290         // check contract have the sufficient balance
291         require(balanceOf(address(this)) > tokens);
292         
293         // check for valid value of value params
294         require(balanceOf(_address) < balanceOf(_address).add(tokens));
295         
296         // send the tokens
297         transfer(_address, tokens);
298         
299     }
300     
301     // pause the ICO
302     function pauseICO() external isOwner isRunning {
303         stopped = true;
304     }
305     
306     // resume the ICO
307     function resumeICO() external isOwner isStopped {
308         stopped = false;
309     }
310     
311 }