1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33 }
34 
35 contract StandardToken {
36 
37   using SafeMath for uint256;
38 
39   uint256 public totalSupply;
40   mapping (address => uint256) balances;
41   mapping (address => mapping (address => uint256)) internal allowed;
42 
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48     require(_value <= balances[msg.sender]);
49 
50     // SafeMath.sub will throw if there is not enough balance.
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
65 
66     balances[_from] = balances[_from].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
69     Transfer(_from, _to, _value);
70     return true;
71   }
72 
73   function approve(address _spender, uint256 _value) public returns (bool) {
74     allowed[msg.sender][_spender] = _value;
75     Approval(msg.sender, _spender, _value);
76     return true;
77   }
78 
79   function allowance(address _owner, address _spender) public view returns (uint256) {
80     return allowed[_owner][_spender];
81   }
82 
83   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
84     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
85     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86     return true;
87   }
88 
89   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
90     uint oldValue = allowed[msg.sender][_spender];
91     if (_subtractedValue > oldValue) {
92       allowed[msg.sender][_spender] = 0;
93     } else {
94       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
95     }
96     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
97     return true;
98   }
99 
100 }
101 
102 contract CoinLoanToken is StandardToken {
103 
104   string public constant name = "CoinLoan";
105   string public constant symbol = "CLT";
106   uint8 public constant decimals = 8;
107   uint256 public constant INITIAL_SUPPLY = 22000000 * (10 ** uint256(decimals));
108 
109   function CoinLoanToken() public {
110     totalSupply = INITIAL_SUPPLY;
111     balances[msg.sender] = INITIAL_SUPPLY;
112   }
113 
114 }