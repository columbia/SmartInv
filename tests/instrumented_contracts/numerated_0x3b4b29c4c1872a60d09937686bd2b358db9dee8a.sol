1 pragma solidity ^0.4.11;
2 
3 interface ERC20 {
4 function totalSupply() constant returns (uint256 totalSupply);
5 function balanceOf(address _owner) constant returns (uint256 balance);
6 function transfer(address _to, uint256 _value) returns (bool success);
7 function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8 function approve(address _spender, uint256 _value) returns (bool success);
9 function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10 event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25     // benefit is lost if 'b' is also tested.
26     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27     if (a == 0) {
28       return 0;
29     }
30 
31     c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return a / b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 contract TeacherCoin is ERC20 {
65     
66     using SafeMath for uint256;
67     
68     uint public constant _totalSupply = 500000000000000000000000000;
69     
70     string public constant symbol = "TCH";
71     string public constant name = "Teacher Coin";
72     uint8 public constant decimals = 18;
73     
74     // 1 ether = 10000 TCH
75     uint256 public constant RATE = 10000;
76     
77     address public owner;
78     
79     
80     mapping(address => uint256) balances;
81     mapping(address => mapping(address => uint256)) allowed;
82     
83     function ( ) payable {
84         createTokens( );
85     }
86     
87     
88     function TeacherCoin( ) {
89         owner = msg.sender;
90     }
91     
92     function createTokens( ) payable {
93         require(msg.value > 0);
94         
95         uint256 tokens = msg.value.mul(RATE);
96         balances[msg.sender] = balances[msg.sender].add(tokens);
97         
98         owner.transfer(msg.value);
99     }
100     
101     function totalSupply( ) constant returns (uint256 totalSupply) {
102        return _totalSupply;
103     }
104    
105    function balanceOf(address _owner) constant returns (uint256 balance) {
106        return balances[_owner];
107    }
108    
109    function transfer(address _to, uint256 _value) returns (bool success) {
110        require(
111            balances[msg.sender] >= _value
112            && _value > 0
113         );
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         Transfer(msg.sender, _to, _value);
117         return true;
118    }
119    
120    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
121        require(
122            allowed[_from][msg.sender] >= _value
123            && balances[_from] >= _value
124            && _value > 0 
125         );
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         Transfer(_from, _to, _value);
130         return true;
131     }
132     
133     function approve(address _spender, uint256 _value) returns (bool success) {
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         return true;
137     }
138     
139     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
140         return allowed[_owner][_spender];
141         
142     }
143 event Transfer(address indexed _from, address indexed _to, uint256 _value);
144 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
145 }