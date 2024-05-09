1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       throw;
28     }
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to. 
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) constant returns (uint256);
49   function transfer(address to, uint256 value) returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66   function mul(uint256 a, uint256 b) internal returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function div(uint256 a, uint256 b) internal returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   function sub(uint256 a, uint256 b) internal returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint256 a, uint256 b) internal returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances. 
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) returns (bool) {
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
118   function balanceOf(address _owner) constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // if (_value > _allowance) throw;
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
168 
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifing the amount of tokens still avaible for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 
187 contract GenesisToken is StandardToken, Ownable {
188   using SafeMath for uint256;
189 
190   // metadata
191   string public constant name = 'Genesis';
192   string public constant symbol = 'GNS';
193   uint256 public constant decimals = 18;
194   string public version = '0.0.1';
195 
196   // events
197   event EarnedGNS(address indexed contributor, uint256 amount);
198   event TransferredGNS(address indexed from, address indexed to, uint256 value);
199 
200   // constructor
201   function GenesisToken(
202     address _owner,
203     uint256 initialBalance)
204   {
205     owner = _owner;
206     totalSupply = initialBalance;
207     balances[_owner] = initialBalance;
208     EarnedGNS(_owner, initialBalance);
209   }
210 
211   /**
212    * @dev Function to mint tokens
213    * @param _to The address that will recieve the minted tokens.
214    * @param _amount The amount of tokens to mint.
215    * @return A boolean that indicates if the operation was successful.
216    */
217   function giveTokens(address _to, uint256 _amount) onlyOwner returns (bool) {
218     totalSupply = totalSupply.add(_amount);
219     balances[_to] = balances[_to].add(_amount);
220     EarnedGNS(_to, _amount);
221     return true;
222   }
223 }