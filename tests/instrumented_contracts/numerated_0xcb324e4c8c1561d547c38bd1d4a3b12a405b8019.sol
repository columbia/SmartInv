1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   uint256 public maxPVB;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     emit OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic,Ownable {
87   using SafeMath for uint256;
88   bool public transfersEnabled;
89   mapping(address => uint256) balances;
90   mapping (address => mapping (address => uint256)) internal allowed;
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public  returns (bool) {
98     require(transfersEnabled);
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint256 the amount of tokens to be transferred
123    */
124   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125 		require(transfersEnabled);
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     emit Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public view returns (uint256) {
160     return allowed[_owner][_spender];
161   }
162 
163   function enableTransfers(bool _transfersEnabled) public onlyOwner {
164       transfersEnabled = _transfersEnabled;
165   }
166 }
167 
168 contract DetailedERC20 is  BasicToken {
169   string public name;
170   string public symbol;
171   uint8 public decimals;
172  function DetailedERC20(uint256 _totalSupply,string _name, string _symbol, uint8 _decimals) public {
173     name = _name;
174     symbol = _symbol;
175     decimals = _decimals;
176     totalSupply = _totalSupply;
177     maxPVB = _totalSupply;
178     balances[owner] = _totalSupply;
179   }
180 }
181 
182 /**
183  * @title Burnable Token
184  * @dev Token that can be irreversibly burned (destroyed).
185  */
186 contract BurnableToken is BasicToken {
187 
188     event Burn(address indexed burner, uint256 value);
189 
190     /**
191      * @dev Burns a specific amount of tokens.
192      * @param _value The amount of token to be burned.
193      */
194     function burn(uint256 _value) public {
195         require(_value <= balances[msg.sender]);
196         // no need to require value <= totalSupply, since that would imply the
197         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
198         address burner = msg.sender;
199         balances[burner] = balances[burner].sub(_value);
200         totalSupply = totalSupply.sub(_value);
201         emit Burn(burner, _value);
202     }
203 }
204 
205 contract PVBToken is  BurnableToken, DetailedERC20 {
206     uint8 constant DECIMALS = 18;
207     string constant NAME = "Points Value Bank";
208     string constant SYM = "PVB";
209     uint256 constant MAXPVB = 50 * 10**8 * 10**18;
210     function PVBToken() DetailedERC20 (MAXPVB,NAME, SYM, DECIMALS) public {}
211 }