1 pragma solidity ^0.4.26;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52     require(_value <= balances[msg.sender]);
53 
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   function balanceOf(address _owner) public view returns (uint256 balance) {
61     return balances[_owner];
62   }
63 }
64 
65 contract StandardToken is ERC20, BasicToken {
66 
67   mapping (address => mapping (address => uint256)) internal allowed;
68 
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[_from]);
72     require(_value <= allowed[_from][msg.sender]);
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function allowance(address _owner, address _spender) public view returns (uint256) {
88     return allowed[_owner][_spender];
89   }
90 
91   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
98     uint oldValue = allowed[msg.sender][_spender];
99     if (_subtractedValue > oldValue) {
100       allowed[msg.sender][_spender] = 0;
101     } else {
102       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
103     }
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108 }
109 
110 contract MyToken is StandardToken {
111   string public constant name = "N77 TOKEN";
112   string public constant symbol = "N77";
113   uint8 public constant decimals = 18;
114 
115   uint256 public constant INITIAL_SUPPLY = 700000000 * (10 ** uint256(decimals));
116 
117   function MyToken() public {
118     totalSupply = INITIAL_SUPPLY;
119     balances[msg.sender] = INITIAL_SUPPLY;
120     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
121   }
122 
123 }