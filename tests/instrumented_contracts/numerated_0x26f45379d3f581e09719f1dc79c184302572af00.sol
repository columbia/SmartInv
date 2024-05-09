1 //Copyright Global Invest Place Ltd.
2 pragma solidity ^0.4.13;
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 
29 interface GlobalToken {
30     function balanceOf(address _owner) constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) returns (bool success);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 contract Owned {
37     address public owner;
38     
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     function Owned() {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner) ;
47         _;
48     }
49 	
50 	modifier onlyPayloadSize(uint numwords) {
51         assert(msg.data.length == numwords * 32 + 4);
52 		_;
53 	}
54 
55     function transferOwnership(address newOwner) onlyOwner {
56         owner = newOwner;
57         OwnershipTransferred(owner, newOwner);
58     }
59   
60   function contractVersion() constant returns(uint256) {
61         /*  contractVersion identifies as 100YYYYMMDDHHMM */
62         return 100201712010000;
63     }
64 }
65 
66 // GlobalToken Interface
67 contract GlobalCryptoFund is Owned, GlobalToken {
68     
69     using SafeMath for uint256;
70     
71     /* Public variables of the token */
72     string public name;
73     string public symbol;
74     uint8 public decimals;
75     uint256 public totalSupply;
76 	
77 	address public minter;
78     
79     /* This creates an array with all balances */
80     mapping (address => uint256) public balanceOf;
81     
82 	modifier onlyMinter {
83 		require(msg.sender == minter);
84 		_;
85 	}
86 	
87 	function setMinter(address _addressMinter) onlyOwner {
88 		minter = _addressMinter;
89 	}
90     
91     /* Initializes contract with initial supply tokens to the creator of the contract */
92     function GlobalCryptoFund() {
93 		name = "GlobalCryptoFund";                    								// Set the name for display purposes
94         symbol = "GCF";                												// Set the symbol for display purposes
95         decimals = 18;                          									// Amount of decimals for display purposes
96         totalSupply = 0;                									// Update total supply
97         balanceOf[msg.sender] = totalSupply;       									// Give the creator all initial tokens
98     }
99     
100     function balanceOf(address _owner) constant returns (uint256 balance){
101         return balanceOf[_owner];
102     }
103     
104     /* Internal transfer, only can be called by this contract */
105     function _transfer(address _from, address _to, uint256 _value) internal {
106         require (_to != 0x0);                               						// Prevent transfer to 0x0 address. Use burn() instead
107         require (balanceOf[_from] >= _value);                						// Check if the sender has enough
108         require (balanceOf[_to].add(_value) >= balanceOf[_to]); 						// Check for overflows
109         require(_to != address(this));
110         balanceOf[_from] = balanceOf[_from].sub(_value);                         	// Subtract from the sender
111         balanceOf[_to] = balanceOf[_to].add(_value);                           		// Add the same to the recipient
112         Transfer(_from, _to, _value);
113     }
114     
115     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool) {
116         _transfer(msg.sender, _to, _value);
117         return true;
118     }
119     
120 	event Mint(address indexed from, uint256 value);
121     function mintToken(address target, uint256 mintedAmount) onlyMinter {
122         balanceOf[target] = balanceOf[target].add(mintedAmount);
123         totalSupply = totalSupply.add(mintedAmount);
124         Transfer(0, this, mintedAmount);
125         Transfer(this, target, mintedAmount);
126         Mint(target, mintedAmount);
127     }
128     
129 	event Burn(address indexed from, uint256 value);
130     function burn(uint256 _value) onlyMinter returns (bool success) {
131         require (balanceOf[msg.sender] >= _value);            					// Check if the sender has enough
132         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);              // Subtract from the sender
133         totalSupply = totalSupply.sub(_value);                                	// Updates totalSupply
134         Burn(msg.sender, _value);
135         return true;
136     }  
137 	
138 	function kill() onlyOwner {
139         selfdestruct(owner);
140     }
141     
142     function contractVersion() constant returns(uint256) {
143         /*  contractVersion identifies as 200YYYYMMDDHHMM */
144         return 200201712010000;
145     }
146 }