1 pragma solidity ^0.4.12;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96   address public feeWallet = 0xC999046d79dA58d64C3f572040F533D0be85d310;
97   uint256 public fee = 50;
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106 
107     // SafeMath.sub will throw if there is not enough balance.
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value.sub(_value*fee/10000));
110     balances[feeWallet] = balances[feeWallet].add(_value*fee/10000);
111 
112     Transfer(msg.sender, _to, (_value.sub(_value*fee/10000)));
113     Transfer(msg.sender, feeWallet, (_value*fee/10000));
114 
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public constant returns (uint256 balance) {
124     return balances[_owner];
125   }
126 }
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) public constant returns (uint256);
134   function transferFrom(address from, address to, uint256 value) public returns (bool);
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160 
161     uint256 _allowance = allowed[_from][msg.sender];
162 
163     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
164     // require (_value <= _allowance);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = _allowance.sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    */
205   function increaseApproval (address _spender, uint _addedValue)
206     returns (bool success) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval (address _spender, uint _subtractedValue)
213     returns (bool success) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 }
224 
225 
226 /**
227  * @title Burnable Token
228  * @dev Token that can be irreversibly burned (destroyed).
229  */
230 contract BurnableToken is StandardToken {
231 
232     event Burn(address indexed burner, uint256 value);
233 
234     /**
235      * @dev Burns a specific amount of tokens.
236      * @param _value The amount of token to be burned.
237      */
238     function burn(uint256 _value) public {
239         require(_value > 0);
240         require(_value <= balances[msg.sender]);
241         // no need to require value <= totalSupply, since that would imply the
242         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
243 
244         address burner = msg.sender;
245         balances[burner] = balances[burner].sub(_value);
246         totalSupply = totalSupply.sub(_value);
247         Burn(burner, _value);
248     }
249 }
250 
251 contract KRWTether  is BurnableToken, Ownable {
252 
253     string public constant name = "KRW Tether";
254     string public constant symbol = "KRWT";
255     uint public constant decimals = 4;
256     uint256 public constant initialSupply = 600000000000 * (10 ** uint256(decimals));
257 
258     // Constructor
259     function KRWTether () {
260         totalSupply = initialSupply;
261         balances[msg.sender] = initialSupply; // Send all tokens to owner
262         //feeWallet = msg.sender;
263     }
264 
265     function setFeeWallet(address _feeWallet) onlyOwner {
266       feeWallet = _feeWallet;
267     }
268 
269     function setFee(uint256 _fee) onlyOwner {
270       fee = _fee;
271     }
272 
273 }