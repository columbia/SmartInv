1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5     address receiver;
6 
7     function Owned() public {
8       owner = msg.sender;
9       receiver = owner;
10     }
11 
12     modifier onlyOwner {
13       require(msg.sender == owner);
14       _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18       require(newOwner != address(0));
19       owner = newOwner;
20     }
21 
22     function changeReceiver(address newReceiver) onlyOwner public {
23       require(newReceiver != address(0));
24       receiver =  newReceiver;
25     }
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33     
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) public constant returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) public constant returns (uint256);
77   function transferFrom(address from, address to, uint256 value) public returns (bool);
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract AdminToken is Owned{
83   
84   bool onSale = true;
85 
86   uint stageNumber = 1;
87   uint256 tokenPrice = 1000;
88 
89   
90   //Enable token sale;
91   function sell() public onlyOwner {
92     require (!onSale && stageNumber < 5);                // cannot activated sale when ongoing/ stage already reach 5
93 
94     stageNumber += 1;                                    // move to next stage
95 
96     if (stageNumber != 5) {
97       tokenPrice -= 100;                                 // stage 2-4 price will be 100 less then previous price
98     }
99     else{
100       tokenPrice -= 200;                                 // stage 5 price will be 200 less then stage 4 price
101     }
102     onSale = true;
103   }
104 
105   //disable token sale
106   function _stopSale() internal {
107     onSale = false;
108   }
109 }
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken
114  */
115 contract AdminBasicToken is ERC20Basic, AdminToken {
116 
117   using SafeMath for uint256;
118 
119   mapping (address => uint256) balances;
120 
121   /**
122   * Internal transfer, only can be called by this contract
123   */
124   function _transfer(address _from, address _to, uint _value) internal {
125 
126     require (_to != 0x0 &&                                            // Prevent transfer to 0x0 address.
127            balances[_from] >= _value &&                               // Check if the sender has enough
128            balances[_to] + _value > balances[_to]);                   // Check for overflows
129                                        
130     balances[_from] = balances[_from].sub(_value);                    // Subtract from the sender
131     balances[_to] = balances[_to].add(_value);                        // Add the same to the recipient
132     Transfer(_from, _to, _value);
133   }
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     _transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of. 
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public constant returns (uint256 balance) {
151     return balances[_owner];
152   }
153 }
154 
155 contract StandardToken is ERC20, AdminBasicToken {
156 
157   mapping (address => mapping (address => uint256)) allowed;
158   
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amout of tokens to be transfered
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166     require(_value <= allowed[_from][msg.sender]);     // Check allowance
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     _transfer(_from, _to, _value);
169     return true;
170   }
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool success) {
177 
178     //  To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
183 
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200   	require(_addedValue !=0 && allowed[msg.sender][_spender] > 0);
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   /**
207    * @dev Decrease the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To decrement
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _subtractedValue The amount of tokens to decrease the allowance by.
215    */
216   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217   	require(_subtractedValue !=0 && allowed[msg.sender][_spender] > 0);
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifing the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
235     return allowed[_owner][_spender];
236   }
237 }
238 
239 contract SackWengerCoin is StandardToken {
240 
241   // Public variables of the token
242   string public name =  "Sack Wenger Coin";
243   string public symbol = "AXW";
244   uint8 public decimals = 18;
245   uint256 ETHreceived = 0;
246 
247   uint256 eachStageSupply = 20000000 * 10 ** uint256(decimals);   // Target of each stage is 20,000,000AXW
248 
249   uint256 stageTokenIssued = 0;
250 
251 
252   /* Initializes contract */
253   function SackWengerCoin() public {
254     totalSupply = 0;                                    // Initial supply = 0; No coin pre-exist!
255   }
256 
257   function getStats() public constant returns (uint, uint256, uint256, uint256, uint256, bool) {
258     return (stageNumber, stageTokenIssued, tokenPrice, ETHreceived, totalSupply, onSale);
259   }
260 
261   function _createTokenAndSend(uint256 price) internal {
262     uint newTokenIssued = msg.value * price;            // calculates new token amount by stageOnePrice
263     totalSupply += newTokenIssued;
264     stageTokenIssued += newTokenIssued;
265     balances[msg.sender] += newTokenIssued;            // makes the transfers
266 
267     if (stageTokenIssued >= eachStageSupply) {
268       _stopSale();                                     // stop selling coins when stage target is met
269       stageTokenIssued = 0;
270     }
271   }
272 
273   function () payable public {
274     require (onSale && msg.value != 0);
275 
276     receiver.transfer(msg.value);
277 
278     ETHreceived += msg.value;
279     _createTokenAndSend(tokenPrice);
280   }
281 }