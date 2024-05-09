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
114  * @title OOTest
115  */
116 contract OOTEST is ERC20Token, Owned {
117 
118   string  public constant name     = "OO Token";
119   string  public constant symbol   = "OO";
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
132   // mainnet
133   address public constant privateSell1Address = 0x00f32621bc1f641afec54f82fc5416f090c8f936;
134   address public constant privateSell2Address = 0x00e2b13871235796f0a5d2fd0fafe013f15f13f6;
135   address public constant team1Address        = 0x00dc41ccc0f0844e37838badac5dc97bc2cf206f;
136   address public constant team2Address        = 0x00ca7106cc04dba804d59f6fb9acef58d16d18c3;
137   address public constant team3Address        = 0x0052f120c691e35d8b6845af8e963322a7895551;
138   address public constant team4Address        = 0x005eb7b659e66cc11210e0407186ebb51ecf4d59;
139   address public constant rescueAddress       = 0x00d952948a1d10a08bc419146620ed0f147ecef3;
140 
141   // mainnet
142   uint256 public constant publicSellLockEndTime   = 1526860800; // 2018-06-05 04:00:00 GMT
143   uint256 public constant privateSell1LockEndTime = 1526866200; // 2018-07-15 04:00:00 GMT
144   uint256 public constant privateSell2LockEndTime = 1526871600; // 2018-09-01 04:00:00 GMT
145   uint256 public constant team1LockEndTime        = 1526877000; // 2018-06-05 04:00:00 GMT
146   uint256 public constant team2LockEndTime        = 1526882400; // 2019-06-05 04:00:00 GMT
147   uint256 public constant team3LockEndTime        = 1526887800; // 2020-06-05 04:00:00 GMT
148   uint256 public constant team4LockEndTime        = 1526893200; // 2021-06-05 04:00:00 GMT
149 
150   uint256 public constant maxDestroyThreshold = initialToken / 2;
151   uint256 public constant maxBurnThreshold    = maxDestroyThreshold / 8;
152   
153   mapping(address => bool) lockAddresses;
154 
155   uint256 public destroyedToken;
156 
157   event Burn(address indexed _burner, uint256 _value);
158 
159   constructor() public {
160     totalToken     = initialToken;
161 
162     balances[msg.sender]          = publicSellToken;
163     balances[privateSell1Address] = privateSell1Token;
164     balances[privateSell2Address] = privateSell2Token;
165     balances[team1Address]        = team1Token;
166     balances[team2Address]        = team2Token;
167     balances[team3Address]        = team3Token;
168     balances[team4Address]        = team4Token;
169 
170     emit Transfer(0x0, msg.sender, publicSellToken);
171     emit Transfer(0x0, privateSell1Address, privateSell1Token);
172     emit Transfer(0x0, privateSell2Address, privateSell2Token);
173     emit Transfer(0x0, team1Address, team1Token);
174     emit Transfer(0x0, team2Address, team2Token);
175     emit Transfer(0x0, team3Address, team3Token);
176     emit Transfer(0x0, team4Address, team4Token);
177 
178     lockAddresses[privateSell1Address] = true;
179     lockAddresses[privateSell2Address] = true;
180     lockAddresses[team1Address]        = true;
181     lockAddresses[team2Address]        = true;
182     lockAddresses[team3Address]        = true;
183     lockAddresses[team4Address]        = true;
184 
185     destroyedToken = 0;
186   }
187 
188   modifier transferable(address _addr) {
189     require(!lockAddresses[_addr]);
190     _;
191   }
192 
193   function unlock() public onlyOwner {
194     if (lockAddresses[privateSell1Address] && now >= privateSell1LockEndTime)
195       lockAddresses[privateSell1Address] = false;
196     if (lockAddresses[privateSell2Address] && now >= privateSell2LockEndTime)
197       lockAddresses[privateSell2Address] = false;
198     if (lockAddresses[team1Address] && now >= team1LockEndTime)
199       lockAddresses[team1Address] = false;
200     if (lockAddresses[team2Address] && now >= team2LockEndTime)
201       lockAddresses[team2Address] = false;
202     if (lockAddresses[team3Address] && now >= team3LockEndTime)
203       lockAddresses[team3Address] = false;
204     if (lockAddresses[team4Address] && now >= team4LockEndTime)
205       lockAddresses[team4Address] = false;
206   }
207 
208   function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {
209     return super.transfer(_to, _value);
210   }
211 
212   function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {
213     return super.approve(_spender, _value);
214   }
215 
216   function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {
217     return super.transferFrom(_from, _to, _value);
218   }
219 
220   function burn(uint256 _value) public onlyOwner returns (bool) {
221     require(balances[msg.sender] >= _value);
222     require(maxBurnThreshold >= _value);
223     require(maxDestroyThreshold >= destroyedToken.add(_value));
224 
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     totalToken = totalToken.sub(_value);
227     destroyedToken = destroyedToken.add(_value);
228     emit Transfer(msg.sender, 0x0, _value);
229     emit Burn(msg.sender, _value);
230     return true;
231   }
232 
233   function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
234     return ERC20(_tokenAddress).transfer(rescueAddress, _value);
235   }
236 }