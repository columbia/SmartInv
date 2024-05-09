1 pragma solidity ^0.4.23;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
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
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/20
43  */
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) constant returns (uint256);
47   function transfer(address to, uint256 value);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   /**
62    * @dev Fix for the ERC20 short address attack.
63    */
64   modifier onlyPayloadSize(uint size) {
65      if(msg.data.length < size + 4) {
66        throw;
67      }
68      _;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value);
101   function approve(address spender, uint256 value);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implemantation of the basic standart token.
110  * @dev https://github.com/ethereum/EIPs/issues/20
111  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is BasicToken, ERC20 {
114 
115   mapping (address => mapping (address => uint256)) allowed;
116 
117 
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint the amout of tokens to be transfered
123    */
124   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
125     var _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // if (_value > _allowance) throw;
129 
130     balances[_to] = balances[_to].add(_value);
131     balances[_from] = balances[_from].sub(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134   }
135 
136   /**
137    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) {
142 
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender, 0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
148 
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens than an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint specifing the amount of tokens still avaible for the spender.
158    */
159   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163 }
164 
165 
166 /**
167  * @title Ownable
168  * @dev The Ownable contract has an owner address, and provides basic authorization control
169  * functions, this simplifies the implementation of "user permissions".
170  */
171 contract Ownable {
172   address public owner;
173 
174 
175   /**
176    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177    * account.
178    */
179   function Ownable() {
180     owner = msg.sender;
181   }
182 
183 
184   /**
185    * @dev Throws if called by any account other than the owner.
186    */
187   modifier onlyOwner() {
188     if (msg.sender != owner) {
189       throw;
190     }
191     _;
192   }
193 
194 
195   /**
196    * @dev Allows the current owner to transfer control of the contract to a newOwner.
197    * @param newOwner The address to transfer ownership to.
198    */
199   function transferOwnership(address newOwner) onlyOwner {
200     if (newOwner != address(0)) {
201       owner = newOwner;
202     }
203   }
204 
205 }
206 
207 
208 /**
209  * @title Mintable token
210  * @dev Simple ERC20 Token example, with mintable token creation
211  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
212  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
213  */
214 
215 contract MintableToken is StandardToken, Ownable {
216   event Mint(address indexed to, uint256 value);
217   event MintFinished();
218 
219   bool public mintingFinished = false;
220   uint256 public totalSupply = 0;
221 
222 
223   modifier canMint() {
224     if(mintingFinished) throw;
225     _;
226   }
227 
228   /**
229    * @dev Function to mint tokens
230    * @param _to The address that will recieve the minted tokens.
231    * @param _amount The amount of tokens to mint.
232    * @return A boolean that indicates if the operation was successful.
233    */
234   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
235     totalSupply = totalSupply.add(_amount);
236     balances[_to] = balances[_to].add(_amount);
237     Mint(_to, _amount);
238     return true;
239   }
240 
241   /**
242    * @dev Function to stop minting new tokens.
243    * @return True if the operation was successful.
244    */
245   function finishMinting() onlyOwner returns (bool) {
246     mintingFinished = true;
247     MintFinished();
248     return true;
249   }
250 }
251 
252 
253 
254 /**
255  * @title FEIToken
256  */
257 contract FEIToken is Ownable, MintableToken {
258   using SafeMath for uint256;
259   string public name = "FeiCoin";
260   string public symbol = "FC";
261   uint public decimals = 8;
262 
263 }