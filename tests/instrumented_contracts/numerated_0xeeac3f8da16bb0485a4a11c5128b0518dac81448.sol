1 pragma solidity 0.4.14;
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
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev revert()s if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       revert();
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 
46 /**
47  * Math operations with safety checks
48  */
49 library SafeMath {
50   
51   
52   function mul256(uint256 a, uint256 b) internal returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div256(uint256 a, uint256 b) internal returns (uint256) {
59     require(b > 0); // Solidity automatically revert()s when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub256(uint256 a, uint256 b) internal returns (uint256) {
66     require(b <= a);
67     return a - b;
68   }
69 
70   function add256(uint256 a, uint256 b) internal returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }  
75   
76 
77   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
78     return a >= b ? a : b;
79   }
80 
81   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
82     return a < b ? a : b;
83   }
84 
85   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
86     return a >= b ? a : b;
87   }
88 
89   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
90     return a < b ? a : b;
91   }
92 }
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  */
99 contract ERC20Basic {
100   uint256 public totalSupply;
101   function balanceOf(address who) constant returns (uint256);
102   function transfer(address to, uint256 value);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev ERC20 interface with allowances. 
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) constant returns (uint256);
115   function transferFrom(address from, address to, uint256 value);
116   function approve(address spender, uint256 value);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances. 
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   /**
133    * @dev Fix for the ERC20 short address attack.
134    */
135   modifier onlyPayloadSize(uint size) {
136      if(msg.data.length < size + 4) {
137        revert();
138      }
139      _;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
148     balances[msg.sender] = balances[msg.sender].sub256(_value);
149     balances[_to] = balances[_to].add256(_value);
150     Transfer(msg.sender, _to, _value);
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of. 
156   * @return An uint representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) constant returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 
165 
166 
167 /**
168  * @title Standard ERC20 token
169  * @dev Implemantation of the basic standart token.
170  */
171 contract StandardToken is BasicToken, ERC20 {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint the amout of tokens to be transfered
181    */
182   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
183     var _allowance = allowed[_from][msg.sender];
184 
185     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
186     // if (_value > _allowance) revert();
187 
188     balances[_to] = balances[_to].add256(_value);
189     balances[_from] = balances[_from].sub256(_value);
190     allowed[_from][msg.sender] = _allowance.sub256(_value);
191     Transfer(_from, _to, _value);
192   }
193 
194   /**
195    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) {
200 
201     //  To change the approve amount you first have to reduce the addresses
202     //  allowance to zero by calling `approve(_spender, 0)` if it is not
203     //  already 0 to mitigate the race condition described here:
204     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
206 
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens than an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint specifing the amount of tokens still avaible for the spender.
216    */
217   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
218     return allowed[_owner][_spender];
219   }
220 
221 
222 }
223 
224 
225 
226 /**
227  * @title TeuToken
228  * @dev The main TEU token contract
229  * 
230  */
231  
232 contract TeuToken is StandardToken, Ownable{
233   string public name = "20-footEqvUnit";
234   string public symbol = "TEU";
235   uint public decimals = 18;
236 
237   event TokenBurned(uint256 value);
238   
239   function TeuToken() {
240     totalSupply = (10 ** 8) * (10 ** decimals);
241     balances[msg.sender] = totalSupply;
242   }
243 
244   /**
245    * @dev Allows the owner to burn the token
246    * @param _value number of tokens to be burned.
247    */
248   function burn(uint _value) onlyOwner {
249     require(balances[msg.sender] >= _value);
250     balances[msg.sender] = balances[msg.sender].sub256(_value);
251     totalSupply = totalSupply.sub256(_value);
252     TokenBurned(_value);
253   }
254 
255 }