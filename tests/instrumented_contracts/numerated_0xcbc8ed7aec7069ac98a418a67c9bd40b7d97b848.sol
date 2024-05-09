1 pragma solidity ^0.4.15;
2 
3 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public constant returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80 
81     // SafeMath.sub will throw if there is not enough balance.
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) public constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   function Ownable() {
118     owner = msg.sender;
119   }
120 
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address newOwner) onlyOwner public {
136     require(newOwner != address(0));
137     OwnershipTransferred(owner, newOwner);
138     owner = newOwner;
139   }
140 
141 }
142 
143 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165 
166     uint256 _allowance = allowed[_from][msg.sender];
167 
168     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169     // require (_value <= _allowance);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = _allowance.sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval (address _spender, uint _addedValue)
211     returns (bool success) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval (address _spender, uint _subtractedValue)
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
232 
233 contract CopPayToken is StandardToken, Ownable {
234   string public name = 'CopPayToken';
235   string public symbol = 'COP';
236   uint public decimals = 18;
237 
238   uint public crowdsaleStartTime;
239   uint public crowdsaleEndTime;
240 
241   uint public startTime;
242   uint public endTime;
243   uint public tokensSupply;
244   uint public rate;
245   address public wallet;
246 
247   uint public tokensSold;
248 
249   bool public stopped;
250   event SaleStart();
251   event SaleStop();
252 
253   modifier crowdsaleTransferLock() {
254     require(now > crowdsaleEndTime);
255     _;
256   }
257 
258   function CopPayToken() {
259     totalSupply = 2325000000 * (10**18);
260     balances[msg.sender] = totalSupply;
261     crowdsaleStartTime = 1509364800;
262     crowdsaleEndTime = 1512302400;
263     startTime = 1509278400;
264     endTime = 1512043200;
265     tokensSupply = 1250200000 * (10**18);
266     rate = 19000;
267     wallet = address(0xD6bd7B92f1f6ed1d429c5001D3786c4de0338b19);
268     startSale();
269   }
270 
271   function() payable {
272     buy(msg.sender);
273   }
274 
275   function buy(address buyer) public payable {
276     require(!stopped);
277     require(buyer != address(0));
278     require(msg.value > 0);
279     require(now >= startTime && now <= endTime);
280 
281     uint tokens = msg.value.mul(rate);
282     assert(tokensSupply.sub(tokens) >= 0);
283 
284     balances[buyer] = balances[buyer].add(tokens);
285     balances[owner] = balances[owner].sub(tokens);
286     tokensSupply = tokensSupply.sub(tokens);
287     tokensSold = tokensSold.add(tokens);
288 
289     assert(wallet.send(msg.value));
290     Transfer(this, buyer, tokens);
291   }
292 
293   function startSale() onlyOwner {
294     stopped = false;
295     SaleStart();
296   }
297 
298   function stopSale() onlyOwner {
299     stopped = true;
300     SaleStop();
301   }
302 
303   function migrate(address _to, uint _value) onlyOwner returns (bool) {
304     require(now < crowdsaleStartTime);
305     return super.transfer(_to, _value);
306   }
307 
308   function transfer(address _to, uint _value) crowdsaleTransferLock returns (bool) {
309     return super.transfer(_to, _value);
310   }
311 
312   function transferFrom(address _from, address _to, uint _value) crowdsaleTransferLock returns (bool) {
313     return super.transferFrom(_from, _to, _value);
314   }
315 }