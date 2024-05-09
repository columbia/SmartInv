1 pragma solidity ^0.4.18;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
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
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     require (_value == 0 || allowed[msg.sender][_spender] == 0);
175 
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
197   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
204     if (_subtractedValue > allowed[msg.sender][_spender]) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
208     }
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 }
213 
214 contract Mtc is StandardToken, Ownable {
215   event WalletFunded(address wallet, uint256 amount);
216   
217   string public name;
218   string public symbol;
219   uint8 public decimals;
220   address public wallet;
221 
222   function Mtc(string _name, string _symbol, uint256 _totalSupply, uint8 _decimals, address _multiSig) public {
223     require(_multiSig != address(0));
224     require(_multiSig != msg.sender);
225     require(_totalSupply > 0);
226     name = _name;
227     symbol = _symbol;
228     totalSupply = _totalSupply;
229     decimals = _decimals;
230     wallet = _multiSig;
231 
232     /** todos los tokens a la cartera principal */
233     fundWallet(_multiSig, _totalSupply);
234 
235     /** transferimos el ownership */
236     transferOwnership(_multiSig);
237  }
238 
239  function fundWallet(address _wallet, uint256 _amount) internal {
240      /** validaciones */
241     require(_wallet != address(0));
242     require(_amount > 0);
243      
244      balances[_wallet] = balances[_wallet].add(_amount);
245 
246      /** notificamos la operación */
247      WalletFunded(_wallet, _amount);
248      Transfer(address(0), _wallet, _amount);
249  }
250 }