1 pragma solidity ^0.4.18;
2 
3  /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) public onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23  /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
24 contract Killable is Ownable {
25   function kill() public onlyOwner {
26     selfdestruct(owner);
27   }
28 }
29 
30 
31  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
32 contract ERC20 {
33   uint public totalSupply;
34   function balanceOf(address who) public constant returns (uint);
35   function allowance(address owner, address spender) public constant returns (uint);  
36   function transfer(address to, uint value) public returns (bool ok);
37   function transferFrom(address from, address to, uint value) public returns (bool ok);
38   function approve(address spender, uint value) public returns (bool ok);
39   function decimals() public constant returns (uint value);
40   event Transfer(address indexed from, address indexed to, uint value);
41   event Approval(address indexed owner, address indexed spender, uint value);
42 }
43 
44  /// @title SafeMath contract - math operations with safety checks
45 contract SafeMath {
46   function safeMul(uint a, uint b) internal pure  returns (uint) {
47     uint c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function safeDiv(uint a, uint b) internal pure returns (uint) {
53     assert(b > 0);
54     uint c = a / b;
55     assert(a == b * c + a % b);
56     return c;
57   }
58 
59   function safeSub(uint a, uint b) internal pure returns (uint) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function safeAdd(uint a, uint b) internal pure returns (uint) {
65     uint c = a + b;
66     assert(c>=a && c>=b);
67     return c;
68   }
69 
70   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
71     return a >= b ? a : b;
72   }
73 
74   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
75     return a < b ? a : b;
76   }
77 
78   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
79     return a >= b ? a : b;
80   }
81 
82   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
83     return a < b ? a : b;
84   }
85 }
86 
87 
88  /// @title TokenAdrToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
89 contract TokenAdrToken is SafeMath, ERC20, Killable {
90   string constant public name = "TokenAdr Token";
91   string constant public symbol = "TADR";
92  
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
152   /// @dev Constructor
153   function TokenAdrToken() public {
154   }
155 
156   /// Fallback method
157   function() payable public {
158 	  revert();
159   }
160 
161   function decimals() public constant returns (uint value) {
162     return 12;
163   }
164   /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
165   /// @param receiver Address of receiver
166   /// @param amount  Number of tokens to issue.
167   function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint addIfNotExist(receiver) public {
168       totalSupply = safeAdd(totalSupply, amount);
169       balances[receiver].value = safeAdd(balances[receiver].value, amount);
170       balances[receiver].exist = true;
171       Transfer(0, receiver, amount);
172   }
173 
174   /// @dev Set the contract that can call release and make the token transferable.
175   /// @param _crowdsaleAgent crowdsale contract address
176   function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
177     crowdsaleAgent = _crowdsaleAgent;
178   }
179   /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
180   function releaseTokenTransfer() public onlyCrowdsaleAgent {
181     released = true;
182   }
183   /// @dev Tranfer tokens to address
184   /// @param _to dest address
185   /// @param _value tokens amount
186   /// @return transfer result
187   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) public returns (bool success) {
188     balances[msg.sender].value = safeSub(balances[msg.sender].value, _value);
189     balances[_to].value = safeAdd(balances[_to].value, _value);
190     balances[_to].exist = true;
191     Transfer(msg.sender, _to, _value);
192     return true;
193   }
194 
195   /// @dev Tranfer tokens from one address to other
196   /// @param _from source address
197   /// @param _to dest address
198   /// @param _value tokens amount
199   /// @return transfer result
200   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) public returns (bool success) {
201     var _allowance = allowed[_from][msg.sender];
202 
203     balances[_to].value = safeAdd(balances[_to].value, _value);
204     balances[_from].value = safeSub(balances[_from].value, _value);
205     balances[_to].exist = true;
206 
207     allowed[_from][msg.sender] = safeSub(_allowance, _value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211   /// @dev Tokens balance
212   /// @param _owner holder address
213   /// @return balance amount
214   function balanceOf(address _owner) constant public returns (uint balance) {
215     return balances[_owner].value;
216   }
217 
218   /// @dev Approve transfer
219   /// @param _spender holder address
220   /// @param _value tokens amount
221   /// @return result
222   function approve(address _spender, uint _value) public returns (bool success) {
223     // To change the approve amount you first have to reduce the addresses`
224     //  allowance to zero by calling `approve(_spender, 0)` if it is not
225     //  already 0 to mitigate the race condition described here:
226     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227     require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
228 
229     allowed[msg.sender][_spender] = _value;
230     Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /// @dev Token allowance
235   /// @param _owner holder address
236   /// @param _spender spender address
237   /// @return remain amount
238   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
239     return allowed[_owner][_spender];
240   }
241 }