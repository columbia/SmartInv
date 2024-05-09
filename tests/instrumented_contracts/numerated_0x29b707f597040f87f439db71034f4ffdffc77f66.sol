1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 }
33 
34 
35 interface IERC20 {
36     function totalSupply() public view returns (uint256);
37     function balanceOf(address _owner) public view returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
40     function approve(address _spender, uint256 _value) public returns (bool);
41     function allowance(address _owner, address _spender) public view returns (uint256);
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 
47 contract Guardian is IERC20 {
48 
49     /* Public variables of the token */
50     string public standard = "Token 0.1";
51     string public constant name = "Guardian Digital Investment Services";
52     string public constant symbol = "GUARD";
53     uint8 public constant decimals = 2;
54     uint256 public initialSupply;
55     uint256 public totalSupply;
56 
57     using SafeMath for uint256;
58     /* This creates an array with all balances */
59     mapping (address => uint256) public balanceOf;
60     mapping (address => mapping (address => uint256)) public allowance;
61   
62     /* Initializes contract with initial supply tokens to the creator of the contract */
63     function Guardian() public {
64         initialSupply = 10000000000 * (10 ** uint256(decimals));
65         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
66         totalSupply = initialSupply;                        // Update total supply
67         Transfer(0x0, msg.sender, initialSupply);                           
68     }
69 
70     function totalSupply() public view returns (uint256) {
71         return totalSupply;
72     }
73 
74     function balanceOf(address _owner) public view returns (uint256) {
75         return balanceOf[_owner];
76     }
77 
78     function transfer(address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
81         balanceOf[_to] = balanceOf[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88         balanceOf[_from] = balanceOf[_from].sub(_value);
89         balanceOf[_to] = balanceOf[_to].add(_value);
90         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool) {
96         allowance[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public view returns (uint256) {
102         return allowance[_owner][_spender];
103     }
104 
105     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
106         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
107         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
108         return true;
109     }
110 
111     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
112         uint oldValue = allowance[msg.sender][_spender];
113         if (_subtractedValue > oldValue) {
114             allowance[msg.sender][_spender] = 0;
115         } else {
116             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117         }
118         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
119         return true;
120     }
121 
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124 }