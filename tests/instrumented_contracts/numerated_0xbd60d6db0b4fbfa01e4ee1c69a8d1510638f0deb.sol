1 pragma solidity ^0.4.18;
2 
3 interface IERC20 {
4 
5 function totalSupply() public constant returns (uint256 totalSupply);
6 //Get the total token supply
7 function balanceOf(address _owner) public constant returns (uint256 balance);
8 //Get the account balance of another account with address _owner
9 function transfer(address _to, uint256 _value) public returns (bool success);
10 //Send _value amount of tokens to address _to
11 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 //Send _value amount of tokens from address _from to address _to
13 /*The transferFrom method is used for a withdraw workflow, allowing contracts to send 
14 tokens on your behalf, for example to "deposit" to a contract address and/or to charge
15 fees in sub-currencies; the command should fail unless the _from account has deliberately
16 authorized the sender of the message via some mechanism; we propose these standardized APIs for approval: */
17 function approve(address _spender, uint256 _value) public returns (bool success);
18 /* Allow _spender to withdraw from your account, multiple times, up to the _value amount. 
19 If this function is called again it overwrites the current allowance with _value. */
20 function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
21 //Returns the amount which _spender is still allowed to withdraw from _owner
22 event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 //Triggered when tokens are transferred.
24 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 //Triggered whenever approve(address _spender, uint256 _value) is called.
26 
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     if (a == 0) {
40       return 0;
41     }
42     uint256 c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   /**
58   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 contract Nickelcoin is IERC20 {
76     
77     using SafeMath for uint256;
78     
79     string public constant name = "Nickelcoin";  
80     string public constant symbol = "NKL"; 
81     uint8 public constant decimals = 8;  
82     uint public  _totalSupply = 4000000000000000; 
83     
84    
85     mapping (address => uint256) public funds; 
86     mapping(address => mapping(address => uint256)) allowed;
87     
88     event Transfer(address indexed from, address indexed to, uint256 value);  
89     
90     function Nickelcoin() public {
91     funds[0xa33c5838B8169A488344a9ba656420de1db3dc51] = _totalSupply; 
92     }
93      
94     function totalSupply() public constant returns (uint256 totalsupply) {
95         return _totalSupply;
96     }
97     
98     function balanceOf(address _owner) public constant returns (uint256 balance) {
99         return funds[_owner];  
100     }
101         
102     function transfer(address _to, uint256 _value) public returns (bool success) {
103    
104     require(funds[msg.sender] >= _value && funds[_to].add(_value) >= funds[_to]);
105 
106     
107     funds[msg.sender] = funds[msg.sender].sub(_value); 
108     funds[_to] = funds[_to].add(_value);       
109   
110     Transfer(msg.sender, _to, _value); 
111     return true;
112     }
113 	
114     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
115         require (allowed[_from][msg.sender] >= _value);   
116         require (_to != 0x0);                            
117         require (funds[_from] >= _value);               
118         require (funds[_to].add(_value) > funds[_to]); 
119         funds[_from] = funds[_from].sub(_value);   
120         funds[_to] = funds[_to].add(_value);        
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         Transfer(_from, _to, _value);                 
123         return true;                                      
124     }
125     
126     function approve(address _spender, uint256 _value) public returns (bool success) {
127          allowed[msg.sender][_spender] = _value;    
128          Approval (msg.sender, _spender, _value);   
129          return true;                               
130      }
131     
132     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
133       return allowed[_owner][_spender];   
134     } 
135     
136 
137 }