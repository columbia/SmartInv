1 pragma solidity ^0.4.18;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48   mapping(address => uint256) balances;
49   /**
50   * @dev transfer token for a specified address
51   * @param _to The address to transfer to.
52   * @param _value The amount to be transferred.
53   */
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63   /**
64   * @dev Gets the balance of the specified address.
65   * @param _owner The address to query the the balance of.
66   * @return An uint256 representing the amount owned by the passed address.
67   */
68   function balanceOf(address _owner) public view returns (uint256 balance) {
69     return balances[_owner];
70   }
71 }
72 contract StandardToken is ERC20, BasicToken {
73   mapping (address => mapping (address => uint256)) internal allowed;
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amount of tokens to be transferred
79    */
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90   /**
91    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
92    *
93    * Beware that changing an allowance with this method brings the risk that someone may use both the old
94    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
95    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
96    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97    * @param _spender The address which will spend the funds.
98    * @param _value The amount of tokens to be spent.
99    */
100   function approve(address _spender, uint256 _value) public returns (bool) {
101     require (_value == 0 || allowed[msg.sender][_spender] == 0);
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106   /**
107    * @dev Function to check the amount of tokens that an owner allowed to a spender.
108    * @param _owner address The address which owns the funds.
109    * @param _spender address The address which will spend the funds.
110    * @return A uint256 specifying the amount of tokens still available for the spender.
111    */
112   function allowance(address _owner, address _spender) public view returns (uint256) {
113     return allowed[_owner][_spender];
114   }
115   /**
116    * approve should be called when allowed[_spender] == 0. To increment
117    * allowed value is better to use this function to avoid 2 calls (and wait until
118    * the first transaction is mined)
119    * From MonolithDAO Token.sol
120    */
121   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
122     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
123     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
127     if (_subtractedValue > allowed[msg.sender][_spender]) {
128       allowed[msg.sender][_spender] = 0;
129     } else {
130       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
131     }
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 }
136 contract Ownable {
137   address public owner;
138   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   function Ownable() public {
144     owner = msg.sender;
145   }
146   /**
147    * @dev Throws if called by any account other than the owner.
148    */
149   modifier onlyOwner() {
150     require(msg.sender == owner);
151     _;
152   }
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address newOwner) public onlyOwner {
158     require(newOwner != address(0));
159     OwnershipTransferred(owner, newOwner);
160     owner = newOwner;
161   }
162 }
163 contract MTC is StandardToken, Ownable {
164   event WalletFunded(address wallet, uint256 amount);
165   
166   string public name;
167   string public symbol;
168   uint8 public decimals;
169   address public wallet;
170   function MTC(string _name, string _symbol, uint256 _totalSupply, uint8 _decimals, address _multiSig) public {
171     require(_multiSig != address(0));
172     require(_multiSig != msg.sender);
173     require(_totalSupply > 0);
174     name = _name;
175     symbol = _symbol;
176     totalSupply = _totalSupply;
177     decimals = _decimals;
178     wallet = _multiSig;
179     /** todos los tokens a la cartera principal */
180     fundWallet(_multiSig, _totalSupply);
181     /** transferimos el ownership */
182     transferOwnership(_multiSig);
183  }
184  function fundWallet(address _wallet, uint256 _amount) internal {
185      /** validaciones */
186     require(_wallet != address(0));
187     require(_amount > 0);
188      
189      balances[_wallet] = balances[_wallet].add(_amount);
190      /** notificamos la operación */
191      WalletFunded(_wallet, _amount);
192      Transfer(address(0), _wallet, _amount);
193  }
194 }