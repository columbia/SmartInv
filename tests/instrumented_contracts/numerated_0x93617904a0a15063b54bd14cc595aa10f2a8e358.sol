1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-03
3 */
4 
5 pragma solidity >=0.4.0 <0.7.0;
6 
7 
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who)  public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22     address public owner;
23 
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     //0.000786
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33     constructor() public {
34     owner = msg.sender;
35     }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 /**
57  * @title Pausable
58  * @dev Base contract which allows children to implement an emergency stop mechanism.
59  */
60 contract Pausable is Ownable {
61   event Pause();
62   event Unpause();
63 
64   bool public paused = false;
65 
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is not paused.
69    */
70   modifier whenNotPaused() {
71     require(!paused);
72     _;
73   }
74 
75   /**
76    * @dev Modifier to make a function callable only when the contract is paused.
77    */
78   modifier whenPaused() {
79     require(paused);
80     _;
81   }
82 
83   /**
84    * @dev called by the owner to pause, triggers stopped state
85    */
86   function pause() public onlyOwner whenNotPaused  {
87     paused = true;
88     emit Pause();
89   }
90 
91   /**
92    * @dev called by the owner to unpause, returns to normal state
93    */
94   function unpause() public onlyOwner whenPaused {
95     paused = false;
96     emit Unpause();
97   }
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 library SafeMath {
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a * b;
114     assert(a == 0 || c / a == b);
115     return c;
116   }
117 
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return c;
123   }
124 
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances.
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   /**
147   * @dev transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0x0));
153 
154     // SafeMath.sub will throw if there is not enough balance.
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     emit Transfer(msg.sender, _to, _value);
158     return true;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address.
163   * @param _owner The address to query the the balance of.
164   * @return An uint256 representing the amount owned by the passed address.
165   */
166   function balanceOf(address _owner) public view returns (uint256 balance) {
167     return balances[_owner];
168   }
169 
170 }
171 
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  */
179 contract StandardToken is ERC20, BasicToken, Pausable {
180 
181   mapping (address => mapping (address => uint256)) allowed;
182 
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param _from address The address which you want to send tokens from
187    * @param _to address The address which you want to transfer to
188    * @param _value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
191     require(_to != address(0x0));
192 
193     uint256 _allowance = allowed[_from][msg.sender];
194 
195     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
196     // require (_value <= _allowance);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = _allowance.sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   
206   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256 remaining) {
213     return allowed[_owner][_spender];
214   }
215 
216   
217   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
224     uint oldValue = allowed[msg.sender][_spender];
225     if (_subtractedValue > oldValue) {
226       allowed[msg.sender][_spender] = 0;
227     } else {
228       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229     }
230     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234 }
235 
236 contract ALA is StandardToken {
237     using SafeMath for uint256;
238 
239     string public name = "Al Arab Coin";
240     string public symbol = "ALA";
241     uint256 public decimals = 18;
242     uint256 public totalSupply =  999000000 * (10 ** decimals);
243 
244     constructor() public {
245       address wallet = 0x82ABa5287980e6c5F698706B6e50B7d8b243b471;
246       balances[wallet] = totalSupply;
247     }
248 }