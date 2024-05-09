1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 x, uint256 y) internal returns (uint256) {
9         uint256 z = x + y;
10         assert((z >= x) && (z >= y));
11         return z;
12     }
13 
14     function sub(uint256 x, uint256 y) internal returns (uint256) {
15         assert(x >= y);
16         uint256 z = x - y;
17         return z;
18     }
19 
20     function mul(uint256 x, uint256 y) internal returns (uint256) {
21         uint256 z = x * y;
22         assert((x == 0) || (z / x == y));
23         return z;
24     }
25 }
26 
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner {
60     if (newOwner != address(0)) {
61       owner = newOwner;
62     }
63   }
64 
65 }
66 /*
67  * Haltable
68  *
69  * Abstract contract that allows children to implement an
70  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
71  *
72  *
73  * Originally envisioned in FirstBlood ICO contract.
74  */
75 contract Haltable is Ownable {
76   bool public halted;
77 
78   modifier stopInEmergency {
79     require (!halted);
80     _;
81   }
82 
83   modifier onlyInEmergency {
84     require (halted);
85     _;
86   }
87 
88   // called by the owner on emergency, triggers stopped state
89   function halt() external onlyOwner {
90     halted = true;
91   }
92 
93   // called by the owner on end of emergency, returns to normal state
94   function unhalt() external onlyOwner onlyInEmergency {
95     halted = false;
96   }
97 
98 }
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   uint256 public totalSupply;
107   function balanceOf(address who) constant returns (uint256);
108   function transfer(address to, uint256 value) returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract DGZ is ERC20Basic {
118   function allowance(address owner, address spender) constant returns (uint256);
119   function transferFrom(address from, address to, uint256 value) returns (bool);
120   function approve(address spender, uint256 value) returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances. 
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) returns (bool) {
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     Transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of. 
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) constant returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is DGZ, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amout of tokens to be transfered
175    */
176   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
177     var _allowance = allowed[_from][msg.sender];
178 
179     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
180     // require (_value <= _allowance);
181 
182     balances[_to] = balances[_to].add(_value);
183     balances[_from] = balances[_from].sub(_value);
184     allowed[_from][msg.sender] = _allowance.sub(_value);
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) returns (bool) {
195 
196     // To change the approve amount you first have to reduce the addresses`
197     //  allowance to zero by calling `approve(_spender, 0)` if it is not
198     //  already 0 to mitigate the race condition described here:
199     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
201 
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifing the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
214     return allowed[_owner][_spender];
215   }
216 
217 }
218 
219 contract DGZToken is StandardToken {
220     using SafeMath for uint256;
221 
222     /*/ Public variables of the token /*/
223     string public constant name = "Dogezer DGZ Token";
224     string public constant symbol = "DGZ";
225     uint8 public decimals = 8;
226     uint256 public totalSupply = 10000000000000000;
227 
228     /*/ Initializes contract with initial supply tokens to the creator of the contract /*/
229     function DGZToken() 
230     {
231         balances[msg.sender] = totalSupply;              // Give the creator all initial tokens
232     }
233 }