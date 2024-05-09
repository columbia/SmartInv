1 pragma solidity ^0.5.9;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7 
8     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b <= a, "SafeMath: subtraction overflow");
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b > 0, "SafeMath: division by zero");
35         uint256 c = a / b;
36 
37         return c;
38     }
39 
40     function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 contract Mero {
47     using SafeMath for uint256;
48     string public name;
49     string public symbol;
50     uint8 public decimals;
51     uint256 public totalSupply;
52     address public owner;
53 
54     mapping (address => uint256) public balanceOf;
55     mapping (address => mapping (address => uint256)) public allowance;
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60     /**
61      * Constructor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65     constructor(
66         uint256 initialSupply,
67         string memory tokenName,
68         uint8 decimalUnits,
69         string memory tokenSymbol
70         ) public {
71             balanceOf[msg.sender] = initialSupply;
72             totalSupply = initialSupply;
73             name = tokenName;
74             symbol = tokenSymbol;
75             decimals = decimalUnits;
76             owner = msg.sender;
77         }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public {
88         require(_to != address(0), "Cannot use zero address");
89         require(_value > 0, "Cannot use zero value");
90 
91         require (balanceOf[msg.sender] >= _value, "Balance not enough");         // Check if the sender has enough
92         require (balanceOf[_to] + _value >= balanceOf[_to], "Overflow" );        // Check for overflows
93         
94         uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];          
95         
96         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
97         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);               // Add the same to the recipient
98         
99         emit Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took place
100         
101         assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens on your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         require (_value > 0, "Cannot use zero");
114         
115         allowance[msg.sender][_spender] = _value;
116         
117         emit Approval(msg.sender, _spender, _value);
118         
119         return true;
120     }
121 
122     /**
123      * Transfer tokens from other address
124      *
125      * Send `_value` tokens to `_to` on behalf of `_from`
126      *
127      * @param _from The address of the sender
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_to != address(0), "Cannot use zero address");
133         require(_value > 0, "Cannot use zero value");
134         
135         require( balanceOf[_from] >= _value, "Balance not enough" );
136         require( balanceOf[_to] + _value > balanceOf[_to], "Cannot overflow" );
137         
138         require( _value <= allowance[_from][msg.sender], "Cannot over allowance" );
139         
140         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
141         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
142         
143         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
144         
145         emit Transfer(_from, _to, _value);
146         
147         return true;
148     }
149 }