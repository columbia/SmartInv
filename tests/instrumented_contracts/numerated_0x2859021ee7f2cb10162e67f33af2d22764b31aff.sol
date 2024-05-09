1 pragma solidity ^0.4.18;
2 
3  /// @title SafeMath contract - math operations with safety checks
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal pure  returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal pure returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal pure returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal pure returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
42     return a < b ? a : b;
43   }
44 }
45 
46  /// @title Ownable contract - base contract with an owner
47 contract Ownable {
48   address public owner;
49 
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     if (newOwner != address(0)) {
61       owner = newOwner;
62     }
63   }
64 }
65 
66  /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
67 contract Killable is Ownable {
68   function kill() public onlyOwner {
69     selfdestruct(owner);
70   }
71 }
72 
73  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
74 contract ERC20 {
75   uint public totalSupply;
76   function balanceOf(address who) public constant returns (uint);
77   function allowance(address owner, address spender) public constant returns (uint);  
78   function transfer(address to, uint value) public returns (bool ok);
79   function transferFrom(address from, address to, uint value) public returns (bool ok);
80   function approve(address spender, uint value) public returns (bool ok);
81   function decimals() public constant returns (uint value);
82   event Transfer(address indexed from, address indexed to, uint value);
83   event Approval(address indexed owner, address indexed spender, uint value);
84 }
85 
86  /// @title SilentNotaryToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
87 contract SilentNotaryToken is SafeMath, ERC20, Killable {
88   string constant public name = "Silent Notary Token";
89   string constant public symbol = "SNTR";
90  
91   /// Holder list
92   address[] public holders;
93   /// Balance data
94   struct Balance {
95     /// Tokens amount
96     uint value;
97     /// Object exist
98     bool exist;
99   }
100   /// Holder balances
101   mapping(address => Balance) public balances;
102   /// Contract that is allowed to create new tokens and allows unlift the transfer limits on this token
103   address public crowdsaleAgent;
104   /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
105   bool public released = false;
106   /// approve() allowances
107   mapping (address => mapping (address => uint)) allowed;
108 
109   /// @dev Limit token transfer until the crowdsale is over.
110   modifier canTransfer() {
111     if(!released)
112       require(msg.sender == crowdsaleAgent);
113     _;
114   }
115 
116   /// @dev The function can be called only before or after the tokens have been releasesd
117   /// @param _released token transfer and mint state
118   modifier inReleaseState(bool _released) {
119     require(_released == released);
120     _;
121   }
122 
123   /// @dev If holder does not exist add to array
124   /// @param holder Token holder
125   modifier addIfNotExist(address holder) {
126     if(!balances[holder].exist)
127       holders.push(holder);
128     _;
129   }
130 
131   /// @dev The function can be called only by release agent.
132   modifier onlyCrowdsaleAgent() {
133     require(msg.sender == crowdsaleAgent);
134     _;
135   }
136 
137   /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
138   /// @param size payload size
139   modifier onlyPayloadSize(uint size) {
140     require(msg.data.length >= size + 4);
141     _;
142   }
143 
144   /// @dev Make sure we are not done yet.
145   modifier canMint() {
146     require(!released);
147     _;
148   }
149 
150   /// @dev Constructor
151   function SilentNotaryToken() public {
152   }
153 
154   /// Fallback method
155   function() payable public {
156 	  revert();
157   }
158 
159   function decimals() public constant returns (uint value) {
160     return 4;
161   }
162   /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
163   /// @param receiver Address of receiver
164   /// @param amount  Number of tokens to issue.
165   function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint addIfNotExist(receiver) public {
166       totalSupply = safeAdd(totalSupply, amount);
167       balances[receiver].value = safeAdd(balances[receiver].value, amount);
168       balances[receiver].exist = true;
169       Transfer(0, receiver, amount);
170   }
171 
172   /// @dev Set the contract that can call release and make the token transferable.
173   /// @param _crowdsaleAgent crowdsale contract address
174   function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
175     crowdsaleAgent = _crowdsaleAgent;
176   }
177   /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
178   function releaseTokenTransfer() public onlyCrowdsaleAgent {
179     released = true;
180   }
181   /// @dev Tranfer tokens to address
182   /// @param _to dest address
183   /// @param _value tokens amount
184   /// @return transfer result
185   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) public returns (bool success) {
186     balances[msg.sender].value = safeSub(balances[msg.sender].value, _value);
187     balances[_to].value = safeAdd(balances[_to].value, _value);
188     balances[_to].exist = true;
189     Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /// @dev Tranfer tokens from one address to other
194   /// @param _from source address
195   /// @param _to dest address
196   /// @param _value tokens amount
197   /// @return transfer result
198   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) public returns (bool success) {
199     var _allowance = allowed[_from][msg.sender];
200 
201     balances[_to].value = safeAdd(balances[_to].value, _value);
202     balances[_from].value = safeSub(balances[_from].value, _value);
203     balances[_to].exist = true;
204 
205     allowed[_from][msg.sender] = safeSub(_allowance, _value);
206     Transfer(_from, _to, _value);
207     return true;
208   }
209   /// @dev Tokens balance
210   /// @param _owner holder address
211   /// @return balance amount
212   function balanceOf(address _owner) constant public returns (uint balance) {
213     return balances[_owner].value;
214   }
215 
216   /// @dev Approve transfer
217   /// @param _spender holder address
218   /// @param _value tokens amount
219   /// @return result
220   function approve(address _spender, uint _value) public returns (bool success) {
221     // To change the approve amount you first have to reduce the addresses`
222     //  allowance to zero by calling `approve(_spender, 0)` if it is not
223     //  already 0 to mitigate the race condition described here:
224     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225     require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
226 
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /// @dev Token allowance
233   /// @param _owner holder address
234   /// @param _spender spender address
235   /// @return remain amount
236   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
237     return allowed[_owner][_spender];
238   }
239 }