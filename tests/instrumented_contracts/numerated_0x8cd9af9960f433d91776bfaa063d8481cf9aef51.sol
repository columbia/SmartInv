1 pragma solidity ^0.4.18;
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
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38 
39   address public owner;
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) onlyOwner {
62     require(newOwner != address(0));
63     owner = newOwner;
64   }
65 }
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73   uint256 public totalSupply;
74   function balanceOf(address who) constant returns (uint256);
75   function transfer(address to, uint256 value) returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) returns (bool) {
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
105   function balanceOf(address _owner) constant returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint256);
117   function transferFrom(address from, address to, uint256 value) returns (bool);
118   function approve(address spender, uint256 value) returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken, Ownable {
130 
131   mapping (address => mapping (address => uint256)) allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amout of tokens to be transfered
139    */
140   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
141     var _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // require (_value <= _allowance);
145 
146     balances[_to] = balances[_to].add(_value);
147     balances[_from] = balances[_from].sub(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) returns (bool) {
159 
160     // To change the approve amount you first have to reduce the addresses`
161     //  allowance to zero by calling `approve(_spender, 0)` if it is not
162     //  already 0 to mitigate the race condition described here:
163     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
165 
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169 
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifing the amount of tokens still available for the spender.
177    * also adding burn function and event.
178    */
179   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
180     return allowed[_owner][_spender];
181   }
182   event Burn(address indexed burner, uint256 value);
183   function burn(uint256 _value) public onlyOwner {
184         require(_value > 0);
185         require(_value <= balances[msg.sender]);
186         // no need to require value <= totalSupply, since that would imply the
187         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
188 
189         address burner = msg.sender;
190         balances[burner] = balances[burner].sub(_value);
191         totalSupply = totalSupply.sub(_value);
192         Burn(burner, _value);
193     }
194 
195 
196 }
197 
198 /**
199  * @title SimpleToken
200  * 
201  * 
202  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
203  * Note they can later distribute these tokens as they wish using `transfer` and other
204  * `StandardToken` functions.
205  */
206 contract Voicecoin is StandardToken {
207 
208   string public constant name = "Voicecoin";
209   string public constant symbol = "VC";
210   uint256 public constant decimals = 18;
211 
212   uint256 public constant INITIAL_SUPPLY = 2100000000*10**18;
213 
214   /**
215    * @dev Contructor that gives msg.sender all of existing tokens.
216    */
217   function Voicecoin() {
218     totalSupply = INITIAL_SUPPLY;
219     balances[msg.sender] = INITIAL_SUPPLY;
220   }
221 
222 }