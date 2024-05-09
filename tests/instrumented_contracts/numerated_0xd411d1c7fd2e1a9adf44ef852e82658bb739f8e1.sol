1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9 		if (a == 0) {
10 			return 0;
11 		}
12 		uint256 c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	}
16 
17 	function div(uint256 a, uint256 b) internal pure returns(uint256) {
18 		assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint256 c = a / b;
20 		assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 
29 	function add(uint256 a, uint256 b) internal pure returns(uint256) {
30 		uint256 c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34 }
35 
36 contract ERC20
37 {
38 	function totalSupply()public view returns(uint total_Supply);
39 	function balanceOf(address who)public view returns(uint256);
40 	function allowance(address owner, address spender)public view returns(uint);
41 	function transferFrom(address from, address to, uint value)public returns(bool ok);
42 	function approve(address spender, uint value)public returns(bool ok);
43 	function transfer(address to, uint value)public returns(bool ok);
44 	event Transfer(address indexed from, address indexed to, uint value);
45 	event Approval(address indexed owner, address indexed spender, uint value);
46 }
47 
48 
49 contract Standix is ERC20
50 {
51 	using SafeMath for uint256;
52 
53 	address public 				WALLET 					= 0xAaF9BfaBB08e55B68140B3Ea6515901170053980;
54 	uint256 constant 	public 	TOKEN_DECIMALS 			= 10 ** 9;
55 	uint256 constant 	public 	ETH_DECIMALS 			= 10 ** 18;
56 	uint256 public 				TotalpresaleSupply 		= 20000000;  //20 million presale
57 	uint256 public 				TotalCrowdsaleSupply 	= 20000000; // 20 million ICO
58 	uint256 public 				TotalOwnerSupply 		= 60000000;  //60 Million to owner
59 	uint256 					PresaleDays 			= 31 days;
60 	uint256 					ICODays 				= 63 days;
61 
62 	// Name of the token
63 	string public constant name = "Standix";
64 
65 	// Symbol of token
66 	string public constant symbol = "SAX";
67 
68 	uint8 public constant decimals = 9;
69 
70 	// 100 Million total supply // muliplies dues to decimal precision
71 	uint public TotalTokenSupply = 100000000 * TOKEN_DECIMALS;   //100 million
72 
73 	// Owner of this contract
74 	address public owner;
75 
76 	bool private paused = false;
77 
78 	uint256 public ContributionAmount;
79 	uint256 public StartdatePresale;
80 	uint256 public EnddatePresale;
81 	uint256 public StartdateICO;
82 	uint256 public EnddateICO;
83 	uint256 no_of_tokens;
84 	uint public BONUS;
85 
86 	uint256 public minContribution = 5000;// 50 USD in cents
87 	uint256 public TotalCrowdsaleContributions;
88 	uint Price_Per_Token;
89 
90 	uint public EtherUSDPriceFactor;
91 
92 	mapping(address => mapping(address => uint)) allowed;
93 	mapping(address => uint) balances;
94 
95 	enum Stages {
96 		NOTSTARTED,
97 		PREICO,
98 		ICO,
99 		ENDED
100 	}
101 
102 	Stages public stage;
103 
104 	modifier atStage(Stages _stage) {
105 		require(stage == _stage);
106 		_;
107 	}
108 
109 	modifier onlyOwner() {
110 		require (msg.sender == owner);
111 		_;
112 	}
113 
114 	constructor (uint256 EtherPriceFactor) public
115 	{
116 		require(EtherPriceFactor != 0);
117 		owner = msg.sender;
118 		balances[owner] = TotalOwnerSupply.mul(TOKEN_DECIMALS);
119 		stage = Stages.NOTSTARTED;
120 		EtherUSDPriceFactor = EtherPriceFactor;
121 		emit Transfer(0, owner, balances[owner]);
122 	}
123 
124 	function() public payable
125 	{
126 
127 		require(stage != Stages.ENDED);
128 		require(!paused && msg.sender != owner);
129 
130 		if( stage == Stages.PREICO && now <= EnddatePresale )
131 		{  
132 			caltoken();
133 		}
134 		else if(stage == Stages.ICO && now <= EnddateICO )
135 		{  
136 			caltoken();
137 		}
138 		else
139 		{
140 			revert();
141 		}
142 
143 	}
144 
145 
146 	function caltoken() private {
147 		// price in cents with 18 zeros included
148 		ContributionAmount = ((msg.value).mul(EtherUSDPriceFactor.mul(100)));
149 		require(ContributionAmount >= (minContribution.mul(ETH_DECIMALS)));
150 		no_of_tokens =(((ContributionAmount).div(Price_Per_Token))).div(TOKEN_DECIMALS);
151 		uint256 bonus_token = ((no_of_tokens).mul(BONUS)).div(100); // 58 percent bonus token
152 		uint256 total_token = no_of_tokens + bonus_token;
153 		transferTokens(msg.sender,total_token);
154 	}
155 
156 	// Calculates the Bonus Award based upon the purchase amount and the purchase period
157 	// function calculateBonus(uint256 individuallyContributedEtherInWei) private returns(uint256 bonus_applied)
158 
159 	function startPreICO() public onlyOwner atStage(Stages.NOTSTARTED)
160 	{
161 		stage = Stages.PREICO;
162 		paused = false;
163 		Price_Per_Token = 10;
164 		BONUS = 30;
165 		balances[address(this)] = (TotalpresaleSupply).mul(TOKEN_DECIMALS);
166 		StartdatePresale = now;
167 		EnddatePresale = now + PresaleDays;
168 		emit Transfer(0, address(this), balances[address(this)]);
169 
170 	}
171 
172 	function startICO() public onlyOwner //atStage(Stages.PREICO)
173 	{
174 
175 		//   require(now > pre_enddate);
176 		stage = Stages.ICO;
177 		paused = false;
178 		Price_Per_Token= 20;
179 		BONUS = 20;
180 		balances[address(this)] = balances[address(this)].add((TotalCrowdsaleSupply).mul(TOKEN_DECIMALS)); 
181 		StartdateICO = now;
182 		EnddateICO = now + ICODays;
183 		emit Transfer(0, address(this), (TotalCrowdsaleSupply).mul(TOKEN_DECIMALS));
184 
185 	}
186 	
187 	function setpricefactor(uint256 newPricefactor) external onlyOwner
188 	{
189 		EtherUSDPriceFactor = newPricefactor;
190 	}
191 
192 	// called by the owner, pause ICO
193 	function pauseICO() external onlyOwner
194 	{
195 		paused = true;
196 	}
197 
198 	// called by the owner , resumes ICO
199 	function resumeICO() external onlyOwner
200 	{
201 		paused = false;
202 	}
203 	function end_ICO() external onlyOwner atStage(Stages.ICO)
204 	{
205 		require(now > EnddateICO);
206 		stage = Stages.ENDED;
207 		TotalTokenSupply = (TotalTokenSupply).sub(balances[address(this)]);
208 		balances[address(this)] = 0;
209 		emit Transfer(address(this), 0 , balances[address(this)]);
210 
211 	}
212 
213 	// what is the total supply of the ech tokens
214 	function totalSupply() public view returns(uint256 total_Supply) {
215 		total_Supply = TotalTokenSupply;
216 	}
217 
218 	// What is the balance of a particular account?
219 	function balanceOf(address token_Owner)public constant returns(uint256 balance) {
220 		return balances[token_Owner];
221 	}
222 
223 	// Send _value amount of tokens from address _from to address _to
224 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
225 	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
226 	// fees in sub-currencies; the command should fail unless the _from account has
227 	// deliberately authorized the sender of the message via some mechanism; we propose
228 	// these standardized APIs for approval:
229 	function transferFrom(address from_address, address to_address, uint256 tokens)public returns(bool success)
230 	{
231 		require(to_address != 0x0);
232 		require(balances[from_address] >= tokens && allowed[from_address][msg.sender] >= tokens && tokens >= 0);
233 		balances[from_address] = (balances[from_address]).sub(tokens);
234 		allowed[from_address][msg.sender] = (allowed[from_address][msg.sender]).sub(tokens);
235 		balances[to_address] = (balances[to_address]).add(tokens);
236 		emit   Transfer(from_address, to_address, tokens);
237 		return true;
238 	}
239 
240 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
241 	// If this function is called again it overwrites the current allowance with _value.
242 	function approve(address spender, uint256 tokens)public returns(bool success)
243 	{
244 		require(spender != 0x0);
245 		allowed[msg.sender][spender] = tokens;
246 		emit  Approval(msg.sender, spender, tokens);
247 		return true;
248 	}
249 
250 	function allowance(address token_Owner, address spender) public constant returns(uint256 remaining)
251 	{
252 		require(token_Owner != 0x0 && spender != 0x0);
253 		return allowed[token_Owner][spender];
254 	}
255 
256 	// Transfer the balance from owner's account to another account
257 	function transfer(address to_address, uint256 tokens)public returns(bool success)
258 	{
259 		require(to_address != 0x0);
260 		require(balances[msg.sender] >= tokens && tokens >= 0);
261 		balances[msg.sender] = (balances[msg.sender]).sub(tokens);
262 		balances[to_address] = (balances[to_address]).add(tokens);
263 		emit  Transfer(msg.sender, to_address, tokens);
264 		return true;
265 	}
266 
267 	// Transfer the balance from owner's account to another account
268 	function transferTokens(address to_address, uint256 tokens) private returns(bool success)
269 	{
270 		require(to_address != 0x0);
271 		require(balances[address(this)] >= tokens && tokens > 0);
272 		balances[address(this)] = (balances[address(this)]).sub(tokens);
273 		balances[to_address] = (balances[to_address]).add(tokens);
274 		emit   Transfer(address(this), to_address, tokens);
275 		return true;
276 	}
277 
278 	function forwardFunds() external onlyOwner
279 	{
280 		address myAddress = this;
281 		WALLET.transfer(myAddress.balance);
282 	}
283 	
284 	// send token to multiple users in single time
285 	function sendTokens(address[] a, uint[] v) public {
286 	    uint i = 0;
287 	    while( i < a.length ){
288 	        transfer(a[i], v[i] * TOKEN_DECIMALS);
289 	        i++;
290 	    }
291 	}
292 
293 }