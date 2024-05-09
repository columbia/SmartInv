1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) constant returns (uint256);
30   function transfer(address to, uint256 value) returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) constant returns (uint256);
36   function transferFrom(address from, address to, uint256 value) returns (bool);
37   function approve(address spender, uint256 value) returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45   function transfer(address _to, uint256 _value) returns (bool) {
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51   function balanceOf(address _owner) constant returns (uint256 balance) {
52     return balances[_owner];
53   }
54 
55 }
56 
57 
58 contract StandardToken is ERC20, BasicToken {
59 
60   mapping (address => mapping (address => uint256)) allowed;
61   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
62     var _allowance = allowed[_from][msg.sender];
63     balances[_from] = balances[_from].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     allowed[_from][msg.sender] = _allowance.sub(_value);
66     Transfer(_from, _to, _value);
67     return true;
68   }
69   function approve(address _spender, uint256 _value) returns (bool) {
70     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
71 
72     allowed[msg.sender][_spender] = _value;
73     Approval(msg.sender, _spender, _value);
74     return true;
75   }
76   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77     return allowed[_owner][_spender];
78   }
79 }
80 
81 contract Ownable {
82   address public owner;
83   function Ownable() {
84     owner = msg.sender;
85   }
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90   function transferOwnership(address newOwner) onlyOwner {
91     require(newOwner != address(0));      
92     owner = newOwner;
93   }
94 
95 }
96 contract MintableToken is StandardToken, Ownable {
97   event Mint(address indexed to, uint256 amount);
98   event MintFinished();
99 
100   bool public mintingFinished = false;
101 
102     modifier canMint() {
103       require(!mintingFinished);
104     _;
105   }
106   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
107     totalSupply = totalSupply.add(_amount);
108     balances[_to] = balances[_to].add(_amount);
109     Mint(_to, _amount);
110     Transfer(0x0, _to, _amount);
111     return true;
112   }
113   function finishMinting() onlyOwner returns (bool) {
114     mintingFinished = true;
115     MintFinished();
116     return true;
117   }
118 }
119 contract LightningQiwiToken is MintableToken {
120     string public name = "Lightning Qiwi token";		
121   string public symbol = "QIWI";		
122   uint256 public decimals = 18;	
123   uint256 public INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
124   function LightningQiwiToken() {
125     totalSupply = INITIAL_SUPPLY;
126     balances[0xeBA036468a1ec330996D9dB7bD0d7B18Cb33953f] = INITIAL_SUPPLY;
127   }
128   
129 }
130 contract LightningQiwiCrowdsale is Ownable{
131   using SafeMath for uint256;
132   MintableToken public token;
133   uint256 public startTime;
134   uint256 public endTime;
135   address public wallet;
136   uint256 public rate;
137   uint256 public weiRaised;
138   event TokenPurchase (address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
139 
140 
141   function LightningQiwiCrowdsale() {
142     token = createTokenContract();
143     startTime = 1507411037;
144     endTime = 1514764799;
145     rate = 50000;
146     wallet = 0xeBA036468a1ec330996D9dB7bD0d7B18Cb33953f;
147   }
148   function createTokenContract() internal returns (MintableToken) {
149     return new LightningQiwiToken();
150   }
151   function () payable {
152     buyTokens(msg.sender);
153   }
154     event purch(address indexed from, address indexed to, uint256 value);
155   function Ended (address _to, uint256 _value) public onlyOwner  {
156     token.mint(_to, _value);
157     purch(0x0, _to, _value);
158 
159   }
160 
161   function buyTokens(address beneficiary) public payable {
162     require(beneficiary != 0x0);
163     require(validPurchase());
164 
165     uint256 weiAmount = msg.value;
166     uint256 tokens = weiAmount.mul(rate);
167 
168     weiRaised = weiRaised.add(weiAmount);
169 
170     token.mint(beneficiary, tokens);
171     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
172 
173     forwardFunds();
174   }
175   function forwardFunds() internal {
176     wallet.transfer(msg.value);
177   }
178 
179   function validPurchase() internal constant returns (bool) {
180     bool withinPeriod = now >= startTime && now <= endTime;
181     bool nonZeroPurchase = msg.value != 0;
182     return withinPeriod && nonZeroPurchase;
183   }
184 
185   function hasEnded() public constant returns (bool) {
186     return now > endTime;
187   }
188 
189 }