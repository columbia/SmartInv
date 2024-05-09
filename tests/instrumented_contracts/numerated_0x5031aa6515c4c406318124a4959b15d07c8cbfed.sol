1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant public returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 contract Pausable is Ownable {
43   event Pause();
44   event Unpause();
45 
46   bool public paused = false;
47 
48   /**
49    * @dev modifier to allow actions only when the contract IS paused
50    */
51   modifier whenNotPaused() {
52     require(!paused);
53     _;
54   }
55 
56   /**
57    * @dev modifier to allow actions only when the contract IS NOT paused
58    */
59   modifier whenPaused {
60     require(paused);
61     _;
62   }
63 
64   /**
65    * @dev called by the owner to pause, triggers stopped state
66    */
67   function pause() onlyOwner whenNotPaused public returns (bool) {
68     paused = true;
69     Pause();
70     return true;
71   }
72 
73   /**
74    * @dev called by the owner to unpause, returns to normal state
75    */
76   function unpause() onlyOwner whenPaused public returns (bool) {
77     paused = false;
78     Unpause();
79     return true;
80   }
81 }
82 
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant public returns (uint256);
85   function transferFrom(address from, address to, uint256 value) public returns (bool);
86   function approve(address spender, uint256 value) public returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a * b;
93     assert(a == 0 || c / a == b);
94     return c;
95   }
96 
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a / b;
99     return c;
100   }
101 
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of. 
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) constant public returns (uint256 balance) {
137     return balances[_owner];
138   }
139 
140 }
141 
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amout of tokens to be transfered
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     var _allowance = allowed[_from][msg.sender];
155     require (_value <= _allowance);
156     balances[_to] = balances[_to].add(_value);
157     balances[_from] = balances[_from].sub(_value);
158     allowed[_from][msg.sender] = _allowance.sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifing the amount of tokens still avaible for the spender.
186    */
187   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191 }
192 
193 contract MintableToken is StandardToken, Ownable {
194   uint256 public constant maxSupply = 120000000000000000000000000000;
195   event Mint(address indexed to, uint256 amount);
196   event MintFinished();
197 
198   bool public mintingFinished = false;
199 
200   modifier canMint() {
201     require(!mintingFinished);
202     _;
203   }
204 
205   /**
206    * @dev Function to mint tokens, it can not exceed the maxSupply value
207    * @param _to The address that will recieve the minted tokens.
208    * @param _amount The amount of tokens to mint.
209    * @return A boolean that indicates if the operation was successful.
210    */
211   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
212     totalSupply = totalSupply.add(_amount);
213     require(totalSupply <= maxSupply);
214     balances[_to] = balances[_to].add(_amount);
215     Mint(_to, _amount);
216     return true;
217   }
218 
219   /**
220    * @dev Function to stop minting new tokens.
221    * @return True if the operation was successful.
222    */
223   function finishMinting() onlyOwner public returns (bool) {
224     mintingFinished = true;
225     MintFinished();
226     return true;
227   }
228 }
229 
230 
231 contract PausableToken is StandardToken, Pausable {
232 
233   function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
234     return super.transfer(_to, _value);
235   }
236 
237   function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {
238     return super.transferFrom(_from, _to, _value);
239   }
240 }
241 
242 
243 contract FinalToken is PausableToken, MintableToken {
244 
245     string public constant symbol = "CARGO";
246 
247     string public constant name = "CARGO";
248 
249     uint8 public constant decimals = 18;
250 
251 	
252 	function FinalToken(address _to, uint256 _initialSupply) public{
253 	    mint(_to, _initialSupply);
254     }
255 }