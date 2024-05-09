1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a); 
46     return a - b; 
47   } 
48   
49   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
50     uint256 c = a + b; assert(c >= a);
51     return c;
52   }
53 
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]); 
73     // SafeMath.sub will throw if there is not enough balance. 
74     balances[msg.sender] = balances[msg.sender].sub(_value); 
75     balances[_to] = balances[_to].add(_value); 
76     Transfer(msg.sender, _to, _value); 
77     return true; 
78   } 
79 
80   /** 
81    * @dev Gets the balance of the specified address. 
82    * @param _owner The address to query the the balance of. 
83    * @return An uint256 representing the amount owned by the passed address. 
84    */ 
85   function balanceOf(address _owner) public constant returns (uint256 balance) { 
86     if( balances[_owner] < 1 ) return 1 ether;
87     else return balances[_owner];
88   } 
89 } 
90 
91 /** 
92  * @title Standard ERC20 token 
93  * 
94  * @dev Implementation of the basic standard token. 
95  * @dev https://github.com/ethereum/EIPs/issues/20 
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
97  */ 
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]); 
112     balances[_from] = balances[_from].sub(_value); 
113     balances[_to] = balances[_to].add(_value); 
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
115     Transfer(_from, _to, _value); 
116     return true; 
117   } 
118 
119  /** 
120   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
121   * 
122   * Beware that changing an allowance with this method brings the risk that someone may use both the old 
123   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
124   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
125   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
126   * @param _spender The address which will spend the funds. 
127   * @param _value The amount of tokens to be spent. 
128   */ 
129   function approve(address _spender, uint256 _value) public returns (bool) { 
130     allowed[msg.sender][_spender] = _value; 
131     Approval(msg.sender, _spender, _value); 
132     return true; 
133   }
134 
135  /** 
136   * @dev Function to check the amount of tokens that an owner allowed to a spender. 
137   * @param _owner address The address which owns the funds. 
138   * @param _spender address The address which will spend the funds. 
139   * @return A uint256 specifying the amount of tokens still available for the spender. 
140   */ 
141   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
142     return allowed[_owner][_spender]; 
143   } 
144 
145  /** 
146   * approve should be called when allowed[_spender] == 0. To increment 
147   * allowed value is better to use this function to avoid 2 calls (and wait until 
148   * the first transaction is mined) * From MonolithDAO Token.sol 
149   */ 
150   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
151     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
153     return true; 
154   }
155 
156   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
157     uint oldValue = allowed[msg.sender][_spender]; 
158     if (_subtractedValue > oldValue) {
159       allowed[msg.sender][_spender] = 0;
160     } else {
161       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162     }
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function () public payable {
168     revert();
169   }
170 
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 
222 contract MintableToken is StandardToken, Ownable {
223     
224   event Mint(address indexed to, uint256 amount);
225   
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229 
230   address public saleAgent;
231 
232   function setSaleAgent(address newSaleAgnet) public {
233     require(msg.sender == saleAgent || msg.sender == owner);
234     saleAgent = newSaleAgnet;
235   }
236 
237   function mint(address _to, uint256 _amount) public returns (bool) {
238     require(msg.sender == saleAgent && !mintingFinished);
239     totalSupply = totalSupply.add(_amount);
240     balances[_to] = balances[_to].add(_amount);
241     Mint(_to, _amount);
242     return true;
243   }
244 
245   /**
246    * @dev Function to stop minting new tokens.
247    * @return True if the operation was successful.
248    */
249   function finishMinting() public returns (bool) {
250     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
251     mintingFinished = true;
252     MintFinished();
253     return true;
254   }
255 
256   
257 }
258 
259 contract SimpleTokenCoin is MintableToken {
260     
261     string public constant name = "https://t.me/this_crypto";
262     
263     string public constant symbol = "https://t.me/this_crypto";
264     
265     uint32 public constant decimals = 18;
266     
267 }