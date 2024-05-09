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
159     uint256 public fundsFromPreSale;
160     string public version = "0.4";
161     bool public halted; //Halt crowdsale in emergency
162     bool public isFinalized; // switched to true in operational state
163 	mapping(address => uint256) exchangeRate;
164     uint256 public fundingStartBlock;
165     uint256 public fundingEndBlock;
166     uint256 public constant tokenExchangeRatePreSale = 10000; // 10000 STR tokens for 1 eth at the presale
167     uint256 public constant tokenExchangeRateMile1 = 3000; // 3000 STR tokens for the 1 eth at first phase
168     uint256 public constant tokenExchangeRateMile2 = 2000; // 2000 STR tokens for the 1 eth at second phase
169     uint256 public constant tokenExchangeRateMile3 = 1000; // 1000 STR tokens for the 1 eth at third phase   
170     uint256 public constant tokenCreationMinMile1 = 10 * (10 ** 6) * 10 ** decimals; //minimum ammount of tokens to be created for the ICO to be succesfull
171     uint256 public constant tokenCreationMinMile2 = 78 * (10 ** 6) * 10 ** decimals; //tokens to be created for the ICO for the second milestone 
172 	uint256 public constant tokenCreationMaxCap = 168 * (10 ** 6) * 10 ** decimals; //max tokens to be created
173 
174     // contracts
175     address public ethFundDeposit; // deposit address for ETH for Strim Team
176     address public strFundDeposit; // deposit address for Strim Team use and STR User Fund
177     address public StrimTeam; //contract owner
178 
179     // events
180     event LogRefund(address indexed _to, uint256 _value);
181     event CreateSTR(address indexed _to, uint256 _value);
182     event Halt(); //Halt event
183     event Unhalt(); //Unhalt event
184 
185     modifier onlyTeam() {
186         //only do if call is from owner modifier
187         require(msg.sender == StrimTeam);
188         _;
189     }
190 
191     modifier crowdsaleTransferLock() {
192         require(isFinalized);
193         _;
194     }
195 
196     modifier whenNotHalted() {
197         // only do when not halted modifier
198         require(!halted);
199         _;
200     }
201 
202     // constructor
203     function STRIMToken(
204         address _ethFundDeposit,
205         address _strFundDeposit,
206         uint256 _fundingStartBlock,
207         uint256 _fundingEndBlock) {
208         isFinalized = false; //controls pre through crowdsale state
209         halted = false;
210         ethFundDeposit = _ethFundDeposit;
211         strFundDeposit = _strFundDeposit;
212         fundingStartBlock = _fundingStartBlock;
213         fundingEndBlock = _fundingEndBlock;
214         totalSupply = 0;
215         StrimTeam = msg.sender;
216         fundsFromPreSale = 0;
217     }
218 
219     //Fallback function when receiving Ether.
220     function() payable {
221         buy();
222     }
223 
224     //Halt ICO in case of emergency.
225     function halt() onlyTeam {
226         halted = true;
227         Halt();
228     }
229 
230     function unhalt() onlyTeam {
231         halted = false;
232         Unhalt();
233     }
234 
235     function buy() payable {
236         createTokens(msg.sender);
237     }
238 
239 
240 
241     //mint Tokens. Accepts ether and creates new STR tokens.
242     function createTokens(address recipient) public payable whenNotHalted {
243         require(!isFinalized);
244         require(block.number >= fundingStartBlock);
245         require(block.number <= fundingEndBlock);
246 		require (totalSupply < tokenCreationMaxCap);
247         require(msg.value > 0);
248 
249         uint256 retRate = returnRate();
250 
251         uint256 tokens = msg.value.mul(retRate); //decimals=18, so no need to adjust for unit   
252         if (retRate == 10000) {
253             fundsFromPreSale = fundsFromPreSale.add(tokens);
254 			exchangeRate[recipient]=0;//presale ether is non refundable as it will be used for marketing during the ICO period
255         } else {
256 		    exchangeRate[recipient]=retRate;
257 		}
258         balances[recipient] = balances[recipient].add(tokens);//map tokens to the reciepient address	
259         totalSupply = totalSupply.add(tokens);
260 
261         CreateSTR(msg.sender, tokens); // logs token creation
262         Transfer(this, recipient, tokens);
263     }
264 
265     //Return rate of token against ether.
266     function returnRate() public constant returns(uint256) {
267         if (block.number < fundingStartBlock.add(5000)) {
268             return tokenExchangeRatePreSale;
269         } else if (totalSupply.sub(fundsFromPreSale) < tokenCreationMinMile1) {
270             return tokenExchangeRateMile1;
271         } else if (totalSupply.sub(fundsFromPreSale) < tokenCreationMinMile2) {
272             return tokenExchangeRateMile2;
273         } else {
274             return tokenExchangeRateMile3;  
275         }
276     }
277 
278     function finalize() external onlyTeam{
279         require(!isFinalized);//check if already ran        
280         require(totalSupply >= tokenCreationMinMile1); // have to sell minimum to move to operational
281         require(block.number > fundingEndBlock || totalSupply >= tokenCreationMaxCap);//don't end before ico period ends or max cap reached
282 
283         uint256 strVal = totalSupply.div(2);
284         balances[strFundDeposit] = strVal; // deposit Strim share
285         CreateSTR(msg.sender, strVal); // logs token creation
286 
287         // move to operational        
288         if (!ethFundDeposit.send(this.balance)) revert(); // send the eth to Strim Team
289         if (!strFundDeposit.send(this.balance)) revert(); // send the str to Strim Team
290         isFinalized = true;
291     }
292 
293     function sendPreSaleETH() external onlyTeam{        
294         require(block.number > fundingStartBlock.add(5000)); //check if the presale passed the 2 day limit 
295         require(fundsFromPreSale > 0); //make sure that there are funds to transfer
296 
297         uint256 ethFromPreSale = fundsFromPreSale.div(10000); //convert from tokens to ether
298         fundsFromPreSale = 0; //revert to initial state so it can't be reused 
299 
300         if (!ethFundDeposit.send(ethFromPreSale)) revert(); // send the eth raised for the pre sale to Strim Team
301 
302     }
303 
304     // Allows contributors to recover their ether in the case of a failed funding campaign.
305     function refund() external {
306         require(!isFinalized); // prevents refund if operational
307         require(block.number > fundingEndBlock); // prevents refund until sale period is over
308         require(totalSupply < tokenCreationMinMile1); // no refunds if we sold enough
309         require(msg.sender != strFundDeposit); // Strim not entitled to a refund
310         
311         if (exchangeRate[msg.sender] > 0) {  //presale ether is non refundable as it will be used for marketing during the ICO period
312 		    uint256 strVal = balances[msg.sender];
313             balances[msg.sender] = 0; //if refunded delete the users tokens
314             totalSupply = totalSupply.sub(strVal); // extra safe
315        	    uint256 ethVal = strVal / exchangeRate[msg.sender]; // should be safe; considering it never reached the first milestone;
316             LogRefund(msg.sender, ethVal); // log it 
317             if (!msg.sender.send(ethVal)) revert(); // if you're using a contract; make sure it works with .send gas limits
318 		}
319     }
320 
321     function transfer(address _to, uint256 _value, bytes _data) public crowdsaleTransferLock returns(bool success) {
322         return super.transfer(_to, _value, _data);
323     }
324 
325     function transfer(address _to, uint256 _value) public crowdsaleTransferLock {
326         super.transfer(_to, _value);
327     }
328 
329     function transferFrom(address _from, address _to, uint256 _value) public crowdsaleTransferLock {
330         super.transferFrom(_from, _to, _value);
331     }
332 }