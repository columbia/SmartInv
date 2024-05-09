1 pragma solidity ^0.4.17;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) constant returns (uint256);
13   function transfer(address to, uint256 value) returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 
56 }
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62 
63   using SafeMath for uint256;
64 
65   modifier onlyPayloadSize(uint size) {
66     assert(msg.data.length == size + 4);
67     _;
68   }
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifing the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152 }
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160 
161   address public owner;
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner {
184     require(newOwner != address(0));
185     owner = newOwner;
186   }
187 
188 }
189 
190 /**
191  * @title Mintable token
192  * @dev Simple ERC20 Token example, with mintable token creation
193  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
194  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
195  */
196 
197 contract MintableToken is StandardToken, Ownable {
198 
199   event Mint(address indexed to, uint256 amount);
200   event MintFinished();
201 
202   bool public mintingFinished = false;
203   mapping (address => bool) public crowdsaleContracts;
204 
205   modifier canMint() {
206     require(!mintingFinished);
207     _;
208   }
209 
210   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
211 
212     totalSupply = totalSupply.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     Mint(_to, _amount);
215     Transfer(this, _to, _amount);
216     return true;
217   }
218 
219   function finishMinting() onlyOwner returns (bool) {
220     mintingFinished = true;
221     MintFinished();
222     return true;
223   }
224 
225 }
226 
227 contract BSEToken is MintableToken {
228 
229   string public constant name = " BLACK SNAIL ENERGY ";
230 
231   string public constant symbol = "BSE";
232 
233   uint32 public constant decimals = 18;
234 
235   event Burn(address indexed burner, uint256 value);
236 
237   /**
238    * @dev Burns a specific amount of tokens.
239    * @param _value The amount of token to be burned.
240    */
241   function burn(uint256 _value) public {
242     require(_value > 0);
243     require(_value <= balances[msg.sender]);
244     // no need to require value <= totalSupply, since that would imply the
245     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
246 
247     address burner = msg.sender;
248     balances[burner] = balances[burner].sub(_value);
249     totalSupply = totalSupply.sub(_value);
250     Burn(burner, _value);
251   }
252 
253 }