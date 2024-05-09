1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) constant returns (uint256);
20   function transferFrom(address from, address to, uint256 value) returns (bool);
21   function approve(address spender, uint256 value) returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal constant returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 
54 }
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60 
61   using SafeMath for uint256;
62 
63   modifier onlyPayloadSize(uint size) {
64      assert(msg.data.length == size + 4);
65      _;
66    } 
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158 
159   address public owner;
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() {
166     owner = msg.sender;
167   }
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177   /**
178    * @dev Allows the current owner to transfer control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function transferOwnership(address newOwner) onlyOwner {
182     require(newOwner != address(0));
183     owner = newOwner;
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 
195 contract MintableToken is StandardToken, Ownable {
196 
197   event Mint(address indexed to, uint256 amount);
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201   mapping (address => bool) public crowdsaleContracts;
202 
203   modifier canMint() {
204     require(!mintingFinished);
205     _;
206   }
207 
208   modifier onlyCrowdsaleContract() {
209     require(crowdsaleContracts[msg.sender]);
210     _;
211   }
212 
213   function addCrowdsaleContract(address _crowdsaleContract) onlyOwner {
214     crowdsaleContracts[_crowdsaleContract] = true;
215   }
216 
217   function deleteCrowdsaleContract(address _crowdsaleContract) onlyOwner {
218     require(crowdsaleContracts[_crowdsaleContract]);
219     delete crowdsaleContracts[_crowdsaleContract];
220   }
221   function mint(address _to, uint256 _amount) onlyCrowdsaleContract canMint returns (bool) {
222      
223     totalSupply = totalSupply.add(_amount);
224     balances[_to] = balances[_to].add(_amount);
225     Mint(_to, _amount);
226     Transfer(this, _to, _amount);
227     return true;
228   }
229 
230   function finishMinting() onlyCrowdsaleContract returns (bool) {
231     mintingFinished = true;
232     MintFinished();
233     return true;
234   }
235 
236 }
237 
238 contract ABHCoin is MintableToken {
239 
240   string public constant name = "ABH Coin";
241 
242   string public constant symbol = "ABH";
243 
244   uint32 public constant decimals = 18;
245 
246 }