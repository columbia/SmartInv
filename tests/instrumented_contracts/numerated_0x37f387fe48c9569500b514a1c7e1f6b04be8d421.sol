1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     if (a == 0) {
66       return 0;
67     }
68     uint256 c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
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
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 contract QIUToken is StandardToken,Ownable {
253     string public name = 'QIUToken';
254     string public symbol = 'QIU';
255     uint8 public decimals = 0;
256     uint public INITIAL_SUPPLY = 5000000000;
257     uint public eth2qiuRate = 10000;
258 
259     function() public payable { } // make this contract to receive ethers
260 
261     function QIUToken() public {
262         totalSupply_ = INITIAL_SUPPLY;
263         balances[owner] = INITIAL_SUPPLY / 10;
264         balances[this] = INITIAL_SUPPLY - balances[owner];
265     }
266 
267     function getOwner() public view returns (address) {
268         return owner;
269     }  
270     
271     /**
272     * @dev Transfer tokens from one address to another, only owner can do this super-user operate
273     * @param _from address The address which you want to send tokens from
274     * @param _to address The address which you want to transfer to
275     * @param _value uint256 the amount of tokens to be transferred
276     */
277     function ownerTransferFrom(address _from, address _to, uint256 _value) public returns (bool) {
278         require(tx.origin == owner); // only the owner can call the method.
279         require(_to != address(0));
280         require(_value <= balances[_from]);
281 
282         balances[_from] = balances[_from].sub(_value);
283         balances[_to] = balances[_to].add(_value);
284         Transfer(_from, _to, _value);
285         return true;
286     }
287 
288       /**
289     * @dev transfer token for a specified address,but different from transfer is replace msg.sender with tx.origin
290     * @param _to The address to transfer to.
291     * @param _value The amount to be transferred.
292     */
293     function originTransfer(address _to, uint256 _value) public returns (bool) {
294         require(_to != address(0));
295         require(_value <= balances[tx.origin]);
296 
297         // SafeMath.sub will throw if there is not enough balance.
298         balances[tx.origin] = balances[tx.origin].sub(_value);
299         balances[_to] = balances[_to].add(_value);
300         Transfer(tx.origin, _to, _value);
301         return true;
302     }
303 
304     event ExchangeForETH(address fromAddr,address to,uint qiuAmount,uint ethAmount);
305     function exchangeForETH(uint qiuAmount) public returns (bool){
306         uint ethAmount = qiuAmount * 1000000000000000000 / eth2qiuRate; // only accept multiple of 100
307         require(this.balance >= ethAmount);
308         balances[this] = balances[this].add(qiuAmount);
309         balances[msg.sender] = balances[msg.sender].sub(qiuAmount);
310         msg.sender.transfer(ethAmount);
311         ExchangeForETH(this,msg.sender,qiuAmount,ethAmount);
312         return true;
313     }
314 
315     event ExchangeForQIU(address fromAddr,address to,uint qiuAmount,uint ethAmount);
316     function exchangeForQIU() payable public returns (bool){
317         uint qiuAmount = msg.value * eth2qiuRate / 1000000000000000000;
318         require(qiuAmount <= balances[this]);
319         balances[this] = balances[this].sub(qiuAmount);
320         balances[msg.sender] = balances[msg.sender].add(qiuAmount);
321         ExchangeForQIU(this,msg.sender,qiuAmount,msg.value);
322         return true;
323     }
324 
325     function getETHBalance() public view returns (uint) {
326         return this.balance; // balance is "inherited" from the address type
327     }
328 }