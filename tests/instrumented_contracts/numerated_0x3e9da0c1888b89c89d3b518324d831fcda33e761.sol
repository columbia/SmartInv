1 pragma solidity ^0.4.10;
2 
3 pragma solidity ^0.4.10;
4 library SafeMath {
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
33 pragma solidity ^0.4.10;
34 interface ERC20 {
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 pragma solidity ^0.4.10;
45 interface ERC223 {
46     function transfer(address to, uint value, bytes data) public;
47     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
48 }
49 
50 pragma solidity ^0.4.10;
51 contract ERC223ReceivingContract { 
52     function tokenFallback(address _from, uint _value, bytes _data) public;
53 }
54 
55 contract STLHToken is ERC20, ERC223 {
56   using SafeMath for uint;
57      
58     string internal _name;
59     string internal _symbol;
60     uint8 internal _decimals;
61     uint256 internal _totalSupply;
62 
63     mapping (address => uint256) internal balances;
64     mapping (address => mapping (address => uint256)) internal allowed;
65 
66     function STLHToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
67         _symbol = symbol;
68         _name = name;
69         _decimals = decimals;
70         _totalSupply = totalSupply;
71         balances[msg.sender] = totalSupply;
72     }
73 
74     function name()
75         public
76         view
77         returns (string) {
78         return _name;
79     }
80 
81     function symbol()
82         public
83         view
84         returns (string) {
85         return _symbol;
86     }
87 
88     function decimals()
89         public
90         view
91         returns (uint8) {
92         return _decimals;
93     }
94 
95     function totalSupply()
96         public
97         view
98         returns (uint256) {
99         return _totalSupply;
100     }
101 
102    function transfer(address _to, uint256 _value) public returns (bool) {
103      require(_to != address(0));
104      require(_value <= balances[msg.sender]);
105      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
106      balances[_to] = SafeMath.add(balances[_to], _value);
107      Transfer(msg.sender, _to, _value);
108      return true;
109    }
110 
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113    }
114 
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117      require(_value <= balances[_from]);
118      require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = SafeMath.sub(balances[_from], _value);
121      balances[_to] = SafeMath.add(balances[_to], _value);
122      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
123     Transfer(_from, _to, _value);
124      return true;
125    }
126 
127    function approve(address _spender, uint256 _value) public returns (bool) {
128      allowed[msg.sender][_spender] = _value;
129      Approval(msg.sender, _spender, _value);
130      return true;
131    }
132 
133   function allowance(address _owner, address _spender) public view returns (uint256) {
134      return allowed[_owner][_spender];
135    }
136 
137    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
139      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140      return true;
141    }
142 
143   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144      uint oldValue = allowed[msg.sender][_spender];
145      if (_subtractedValue > oldValue) {
146        allowed[msg.sender][_spender] = 0;
147      } else {
148        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
149     }
150      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151      return true;
152    }
153    
154   function transfer(address _to, uint _value, bytes _data) public {
155     require(_value > 0 );
156     if(isContract(_to)) {
157         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
158         receiver.tokenFallback(msg.sender, _value, _data);
159     }
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         Transfer(msg.sender, _to, _value, _data);
163     }
164     
165   function isContract(address _addr) private returns (bool is_contract) {
166       uint length;
167       assembly {
168             //retrieve the size of the code on target address, this needs assembly
169             length := extcodesize(_addr)
170       }
171       return (length>0);
172     }
173 }