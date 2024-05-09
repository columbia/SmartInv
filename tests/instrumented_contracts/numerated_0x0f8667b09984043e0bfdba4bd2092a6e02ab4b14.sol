1 pragma solidity ^0.4.18;
2 
3 library SafeMath
4 {
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
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract StandardToken
34 {
35   using SafeMath for uint256;
36 
37   uint256 public totalSupply;
38   mapping (address => uint256) balances;
39   mapping (address => mapping (address => uint256)) internal allowed;
40 
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47 
48     // SafeMath.sub will throw if there is not enough balance.
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     emit Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function balanceOf(address _owner) public view returns (uint256 balance) {
56     return balances[_owner];
57   }
58 
59   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[_from]);
62     require(_value <= allowed[_from][msg.sender]);
63 
64     balances[_from] = balances[_from].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
67     emit Transfer(_from, _to, _value);
68     return true;
69   }
70 
71   function approve(address _spender, uint256 _value) public returns (bool) {
72     allowed[msg.sender][_spender] = _value;
73     emit Approval(msg.sender, _spender, _value);
74     return true;
75   }
76 
77   function allowance(address _owner, address _spender) public view returns (uint256) {
78     return allowed[_owner][_spender];
79   }
80 
81   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
82     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
83     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
84     return true;
85   }
86 
87   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
88     uint oldValue = allowed[msg.sender][_spender];
89     if (_subtractedValue > oldValue) {
90       allowed[msg.sender][_spender] = 0;
91     } else {
92       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
93     }
94     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95     return true;
96   }
97 
98 }
99 
100 contract ButterToken is StandardToken
101 {
102   string public constant name = "ButterToken";
103   string public constant symbol = "BUTTER";
104   uint8 public constant decimals = 8;
105   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
106 
107   constructor() public {
108     totalSupply = INITIAL_SUPPLY;
109     balances[msg.sender] = INITIAL_SUPPLY;
110   }
111 }