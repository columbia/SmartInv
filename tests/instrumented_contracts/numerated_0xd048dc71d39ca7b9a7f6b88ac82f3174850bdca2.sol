1 pragma solidity ^0.4.25;
2 // ERC20 interface
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
42 contract TokenBase is IERC20 {
43   using SafeMath for uint256;
44   address private owner;
45   string public name = 'Rivet Chain';
46   string public symbol = 'RVCX';
47   uint8 public constant decimals = 18;
48   uint256 public constant decimalFactor = 10 ** uint256(decimals);
49   uint256 public constant totalSupply = 2500000000 * decimalFactor;
50   mapping (address => uint256) balances;
51   mapping (address => mapping (address => uint256)) internal allowed;
52   event Transfer(address indexed from, address indexed to, uint256 value);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 
55   constructor() public {
56     balances[msg.sender] = totalSupply;
57     emit Transfer(address(0), msg.sender, totalSupply);
58   }
59 
60     modifier onlyOwner {
61         if (msg.sender != owner) revert();
62         _;
63     }
64    function() external payable {
65     }
66     function withdraw() onlyOwner public {
67         uint256 etherBalance = address(this).balance;
68         owner.transfer(etherBalance);
69     }
70   function balanceOf(address _owner) public view returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74   function allowance(address _owner, address _spender) public view returns (uint256) {
75     return allowed[_owner][_spender];
76   }
77 
78   function transfer(address _to, uint256 _value) public returns (bool) {
79 
80     require(_value <= balances[msg.sender]);
81     // SafeMath.sub will throw if there is not enough balance.
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     emit Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89 
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95     emit Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   function approve(address _spender, uint256 _value) public returns (bool) {
100     allowed[msg.sender][_spender] = _value;
101     emit Approval(msg.sender, _spender, _value);
102     return true;
103   }
104 
105   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
106     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
107     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108     return true; 
109   }
110 
111   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
112     uint oldValue = allowed[msg.sender][_spender];
113     if (_subtractedValue > oldValue) {
114       allowed[msg.sender][_spender] = 0;
115     } else {
116       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117     }
118     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119     return true;
120   }
121 }