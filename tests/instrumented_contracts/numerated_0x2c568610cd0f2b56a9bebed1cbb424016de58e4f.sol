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
54 contract TIZACOIN {
55     
56     using SafeMath for uint256;
57 
58     string public name      = "TIZACOIN";                                   // Token name
59     string public symbol    = "TIZA";                                       // Token symbol
60     uint256 public decimals = 18;                                           // Token decimal points
61     uint256 public totalSupply  = 50000000 * (10 ** uint256(decimals));     // Token total supply
62 
63     // Balances for each account
64     mapping (address => uint256) public balances;
65     
66     // Owner of account approves the transfer of an amount to another account
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // variable to start and stop ico
70     bool public stopped = false;
71 
72     // contract owner
73     address public owner;
74     
75     // wallet address ethereum will going
76     address public wallet = 0xAFe8D7B071298DD6170b94dcC5B5822Bf4f94980;
77     
78     // number token we are going to provide in one ethereum
79     uint256 public tokenPerEth = 5000;
80 
81     // struct to set ico stage detail
82     struct icoData {
83         uint256 icoStage;
84         uint256 icoStartDate;
85         uint256 icoEndDate;
86         uint256 icoFund;
87         uint256 icoBonus;
88         uint256 icoSold;
89     }
90     
91     // ico struct alias
92     icoData public ico;
93 
94     // modifier to check sender is owner ot not
95     modifier isOwner {
96         assert(owner == msg.sender);
97         _;
98     }
99 
100     // modifier to check ico is running ot not
101     modifier isRunning {
102         assert (!stopped);
103         _;
104     }
105 
106     // modifier to check ico is stopped ot not
107     modifier isStopped {
108         assert (stopped);
109         _;
110     }
111 
112     // modifier to check sender is valid or not
113     modifier validAddress {
114         assert(0x0 != msg.sender);
115         _;
116     }
117 
118     // contract constructor
119     constructor(address _owner) public {
120         require( _owner != address(0), "Invalid owner address." );
121         owner = _owner;
122         balances[owner] = totalSupply;
123         emit Transfer(0x0, owner, totalSupply);
124     }
125     
126     // function to get the balance of a specific address
127     function balanceOf(address _address) public view returns (uint256 balance) {
128         // Return the balance for the specific address
129         return balances[_address];
130     }
131 
132     // Transfer the balance from owner's account to another account
133     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
134         require(_to != address(0), "Invalid receive address.");
135         require(balances[msg.sender] >= _value, "Insufficient amount.");
136         require(balances[_to].add(_value) >= balances[_to], "Invalid token input.");
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         emit Transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     // Send `tokens` amount of tokens from address `from` to address `to`
144     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
145     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
146     // fees in sub-currencies; the command should fail unless the _from account has
147     // deliberately authorized the sender of the message via some mechanism; we propose
148     // these standardized APIs for approval:
149     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
150         require(_from != address(0) && _to != address(0), "Invalid address.");
151         require(balances[_from] >= _value, "Insufficient balance.");
152         require(balances[_to].add(_value) >= balances[_to], "Invalid token input.");
153         require(allowance[_from][msg.sender] >= _value, "Allowed amount less then token amount.");
154         balances[_to] = balances[_to].add(_value);
155         balances[_from] = balances[_from].sub(_value);
156         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
162     // If this function is called again it overwrites the current allowance with _value.
163     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
164         require(_spender != address(0), "Invalid address.");
165         require(_value <= balances[msg.sender], "Insufficient balance.");
166         require(_value == 0 || allowance[msg.sender][_spender] == 0, "Invalid token input.");
167         allowance[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     // set new ico stage
173     function setStage(uint256 _stage, uint256 _startDate, uint256 _endDate, uint256 _fund, uint256 _bonus) external isOwner returns(bool) {
174         
175         // current time must be less then start new ico time
176         require(now < _startDate, "ICO Start time must be greater then current time.");
177         // current time must be greater then previous ico stage end time
178         require(now > ico.icoEndDate, "ICO end time must be greater then current time.");
179         // current stage must be greater then previous ico stage 
180         require(_stage > ico.icoStage, "Invalid stage number.");
181         // new ico start time must be less then new ico stage end date
182         require(_startDate < _endDate, "End time must be greater then start time.");
183         // owner must have fund to start the ico stage
184         require(balances[msg.sender] >= _fund, "Insufficient amount to set stage.");
185         
186         //  calculate the token
187         uint tokens = _fund * (10 ** uint256(decimals));
188         
189         // set ico data
190         ico.icoStage        = _stage;
191         ico.icoStartDate    = _startDate;
192         ico.icoEndDate      = _endDate;
193         ico.icoFund         = tokens;
194         ico.icoBonus        = _bonus;
195         ico.icoSold         = 0;
196         
197         // transfer tokens to the contract
198         transfer( address(this), tokens );
199         
200         return true;
201     }
202     
203     // set withdrawal wallet address
204     function setWithdrawalWallet(address _newWallet) external isOwner {
205         
206         // new and old address should not be same
207         require( _newWallet != wallet, "New wallet address can not be same as old address." );
208         // new balance is valid or not
209         require( _newWallet != address(0), "New wallet address can not be empty." );
210         
211         // set new withdrawal wallet
212         wallet = _newWallet;
213         
214     }
215 
216     // payable to send tokens who is paying to the contract
217     function() payable public isRunning validAddress  {
218         
219         // check for ico is active or not
220         require(now >= ico.icoStartDate && now <= ico.icoEndDate, "ICO not active." );
221 
222         // calculate the tokens amount
223         uint tokens = msg.value * tokenPerEth;
224         // calculate the bounus
225         uint bonus  = ( tokens.mul(ico.icoBonus) ).div(100);
226         // add the bonus tokens to actual token amount
227         uint total  = tokens + bonus;
228 
229         // ico must have the fund to send
230         require(ico.icoFund >= total, "ICO doesn't have sufficient balance.");
231         // contract must have the balance to send
232         require(balances[address(this)] >= total, "Contact doesn't have sufficient balance.");
233         // sender's new balance must be greate then old balance
234         require(balances[msg.sender].add(total) >= balances[msg.sender], "Invalid token input.");
235         
236         // update ico fund and sold token count
237         ico.icoFund      = ico.icoFund.sub(total);
238         ico.icoSold      = ico.icoSold.add(total);
239         
240         // send the tokens from contract to msg.sender
241         _sendTokens(address(this), msg.sender, total);
242         
243         // transfer ethereum to the withdrawal address
244         wallet.transfer( msg.value );
245         
246     }
247     
248     // function to get back the token from contract to owner
249     function withdrawTokens(address _address, uint256 _value) external isOwner validAddress {
250         
251         // check for valid address
252         require(_address != address(0) && _address != address(this), "Withdrawal address is not valid.");
253         
254         // calculate the tokens
255         uint256 tokens = _value * 10 ** uint256(decimals);
256         
257         // check contract have the sufficient balance
258         require(balances[address(this)] > tokens, "Contact doesn't have sufficient balance.");
259         
260         // check for valid value of value params
261         require(balances[_address] < balances[_address].add(tokens), "Invalid token input.");
262         
263         // send the tokens
264         _sendTokens(address(this), _address, tokens);
265         
266     }
267     
268     function _sendTokens(address _from, address _to, uint256 _tokens) internal {
269         
270          // deduct contract balance
271         balances[_from] = balances[_from].sub(_tokens);
272         // add balanc to the sender
273         balances[_to] = balances[_to].add(_tokens);
274         // call the transfer event
275         emit Transfer(_from, _to, _tokens);
276         
277     }
278 
279     // event to 
280     event Transfer(address indexed _from, address indexed _to, uint256 _value);
281     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
282 }