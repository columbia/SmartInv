1 pragma solidity ^0.4.18;
2 
3 // File: contracts/helpers/Owned.sol
4 
5 pragma solidity ^0.4.19;
6 
7 contract Owned {
8   address public ownerAddr;
9 
10   function Owned() internal {
11     ownerAddr = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == ownerAddr);
16     _;
17   }
18 
19   function transferOwnership(address _newOwner) public onlyOwner {
20     require(_newOwner != address(0));
21 
22     ownerAddr = _newOwner;
23   }
24 
25 }
26 
27 // File: zeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     if (a == 0) {
40       return 0;
41     }
42     uint256 c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   /**
58   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   function totalSupply() public view returns (uint256);
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) balances;
99 
100   uint256 totalSupply_;
101 
102   /**
103   * @dev total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return totalSupply_;
107   }
108 
109   /**
110   * @dev transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender) public view returns (uint256);
144   function transferFrom(address from, address to, uint256 value) public returns (bool);
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    *
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(address _owner, address _spender) public view returns (uint256) {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    *
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To decrement
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _subtractedValue The amount of tokens to decrease the allowance by.
232    */
233   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
234     uint oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue > oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 // File: contracts/token/TweetherToken.sol
247 
248 // contracts/token/TweetherToken.sol
249 
250 pragma solidity ^0.4.19;
251 
252 
253 
254 contract TweetherToken is StandardToken, Owned {
255   string public name = "TweetherToken";
256   string public symbol = "TWE";
257   uint8 public decimals = 0;
258 
259   uint256 public FOR_ICO = 750000;
260   uint256 public FOR_FOUNDER = 250000;
261 
262   function TweetherToken() public {
263     totalSupply_ = FOR_FOUNDER + FOR_ICO;
264     balances[msg.sender] = totalSupply_;
265   }
266 
267   function fundICO(address _icoAddr) onlyOwner public {
268     transfer(_icoAddr, FOR_ICO);
269   }
270 }