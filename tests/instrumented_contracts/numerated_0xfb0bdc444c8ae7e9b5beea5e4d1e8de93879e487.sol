1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract ERC20 is ERC20Basic {
17   function allowance(address owner, address spender) public view returns (uint256);
18   function transferFrom(address from, address to, uint256 value) public returns (bool);
19   function approve(address spender, uint256 value) public returns (bool);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 /**
61  * @title Pausable
62  * @dev Base contract which allows children to implement an emergency stop mechanism.
63  */
64 contract Pausable is Ownable {
65   event Pause();
66   event Unpause();
67 
68   bool public paused = false;
69 
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is not paused.
73    */
74   modifier whenNotPaused() {
75     require(!paused);
76     _;
77   }
78 
79   /**
80    * @dev Modifier to make a function callable only when the contract is paused.
81    */
82   modifier whenPaused() {
83     require(paused);
84     _;
85   }
86 
87   /**
88    * @dev called by the owner to pause, triggers stopped state
89    */
90   function pause() onlyOwner whenNotPaused public {
91     paused = true;
92     emit Pause();
93   }
94 
95   /**
96    * @dev called by the owner to unpause, returns to normal state
97    */
98   function unpause() onlyOwner whenPaused public {
99     paused = false;
100     emit Unpause();
101   }
102 }
103 
104 contract StandardToken is ERC20,Pausable {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) public balances;
108     mapping (address => mapping (address => uint256)) public allowed;
109 
110     /**
111     * @dev transfer token for a specified address
112     * @param _to The address to transfer to.
113     * @param _value The amount to be transferred.
114     */
115     function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {
116         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124     * @dev Transfer tokens from one address to another
125     * @param _from address The address which you want to send tokens from
126     * @param _to address The address which you want to transfer to
127     * @param _value uint256 the amout of tokens to be transfered
128     */
129     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool success) {
130         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
131         balances[_to] = balances[_to].add(_value);
132         balances[_from] = balances[_from].sub(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139     * @dev Gets the balance of the specified address.
140     * @param _owner The address to query the the balance of.
141     * @return An uint256 representing the amount owned by the passed address.
142     */
143     function balanceOf(address _owner) constant returns (uint256 balance) {
144         return balances[_owner];
145     }
146 
147     /**
148     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149     * This only works when the allowance is 0. Cannot be used to change allowance.
150     * https://github.com/ethereum/EIPs/issues/738#issuecomment-336277632
151     * @param _spender The address which will spend the funds.
152     * @param _value The amount of tokens to be spent.
153     */
154     function approve(address _spender, uint256 _value) whenNotPaused returns (bool success) {
155         require(allowed[msg.sender][_spender] == 0);
156         allowed[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /**
162     * @dev Function to check the amount of tokens that an owner allowed to a spender.
163     * @param _owner address The address which owns the funds.
164     * @param _spender address The address which will spend the funds.
165     * @return A uint256 specifing the amount of tokens still available for the spender.
166     */
167     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
168       return allowed[_owner][_spender];
169     }
170 
171     /**
172      * To increment allowed value is better to use this function.
173      * From MonolithDAO Token.sol
174      */
175     function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
176         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178         return true;
179     }
180 
181     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
182         uint oldValue = allowed[msg.sender][_spender];
183         if (_subtractedValue > oldValue) {
184             allowed[msg.sender][_spender] = 0;
185         } else {
186             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187         }
188         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189         return true;
190     }
191 }
192 
193 library SafeMath {
194   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
195     uint256 c = a * b;
196     assert(a == 0 || c / a == b);
197     return c;
198   }
199 
200   function div(uint256 a, uint256 b) internal constant returns (uint256) {
201     assert(b > 0); // Solidity automatically throws when dividing by 0
202     uint256 c = a / b;
203     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204     return c;
205   }
206 
207   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
208     assert(b <= a);
209     return a - b;
210   }
211 
212   function add(uint256 a, uint256 b) internal constant returns (uint256) {
213     uint256 c = a + b;
214     assert(c >= a);
215     return c;
216   }
217 }
218 
219 
220 /* Contract class to mint tokens and transfer */
221 contract SPRINGToken is StandardToken {
222   using SafeMath for uint256;
223 
224   string constant public name = 'SPRING Token';
225   string constant public symbol = 'SPRING';
226   uint constant public decimals = 18;
227   uint256 public totalSupply;
228   uint256 public maxSupply;
229 
230   /* Constructor function to set maxSupply*/
231   constructor(uint256 _maxSupply) public {
232     maxSupply = _maxSupply;
233   }
234 
235   /**
236  * @dev Function to mint tokens
237  * @param _amount The amount of tokens to mint.
238  * @return A boolean that indicates if the operation was successful.
239  */
240   function mint(uint256 _amount) onlyOwner public returns (bool) {
241     require (maxSupply >= (totalSupply.add(_amount)));
242     totalSupply = totalSupply.add(_amount);
243     balances[msg.sender] = balances[msg.sender].add(_amount);
244     emit Transfer(address(0), msg.sender, _amount);
245     return true;
246   }
247 
248 }