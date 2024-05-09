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
32 }
33 
34 contract ERC20 {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 
48 contract StandardToken is ERC20 {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52   mapping (address => mapping (address => uint256)) internal allowed;
53 
54 
55   uint256 totalSupply_;
56 
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   function balanceOf(address _owner) public view returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79 
80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87   function approve(address _spender, uint256 _value) public returns (bool) {
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender) public view returns (uint256) {
94     return allowed[_owner][_spender];
95   }
96 
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104     uint oldValue = allowed[msg.sender][_spender];
105     if (_subtractedValue > oldValue) {
106       allowed[msg.sender][_spender] = 0;
107     } else {
108       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109     }
110     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 }
114 
115 contract BATToken is StandardToken {
116     uint public totalSupply = 1*10**8;
117     uint8 constant public decimals = 0;
118     string constant public name = "BAT Token";
119     string constant public symbol = "BAT";
120 
121     function BATToken() public {
122         balances[msg.sender] = totalSupply;
123     }
124 }