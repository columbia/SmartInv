1 pragma solidity ^0.4.15;
2 
3 
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8         if (a == 0) {
9 			return 0;
10 		}
11 		uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal constant returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a && c >= b);
26         return c;
27     }
28 	
29 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30 		assert(b <= a);
31 		return a - b;
32 	}
33 
34 }
35 
36 
37 
38 contract Token {
39 
40     uint256 public totalSupply;
41 
42     function balanceOf(address _owner) constant returns (uint256 balance);
43     function transfer(address _to, uint256 _value) returns (bool success);
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
45     function approve(address _spender, uint256 _value) returns (bool success);
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 
51 }
52 
53 
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58 		require( msg.data.length >= (2 * 32) + 4 );
59 		require( _value > 0 );
60 		require( balances[msg.sender] >= _value );
61 		require( balances[_to] + _value > balances[_to] );
62 
63         balances[msg.sender] -= _value;
64         balances[_to] += _value;
65         Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
70 		require( msg.data.length >= (3 * 32) + 4 );
71 		require( _value > 0 );
72 		require( balances[_from] >= _value );
73 		require( allowed[_from][msg.sender] >= _value );
74 		require( balances[_to] + _value > balances[_to] );
75 
76         balances[_from] -= _value;
77 		allowed[_from][msg.sender] -= _value;
78 		balances[_to] += _value;
79         Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) returns (bool success) {
88 		require( _value == 0 || allowed[msg.sender][_spender] == 0 );
89 
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96         return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 
102 }
103 
104 
105 
106 contract WhaleToken is StandardToken {
107 
108     using SafeMath for uint256;
109 
110 	string public constant name = "WhaleFUND";								// WHALE tokens name
111     string public constant symbol = "WHALE";								// WHALE tokens ticker
112     uint256 public constant decimals = 18;									// WHALE tokens decimals
113 	string public version = "1.0";											// WHALE version
114 
115 	uint256 public constant maximumSupply =  800 * (10**3) * 10**decimals;	// Maximum 800k Whale tokens
116 	uint256 public constant operatingFund = 152 * (10**3) * 10**decimals;	// 19% - 152k WHALE reserved for operating expenses
117 	uint256 public constant teamFund = 120 * (10**3) * 10**decimals;		// 15% - 120k WHALE reserved for WhaleFUND team
118 	uint256 public constant partnersFund = 24 * (10**3) * 10**decimals;		// 3% - 24k WHALE reserved for partner program
119 	uint256 public constant bountyFund = 24 * (10**3) * 10**decimals;		// 3% - 24k WHALE reserved for bounty program
120 	
121 	uint256 public constant whaleExchangeRate = 100;						// 100 WHALE tokens per 1 ETH
122 	
123 	uint256 public constant preIcoBonus = 15;								// PreICO bonus 15%
124 	uint256 public constant icoThreshold1 = 420 * (10**3) * 10**decimals;	// <100k sold WHALE tokens, without 152k+120k+24k+24k=320k reserved tokens
125 	uint256 public constant icoThreshold2 = 520 * (10**3) * 10**decimals;	// >100k && <200k sold WHALE tokens, without 152k+120k+24k+24k=320k reserved tokens
126 	uint256 public constant icoThreshold3 = 620 * (10**3) * 10**decimals;	// >200k && <300k sold WHALE tokens, without 152k+120k+24k+24k=320k reserved tokens
127 	uint256 public constant icoThresholdBonus1 = 10;						// ICO threshold bonus 10%
128 	uint256 public constant icoThresholdBonus2 = 5;							// ICO threshold bonus 5%
129 	uint256 public constant icoThresholdBonus3 = 3;							// ICO threshold bonus 3%
130 	uint256 public constant icoAmountBonus1 = 2;							// ICO amount bonus 2%
131 	uint256 public constant icoAmountBonus2 = 3;							// ICO amount bonus 3%
132 	uint256 public constant icoAmountBonus3 = 5;							// ICO amount bonus 5%
133 
134     address public etherAddress;
135     address public operatingFundAddress;
136 	address public teamFundAddress;
137 	address public partnersFundAddress;
138 	address public bountyFundAddress;
139 	address public dividendFundAddress;
140 
141     bool public isFinalized;
142 	uint256 public constant crowdsaleStart = 1511136000;					// Monday, 20 November 2017, 00:00:00 UTC
143 	uint256 public constant crowdsaleEnd = 1513555200;						// Monday, 18 December 2017, 00:00:00 UTC
144 
145     event createWhaleTokens(address indexed _to, uint256 _value);
146 
147 
148     function WhaleToken(
149         address _etherAddress,
150         address _operatingFundAddress,
151 		address _teamFundAddress,
152 		address _partnersFundAddress,
153 		address _bountyFundAddress,
154 		address _dividendFundAddress
155 	)
156     {
157 
158         isFinalized = false;
159 
160         etherAddress = _etherAddress;
161         operatingFundAddress = _operatingFundAddress;
162 		teamFundAddress = _teamFundAddress;
163 	    partnersFundAddress = _partnersFundAddress;
164 		bountyFundAddress = _bountyFundAddress;
165 		dividendFundAddress = _dividendFundAddress;
166 		
167 		totalSupply = totalSupply.add(operatingFund).add(teamFund).add(partnersFund).add(bountyFund);
168 
169 		balances[operatingFundAddress] = operatingFund;						// Update operating funds balance
170 		createWhaleTokens(operatingFundAddress, operatingFund);				// Create operating funds tokens
171 
172 		balances[teamFundAddress] = teamFund;								// Update team funds balance
173 		createWhaleTokens(teamFundAddress, teamFund);						// Create team funds tokens
174 
175 		balances[partnersFundAddress] = partnersFund;						// Update partner program funds balance
176 		createWhaleTokens(partnersFundAddress, partnersFund);				// Create partner program funds tokens
177 		
178 		balances[bountyFundAddress] = bountyFund;							// Update bounty program funds balance
179 		createWhaleTokens(bountyFundAddress, bountyFund);					// Create bounty program funds tokens
180 
181 	}
182 
183 
184     function makeTokens() payable  {
185 
186 		require( !isFinalized );
187 		require( now >= crowdsaleStart );
188 		require( now < crowdsaleEnd );
189 		
190 		if (now < crowdsaleStart + 7 days) {
191 			require( msg.value >= 3000 finney );
192 		} else if (now >= crowdsaleStart + 7 days) {
193 			require( msg.value >= 10 finney );
194 		}
195 
196 
197 		uint256 buyedTokens = 0;
198 		uint256 bonusTokens = 0;
199 		uint256 bonusThresholdTokens = 0;
200 		uint256 bonusAmountTokens = 0;
201 		uint256 tokens = 0;
202 
203 
204 		if (now < crowdsaleStart + 7 days) {
205 
206 			buyedTokens = msg.value.mul(whaleExchangeRate);								// Buyed WHALE tokens without bonuses
207 			bonusTokens = buyedTokens.mul(preIcoBonus).div(100);						// preICO bonus 15%
208 			tokens = buyedTokens.add(bonusTokens);										// Buyed WHALE tokens with bonuses
209 	
210 		} else {
211 		
212 			buyedTokens = msg.value.mul(whaleExchangeRate);								// Buyed WHALE tokens without bonuses
213 
214 			if (totalSupply <= icoThreshold1) {
215 				bonusThresholdTokens = buyedTokens.mul(icoThresholdBonus1).div(100);	// ICO threshold bonus 10%
216 			} else if (totalSupply > icoThreshold1 && totalSupply <= icoThreshold2) {
217 				bonusThresholdTokens = buyedTokens.mul(icoThresholdBonus2).div(100);	// ICO threshold bonus 5%
218 			} else if (totalSupply > icoThreshold2 && totalSupply <= icoThreshold3) {
219 				bonusThresholdTokens = buyedTokens.mul(icoThresholdBonus3).div(100);	// ICO threshold bonus 3%
220 			} else if (totalSupply > icoThreshold3) {
221 				bonusThresholdTokens = 0;												// ICO threshold bonus 0%
222 			}
223 
224 			if (msg.value < 10000 finney) {
225 				bonusAmountTokens = 0;													// ICO amount bonus 0%
226 			} else if (msg.value >= 10000 finney && msg.value < 100010 finney) {
227 				bonusAmountTokens = buyedTokens.mul(icoAmountBonus1).div(100);			// ICO amount bonus 2%
228 			} else if (msg.value >= 100010 finney && msg.value < 300010 finney) {
229 				bonusAmountTokens = buyedTokens.mul(icoAmountBonus2).div(100);			// ICO amount bonus 3%
230 			} else if (msg.value >= 300010 finney) {
231 				bonusAmountTokens = buyedTokens.mul(icoAmountBonus3).div(100);			// ICO amount bonus 5%
232 			}
233 
234 			tokens = buyedTokens.add(bonusThresholdTokens).add(bonusAmountTokens);		// Buyed WHALE tokens with bonuses
235 
236 		}
237 
238 	    uint256 currentSupply = totalSupply.add(tokens);
239 
240 		require( maximumSupply >= currentSupply );
241 
242         totalSupply = currentSupply;
243 
244         balances[msg.sender] += tokens;										// Update buyer balance 
245         createWhaleTokens(msg.sender, tokens);								// Create buyed tokens
246 		
247 		etherAddress.transfer(msg.value);									// Transfer ETH to MultiSig Address
248 
249     }
250 
251 
252     function() payable {
253 
254         makeTokens();
255 
256     }
257 
258 
259     function finalizeCrowdsale() external {
260 
261 		require( !isFinalized );											// Required crowdsale state FALSE
262 		require( msg.sender == teamFundAddress );							// Required call from team fund address
263 		require( now > crowdsaleEnd || totalSupply == maximumSupply );		// Required crowdsale ended or maximum supply reached
264 		
265 		uint256 remainingSupply = maximumSupply.sub(totalSupply);			// Remaining tokens to reach maximum supply
266 		if (remainingSupply > 0) {
267 			uint256 updatedSupply = totalSupply.add(remainingSupply);		// New total supply
268 			totalSupply = updatedSupply;									// Update total supply
269 			balances[dividendFundAddress] += remainingSupply;				// Update dividend funds balance
270 			createWhaleTokens(dividendFundAddress, remainingSupply);		// Create dividend funds tokens
271 		}
272 
273         isFinalized = true;													// Set crowdsale state TRUE
274 
275     }
276 
277 }