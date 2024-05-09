1 pragma solidity ^0.4.13;
2 // Abstract contract for the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 
5 contract ERC20 {
6     /// total amount of tokens
7     uint256 public totalSupply;
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract SafeMath {
42   function safeMul(uint a, uint b) internal returns (uint) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function safeDiv(uint a, uint b) internal returns (uint) {
49     assert(b > 0);
50     uint c = a / b;
51     assert(a == b * c + a % b);
52     return c;
53   }
54 
55   function safeSub(uint a, uint b) internal returns (uint) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint a, uint b) internal returns (uint) {
61     uint c = a + b;
62     assert(c>=a && c>=b);
63     return c;
64   }
65 
66   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a >= b ? a : b;
68   }
69 
70   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
71     return a < b ? a : b;
72   }
73 
74   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a >= b ? a : b;
76   }
77 
78   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
79     return a < b ? a : b;
80   }
81 
82   function assert(bool assertion) internal {
83     if (!assertion) {
84       throw;
85     }
86   }
87 }
88 
89 contract Owned {
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     address public owner;
96 
97     function Owned() {
98         owner = msg.sender;
99     }
100 
101     address public newOwner;
102 
103     function changeOwner(address _newOwner) onlyOwner {
104         newOwner = _newOwner;
105     }
106 
107     function acceptOwnership() {
108         if (msg.sender == newOwner) {
109             owner = newOwner;
110         }
111     }
112 }
113 
114 contract MintableToken is ERC20, SafeMath, Owned{
115 	mapping(address => uint) public balances;
116 	address[] mintingFactories;
117 	uint numFactories;
118 	
119 	function addMintingFactory(address _factory) onlyOwner{
120 	    mintingFactories.push(_factory);
121 	    numFactories += 1;
122 	}
123 	
124 	modifier onlyFactory{
125 	    bool isFactory = false;
126 	    for (uint i = 0; i < numFactories; i++){
127 	        if (msg.sender == mintingFactories[i])
128 	        {
129 	            isFactory = true;
130 	        }
131 	    }
132 	    if (!isFactory) throw;
133 	    _;
134 	}
135 	function exchangeTransfer(address _to, uint _value);
136 }
137 
138 contract CollectibleFeeToken is MintableToken{
139 	uint8 public decimals;
140 	mapping(uint => uint) public roundFees;
141 	mapping(uint => uint) public recordedCoinSupplyForRound;
142 	mapping(uint => mapping (address => uint)) claimedFees;
143 	mapping(address => uint) lastClaimedRound;
144 	uint256 public reserves;
145 	uint public latestRound = 0;
146 	uint public initialRound = 1;
147 	
148 	modifier onlyPayloadSize(uint size) {
149 		if(msg.data.length != size + 4) {
150 		throw;
151 		}
152 		_;
153 	}
154 	
155 	function reduceReserves(uint value) onlyPayloadSize(1 * 32) onlyOwner{
156 	    reserves = safeSub(reserves, value);
157 	}
158 	
159 	function addReserves(uint value) onlyPayloadSize(1 * 32) onlyOwner{
160 	    reserves = safeAdd(reserves, value);
161 	}
162 	
163 	function depositFees(uint value) onlyPayloadSize(1 * 32) onlyOwner {
164 		latestRound += 1;
165 		recordedCoinSupplyForRound[latestRound] = totalSupply;
166 		roundFees[latestRound] = value;
167 	}
168 	function claimFees(address _owner) onlyPayloadSize(1 * 32) onlyOwner returns (uint totalFees) {
169 		totalFees = 0;
170 		for (uint i = lastClaimedRound[_owner] + 1; i <= latestRound; i++){
171 			uint feeForRound = balances[_owner] * feePerUnitOfCoin(i);
172 			if (feeForRound > claimedFees[i][_owner]){
173 				feeForRound = safeSub(feeForRound,claimedFees[i][_owner]);
174 			}
175 			else {
176 				feeForRound = 0;
177 			}
178 			claimedFees[i][_owner] = safeAdd(claimedFees[i][_owner], feeForRound);
179 			totalFees = safeAdd(totalFees, feeForRound);
180 		}
181 		lastClaimedRound[_owner] = latestRound;
182 		return totalFees;
183 	}
184 
185 	function claimFeesForRound(address _owner, uint round) onlyPayloadSize(2 * 32) onlyOwner returns (uint feeForRound) {
186 		feeForRound = balances[_owner] * feePerUnitOfCoin(round);
187 		if (feeForRound > claimedFees[round][_owner]){
188 			feeForRound = safeSub(feeForRound,claimedFees[round][_owner]);
189 		}
190 		else {
191 			feeForRound = 0;
192 		}
193 		claimedFees[round][_owner] = safeAdd(claimedFees[round][_owner], feeForRound);
194 		return feeForRound;
195 	}
196 
197 	function _resetTransferredCoinFees(address _owner, address _receipient, uint numCoins) internal{
198 		for (uint i = lastClaimedRound[_owner] + 1; i <= latestRound; i++){
199 			uint feeForRound = balances[_owner] * feePerUnitOfCoin(i);
200 			if (feeForRound > claimedFees[i][_owner]) {
201 				//Add unclaimed fees to reserves
202 				uint unclaimedFees = min256(numCoins * feePerUnitOfCoin(i), safeSub(feeForRound, claimedFees[i][_owner]));
203 				reserves = safeAdd(reserves, unclaimedFees);
204 				claimedFees[i][_owner] = safeAdd(claimedFees[i][_owner], unclaimedFees);
205 			}
206 		}
207 		for (uint x = lastClaimedRound[_receipient] + 1; x <= latestRound; x++){
208 			//Empty fees for new receipient
209 			claimedFees[x][_receipient] = safeAdd(claimedFees[x][_receipient], numCoins * feePerUnitOfCoin(x));
210 		}
211 	}
212 	function feePerUnitOfCoin(uint round) public constant returns (uint fee){
213 		return safeDiv(roundFees[round], recordedCoinSupplyForRound[round]);
214 	}
215 	
216    function mintTokens(address _owner, uint amount) onlyFactory{
217        //Upon factory transfer, fees will be redistributed into reserves
218        lastClaimedRound[msg.sender] = latestRound;
219        totalSupply = safeAdd(totalSupply, amount);
220        balances[_owner] += amount;
221    }
222 }
223 contract SphereTokenFactory is Owned{
224 	CollectibleFeeToken sphereToken;
225 	address public exchangeAddress;
226 	address public daoAddress;
227 	modifier onlyExchange{
228 	    if (msg.sender != exchangeAddress && msg.sender != daoAddress){
229 	        throw;
230 	    }
231 	    _;
232 	}
233 	function SphereTokenFactory(){
234 		sphereToken = CollectibleFeeToken(0xe18e9ce082B1609ebFAE090c6e5Cbb65eDaC5855);
235 	}
236 	function mint(address target, uint amount) onlyExchange{
237 		sphereToken.mintTokens(address(this), amount);
238 		sphereToken.exchangeTransfer(target, amount);
239 	}
240     function setExchange(address exchange) onlyOwner{
241         exchangeAddress = exchange;
242     }
243     function setDAO(address dao) onlyOwner{
244         daoAddress = dao;
245     }
246 }