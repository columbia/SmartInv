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
114  * @title Racing Pigeon Coin
115  */
116 contract RacingPigeonCoin is ERC20Token, Owned {
117 
118   string  public constant name     = "Racing Pigeon Coin";
119   string  public constant symbol   = "RPC";
120   uint256 public constant decimals = 18;
121 
122   uint256 public constant initialToken     = 500000000 * (10 ** decimals);
123 
124   uint256 public constant unlockedToken = initialToken * 40 / 100; // 40%
125   uint256 public constant team1Token    = initialToken * 15 / 100; // 15%
126   uint256 public constant team2Token    = initialToken * 15 / 100; // 15%
127   uint256 public constant team3Token    = initialToken * 15 / 100; // 15%
128   uint256 public constant team4Token    = initialToken * 15 / 100; // 15%
129 
130   address public constant team1Address  = 0x00602F855B9EC54D8A02aFb7d8a36d0129729242;
131   address public constant team2Address  = 0x00215cFb433105d55344b6f8c9c8d6557203b858;
132   address public constant team3Address  = 0x004a9b534313fA84Ed0295c5f255448bD68F085C;
133   address public constant team4Address  = 0x00B219Cb01c0ba8176CFbB0bDA16d2729d9E2823;
134   address public constant rescueAddress = 0x00bACAfB97DCcDb091e2b3554F6D3A2838383334;
135 
136   uint256 public constant team1LockEndTime = 1558314000; // 2019-05-20 01:00:00 GMT
137   uint256 public constant team2LockEndTime = 1574211600; // 2019-11-20 01:00:00 GMT
138   uint256 public constant team3LockEndTime = 1589936400; // 2020-05-20 01:00:00 GMT
139   uint256 public constant team4LockEndTime = 1605834000; // 2020-11-20 01:00:00 GMT
140 
141   uint256 public constant maxDestroyThreshold = initialToken / 2;
142   uint256 public constant maxBurnThreshold    = maxDestroyThreshold / 50;
143   
144   mapping(address => bool) lockAddresses;
145 
146   uint256 public destroyedToken;
147 
148   event Burn(address indexed _burner, uint256 _value);
149 
150   constructor() public {
151     totalToken     = initialToken;
152 
153     balances[msg.sender]   = unlockedToken;
154     balances[team1Address] = team1Token;
155     balances[team2Address] = team2Token;
156     balances[team3Address] = team3Token;
157     balances[team4Address] = team4Token;
158 
159     emit Transfer(0x0, msg.sender, unlockedToken);
160     emit Transfer(0x0, team1Address, team1Token);
161     emit Transfer(0x0, team2Address, team2Token);
162     emit Transfer(0x0, team3Address, team3Token);
163     emit Transfer(0x0, team4Address, team4Token);
164 
165     lockAddresses[team1Address] = true;
166     lockAddresses[team2Address] = true;
167     lockAddresses[team3Address] = true;
168     lockAddresses[team4Address] = true;
169 
170     destroyedToken = 0;
171   }
172 
173   modifier transferable(address _addr) {
174     require(!lockAddresses[_addr]);
175     _;
176   }
177 
178   function unlock() public onlyOwner {
179     if (lockAddresses[team1Address] && now >= team1LockEndTime)
180       lockAddresses[team1Address] = false;
181     if (lockAddresses[team2Address] && now >= team2LockEndTime)
182       lockAddresses[team2Address] = false;
183     if (lockAddresses[team3Address] && now >= team3LockEndTime)
184       lockAddresses[team3Address] = false;
185     if (lockAddresses[team4Address] && now >= team4LockEndTime)
186       lockAddresses[team4Address] = false;
187   }
188 
189   function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {
190     return super.transfer(_to, _value);
191   }
192 
193   function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {
194     return super.approve(_spender, _value);
195   }
196 
197   function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {
198     return super.transferFrom(_from, _to, _value);
199   }
200 
201   function burn(uint256 _value) public onlyOwner returns (bool) {
202     require(balances[msg.sender] >= _value);
203     require(maxBurnThreshold >= _value);
204     require(maxDestroyThreshold >= destroyedToken.add(_value));
205 
206     balances[msg.sender] = balances[msg.sender].sub(_value);
207     totalToken = totalToken.sub(_value);
208     destroyedToken = destroyedToken.add(_value);
209     emit Transfer(msg.sender, 0x0, _value);
210     emit Burn(msg.sender, _value);
211     return true;
212   }
213 
214   function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
215     return ERC20(_tokenAddress).transfer(rescueAddress, _value);
216   }
217 }