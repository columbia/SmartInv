1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 		if (a == 0) {
7 			return 0;
8 		}
9 		uint256 c = a * b;
10 		assert(c / a == b);
11 		return c;
12 	}
13 
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 		// assert(b > 0); // Solidity automatically throws when dividing by 0
16 		uint256 c = a / b;
17 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
18 		return c;
19 	}
20 
21 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22 		assert(b <= a);
23 		return a - b;
24 	}
25 
26 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
27 		uint256 c = a + b;
28 		assert(c >= a);
29 		return c;
30 	}
31 }
32 
33 contract OwnableToken {
34 	address public owner;
35 	address public minter;
36 	address public burner;
37 	address public controller;
38 	
39 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 	function OwnableToken() public {
42 		owner = msg.sender;
43 	}
44 
45 	modifier onlyOwner() {
46 		require(msg.sender == owner);
47 		_;
48 	}
49 	
50 	modifier onlyMinter() {
51 		require(msg.sender == minter);
52 		_;
53 	}
54 	
55 	modifier onlyBurner() {
56 		require(msg.sender == burner);
57 		_;
58 	}
59 	modifier onlyController() {
60 		require(msg.sender == controller);
61 		_;
62 	}
63   
64 	modifier onlyPayloadSize(uint256 numwords) {                                       
65 		assert(msg.data.length == numwords * 32 + 4);
66 		_;
67 	}
68 
69 	function transferOwnership(address newOwner) public onlyOwner {
70 		require(newOwner != address(0));
71 		emit OwnershipTransferred(owner, newOwner);
72 		owner = newOwner;
73 	}
74 	
75 	function setMinter(address _minterAddress) public onlyOwner {
76 		minter = _minterAddress;
77 	}
78 	
79 	function setBurner(address _burnerAddress) public onlyOwner {
80 		burner = _burnerAddress;
81 	}
82 	
83 	function setControler(address _controller) public onlyOwner {
84 		controller = _controller;
85 	}
86 }
87 
88 contract KYCControl is OwnableToken {
89 	event KYCApproved(address _user, bool isApproved);
90 	mapping(address => bool) public KYCParticipants;
91 	
92 	function isKYCApproved(address _who) view public returns (bool _isAprroved){
93 		return KYCParticipants[_who];
94 	}
95 
96 	function approveKYC(address _userAddress) onlyController public {
97 		KYCParticipants[_userAddress] = true;
98 		emit KYCApproved(_userAddress, true);
99 	}
100 }
101 
102 contract VernamCrowdSaleToken is OwnableToken, KYCControl {
103 	using SafeMath for uint256;
104 	
105     event Transfer(address indexed from, address indexed to, uint256 value);
106     
107 	/* Public variables of the token */
108 	string public name;
109 	string public symbol;
110 	uint8 public decimals;
111 	uint256 public _totalSupply;
112 	
113 	/*Private Variables*/
114 	uint256 constant POW = 10 ** 18;
115 	uint256 _circulatingSupply;
116 	
117 	/* This creates an array with all balances */
118 	mapping (address => uint256) public balances;
119 		
120 	// This notifies clients about the amount burnt
121 	event Burn(address indexed from, uint256 value);
122 	event Mint(address indexed _participant, uint256 value);
123 
124 	/* Initializes contract with initial supply tokens to the creator of the contract */
125 	function VernamCrowdSaleToken() public {
126 		name = "Vernam Crowdsale Token";                            // Set the name for display purposes
127 		symbol = "VCT";                               				// Set the symbol for display purposes
128 		decimals = 18;                            					// Amount of decimals for display purposes
129 		_totalSupply = SafeMath.mul(1000000000, POW);     			//1 Billion Tokens with 18 Decimals
130 		_circulatingSupply = 0;
131 	}
132 	
133 	function mintToken(address _participant, uint256 _mintedAmount) public onlyMinter returns (bool _success) {
134 		require(_mintedAmount > 0);
135 		require(_circulatingSupply.add(_mintedAmount) <= _totalSupply);
136 		KYCParticipants[_participant] = false;
137 
138         balances[_participant] =  balances[_participant].add(_mintedAmount);
139         _circulatingSupply = _circulatingSupply.add(_mintedAmount);
140 		
141 		emit Transfer(0, this, _mintedAmount);
142         emit Transfer(this, _participant, _mintedAmount);
143 		emit Mint(_participant, _mintedAmount);
144 		
145 		return true;
146     }
147 	
148 	function burn(address _participant, uint256 _value) public onlyBurner returns (bool _success) {
149         require(_value > 0);
150 		require(balances[_participant] >= _value);   							// Check if the sender has enough
151 		require(isKYCApproved(_participant) == true);
152 		balances[_participant] = balances[_participant].sub(_value);            // Subtract from the sender
153 		_circulatingSupply = _circulatingSupply.sub(_value);
154         _totalSupply = _totalSupply.sub(_value);                      			// Updates totalSupply
155 		emit Transfer(_participant, 0, _value);
156         emit Burn(_participant, _value);
157         
158 		return true;
159     }
160   
161 	function totalSupply() public view returns (uint256) {
162 		return _totalSupply;
163 	}
164 	
165 	function circulatingSupply() public view returns (uint256) {
166 		return _circulatingSupply;
167 	}
168 	
169 	function balanceOf(address _owner) public view returns (uint256 balance) {
170 		return balances[_owner];
171 	}
172 }