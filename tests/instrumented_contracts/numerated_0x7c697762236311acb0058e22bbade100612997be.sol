1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // SNTC SaintCoin token public sale contract
6 //
7 // For details, please visit: https://saintcoin.io
8 //
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 //
14 // SafeMath3
15 //
16 // Adapted from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
17 // (no need to implement division)
18 //
19 // ----------------------------------------------------------------------------
20 
21 library SafeMath3 {
22 
23   function mul(uint a, uint b) internal pure returns (uint c) {
24     c = a * b;
25     assert(a == 0 || c / a == b);
26   }
27 
28   function sub(uint a, uint b) internal pure returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal pure returns (uint c) {
34     c = a + b;
35     assert(c >= a);
36   }
37 
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 //
43 // Owned contract
44 //
45 // ----------------------------------------------------------------------------
46 
47 contract Owned {
48 
49   address public owner;
50   address public newOwner;
51 
52   // Events ---------------------------
53 
54   event OwnershipTransferProposed(address indexed _from, address indexed _to);
55   event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57   // Modifier -------------------------
58 
59   modifier onlyOwner {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   // Functions ------------------------
65 
66   function Owned() public {
67     owner = msg.sender;
68   }
69 
70   function transferOwnership(address _newOwner) onlyOwner public {
71     require(_newOwner != owner);
72     require(_newOwner != address(0x0));
73     OwnershipTransferProposed(owner, _newOwner);
74     newOwner = _newOwner;
75   }
76 
77   function acceptOwnership() public {
78     require(msg.sender == newOwner);
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81     newOwner = address(0x0);
82   }
83 
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 //
89 // ERC Token Standard #20 Interface
90 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
91 //
92 // ----------------------------------------------------------------------------
93 
94 contract ERC20Interface {
95 
96   // Events ---------------------------
97 
98   event Transfer(address indexed _from, address indexed _to, uint _value);
99   event Approval(address indexed _owner, address indexed _spender, uint _value);
100 
101   // Functions ------------------------
102 
103   function totalSupply() constant public returns (uint);
104   function balanceOf(address _owner) constant public returns (uint balance);
105   function transfer(address _to, uint _value) public returns (bool success);
106   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
107   function approve(address _spender, uint _value) public returns (bool success);
108   function allowance(address _owner, address _spender) constant public returns (uint remaining);
109 
110 }
111 
112 
113 // ----------------------------------------------------------------------------
114 //
115 // ERC Token Standard #20
116 //
117 // ----------------------------------------------------------------------------
118 
119 contract ERC20Token is ERC20Interface, Owned {
120   
121   using SafeMath3 for uint;
122 
123   uint public tokensIssuedTotal = 0;
124 
125   mapping(address => uint) balances;
126   mapping(address => mapping (address => uint)) internal allowed;
127 
128   // Functions ------------------------
129 
130   /* Total token supply */
131 
132   function totalSupply() constant public returns (uint) {
133     return tokensIssuedTotal;
134   }
135 
136   /* Get the account balance for an address */
137 
138   function balanceOf(address _owner) constant public returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142   /* Transfer the balance from owner's account to another account */
143 
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // update balances
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151 
152     // log event
153     Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /* Allow _spender to withdraw from your account up to _value */
158 
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     // approval amount cannot exceed the balance
161     require(balances[msg.sender] >= _value);
162       
163     // update allowed amount
164     allowed[msg.sender][_spender] = _value;
165     
166     // log event
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /* Spender of tokens transfers tokens from the owner's balance */
172   /* Must be pre-approved by owner */
173 
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     // update balances and allowed amount
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183 
184     // log event
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /* Returns the amount of tokens approved by the owner */
190   /* that can be transferred by spender */
191 
192   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    */
202   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204 
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211 
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217 
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 }
222 
223 contract SaintCoinToken is ERC20Token {
224     /* Utility variable */
225   
226     uint constant E6 = 10**6;
227   
228     /* Basic token data */
229   
230     string public constant name = "Saint Coins";
231     string public constant symbol = "SAINT";
232     uint8 public constant decimals = 0;
233     
234     /* Saint coinds per ETH */
235   
236     uint public tokensPerEth = 1000;
237 
238     /* Fundation contract addresses */
239     
240     mapping(address => bool) public grantedContracts;
241 
242     /* HelpCoin address */
243 
244     address public helpCoinAddress;
245 
246     event GrantedOrganization(bool isGranted);
247 
248     function SaintCoinToken(address _helpCoinAddress) public { 
249       helpCoinAddress = _helpCoinAddress;          
250     }
251     
252     function setHelpCoinAddress(address newHelpCoinWalletAddress) public onlyOwner {
253         helpCoinAddress = newHelpCoinWalletAddress;
254     }
255 
256     function sendTo(address _to, uint256 _value) public {
257         require(isAuthorized(msg.sender));
258         require(balances[_to] + _value >= balances[_to]);
259         
260         uint tokens = tokensPerEth.mul(_value) / 1 ether;
261         
262         balances[_to] += tokens;
263         tokensIssuedTotal += tokens;
264 
265         Transfer(msg.sender, _to, tokens);
266     }
267 
268     function grantAccess(address _address) public onlyOwner {
269         grantedContracts[_address] = true;
270         GrantedOrganization(grantedContracts[_address]);
271     }
272     
273     function revokeAccess(address _address) public onlyOwner {
274         grantedContracts[_address] = false;
275         GrantedOrganization(grantedContracts[_address]);
276     }
277 
278     function isAuthorized(address _address) public constant returns (bool) {
279         return grantedContracts[_address];
280     }
281 }