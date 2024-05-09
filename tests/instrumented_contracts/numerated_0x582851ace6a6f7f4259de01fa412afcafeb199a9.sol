1 pragma solidity ^0.4.17;
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
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47 
48     // SafeMath.sub will throw if there is not enough balance.
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55 
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) public view returns (uint256);
64   function transferFrom(address from, address to, uint256 value) public returns (bool);
65   function approve(address spender, uint256 value) public returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[_from]);
76     require(_value <= allowed[_from][msg.sender]);
77 
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public view returns (uint256) {
93     return allowed[_owner][_spender];
94   }
95 
96 
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115 }
116 
117 contract AsToken is StandardToken {
118 
119     string public name = 'Ascoin';
120     string public symbol = 'ASC';
121     uint8 public decimals = 18;
122     uint public INITIAL_SUPPLY = 21000000000000000000000000;
123 
124     function AsToken() public {
125     totalSupply = INITIAL_SUPPLY;
126     balances[0x848be6badedee3e8b2c4ba6a573f32459c132cf3] = INITIAL_SUPPLY;
127     }
128 
129 }