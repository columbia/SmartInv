1 pragma solidity ^0.4.24;
2 
3 
4 /*Token contract based on Zeppelin StandardToken contract*/
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * See https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender)
53     public view returns (uint256);
54 
55   function transferFrom(address from, address to, uint256 value)
56     public returns (bool);
57 
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(
60     address indexed owner,
61     address indexed spender,
62     uint256 value
63   );
64 }
65 contract StandardToken is ERC20 {
66   using SafeMath for uint;
67      
68     string internal _name;
69     string internal _symbol;
70     uint8 internal _decimals;
71     uint256 internal _totalSupply;
72 
73     mapping (address => uint256) internal balances;
74     mapping (address => mapping (address => uint256)) internal allowed;
75 
76     constructor() public {
77         _symbol = "ExShares";
78         _name = "EXS";
79         _decimals = 18;
80         _totalSupply = 100 * (uint256(10)**_decimals);
81         balances[msg.sender] = _totalSupply;
82     }
83 
84     function name()
85         public
86         view
87         returns (string) {
88         return _name;
89     }
90 
91     function symbol()
92         public
93         view
94         returns (string) {
95         return _symbol;
96     }
97 
98     function decimals()
99         public
100         view
101         returns (uint8) {
102         return _decimals;
103     }
104 
105     function totalSupply()
106         public
107         view
108         returns (uint256) {
109         return _totalSupply;
110     }
111 
112    function transfer(address _to, uint256 _value) public returns (bool) {
113      require(_to != address(0));
114      require(_value <= balances[msg.sender]);
115      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
116      balances[_to] = SafeMath.add(balances[_to], _value);
117      emit Transfer(msg.sender, _to, _value);
118      return true;
119    }
120 
121   function balanceOf(address _owner) public view returns (uint256 balance) {
122     return balances[_owner];
123    }
124 
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127      require(_value <= balances[_from]);
128      require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = SafeMath.sub(balances[_from], _value);
131      balances[_to] = SafeMath.add(balances[_to], _value);
132      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
133     emit Transfer(_from, _to, _value);
134      return true;
135    }
136 
137    function approve(address _spender, uint256 _value) public returns (bool) {
138      allowed[msg.sender][_spender] = _value;
139      emit Approval(msg.sender, _spender, _value);
140      return true;
141    }
142 
143   function allowance(address _owner, address _spender) public view returns (uint256) {
144      return allowed[_owner][_spender];
145    }
146 
147    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
148      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
149      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150      return true;
151    }
152 
153   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154      uint oldValue = allowed[msg.sender][_spender];
155      if (_subtractedValue > oldValue) {
156        allowed[msg.sender][_spender] = 0;
157      } else {
158        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
159     }
160      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161      return true;
162    }
163 
164 }