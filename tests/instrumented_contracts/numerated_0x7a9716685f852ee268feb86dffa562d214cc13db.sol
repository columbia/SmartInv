1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public constant returns (uint256);
5 
6   function balanceOf(address _addr) public constant returns (uint256);
7 
8   function allowance(address _addr, address _spender) public constant returns (uint256);
9 
10   function transfer(address _to, uint256 _value) public returns (bool);
11 
12   function approve(address _spender, uint256 _fromValue,uint256 _toValue) public returns (bool);
13 
14   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22   
23   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24     require(_b <= _a);
25     uint256 c = _a - _b;
26 
27     return c;
28   }
29 
30   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     uint256 c = _a + _b;
32     require(c >= _a);
33     return c;
34   }
35 }
36 
37 
38 contract FBT is ERC20 {
39   using SafeMath for uint256;
40   address public owner;
41 
42   mapping (address => uint256) balances;
43   mapping (address => mapping (address => uint256)) allowed;
44 
45   string public symbol;
46   string public  name;
47   uint256 public decimals;
48   uint256 _totalSupply;
49 
50   constructor() public {
51 	owner = msg.sender;
52     symbol = "FBT";
53     name = "FANBI TOKEN";
54     decimals = 6;
55 
56     _totalSupply = 5*(10**15);
57     balances[owner] = _totalSupply;
58   }
59 
60   function totalSupply() public  constant returns (uint256) {
61     return _totalSupply;
62   }
63 
64   function balanceOf(address _addr) public  constant returns (uint256) {
65     return balances[_addr];
66   }
67 
68   function allowance(address _addr, address _spender) public  constant returns (uint256) {
69     return allowed[_addr][_spender];
70   }
71 
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_value <= balances[msg.sender]);
74     require(_to != address(0));
75 
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   function approve(address _spender, uint256 _fromValue, uint256 _toValue) public returns (bool) {
83     require(_spender != address(0));
84     require(allowed[msg.sender][_spender] ==_fromValue);
85     allowed[msg.sender][_spender] = _toValue;
86     emit Approval(msg.sender, _spender, _toValue);
87     return true;
88   }
89 
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93     require(_to != address(0));
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     emit Transfer(_from, _to, _value);
99     return true;
100   }
101 }