1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4  
5 
6     function totalSupply() public constant returns (uint256 totalSupply);
7     function balanceOf(address _owner) public constant returns (uint256 balance);
8     function transfer(address _owner, uint256 _value) public returns (bool success);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 
11     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
12     function transferFrom(address _owner, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 /**
61  * @title Standard ERC20 token
62  *
63 */
64 contract KeplerCoin is IERC20 {
65     
66     
67     using SafeMath for uint256;
68     
69     
70     uint256 public constant  _totalSupply = 30000000000000000000000000 ;
71     string public constant symbol = "KPL";
72     string public constant name = "Kepler Coin";
73     uint8 public constant decimals = 18;
74     
75     mapping(address => uint256) balances;
76     mapping(address => mapping(address => uint256)) allowed;
77     
78     // rate of our token
79     uint256 public RATE = 5000;
80     
81     // address of the person who created it
82     address public owner;
83     
84     bool public isActive = true;
85     
86 
87     
88     //paybale function to create transaction
89     
90     function () payable {
91         createTokens();
92     }
93 
94     function KeplerCoin(){
95     
96         owner = msg.sender;
97         balances[msg.sender] = _totalSupply;
98 
99 
100     } 
101     
102     function changeRate(uint256 _rate){
103     
104         require(msg.sender == owner);
105 
106         RATE = _rate;
107     }
108     
109     
110     function toggleActive(bool _isActive){
111         
112         require(msg.sender == owner);
113         
114         isActive = _isActive;
115 
116     }
117     
118     
119    
120  
121     
122     function createTokens() payable{
123         require(msg.value > 0
124         && isActive
125         );
126         
127         uint256 tokens = msg.value*RATE;
128         
129         require(balances[owner] >= tokens);
130 
131         balances[owner] = balances[owner].sub(tokens);
132 
133         balances[msg.sender] = balances[msg.sender].add(tokens);
134 
135         owner.transfer(msg.value);
136     }
137     
138     function totalSupply() public constant returns (uint256 totalSupply){
139         return _totalSupply;
140     }
141     
142      function balanceOf(address _owner) public constant returns (uint256 balance){
143          return balances[_owner];
144      }
145      
146     function transfer(address _owner, uint256 _value) public returns (bool success){
147         
148         require(
149             balances[msg.sender]>= _value 
150             && _value >0
151             );
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_owner] = balances[_owner].add(_value);
154         Transfer(msg.sender , _owner  , _value);
155         return true;
156     }
157     
158     event Transfer(address indexed _from, address indexed _to, uint256 _value);
159     
160     
161 
162     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
163         return allowed[_owner][_spender];
164     }
165     
166     
167     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
168         require(
169             allowed[_from][msg.sender] >= _value
170             && balances[_from] >= _value
171             && _value >0
172             );
173         
174         balances[_from] = balances[_from].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177         Transfer(_from , _to , _value);
178         return true;
179         
180     }
181     
182     function approve(address _spender, uint256 _value) public returns (bool success){
183         
184         allowed[msg.sender][_spender] = _value;
185         Approval(msg.sender , _spender , _value);
186         return true;
187         
188     }
189     
190     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
191     
192 
193  
194 
195 }