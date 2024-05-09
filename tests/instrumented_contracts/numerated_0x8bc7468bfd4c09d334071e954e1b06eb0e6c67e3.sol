1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ContractReceiver{
35     function tokenFallback(address _from, uint256 _value, bytes  _data) external;
36 }
37 
38 
39 //Basic ERC23 token, backward compatible with ERC20 transfer function.
40 //Based in part on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
41 contract ERC23BasicToken {
42     using SafeMath for uint256;
43     uint256 public totalSupply;
44     mapping(address => uint256) balances;
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
47 
48     function tokenFallback(address _from, uint256 _value, bytes  _data) external {
49         throw;
50     }
51 
52     function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
53 
54         //Standard ERC23 transfer function
55 
56         if(isContract(_to)) {
57             transferToContract(_to, _value, _data);
58         }
59         else {
60             transferToAddress(_to, _value, _data);
61         }
62         return true;
63     }
64 
65     function transfer(address _to, uint256 _value) {
66 
67         //standard function transfer similar to ERC20 transfer with no _data
68         //added due to backwards compatibility reasons
69 
70         bytes memory empty;
71         if(isContract(_to)) {
72             transferToContract(_to, _value, empty);
73         }
74         else {
75             transferToAddress(_to, _value, empty);
76         }
77     }
78 
79     function transferToAddress(address _to, uint256 _value, bytes _data) internal {
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         Transfer(msg.sender, _to, _value, _data);
84     }
85 
86     function transferToContract(address _to, uint256 _value, bytes _data) internal {
87         balances[msg.sender] = balances[msg.sender].sub( _value);
88         balances[_to] = balances[_to].add( _value);
89         ContractReceiver receiver = ContractReceiver(_to);
90         receiver.tokenFallback(msg.sender, _value, _data);
91         Transfer(msg.sender, _to, _value);
92         Transfer(msg.sender, _to, _value, _data);
93     }
94 
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
100     function isContract(address _addr) returns (bool is_contract) {
101           uint256 length;
102           assembly {
103               //retrieve the size of the code on target address, this needs assembly
104               length := extcodesize(_addr)
105           }
106           if(length>0) {
107               return true;
108           }
109           else {
110               return false;
111           }
112     }
113 }
114 
115 // Standard ERC23 token, backward compatible with ERC20 standards.
116 // Based on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
117 contract ERC23StandardToken is ERC23BasicToken {
118     mapping (address => mapping (address => uint256)) allowed;
119     event Approval (address indexed owner, address indexed spender, uint256 value);
120 
121     function transferFrom(address _from, address _to, uint256 _value) {
122         var _allowance = allowed[_from][msg.sender];
123 
124         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125         // if (_value > _allowance) throw;
126 
127         balances[_to] = balances[_to].add(_value);
128         balances[_from] = balances[_from].sub(_value);
129         allowed[_from][msg.sender] = _allowance.sub(_value);
130         Transfer(_from, _to, _value);
131     }
132 
133     function approve(address _spender, uint256 _value) {
134 
135         // To change the approve amount you first have to reduce the addresses`
136         //  allowance to zero by calling `approve(_spender, 0)` if it is not
137         //  already 0 to mitigate the race condition described here:
138         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
140 
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143     }
144 
145     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 }
149 
150 // Based in part on code by Open-Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
151 // Based in part on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152 
153 contract STRIMToken is ERC23StandardToken {
154 
155     // metadata
156     string public constant name = "STRIM Token";
157     string public constant symbol = "STR";
158     uint256 public constant decimals = 18;
159     string public version = "1.0";
160     bool public halted; //Halt crowdsale in emergency
161     bool public isFinalized; // switched to true in operational state
162 	mapping(address => uint256) exchangeRate;
163     uint256 public fundingStartBlock;
164     uint256 public fundingEndBlock;
165     uint256 public constant tokenExchangeRateMile1 = 3000; // 3000 STR tokens for the 1 eth at first phase
166     uint256 public constant tokenExchangeRateMile2 = 2000; // 2000 STR tokens for the 1 eth at second phase
167     uint256 public constant tokenExchangeRateMile3 = 1000; // 1000 STR tokens for the 1 eth at third phase   
168     uint256 public constant tokenCreationMinMile1 = 10 * (10 ** 6) * 10 ** decimals; //minimum ammount of tokens to be created for the ICO to be succesfull
169     uint256 public constant tokenCreationMinMile2 = 78 * (10 ** 6) * 10 ** decimals; //tokens to be created for the ICO for the second milestone 
170     uint256 public constant tokenCreationMaxCap = 187 * (10 ** 6) * 10 ** decimals; //max tokens to be created
171 
172     // contracts
173     address public ethFundDeposit; // deposit address for ETH for Strim Team
174     address public strFundDeposit; // deposit address for Strim Team use and STR User Fund
175     address public StrimTeam; //contract owner
176 
177     // events
178     event LogRefund(address indexed _to, uint256 _value);
179     event CreateSTR(address indexed _to, uint256 _value);
180     event Halt(); //Halt event
181     event Unhalt(); //Unhalt event
182 
183     modifier onlyTeam() {
184         //only do if call is from owner modifier
185         require(msg.sender == StrimTeam);
186         _;
187     }
188 
189     modifier crowdsaleTransferLock() {
190         require(isFinalized);
191         _;
192     }
193 
194     modifier whenNotHalted() {
195         // only do when not halted modifier
196         require(!halted);
197         _;
198     }
199 
200     // constructor
201     function STRIMToken(
202         address _ethFundDeposit,
203         address _strFundDeposit,
204         uint256 _fundingStartBlock,
205         uint256 _fundingEndBlock) {
206         isFinalized = false; //controls pre through crowdsale state
207         halted = false;
208         ethFundDeposit = _ethFundDeposit;
209         strFundDeposit = _strFundDeposit;
210         fundingStartBlock = _fundingStartBlock;
211         fundingEndBlock = _fundingEndBlock;
212         totalSupply = 0;
213         StrimTeam = msg.sender;
214     }
215 
216     //Fallback function when receiving Ether.
217     function() payable {
218         buy();
219     }
220 
221     //Halt ICO in case of emergency.
222     function halt() onlyTeam {
223         halted = true;
224         Halt();
225     }
226 
227     function unhalt() onlyTeam {
228         halted = false;
229         Unhalt();
230     }
231 
232     function buy() payable {
233         createTokens(msg.sender);
234     }
235 
236 
237 
238     //mint Tokens. Accepts ether and creates new STR tokens.
239     function createTokens(address recipient) public payable whenNotHalted {
240         require(!isFinalized);
241         require(block.number >= fundingStartBlock);
242         require(block.number <= fundingEndBlock);
243 		require (totalSupply < tokenCreationMaxCap);
244         require(msg.value > 0);
245 
246         uint256 retRate = returnRate();
247 
248         uint256 tokens = msg.value.mul(retRate); //decimals=18, so no need to adjust for unit  
249 		exchangeRate[recipient]=retRate;
250 		
251         balances[recipient] = balances[recipient].add(tokens);//map tokens to the reciepient address	
252         totalSupply = totalSupply.add(tokens);
253 
254         CreateSTR(msg.sender, tokens); // logs token creation
255         Transfer(this, recipient, tokens);
256     }
257 
258     //Return rate of token against ether.
259     function returnRate() public constant returns(uint256) {
260         if (totalSupply < tokenCreationMinMile1) {
261             return tokenExchangeRateMile1;
262         } else if (totalSupply < tokenCreationMinMile2) {
263             return tokenExchangeRateMile2;
264         } else {
265             return tokenExchangeRateMile3;  
266         }
267     }
268 
269     function finalize() external onlyTeam{
270         require(!isFinalized);//check if already ran        
271         require(totalSupply >= tokenCreationMinMile1); // have to sell minimum to move to operational
272         require(block.number > fundingEndBlock || totalSupply >= tokenCreationMaxCap);//don't end before ico period ends or max cap reached
273 
274         uint256 strVal = totalSupply.div(2);
275         balances[strFundDeposit] = strVal; // deposit Strim share
276         CreateSTR(msg.sender, strVal); // logs token creation
277 
278         // move to operational        
279         if (!ethFundDeposit.send(this.balance)) revert(); // send the eth to Strim Team
280         if (!strFundDeposit.send(this.balance)) revert(); // send the str to Strim Team
281         isFinalized = true;
282     }
283 
284     // Allows contributors to recover their ether in the case of a failed funding campaign.
285     function refund() external {
286         require(!isFinalized); // prevents refund if operational
287         require(block.number > fundingEndBlock); // prevents refund until sale period is over
288         require(totalSupply < tokenCreationMinMile1); // no refunds if we sold enough
289         require(msg.sender != strFundDeposit); // Strim not entitled to a refund
290         
291         if (exchangeRate[msg.sender] > 0) {  
292 		    uint256 strVal = balances[msg.sender];
293             balances[msg.sender] = 0; //if refunded delete the users tokens
294             totalSupply = totalSupply.sub(strVal); // extra safe
295        	    uint256 ethVal = strVal / exchangeRate[msg.sender]; // should be safe; considering it never reached the first milestone;
296             LogRefund(msg.sender, ethVal); // log it 
297             if (!msg.sender.send(ethVal)) revert(); // if you're using a contract; make sure it works with .send gas limits
298 		}
299     }
300 
301     function transfer(address _to, uint256 _value, bytes _data) public crowdsaleTransferLock returns(bool success) {
302         return super.transfer(_to, _value, _data);
303     }
304 
305     function transfer(address _to, uint256 _value) public crowdsaleTransferLock {
306         super.transfer(_to, _value);
307     }
308 
309     function transferFrom(address _from, address _to, uint256 _value) public crowdsaleTransferLock {
310         super.transferFrom(_from, _to, _value);
311     }
312 }