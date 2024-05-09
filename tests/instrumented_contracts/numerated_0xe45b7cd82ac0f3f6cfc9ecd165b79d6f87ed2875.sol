1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that revert on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, reverts on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (a == 0) {
24       return 0;
25     }
26 
27     uint256 c = a * b;
28     require(c / a == b);
29 
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b > 0); // Solidity only automatically asserts when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40 
41     return c;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b <= a);
49     uint256 c = a - b;
50 
51     return c;
52   }
53 
54   /**
55   * @dev Adds two numbers, reverts on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     require(c >= a);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
66   * reverts when dividing by zero.
67   */
68   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b != 0);
70     return a % b;
71   }
72 }
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public constant returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public constant returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    */
184   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203 /**
204  * @title Ownable
205  * @dev The Ownable contract has an owner address, and provides basic authorization control
206  * functions, this simplifies the implementation of "user permissions".
207  */
208 contract Ownable {
209   address public owner;
210 
211 
212   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214 
215   /**
216    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
217    * account.
218    */
219   function Ownable() {
220     owner = msg.sender;
221   }
222 
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232 
233   /**
234    * @dev Allows the current owner to transfer control of the contract to a newOwner.
235    * @param newOwner The address to transfer ownership to.
236    */
237   function transferOwnership(address newOwner) onlyOwner public {
238     require(newOwner != address(0));
239     OwnershipTransferred(owner, newOwner);
240     owner = newOwner;
241   }
242 
243 }
244 
245 contract SEcoin is StandardToken, Ownable {
246     string constant public name = "SE coin";
247     string constant public symbol = "SE";
248     uint8 constant public decimals = 18;
249     bool public isLocked = true;
250 
251     function SEcoin(address SEcoinwallet) {
252         totalSupply = (14*1e8)*1e18;
253         balances[SEcoinwallet] = totalSupply;
254     }
255 
256     modifier illegalWhenLocked() {
257         require(!isLocked || msg.sender == owner);
258         _;
259     }
260 
261     // should be called by crowdSale when crowdSale is finished
262     function unlock() onlyOwner public{
263         isLocked = false;
264     }
265 
266     function transfer(address _to, uint256 _value) illegalWhenLocked public returns (bool) {
267         return super.transfer(_to, _value);
268     }
269 
270     function transferFrom(address _from, address _to, uint256 _value) illegalWhenLocked public returns (bool) {
271         return super.transferFrom(_from, _to, _value);
272     }
273 }