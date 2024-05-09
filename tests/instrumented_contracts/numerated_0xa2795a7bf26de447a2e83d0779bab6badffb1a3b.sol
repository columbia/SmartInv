1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 	function mul(uint a, uint b) internal pure returns (uint c) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		c = a * b;
9 		require(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint a, uint b) internal pure returns (uint c) {
14 		return a / b;
15 	}
16 }
17 
18 contract DrupeCoin {
19 	function transfer(address to, uint tokens) public returns (bool success);
20 	function balanceOf(address tokenOwner) public constant returns (uint balance);
21 }
22 
23 // Contract that forwards token purchases to the main ico contract
24 // and references the referrer in order to sent a referral bonus:
25 contract DrupeICORef {
26 	address _referrer;
27 	DrupeICO _ico;
28 
29 	constructor(address referrer, DrupeICO ico) public {
30 		_referrer = referrer;
31 		_ico = ico;
32 	}
33 
34 	function() public payable {
35 		_ico.purchase.value(msg.value)(msg.sender, _referrer);
36 	}
37 }
38 
39 // The main contract that holds all tokens for sale and accepts Ether:
40 contract DrupeICO {
41 	using SafeMath for uint;
42 
43 	// Representation of a fraction: n(numerator)/d(denominator)
44 	struct Fraction { uint n; uint d; }
45 
46 	// Representation of an ico phases:
47 	struct Presale {
48 		// Start timestamp in seconds since unix epoch:
49 		uint start;
50 		// Bonus that applies to token purchases during this phase:
51 		Fraction bonus;
52 	}
53 	struct Mainsale {
54 		// Start timestamp in seconds since unix epoch:
55 		uint start;
56 		// End timestamp in seconds since unix epoch:
57 		uint end;
58 	}
59 
60 	// Event that is emitted for each referral contract creation:
61 	event Referrer(address indexed referrer, address indexed refContract);
62 
63 	address _owner;
64 	address _newOwner;
65 	DrupeCoin _drupe;
66 	Fraction _basePrice; // in: ETH per DPC
67 	Fraction _refBonus;
68 	Presale _presale1;
69 	Presale _presale2;
70 	Mainsale _mainsale;
71 
72 	constructor(
73 		address drupe,
74 		uint basePriceN, uint basePriceD,
75 		uint refBonusN, uint refBonusD,
76 		uint presale1Start, uint presale1BonusN, uint presale1BonusD,
77 		uint presale2Start, uint presale2BonusN, uint presale2BonusD,
78 		uint mainsaleStart, uint mainsaleEnd
79 	) public {
80 		require(drupe != address(0));
81 		require(basePriceN > 0 && basePriceD > 0);
82 		require(refBonusN > 0 && basePriceD > 0);
83 		require(presale1Start > now);
84 		require(presale1BonusN > 0 && presale1BonusD > 0);
85 		require(presale2Start > presale1Start);
86 		require(presale2BonusN > 0 && presale2BonusD > 0);
87 		require(mainsaleStart > presale2Start);
88 		require(mainsaleEnd > mainsaleStart);
89 
90 		_owner = msg.sender;
91 		_newOwner = address(0);
92 		_drupe = DrupeCoin(drupe);
93 		_basePrice = Fraction({n: basePriceN, d: basePriceD});
94 		_refBonus = Fraction({n: refBonusN, d: refBonusD});
95 		_presale1 = Presale({
96 			start: presale1Start,
97 			bonus: Fraction({n: presale1BonusN, d: presale1BonusD})
98 		});
99 		_presale2 = Presale({
100 			start: presale2Start,
101 			bonus: Fraction({n: presale2BonusN, d: presale2BonusD})
102 		});
103 		_mainsale = Mainsale({
104 			start: mainsaleStart,
105 			end: mainsaleEnd
106 		});
107 	}
108 
109 	// Modifier to ensure that a function is only called during the ico:
110 	modifier icoOnly() {
111 		require(now >= _presale1.start && now < _mainsale.end);
112 		_;
113 	}
114 
115 	// Modifier to ensure that a function is only called by the owner:
116 	modifier ownerOnly() {
117 		require(msg.sender == _owner);
118 		_;
119 	}
120 
121 
122 
123 	// Internal function for determining the current bonus:
124 	// (It is assumed that this function is only called during the ico)
125 	function _getBonus() internal view returns (Fraction memory bonus) {
126 		if (now < _presale2.start) {
127 			bonus = _presale1.bonus;
128 		} else if (now < _mainsale.start) {
129 			bonus = _presale2.bonus;
130 		} else {
131 			bonus = Fraction({n: 0, d: 1});
132 		}
133 	}
134 
135 
136 
137 	// Exchange Ether for tokens:
138 	function() public payable icoOnly {
139 		Fraction memory bonus = _getBonus();
140 
141 		// Calculate the raw amount of tokens:
142 		uint rawTokens = msg.value.mul(_basePrice.d).div(_basePrice.n);
143 		// Calculate the amount of tokens including bonus:
144 		uint tokens = rawTokens + rawTokens.mul(bonus.n).div(bonus.d);
145 
146 		// Transfer tokens to the sender:
147 		_drupe.transfer(msg.sender, tokens);
148 		// (Sent Ether will remain on this contract)
149 
150 		// Create referral contract for the sender:
151 		address refContract = new DrupeICORef(msg.sender, this);
152 		emit Referrer(msg.sender, refContract);
153 	}
154 
155 	// Extended function for exchanging Ether for tokens.
156 	//  - aquired tokens will be send to the payout address.
157 	//  - ref bonus tokens will be send to the referrer.
158 	function purchase(address payout, address referrer) public payable icoOnly returns (uint tokens) {
159 		Fraction memory bonus = _getBonus();
160 
161 		// Calculate the raw amount of tokens:
162 		uint rawTokens = msg.value.mul(_basePrice.d).div(_basePrice.n);
163 		// Calculate the amount of tokens including bonus:
164 		tokens = rawTokens + rawTokens.mul(bonus.n).div(bonus.d);
165 		// Calculate the amount of tokens for the referrer:
166 		uint refTokens = rawTokens.mul(_refBonus.n).div(_refBonus.d);
167 
168 		// Transfer tokens to the payout address:
169 		_drupe.transfer(payout, tokens);
170 		// Transfer ref bonus tokens to the referrer:
171 		_drupe.transfer(referrer, refTokens);
172 		// (Sent Ether will remain on this contract)
173 
174 		// Create referral contract for the sender:
175 		address refContract = new DrupeICORef(payout, this);
176 		emit Referrer(payout, refContract);
177 	}
178 
179 
180 
181 	// Function that can be used to burn unsold tokens after the ico has ended:
182 	function burnUnsoldTokens() public ownerOnly {
183 		require(now >= _mainsale.end);
184 		uint unsoldTokens = _drupe.balanceOf(this);
185 		_drupe.transfer(address(0), unsoldTokens);
186 	}
187 
188 	// Function that the owner can withdraw funds:
189 	function withdrawFunds(uint value) public ownerOnly {
190 		msg.sender.transfer(value);
191 	}
192 
193 
194 
195 	function getOwner() public view returns (address) {
196 		return _owner;
197 	}
198 
199 	function transferOwnership(address newOwner) public ownerOnly {
200 		_newOwner = newOwner;
201 	}
202 
203 	function acceptOwnership() public {
204 		require(msg.sender == _newOwner);
205 		_owner = _newOwner;
206 		_newOwner = address(0);
207 	}
208 
209 
210 
211 	function getDrupeCoin() public view returns (address) {
212 		return _drupe;
213 	}
214 
215 	function getBasePrice() public view returns (uint n, uint d) {
216 		n = _basePrice.n;
217 		d = _basePrice.d;
218 	}
219 
220 	function getRefBonus() public view returns (uint n, uint d) {
221 		n = _refBonus.n;
222 		d = _refBonus.d;
223 	}
224 
225 	function getPresale1() public view returns (uint start, uint bonusN, uint bonusD) {
226 		start = _presale1.start;
227 		bonusN = _presale1.bonus.n;
228 		bonusD = _presale1.bonus.d;
229 	}
230 
231 	function getPresale2() public view returns (uint start, uint bonusN, uint bonusD) {
232 		start = _presale2.start;
233 		bonusN = _presale2.bonus.n;
234 		bonusD = _presale2.bonus.d;
235 	}
236 
237 	function getMainsale() public view returns (uint start, uint end) {
238 		start = _mainsale.start;
239 		end = _mainsale.end;
240 	}
241 }