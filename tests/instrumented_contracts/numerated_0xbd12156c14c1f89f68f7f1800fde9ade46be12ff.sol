1 pragma solidity ^0.4.10;
2 
3 interface ERC20 {
4   function balanceOf(address who) external view returns (uint256);
5   function transfer(address to, uint256 value) external returns (bool);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transferFrom(address from, address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
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
42 contract ArpachainToken is ERC20 {
43   using SafeMath for uint;
44      
45     string internal _name;
46     string internal _symbol;
47     uint8 public decimals = 6;
48     uint256 internal _totalSupply;
49 
50     mapping (address => uint256) internal balances;
51     mapping (address => mapping (address => uint256)) internal allowed;
52 
53     constructor() public {
54       _symbol = "OCT";
55       _name = "OC Test";
56       _totalSupply = 10 * 1000000;
57       balances[msg.sender] = _totalSupply;
58       emit Transfer(address(0), msg.sender, _totalSupply);
59     }
60 
61     function name() public view returns (string) {
62       return _name;
63     }
64 
65     function symbol() public view returns (string) {
66       return _symbol;
67     }
68     
69     function totalSupply() public view returns (uint256) {
70       return _totalSupply;
71     }
72 
73     function _transfer(address _from, address _to, uint256 _value) internal {
74       require(_to != address(0));
75       require(_value <= balances[_from]);
76       require(_value > 0);
77       require(balances[_to] + _value > balances[_to]);
78      
79       uint256 previousBalances = balances[_from] + balances[_to];
80       balances[_from] = SafeMath.sub(balances[_from], _value);
81       balances[_to] = SafeMath.add(balances[_to], _value);
82       emit Transfer(_from, _to, _value);
83       assert(balances[_from] + balances[_to] == previousBalances);
84     }
85 
86    function transfer(address _to, uint256 _value) public returns (bool) {
87      _transfer(msg.sender, _to, _value);
88      return true;
89    }
90 
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93    }
94 
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96       require(_value <= allowed[_from][msg.sender]);
97       _transfer(_from, _to, _value);
98       allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
99       return true;
100    }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     emit Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) public view returns (uint256) {
109     return allowed[_owner][_spender];
110   }
111 
112   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
113     allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
119     uint oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
124     }
125     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129   function increaseTotalSupply(uint256 _addedValue) public returns (bool) {
130     _totalSupply = SafeMath.add(_totalSupply, _addedValue);
131     balances[msg.sender] = SafeMath.add(balances[msg.sender], _addedValue);
132     emit Transfer(address(0), msg.sender, _addedValue);
133     return true;
134   }
135 
136 }