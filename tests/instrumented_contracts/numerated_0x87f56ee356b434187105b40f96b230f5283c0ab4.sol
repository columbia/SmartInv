1 pragma solidity ^0.4.4;
2 
3 pragma solidity ^0.4.4;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 contract PitchToken {
55     using SafeMath for uint256;
56 
57     address public owner;
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60 
61     uint256 public totalSupply;
62     bool private saleComplete;
63 
64     string public name;
65     uint8 public decimals;
66     string public symbol;
67     string public version = "H1.0";
68 
69     function PitchToken() public {
70         name = "PITCH";
71         symbol = "PITCH";
72 
73         decimals = 9;
74         totalSupply = (1618000000 * (10**uint(decimals)));
75 
76         owner = msg.sender;
77         balances[msg.sender] = totalSupply;
78 
79         saleComplete = false;
80         Transfer(address(0), msg.sender, totalSupply);
81     }
82 
83     modifier isOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function balanceOf(address _owner) public constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         require(msg.sender == owner || saleComplete);
94         
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
101         return allowed[_owner][_spender];
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107         require(msg.sender == owner || saleComplete);
108 
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111 
112         Transfer(msg.sender, _to, _value);
113 
114         return true;
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         require(_to != address(0));
119         require(_value <= balances[_from] && _value <= allowed[_from][msg.sender]);
120 
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         balances[_from] = balances[_from].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124 
125         Transfer(_from, _to, _value);
126 
127         return true;
128     }
129 
130     function isSaleComplete() view public returns (bool complete) {
131         return saleComplete;
132     }
133 
134     function completeSale() public returns (bool complete) {
135         if (msg.sender != owner) {
136             return false;
137         }
138 
139         saleComplete = true;
140         return saleComplete;
141     }
142 
143     function () public {
144         //if ether is sent to this address, send it back.
145         revert();
146     }
147 
148     event Transfer(address indexed from, address indexed to, uint tokens);
149     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
150 }