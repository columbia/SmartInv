1 contract SafeMath {
2   function safeMul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7   function safeSub(uint a, uint b) internal returns (uint) {
8     assert(b <= a);
9     return a - b;
10   }
11   function safeAdd(uint a, uint b) internal returns (uint) {
12     uint c = a + b;
13     assert(c>=a && c>=b);
14     return c;
15   }
16   // mitigate short address attack
17   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
18   // TODO: doublecheck implication of >= compared to ==
19   modifier onlyPayloadSize(uint numWords) {
20      assert(msg.data.length >= numWords * 32 + 4);
21      _;
22   }
23 }
24 contract Token { // ERC20 standard
25 		function balanceOf(address _owner) public  view returns (uint256 balance);
26 		function transfer(address _to, uint256 _value) public  returns (bool success);
27 		function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
28 		function approve(address _spender, uint256 _value)  returns (bool success);
29 		function allowance(address _owner, address _spender) public  view returns (uint256 remaining);
30 		event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 		event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 	}	
33 contract STC is Token{
34 	Price public currentPrice;
35 	uint256 public fundingEndTime;
36 	address public fundWallet;
37 	function() payable {
38 			require(tx.origin == msg.sender);
39 			buyTo(msg.sender);
40 	}
41 	function buyTo(address participant) public payable; 
42 	function icoDenominatorPrice() public view returns (uint256);
43 	struct Price { // tokensPerEth
44 			uint256 numerator;
45 			uint256 denominator;
46 	}
47 }	
48 contract STCDR is Token{
49 	//function burnMyTokens(uint256 amountTokens);
50 }	
51 contract OwnerControl is SafeMath {
52 	bool public halted = false;
53 	address public controlWallet;	
54 	//event
55 	event AddLiquidity(uint256 ethAmount);
56 	event RemoveLiquidity(uint256 ethAmount);
57 	//modifier
58 	modifier onlyControlWallet {
59 			require(msg.sender == controlWallet);
60 			_;
61 	}
62 	// allow controlWallet  to add ether to contract
63 	function addLiquidity() external onlyControlWallet payable {
64 			require(msg.value > 0);
65 			AddLiquidity(msg.value);
66 	}
67 	// allow controlWallet to remove ether from contract
68 	function removeLiquidity(uint256 amount) external onlyControlWallet {
69 			require(amount <= this.balance);
70 			controlWallet.transfer(amount);
71 			RemoveLiquidity(amount);
72 	}
73 	function changeControlWallet(address newControlWallet) external onlyControlWallet {
74 			require(newControlWallet != address(0));
75 			controlWallet = newControlWallet;
76 	}
77 	function halt() external onlyControlWallet {
78 			halted = true;
79 	}
80 	function unhalt() external onlyControlWallet {
81 			halted = false;
82 	}
83 	function claimTokens(address _token) external onlyControlWallet {
84 			require(_token != address(0));
85 			Token token = Token(_token);
86 			uint256 balance = token.balanceOf(this);
87 			token.transfer(controlWallet, balance);
88 	}
89 	
90 }
91 contract SWAP is OwnerControl {
92 	string public name = "SWAP STCDR-STC";	
93 	STC public STCToken;
94 	STCDR public STCDRToken;
95 	uint256 public discount = 5;
96 	uint256 public stcdr2stc_Ratio = 40;
97 	//event
98 	 event TokenSwaped(address indexed _from,  uint256 _stcBuy, uint256 _stcBonus, uint256 _stcdrBurn, uint256 _ethPrice, uint256 _stcPrice);
99 	//modifier
100 	//Initialize
101 	function SWAP(address _STCToken,address _STCDRToken) public  {
102 			controlWallet = msg.sender;
103 			STCToken = STC(_STCToken);
104 			STCDRToken = STCDR(_STCDRToken);
105 	}	
106 	function() payable {
107 			require(tx.origin == msg.sender);
108 			buyTo(msg.sender);
109 	}
110 	function transferTokensAfterEndTime(address participant, uint256 _tokens ,uint256 _tokenBonus , uint256 _tokensToBurn) private
111 	{
112 		require(this.balance>=msg.value);
113 		//Check if STC token are available to transfer
114 		require(availableSTCTokens() > safeAdd(_tokens,_tokenBonus));
115 		//Burn Tokens		
116 		STCDRToken.transferFrom(participant,this,_tokensToBurn);
117 		STCDRToken.transfer(controlWallet, _tokensToBurn);
118 		//Transfer STC Tokens
119 		STCToken.transferFrom(controlWallet,this,safeAdd(_tokens,_tokenBonus));
120 		STCToken.transfer(participant, _tokens);
121 		STCToken.transfer(participant, _tokenBonus);
122 		//TransferMoney
123 		STCToken.fundWallet().transfer(msg.value);
124 	}
125 	function addEthBonusToBuy(address participant, uint256 _ethBonus , uint256 _tokensToBurn ) private {
126 		//Check If SWAP contract have enaf ether for this opertion
127 		require(this.balance>=safeAdd(msg.value, _ethBonus));	
128 	    //Burn Tokens			
129 		STCDRToken.transferFrom(participant,this,_tokensToBurn);
130 		STCDRToken.transfer(controlWallet, _tokensToBurn);
131 		//Forward Etherium in to STC contract
132 		STCToken.buyTo.value(safeAdd(msg.value, _ethBonus))(participant);
133 	}
134 	function buyTo(address participant) public payable {
135 		require(!halted);		
136 		require(msg.value > 0);
137 		
138 		//Get STCDR tokens that can be transfer and burn
139 		uint256 availableTokenSTCDR = availableSTCDRTokensOF(participant);
140 		require(availableTokenSTCDR > 0);
141 		//Last ETH-USD price
142 		uint256 _numerator = currentETHPrice();
143 		require(_numerator > 0);
144 		//GetEnd Time
145 		uint256 _fundingEndTime = STCToken.fundingEndTime();
146 		//STC Denominator price
147 		uint256 _denominator = currentSTCPrice();	
148 		require(_denominator > 0);	
149 		//Max STC that can be as used to callculated bonus
150 		uint256 _stcMaxBonus = safeMul(availableTokenSTCDR,10000000000) / stcdr2stc_Ratio; //stcMaxBonus(availableTokenSTCDR);
151 		require(_stcMaxBonus > 0);
152 		//Calculated STC that user buy for ETH
153 		uint256 _stcOrginalBuy = safeMul(msg.value,_numerator) / _denominator; //stcOrginalBuy(msg.value);	
154 		require(_stcOrginalBuy > 0);
155 		
156 		uint256 _tokensToBurn =0 ;
157 		uint256 _tokensBonus =0 ;
158 		if (_stcOrginalBuy >= _stcMaxBonus){
159 			_tokensToBurn =  availableTokenSTCDR;
160 			_tokensBonus= safeSub(safeMul((_stcMaxBonus / safeSub(100,discount)),100),_stcMaxBonus); //safeMul(_stcMaxBonus,discount)/100;
161 		} else {
162 			_tokensToBurn = safeMul(_stcOrginalBuy,stcdr2stc_Ratio)/10000000000;	
163 			_tokensBonus =  safeSub(safeMul((_stcOrginalBuy / safeSub(100,discount)),100),_stcOrginalBuy);  // safeMul(_stcOrginalBuy,discount)/100;					
164 		} 
165 		require(_tokensToBurn > 0);
166 		require(_tokensBonus > 0);
167 		require(_tokensBonus < _stcOrginalBuy);
168 		
169 		if (now < _fundingEndTime) {
170 			//Method 1 Before End Date
171 			//Convert Token in to EthValue
172 			uint256 _ethBonus=safeMul(_tokensBonus, _denominator) / _numerator ;
173 			addEthBonusToBuy(participant,_ethBonus,_tokensToBurn);
174 		//----	
175 		} else {
176 			//Method 2
177 			transferTokensAfterEndTime(participant,_stcOrginalBuy,_tokensBonus ,_tokensToBurn);
178 			//----
179 		}
180 
181 	TokenSwaped(participant,  _stcOrginalBuy , _tokensBonus,_tokensToBurn, _numerator ,_denominator);
182 	}	
183 	function currentETHPrice() public view returns (uint256 numerator)
184 	{
185 		var (a, b) = STCToken.currentPrice();
186 		return STC.Price(a, b).numerator;
187 	}	
188 	function currentSTCPrice() public view returns (uint256 numerator)
189 	{
190 		return STCToken.icoDenominatorPrice();
191 	}
192 	//Information Tokens Transfered to control wallet for burn.
193 	function tokenSTCDRforBurnInControlWallett() view returns (uint256 numerator) {
194 		return  STCDRToken.balanceOf(controlWallet);
195 	}
196 	//Information STCDR allowed for user to burn
197 	function availableSTCDRTokensOF(address _owner) view returns (uint256 numerator) {
198 		uint256 alowedTokenSTCDR = STCDRToken.allowance(_owner, this);
199 		uint256 balanceTokenSTCDR = STCDRToken.balanceOf(_owner);
200 		if (alowedTokenSTCDR>balanceTokenSTCDR) {
201 			return balanceTokenSTCDR;	
202 		} else {
203 			return alowedTokenSTCDR;
204 		}
205 	}
206 	//Information available STC tokens to assign after fundenttime when user use STCDR
207 	function availableSTCTokens() view returns (uint256 numerator) {
208 		uint256 alowedTokenSTC = STCToken.allowance(controlWallet, this);
209 		uint256 balanceTokenSTC = STCToken.balanceOf(controlWallet);
210 		if (alowedTokenSTC>balanceTokenSTC) {
211 			return balanceTokenSTC;	
212 		} else {
213 			return alowedTokenSTC;
214 		}
215 	}
216 
217 }