1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b); 
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a); 
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a); 
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34   
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is not paused.
74    */
75   modifier whenNotPaused() {
76     require(!paused); 
77     _;
78   }
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is paused.
82    */
83   modifier whenPaused() {
84     require(paused);
85     _;
86   }
87 
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() onlyOwner whenNotPaused public {
92     paused = true;
93     emit  Pause();
94   }
95 
96   /**
97    * @dev called by the owner to unpause, returns to normal state
98    */
99   function unpause() onlyOwner whenPaused public {
100     paused = false;
101     emit Unpause();
102   }
103 }
104 
105 contract ERC20Basic {
106   uint256 public totalSupply; 
107   function balanceOf(address who) public view returns (uint256); 
108   function transfer(address to, uint256 value) public returns (bool); 
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
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
148 }
149 
150 contract StandardToken is ERC20, BasicToken {
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163   
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     emit Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit  Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public view returns (uint256) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * @param _spender The address which will spend the funds.
198    * @param _addedValue The amount of tokens to increase the allowance by.
199    */
200   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     emit   Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   /**
207    * @dev Decrease the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221   emit  Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 contract PausableToken is StandardToken, Pausable {
228 
229   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
230     return super.transfer(_to, _value);
231   }
232 
233   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transferFrom(_from, _to, _value);
235   }
236 
237   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
238     return super.approve(_spender, _value);
239   }
240 
241   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
242     return super.increaseApproval(_spender, _addedValue);
243   }
244 
245   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
246     return super.decreaseApproval(_spender, _subtractedValue);
247   }
248 }
249 
250 /**
251  * @dev Initialize contract basic information
252  */
253 contract XBlockToken is PausableToken {
254     string public name = "XBlock";
255     string public symbol = "IX";
256     uint public decimals = 18;
257     uint public INITIAL_SUPPLY = 5000000000000000000000000000;
258 
259     function XBlockToken() public {
260         totalSupply = INITIAL_SUPPLY;
261         balances[msg.sender] = INITIAL_SUPPLY;
262     }
263 }