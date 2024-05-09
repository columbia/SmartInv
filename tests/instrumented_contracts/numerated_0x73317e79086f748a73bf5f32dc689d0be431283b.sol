1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42   
43 }
44 
45 contract BasicToken is ERC20Basic {
46     
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   function transfer(address _to, uint256 _value) returns (bool) {
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
69     var _allowance = allowed[_from][msg.sender];
70 
71 
72     balances[_to] = balances[_to].add(_value);
73     balances[_from] = balances[_from].sub(_value);
74     allowed[_from][msg.sender] = _allowance.sub(_value);
75     Transfer(_from, _to, _value);
76     return true;
77   }
78 
79   function approve(address _spender, uint256 _value) returns (bool) {
80 
81     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
82 
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89     return allowed[_owner][_spender];
90   }
91 
92 }
93 
94 contract Ownable {
95     
96   address public owner;
97 
98   function Ownable() {
99     owner = msg.sender;
100   }
101 
102   modifier onlyOwner() {
103     require(msg.sender == owner);
104     _;
105   }
106 
107   function transferOwnership(address newOwner) onlyOwner {
108     require(newOwner != address(0));      
109     owner = newOwner;
110   }
111 
112 }
113 
114 
115 contract MintableToken is StandardToken, Ownable {
116     
117   event Mint(address indexed to, uint256 amount);
118   
119   event MintFinished();
120 
121   bool public mintingFinished = false;
122 
123   modifier canMint() {
124     require(!mintingFinished);
125     _;
126   }
127 
128   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
129     totalSupply = totalSupply.add(_amount);
130     balances[_to] = balances[_to].add(_amount);
131     Mint(_to, _amount);
132     return true;
133   }
134 
135   function finishMinting() onlyOwner returns (bool) {
136     mintingFinished = true;
137     MintFinished();
138     return true;
139   }
140   
141 }
142 
143 contract Testcoin is MintableToken {
144     
145     string public constant name = "Testcoin Token";
146     
147     string public constant symbol = "TSTC";
148     
149     uint32 public constant decimals = 18;
150     
151 }
152 
153 
154 contract Crowdsale is Ownable {
155     
156     using SafeMath for uint;
157     
158     address multisig;
159 
160     Testcoin public token = new Testcoin();
161 
162     uint start;
163     
164     uint period;
165 
166     uint hardcap;
167 
168     uint rate;
169 
170     function Crowdsale() {
171         multisig = 0x18A09596E20A84EC5915DC1EBdC0B13312C924cD;
172         rate = 500000000000000000000;
173         start = 1523998800;
174         period = 30;
175         hardcap = 250000000000000000000000;
176     }
177 
178     modifier saleIsOn() {
179     	require(now > start && now < start + period * 1 days);
180     	_;
181     }
182 	
183     modifier isUnderHardCap() {
184         require(multisig.balance <= hardcap);
185         _;
186     }
187     
188     function finishMinting() public onlyOwner {
189     token.finishMinting();
190     }
191 
192    function createTokens() isUnderHardCap saleIsOn payable {
193         multisig.transfer(msg.value);
194         uint tokens = rate.mul(msg.value).div(1 ether);
195         uint bonusTokens = 0;
196         if(now < start + (period * 1 days).div(3)) {
197           bonusTokens = tokens.div(5);
198         }
199         tokens += bonusTokens;
200         token.mint(msg.sender, tokens);
201     }
202 
203     function() external payable {
204         createTokens();
205     }
206     
207 }