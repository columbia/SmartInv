1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     /**
8      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9      * account.
10      */
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     /**
16      * @dev Throws if called by any account other than the owner.
17      */
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     /**
24      * @dev Allows the current owner to transfer control of the contract to a newOwner.
25      * @param newOwner The address to transfer ownership to.
26      */
27     function transferOwnership(address newOwner) public onlyOwner {
28         require(newOwner != address(0));
29         emit OwnershipTransferred(owner, newOwner);
30         owner = newOwner;
31     }
32 }
33 /**
34  * Math operations with safety checks
35  */
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b > 0); // Solidity automatically throws when dividing by 0
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54         return c;
55     }
56 
57     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
58         assert(b <= a);
59         return a - b;
60     }
61 
62     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         assert(c >= a);
65         return c;
66     }
67 }
68 
69 contract BigerToken is Ownable {
70    /**
71   * @dev Fix for the ERC20 short address attack.
72    */
73   modifier onlyPayloadSize(uint256 size) {
74     require(size > 0);
75     require(msg.data.length >= size + 4) ;
76     _;
77   }
78   using SafeMath for uint256;
79     
80   string public constant name = "BigerToken";
81   string public constant symbol = "BG";
82   uint256 public constant decimals = 18;
83   string public version = "1.0";
84   uint256 public  totalSupply = 100 * (10**8) * 10**decimals;   // 100*10^8 BG total
85   //address public owner;
86     /* This creates an array with all balances */
87     mapping (address => uint256) public balanceOf;
88 	mapping (address => uint256) public freezeOf;
89     mapping (address => mapping (address => uint256)) public allowance;
90 
91     /* This generates a public event on the blockchain that will notify clients */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /* This notifies clients about the amount burnt */
95     event Burn(address indexed from, uint256 value);
96 	
97 	/* This notifies clients about the amount frozen */
98     event Freeze(address indexed from, uint256 value);
99 	
100 	/* This notifies clients about the amount unfrozen */
101     event Unfreeze(address indexed from, uint256 value);
102 
103     /* Initializes contract with initial supply tokens to the creator of the contract  constructor() public */
104  function BigerToken() public {
105     balanceOf[msg.sender] = totalSupply;
106     owner = msg.sender;
107     emit Transfer(0x0, msg.sender, totalSupply);
108   }
109 
110     /* Send coins */
111     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool){
112         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
113         require(_to != address(this)); //Prevent to contract address
114 		require(0 <= _value); 
115         require(_value <= balanceOf[msg.sender]);           // Check if the sender has enough
116         require(balanceOf[_to] <= balanceOf[_to] + _value); // Check for overflows
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
118         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
119         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
120         return true;
121     }
122 
123     /* Allow another contract to spend some tokens in your behalf */
124     function approve(address _spender, uint256 _value) public returns (bool success) {
125 		require (0 <= _value ) ; 
126         allowance[msg.sender][_spender] = _value;
127         return true;
128     }
129        
130 
131     /* A contract attempts to get the coins */
132     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool success) {
133         require (_to != 0x0);             // Prevent transfer to 0x0 address. Use burn() instead
134         require(_to != address(this));        //Prevent to contract address
135 		require( 0 <= _value); 
136         require(_value <= balanceOf[_from]);                 // Check if the sender has enough
137         require( balanceOf[_to] <= balanceOf[_to] + _value) ;  // Check for overflows
138         require(_value <= allowance[_from][msg.sender]) ;     // Check allowance
139         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
140         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
141         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function burn(uint256 _value) onlyOwner public returns (bool success) {
147         require(_value <= balanceOf[msg.sender]);            // Check if the sender has enough
148 		require(0 <= _value); 
149         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
150         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
151         emit Burn(msg.sender, _value);
152         return true;
153     }
154 	
155 	function freeze(uint256 _value) onlyOwner public returns (bool success) {
156         require(_value <= balanceOf[msg.sender]);            // Check if the sender has enough
157 		require(0 <= _value); 
158         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
159         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
160         emit Freeze(msg.sender, _value);
161         return true;
162     }
163 	
164 	function unfreeze(uint256 _value) onlyOwner public returns (bool success) {
165         require( _value <= freezeOf[msg.sender]);            // Check if the sender has enough
166 		require(0 <= _value) ; 
167         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
168 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
169         emit Unfreeze(msg.sender, _value);
170         return true;
171     }
172 	
173 	// can not accept ether
174 	function() payable public {
175 	     revert();
176     }
177 }