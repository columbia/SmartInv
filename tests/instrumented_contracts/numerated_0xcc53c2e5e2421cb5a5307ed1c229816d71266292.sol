1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 }
78 
79 
80 /**
81  * @title ERC20Basic
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/179
84  */
85 contract ERC20Basic {
86   uint256 public totalSupply;
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 contract BitcoinusToken is ERC20, Ownable {
104   using SafeMath for uint256;
105 
106   string public constant name = "Bitcoinus";
107     string public constant symbol = "BITS";
108     uint8 public constant decimals = 18;
109 
110   mapping (address => uint256) balances;
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   event Mint(address indexed to, uint256 amount);
114     event MintFinished();
115 
116   bool public mintingFinished = false;
117 
118   modifier canTransfer() {
119     require(mintingFinished);
120     _;
121   }
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256 balance) {
145     return balances[_owner];
146   }
147 
148 
149   /**
150   * @dev Transfer tokens from one address to another
151   * @param _from address The address which you want to send tokens from
152   * @param _to address The address which you want to transfer to
153   * @param _value uint256 the amount of tokens to be transferred
154   */
155   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169   *
170   * Beware that changing an allowance with this method brings the risk that someone may use both the old
171   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174   * @param _spender The address which will spend the funds.
175   * @param _value The amount of tokens to be spent.
176   */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Function to check the amount of tokens that an owner allowed to a spender.
185   * @param _owner address The address which owns the funds.
186   * @param _spender address The address which will spend the funds.
187   * @return A uint256 specifying the amount of tokens still available for the spender.
188   */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194   * @dev Increase the amount of tokens that an owner allowed to a spender.
195   *
196   * approve should be called when allowed[_spender] == 0. To increment
197   * allowed value is better to use this function to avoid 2 calls (and wait until
198   * the first transaction is mined)
199   * From MonolithDAO Token.sol
200   * @param _spender The address which will spend the funds.
201   * @param _addedValue The amount of tokens to increase the allowance by.
202   */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210   * @dev Decrease the amount of tokens that an owner allowed to a spender.
211   *
212   * approve should be called when allowed[_spender] == 0. To decrement
213   * allowed value is better to use this function to avoid 2 calls (and wait until
214   * the first transaction is mined)
215   * From MonolithDAO Token.sol
216   * @param _spender The address which will spend the funds.
217   * @param _subtractedValue The amount of tokens to decrease the allowance by.
218   */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236   * @dev Function to mint tokens
237   * @param _to The address that will receive the minted tokens.
238   * @param _amount The amount of tokens to mint.
239   * @return A boolean that indicates if the operation was successful.
240   */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250   * @dev Function to stop minting new tokens.
251   * @return True if the operation was successful.
252   */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }