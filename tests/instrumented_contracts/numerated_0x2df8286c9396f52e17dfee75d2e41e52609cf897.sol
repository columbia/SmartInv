1 pragma solidity ^0.4.14;
2 
3 /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5  address public owner;
6 
7  function Ownable() {
8    owner = msg.sender;
9  }
10 
11  modifier onlyOwner() {
12    require(msg.sender == owner);
13    _;
14  }
15 
16  function transferOwnership(address newOwner) onlyOwner {
17    if (newOwner != address(0)) {
18      owner = newOwner;
19    }
20  }
21 }
22 
23 /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
24 contract Killable is Ownable {
25  function kill() onlyOwner {
26    selfdestruct(owner);
27  }
28 }
29 
30  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
31 contract ERC20 {
32   uint public totalSupply;
33   function balanceOf(address who) constant returns (uint);
34   function allowance(address owner, address spender) constant returns (uint);
35   function mint(address receiver, uint amount);
36   function transfer(address to, uint value) returns (bool ok);
37   function transferFrom(address from, address to, uint value) returns (bool ok);
38   function approve(address spender, uint value) returns (bool ok);
39   event Transfer(address indexed from, address indexed to, uint value);
40   event Approval(address indexed owner, address indexed spender, uint value);
41 }
42 
43  /// @title SafeMath contract - math operations with safety checks
44 contract SafeMath {
45   function safeMul(uint a, uint b) internal returns (uint) {
46     uint c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function safeDiv(uint a, uint b) internal returns (uint) {
52     assert(b > 0);
53     uint c = a / b;
54     assert(a == b * c + a % b);
55     return c;
56   }
57 
58   function safeSub(uint a, uint b) internal returns (uint) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function safeAdd(uint a, uint b) internal returns (uint) {
64     uint c = a + b;
65     assert(c>=a && c>=b);
66     return c;
67   }
68 
69   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
70     return a >= b ? a : b;
71   }
72 
73   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
74     return a < b ? a : b;
75   }
76 
77   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
78     return a >= b ? a : b;
79   }
80 
81   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
82     return a < b ? a : b;
83   }
84 }
85 
86  /// @title SilentNotaryToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
87 contract SilentNotaryToken is SafeMath, ERC20, Killable {
88   string constant public name = "Silent Notary Token";
89   string constant public symbol = "SNTR";
90   uint constant public decimals = 4;
91   /// Buyout price
92   uint constant public BUYOUT_PRICE = 20e10;
93   /// Holder list
94   address[] public holders;
95   /// Balance data
96   struct Balance {
97     /// Tokens amount
98     uint value;
99     /// Object exist
100     bool exist;
101   }
102   /// Holder balances
103   mapping(address => Balance) public balances;
104   /// Contract that is allowed to create new tokens and allows unlift the transfer limits on this token
105   address public crowdsaleAgent;
106   /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
107   bool public released = false;
108   /// approve() allowances
109   mapping (address => mapping (address => uint)) allowed;
110 
111   /// @dev Limit token transfer until the crowdsale is over.
112   modifier canTransfer() {
113     if(!released)
114       require(msg.sender == crowdsaleAgent);
115     _;
116   }
117 
118   /// @dev The function can be called only before or after the tokens have been releasesd
119   /// @param _released token transfer and mint state
120   modifier inReleaseState(bool _released) {
121     require(_released == released);
122     _;
123   }
124 
125   /// @dev If holder does not exist add to array
126   /// @param holder Token holder
127   modifier addIfNotExist(address holder) {
128     if(!balances[holder].exist)
129       holders.push(holder);
130     _;
131   }
132 
133   /// @dev The function can be called only by release agent.
134   modifier onlyCrowdsaleAgent() {
135     require(msg.sender == crowdsaleAgent);
136     _;
137   }
138 
139   /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
140   /// @param size payload size
141   modifier onlyPayloadSize(uint size) {
142     require(msg.data.length >= size + 4);
143     _;
144   }
145 
146   /// @dev Make sure we are not done yet.
147   modifier canMint() {
148     require(!released);
149     _;
150   }
151 
152   /// Tokens burn event
153   event Burned(address indexed burner, address indexed holder, uint burnedAmount);
154   /// Tokens buyout event
155   event Pay(address indexed to, uint value);
156   /// Wei deposit event
157   event Deposit(address indexed from, uint value);
158 
159   /// @dev Constructor
160   function SilentNotaryToken() {
161   }
162 
163   /// Fallback method
164   function() payable {
165     require(msg.value > 0);
166     Deposit(msg.sender, msg.value);
167   }
168   /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
169   /// @param receiver Address of receiver
170   /// @param amount  Number of tokens to issue.
171   function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint addIfNotExist(receiver) public {
172       totalSupply = safeAdd(totalSupply, amount);
173       balances[receiver].value = safeAdd(balances[receiver].value, amount);
174       balances[receiver].exist = true;
175       Transfer(0, receiver, amount);
176   }
177 
178   /// @dev Set the contract that can call release and make the token transferable.
179   /// @param _crowdsaleAgent crowdsale contract address
180   function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
181     crowdsaleAgent = _crowdsaleAgent;
182   }
183   /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
184   function releaseTokenTransfer() public onlyCrowdsaleAgent {
185     released = true;
186   }
187   /// @dev Tranfer tokens to address
188   /// @param _to dest address
189   /// @param _value tokens amount
190   /// @return transfer result
191   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) returns (bool success) {
192     balances[msg.sender].value = safeSub(balances[msg.sender].value, _value);
193     balances[_to].value = safeAdd(balances[_to].value, _value);
194     balances[_to].exist = true;
195     Transfer(msg.sender, _to, _value);
196     return true;
197   }
198 
199   /// @dev Tranfer tokens from one address to other
200   /// @param _from source address
201   /// @param _to dest address
202   /// @param _value tokens amount
203   /// @return transfer result
204   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) returns (bool success) {
205     var _allowance = allowed[_from][msg.sender];
206 
207     balances[_to].value = safeAdd(balances[_to].value, _value);
208     balances[_from].value = safeSub(balances[_from].value, _value);
209     balances[_to].exist = true;
210 
211     allowed[_from][msg.sender] = safeSub(_allowance, _value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215   /// @dev Tokens balance
216   /// @param _owner holder address
217   /// @return balance amount
218   function balanceOf(address _owner) constant returns (uint balance) {
219     return balances[_owner].value;
220   }
221 
222   /// @dev Approve transfer
223   /// @param _spender holder address
224   /// @param _value tokens amount
225   /// @return result
226   function approve(address _spender, uint _value) returns (bool success) {
227     // To change the approve amount you first have to reduce the addresses`
228     //  allowance to zero by calling `approve(_spender, 0)` if it is not
229     //  already 0 to mitigate the race condition described here:
230     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231     require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
232 
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /// @dev Token allowance
239   /// @param _owner holder address
240   /// @param _spender spender address
241   /// @return remain amount
242   function allowance(address _owner, address _spender) constant returns (uint remaining) {
243     return allowed[_owner][_spender];
244   }
245 
246   /// @dev buyout method
247   /// @param _holder holder address
248   /// @param _amount wei for buyout tokens
249   function buyout(address _holder, uint _amount) onlyOwner addIfNotExist(msg.sender) external  {
250     require(_holder != msg.sender);
251     require(this.balance >= _amount);
252     require(BUYOUT_PRICE <= _amount);
253 
254     uint multiplier = 10 ** decimals;
255     uint buyoutTokens = safeDiv(safeMul(_amount, multiplier), BUYOUT_PRICE);
256 
257     balances[msg.sender].value = safeAdd(balances[msg.sender].value, buyoutTokens);
258     balances[_holder].value = safeSub(balances[_holder].value, buyoutTokens);
259     balances[msg.sender].exist = true;
260 
261     Transfer(_holder, msg.sender, buyoutTokens);
262 
263     _holder.transfer(_amount);
264     Pay(_holder, _amount);
265   }
266 }