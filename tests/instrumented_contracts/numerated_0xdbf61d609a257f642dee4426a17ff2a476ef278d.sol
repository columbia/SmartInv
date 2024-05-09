1 pragma solidity 0.4.17;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) public constant returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public constant returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   function balanceOf(address _owner) public view returns (uint256 balance) {
54     return balances[_owner];
55   }
56 }
57 
58 contract Ownable {
59   address public owner;
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) allowed;
83 
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     var _allowance = allowed[_from][msg.sender];
86     balances[_to] = balances[_to].add(_value);
87     balances[_from] = balances[_from].sub(_value);
88     allowed[_from][msg.sender] = _allowance.sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93 
94   function approve(address _spender, uint256 _value) public returns (bool) {
95     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
96 
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105 
106 }
107 
108 contract MintableToken is StandardToken, Ownable {
109 
110   event Mint(address indexed to, uint256 amount);
111   event MintFinished();
112 
113   bool public mintingFinished = false;
114 
115   modifier canMint() {
116     require(!mintingFinished);
117     _;
118   }
119 
120   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
121     totalSupply = totalSupply.add(_amount);
122     balances[_to] = balances[_to].add(_amount);
123     Mint(_to, _amount);
124     return true;
125   }
126 
127   function finishMinting() public onlyOwner returns (bool) {
128     mintingFinished = true;
129     MintFinished();
130     return true;
131   }
132 }
133 
134 contract EndtimesToken is MintableToken {
135   string public name = "Endtimes";
136   string public symbol = "END";
137   uint256 public decimals = 18;
138 }
139 
140 contract EndtimesCrowdsale {
141   using SafeMath for uint256;
142 
143   // The token being sold
144   MintableToken public token;
145 
146   // start and end block where investments are allowed (both inclusive)
147   uint256 public ICOBeginsAt = 1512719999; // Unix timestamp
148 
149   // address where funds are collected
150   address public wallet = 0x00A3f365CDcb90fE3a7d0158Cf9D8738f3477764;
151 
152   // how many token units a buyer gets per wei
153   uint256 public rate = 7000;
154 
155   // amount of raised money in wei
156   uint256 public weiRaised;
157   
158   /**
159    * event for token purchase logging
160    * @param purchaser who paid for the tokens
161    * @param beneficiary who got the tokens
162    * @param value weis paid for purchase
163    * @param amount amount of tokens purchased
164    * @param tokenRate current rate of token purchase
165    */ 
166   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint tokenRate);
167 
168   function EndtimesCrowdsale() public {
169     token = createTokenContract();
170   }
171 
172   // creates the token to be sold. 
173   // override this method to have crowdsale of a specific mintable token.
174   function createTokenContract() internal returns (MintableToken) {
175     return new EndtimesToken();
176   }
177 
178 
179   // fallback function can be used to buy tokens
180   function () public payable {
181     buyTokens(msg.sender);
182   }
183 
184   // low level token purchase function
185   function buyTokens(address beneficiary) public payable {
186     require(beneficiary != 0x0);
187     require(ICOBeginsAt < now);
188     require(msg.value > 0);
189 
190     uint256 weiAmount = msg.value;
191 
192     // calculate token amount to be created
193     uint currentRate = getCurrentRate();
194     uint256 tokens = weiAmount.mul(currentRate);
195     assert(tokens > 0);
196     
197     // update state
198     weiRaised = weiRaised.add(weiAmount);
199 
200     token.mint(beneficiary, tokens);
201     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, currentRate);
202 
203     forwardFunds();
204   }
205   
206   function getCurrentRate() public view
207   returns (uint)
208   {
209       uint timeFrame = 1 weeks;
210       
211       if (ICOBeginsAt < now && now < ICOBeginsAt + 1 * timeFrame)
212         return (2 * rate);           // 100 % bonus
213 
214       if (ICOBeginsAt + 1 * timeFrame < now && now < ICOBeginsAt + 2 * timeFrame) 
215         return (175 * rate / 100);   // 75 % bonus
216 
217       if (ICOBeginsAt + 2 * timeFrame < now && now < ICOBeginsAt + 3 * timeFrame)
218         return (150 * rate / 100);   // 50 % bonus
219 
220       if (ICOBeginsAt + 3 * timeFrame < now && now < ICOBeginsAt + 4 * timeFrame)
221         return (140 * rate / 100);   // 40 % bonus
222 
223       if (ICOBeginsAt + 4 * timeFrame < now && now < ICOBeginsAt + 5 * timeFrame)
224         return (125 * rate / 100);   // 25 % bonus
225 
226         return rate;                 // 0 % bonus
227   }
228 
229   // send ether to the fund collection wallet
230   // override to create custom fund forwarding mechanisms
231   function forwardFunds() internal {
232     wallet.transfer(msg.value);
233   }
234 }