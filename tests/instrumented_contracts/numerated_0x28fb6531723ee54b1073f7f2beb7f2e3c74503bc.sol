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
37 contract StandardToken {
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
65  * @title ALLN Token
66  */
67 contract ALLNToken is StandardToken {
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
114  * @title Airline & Life Networking Token
115  */
116 contract ALLN is ALLNToken, Owned {
117 
118   string  public constant name     = "Airline & Life Networking";
119   string  public constant symbol   = "ALLN";
120   uint256 public constant decimals = 18;
121 
122   uint256 public constant initialToken     = 3500000000 * (10 ** decimals);
123 
124   uint256 public constant publicToken      = initialToken * 100 / 100;
125 
126   address public constant lockoutAddress = 0x7B080EDe2f84240DE894fd2f35bCe464a5d67f4D;
127   address public constant rescueAddress = 0xa1AA83108bf7B225b35260273899686eBF4839C7;
128 
129   uint256 public constant lockoutEndTime = 1569902400; // 2019-10-01 04:00:00 GMT
130 
131   mapping(address => bool) lockAddresses;
132 
133   constructor() public {
134     totalToken     = initialToken;
135 
136     balances[msg.sender]         = publicToken;
137 
138     emit Transfer(0x0, msg.sender, publicToken);
139 
140     lockAddresses[lockoutAddress] = false;
141   }
142 
143   modifier transferable(address _addr) {
144     require(!lockAddresses[_addr]);
145     _;
146   }
147 
148   function unlock() public onlyOwner {
149    //  if (lockAddresses[lockoutAddress] && now >= lockoutEndTime)
150     if (lockAddresses[lockoutAddress])
151       lockAddresses[lockoutAddress] = false;
152   }
153 
154   function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {
155     return super.transfer(_to, _value);
156   }
157 
158   function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {
159     return super.approve(_spender, _value);
160   }
161 
162   function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {
163     return super.transferFrom(_from, _to, _value);
164   }
165 
166   function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
167     return ALLNToken(_tokenAddress).transfer(rescueAddress, _value);
168   }
169 }