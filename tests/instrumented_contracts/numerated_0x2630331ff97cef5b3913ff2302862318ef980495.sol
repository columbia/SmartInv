1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev revert()s if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to. 
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 
43 
44 /**
45  * Math operations with safety checks
46  */
47 library SafeMath {
48   
49   
50   function mul256(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55 
56   function div256(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b > 0); // Solidity automatically revert()s when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub256(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b <= a);
65     return a - b;
66   }
67 
68   function add256(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }  
73   
74 
75   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
76     return a >= b ? a : b;
77   }
78 
79   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
80     return a < b ? a : b;
81   }
82 
83   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
84     return a >= b ? a : b;
85   }
86 
87   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
88     return a < b ? a : b;
89   }
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  */
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) constant public returns (uint256);
100   function transfer(address to, uint256 value) public;
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev ERC20 interface with allowances. 
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) constant public returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public;
114   function approve(address spender, uint256 value) public;
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances. 
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   /**
131    * @dev Fix for the ERC20 short address attack.
132    */
133   modifier onlyPayloadSize(uint size) {
134      require(msg.data.length >= size + 4);
135      _;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public {
144     balances[msg.sender] = balances[msg.sender].sub256(_value);
145     balances[_to] = balances[_to].add256(_value);
146     Transfer(msg.sender, _to, _value);
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of. 
152   * @return An uint representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) constant public returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 
161 
162 
163 /**
164  * @title Standard ERC20 token
165  * @dev Implemantation of the basic standart token.
166  */
167 contract StandardToken is BasicToken, ERC20 {
168 
169   mapping (address => mapping (address => uint256)) allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint the amout of tokens to be transfered
177    */
178   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public {
179     var _allowance = allowed[_from][msg.sender];
180 
181     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
182     // if (_value > _allowance) revert();
183 
184     balances[_to] = balances[_to].add256(_value);
185     balances[_from] = balances[_from].sub256(_value);
186     allowed[_from][msg.sender] = _allowance.sub256(_value);
187     Transfer(_from, _to, _value);
188   }
189 
190   /**
191    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public {
196 
197     //  To change the approve amount you first have to reduce the addresses
198     //  allowance to zero by calling `approve(_spender, 0)` if it is not
199     //  already 0 to mitigate the race condition described here:
200     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
202 
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens than an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint specifing the amount of tokens still avaible for the spender.
212    */
213   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
214     return allowed[_owner][_spender];
215   }
216 
217 
218 }
219 
220 
221 
222 /**
223  * @title EcoToken
224  * @dev The main EcoToken contract
225  * 
226  */
227  
228 contract EcoToken is StandardToken, Ownable{
229   string public name = "BlockchainEcoToken";
230   string public symbol = "ETS";
231   uint public decimals = 8;
232 
233   event TokenBurned(uint256 value);
234   
235   function EcoToken() public {
236     totalSupply = (10 ** 8) * (10 ** decimals);
237     balances[msg.sender] = totalSupply;
238   }
239 
240   /**
241    * @dev Allows the owner to burn the token
242    * @param _value number of tokens to be burned.
243    */
244   function burn(uint _value) onlyOwner public {
245     require(balances[msg.sender] >= _value);
246     balances[msg.sender] = balances[msg.sender].sub256(_value);
247     totalSupply = totalSupply.sub256(_value);
248     TokenBurned(_value);
249   }
250 
251 }