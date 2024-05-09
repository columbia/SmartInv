1 pragma solidity ^0.4.20;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34   mapping(address => uint256) balances;
35   function transfer(address _to, uint256 _value) public returns (bool) {
36     require(_value > 0);
37     require(_to != address(0));
38     require(_value <= balances[msg.sender]);
39     balances[msg.sender] = balances[msg.sender].sub(_value);
40     balances[_to] = balances[_to].add(_value);
41     Transfer(msg.sender, _to, _value);
42     return true;
43   }
44   function balanceOf(address _owner) public view returns (uint256 balance) {
45     return balances[_owner];
46   }
47 }
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) public view returns (uint256);
50   function transferFrom(address from, address to, uint256 value) public returns (bool);
51   function approve(address spender, uint256 value) public returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 contract StandardToken is ERC20, BasicToken {
55   mapping (address => mapping (address => uint256)) internal allowed;
56   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
57     require(_value > 0);
58     require(_to != address(0));
59     require(_value <= balances[_from]);
60     require(_value <= allowed[_from][msg.sender]);
61     balances[_from] = balances[_from].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
64     Transfer(_from, _to, _value);
65     return true;
66   }
67   function approve(address _spender, uint256 _value) public returns (bool) {
68     require(_value > 0);
69     allowed[msg.sender][_spender] = _value;
70     Approval(msg.sender, _spender, _value);
71     return true;
72   }
73   function allowance(address _owner, address _spender) public view returns (uint256) {
74     return allowed[_owner][_spender];
75   }
76   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
77     require(_addedValue > 0);
78     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
79     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
80     return true;
81   }
82   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
83     require(_subtractedValue > 0);
84     uint oldValue = allowed[msg.sender][_spender];
85     if (_subtractedValue > oldValue) {
86       allowed[msg.sender][_spender] = 0;
87     } else {
88       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
89     }
90     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91     return true;
92   }
93 }
94 contract BurnableToken is BasicToken {
95   event Burn(address indexed burner, uint256 value);
96   function burn(uint256 _value) public {
97     require(_value > 0);
98     require(_value <= balances[msg.sender]);
99     address burner = msg.sender;
100     balances[burner] = balances[burner].sub(_value);
101     totalSupply = totalSupply.sub(_value);
102     Burn(burner, _value);
103   }
104 }
105 contract PXGToken is StandardToken, BurnableToken {
106   string public constant name = "PlayGame"; 
107   string public constant symbol = "PXG"; 
108   uint8 public constant decimals = 18; 
109   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
110   function PXGToken() public {
111     totalSupply = INITIAL_SUPPLY;
112     balances[msg.sender] = INITIAL_SUPPLY;
113     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
114   }
115 }