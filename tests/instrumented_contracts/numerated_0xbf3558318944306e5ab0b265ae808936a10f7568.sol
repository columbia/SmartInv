1 pragma solidity ^0.4.18;
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
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Intercoin {
31   using SafeMath for uint256;
32   string public constant name = "Intercoin";
33   string public constant symbol = "INT";
34   uint8 public constant decimals = 8;
35   uint256 public constant totalSupply = 21000000 * (10 ** uint256(decimals));
36   mapping(address => uint256) balances;
37   mapping (address => mapping (address => uint256)) internal allowed;
38 
39   function Intercoin() public {
40     balances[msg.sender] = totalSupply;
41   }
42   function() public payable {
43     revert();
44   }
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) public view returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[_from]);
64     require(_value <= allowed[_from][msg.sender]);
65     balances[_from] = balances[_from].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
68     Transfer(_from, _to, _value);
69     return true;
70   }
71 
72   function approve(address _spender, uint256 _value) public returns (bool) {
73     allowed[msg.sender][_spender] = _value;
74     Approval(msg.sender, _spender, _value);
75     return true;
76   }
77 
78   function allowance(address _owner, address _spender) public view returns (uint256) {
79     return allowed[_owner][_spender];
80   }
81 
82   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
83     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
84     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
85     return true;
86   }
87 
88   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
89     uint oldValue = allowed[msg.sender][_spender];
90     if (_subtractedValue > oldValue) {
91       allowed[msg.sender][_spender] = 0;
92     } else {
93       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
94     }
95     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96     return true;
97   }
98 }