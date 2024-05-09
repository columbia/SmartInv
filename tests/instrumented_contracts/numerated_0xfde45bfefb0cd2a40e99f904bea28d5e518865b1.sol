1 pragma solidity ^0.4.20;
2 library SafeMath {
3 
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		// assert(b > 0); // Solidity automatically throws when dividing by 0
15 		uint256 c = a / b;
16 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
17 		return c;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 		assert(b <= a);
22 		return a - b;
23 	}
24 
25 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a + b;
27 		assert(c >= a);
28 		return c;
29 	}
30 }
31 
32 contract OwnableToken {
33 	address public owner;
34 	address public minter;
35 	address public burner;
36 	address public controller;
37 	
38 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 	function OwnableToken() public {
41 		owner = msg.sender;
42 	}
43 
44 	modifier onlyOwner() {
45 		require(msg.sender == owner);
46 		_;
47 	}
48 	
49 	modifier onlyMinter() {
50 		require(msg.sender == minter);
51 		_;
52 	}
53 	
54 	modifier onlyBurner() {
55 		require(msg.sender == burner);
56 		_;
57 	}
58 	modifier onlyController() {
59 		require(msg.sender == controller);
60 		_;
61 	}
62   
63 	modifier onlyPayloadSize(uint256 numwords) {                                       
64 		assert(msg.data.length == numwords * 32 + 4);
65 		_;
66 	}
67 
68 	function transferOwnership(address newOwner) public onlyOwner {
69 		require(newOwner != address(0));
70 		emit OwnershipTransferred(owner, newOwner);
71 		owner = newOwner;
72 	}
73 	
74 	function setMinter(address _minterAddress) public onlyOwner {
75 		minter = _minterAddress;
76 	}
77 	
78 	function setBurner(address _burnerAddress) public onlyOwner {
79 		burner = _burnerAddress;
80 	}
81 	
82 	function setControler(address _controller) public onlyOwner {
83 		controller = _controller;
84 	}
85 }
86 
87 contract KYCControl is OwnableToken {
88 	event KYCApproved(address _user, bool isApproved);
89 	mapping(address => bool) public KYCParticipants;
90 	
91 	function isKYCApproved(address _who) view public returns (bool _isAprroved){
92 		return KYCParticipants[_who];
93 	}
94 
95 	function approveKYC(address _userAddress) onlyController public {
96 		KYCParticipants[_userAddress] = true;
97 		emit KYCApproved(_userAddress, true);
98 	}
99 }
100 
101 contract VernamCrowdSaleToken is OwnableToken, KYCControl {
102 	using SafeMath for uint256;
103 	
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     
106 	/* Public variables of the token */
107 	string public name;
108 	string public symbol;
109 	uint8 public decimals;
110 	uint256 public _totalSupply;
111 	
112 	/*Private Variables*/
113 	uint256 constant POW = 10 ** 18;
114 	uint256 _circulatingSupply;
115 	
116 	/* This creates an array with all balances */
117 	mapping (address => uint256) public balances;
118 		
119 	// This notifies clients about the amount burnt
120 	event Burn(address indexed from, uint256 value);
121 	event Mint(address indexed _participant, uint256 value);
122 
123 	/* Initializes contract with initial supply tokens to the creator of the contract */
124 	function VernamCrowdSaleToken() public {
125 		name = "Vernam Crowdsale Token";                            // Set the name for display purposes
126 		symbol = "VCT";                               				// Set the symbol for display purposes
127 		decimals = 18;                            					// Amount of decimals for display purposes
128 		_totalSupply = SafeMath.mul(1000000000, POW);     			//1 Billion Tokens with 18 Decimals
129 		_circulatingSupply = 0;
130 	}
131 	
132 	function mintToken(address _participant, uint256 _mintedAmount) public onlyMinter returns (bool _success) {
133 		require(_mintedAmount > 0);
134 		require(_circulatingSupply.add(_mintedAmount) <= _totalSupply);
135 		KYCParticipants[_participant] = false;
136 
137         balances[_participant] =  balances[_participant].add(_mintedAmount);
138         _circulatingSupply = _circulatingSupply.add(_mintedAmount);
139 		
140 		emit Transfer(0, this, _mintedAmount);
141         emit Transfer(this, _participant, _mintedAmount);
142 		emit Mint(_participant, _mintedAmount);
143 		
144 		return true;
145     }
146 	
147 	function burn(address _participant, uint256 _value) public onlyBurner returns (bool _success) {
148         require(_value > 0);
149 		require(balances[_participant] >= _value);   							// Check if the sender has enough
150 		require(isKYCApproved(_participant) == true);
151 		balances[_participant] = balances[_participant].sub(_value);            // Subtract from the sender
152 		_circulatingSupply = _circulatingSupply.sub(_value);
153         _totalSupply = _totalSupply.sub(_value);                      			// Updates totalSupply
154 		emit Transfer(_participant, 0, _value);
155         emit Burn(_participant, _value);
156         
157 		return true;
158     }
159   
160 	function totalSupply() public view returns (uint256) {
161 		return _totalSupply;
162 	}
163 	
164 	function circulatingSupply() public view returns (uint256) {
165 		return _circulatingSupply;
166 	}
167 	
168 	function balanceOf(address _owner) public view returns (uint256 balance) {
169 		return balances[_owner];
170 	}
171 }
172 
173 contract VernamPrivatePreSale is OwnableToken, KYCControl {
174 	using SafeMath for uint256;
175 
176 	VernamCrowdSaleToken public vernamCrowdsaleToken;
177 	
178 	mapping(address => uint256) public privatePreSaleTokenBalances;
179 	mapping(address => uint256) public weiBalances;
180 	
181 	uint256 constant public minimumContributionWeiByOneInvestor = 25000000000000000000 wei;
182 	uint256 public privatePreSalePrice = 100000000000000 wei;
183 	uint256 public totalSupplyInWei = 5000000000000000000000 wei;
184 	uint256 public totalTokensForSold = 50000000000000000000000000; 
185 	uint256 public privatePreSaleSoldTokens;
186 	uint256 public totalInvested;
187 	
188 	address public beneficiary;
189 	
190 	function VernamPrivatePreSale() public {
191 		beneficiary = 0xd977af9f1cf2cf615ab7d61c84aabb315b9a0337;
192 		vernamCrowdsaleToken = VernamCrowdSaleToken(0x6d908a2ef63aeac21cb2b5c3d32a145f14144b38);
193 	}
194 	
195 	function() public payable {
196 		buyPreSale(msg.sender, msg.value);
197 	}
198 	
199 	function buyPreSale(address _participant, uint256 _value) payable public {
200 		require(_value >= minimumContributionWeiByOneInvestor);
201 		require(totalSupplyInWei >= totalInvested.add(_value));
202 		
203 		beneficiary.transfer(_value);
204 		
205 		weiBalances[_participant] = weiBalances[_participant].add(_value);
206 		
207 		totalInvested = totalInvested.add(_value);
208 		
209 		uint256 tokens = ((_value).mul(1 ether)).div(privatePreSalePrice);
210 		
211 		privatePreSaleSoldTokens = privatePreSaleSoldTokens.add(tokens);
212 		privatePreSaleTokenBalances[_participant] = privatePreSaleTokenBalances[_participant].add(tokens);
213 		
214 		vernamCrowdsaleToken.mintToken(_participant, tokens);
215 	}
216 	
217 	function getPrivatePreSaleTokenBalance(address _participant) public view returns(uint256) {
218 		return privatePreSaleTokenBalances[_participant];
219 	}	
220 
221 	function getWeiBalance(address _participant) public view returns(uint256) {
222 		return weiBalances[_participant];
223 	}
224 	
225 	function setBenificiary(address _benecifiaryAddress) public view onlyOwner {
226 		beneficiary = _benecifiaryAddress;
227 	}
228 }