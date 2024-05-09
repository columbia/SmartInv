1 pragma solidity ^0.4.18;
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
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract HasNoEther is Ownable {
70 
71   /**
72   * @dev Constructor that rejects incoming Ether
73   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
74   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
75   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
76   * we could use assembly to access msg.value.
77   */
78   function HasNoEther() public payable {
79     require(msg.value == 0);
80   }
81 
82   /**
83    * @dev Disallows direct send by settings a default function without the `payable` flag.
84    */
85   function() external {
86   }
87 
88   /**
89    * @dev Transfer all Ether held by the contract to the owner.
90    */
91   function reclaimEther() external onlyOwner {
92     assert(owner.send(this.balance));
93   }
94 }
95 
96 contract ERC20Basic {
97   uint256 public totalSupply;
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133 }
134 
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public view returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(address _owner, address _spender) public view returns (uint256) {
188     return allowed[_owner][_spender];
189   }
190 
191   /**
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    */
197   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 contract BurnableToken is StandardToken {
217 
218     event Burn(address indexed burner, uint256 value);
219 
220     /**
221      * @dev Burns a specific amount of tokens.
222      * @param _value The amount of token to be burned.
223      */
224     function burn(uint256 _value) public {
225         require(_value > 0);
226         require(_value <= balances[msg.sender]);
227         // no need to require value <= totalSupply, since that would imply the
228         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
229 
230         address burner = msg.sender;
231         balances[burner] = balances[burner].sub(_value);
232         totalSupply = totalSupply.sub(_value);
233         Burn(burner, _value);
234     }
235 }
236 
237 contract NeuroToken is BurnableToken, HasNoEther {
238 
239     string public constant name = "NeuroToken";
240 
241     string public constant symbol = "NTK";
242 
243     uint8 public constant decimals = 18;
244 
245     uint256 constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
246 
247     //February 15, 2018 11:59:59 PM
248     uint256 constant FREEZE_END = 1518739199;
249 
250     /**
251     * @dev Constructor that gives msg.sender all of existing tokens.
252     */
253     function NeuroToken() public {
254         totalSupply = INITIAL_SUPPLY;
255         balances[msg.sender] = INITIAL_SUPPLY;
256         Transfer(address(0), msg.sender, totalSupply);
257     }
258 
259     /**
260     * @dev transfer token for a specified address
261     * @param _to The address to transfer to.
262     * @param _value The amount to be transferred.
263     */
264     function transfer(address _to, uint256 _value) public returns (bool) {
265         require(msg.sender == owner || now >= FREEZE_END);
266         return super.transfer(_to, _value);
267     }
268 
269     /**
270     * @dev Transfer tokens from one address to another
271     * @param _from address The address which you want to send tokens from
272     * @param _to address The address which you want to transfer to
273     * @param _value uint256 the amount of tokens to be transferred
274     */
275     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
276         require(msg.sender == owner || now >= FREEZE_END);
277         return super.transferFrom(_from, _to, _value);
278     }
279 
280     function multiTransfer(address[] recipients, uint256[] amounts) public {
281         require(recipients.length == amounts.length);
282         for (uint i = 0; i < recipients.length; i++) {
283             transfer(recipients[i], amounts[i]);
284         }
285     }
286 }