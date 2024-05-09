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
114  * @title PandaGold Token
115  */
116 contract PandaGoldToken is ERC20Token, Owned {
117 
118   string  public constant name     = "PandaGold Token";
119   string  public constant symbol   = "PANDA";
120   uint256 public constant decimals = 18;
121 
122   uint256 public constant initialToken     = 2000000000 * (10 ** decimals);
123 
124   uint256 public constant publicToken      = initialToken * 55 / 100; // 55%
125   uint256 public constant founderToken     = initialToken * 10 / 100; // 10%
126   uint256 public constant developmentToken = initialToken * 10 / 100; // 10%
127   uint256 public constant bountyToken      = initialToken *  5 / 100; //  5%
128   uint256 public constant privateSaleToken = initialToken * 10 / 100; // 10%
129   uint256 public constant preSaleToken     = initialToken * 10 / 100; // 10%
130 
131   address public constant founderAddress     = 0x003d9d0ebfbDa7AEc39EEAEcc4D47Dd18eA3c495;
132   address public constant developmentAddress = 0x00aCede2bdf8aecCedb0B669DbA662edC93D6178;
133   address public constant bountyAddress      = 0x00D42B2864C6E383b1FD9E56540c43d3815D486e;
134   address public constant privateSaleAddress = 0x00507Bf4d07A693fB7C4F9d846d58951042260aa;
135   address public constant preSaleAddress     = 0x00241bD9aa09b440DE23835BB2EE0a45926Bb61A;
136   address public constant rescueAddress      = 0x005F25Bc2386BfE9E5612f2C437c5e5E45720874;
137 
138   uint256 public constant founderLockEndTime     = 1577836800; // 2020-01-01 00:00:00 GMT
139   uint256 public constant developmentLockEndTime = 1559347200; // 2019-06-01 00:00:00 GMT
140   uint256 public constant bountyLockEndTime      = 1543363200; // 2018-11-28 00:00:00 GMT
141   uint256 public constant privateSaleLockEndTime = 1546300800; // 2019-01-01 00:00:00 GMT
142   uint256 public constant preSaleLockEndTime     = 1543363200; // 2018-11-28 00:00:00 GMT
143 
144   uint256 public constant maxDestroyThreshold = initialToken / 2;
145   uint256 public constant maxBurnThreshold    = maxDestroyThreshold / 50;
146   
147   mapping(address => bool) lockAddresses;
148 
149   uint256 public destroyedToken;
150 
151   event Burn(address indexed _burner, uint256 _value);
152 
153   constructor() public {
154     totalToken     = initialToken;
155 
156     balances[msg.sender]         = publicToken;
157     balances[founderAddress]     = founderToken;
158     balances[developmentAddress] = developmentToken;
159     balances[bountyAddress]      = bountyToken;
160     balances[privateSaleAddress] = privateSaleToken;
161     balances[preSaleAddress]     = preSaleToken;
162 
163     emit Transfer(0x0, msg.sender, publicToken);
164     emit Transfer(0x0, founderAddress, founderToken);
165     emit Transfer(0x0, developmentAddress, developmentToken);
166     emit Transfer(0x0, bountyAddress, bountyToken);
167     emit Transfer(0x0, privateSaleAddress, privateSaleToken);
168     emit Transfer(0x0, preSaleAddress, preSaleToken);
169 
170     lockAddresses[founderAddress]     = true;
171     lockAddresses[developmentAddress] = true;
172     lockAddresses[bountyAddress]      = true;
173     lockAddresses[privateSaleAddress] = true;
174     lockAddresses[preSaleAddress]     = true;
175 
176     destroyedToken = 0;
177   }
178 
179   modifier transferable(address _addr) {
180     require(!lockAddresses[_addr]);
181     _;
182   }
183 
184   function unlock() public onlyOwner {
185     if (lockAddresses[founderAddress] && now >= founderLockEndTime)
186       lockAddresses[founderAddress] = false;
187     if (lockAddresses[developmentAddress] && now >= developmentLockEndTime)
188       lockAddresses[developmentAddress] = false;
189     if (lockAddresses[bountyAddress] && now >= bountyLockEndTime)
190       lockAddresses[bountyAddress] = false;
191     if (lockAddresses[privateSaleAddress] && now >= privateSaleLockEndTime)
192       lockAddresses[privateSaleAddress] = false;
193     if (lockAddresses[preSaleAddress] && now >= preSaleLockEndTime)
194       lockAddresses[preSaleAddress] = false;
195   }
196 
197   function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {
198     return super.transfer(_to, _value);
199   }
200 
201   function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {
202     return super.approve(_spender, _value);
203   }
204 
205   function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {
206     return super.transferFrom(_from, _to, _value);
207   }
208 
209   function burn(uint256 _value) public onlyOwner returns (bool) {
210     require(balances[msg.sender] >= _value);
211     require(maxBurnThreshold >= _value);
212     require(maxDestroyThreshold >= destroyedToken.add(_value));
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     totalToken = totalToken.sub(_value);
216     destroyedToken = destroyedToken.add(_value);
217     emit Transfer(msg.sender, 0x0, _value);
218     emit Burn(msg.sender, _value);
219     return true;
220   }
221 
222   function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
223     return ERC20(_tokenAddress).transfer(rescueAddress, _value);
224   }
225 }