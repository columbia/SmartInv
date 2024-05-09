1 /**
2  * @First Smart Airdrop eGAS Token
3  * @First Smart Airdrop as Service SAaS Project
4  * @http://ethgas.stream
5  * @email: egas@ethgas.stream
6  */
7 
8 pragma solidity ^0.4.18;
9 
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 contract Owned {
25   address public owner;
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29   /**
30    * @dev The Owned constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Owned() {
34     owner = msg.sender;
35   }
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
49   function transferOwnership(address newOwner) onlyOwner public {
50     require(newOwner != address(0));
51     OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 }
55 
56 library SaferMath {
57   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
58     uint256 c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal constant returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 contract BasicToken is ERC20Basic {
83   using SaferMath for uint256;
84   mapping(address => uint256) balances;
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public constant returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123 
124     uint256 _allowance = allowed[_from][msg.sender];
125 
126     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
127     // require (_value <= _allowance);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = _allowance.sub(_value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifying the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
159     return allowed[_owner][_spender];
160   }
161 
162   /**
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    */
168   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184    // revert on eth transfers to this contract
185     function() public payable {revert();}
186 }
187 
188 /**
189  * @title Burnable Token
190  * @dev Token that can be irreversibly burned (destroyed).
191  */
192 contract BurnableToken is StandardToken {
193 
194     event Burn(address indexed burner, uint256 value);
195 
196     /**
197      * @dev Burns a specific amount of tokens.
198      * @param _value The amount of token to be burned.
199      */
200     function burn(uint256 _value) public {
201         require(_value > 0);
202         require(_value <= balances[msg.sender]);
203         // no need to require value <= totalSupply, since that would imply the
204         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         Burn(burner, _value);
210     }
211 }
212 
213 contract EGAS is BurnableToken, Owned {
214 
215   string public constant name = "ETHGAS";
216   string public constant symbol = "eGAS";
217   uint8 public constant decimals = 8;
218 
219   uint256 public constant totalSupply = 13792050 * (10 ** uint256(decimals));
220   
221   function NewEgasDrop(address[] _toAddresses, uint256[] _toAmounts) public onlyOwner {
222     
223     /* Ensures _toAddresses array is less than or equal to 255 */
224     assert(_toAddresses.length <= 255);
225     assert(_toAddresses.length == _toAmounts.length);
226     for (uint i = 0; i < _toAddresses.length; i++) 
227         transfer(_toAddresses[i], _toAmounts[i]);  
228     }
229   
230   /**
231    * @dev Constructor that gives msg.sender all of existing tokens
232    */
233   function EGAS() {
234     balances[msg.sender] = totalSupply;
235   }
236 }