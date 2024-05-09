1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract mAlek {
50 
51     using SafeMath for uint256;
52 
53     uint public _totalSupply = 0;
54 
55     string public constant symbol = "mAlek";
56     string public constant name = "mAlek Token";
57     uint8 public constant decimals = 18;
58     uint256 public bonus = 50;
59     uint256 public price = 1000;
60     uint256 public rate;
61 
62     address public owner;
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66 
67     function () payable {
68         createTokens();
69     }
70 
71     function mAlek () {
72         owner = msg.sender;
73     }
74 
75     function setBonus (uint256 newBonus) public {
76         require (owner == msg.sender);
77         bonus = newBonus;
78     }
79 
80     function setPrice (uint256 newPrice) public {
81         require (owner == msg.sender);
82         price = newPrice;
83     }
84 
85     function createTokens() payable {
86         require (msg.value > 0);
87         rate = ((bonus.add(100)).mul(price));
88         uint256 tokens = (msg.value.mul(rate)).div(100);
89         balances[msg.sender] = balances[msg.sender].add(tokens);
90         _totalSupply = _totalSupply.add(tokens);
91         owner.transfer(msg.value);
92     }
93 
94     function mintTokens(address _to, uint256 _value) {
95         require (owner == msg.sender);        
96         balances[_to] = balances[_to].add(_value*10**18);
97         _totalSupply = _totalSupply.add(_value*10**18);
98         Transfer(0x0, this, _value*10**18);
99         Transfer(this, _to, _value*10**18);
100     }
101 
102     function totalSupply () constant returns (uint256 totalSupply) {
103         return _totalSupply;
104     }
105 
106     function balanceOf (address _owner) constant returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     function transfer (address _to, uint256 _value) returns (bool success) {
111         require (balances[msg.sender] >= _value && _value > 0);
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         Transfer(msg.sender, _to, _value);
115         return true;        
116     }
117 
118     function transferFrom (address _from, address _to, uint256 _value) returns (bool success) {
119         require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     function approve (address _spender, uint256 _value) returns (bool success) {
128         allowed [msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance (address _owner, address _spender) constant returns (uint256 remaining) {
134         return allowed[_owner][_spender];
135     }
136 
137     event Transfer (address indexed _from, address indexed _to, uint256 _value);
138     event Approval (address indexed _owner, address indexed _spender, uint256 _value);
139 }