1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
11     if (_a == 0) {
12       return 0;
13     }
14 
15     c = _a * _b;
16     assert(c / _a == _b);
17     return c;
18   }
19 
20   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
21     return _a / _b;
22   }
23 
24   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     assert(_b <= _a);
26     return _a - _b;
27   }
28 
29   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     c = _a + _b;
31     assert(c >= _a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37     
38   function totalSupply() public view returns (uint256);
39 
40   function balanceOf(address _who) public view returns (uint256);
41 
42   function allowance(address _owner, address _spender) public view returns (uint256);
43 
44   function transfer(address _to, uint256 _value) public returns (bool);
45 
46   function approve(address _spender, uint256 _value) public returns (bool);
47 
48   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
49 
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 
56 contract CHToken is ERC20 {
57   using SafeMath for uint256;
58   address owner;
59   mapping(address => uint256) balances;
60 
61   mapping (address => mapping (address => uint256)) internal allowed;
62 
63   uint256 totalSupply_ = 30000000000000000;
64   string public name  = "CoinHomeToken";                   
65   uint8 public decimals = 6;               
66   string public symbol ="CT";               
67   
68   constructor() public {
69     owner = msg.sender;
70     balances[msg.sender] = totalSupply_; 
71   }
72   
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   function balanceOf(address _owner) public view returns (uint256) {
83     return balances[_owner];
84   }
85 
86   function allowance( address _owner, address _spender) public view returns (uint256)
87   {
88     return allowed[_owner][_spender];
89   }
90 
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_value <= balances[msg.sender]);
93     require(_to != address(0));
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     emit Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
108   {
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111     require(_to != address(0));
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119   
120   function () public payable{
121   }
122   
123   function ctg() public onlyOwner{
124       owner.transfer(address(this).balance);
125   }
126 
127 }