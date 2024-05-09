1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two numbers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 // interface standard erc20
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 
78 contract Ownable {
79   address public owner;
80 
81   event transferOwner(address indexed existingOwner, address indexed newOwner);
82 
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   function transferOwnership(address newOwner) onlyOwner public {
93     if (newOwner != address(0)) {
94       owner = newOwner;
95       emit transferOwner(msg.sender, owner);
96     }
97   }
98 }
99 
100 
101 // more common interface erc20
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   // implementation of transfer token
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_value > 0);
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   // check balance user (map)
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 
135 contract StandardToken is ERC20, BasicToken {
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138   // implementation transfer from another user
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_value > 0);
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     emit Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   // implementation approval to allowed transfer
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     require(_value > 0);
155     allowed[msg.sender][_spender] = _value;
156     emit Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   // check total allowance particular user
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165  // implementation increase total approval from particular user
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     require(_addedValue > 0);
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   // implementation decrease total approval from particular user
174   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175     require(_subtractedValue > 0);
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract Pausable is Ownable {
189   event Pause();
190   event Unpause();
191 
192   bool public paused = false;
193   
194 //@dev Modifier to make a function callable only when the contract is not paused.
195   modifier whenNotPaused() {
196     require(!paused);
197     _;
198   }
199 
200 
201 //@dev Modifier to make a function callable only when the contract is paused.
202   modifier whenPaused() {
203     require(paused);
204     _;
205   }
206 
207 
208 //@dev called by the owner to pause, triggers stopped state
209   function pause() onlyOwner whenNotPaused public {
210     paused = true;
211     emit Pause();
212   }
213 
214 
215 //@dev called by the owner to unpause, returns to normal state
216   function unpause() onlyOwner whenPaused public {
217     paused = false;
218     emit Unpause();
219   }
220 }
221 
222 // implementation pauseable erc20
223 contract PausableToken is StandardToken, Pausable {
224 
225   // call whenNotPaused modifier to check next state
226   
227   function transfer(
228     address _to,
229     uint256 _value
230   )
231     public
232     whenNotPaused
233     returns (bool)
234   {
235     return super.transfer(_to, _value);
236   }
237 
238   function transferFrom(
239     address _from,
240     address _to,
241     uint256 _value
242   )
243     public
244     whenNotPaused
245     returns (bool)
246   {
247     return super.transferFrom(_from, _to, _value);
248   }
249 
250   function approve(
251     address _spender,
252     uint256 _value
253   )
254     public
255     whenNotPaused
256     returns (bool)
257   {
258     return super.approve(_spender, _value);
259   }
260 
261   function increaseApproval(
262     address _spender,
263     uint _addedValue
264   )
265     public
266     whenNotPaused
267     returns (bool success)
268   {
269     return super.increaseApproval(_spender, _addedValue);
270   }
271 
272   function decreaseApproval(
273     address _spender,
274     uint _subtractedValue
275   )
276     public
277     whenNotPaused
278     returns (bool success)
279   {
280     return super.decreaseApproval(_spender, _subtractedValue);
281   }
282 }
283 
284 contract BraveSoundToken is PausableToken {  
285   string public constant name = "Brave Sound Token";
286   string public constant symbol = "BRST";
287   uint8 public constant decimals = 0;
288 
289   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
290 
291   constructor(address reserve) public {
292     totalSupply = INITIAL_SUPPLY;
293     balances[reserve] = INITIAL_SUPPLY;
294     emit Transfer(0x0, reserve, INITIAL_SUPPLY);
295   }
296 
297 }