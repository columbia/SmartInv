1 pragma solidity ^0.4.11;
2 library SafeMath {
3   function mul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14   function sub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c >= a);
21     return c;
22   }
23   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
24     return a >= b ? a : b;
25   }
26   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a < b ? a : b;
28   }
29   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
30     return a >= b ? a : b;
31   }
32   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a < b ? a : b;
34   }
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract Ownable {
42     address public owner;
43     function Ownable() {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         if (msg.sender != owner) throw;
48         _;
49     }
50     function transferOwnership(address newOwner) onlyOwner {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 /*
57  *  an emergency  mechanism.
58  */
59 contract Pausable is Ownable {
60   bool public stopped;
61   modifier stopInEmergency {
62     if (stopped) {
63       throw;
64     }
65     _;
66   }
67   
68   modifier onlyInEmergency {
69     if (!stopped) {
70       throw;
71     }
72     _;
73   }
74   // called by the owner on emergency, triggers stopped state
75   function emergencyStop() external onlyOwner {
76     stopped = true;
77   }
78   // called by the owner on end of emergency, returns to normal state
79   function release() external onlyOwner onlyInEmergency {
80     stopped = false;
81   }
82 }
83 contract ERC20Basic {
84   uint public totalSupply;
85   function balanceOf(address who) constant returns (uint);
86   function transfer(address to, uint value);
87   event Transfer(address indexed from, address indexed to, uint value);
88 }
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) constant returns (uint);
91   function transferFrom(address from, address to, uint value);
92   function approve(address spender, uint value);
93   event Approval(address indexed owner, address indexed spender, uint value);
94 }
95 
96 contract BasicToken is ERC20Basic {
97   
98   using SafeMath for uint;
99   
100   mapping(address => uint) balances;
101   
102   /*
103    * Fix for the ERC20 short address attack  
104   */
105   modifier onlyPayloadSize(uint size) {
106      if(msg.data.length < size + 4) {
107        throw;
108      }
109      _;
110   }
111   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115   }
116   function balanceOf(address _owner) constant returns (uint balance) {
117     return balances[_owner];
118   }
119 }
120 contract StandardToken is BasicToken, ERC20 {
121   mapping (address => mapping (address => uint)) allowed;
122   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
123     var _allowance = allowed[_from][msg.sender];
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // if (_value > _allowance) throw;
126     balances[_to] = balances[_to].add(_value);
127     balances[_from] = balances[_from].sub(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130   }
131   function approve(address _spender, uint _value) {
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139   }
140   function allowance(address _owner, address _spender) constant returns (uint remaining) {
141     return allowed[_owner][_spender];
142   }
143 }
144 /**
145  *  VenusCoin token contract. Implements
146  */
147 contract VenusCoin is StandardToken, Ownable {
148   string public constant name = "VenusCoin";
149   string public constant symbol = "Venus";
150   uint public constant decimals = 0;
151   // Constructor
152   function VenusCoin() {
153       totalSupply = 50000000000;
154       balances[msg.sender] = totalSupply; // Send all tokens to owner
155   }
156   /**
157    *  Burn away the specified amount of VenusCoin tokens
158    */
159   function burn(uint _value) onlyOwner returns (bool) {
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     totalSupply = totalSupply.sub(_value);
162     Transfer(msg.sender, 0x0, _value);
163     return true;
164   }
165 }
166 /*
167   Tokensale Smart Contract for the VenusCoin project
168   This smart contract collects ETH
169 */
170 contract Tokensale is Pausable {
171     
172     using SafeMath for uint;
173     struct Beneficiar {
174         uint weiReceived; // Amount of Ether
175         uint coinSent;
176     }
177     
178     /* Minimum amount to accept */
179     uint public constant MIN_ACCEPT_ETHER = 50000000000000 wei; // min sale price is 1/20000 ETH = 5*10**13 wei = 0.00005 ETH
180     /* Number of VenusCoins per Ether */
181     uint public constant COIN_PER_ETHER = 20000; // 20,000 VenusCoins
182     /*
183     * Variables
184     */
185     /* VenusCoin contract reference */
186     VenusCoin public coin;
187     /* Multisig contract that will receive the Ether */
188     address public multisigEther;
189     /* Number of Ether received */
190     uint public etherReceived;
191     /* Number of VenusCoins sent to Ether contributors */
192     uint public coinSentToEther;
193     /* Tokensale start time */
194     uint public startTime;
195     /*  Beneficiar's Ether indexed by Ethereum address */
196     mapping(address => Beneficiar) public beneficiars;
197   
198     /*
199      * Event
200     */
201     event LogReceivedETH(address addr, uint value);
202     event LogCoinsEmited(address indexed from, uint amount);
203     /*
204      * Constructor
205     */
206     function Tokensale(address _venusCoinAddress, address _to) {
207         coin = VenusCoin(_venusCoinAddress);
208         multisigEther = _to;
209     }
210     /* 
211      * The fallback function corresponds to a donation in ETH
212      */
213     function() stopInEmergency payable {
214         receiveETH(msg.sender);
215     }
216     /* 
217      * To call to start the Token's sale
218      */
219     function start() onlyOwner {
220         if (startTime != 0) throw; // Token's sale was already started
221         startTime = now ;              
222     }
223     
224     function receiveETH(address beneficiary) internal {
225         if (msg.value < MIN_ACCEPT_ETHER) throw; // Don't accept funding under a predefined threshold
226         
227         uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of VenusCoin to send 
228         Beneficiar beneficiar = beneficiars[beneficiary];
229         coin.transfer(beneficiary, coinToSend); // Transfer VenusCoins right now 
230         beneficiar.coinSent = beneficiar.coinSent.add(coinToSend);
231         beneficiar.weiReceived = beneficiar.weiReceived.add(msg.value); // Update the total wei collected     
232         etherReceived = etherReceived.add(msg.value); // Update the total wei collected 
233         coinSentToEther = coinSentToEther.add(coinToSend);
234         // Send events
235         LogCoinsEmited(msg.sender ,coinToSend);
236         LogReceivedETH(beneficiary, etherReceived); 
237     }
238     
239     /*
240      *Compute the VenusCoin bonus according to the bonus period
241      */
242     function bonus(uint amount) internal constant returns (uint) {
243         if (now < startTime.add(2 days)) return amount.add(amount.div(10));   // bonus 10%
244         return amount;
245     }
246     
247     /*  
248     * Failsafe drain
249     */
250     function drain() onlyOwner {
251         if (!owner.send(this.balance)) throw;
252     }
253     /**
254      * Allow to change the team multisig address in the case of emergency.
255      */
256     function setMultisig(address addr) onlyOwner public {
257         if (addr == address(0)) throw;
258         multisigEther = addr;
259     }
260     /**
261      * Manually back VenusCoin owner address.
262      */
263     function backVenusCoinOwner() onlyOwner public {
264         coin.transferOwnership(owner);
265     }
266   
267     
268     
269 }