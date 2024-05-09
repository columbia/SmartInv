1 pragma solidity ^0.4.24;
2 contract ERC20Basic {
3   function totalSupply() public view returns (uint256 supply);
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 contract ERC20 is ERC20Basic {
32   function allowance(address owner, address spender) public view returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool);
34   function approve(address spender, uint256 value) public returns (bool);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39   mapping(address => uint256) balances;
40   uint256 totalSupply_;
41   function totalSupply() public view returns (uint256) {
42     return totalSupply_;
43   }
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     emit Transfer(msg.sender, _to, _value);
50     return true;
51   }
52   function balanceOf(address _owner) public view returns (uint256 balance) {
53     return balances[_owner];
54   }
55 }
56 contract StandardToken is ERC20, BasicToken {
57   mapping (address => mapping (address => uint256)) internal allowed;
58   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[_from]);
61     require(_value <= allowed[_from][msg.sender]);
62 
63     balances[_from] = balances[_from].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
66     emit Transfer(_from, _to, _value);
67     return true;
68   }
69   function approve(address _spender, uint256 _value) public returns (bool) {
70     require((_value == 0) || allowed[msg.sender][_spender]== 0);
71     allowed[msg.sender][_spender] = _value;
72     emit Approval(msg.sender, _spender, _value);
73     return true;
74   }
75   function allowance(address _owner, address _spender) public view returns (uint256) {
76     return allowed[_owner][_spender];
77   }
78   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
79     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
80     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
81     return true;
82   }
83   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
84     uint oldValue = allowed[msg.sender][_spender];
85     if (_subtractedValue > oldValue) {
86       allowed[msg.sender][_spender] = 0;
87     } else {
88       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
89     }
90     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91     return true;
92   }
93 }
94 contract AEToken is StandardToken {
95     string public constant name = "AE Fraction";
96     string public constant symbol = "AE"; 
97     uint8 public constant decimals = 18; 
98     uint256 public constant INITIAL_SUPPLY = 21 * (10 ** 8) * (10 ** uint256(decimals));
99     constructor() public {
100         totalSupply_ = INITIAL_SUPPLY;
101         balances[msg.sender] = INITIAL_SUPPLY;
102         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
103     }
104 }