1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-14
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * 使用安全计算法进行加减乘除运算
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract Ownable {
55   address public owner;
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     if (newOwner != address(0)) {
81       owner = newOwner;
82     }
83   }
84 
85 }
86 
87 /**
88  * 合约管理员可以在紧急情况下暂停合约，停止转账行为
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is Ownable {
93   event Pause();
94   event Unpause();
95 
96   bool public paused = false;
97 
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() onlyOwner whenNotPaused public {
119     paused = true;
120     emit Pause();
121   }
122 
123   /**
124    * @dev called by the owner to unpause, returns to normal state
125    */
126   function unpause() onlyOwner whenPaused public {
127     paused = false;
128     emit Unpause();
129   }
130 
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function symbol() public view returns (string);
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic, Ownable {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165   mapping(address => bool) public frozenAccount;
166 
167   event FrozenFunds(address target, bool frozen);
168 
169   uint256 totalSupply_;
170   
171   string symbol_;
172 
173   /**
174   * @dev total number of tokens in existence
175   */
176   function totalSupply() public view returns (uint256) {
177     return totalSupply_;
178   }
179   
180   function symbol() public view returns (string) {
181     return symbol_;
182   }
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(!frozenAccount[msg.sender]);
191     require(_to != address(0));
192     require(_value <= balances[msg.sender]);
193 
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     emit Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209   // freeze account
210   function freezeAccount(address target, bool freeze) public onlyOwner {
211     frozenAccount[target] = freeze;
212     emit FrozenFunds(target, freeze);
213   }
214 }
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226   /**
227    * 方法调用者将from账户中的代币转入to账户中
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(!frozenAccount[_from]);
235     require(_to != address(0));
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     emit Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * 方法调用者允许spender操作自己账户中value数量的代币
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    *
250    * Beware that changing an allowance with this method brings the risk that someone may use both the old
251    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param _spender The address which will spend the funds.
255    * @param _value The amount of tokens to be spent.
256    */
257   function approve(address _spender, uint256 _value) public returns (bool) {
258     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * 查看spender还可以操作owner代币的数量是多少
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274 
275 }
276 
277 
278 // 暂停合约会影响以下方法的调用
279 contract PausableToken is StandardToken, Pausable {
280 
281   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
282     return super.transfer(_to, _value);
283   }
284 
285   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
286     return super.transferFrom(_from, _to, _value);
287   }
288 
289   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
290     return super.approve(_spender, _value);
291   }
292 
293   // 批量转账
294   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
295     require(!frozenAccount[msg.sender]);
296 
297     uint receiverCount = _receivers.length;
298     require(receiverCount > 0);
299 
300     uint256 amount = _value.mul(uint256(receiverCount));
301     require(_value > 0 && balances[msg.sender] >= amount);
302 
303     balances[msg.sender] = balances[msg.sender].sub(amount);
304     for (uint i = 0; i < receiverCount; i++) {
305         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
306         emit Transfer(msg.sender, _receivers[i], _value);
307     }
308     return true;
309   }
310 
311 }
312 contract YAKL is PausableToken {
313     uint8 public constant decimals = 18;
314     uint256 public contractAmount = 33600000 * (10 ** uint256(decimals));
315     address public originalAddr = 0x4254f5f0d3d0D46900053B1566ff16C8e7800816;
316     address public receiveAddr =  0x0e8720C2AD735E7b38Bd9FfEA3186d7DDDD869c2;
317     uint public supplyDateTime = 4102415999;
318     uint256 public originAmount = 300000 * (10 ** uint256(decimals));
319     
320     function getContractAmount() constant returns (uint256){
321         return contractAmount;
322     }
323     
324     function setReceiveAddr(address newReceiveAddr) public onlyOwner{
325         receiveAddr = newReceiveAddr;
326     }
327     
328     function setSupplyDateTime(uint newSupplyDateTime) public onlyOwner{
329         supplyDateTime = newSupplyDateTime;
330     }
331     
332     function setOrigAmount(uint256 newOrigAmount) public onlyOwner{
333         originAmount = newOrigAmount;
334     }
335 
336     function apply() public onlyOwner{
337       require(now > supplyDateTime && contractAmount > 0);
338       uint256 _value = originAmount;
339       for(uint i = 0; i < (now - supplyDateTime) / 60 days ;i ++){
340           if(contractAmount >= 11200000 * (10 ** uint256(decimals))){
341                _value -= _value * 2 / 100;
342                
343           }else{
344                _value -= _value * 5 / 100; 
345           }
346           if(_value < originAmount / 3){
347               _value = originAmount / 3;
348               break;
349           }
350       }
351       _value = _value / 30;
352       if(contractAmount < _value){
353           _value = contractAmount;
354       }
355       contractAmount -=_value;
356       balances[receiveAddr]+= _value;
357     }
358     
359     constructor() public {
360 	  symbol_ = "YAKL";
361       totalSupply_ = 42000000 * (10 ** uint256(decimals));
362       balances[originalAddr] = 8400000 * (10 ** uint256(decimals));
363       emit Transfer(address(0), originalAddr, 8400000 * (10 ** uint256(decimals)));
364       paused = false;
365   }
366 }