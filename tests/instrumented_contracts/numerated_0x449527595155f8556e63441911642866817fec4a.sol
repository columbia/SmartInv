1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14   
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) public constant returns (uint256);
30   function transfer(address to, uint256 value) public  returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract BasicToken is ERC20Basic {
35   using SafeMath for uint256;
36   mapping(address => uint256) balances;
37 
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     balances[msg.sender] = balances[msg.sender].sub(_value);
40     balances[_to] = balances[_to].add(_value);
41     emit Transfer(msg.sender, _to, _value);
42     return true;
43   }
44 
45   function balanceOf(address _owner) public constant returns (uint256 bal) {
46     return balances[_owner];
47   }
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract Token is ERC20, BasicToken {
58   mapping (address => mapping (address => uint256)) allowed;
59   
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61     uint256 _allowance = allowed[_from][msg.sender];
62     balances[_to] = balances[_to].add(_value);
63     balances[_from] = balances[_from].sub(_value);
64     allowed[_from][msg.sender] = _allowance.sub(_value);
65     emit Transfer(_from, _to, _value);
66     return true;
67   }
68 
69   function approve(address _spender, uint256 _value) public returns (bool) {
70     assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
71 
72     allowed[msg.sender][_spender] = _value;
73     emit Approval(msg.sender, _spender, _value);
74     return true;
75   }
76 
77   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
78     return allowed[_owner][_spender];
79   }
80 }
81 
82 contract StandardToken is Token {
83   string public constant name = "HAPY";  //代币名称
84   string public constant symbol = "Hi";       //代币符号  
85   uint256 public constant decimals = 18;        //小数点位数
86 
87   uint256 constant INITIAL_SUPPLY = 400000000 * 10**18;  //代币发行量
88 
89   function StandardToken() public {
90     totalSupply = INITIAL_SUPPLY;
91     balances[msg.sender] = INITIAL_SUPPLY;
92   }
93 }