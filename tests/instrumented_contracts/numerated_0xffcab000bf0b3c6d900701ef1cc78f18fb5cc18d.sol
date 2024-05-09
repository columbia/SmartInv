1 pragma solidity ^0.4.24;
2 
3 contract Ownable{
4 
5  address public owner;
6  
7  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9    constructor() public {
10      owner = msg.sender;
11    }
12 
13    modifier onlyOwner() {
14      require(msg.sender == owner);
15     _;
16    }
17     
18    function transferOwnership(address newOwner) public onlyOwner {
19      require(newOwner != address(0));
20      emit OwnershipTransferred(owner, newOwner);
21      owner = newOwner;
22    }
23  }
24 
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 } 
53     
54 contract MintableToken is Ownable {
55 
56   using SafeMath for uint256;
57 
58   uint256 public totalSupply;
59 
60   event Mint(address indexed to, uint256 amount);
61   event Transfer(address indexed _from, address indexed _to, uint256 _value);
62   event MintFinished();
63 
64   bool public mintingFinished = false;
65   
66   address public saleAgent;
67 
68   mapping (address => uint256) balances;
69   
70   function setSaleAgent(address newSaleAgnet) public onlyOwner {
71     saleAgent = newSaleAgnet;
72   }
73 
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(msg.sender == saleAgent);
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89   function mint(address _to, uint256 _amount) public returns (bool) {
90     require(msg.sender == saleAgent && !mintingFinished);
91     
92     totalSupply = totalSupply.add(_amount);
93     balances[_to] = balances[_to].add(_amount);
94     emit Mint(_to, _amount);
95     return true;
96   }
97 
98   function finishMinting() public returns (bool) {
99     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
100     mintingFinished = true;
101     emit MintFinished();
102     return true;
103   }
104 
105 }
106 
107 contract TokenSale is Ownable {
108 
109   using SafeMath for uint;
110   uint public period;
111   uint public price = 1000000000000000000;
112   uint public start;
113   uint public minInvestedLimit = 100000000000000000;
114   uint public hardcap = 25000000000000000000000;
115   uint public invested;
116 
117   MintableToken public token;
118 
119   bool public PreICO = true;
120 
121   address public wallet;
122 
123   mapping(address => bool) public whiteList;
124   
125   modifier isUnderHardcap() {
126     require(invested < hardcap);
127     _;
128   }
129 
130   modifier PhaseCheck() {
131     if(PreICO == true)
132     require(whiteList[msg.sender]);
133     _;
134   }
135 
136   modifier minInvestLimited(uint value) {
137     require(value >= minInvestedLimit);
138     _;
139   }
140 
141   function addToWhiteList(address _address) public onlyOwner {
142     whiteList[_address] = true;
143   }
144   
145   function deleteFromWhiteList(address _address) public onlyOwner {
146     whiteList[_address] = false;
147   }
148 
149   function preicofinish() public onlyOwner {
150     PreICO = false;
151   }
152   
153   function icofinish() public onlyOwner {
154     token.finishMinting();
155   }
156 
157   function GRW() public onlyOwner {
158     PreICO = true;
159   }
160 
161   function setToken(address newToken) public onlyOwner {
162     token = MintableToken(newToken);
163   }
164 
165   function setWallet(address newWallet) public onlyOwner {
166     wallet = newWallet;
167   }
168 
169   function setStart(uint newStart) public onlyOwner {
170     start = newStart;
171   }
172   
173   function setPeriod(uint newPeriod) public onlyOwner {
174     period = newPeriod;
175   }
176   
177   function endSaleDate() public view returns(uint) {
178     return start.add(period * 1 days);
179   }
180   
181   function calculateTokens(uint _invested) internal view returns(uint) {
182     return _invested.mul(price).div(1 ether);
183   }
184 
185   function mintTokens(address to, uint tokens) internal {
186     token.mint(this, tokens);
187     token.transfer(to, tokens);
188   }
189 
190   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
191     invested = invested.add(_invested);
192     uint tokens = calculateTokens(_invested);
193     mintTokens(to, tokens);
194     return tokens;
195   }
196 
197   function fallback() internal minInvestLimited(msg.value) PhaseCheck returns(uint) {
198     require(now >= start && now < endSaleDate());
199     wallet.transfer(msg.value);
200     return mintTokensByETH(msg.sender, msg.value);
201   }
202 
203   function () public payable {
204     fallback();
205   }
206 
207 }
208 
209 contract GrowUpToken is MintableToken {
210 
211   string public constant name = "GrowUpToken";
212 
213   string public constant symbol = "GRW";
214 
215   uint32 public constant decimals = 0;
216 
217 }