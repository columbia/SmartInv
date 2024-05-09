1 pragma solidity ^0.4.18;
2 
3 /** These Contract is created for Pre-Sale and Sale of TILX Coin,
4  * this is created for all coins required for crowdfunding
5  * this includes bonus for Pre-Sale and Sale, that are in this way:
6  * 65% Pre Sale (Huge Competitive Percent)
7  * 50% First Round
8  * 40% Second Round
9  * 20% Third Round
10  * Detailed at www.tilxcoin.com
11  * 
12  * All these coins are the necessary amount for covering Bonus needed.
13  * Exact distribution announced will be done.
14  * 
15  * SafeMath library used for security
16  * 
17  * THESE IS A COIN FOR A GREAT, EDUCATIONAL, SOCIAL AND ENTERTAINMENT PROJECT*/
18  
19 
20 /** All needed functions here in IERC20,
21  * this will be used for contract*/
22  
23 
24 interface IERC20 {
25     function totalSupply() public constant returns (uint256);
26     function balanceOf(address _owner) public constant returns (uint256 balance);
27     function transfer(address _to, uint256 _value) public returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29     function approve(address _spender, uint256 _value) public returns (bool success);
30     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   /**
67   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 
85 
86 
87 contract tilxtoken is IERC20 {
88     
89     using SafeMath for uint256;
90     
91     uint public constant _totalSupply = 52500000000000000000000000;
92     
93     string public constant symbol = "TILX";
94     string public constant name = "TILX COIN";
95     uint8 public constant decimals = 18;
96     
97     mapping(address => uint256) balances;
98     mapping(address => mapping(address => uint256)) allowed;
99     
100     
101     function tilxtoken() public {
102         balances[msg.sender] = _totalSupply;
103     }
104     
105     function totalSupply() public constant returns (uint256){
106         return _totalSupply;
107         
108     }
109     function balanceOf(address _owner) public constant returns (uint256 balance){
110         return balances[_owner];
111         
112     }
113     function transfer(address _to, uint256 _value) public returns (bool success){
114         require(
115             balances[msg.sender] >= _value
116             && _value>0 
117         );
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         Transfer(msg.sender, _to, _value);
121         return true;
122         
123     }
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
125         require(
126             allowed[_from][msg.sender] >= _value
127             && balances[_from] >= _value
128             && _value > 0 
129         );
130         balances[_from] -= balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135         
136     }
137     
138     function approve(address _spender, uint256 _value) public returns (bool success){
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142         
143     }
144     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
145          return allowed[_owner][_spender];
146         
147     }
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 }