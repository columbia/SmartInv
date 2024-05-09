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
56 }
57 
58 contract HasNoEther is Ownable {
59 
60   /**
61   * @dev Constructor that rejects incoming Ether
62   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
63   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
64   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
65   * we could use assembly to access msg.value.
66   */
67   function HasNoEther() public payable {
68     require(msg.value == 0);
69   }
70 
71   /**
72    * @dev Disallows direct send by settings a default function without the `payable` flag.
73    */
74   function() external {
75   }
76 
77   /**
78    * @dev Transfer all Ether held by the contract to the owner.
79    */
80   function reclaimEther() external onlyOwner {
81     assert(owner.send(this.balance));
82   }
83 }
84 
85 contract ERC20Basic {
86   uint256 public totalSupply;
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) public view returns (uint256);
126   function transferFrom(address from, address to, uint256 value) public returns (bool);
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    */
186   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
193     uint oldValue = allowed[msg.sender][_spender];
194     if (_subtractedValue > oldValue) {
195       allowed[msg.sender][_spender] = 0;
196     } else {
197       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
198     }
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203 }
204 
205 contract BurnableToken is StandardToken {
206 
207     event Burn(address indexed burner, uint256 value);
208 
209     /**
210      * @dev Burns a specific amount of tokens.
211      * @param _value The amount of token to be burned.
212      */
213     function burn(uint256 _value) public {
214         require(_value > 0);
215         require(_value <= balances[msg.sender]);
216         address burner = msg.sender;
217         balances[burner] = balances[burner].sub(_value);
218         totalSupply = totalSupply.sub(_value);
219         Burn(burner, _value);
220     }
221 }
222 
223 contract HighCastleToken is BurnableToken, HasNoEther {
224 
225     string public constant name = "HighCastle Token";
226     string public constant symbol = "AIMS";
227     uint8 public constant decimals = 8;
228     uint256 constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
229 
230     uint256 constant FREEZE_END = 1520553600;
231 	// 1520553600 - Fri, 09 Mar 2018 00:00:00 GMT
232 	
233     /**
234     * @dev Constructor that gives msg.sender all of existing tokens.
235     */
236     function HighCastleToken() public {
237         totalSupply = INITIAL_SUPPLY;
238         balances[msg.sender] = INITIAL_SUPPLY;
239         Transfer(address(0), msg.sender, totalSupply);
240     }
241 
242     /**
243     * @dev Transfer token for a specified address
244     * @param _to The address to transfer to.
245     * @param _value The amount to be transferred.
246     */
247     function transfer(address _to, uint256 _value) public returns (bool) {
248         require(msg.sender == owner || now >= FREEZE_END);
249         return super.transfer(_to, _value);
250     }
251 
252     /**
253     * @dev Transfer tokens from one address to another
254     * @param _from address The address which you want to send tokens from
255     * @param _to address The address which you want to transfer to
256     * @param _value uint256 the amount of tokens to be transferred
257     */
258     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
259         require(msg.sender == owner || now >= FREEZE_END);
260         return super.transferFrom(_from, _to, _value);
261     }
262 
263     /**
264     * @dev Multi transfer token for a specified address
265     * @param _to The array addresses to transfer to.
266     * @param _value The array amounts to be transferred.
267     */
268     function multiTransfer(address[] _to, uint256[] _value) public {
269         require(_to.length == _value.length);
270         for (uint i = 0; i < _to.length; i++) {
271             transfer(_to[i], _value[i]);
272         }
273     }
274 }