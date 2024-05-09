1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-19
3 */
4 
5 pragma solidity >=0.4.0 <0.7.0;
6 
7 
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
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
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32     constructor() public {
33     owner = msg.sender;
34     }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     emit OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 /**
56  * @title Pausable
57  * @dev Base contract which allows children to implement an emergency stop mechanism.
58  */
59 contract Pausable is Ownable {
60   event Pause();
61   event Unpause();
62 
63   bool public paused = false;
64 
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is not paused.
68    */
69   modifier whenNotPaused() {
70     require(!paused);
71     _;
72   }
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is paused.
76    */
77   modifier whenPaused() {
78     require(paused);
79     _;
80   }
81 
82   /**
83    * @dev called by the owner to pause, triggers stopped state
84    */
85   function pause() onlyOwner whenNotPaused public {
86     paused = true;
87     emit Pause();
88   }
89 
90   /**
91    * @dev called by the owner to unpause, returns to normal state
92    */
93   function unpause() onlyOwner whenPaused public {
94     paused = false;
95     emit Unpause();
96   }
97 }
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public view returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 library SafeMath {
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     uint256 c = a * b;
113     assert(a == 0 || c / a == b);
114     return c;
115   }
116 
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 /**
137  * @title Basic token
138  * @dev Basic version of StandardToken, with no allowances.
139  */
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) balances;
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0x0));
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 
172 /**
173  * @title Standard ERC20 token
174  *
175  * @dev Implementation of the basic standard token.
176  * @dev https://github.com/ethereum/EIPs/issues/20
177  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
236 contract Leaxcoin is StandardToken {
237     using SafeMath for uint256;
238 
239     //Information coin
240     string public name = "Leaxcoin";
241     string public symbol = "LEAX";
242     uint256 public decimals = 18;
243     uint256 public totalSupply = 2000000000 * (10 ** decimals);
244 
245     address payable public walletETH; 
246 
247     event Burn(address indexed burner, uint256 value);  
248     
249     constructor() public {         
250       walletETH = msg.sender;
251       balances[walletETH] = totalSupply;
252     }
253     
254     function burn(uint256 _value) public whenNotPaused {
255         require(_value > 0);
256 
257         address burner = msg.sender;
258         balances[burner] = balances[burner].sub(_value);
259         totalSupply = totalSupply.sub(_value);
260         emit Burn(burner, _value);
261     }   
262     
263     function () payable external {  
264         return;
265     } 
266 }