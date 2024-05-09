1 pragma solidity ^0.5.9;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7 function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13 
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
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0, "SafeMath: division by zero");
36         uint256 c = a / b;
37 
38         return c;
39     }
40 
41     function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b != 0, "SafeMath: modulo by zero");
43         return a % b;
44     }
45 }
46 
47 contract FitToken {
48     using SafeMath for uint256;
49     string public name;
50     string public symbol;
51     uint8 public decimals;
52     uint256 public totalSupply;
53 	address public owner;
54 
55     /* This creates an array with all balances */
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     /* This generates a public event on the blockchain that will notify clients */
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     /* This notifies clients about the amount burnt */
63     event Burn(address indexed from, uint256 value);
64 
65     /* Initializes contract with initial supply tokens to the creator of the contract */
66     constructor(
67         uint256 initialSupply,
68         string memory tokenName,
69         uint8 decimalUnits,
70         string memory tokenSymbol
71         ) public {
72         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
73         totalSupply = initialSupply;                        // Update total supply
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76         decimals = decimalUnits;                            // Amount of decimals for display purposes
77 		owner = msg.sender;
78     }
79 
80     /* Send coins */
81     function transfer(address _to, uint256 _value) public {
82         require(_to != address(0), "Cannot use zero address");
83         require(_value > 0, "Cannot use zero value");
84 
85         require (balanceOf[msg.sender] >= _value, "Balance not enough");         // Check if the sender has enough
86         require (balanceOf[_to] + _value >= balanceOf[_to], "Overflow" );        // Check for overflows
87         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
88         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);               // Add the same to the recipient
89         emit Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took place
90     }
91 
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94 		require (_value > 0, "Cannot use zero");
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_to != address(0), "Cannot use zero address");
101 		require(_value > 0, "Cannot use zero value");
102 		require( balanceOf[_from] >= _value, "Balance not enough" );
103         require( balanceOf[_to] + _value > balanceOf[_to], "Cannot overflows" );
104         require( _value <= allowance[_from][msg.sender], "Cannot over allowance" );
105         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
106         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
107         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
108         emit Transfer(_from, _to, _value);
109         return true;
110     }
111 
112 }