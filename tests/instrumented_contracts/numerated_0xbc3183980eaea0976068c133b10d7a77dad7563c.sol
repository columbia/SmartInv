1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) public constant returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public constant returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160 
161     uint256 _allowance = allowed[_from][msg.sender];
162 
163     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
164     // require (_value <= _allowance);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = _allowance.sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    */
205   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222 }
223 
224 
225 /**
226  * @title SimpleToken
227  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
228  * Note they can later distribute these tokens as they wish using `transfer` and other
229  * `StandardToken` functions.
230  */
231 contract PresaleMidexToken is StandardToken, Ownable {
232 
233   string public constant name = "PresaleMidex";
234   string public constant symbol = "PMDX";
235   uint8 public constant decimals = 18;
236 
237   address public exchangeRegulatorWallet;
238   address public wallet;
239 
240   uint256 public initialSupply = 10000000 * (10 ** uint256(decimals));
241   uint256 public amountToken = 1 * (10 ** uint256(decimals));
242 
243   uint public startTime;
244   uint public endTime;
245 
246   /**
247    * @dev Constructor that gives msg.sender all of existing tokens.
248    */
249   function PresaleMidexToken() {
250     totalSupply = initialSupply;
251     balances[msg.sender] = initialSupply;
252     wallet = owner;
253     exchangeRegulatorWallet = owner;
254     startTime = now;
255     endTime = startTime + 30 days;
256   }
257 
258   function setAmountToken(uint256 _value) onlyOwnerOrRegulatorExchange {
259     amountToken = _value;
260   }
261 
262   function setExchangeRegulatorWallet(address _value) onlyOwner {
263     exchangeRegulatorWallet = _value;
264   }
265 
266   modifier onlyOwnerOrRegulatorExchange() {
267     require(msg.sender == owner || msg.sender == exchangeRegulatorWallet);
268     _;
269   }
270 
271   function setEndTime(uint256 _value) onlyOwner {
272     endTime = _value;
273   }
274 
275   function setWallet(address _value) onlyOwner {
276     wallet = _value;
277   }
278 
279   modifier saleIsOn() {
280     require(now > startTime && now < endTime);
281     _;
282   }
283 
284   modifier tokenAvaiable() {
285     require(balances[owner] > 0);
286     _;
287   }
288 
289   function () payable saleIsOn tokenAvaiable {
290     uint256 recieveAmount = msg.value;
291     uint256 tokens = recieveAmount.div(amountToken).mul(10 ** uint256(decimals));
292 
293     assert(balances[msg.sender] + tokens >= balances[msg.sender]);
294 
295     if (balances[owner] < tokens) {
296       tokens = balances[owner];
297       recieveAmount = tokens.div(10 ** uint256(decimals)).mul(amountToken);
298     }
299     balances[msg.sender] += tokens;
300     balances[owner] -= tokens;
301     Transfer(owner, msg.sender, tokens);
302     wallet.transfer(recieveAmount);
303   }
304 
305   function burn() onlyOwner {
306     address burner = msg.sender;
307     uint256 quantity = balances[burner];
308     totalSupply = totalSupply.sub(quantity);
309     balances[burner] = 0;
310     Burn(burner, quantity);
311   }
312 
313   event Burn(address indexed burner, uint indexed value);
314 
315 }