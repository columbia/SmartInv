1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
52  */
53 interface ERC20 {
54 
55     function balanceOf(address _owner) external returns (uint256 balance);
56 
57     function transfer(address _to, uint256 _value) external returns (bool success);
58 
59     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
60 
61     function approve(address _spender, uint256 _value) external returns (bool success);
62 
63     function allowance(address _owner, address _spender) external returns (uint256 remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 
67     event Approval(address indexed _owner, address indexed _spender, uint256  _value);
68 }
69 
70 
71 contract AKAD is ERC20 {
72 
73 	using SafeMath for uint256;                                        // Use safe math library
74 
75     mapping (address => uint256) balances;                             // Balances table
76     mapping (address => mapping (address => uint256)) allowed;         // Allowance table
77 
78     uint public constant decimals = 8;                                 // Decimals count
79     uint256 public totalSupply = 5000000000 * 10 ** decimals;          // Total supply
80 	string public constant name = "AKAD";                             // Coin name
81     string public constant symbol = "AKAD";                           // Coin symbol
82 
83 	constructor() public {                                             // Constructor
84 		balances[msg.sender] = totalSupply;                            // Give the creator all initial tokens
85 	}
86 
87     function balanceOf(address _owner) constant public returns (uint256) {
88 	    return balances[_owner];                                        // Return tokens count from balance table by address
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         if (balances[msg.sender] >= _value && _value > 0) {             // Check if the sender has enough
93             balances[msg.sender] = balances[msg.sender].sub(_value);    // Safe decrease sender balance
94             balances[_to] = balances[_to].add(_value);                  // Safe increase recipient balance
95             emit Transfer(msg.sender, _to, _value);                     // Emit transfer event
96             return true;
97         } else {
98             return false;
99          }
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         if (balances[_from] >= _value &&                                // Check if the from has enough
104             allowed[_from][msg.sender] >= _value && _value > 0) {       // Check allowance table row
105 			balances[_from] = balances[_from].sub(_value);              // Safe decrease from balance
106 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // Safe decrease allowance
107 			balances[_to] = balances[_to].add(_value);                  // Safe increase recipient balance
108             emit Transfer(_from, _to, _value);                          // Emit transfer event
109             return true;
110         } else { return false; }
111     }
112 
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         allowed[msg.sender][_spender] = _value;                         // Update allowed
115         emit Approval(msg.sender, _spender, _value);                    // Emit approval event
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
120       return allowed[_owner][_spender];                                 // Check allowed
121     }
122 
123 	function () public {
124         revert();                                                       // If ether is sent to this address, send it back.
125     }
126 
127 }