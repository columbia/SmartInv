1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-09
3 */
4 //integer overflowx
5 pragma solidity ^0.4.16;

6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     return c;
14   }

15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }

21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     return a - b;
23   }

24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     return c;
27   }
28 }

29 /**
30  * @title ERC20Basic
31  * @dev Simpler version of ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/179
33  */
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) public constant returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }

40 /**
41  * @title Basic token
42  * @dev Basic version of StandardToken, with no allowances.
43  */
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;

46   mapping(address => uint256) balances;

47   /**
48   * @dev transfer token for a specified address
49   * @param _to The address to transfer to.
50   * @param _value The amount to be transferred.
51   */
52   function transfer(address _to, uint256 _value) public returns (bool) {
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }

59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 }

68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public constant returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }


78 /**
79  * @title Standard ERC20 token
80  *
81  * @dev Implementation of the basic standard token.
82  * @dev https://github.com/ethereum/EIPs/issues/20
83  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
84  */
85 contract StandardToken is ERC20, BasicToken {

86   mapping (address => mapping (address => uint256)) internal allowed;


87   /**
88    * @dev Transfer tokens from one address to another
89    * @param _from address The address which you want to send tokens from
90    * @param _to address The address which you want to transfer to
91    * @param _value uint256 the amount of tokens to be transferred
92    */
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }

100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    *
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }

115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifying the amount of tokens still available for the spender.
120    */
121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 }

125 /**
126  * @title Ownable
127  * @dev The Ownable contract has an owner address, and provides basic authorization control
128  * functions, this simplifies the implementation of "user permissions".
129  */
130 contract Ownable {
131   address public owner;


132   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


133   /**
134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135    * account.
136    */
137   function Ownable() {
138     owner = msg.sender;
139   }


140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     _;
145   }


146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) onlyOwner public {
151     OwnershipTransferred(owner, newOwner);
152     owner = newOwner;
153   }

154 }

155 /**
156  * @title Pausable
157  * @dev Base contract which allows children to implement an emergency stop mechanism.
158  */
159 contract Pausable is Ownable {
160   event Pause();
161   event Unpause();

162   bool public paused = false;


163   /**
164    * @dev Modifier to make a function callable only when the contract is not paused.
165    */
166   modifier whenNotPaused() {
167     _;
168   }

169   /**
170    * @dev Modifier to make a function callable only when the contract is paused.
171    */
172   modifier whenPaused() {
173     _;
174   }

175   /**
176    * @dev called by the owner to pause, triggers stopped state
177    */
178   function pause() onlyOwner whenNotPaused public {
179     paused = true;
180     Pause();
181   }

182   /**
183    * @dev called by the owner to unpause, returns to normal state
184    */
185   function unpause() onlyOwner whenPaused public {
186     paused = false;
187     Unpause();
188   }
189 }

190 /**
191  * @title Pausable token
192  *
193  * @dev StandardToken modified with pausable transfers.
194  **/

195 contract PausableToken is StandardToken, Pausable {

196   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
197     return super.transfer(_to, _value);
198   }

199   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
200     return super.transferFrom(_from, _to, _value);
201   }

202   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
203     return super.approve(_spender, _value);
204   }
  
205   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
206     uint cnt = _receivers.length;
207     uint256 amount = uint256(cnt) * _value;

208     balances[msg.sender] = balances[msg.sender].sub(amount);
209     for (uint i = 0; i < cnt; i++) {
210         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
211         Transfer(msg.sender, _receivers[i], _value);
212     }
213     return true;
214   }
215 }

216 /**
217  * @title Bec Token
218  *
219  * @dev Implementation of Bec Token based on the basic standard token.
220  */
221 contract BecToken is PausableToken {
222     /**
223     * Public variables of the token
224     * The following variables are OPTIONAL vanities. One does not have to include them.
225     * They allow one to customise the token contract & in no way influences the core functionality.
226     * Some wallets/interfaces might not even bother to look at this information.
227     */
228     string public name = "BeautyChain";
229     string public symbol = "BEC";
230     string public version = '1.0.0';
231     uint8 public decimals = 18;

232     /**
233      * @dev Function to check the amount of tokens that an owner allowed to a spender.
234      */
235     function BecToken() {
236       totalSupply = 7000000000 * (10**(uint256(decimals)));
237       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
238     }

239     function () {
240         //if ether is sent to this address, send it back.
241         revert();
242     }
243 }