1 pragma solidity ^0.4.13;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value);
52   function approve(address spender, uint256 value);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /*
57  * Ownable
58  *
59  * Base contract with an owner.
60  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
61  */
62 contract Ownable {
63   address public owner;
64 
65   function Ownable() {
66     owner = msg.sender;
67   }
68 
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   function transferOwnership(address newOwner) onlyOwner {
75     if (newOwner != address(0)) {
76       owner = newOwner;
77     }
78   }
79 
80   function unown() onlyOwner {
81     owner = address(0);
82   }
83 
84 }
85 
86 contract Transferable is Ownable {
87 
88   bool public transfersAllowed = false;
89   mapping(address => bool) allowedTransfersTo;
90 
91   function Transferable() {
92     allowedTransfersTo[msg.sender] = true;
93   }
94 
95   modifier onlyIfTransfersAllowed() {
96     require(transfersAllowed == true || allowedTransfersTo[msg.sender] == true);
97     _;
98   }
99 
100   function allowTransfers() onlyOwner {
101     transfersAllowed = true;
102   }
103 
104   function disallowTransfers() onlyOwner {
105     transfersAllowed = false;
106   }
107 
108   function allowTransfersTo(address _owner) onlyOwner {
109     allowedTransfersTo[_owner] = true;
110   }
111 
112   function disallowTransfersTo(address _owner) onlyOwner {
113     allowedTransfersTo[_owner] = false;
114   }
115 
116   function transfersAllowedTo(address _owner) constant returns (bool) {
117     return (transfersAllowed == true || allowedTransfersTo[_owner] == true);
118   }
119 
120 }
121 
122 /**
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances. 
125  */
126 contract BasicToken is ERC20Basic, Transferable {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   /**
132    * @dev Fix for the ERC20 short address attack.
133    */
134   modifier onlyPayloadSize(uint256 size) {
135      require(msg.data.length >= size + 4);
136      _;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyIfTransfersAllowed {
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of. 
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) constant returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implemantation of the basic standart token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is BasicToken, ERC20 {
169 
170   mapping (address => mapping (address => uint256)) allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amout of tokens to be transfered
178    */
179   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) onlyIfTransfersAllowed {
180     var _allowance = allowed[_from][msg.sender];
181 
182     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
183     // if (_value > _allowance) throw;
184 
185     balances[_to] = balances[_to].add(_value);
186     balances[_from] = balances[_from].sub(_value);
187     allowed[_from][msg.sender] = _allowance.sub(_value);
188     Transfer(_from, _to, _value);
189   }
190 
191   /**
192    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) {
197 
198     // To change the approve amount you first have to reduce the addresses`
199     //  allowance to zero by calling `approve(_spender, 0)` if it is not
200     //  already 0 to mitigate the race condition described here:
201     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
203 
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifing the amount of tokens still avaible for the spender.
213    */
214   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
215     return allowed[_owner][_spender];
216   }
217 
218 }
219 
220 /**
221  * @title SimpleToken
222  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
223  * Note they can later distribute these tokens as they wish using `transfer` and other
224  * `StandardToken` functions.
225  */
226 contract DesToken is StandardToken {
227 
228   string public name = "DES Token";
229   string public symbol = "DES";
230   uint256 public decimals = 18;
231   uint256 public INITIAL_SUPPLY = 35000000 * 1 ether;
232 
233   /**
234    * @dev Contructor that gives msg.sender all of existing tokens. 
235    */
236   function DesToken() {
237     totalSupply = INITIAL_SUPPLY;
238     balances[msg.sender] = INITIAL_SUPPLY;
239   }
240 
241 }