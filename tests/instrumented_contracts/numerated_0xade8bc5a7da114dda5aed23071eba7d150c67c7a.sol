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
71     uint public minEth  = 0.2 ether;
72 
73     // contract owner
74     address public owner;
75     
76     // wallet address ethereum will going
77     address public wallet = 0xDb78138276E9401C908268E093A303f440733f1E;
78     
79     // number token we are going to provide in one ethereum
80     uint256 public tokenPerEth = 5000;
81 
82     // struct to set ico stage detail
83     struct icoData {
84         uint256 icoStage;
85         uint256 icoStartDate;
86         uint256 icoEndDate;
87         uint256 icoFund;
88         uint256 icoBonus;
89         uint256 icoSold;
90     }
91     
92     // ico struct alias
93     icoData public ico;
94 
95     // modifier to check sender is owner ot not
96     modifier isOwner {
97         assert(owner == msg.sender);
98         _;
99     }
100 
101     // modifier to check ico is running ot not
102     modifier isRunning {
103         assert (!stopped);
104         _;
105     }
106 
107     // modifier to check ico is stopped ot not
108     modifier isStopped {
109         assert (stopped);
110         _;
111     }
112 
113     // modifier to check sender is valid or not
114     modifier validAddress {
115         assert(0x0 != msg.sender);
116         _;
117     }
118 
119     // contract constructor
120     constructor(address _owner) public {
121         require( _owner != address(0) );
122         owner = _owner;
123         balances[owner] = totalSupply;
124         emit Transfer(0x0, owner, totalSupply);
125     }
126     
127     // function to get the balance of a specific address
128     function balanceOf(address _address) public view returns (uint256 balance) {
129         // Return the balance for the specific address
130         return balances[_address];
131     }
132 
133     // Transfer the balance from owner's account to another account
134     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
135         require(_to != address(0));
136         require(balances[msg.sender] >= _value);
137         require(balances[_to].add(_value) >= balances[_to]);
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         emit Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     // Send `tokens` amount of tokens from address `from` to address `to`
145     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
146     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
147     // fees in sub-currencies; the command should fail unless the _from account has
148     // deliberately authorized the sender of the message via some mechanism; we propose
149     // these standardized APIs for approval:
150     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
151         require(_from != address(0) && _to != address(0));
152         require(balances[_from] >= _value);
153         require(balances[_to].add(_value) >= balances[_to]);
154         require(allowance[_from][msg.sender] >= _value);
155         balances[_to] = balances[_to].add(_value);
156         balances[_from] = balances[_from].sub(_value);
157         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
158         emit Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
163     // If this function is called again it overwrites the current allowance with _value.
164     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
165         require(_spender != address(0));
166         require(_value <= balances[msg.sender]);
167         require(_value == 0 || allowance[msg.sender][_spender] == 0);
168         allowance[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     // set new ico stage
174     function setStage(uint256 _stage, uint256 _startDate, uint256 _endDate, uint256 _fund, uint256 _bonus) external isOwner returns(bool) {
175         
176         // current time must be greater then previous ico stage end time
177         require(now > ico.icoEndDate);
178         // current stage must be greater then previous ico stage 
179         require(_stage > ico.icoStage);
180         // current time must be less then start new ico time
181         require(now < _startDate);
182         // new ico start time must be less then new ico stage end date
183         require(_startDate < _endDate);
184         // owner must have fund to start the ico stage
185         require(balances[msg.sender] >= _fund);
186         
187         //  calculate the token
188         uint tokens = _fund * (10 ** uint256(decimals));
189         
190         // set ico data
191         ico.icoStage        = _stage;
192         ico.icoStartDate    = _startDate;
193         ico.icoEndDate      = _endDate;
194         ico.icoFund         = tokens;
195         ico.icoBonus        = _bonus;
196         ico.icoSold         = 0;
197         
198         // transfer tokens to the contract
199         transfer( address(this), tokens );
200         
201         return true;
202     }
203     
204     // set withdrawal wallet address
205     function setWithdrawalWallet(address _newWallet) external isOwner {
206         
207         // new and old address should not be same
208         require( _newWallet != wallet );
209         // new balance is valid or not
210         require( _newWallet != address(0) );
211         
212         // set new withdrawal wallet
213         wallet = _newWallet;
214         
215     }
216 
217     // payable to send tokens who is paying to the contract
218     function() payable public isRunning validAddress  {
219         
220         // sender must send atleast 0.02 ETH
221         require(msg.value >= minEth);
222         // check for ico is active or not
223         require(now >= ico.icoStartDate && now <= ico.icoEndDate );
224 
225         // calculate the tokens amount
226         uint tokens = msg.value * tokenPerEth;
227         // calculate the bounus
228         uint bonus  = ( tokens.mul(ico.icoBonus) ).div(100);
229         // add the bonus tokens to actual token amount
230         uint total  = tokens + bonus;
231 
232         // ico must have the fund to send
233         require(ico.icoFund >= total);
234         // contract must have the balance to send
235         require(balances[address(this)] >= total);
236         // sender's new balance must be greate then old balance
237         require(balances[msg.sender].add(total) >= balances[msg.sender]);
238         
239         // update ico fund and sold token count
240         ico.icoFund      = ico.icoFund.sub(total);
241         ico.icoSold      = ico.icoSold.add(total);
242         
243         // send the tokens from contract to msg.sender
244         _sendTokens(address(this), msg.sender, total);
245         
246         // transfer ethereum to the withdrawal address
247         wallet.transfer( msg.value );
248         
249     }
250     
251     // function to get back the token from contract to owner
252     function withdrawTokens(address _address, uint256 _value) external isOwner validAddress {
253         
254         // check for valid address
255         require(_address != address(0) && _address != address(this));
256         
257         // calculate the tokens
258         uint256 tokens = _value * 10 ** uint256(decimals);
259         
260         // check contract have the sufficient balance
261         require(balances[address(this)] > tokens);
262         
263         // check for valid value of value params
264         require(balances[_address] < balances[_address].add(tokens));
265         
266         // send the tokens
267         _sendTokens(address(this), _address, tokens);
268         
269     }
270     
271     function _sendTokens(address _from, address _to, uint256 _tokens) internal {
272         
273          // deduct contract balance
274         balances[_from] = balances[_from].sub(_tokens);
275         // add balanc to the sender
276         balances[_to] = balances[_to].add(_tokens);
277         // call the transfer event
278         emit Transfer(_from, _to, _tokens);
279         
280     }
281 
282     // event to 
283     event Transfer(address indexed _from, address indexed _to, uint256 _value);
284     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
285 }