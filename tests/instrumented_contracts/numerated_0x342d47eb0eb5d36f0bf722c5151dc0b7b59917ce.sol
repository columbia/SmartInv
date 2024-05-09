1 pragma solidity ^0.4.10;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 interface ERC20 {
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface ERC223 {
48     function transfer(address to, uint value, bytes data) public;
49     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
50 }
51 
52 contract ERC223ReceivingContract { 
53     function tokenFallback(address _from, uint _value, bytes _data) public;
54 }
55 
56 contract GST is ERC20, ERC223 {
57   using SafeMath for uint;
58      
59     string internal _name;
60     string internal _symbol;
61     uint8 internal _decimals;
62     uint256 internal _totalSupply;
63 
64     mapping (address => uint256) internal balances;
65     mapping (address => mapping (address => uint256)) internal allowed;
66 
67     function GST(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
68         _symbol = symbol;
69         _name = name;
70         _decimals = decimals;
71         _totalSupply = totalSupply;
72         balances[msg.sender] = totalSupply;
73     }
74 
75     function name()
76         public
77         view
78         returns (string) {
79         return _name;
80     }
81 
82     function symbol()
83         public
84         view
85         returns (string) {
86         return _symbol;
87     }
88 
89     function decimals()
90         public
91         view
92         returns (uint8) {
93         return _decimals;
94     }
95 
96     function totalSupply()
97         public
98         view
99         returns (uint256) {
100         return _totalSupply;
101     }
102 
103    function transfer(address _to, uint256 _value) public returns (bool) {
104      require(_to != address(0));
105      require(_value <= balances[msg.sender]);
106      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
107      balances[_to] = SafeMath.add(balances[_to], _value);
108      Transfer(msg.sender, _to, _value);
109      return true;
110    }
111 
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return balances[_owner];
114    }
115 
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118      require(_value <= balances[_from]);
119      require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = SafeMath.sub(balances[_from], _value);
122      balances[_to] = SafeMath.add(balances[_to], _value);
123      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
124     Transfer(_from, _to, _value);
125      return true;
126    }
127 
128    function approve(address _spender, uint256 _value) public returns (bool) {
129      allowed[msg.sender][_spender] = _value;
130      Approval(msg.sender, _spender, _value);
131      return true;
132    }
133 
134   function allowance(address _owner, address _spender) public view returns (uint256) {
135      return allowed[_owner][_spender];
136    }
137 
138    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
140      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141      return true;
142    }
143 
144   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145      uint oldValue = allowed[msg.sender][_spender];
146      if (_subtractedValue > oldValue) {
147        allowed[msg.sender][_spender] = 0;
148      } else {
149        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
150     }
151      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152      return true;
153    }
154    
155   function transfer(address _to, uint _value, bytes _data) public {
156     require(_value > 0 );
157     if(isContract(_to)) {
158         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
159         receiver.tokenFallback(msg.sender, _value, _data);
160     }
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         Transfer(msg.sender, _to, _value, _data);
164     }
165     
166   function isContract(address _addr) private returns (bool is_contract) {
167       uint length;
168       assembly {
169             //retrieve the size of the code on target address, this needs assembly
170             length := extcodesize(_addr)
171       }
172       return (length>0);
173     }
174 
175 
176 }