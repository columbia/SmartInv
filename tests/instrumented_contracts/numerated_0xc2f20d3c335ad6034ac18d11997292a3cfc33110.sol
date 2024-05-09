1 pragma solidity ^0.4.24;
2 
3 contract Token{
4 
5     function balanceOf(address _owner) public constant returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool);
7     function transferFrom(address _from, address _to, uint256 _value) public returns  (bool);
8     function approve(address _spender, uint256 _value) public returns (bool);
9     function allowance(address _owner, address _spender) public constant returns  (uint256);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 
13     _value);
14 }
15 
16 
17 contract StandardToken is Token {
18   using SafeMath for uint256;
19   mapping(address => uint256) balances;
20   mapping (address => mapping (address => uint256)) internal allowed;
21   
22   uint256 totalSupply;//发行总量，如210000000
23   string public name;//代币名称，例如”My test token”。
24   string public symbol;//代币简称，例如：OKNC，这个也是我们在交易所看到的名字。
25   uint8 public decimals;//返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示。
26 
27   constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
28     name = _name;
29     symbol = _symbol;
30     decimals = _decimals;
31     totalSupply = _totalSupply * 10 ** uint256(_decimals);  
32     balances[msg.sender] = totalSupply;
33   }
34 
35 
36   
37   event Transfer(address indexed from, address indexed to, uint256 value);
38   event Approval(
39     address indexed owner,
40     address indexed spender,
41     uint256 value
42   );
43 
44   function transferFrom(
45     address _from,
46     address _to,
47     uint256 _value
48   )
49     public
50     returns (bool)
51   {
52     require(_to != address(0));
53     require(_value <= balances[_from]);
54     require(_value <= allowed[_from][msg.sender]);
55 
56     balances[_from] = balances[_from].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
59     emit Transfer(_from, _to, _value);
60     return true;
61   }
62   
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     emit Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   function balanceOf(address _owner) public view returns (uint256) {
74     return balances[_owner];
75   }
76 
77 
78   function approve(address _spender, uint256 _value) public returns (bool) {
79     allowed[msg.sender][_spender] = _value;
80     emit Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84 
85   function allowance(
86     address _owner,
87     address _spender
88    )
89     public
90     view
91     returns (uint256)
92   {
93     return allowed[_owner][_spender];
94   }
95 
96 
97   function increaseApproval(
98     address _spender,
99     uint256 _addedValue
100   )
101     public
102     returns (bool)
103   {
104     allowed[msg.sender][_spender] = (
105       allowed[msg.sender][_spender].add(_addedValue));
106     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110 
111   function decreaseApproval(
112     address _spender,
113     uint256 _subtractedValue
114   )
115     public
116     returns (bool)
117   {
118     uint256 oldValue = allowed[msg.sender][_spender];
119     if (_subtractedValue > oldValue) {
120       allowed[msg.sender][_spender] = 0;
121     } else {
122       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123     }
124     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128 }
129 
130 /**
131  * @title SafeMath
132  * @dev Math operations with safety checks that throw on error
133  */
134 library SafeMath {
135 
136   /**
137   * @dev Multiplies two numbers, throws on overflow.
138   */
139   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
140     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
141     // benefit is lost if 'b' is also tested.
142     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143     if (a == 0) {
144       return 0;
145     }
146 
147     c = a * b;
148     assert(c / a == b);
149     return c;
150   }
151 
152   /**
153   * @dev Integer division of two numbers, truncating the quotient.
154   */
155   function div(uint256 a, uint256 b) internal pure returns (uint256) {
156     // assert(b > 0); // Solidity automatically throws when dividing by 0
157     // uint256 c = a / b;
158     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159     return a / b;
160   }
161 
162   /**
163   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
164   */
165   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166     assert(b <= a);
167     return a - b;
168   }
169 
170   /**
171   * @dev Adds two numbers, throws on overflow.
172   */
173   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
174     c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 }