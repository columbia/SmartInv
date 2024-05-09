1 pragma solidity 0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract customToken{
50     using SafeMath for uint256;
51 
52     /* Events */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56     /* Storage */
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60 
61     mapping(address => uint256) balances;
62     mapping (address => mapping (address => uint256)) internal allowed;
63 
64     uint256 totalSupply_;
65 
66     /* Getters */
67     function totalSupply() public view returns (uint256) {
68         return totalSupply_;
69     }
70 
71     function balanceOf(address _owner) public view returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function allowance(address _owner, address _spender) public view returns (uint256) {
76         return allowed[_owner][_spender];
77     }
78 
79     /* Methods */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     emit Transfer(_from, _to, _value);
89     return true;
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101         return true;
102     }
103 
104     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105         uint oldValue = allowed[msg.sender][_spender];
106         if (_subtractedValue > oldValue) {
107             allowed[msg.sender][_spender] = 0;
108         } else {
109             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110         }
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113   }
114 
115     function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124     }
125 
126     constructor (string _name, string _symbol, uint8 _decimals, uint _totalSupply, address _beneficiary) public {
127     require(_beneficiary != address(0));
128     name = _name;
129     symbol = _symbol;
130     decimals = _decimals;
131     totalSupply_ = _totalSupply * 10 ** uint(_decimals);
132     balances[_beneficiary] = totalSupply_;
133   }
134 
135 }