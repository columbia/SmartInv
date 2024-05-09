1 /**
2  *Submitted for verification at Etherscan.io on 2018-04-18
3 */
4 
5 pragma solidity ^0.4.18;
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() public {
30     owner = msg.sender;
31   }
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 }
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96   mapping(address => uint256) balances;
97   uint256 totalSupply_;
98   /**
99   * @dev total number of tokens in existence
100   */
101   function totalSupply() public view returns (uint256) {
102     return totalSupply_;
103   }
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return balances[_owner];
125   }
126 }
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145   mapping (address => mapping (address => uint256)) internal allowed;
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186   /**
187    * @dev Increase the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _addedValue The amount of tokens to increase the allowance by.
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 }
222 contract Aaa is StandardToken, Ownable {
223   string public name = "Light Chain"; 
224   string public symbol = "QDL";
225   uint public decimals = 8;
226   uint public INITIAL_SUPPLY = 1000000000 * (10 ** decimals);
227   function Aaa() public {
228     totalSupply_ = INITIAL_SUPPLY;
229     owner = msg.sender;
230     balances[msg.sender] = INITIAL_SUPPLY;
231   }
232 }