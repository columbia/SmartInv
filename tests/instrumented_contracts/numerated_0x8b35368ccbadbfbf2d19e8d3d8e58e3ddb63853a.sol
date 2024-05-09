1 pragma solidity 0.4.24;
2 
3 interface IERC20 {
4   function balanceOf(address _owner) external view returns (uint256);
5   function allowance(address _owner, address _spender) external view returns (uint256);
6   function transfer(address _to, uint256 _value) external returns (bool);
7   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
8   function approve(address _spender, uint256 _value) external returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract CGCXToken is IERC20 {
43   using SafeMath for uint256;
44 
45   string public name = "CGCX Exchange Token";
46   string public symbol = "CGCX";
47   uint8 public constant decimals = 18;
48   uint256 public constant decimalFactor = 10 ** uint256(decimals);
49   uint256 public constant totalSupply = 2000000000 * decimalFactor;
50   mapping (address => uint256) private balances;
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53   event Transfer(address indexed from, address indexed to, uint256 value);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56   constructor() public {
57     balances[msg.sender] = totalSupply;
58     emit Transfer(address(0), msg.sender, totalSupply);
59   }
60 
61   function balanceOf(address _owner) public view returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65   function allowance(address _owner, address _spender) public view returns (uint256) {
66     return allowed[_owner][_spender];
67   }
68 
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[msg.sender]);
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     emit Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool) {
93     allowed[msg.sender][_spender] = _value;
94     emit Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue >= oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115 }