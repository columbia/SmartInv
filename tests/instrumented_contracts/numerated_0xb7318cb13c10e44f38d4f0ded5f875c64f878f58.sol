1 pragma solidity ^0.4.21;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19     if (a == 0) {
20       return 0;
21     }
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     return a / b;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45   mapping(address => uint256) balances;
46   uint256 totalSupply_;
47   function totalSupply() public view returns (uint256) {
48     return totalSupply_;
49   }
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52     require(_value <= balances[msg.sender]);
53 
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     emit Transfer(msg.sender, _to, _value);
57     return true;
58   }
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65   mapping (address => mapping (address => uint256)) internal allowed;
66   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     require(_value <= balances[_from]);
69     require(_value <= allowed[_from][msg.sender]);
70 
71     balances[_from] = balances[_from].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
74     emit Transfer(_from, _to, _value);
75     return true;
76   }
77   function approve(address _spender, uint256 _value) public returns (bool) {
78     allowed[msg.sender][_spender] = _value;
79     emit Approval(msg.sender, _spender, _value);
80     return true;
81   }
82   function allowance(address _owner, address _spender) public view returns (uint256) {
83     return allowed[_owner][_spender];
84   }
85   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
86     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
87     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
88     return true;
89   }
90   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
91     uint oldValue = allowed[msg.sender][_spender];
92     if (_subtractedValue > oldValue) {
93       allowed[msg.sender][_spender] = 0;
94     } else {
95       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
96     }
97     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98     return true;
99   }
100 }
101 
102 contract StudToken is StandardToken {
103     function() public {
104         revert();
105     }
106     string public constant name = 'Stud Coin';
107     string public constant symbol = 'STUD';
108     uint8 public constant decimals = 3;
109     string public constant version = 'S1.0';
110     function StudToken(uint256 _initialAmount) public {
111         balances[msg.sender] = _initialAmount;
112         totalSupply_ = _initialAmount;
113     }
114     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
115         require(_spender != address(this));
116         super.approve(_spender, _value);
117         // solium-disable-next-line security/no-call-value
118         require(_spender.call.value(msg.value)(_data));
119         return true;
120     }
121 }