1 pragma solidity ^0.4.11;
2 
3 // import "./ERC223BasicToken.sol";
4 
5 // import "./SafeMath.sol";
6 /**
7  * Math operations with safety checks
8  */
9 library SafeMath {
10   function mul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint a, uint b) internal returns (uint) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint a, uint b) internal returns (uint) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint a, uint b) internal returns (uint) {
29     uint c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50   function assert(bool assertion) internal {
51     if (!assertion) {
52       throw;
53     }
54   }
55 }
56 // end import
57 
58 // import "./ERC223Basic.sol";
59 contract ERC223Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   function transfer(address to, uint value, bytes data);
64   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
65 }
66 // end import
67 
68 // import "./ERC223ReceivingContract.sol";
69  /*
70  * Contract that is working with ERC223 tokens
71  */
72 contract ERC223ReceivingContract {
73   function tokenFallback(address _from, uint _value, bytes _data);
74 }
75 // end import 
76 
77 
78 contract ERC223BasicToken is ERC223Basic {
79   using SafeMath for uint;
80 
81   mapping(address => uint) balances;
82 
83   // Function that is called when a user or another contract wants to transfer funds .
84   function transfer(address to, uint value, bytes data) {
85     // Standard function transfer similar to ERC20 transfer with no _data .
86     // Added due to backwards compatibility reasons .
87     uint codeLength;
88 
89     assembly {
90       // Retrieve the size of the code on target address, this needs assembly .
91       codeLength := extcodesize(to)
92     }
93 
94     balances[msg.sender] = balances[msg.sender].sub(value);
95     balances[to] = balances[to].add(value);
96     if (codeLength > 0) {
97       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
98       receiver.tokenFallback(msg.sender, value, data);
99     }
100     Transfer(msg.sender, to, value, data);
101   }
102 
103   // Standard function transfer similar to ERC20 transfer with no _data .
104   // Added due to backwards compatibility reasons .
105   function transfer(address to, uint value) {
106     uint codeLength;
107 
108     assembly {
109       // Retrieve the size of the code on target address, this needs assembly .
110       codeLength := extcodesize(to)
111     }
112 
113     balances[msg.sender] = balances[msg.sender].sub(value);
114     balances[to] = balances[to].add(value);
115     if (codeLength > 0) {
116       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
117       bytes memory empty;
118       receiver.tokenFallback(msg.sender, value, empty);
119     }
120     Transfer(msg.sender, to, value, empty);
121   }
122 
123   function balanceOf(address _owner) constant returns (uint balance) {
124     return balances[_owner];
125   }
126 }
127 // end import
128 
129 contract PreTgeExperty is ERC223BasicToken {
130 
131   // token constants
132   string public constant name = "Pre-TGE Experty Token";
133   string public constant symbol = "PEXY";
134   uint8 public constant decimals = 18;
135 
136   // pre-tge variables
137   uint8 public basicRate = 100;
138   uint8 public preTgeBonus = 45;
139   address public preTgeManager;
140   address public multisigWallet;
141   bool public isClosed = false;
142 
143   // keep track of burned tokens here
144   mapping(address => uint) public burnedTokens;
145   
146   // preICO constructor
147   function PreTgeExperty() {
148     multisigWallet = 0x6fb25777000c069bf4c253b9f5f886a5144a0021;
149     preTgeManager = 0x009A55A3c16953A359484afD299ebdC444200EdB;
150   }
151 
152   // contribute function
153   function() payable {
154     // throw if pre-tge is closed
155     if (isClosed) throw;
156 
157     uint ethers = msg.value;
158 
159     // calculate tokens amount and pre-tge bonus
160     uint tokens = ethers * basicRate;
161     uint bonus = ethers * preTgeBonus;
162 
163     // generate new tokens
164     uint sum = tokens + bonus;
165     balances[msg.sender] += sum;
166     totalSupply += sum;
167 
168     // send ethers to secure wallet
169     multisigWallet.transfer(ethers);
170   }
171 
172   // allow to burn pre-tge tokens in order to teleport them to new contract
173   function burnTokens(uint amount) {
174     if (amount > balances[msg.sender]) throw;
175 
176     balances[msg.sender] = balances[msg.sender].sub(amount);
177     burnedTokens[msg.sender] = burnedTokens[msg.sender].add(amount);
178   }
179 
180   // allow contract manager to decrease bonus over time
181   function changeBonus(uint8 _preTgeBonus) {
182     if (msg.sender != preTgeManager) throw;
183 
184     // we can only decrease bonus
185     if (_preTgeBonus > preTgeBonus) throw;
186 
187     preTgeBonus = _preTgeBonus;
188   }
189 
190   // allow contract manager to close pre-tge
191   function close() {
192     if (msg.sender != preTgeManager) throw;
193 
194     isClosed = true;
195   }
196 
197 }