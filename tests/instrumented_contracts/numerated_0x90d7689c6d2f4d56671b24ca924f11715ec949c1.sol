1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, May 30, 2018
3  (UTC) */
4 
5 pragma solidity ^0.5.1;
6 
7 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     if (a == 0) {
62       return 0;
63     }
64     c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     // uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return a / b;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   /**
125   * @dev total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_to != address(this));
139     require(_value <= balances[msg.sender]);
140     
141 
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     emit Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 is ERC20Basic {
166   function allowance(address owner, address spender) public view returns (uint256);
167   function transferFrom(address from, address to, uint256 value) public returns (bool);
168   function approve(address spender, uint256 value) public returns (bool);
169   event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * @dev https://github.com/ethereum/EIPs/issues/20
179  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_to != address(this));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(address _owner, address _spender) public view returns (uint256) {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * @dev Increase the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _addedValue The amount of tokens to increase the allowance by.
240    */
241   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
242     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 
270 // File: contracts/ZUCToken.sol
271 
272 contract ZUCToken is StandardToken, Ownable {
273     string  public constant name = "Zeuxcoin";
274     string  public constant symbol = "ZUC";
275     uint8   public constant decimals = 18;
276     uint256 public totalSupply_ = 750000000 ether;
277 
278     constructor() public {
279         balances[msg.sender] = totalSupply_;
280     }
281 }