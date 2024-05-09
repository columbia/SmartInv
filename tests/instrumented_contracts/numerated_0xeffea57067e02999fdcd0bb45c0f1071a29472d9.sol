1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // ZanteCoin smart contract
6 //
7 // ----------------------------------------------------------------------------
8 
9 // ----------------------------------------------------------------------------
10 //
11 // Owned contract
12 //
13 // ----------------------------------------------------------------------------
14 
15 contract Owned {
16 
17   address public owner;
18   address public newOwner;
19 
20   // Events ---------------------------
21 
22   event OwnershipTransferProposed(address indexed _from, address indexed _to);
23   event OwnershipTransferred(address indexed _from, address indexed _to);
24 
25   // Modifier -------------------------
26 
27   modifier onlyOwner {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   // Functions ------------------------
33 
34   function Owned() public {
35     owner = msg.sender;
36   }
37 
38   function transferOwnership(address _newOwner) public onlyOwner {
39     require(_newOwner != owner);
40     require(_newOwner != address(0x0));
41     OwnershipTransferProposed(owner, _newOwner);
42     newOwner = _newOwner;
43   }
44 
45   function acceptOwnership() public {
46     require(msg.sender == newOwner);
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60       return 0;
61     }
62     uint256 c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return c;
72   }
73 
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 // ----------------------------------------------------------------------------
87 //
88 // ERC Token Standard #20 Interface
89 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
90 //
91 // ----------------------------------------------------------------------------
92 
93 contract ERC20Interface {
94 
95   // Events ---------------------------
96 
97   event Transfer(address indexed _from, address indexed _to, uint _value);
98   event Approval(address indexed _owner, address indexed _spender, uint _value);
99 
100   // Functions ------------------------
101 
102   function totalSupply() public constant returns (uint);
103   function balanceOf(address _owner) public constant returns (uint balance);
104   function transfer(address _to, uint _value) public returns (bool success);
105   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
106   function approve(address _spender, uint _value) public returns (bool success);
107   function allowance(address _owner, address _spender) public constant returns (uint remaining);
108 
109 }
110 
111 // ----------------------------------------------------------------------------
112 //
113 // ERC Coin Standard #20
114 //
115 // ----------------------------------------------------------------------------
116 
117 contract ERC20Coin is ERC20Interface, Owned {
118   
119   using SafeMath for uint;
120 
121   uint public coinsIssuedTotal = 0;
122   mapping(address => uint) public balances;
123   mapping(address => mapping (address => uint)) public allowed;
124 
125   // Functions ------------------------
126 
127   /* Total coin supply */
128 
129   function totalSupply() public constant returns (uint) {
130     return coinsIssuedTotal;
131   }
132 
133   /* Get the account balance for an address */
134 
135   function balanceOf(address _owner) public constant returns (uint balance) {
136     return balances[_owner];
137   }
138 
139   /* Transfer the balance from owner's account to another account */
140 
141   function transfer(address _to, uint _amount) public returns (bool success) {
142     // amount sent cannot exceed balance
143     require(balances[msg.sender] >= _amount);
144 
145     // update balances
146     balances[msg.sender] = balances[msg.sender].sub(_amount);
147     balances[_to] = balances[_to].add(_amount);
148 
149     // log event
150     Transfer(msg.sender, _to, _amount);
151     return true;
152   }
153 
154   /* Allow _spender to withdraw from your account up to _amount */
155 
156   function approve(address _spender, uint _amount) public returns (bool success) {
157     // approval amount cannot exceed the balance
158     require (balances[msg.sender] >= _amount);
159       
160     // update allowed amount
161     allowed[msg.sender][_spender] = _amount;
162     
163     // log event
164     Approval(msg.sender, _spender, _amount);
165     return true;
166   }
167 
168   /* Spender of coins transfers coins from the owner's balance */
169   /* Must be pre-approved by owner */
170 
171   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
172     // balance checks
173     require(balances[_from] >= _amount);
174     require(allowed[_from][msg.sender] >= _amount);
175 
176     // update balances and allowed amount
177     balances[_from] = balances[_from].sub(_amount);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
179     balances[_to] = balances[_to].add(_amount);
180 
181     // log event
182     Transfer(_from, _to, _amount);
183     return true;
184   }
185 
186   /* Returns the amount of coins approved by the owner */
187   /* that can be transferred by spender */
188 
189   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
190     return allowed[_owner][_spender];
191   }
192 
193 }
194 
195 contract ZanteCoin is ERC20Coin {
196 
197     /* Basic coin data */
198 
199     string public constant name = "Zpay";
200     string public constant symbol = "ZPAY";
201     uint8  public constant decimals = 18;
202 
203     /* ICO dates */
204 
205     uint public constant DATE_ICO_START = 1521072000; // 15-Mar-2018 00:00 UTC
206     uint public constant DATE_ICO_END   = 1531612800; // 15-Jul-2018 00:00 UTC
207 
208     /* Max ICO and other coin supply parameters */  
209 
210     uint public constant COIN_SUPPLY_ICO_PHASE_0 = 30000000 * 10**18;  //  30M coins Pre-ICO
211     uint public constant COIN_SUPPLY_ICO_PHASE_1 = 70000000 * 10**18;  //  70M coins
212     uint public constant COIN_SUPPLY_ICO_PHASE_2 = 200000000 * 10**18; // 200M coins
213     uint public constant COIN_SUPPLY_ICO_PHASE_3 = 300000000 * 10**18; // 300M coins
214     uint public constant COIN_SUPPLY_ICO_TOTAL   = 
215         COIN_SUPPLY_ICO_PHASE_0
216         + COIN_SUPPLY_ICO_PHASE_1
217         + COIN_SUPPLY_ICO_PHASE_2
218         + COIN_SUPPLY_ICO_PHASE_3;
219 
220     uint public constant COIN_SUPPLY_MKT_TOTAL = 600000000 * 10**18;
221 
222     uint public constant COIN_SUPPLY_COMPANY_TOTAL = 800000000 * 10**18;
223 
224     uint public constant COIN_SUPPLY_TOTAL = 
225         COIN_SUPPLY_ICO_TOTAL
226         + COIN_SUPPLY_MKT_TOTAL
227         + COIN_SUPPLY_COMPANY_TOTAL;
228 
229     /* Other ICO parameters */  
230 
231     uint public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 ether
232     uint public constant MAX_CONTRIBUTION = 15610 ether;
233 
234     /* Current coin supply variables */
235 
236     uint public coinsIssuedIco = 0;
237     uint public coinsIssuedMkt = 0;
238     uint public coinsIssuedCmp = 0;  
239 
240     // Events ---------------------------
241 
242     event IcoCoinsIssued(address indexed _owner, uint _coins);
243     event MarketingCoinsGranted(address indexed _participant, uint _coins, uint _balance);
244     event CompanyCoinsGranted(address indexed _participant, uint _coins, uint _balance);
245 
246     // Basic Functions ------------------
247 
248     /* Initialize (owner is set to msg.sender by Owned.Owned() */
249 
250     function ZanteCoin() public {  }
251 
252     /* Fallback */
253 
254     function () public {
255         // Not a payable to prevent ether transfers to this contract.
256     }
257 
258     function issueIcoCoins(address _participant, uint _coins) public onlyOwner {
259         // Check if enough supply remaining
260         require(_coins <= COIN_SUPPLY_ICO_TOTAL.sub(coinsIssuedIco));
261 
262         // update balances
263         balances[_participant] = balances[_participant].add(_coins);
264         coinsIssuedIco = coinsIssuedIco.add(_coins);
265         coinsIssuedTotal = coinsIssuedTotal.add(_coins);
266 
267         // log the minting
268         Transfer(0x0, _participant, _coins);
269         IcoCoinsIssued(_participant, _coins);
270     }
271 
272     /* Granting / minting of marketing coins by owner */
273     function grantMarketingCoins(address _participant, uint _coins) public onlyOwner {
274         // check amount
275         require(_coins <= COIN_SUPPLY_MKT_TOTAL.sub(coinsIssuedMkt));
276 
277         // update balances
278         balances[_participant] = balances[_participant].add(_coins);
279         coinsIssuedMkt = coinsIssuedMkt.add(_coins);
280         coinsIssuedTotal = coinsIssuedTotal.add(_coins);
281 
282         // log the minting
283         Transfer(0x0, _participant, _coins);
284         MarketingCoinsGranted(_participant, _coins, balances[_participant]);
285     }
286 
287     /* Granting / minting of Company bonus coins by owner */
288     function grantCompanyCoins(address _participant, uint _coins) public onlyOwner {
289         // check amount
290         require(_coins <= COIN_SUPPLY_COMPANY_TOTAL.sub(coinsIssuedCmp));
291 
292         // update balances
293         balances[_participant] = balances[_participant].add(_coins);
294         coinsIssuedCmp = coinsIssuedCmp.add(_coins);
295         coinsIssuedTotal = coinsIssuedTotal.add(_coins);
296 
297         // log the minting
298         Transfer(0x0, _participant, _coins);
299         CompanyCoinsGranted(_participant, _coins, balances[_participant]);
300     }
301 }