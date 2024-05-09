1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
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
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   function balanceOf(address who) public view returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 // File: zeppelin-solidity/contracts/token/BasicToken.sol
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     // SafeMath.sub will throw if there is not enough balance.
116     balances[msg.sender] = balances[msg.sender].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     emit Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public view returns (uint256 balance) {
128     return balances[_owner];
129   }
130 
131 }
132 
133 // File: zeppelin-solidity/contracts/token/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender) public view returns (uint256);
141   function transferFrom(address from, address to, uint256 value) public returns (bool);
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 // File: zeppelin-solidity/contracts/token/StandardToken.sol
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     emit Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217     uint oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 // File: contracts/erc20.sol
230 
231 /**
232  * @title Main (Entry Point) 
233  */
234 contract GBMToken is StandardToken, Ownable {
235     string public constant name = "GlamBeautyCoin";
236     string public constant symbol = "GBM";
237     uint8 public constant decimals = 18;
238 	uint256 public totalSupply = 10000000000 * (10 ** uint256(decimals));
239 
240     /**
241      * @dev Constructor that gives msg.sender all of existing tokens.
242      */
243     function GBMToken() public {
244         balances[msg.sender] = totalSupply;
245     }
246 }