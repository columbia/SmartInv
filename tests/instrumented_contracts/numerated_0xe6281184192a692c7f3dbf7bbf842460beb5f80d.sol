1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   uint256 public maxDGAME;
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
125     require(_to != address(0));
126     require(_value <= balances[_from]);
127     require(_value <= allowed[_from][msg.sender]);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132     emit Transfer(_from, _to, _value);
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
148     emit Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifying the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) public view returns (uint256) {
159     return allowed[_owner][_spender];
160   }
161 
162   function enableTransfers(bool _transfersEnabled) public onlyOwner {
163       transfersEnabled = _transfersEnabled;
164   }
165 }
166 
167 contract DetailedERC20 is  BasicToken {
168   string public name;
169   string public symbol;
170   uint8 public decimals;
171  function DetailedERC20(uint256 _totalSupply,string _name, string _symbol, uint8 _decimals) public {
172     name = _name;
173     symbol = _symbol;
174     decimals = _decimals;
175     totalSupply = _totalSupply;
176     maxDGAME = _totalSupply;
177     balances[owner] = _totalSupply;
178   }
179 }
180 
181 /**
182  * @title Burnable Token
183  * @dev Token that can be irreversibly burned (destroyed).
184  */
185 contract BurnableToken is BasicToken {
186 
187     event Burn(address indexed burner, uint256 value);
188 
189     /**
190      * @dev Burns a specific amount of tokens.
191      * @param _value The amount of token to be burned.
192      */
193     function burn(uint256 _value) public {
194         require(_value <= balances[msg.sender]);
195         // no need to require value <= totalSupply, since that would imply the
196         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
197 
198         address burner = msg.sender;
199         balances[burner] = balances[burner].sub(_value);
200         totalSupply = totalSupply.sub(_value);
201         emit Burn(burner, _value);
202     }
203 }
204 
205 contract DGAMEToken is  BurnableToken, DetailedERC20 {
206     uint8 constant DECIMALS = 18;
207     string constant NAME = "DGAMEToken";
208     string constant SYM = "DGAME";
209     uint256 constant MAXDGAME = 100 * 10**8 * 10**18;
210     function DGAMEToken() DetailedERC20 (MAXDGAME,NAME, SYM, DECIMALS) public {}
211 }