1 pragma solidity ^0.4.4;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 /**
45  * @title Basic token
46  * @dev Basic version of StandardToken, with no allowances. 
47  */
48 contract BasicToken is ERC20Basic {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58   function transfer(address _to, uint256 _value) returns (bool) {
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65   /**
66   * @dev Gets the balance of the specified address.
67   * @param _owner The address to query the the balance of. 
68   * @return An uint256 representing the amount owned by the passed address.
69   */
70   function balanceOf(address _owner) constant returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74 }
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) constant returns (uint256);
81   function transferFrom(address from, address to, uint256 value) returns (bool);
82   function approve(address spender, uint256 value) returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 /**
86  * @title Standard ERC20 token
87  *
88  * @dev Implementation of the basic standard token.
89  * @dev https://github.com/ethereum/EIPs/issues/20
90  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
91  */
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) allowed;
95   /**
96    * @dev Transfer tokens from one address to another
97    * @param _from address The address which you want to send tokens from
98    * @param _to address The address which you want to transfer to
99    * @param _value uint256 the amout of tokens to be transfered
100    */
101   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
102     var _allowance = allowed[_from][msg.sender];
103 
104     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
105     // require (_value <= _allowance);
106 
107     balances[_to] = balances[_to].add(_value);
108     balances[_from] = balances[_from].sub(_value);
109     allowed[_from][msg.sender] = _allowance.sub(_value);
110     Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   function approve(address _spender, uint256 _value) returns (bool) {
120 
121     // To change the approve amount you first have to reduce the addresses`
122     //  allowance to zero by calling `approve(_spender, 0)` if it is not
123     //  already 0 to mitigate the race condition described here:
124     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
126 
127     allowed[msg.sender][_spender] = _value;
128     Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifing the amount of tokens still avaible for the spender.
137    */
138   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139     return allowed[_owner][_spender];
140   }
141 
142 }
143 /**
144  * @title Ownable
145  * @dev The Ownable contract has an owner address, and provides basic authorization control
146  * functions, this simplifies the implementation of "user permissions".
147  */
148 contract Ownable {
149   address public owner;
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   function Ownable() {
155     owner = msg.sender;
156   }
157   /**
158    * @dev Throws if called by any account other than the owner.
159    */
160   modifier onlyOwner() {
161     require(msg.sender == owner);
162     _;
163   }
164   /**
165    * @dev Allows the current owner to transfer control of the contract to a newOwner.
166    * @param newOwner The address to transfer ownership to.
167    */
168   function transferOwnership(address newOwner) onlyOwner {
169     if (newOwner != address(0)) {
170       owner = newOwner;
171     }
172   }
173 
174 }
175 /**
176  * @title Contracts that should not own Ether
177  * @author Remco Bloemen <remco@2π.com>
178  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
179  * in the contract, it will allow the owner to reclaim this ether.
180  * @notice Ether can still be send to this contract by:
181  * calling functions labeled `payable`
182  * `selfdestruct(contract_address)`
183  * mining directly to the contract address
184 */
185 contract HasNoEther is Ownable {
186 
187   /**
188   * @dev Constructor that rejects incoming Ether
189   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
190   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
191   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
192   * we could use assembly to access msg.value.
193   */
194   function HasNoEther() payable {
195     require(msg.value == 0);
196   }
197 
198   /**
199    * @dev Disallows direct send by settings a default function without the `payable` flag.
200    */
201   function() external {
202   }
203 
204   /**
205    * @dev Transfer all Ether held by the contract to the owner.
206    */
207   function reclaimEther() external onlyOwner {
208     assert(owner.send(this.balance));
209   }
210 }
211 contract KillingChainToken is StandardToken, Ownable, HasNoEther {
212 
213   string public name = 'KillingChainToken';
214   string public symbol = 'KCT';
215   uint public decimals = 18;
216 
217   // 团队地址
218   // 所有 ETH 入金都会被转到此地址
219   address public founder = 0x0;
220   // 运营推广基金地址
221   address public marketing = 0x0;
222   // ICO 配额地址
223   address public crowdsale = 0x0;
224 
225   // 总量: 1亿
226   uint public totalSupply = 10000 * 10000 * 10**decimals;
227   // 团队持有: 1000万
228   uint public founderAllocation = 1000 * 10000 * 10**decimals;
229   // 运营推广: 4000万
230   uint public marketingAllocation = 4000 * 10000 * 10**decimals;
231   // ICO 募集量: 5000万
232   uint public crowdsaleAllocation = totalSupply - founderAllocation - marketingAllocation;
233   function KillingChainToken(address _founder, address _marketing, address _crowdsale) {
234     require(_founder != address(0));
235     require(_marketing != address(0));
236     require(_crowdsale != address(0));
237     require(_founder != _marketing);
238     require(_founder != _crowdsale);
239     require(_marketing != _crowdsale);
240 
241     founder = _founder;
242     marketing = _marketing;
243     crowdsale = _crowdsale;
244 
245     balances[founder] = founderAllocation;
246     balances[marketing] = marketingAllocation;
247     balances[crowdsale] = crowdsaleAllocation;
248 
249     owner = founder;
250   }
251 
252 }