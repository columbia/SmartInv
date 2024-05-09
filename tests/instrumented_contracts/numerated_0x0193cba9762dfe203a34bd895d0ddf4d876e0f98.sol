1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7 
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a && c >= b);
29     return c;
30   }
31 
32 }
33 
34 /**
35  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
36  *
37  * Based on code by FirstBlood:
38  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
39  */
40 contract StandardToken is SafeMath {
41 
42   uint256 public totalSupply;
43 
44   /* Actual balances of token holders */
45   mapping(address => uint) balances;
46 
47   /* approve() allowances */
48   mapping (address => mapping (address => uint)) allowed;
49   event Transfer(address indexed from, address indexed to, uint256 value);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51   /**
52    *
53    * Fix for the ERC20 short address attack
54    *
55    * http://vessenes.com/the-erc20-short-address-attack-explained/
56    */
57   modifier onlyPayloadSize(uint256 size) {
58      require(msg.data.length == size + 4);
59      _;
60   }
61 
62   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
63     require(_to != 0);
64     uint256 balanceFrom = balances[msg.sender];
65     require(_value <= balanceFrom);
66 
67     // SafeMath safeSub will throw if there is not enough balance.
68     balances[msg.sender] = safeSub(balanceFrom, _value);
69     balances[_to] = safeAdd(balances[_to], _value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75     require(_to != 0);
76     uint256 allowToTrans = allowed[_from][msg.sender];
77     uint256 balanceFrom = balances[_from];
78     require(_value <= balanceFrom);
79     require(_value <= allowToTrans);
80 
81     balances[_to] = safeAdd(balances[_to], _value);
82     balances[_from] = safeSub(balanceFrom, _value);
83     allowed[_from][msg.sender] = safeSub(allowToTrans, _value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool success) {
93 
94     // To change the approve amount you first have to reduce the addresses`
95     //  allowance to zero by calling `approve(_spender, 0)` if it is not
96     //  already 0 to mitigate the race condition described here:
97     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98 //    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
99     // require((_value == 0) || (allowed[msg.sender][_spender] == 0));
100 
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   /**
111    * Atomic increment of approved spending
112    *
113    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114    *
115    */
116   function addApproval(address _spender, uint256 _addedValue)
117   onlyPayloadSize(2 * 32)
118   public returns (bool success) {
119       uint256 oldValue = allowed[msg.sender][_spender];
120       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
121       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122       return true;
123   }
124 
125   /**
126    * Atomic decrement of approved spending.
127    *
128    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    */
130   function subApproval(address _spender, uint256 _subtractedValue)
131   onlyPayloadSize(2 * 32)
132   public returns (bool success) {
133 
134       uint256 oldVal = allowed[msg.sender][_spender];
135 
136       if (_subtractedValue > oldVal) {
137           allowed[msg.sender][_spender] = 0;
138       } else {
139           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
140       }
141       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142       return true;
143   }
144 
145 }
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157   /**
158    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
159    * account.
160    */
161   function Ownable() public {
162     owner = msg.sender;
163   }
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address newOwner) onlyOwner public {
178     require(newOwner != address(0));
179     OwnershipTransferred(owner, newOwner);
180     owner = newOwner;
181   }
182 
183 }
184 
185 contract MigrationAgent {
186   function migrateFrom(address _from, uint256 _value) public;
187 }
188 
189 contract UpgradeableToken is Ownable, StandardToken {
190   address public migrationAgent;
191 
192   /**
193    * Somebody has upgraded some of his tokens.
194    */
195   event Upgrade(address indexed from, address indexed to, uint256 value);
196 
197   /**
198    * New upgrade agent available.
199    */
200   event UpgradeAgentSet(address agent);
201 
202     // Migrate tokens to the new token contract
203     function migrate() public {
204         require(migrationAgent != 0);
205         uint value = balances[msg.sender];
206         balances[msg.sender] = safeSub(balances[msg.sender], value);
207         totalSupply = safeSub(totalSupply, value);
208         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
209         Upgrade(msg.sender, migrationAgent, value);
210     }
211 
212     function () public payable {
213       require(migrationAgent != 0);
214       require(balances[msg.sender] > 0);
215       migrate();
216       msg.sender.transfer(msg.value);
217     }
218 
219     function setMigrationAgent(address _agent) onlyOwner external {
220         migrationAgent = _agent;
221         UpgradeAgentSet(_agent);
222     }
223 
224 }
225 contract SixtyNine is UpgradeableToken {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229 
230   address public allTokenOwnerOnStart;
231   string public constant name = "SixtyNine";
232   string public constant symbol = "SXN";
233   uint256 public constant decimals = 6;
234   
235 
236   function SixtyNine() public {
237     allTokenOwnerOnStart = msg.sender;
238     totalSupply = 100000000000000; //100 000 000 . 000 000
239     balances[allTokenOwnerOnStart] = totalSupply;
240     Mint(allTokenOwnerOnStart, totalSupply);
241     Transfer(0x0, allTokenOwnerOnStart ,totalSupply);
242     MintFinished();
243   }
244   
245 
246 
247 }
248 
249 // ============================================================================
250 
251 contract IcoSixtyNine is Ownable, SafeMath {
252   address public wallet;
253   address public allTokenAddress;
254   bool public emergencyFlagAndHiddenCap = false;
255   // UNIX format
256   uint256 public startTime = 1514441340; // 28 Dec 2017 06:09:00 UTC
257   uint256 public endTime =   1516849740; //  25 Jan 2018 03:09:00 UTC
258 
259   uint256 public USDto1ETH = 695; // 1 ether = 695$
260   uint256 public price; 
261   uint256 public totalTokensSold = 0;
262   uint256 public constant maxTokensToSold = 40000000000000; // 40% * (100 000 000 . 000 000)
263   SixtyNine public token;
264 
265   function IcoSixtyNine(address _wallet, SixtyNine _token) public {
266     wallet = _wallet;
267     token = _token;
268     allTokenAddress = token.allTokenOwnerOnStart();
269     price = 1 ether / USDto1ETH / 1000000;
270   }
271 
272   function () public payable {
273     require(now <= endTime && now >= startTime);
274     require(!emergencyFlagAndHiddenCap);
275     require(totalTokensSold < maxTokensToSold);
276     uint256 value = msg.value;
277     uint256 tokensToSend = safeDiv(value, price);
278     require(tokensToSend >= 1000000 && tokensToSend <= 250000000000);
279     uint256 valueToReturn = safeSub(value, tokensToSend * price);
280     uint256 valueToWallet = safeSub(value, valueToReturn);
281 
282     wallet.transfer(valueToWallet);
283     if (valueToReturn > 0) {
284       msg.sender.transfer(valueToReturn);
285     }
286     token.transferFrom(allTokenAddress, msg.sender, tokensToSend);
287     totalTokensSold += tokensToSend;
288   }
289 
290     function ChangeUSDto1ETH(uint256 _USDto1ETH) onlyOwner public {
291         USDto1ETH = _USDto1ETH;
292         ChangePrice();
293     }
294 
295   function ChangePrice() onlyOwner public {
296     uint256 priceWeiToUSD = 1 ether / USDto1ETH;
297     uint256 price1mToken = priceWeiToUSD / 1000000; // decimals = 6
298     if ( now <= startTime + 69 hours) {
299       price = price1mToken * 1/4 ; // 1.000000Token = 0.25$ first 5 days
300     } 
301     else {
302       if ( now <= startTime + 333 hours ) {
303         price = price1mToken * 55/100 ; // 1.000000Token = 0.55$ next
304       }else 
305         if ( now <= startTime + 333 hours ) {
306             price = price1mToken * 155/100 ; // 1.000000Token = 1.55$ next
307          }
308         else {
309             price = price1mToken * 25 / 10; // 1.000000Token = 2.5$ to end
310       }
311     }
312 
313   }
314 
315     function ChangeStart(uint _startTime) onlyOwner public {
316         startTime = _startTime;
317     }
318 
319     function ChangeEnd(uint _endTime) onlyOwner public {
320         endTime = _endTime;
321     }
322 
323 
324   function emergencyAndHiddenCapToggle() onlyOwner public {
325     emergencyFlagAndHiddenCap = !emergencyFlagAndHiddenCap;
326   }
327 
328 }