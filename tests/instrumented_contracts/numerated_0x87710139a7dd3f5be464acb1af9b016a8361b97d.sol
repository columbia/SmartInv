1 pragma solidity ^0.4.11;
2 
3 // import "browser/ERC223BasicToken.sol";
4 
5 // import "browser/SafeMath.sol";
6 
7 /**
8  * Math operations with safety checks
9  */
10 library SafeMath {
11   function mul(uint a, uint b) internal returns (uint) {
12     uint c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint a, uint b) internal returns (uint) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint a, uint b) internal returns (uint) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint a, uint b) internal returns (uint) {
30     uint c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 
35   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a >= b ? a : b;
37   }
38 
39   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
40     return a < b ? a : b;
41   }
42 
43   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a >= b ? a : b;
45   }
46 
47   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a < b ? a : b;
49   }
50 
51   function assert(bool assertion) internal {
52     if (!assertion) {
53       throw;
54     }
55   }
56 }
57 
58 // end import
59 
60 
61 contract ERC223Basic {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function transfer(address to, uint value);
65   function transfer(address to, uint value, bytes data);
66   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
67 }
68 
69  /*
70  * Contract that is working with ERC223 tokens
71  */
72 contract ERC223ReceivingContract {
73   function tokenFallback(address _from, uint _value, bytes _data);
74 }
75 
76 
77 contract ERC223BasicToken is ERC223Basic {
78   using SafeMath for uint;
79 
80   mapping(address => uint) balances;
81 
82   // Function that is called when a user or another contract wants to transfer funds .
83   function transfer(address to, uint value, bytes data) {
84     // Standard function transfer similar to ERC20 transfer with no _data .
85     // Added due to backwards compatibility reasons .
86     uint codeLength;
87 
88     assembly {
89       // Retrieve the size of the code on target address, this needs assembly .
90       codeLength := extcodesize(to)
91     }
92 
93     balances[msg.sender] = balances[msg.sender].sub(value);
94     balances[to] = balances[to].add(value);
95     if (codeLength > 0) {
96       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
97       receiver.tokenFallback(msg.sender, value, data);
98     }
99     Transfer(msg.sender, to, value, data);
100   }
101 
102   // Standard function transfer similar to ERC20 transfer with no _data .
103   // Added due to backwards compatibility reasons .
104   function transfer(address to, uint value) {
105     uint codeLength;
106 
107     assembly {
108       // Retrieve the size of the code on target address, this needs assembly .
109       codeLength := extcodesize(to)
110     }
111 
112     balances[msg.sender] = balances[msg.sender].sub(value);
113     balances[to] = balances[to].add(value);
114     if (codeLength > 0) {
115       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
116       bytes memory empty;
117       receiver.tokenFallback(msg.sender, value, empty);
118     }
119     Transfer(msg.sender, to, value, empty);
120   }
121 
122   function balanceOf(address _owner) constant returns (uint balance) {
123     return balances[_owner];
124   }
125 }
126 // end import
127 
128 contract PreTgeExperty is ERC223BasicToken {
129 
130   // token constants
131   string public constant name = "Pre-TGE Experty Token";
132   string public constant symbol = "PEXY";
133   uint8 public constant decimals = 18;
134 
135   // pre-tge variables
136   uint8 public basicRate = 100;
137   uint8 public preTgeBonus = 45;
138   address public preTgeManager;
139   address public multisigWallet;
140   bool public isClosed = false;
141 
142   // keep track of burned tokens here
143   mapping(address => uint) public burnedTokens;
144   
145   // preICO constructor
146   function PreTgeExperty() {
147     multisigWallet = 0x60f4025c67477edf3a8eda7d1bf6b3b035a664eb;
148     preTgeManager = 0x009A55A3c16953A359484afD299ebdC444200EdB;
149   }
150 
151   // contribute function
152   function() payable {
153     // throw if pre-tge is closed
154     if (isClosed) throw;
155 
156     uint ethers = msg.value;
157 
158     // calculate tokens amount and pre-tge bonus
159     uint tokens = ethers * basicRate;
160     uint bonus = ethers * preTgeBonus;
161 
162     // generate new tokens
163     uint sum = tokens + bonus;
164     balances[msg.sender] += sum;
165     totalSupply += sum;
166 
167     // send ethers to secure wallet
168     multisigWallet.transfer(ethers);
169   }
170 
171   // allow to burn pre-tge tokens in order to teleport them to new contract
172   function burnTokens(uint amount) {
173     if (amount > balances[msg.sender]) throw;
174 
175     balances[msg.sender] = balances[msg.sender].sub(amount);
176     burnedTokens[msg.sender] = burnedTokens[msg.sender].add(amount);
177   }
178 
179   // allow contract manager to decrease bonus over time
180   function changeBonus(uint8 _preTgeBonus) {
181     if (msg.sender != preTgeManager) throw;
182 
183     // we can only decrease bonus
184     if (_preTgeBonus > preTgeBonus) throw;
185 
186     preTgeBonus = _preTgeBonus;
187   }
188 
189   // allow contract manager to close pre-tge
190   function close() {
191     if (msg.sender != preTgeManager) throw;
192 
193     isClosed = true;
194   }
195 
196 }