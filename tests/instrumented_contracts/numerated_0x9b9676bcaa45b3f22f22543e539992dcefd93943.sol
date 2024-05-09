1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract Destructible is Ownable {
64 
65   function Destructible() payable { } 
66 
67   /**
68    * @dev Transfers the current balance to the owner and terminates the contract. 
69    */
70   function destroy() onlyOwner {
71     selfdestruct(owner);
72   }
73 
74   function destroyAndSend(address _recipient) onlyOwner {
75     selfdestruct(_recipient);
76   }
77 }
78 
79 contract HasNoEther is Ownable {
80 
81   /**
82   * @dev Constructor that rejects incoming Ether
83   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
84   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
85   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
86   * we could use assembly to access msg.value.
87   */
88   function HasNoEther() payable {
89     require(msg.value == 0);
90   }
91 
92   /**
93    * @dev Disallows direct send by settings a default function without the `payable` flag.
94    */
95   function() external {
96   }
97 
98   /**
99    * @dev Transfer all Ether held by the contract to the owner.
100    */
101   function reclaimEther() external onlyOwner {
102     assert(owner.send(this.balance));
103   }
104 }
105 
106 contract HasNoTokens is Ownable {
107 
108  /**
109   * @dev Reject all ERC23 compatible tokens
110   * @param from_ address The address that is transferring the tokens
111   * @param value_ uint256 the amount of the specified token
112   * @param data_ Bytes The data passed from the caller.
113   */
114   function tokenFallback(address from_, uint256 value_, bytes data_) external {
115     revert();
116   }
117 
118   /**
119    * @dev Reclaim all ERC20Basic compatible tokens
120    * @param tokenAddr address The address of the token contract
121    */
122   function reclaimToken(address tokenAddr) external onlyOwner {
123     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
124     uint256 balance = tokenInst.balanceOf(this);
125     tokenInst.transfer(owner, balance);
126   }
127 }
128 
129 contract ERC20Basic {
130   uint256 public totalSupply;
131   function balanceOf(address who) constant returns (uint256);
132   function transfer(address to, uint256 value) returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) returns (bool) {
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of. 
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) constant returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender) constant returns (uint256);
166   function transferFrom(address from, address to, uint256 value) returns (bool);
167   function approve(address spender, uint256 value) returns (bool);
168   event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amout of tokens to be transfered
181    */
182   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
183     var _allowance = allowed[_from][msg.sender];
184 
185     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
186     // require (_value <= _allowance);
187 
188     balances[_to] = balances[_to].add(_value);
189     balances[_from] = balances[_from].sub(_value);
190     allowed[_from][msg.sender] = _allowance.sub(_value);
191     Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) returns (bool) {
201 
202     // To change the approve amount you first have to reduce the addresses`
203     //  allowance to zero by calling `approve(_spender, 0)` if it is not
204     //  already 0 to mitigate the race condition described here:
205     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
207 
208     allowed[msg.sender][_spender] = _value;
209     Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifing the amount of tokens still avaible for the spender.
218    */
219   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
220     return allowed[_owner][_spender];
221   }
222 
223 }
224 
225 contract WIZE is StandardToken, Ownable, Destructible, HasNoEther, HasNoTokens  {
226 
227 	string public name = "WIZE";
228 	string public symbol = "WIZE";
229 	uint256 public decimals = 6;
230 
231 	function WIZE() {
232 		balances[0x2D665c024bDeC12187cC96A7AcE22efFD3C40603] = 2000000E6;
233 		balances[0xDa8BE6E2F555a753d4B0DfF6B5518F262D097Bc7] = 98000000E6;
234 	}
235 
236 }