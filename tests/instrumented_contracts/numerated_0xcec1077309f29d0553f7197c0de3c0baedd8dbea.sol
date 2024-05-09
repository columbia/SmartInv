1 pragma solidity ^0.4.21;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract DSC is IERC20 {
62 
63     // ---- DSC Specifications ----
64     // Name: DSC (Data Science Coin)
65     // Total Supply: 10 billion
66     // Initial Ownership Ratio: 100%
67     // Another(separate) CONTRACT to be created in the future for crowdsale(ICO)
68     //  
69     // DSC Phases
70     // 1. Create DSC (tokens)
71     // 2. Individually distribute tokens to existing BigPlace users & notify them
72     // 3. Private Sale
73     // 4. Crowdsale (ICO)
74     // 5. PROMOTE DATA SCIENCE !
75     // 
76     // **This is the second try. 
77     //-----------------------------
78     
79     using SafeMath for uint256;
80     
81     uint256 public constant _totalSupply = 10000000000000000000000000000;
82     
83     string public constant symbol = "DSC";
84     string public constant name = "Data Science Coin";
85     uint8 public constant decimals = 18;
86     
87     mapping(address => uint256) balances;
88     mapping(address => mapping(address => uint256)) allowed;
89     
90     function DSC() {
91         balances[msg.sender] = 10000000000000000000000000000;
92     }
93     
94     function totalSupply() constant returns (uint256 totalSupply) {
95         return _totalSupply;
96     }
97     
98     function balanceOf(address _owner) constant returns (uint256 balance) {
99         return balances[_owner];
100     }
101     
102     function transfer(address _to, uint256 _value) returns (bool success) {
103         require(
104             balances[msg.sender] >= _value
105             && _value > 0
106         );
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112     
113     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
114         require(
115             allowed[_from][msg.sender] >= _value
116             && balances[_from] >= _value
117             && _value > 0
118         );
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].sub(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125     
126     function approve(address _spender, uint256 _value) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131     
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
133         return allowed[_owner][_spender];
134     }
135     
136     event Transfer(address indexed _from, address indexed _to, uint256 _value);
137     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
138 
139 }