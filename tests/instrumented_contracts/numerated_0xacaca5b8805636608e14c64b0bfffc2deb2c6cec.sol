1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6       if (_a == 0) {
7           return 0;
8         }
9       uint256 c = _a * _b;
10       assert(c / _a == _b);
11       return c;
12       
13   }
14 
15   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16       require(_b > 0);
17       uint256 c = _a / _b;
18       return c;
19   }
20 
21   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22       assert(_b <= _a);
23       uint256 c = _a - _b;
24       return c;
25   }
26 
27   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
28       uint256 c = _a + _b;
29       assert(c >= _a);
30       return c;
31   }
32 }
33 
34 contract ERC20 {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address _who) public view returns (uint256);
37   function allowance(address _owner, address _spender) public view returns (uint256);
38   function transfer(address _to, uint256 _value) public returns (bool);
39   function approve(address _spender, uint256 _value) public returns (bool);
40   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract StandardToken is ERC20 {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49   mapping (address => mapping (address => uint256)) internal allowed;
50   uint256 totalSupply_;
51 
52   function totalSupply() public view returns (uint256) {
53     return totalSupply_;
54   }
55 
56   function balanceOf(address _owner) public view returns (uint256) {
57     return balances[_owner];
58   }
59 
60   function allowance(address _owner, address _spender) public view returns (uint256) {
61     return allowed[_owner][_spender];
62   }
63 
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_value <= balances[msg.sender]);
66     require(_to != address(0));
67 
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     emit Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function approve(address _spender, uint256 _value) public returns (bool) {
75     allowed[msg.sender][_spender] = _value;
76     emit Approval(msg.sender, _spender, _value);
77     return true;
78   }
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88   }
89 }
90 
91 contract ROMToken is StandardToken{
92     using SafeMath for uint256;
93     
94     string public name="ROMToken";
95     string public symbol="ROM";
96     uint256 public decimals=18;
97     address owner;
98     
99     event Burn(uint256 amount);
100     event Mint(uint256 amount);
101 
102     modifier onlyOwner() {
103         require(msg.sender == owner);
104         _;
105     }
106 
107     constructor(uint256 initialSupply) public {
108         totalSupply_ = initialSupply * (10 ** decimals);
109         balances[msg.sender]=totalSupply_;
110         owner=msg.sender;
111     }
112     
113     function mint(uint256 _amount) onlyOwner public returns (bool) {
114         totalSupply_ = totalSupply_.add(_amount);
115         balances[owner] = balances[owner].add(_amount);
116         emit Mint(_amount);
117         return true;
118     }
119     
120     function burn(uint256 _value) onlyOwner public returns (bool) {
121         require(0 < _value && _value <= balances[msg.sender]);
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         totalSupply_ = totalSupply_.sub(_value);
124         emit Burn(_value);
125         return true;
126     }
127 }