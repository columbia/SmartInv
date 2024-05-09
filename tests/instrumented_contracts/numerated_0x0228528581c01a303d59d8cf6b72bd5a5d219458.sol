1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     require(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
29     return c;
30   }
31 }
32 
33 
34 // Abstract contract for the full ERC 20 Token standard
35 // https://github.com/ethereum/EIPs/issues/20
36 
37 contract Token {
38     /* This is a slight change to the ERC20 base standard.
39     function totalSupply() constant returns (uint256 supply);
40     is replaced with:
41     uint256 public totalSupply;
42     This automatically creates a getter function for the totalSupply.
43     This is moved to the base contract since public getter functions are not
44     currently recognised as an implementation of the matching abstract
45     function by the compiler.
46     */
47     /// total amount of tokens
48     //uint256 public totalSupply;
49     function totalSupply()  public view returns (uint256 supply);
50 
51     /// @param _owner The address from which the balance will be retrieved
52     /// @return The balance
53     function balanceOf(address _owner)  public view returns (uint256 balance);
54 
55     /// @notice send `_value` token to `_to` from `msg.sender`
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transfer(address _to, uint256 _value)  public returns (bool success);
60 
61     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     /// @param _from The address of the sender
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
67 
68     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @param _value The amount of wei to be approved for transfer
71     /// @return Whether the approval was successful or not
72     function approve(address _spender, uint256 _value)  public returns (bool success);
73 
74     /// @param _owner The address of the account owning tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @return Amount of remaining tokens allowed to spent
77     function allowance(address _owner, address _spender)  public view returns (uint256 remaining);
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 }
82 
83 /// OKNC token, ERC20 compliant
84 contract OKNC is Token{
85     using SafeMath for uint256;
86 
87     string public name = "Ok Node Community Token"; // Set the name for display purposes
88     string public symbol = "OKNC";// Set the symbol for display purposes
89     uint8 public decimals = 4;
90     uint256 public totalSupply;
91 	address public owner;
92 
93     /* This creates an array with all balances */
94     mapping (address => uint256) public balanceOf;
95     mapping (address => mapping (address => uint256)) public allowance;
96 
97 
98     /* Initializes contract with initial supply tokens to the creator of the contract */
99     constructor() public {
100         totalSupply = 21000000000 * 10 ** uint256(decimals);                        // Update total supply
101         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens        
102     
103         owner = msg.sender;
104     }
105 
106     function totalSupply() public view returns (uint256 supply){
107         return totalSupply;
108     }
109     function balanceOf(address _owner) public view returns (uint256 balance) {
110         return balanceOf[_owner];
111     }
112 
113     /* Send coins */
114     function transfer(address _to, uint256 _value) public returns (bool){
115         require(_to != address(0));                              // Prevent transfer to 0x0 address. Use burn() instead
116 		
117         require(_value <= balanceOf[msg.sender]);           // Check if the sender has enough
118         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
119         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
120         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
121         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
122     
123         return true;
124     }
125 
126     /* Allow another contract to spend some tokens in your behalf */
127     function approve(address _spender, uint256 _value)public
128         returns (bool success) {
129 		
130         allowance[msg.sender][_spender] = _value;
131         emit Approval(msg.sender, _spender, _value);
132         return true;
133     }
134        
135 
136     /* A contract attempts to get the coins */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_to != address(0));                                // Prevent transfer to 0x0 address. Use burn() instead
139 		
140         require(_value <= balanceOf[_from]);                 // Check if the sender has enough
141         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
142         require(_value <= allowance[_from][msg.sender]);     // Check allowance
143         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
144         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
145         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
146         emit Transfer(_from, _to, _value);
147         return true;
148     }    
149     
150     function allowance(address _owner, address _spender)  public view returns (uint256 remaining) {
151         return allowance[_owner][_spender];
152     }
153 
154 
155 }