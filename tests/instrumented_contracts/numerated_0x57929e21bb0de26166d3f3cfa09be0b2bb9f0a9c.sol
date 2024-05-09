1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20 {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address _who) public view returns (uint256);
33   function transfer(address _to, uint256 _value) public returns (bool);
34   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
35   function allowance(address _owner, address _spender) public view returns (uint256);
36   function approve(address _spender, uint256 _value) public returns (bool);
37   event Transfer(address indexed _from, address indexed _to, uint256 _value);
38   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract Ownable {
42   address public owner;
43 
44   function Ownable() public {
45     owner = msg.sender;
46   }
47 
48   modifier isOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address _newOwner) public isOwner {
54     require(_newOwner != address(0));
55     OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 
59   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
60 }
61 
62 contract Pausable is Ownable {
63   bool public stopped = false;
64 
65   modifier isRunning() {
66     require(!stopped);
67     _;
68   }
69 
70   modifier isStopped() {
71     require(stopped);
72     _;
73   }
74 
75   function stop() isOwner isRunning public {
76     stopped = true;
77     Pause();
78   }
79 
80   function start() isOwner isStopped public {
81     stopped = false;
82     Unpause();
83   }
84 
85   event Pause();
86   event Unpause();
87 }
88 
89 contract CPTXToken is ERC20, Pausable {
90   using SafeMath for uint256;
91 
92   string public constant name = "Crypterra Token";
93   string public constant symbol = "CPTX";
94   uint8 public constant decimals = 18;
95 
96   uint256 public constant INITIAL_SUPPLY = 600000000 * (10 ** uint256(decimals));
97 
98   mapping(address => uint256) balances;
99   mapping (address => mapping (address => uint256)) internal allowed;
100 
101   uint256 totalSupply_;
102 
103   function CPTXToken() public {
104     totalSupply_ = INITIAL_SUPPLY;
105     balances[msg.sender] = INITIAL_SUPPLY;
106     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
107   }
108 
109   modifier validAddress {
110     assert(0x0 != msg.sender);
111     _;
112   }
113 
114   function totalSupply() public view returns (uint256) {
115     return totalSupply_;
116   }
117 
118   function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool) {
119     require(_to != address(0));
120     require(balances[msg.sender] >= _value);
121     require(balances[_to] + _value >= balances[_to]);
122 
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133   function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool) {
134     require(_to != address(0));
135     require(balances[_from] >= _value);
136     require(allowed[_from][msg.sender] >= _value);
137     require(balances[_to] + _value >= balances[_to]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   function approve(address _spender, uint256 _value) isRunning public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   function burn(uint256 _value) public {
157     require(_value > 0);
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     totalSupply_ = totalSupply_.sub(_value);
160     Burn(msg.sender, _value);
161   }
162  
163   event Burn(address indexed _burner, uint256 indexed _value);
164 }