1 pragma solidity ^0.4.16;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) public constant returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 /**
40  * @title Basic token
41  * @dev Basic version of StandardToken, with no allowances.
42  */
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45   mapping(address => uint256) balances;
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value > 0 && _value <= balances[msg.sender]);
54     // SafeMath.sub will throw if there is not enough balance.
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public constant returns (uint256 balance) {
66     return balances[_owner];
67   }
68 }
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 /**
80  * @title Standard ERC20 token
81  *
82  * @dev Implementation of the basic standard token.
83  * @dev https://github.com/ethereum/EIPs/issues/20
84  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract StandardToken is ERC20, BasicToken {
87   mapping (address => mapping (address => uint256)) internal allowed;
88   /**
89    * @dev Transfer tokens from one address to another
90    * @param _from address The address which you want to send tokens from
91    * @param _to address The address which you want to transfer to
92    * @param _value uint256 the amount of tokens to be transferred
93    */
94   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value > 0 && _value <= balances[_from]);
97     require(_value <= allowed[_from][msg.sender]);
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104   /**
105    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
106    *
107    * Beware that changing an allowance with this method brings the risk that someone may use both the old
108    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111    * @param _spender The address which will spend the funds.
112    * @param _value The amount of tokens to be spent.
113    */
114   function approve(address _spender, uint256 _value) public returns (bool) {
115    
116     //require(_value == 0 || (allowance[msg.sender][_spender] == 0));
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121   /**
122    * @dev Function to check the amount of tokens that an owner allowed to a spender.
123    * @param _owner address The address which owns the funds.
124    * @param _spender address The address which will spend the funds.
125    * @return A uint256 specifying the amount of tokens still available for the spender.
126    */
127   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
128     return allowed[_owner][_spender];
129   }
130 }
131 /**
132  * @title Ownable
133  * @dev The Ownable contract has an owner address, and provides basic authorization control
134  * functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137   address public owner;
138   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   function Ownable() public {
144     owner = msg.sender;
145   }
146   /**
147    * @dev Throws if called by any account other than the owner.
148    */
149   modifier onlyOwner() {
150     require(msg.sender == owner);
151     _;
152   }
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address newOwner) onlyOwner public {
158     require(newOwner != address(0));
159     OwnershipTransferred(owner, newOwner);
160     owner = newOwner;
161   }
162 }
163 /**
164  * @title Pausable
165  * @dev Base contract which allows children to implement an emergency stop mechanism.
166  */
167 contract Pausable is Ownable {
168   event Pause();
169   event Unpause();
170   bool public paused = false;
171   /**
172    * @dev Modifier to make a function callable only when the contract is not paused.
173    */
174   modifier whenNotPaused() {
175     require(!paused);
176     _;
177   }
178   /**
179    * @dev Modifier to make a function callable only when the contract is paused.
180    */
181   modifier whenPaused() {
182     require(paused);
183     _;
184   }
185   /**
186    * @dev called by the owner to pause, triggers stopped state
187    */
188   function pause() onlyOwner whenNotPaused public {
189     paused = true;
190     Pause();
191   }
192   /**
193    * @dev called by the owner to unpause, returns to normal state
194    */
195   function unpause() onlyOwner whenPaused public {
196     paused = false;
197     Unpause();
198   }
199 }
200 /**
201  * @title Pausable token
202  *
203  * @dev StandardToken modified with pausable transfers.
204  **/
205 contract PausableToken is StandardToken, Pausable {
206   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
207     return super.transfer(_to, _value);
208   }
209   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
210     return super.transferFrom(_from, _to, _value);
211   }
212   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
213     return super.approve(_spender, _value);
214   }
215 }
216 /**
217  * @title Not Token
218  *
219  * @dev Implementation of Not Token based on the basic standard token.
220  */
221 contract NotToken is PausableToken {
222     /**
223     * Public variables of the token
224     * The following variables are OPTIONAL vanities. One does not have to include them.
225     * They allow one to customise the token contract & in no way influences the core functionality.
226     * Some wallets/interfaces might not even bother to look at this information.
227     */
228     string public name = "NOTChain";
229     string public symbol = "NOT";
230     string public version = '1.0.0';
231     uint8 public decimals = 2;
232     /**
233      * @dev Function to check the amount of tokens that an owner allowed to a spender.
234      */
235     function NotToken() public {
236       totalSupply = 200000000 * (10**(uint256(decimals)));
237       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
238     }
239     function () public {
240         //if ether is sent to this address, send it back.
241         revert();
242     }
243 }