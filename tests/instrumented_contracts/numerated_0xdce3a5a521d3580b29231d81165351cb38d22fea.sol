1 pragma solidity ^0.4.21;
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
49 contract PPGold{
50     using SafeMath for uint256;
51     
52     /* Events */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55     
56     /* Storage */
57     string public constant name = 'PPGold';
58     string public constant symbol = 'PPG';
59     uint8 public constant decimals = 18;
60     address public constant holder = 0x2A97197f759620e66B8cbC5131557031994a8A94;
61     
62     mapping(address => uint256) balances;
63     mapping (address => mapping (address => uint256)) internal allowed;
64 
65     uint256 totalSupply_ = 21*10**6*(10**uint(decimals));
66     
67     /* Getters */
68     function totalSupply() public view returns (uint256) {
69         return totalSupply_;
70     }
71     
72     function balanceOf(address _owner) public view returns (uint256 balance) {
73         return balances[_owner];
74     }
75     
76     function allowance(address _owner, address _spender) public view returns (uint256) {
77         return allowed[_owner][_spender];
78     }
79     
80     /* Methods */
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[_from]);
84         require(_value <= allowed[_from][msg.sender]);
85 
86         balances[_from] = balances[_from].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89         emit Transfer(_from, _to, _value);
90         return true;
91     }
92     
93     function approve(address _spender, uint256 _value) public returns (bool) {
94         allowed[msg.sender][_spender] = _value;
95         emit Approval(msg.sender, _spender, _value);
96         return true;
97     }
98     
99     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102         return true;
103     }
104     
105     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
106         uint oldValue = allowed[msg.sender][_spender];
107         if (_subtractedValue > oldValue) {
108             allowed[msg.sender][_spender] = 0;
109         } else {
110             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111         }
112         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113         return true;
114     }
115     
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[msg.sender]);
119 
120         // SafeMath.sub will throw if there is not enough balance.
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         emit Transfer(msg.sender, _to, _value);
124         return true;
125     }
126     
127     constructor () public {
128         balances[holder] = totalSupply_;
129     }
130   
131 }