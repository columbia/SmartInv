1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20 interface
36  */
37 contract ERC20 {
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address _owner) public view returns (uint256);
40   function transfer(address _to, uint256 _value) public returns (bool);
41   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
42   function approve(address _spender, uint256 _value) public returns (bool);
43   function allowance(address _owner, address _spender) public view returns (uint256);
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 /**
49  * @title Owned
50  */
51 contract Owned {
52   address public owner;
53 
54   constructor() public {
55     owner = msg.sender;
56   }
57   
58   modifier onlyOwner {
59     require(msg.sender == owner);
60     _;
61   }
62 }
63 
64 /**
65  * @title ERC20 token
66  */
67 contract ERC20Token is ERC20 {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71   mapping (address => mapping (address => uint256)) allowed;
72   uint256 public totalToken;
73 
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(balances[msg.sender] >= _value);
76 
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(balances[_from] >= _value);
85     require(allowed[_from][msg.sender] >= _value);
86 
87     balances[_from] = balances[_from].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90     emit Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function totalSupply() public view returns (uint256) {
95     return totalToken;
96   }
97 
98   function balanceOf(address _owner) public view returns (uint256) {
99     return balances[_owner];
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     emit Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) public view returns (uint256) {
109     return allowed[_owner][_spender];
110   }
111 }
112 
113 /**
114  * @title CCCCTest
115  */
116 contract KKKKTEST is ERC20Token, Owned {
117 
118   string  public constant name     = "KKKK Token";
119   string  public constant symbol   = "KKKK";
120   uint256 public constant decimals = 18;
121 
122   uint256 public constant initialToken      = 500000000 * (10 ** decimals);
123 
124   uint256 public constant publicSellToken   = initialToken * 350 / 1000; // 35%
125   uint256 public constant privateSell1Token = initialToken * 125 / 1000; // 12.5%
126   uint256 public constant privateSell2Token = initialToken * 125 / 1000; // 12.5%
127   uint256 public constant team1Token        = initialToken * 100 / 1000; // 10%
128   uint256 public constant team2Token        = initialToken * 100 / 1000; // 10%
129   uint256 public constant team3Token        = initialToken * 100 / 1000; // 10%
130   uint256 public constant team4Token        = initialToken * 100 / 1000; // 10%
131 
132   address public constant privateSell1Address = 0x4eE26F915f55d9833e7Adb5a07F010819D84682A;
133   address public constant privateSell2Address = 0xFA4A129f698C9c1c3545Caf994D8B3B24E234CcF;
134   address public constant team1Address        = 0x2cFD5263896aA51085FFaBF0183dA67F26e5789c;
135   address public constant team2Address        = 0x86BEa0b293dE7975aA9Dd49b8a52c0e10BD243dC;
136   address public constant team3Address        = 0x998D65FB3cAF5da8bE56890414d9fC42a1A8952b;
137   address public constant team4Address        = 0x7fb80E0bc908e02a6E7b0cA438370Af31B739445;
138   address public constant rescueAddress       = 0x83Af23a1794886F5C680ba3448D7E43dBf851658;
139 
140   uint256 public constant publicSellLockEndTime   = 1526566422; // 2018-06-05 04:00:00 GMT
141   uint256 public constant privateSell1LockEndTime = 1526568125; // 2018-07-15 04:00:00 GMT
142   uint256 public constant privateSell2LockEndTime = 1526568125; // 2018-09-01 04:00:00 GMT
143   uint256 public constant team1LockEndTime        = 1526568125; // 2018-06-05 04:00:00 GMT
144   uint256 public constant team2LockEndTime        = 1526568125; // 2019-06-05 04:00:00 GMT
145   uint256 public constant team3LockEndTime        = 1526568125; // 2020-06-05 04:00:00 GMT
146   uint256 public constant team4LockEndTime        = 1526568125; // 2021-06-05 04:00:00 GMT
147 
148   uint256 public constant maxDestroyThreshold = initialToken / 2;
149   uint256 public constant maxBurnThreshold    = maxDestroyThreshold / 8;
150   
151   mapping(address => bool) lockAddresses;
152 
153   uint256 public destroyedToken;
154 
155   event Burn(address indexed _burner, uint256 _value);
156 
157   constructor() public {
158     totalToken     = initialToken;
159 
160     balances[msg.sender]          = publicSellToken;
161     balances[privateSell1Address] = privateSell1Token;
162     balances[privateSell2Address] = privateSell2Token;
163     balances[team1Address]        = team1Token;
164     balances[team2Address]        = team2Token;
165     balances[team3Address]        = team3Token;
166     balances[team4Address]        = team4Token;
167 
168     lockAddresses[privateSell1Address] = true;
169     lockAddresses[privateSell2Address] = true;
170     lockAddresses[team1Address]        = true;
171     lockAddresses[team2Address]        = true;
172     lockAddresses[team3Address]        = true;
173     lockAddresses[team4Address]        = true;
174 
175     destroyedToken = 0;
176   }
177 
178   modifier transferable(address _addr) {
179     require(!lockAddresses[_addr]);
180     _;
181   }
182 
183   function unlock() public onlyOwner {
184     if (lockAddresses[privateSell1Address] && now >= privateSell1LockEndTime)
185       lockAddresses[privateSell1Address] = false;
186     if (lockAddresses[privateSell2Address] && now >= privateSell2LockEndTime)
187       lockAddresses[privateSell2Address] = false;
188     if (lockAddresses[team1Address] && now >= team1LockEndTime)
189       lockAddresses[team1Address] = false;
190     if (lockAddresses[team2Address] && now >= team2LockEndTime)
191       lockAddresses[team2Address] = false;
192     if (lockAddresses[team3Address] && now >= team3LockEndTime)
193       lockAddresses[team3Address] = false;
194     if (lockAddresses[team4Address] && now >= team4LockEndTime)
195       lockAddresses[team4Address] = false;
196   }
197 
198   function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {
199     return super.transfer(_to, _value);
200   }
201 
202   function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {
203     return super.approve(_spender, _value);
204   }
205 
206   function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {
207     return super.transferFrom(_from, _to, _value);
208   }
209 
210   function burn(uint256 _value) public onlyOwner returns (bool) {
211     require(balances[msg.sender] >= _value);
212     require(maxBurnThreshold >= _value);
213     require(maxDestroyThreshold >= destroyedToken.add(_value));
214 
215     balances[msg.sender] = balances[msg.sender].sub(_value);
216     totalToken = totalToken.sub(_value);
217     destroyedToken = destroyedToken.add(_value);
218     emit Transfer(msg.sender, 0x0, _value);
219     emit Burn(msg.sender, _value);
220     return true;
221   }
222 
223   function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
224     return ERC20(_tokenAddress).transfer(rescueAddress, _value);
225   }
226 }