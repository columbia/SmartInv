1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() public {
7     owner = msg.sender;
8   }
9 }
10 
11 /* ~~~~~~~~~ SAFEMATH ~~~~~~~~~ */
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 /* ~~~~~~~~~~~~~~~~~~~~~~ */
38 
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54     require(_value >= 0);
55 
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(address _owner) public constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 }
66 
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public constant returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) internal allowed;
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value >= 0);
84     require(_value <= allowed[_from][msg.sender]);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   function approve(address _spender, uint256 _value) public returns (bool) {
94     require(_spender != address(0));
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
101     require(_owner != address(0));
102     require(_spender != address(0));
103     return allowed[_owner][_spender];
104   }
105 
106   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
107     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
108     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
113     uint oldValue = allowed[msg.sender][_spender];
114     if (_subtractedValue > oldValue) {
115       allowed[msg.sender][_spender] = 0;
116     } else {
117       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
118     }
119     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 }
123 
124 contract AIGaming is StandardToken, Ownable {
125   string public constant name = "AI Gaming Coin";
126   uint public constant decimals = 18;
127   string public constant symbol = "AIGC";
128 
129   function AIGaming() public {
130     totalSupply=100000000 *(10**decimals);
131     owner = msg.sender;
132     balances[msg.sender] = 100000000 * (10**decimals);
133   }
134 
135   function() public {
136      revert();
137   }
138 }