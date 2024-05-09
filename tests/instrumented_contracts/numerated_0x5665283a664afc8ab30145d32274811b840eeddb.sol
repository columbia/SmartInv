1 pragma solidity ^0.4.24;
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
56 contract BMVToken is ERC20 {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   mapping (address => mapping (address => uint256)) internal allowed;
62 
63   uint256 totalSupply_ = 1500000000000000;
64   string public name  = "BlockMoveVelocity";                   
65   uint8 public decimals = 6;               
66   string public symbol ="BMV";               
67   
68   constructor() public {
69     balances[msg.sender] = totalSupply_; 
70   }
71 
72   function totalSupply() public view returns (uint256) {
73     return totalSupply_;
74   }
75 
76   function balanceOf(address _owner) public view returns (uint256) {
77     return balances[_owner];
78   }
79 
80   function allowance( address _owner, address _spender) public view returns (uint256)
81   {
82     return allowed[_owner][_spender];
83   }
84 
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_value <= balances[msg.sender]);
87     require(_to != address(0));
88 
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
102   {
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105     require(_to != address(0));
106 
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
110     emit Transfer(_from, _to, _value);
111     return true;
112   }
113 
114 }