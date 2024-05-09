1 pragma solidity ^0.4.24;
2 
3 
4 
5 //interface ERC20
6 
7 interface ERC20 {
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   function allowance(address owner, address spender) public view returns (uint256);
11   function transferFrom(address from, address to, uint256 value) public returns (bool);
12   function approve(address spender, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 //----X-----
18 
19 
20 //interface ERC223
21 
22 interface ERC223 {
23     function transfer(address to, uint value, bytes data) public;
24     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
25 }
26 
27 //----X-----
28 
29 
30 // contract Recieving ether
31 
32 contract ERC223ReceivingContract { 
33     function tokenFallback(address _from, uint _value, bytes _data) public;
34 }
35 
36 //----X-----
37 
38 
39 
40 // SafeMath library
41 
42 library SafeMath {
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a / b;
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 //----X-----
70 
71 contract Ownable {
72   address public owner;
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 
94 // standard token contract 
95 contract StandardToken is ERC20, ERC223, Ownable {
96   using SafeMath for uint;
97      
98     string internal _name;
99     string internal _symbol;
100     uint8 internal _decimals;
101     uint256 internal _totalSupply;
102 
103     mapping (address => uint256) internal balances;
104     mapping (address => mapping (address => uint256)) internal allowed;
105 
106     function StandardToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
107         _symbol = symbol;
108         _name = name;
109         _decimals = decimals;
110         _totalSupply = totalSupply;
111         balances[msg.sender] = totalSupply;
112     }
113 
114     function name()
115         public
116         view
117         returns (string) {
118         return _name;
119     }
120 
121     function symbol()
122         public
123         view
124         returns (string) {
125         return _symbol;
126     }
127 
128     function decimals()
129         public
130         view
131         returns (uint8) {
132         return _decimals;
133     }
134 
135     function totalSupply()
136         public
137         view
138         returns (uint256) {
139         return _totalSupply;
140     }
141 
142    function transfer(address _to, uint256 _value) public returns (bool) {
143      require(_to != address(0));
144      require(_value <= balances[msg.sender]);
145      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
146      balances[_to] = SafeMath.add(balances[_to], _value);
147      Transfer(msg.sender, _to, _value);
148      return true;
149    }
150 
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153    }
154 
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157      require(_value <= balances[_from]);
158      require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = SafeMath.sub(balances[_from], _value);
161      balances[_to] = SafeMath.add(balances[_to], _value);
162      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
163     Transfer(_from, _to, _value);
164      return true;
165    }
166 
167    function approve(address _spender, uint256 _value) public returns (bool) {
168      allowed[msg.sender][_spender] = _value;
169      Approval(msg.sender, _spender, _value);
170      return true;
171    }
172 
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174      return allowed[_owner][_spender];
175    }
176 
177    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
178      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
179      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180      return true;
181    }
182 
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184      uint oldValue = allowed[msg.sender][_spender];
185      if (_subtractedValue > oldValue) {
186        allowed[msg.sender][_spender] = 0;
187      } else {
188        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
189     }
190      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191      return true;
192    }
193    
194   function transfer(address _to, uint _value, bytes _data) public {
195     require(_value > 0 );
196     if(isContract(_to)) {
197         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
198         receiver.tokenFallback(msg.sender, _value, _data);
199     }
200         balances[msg.sender] = balances[msg.sender].sub(_value);
201         balances[_to] = balances[_to].add(_value);
202         Transfer(msg.sender, _to, _value, _data);
203     }
204     
205   function isContract(address _addr) private returns (bool is_contract) {
206       uint length;
207       assembly {
208             length := extcodesize(_addr)
209       }
210       return (length>0);
211     }
212 
213 
214 }