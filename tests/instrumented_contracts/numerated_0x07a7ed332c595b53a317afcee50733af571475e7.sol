1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title eMTV ERC20 token by Multiversum.
5  *
6  * @dev Based on OpenZeppelin framework.
7  *
8  * * ERC20 Standard
9  * * total supply: 141000000 (initially given to the contract author).
10  * * decimals: 18
11  */
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 contract Pausable is Ownable {
80   event Pause();
81   event Unpause();
82 
83   bool public paused = true;
84 
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is not paused.
88    * Owner ignores the pause check.
89    */
90   modifier whenNotPaused() {
91     if(msg.sender != owner) {
92       require(!paused);
93     }
94     _;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is paused.
99    * Owner ignores the pause check.
100    */
101   modifier whenPaused() {
102     if(msg.sender != owner) {
103       require(paused);
104     }
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 contract BasicToken is ERC20Basic, Pausable {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract BurnableToken is BasicToken {
165 
166   event Burn(address indexed burner, uint256 value);
167 
168   /**
169    * @dev Burns a specific amount of tokens.
170    * @param _value The amount of token to be burned.
171    */
172   function burn(uint256 _value) public {
173       require(_value <= balances[msg.sender]);
174       // no need to require value <= totalSupply, since that would imply the
175       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
176 
177       address burner = msg.sender;
178       balances[burner] = balances[burner].sub(_value);
179       totalSupply = totalSupply.sub(_value);
180       Burn(burner, _value);
181   }
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 contract eMTV is BasicToken, BurnableToken, ERC20 {
192 
193   string public constant name = "eMTV: Multiversum ERC20 Token";
194   string public constant symbol = "eMTV";
195   uint8 public constant decimals = 18;
196   string public constant version = "1.0";
197 
198   uint256 constant INITIAL_SUPPLY_EMTV = 141000000;
199 
200   /// @dev whether an address is permitted to perform burn operations.
201   mapping(address => bool) public isBurner;
202 
203   /// @dev whether an address is allowed to spend on behalf of another address
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206   /**
207    * @dev Constructor that:
208    * * gives all of existing tokens to the message sender;
209    * * initializes the burners (also adding the message sender);
210    */
211   function eMTV() public {
212       totalSupply = INITIAL_SUPPLY_EMTV * (10 ** uint256(decimals));
213       balances[msg.sender] = totalSupply;
214 
215       isBurner[msg.sender] = true;
216   }
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param _from address The address which you want to send tokens from
221    * @param _to address The address which you want to transfer to
222    * @param _value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
263     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
274     uint oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Grant or remove burn permissions. Only owner can do that!
286    */
287   function grantBurner(address _burner, bool _value) public onlyOwner {
288       isBurner[_burner] = _value;
289   }
290 
291   /**
292    * @dev Throws if called by any account other than the burner.
293    */
294   modifier onlyBurner() {
295       require(isBurner[msg.sender]);
296       _;
297   }
298 
299   /**
300    * @dev Burns a specific amount of tokens.
301    * Only an address listed in `isBurner` can do this.
302    * @param _value The amount of token to be burned.
303    */
304   function burn(uint256 _value) public onlyBurner {
305       super.burn(_value);
306   }
307 }