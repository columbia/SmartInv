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
114  * @title ALLN Token
115  */
116 contract ALLNToken is ERC20Token, Owned {
117 
118   string  public constant name     = "ALLN Token";
119   string  public constant symbol   = "ALLN";
120   uint256 public constant decimals = 18;
121 
122   uint256 public constant initialToken     = 3500000000 * (10 ** decimals);
123 
124   uint256 public constant publicToken      = initialToken * 85 / 100; // 85%
125   uint256 public constant developmentToken = initialToken * 15 / 100; // 15%
126 
127   address public constant developmentAddress = 0x00881db6BAC37d502EBd39FbBCc69a063e3b4777;
128   address public constant rescueAddress      = 0x001b97f5760DD45b0Df6467BB76a06Da76fF8720;
129 
130   uint256 public constant developmentLockEndTime = 1569902400; // 2019-10-01 04:00:00 GMT
131 
132   mapping(address => bool) lockAddresses;
133 
134   constructor() public {
135     totalToken     = initialToken;
136 
137     balances[msg.sender]         = publicToken;
138     balances[developmentAddress] = developmentToken;
139 
140     emit Transfer(0x0, msg.sender, publicToken);
141     emit Transfer(0x0, developmentAddress, developmentToken);
142 
143     lockAddresses[developmentAddress] = true;
144   }
145 
146   modifier transferable(address _addr) {
147     require(!lockAddresses[_addr]);
148     _;
149   }
150 
151   function unlock() public onlyOwner {
152     if (lockAddresses[developmentAddress] && now >= developmentLockEndTime)
153       lockAddresses[developmentAddress] = false;
154   }
155 
156   function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {
157     return super.transfer(_to, _value);
158   }
159 
160   function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {
161     return super.approve(_spender, _value);
162   }
163 
164   function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {
165     return super.transferFrom(_from, _to, _value);
166   }
167 
168   function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
169     return ERC20(_tokenAddress).transfer(rescueAddress, _value);
170   }
171 }