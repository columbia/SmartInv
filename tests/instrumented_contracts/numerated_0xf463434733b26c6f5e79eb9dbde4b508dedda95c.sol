1 pragma solidity ^0.4.18;
2 
3 interface IERC20 {
4 	function totalSupply() constant returns (uint totalSupply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 /**
15 * @title SafeMath
16 * @dev Math operations with safety checks that throw on error
17 */
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return c;
30 	}
31 
32 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33 		assert(b <= a);
34 		return a - b;
35 	}
36 
37 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
38 		uint256 c = a + b;
39 		assert(c >= a);
40 		return c;
41 	}
42 }
43 
44 
45 
46 contract ScudoCash is IERC20{
47 	using SafeMath for uint256;
48 
49 	uint256 private _totalSupply = 0;
50 
51 	bool public purchasingAllowed = true;
52 	bool private bonusAllowed = true;	
53 
54 	string public constant symbol = "SCH";
55 	string public constant name = "ScudoCash";
56 	uint256 public constant decimals = 18;
57 
58 	uint256 private CREATOR_TOKEN = 3100000000 * 10**decimals;
59 	uint256 private CREATOR_TOKEN_END = 465000000 * 10**decimals;
60 	uint256 private constant RATE = 100000;
61 	uint constant LENGHT_BONUS = 5 * 1 days;
62 	uint constant PERC_BONUS = 100;
63 	uint constant LENGHT_BONUS2 = 7 * 1 days;
64 	uint constant PERC_BONUS2 = 30;
65 	uint constant LENGHT_BONUS3 = 7 * 1 days;
66 	uint constant PERC_BONUS3 = 30;
67 	uint constant LENGHT_BONUS4 = 7 * 1 days;
68 	uint constant PERC_BONUS4 = 20;
69 	uint constant LENGHT_BONUS5 = 7 * 1 days;
70 	uint constant PERC_BONUS5 = 20;
71 	uint constant LENGHT_BONUS6 = 7 * 1 days;
72 	uint constant PERC_BONUS6 = 15;
73 	uint constant LENGHT_BONUS7 = 7 * 1 days;
74 	uint constant PERC_BONUS7 = 10;
75 	uint constant LENGHT_BONUS8 = 7 * 1 days;
76 	uint constant PERC_BONUS8 = 10;
77 	uint constant LENGHT_BONUS9 = 7 * 1 days;
78 	uint constant PERC_BONUS9 = 5;
79 	uint constant LENGHT_BONUS10 = 7 * 1 days;
80 	uint constant PERC_BONUS10 = 5;
81 
82 		
83 	address private owner;
84 
85 	mapping(address => uint256) balances;
86 	mapping(address => mapping(address => uint256)) allowed;
87 
88 	uint private start;
89 	uint private end;
90 	uint private end2;
91 	uint private end3;
92 	uint private end4;
93 	uint private end5;
94 	uint private end6;
95 	uint private end7;
96 	uint private end8;
97 	uint private end9;
98 	uint private end10;
99 	
100 	struct Buyer{
101 	    address to;
102 	    uint256 value;
103 	}
104 	
105 	Buyer[] buyers;
106 	
107 	modifier onlyOwner {
108 	    require(msg.sender == owner);
109 	    _;
110 	}
111 	
112 	function() payable{
113 		require(purchasingAllowed);		
114 		createTokens();
115 	}
116    
117 	function ScudoCash(){
118 		owner = msg.sender;
119 		balances[msg.sender] = CREATOR_TOKEN;
120 		start = now;
121 		end = now.add(LENGHT_BONUS);
122 		end2 = end.add(LENGHT_BONUS2);
123 		end3 = end2.add(LENGHT_BONUS3);
124 		end4 = end3.add(LENGHT_BONUS4);
125 		end5 = end4.add(LENGHT_BONUS5);
126 		end6 = end5.add(LENGHT_BONUS6);
127 		end7 = end6.add(LENGHT_BONUS7);
128 		end8 = end7.add(LENGHT_BONUS8);
129 		end9 = end8.add(LENGHT_BONUS9);
130 		end10 = end9.add(LENGHT_BONUS10);
131 	}
132    
133 	function createTokens() payable{
134 	    bool bSend = true;
135 		require(msg.value >= 0);
136 		uint256 tokens = msg.value.mul(10 ** decimals);
137 		tokens = tokens.mul(RATE);
138 		tokens = tokens.div(10 ** 18);
139 		if (bonusAllowed)
140 		{
141 			if (now >= start && now < end)
142 			{
143 			tokens += tokens.mul(PERC_BONUS).div(100);
144 			bSend = false;
145 			}
146 			if (now >= end && now < end2)
147 			{
148 			tokens += tokens.mul(PERC_BONUS2).div(100);
149 			bSend = false;
150 			}
151 			if (now >= end2 && now < end3)
152 			{
153 			tokens += tokens.mul(PERC_BONUS3).div(100);
154 			bSend = false;
155 			}
156 			if (now >= end3 && now < end4)
157 			{
158 			tokens += tokens.mul(PERC_BONUS4).div(100);
159 			bSend = false;
160 			}
161 			if (now >= end4 && now < end5)
162 			{
163 			tokens += tokens.mul(PERC_BONUS5).div(100);
164 			bSend = false;
165 			}
166 			if (now >= end5 && now < end6)
167 			{
168 			tokens += tokens.mul(PERC_BONUS6).div(100);
169 			bSend = false;
170 			}
171 			if (now >= end6 && now < end7)
172 			{
173 			tokens += tokens.mul(PERC_BONUS7).div(100);
174 			bSend = false;
175 			}
176 			if (now >= end7 && now < end8)
177 			{
178 			tokens += tokens.mul(PERC_BONUS8).div(100);
179 			bSend = false;
180 			}
181 			if (now >= end8 && now < end9)
182 			{
183 			tokens += tokens.mul(PERC_BONUS9).div(100);
184 			bSend = false;
185 			}
186 			if (now >= end9 && now < end10)
187 			{
188 			tokens += tokens.mul(PERC_BONUS10).div(100);
189 			bSend = false;
190 			}
191 		}
192 		uint256 sum2 = balances[owner].sub(tokens);		
193 		require(sum2 >= CREATOR_TOKEN_END);
194 		uint256 sum = _totalSupply.add(tokens);		
195 		_totalSupply = sum;
196 		owner.transfer(msg.value);
197 		if (!bSend){
198     		buyers.push(Buyer(msg.sender, tokens));
199 	    	Transfer(msg.sender, owner, msg.value);
200 		} else {
201 	        balances[msg.sender] = balances[msg.sender].add(tokens);
202 		    balances[owner] = balances[owner].sub(tokens);		    
203             Transfer(msg.sender, owner, msg.value);
204 		}
205 	}
206    
207 	function totalSupply() constant returns (uint totalSupply){
208 		return _totalSupply;
209 	}
210    
211 	function balanceOf(address _owner) constant returns (uint balance){
212 		return balances[_owner];
213 	}
214 
215 	function enablePurchasing() onlyOwner {
216 		purchasingAllowed = true;
217 	}
218 	
219 	function disablePurchasing() onlyOwner {
220 		purchasingAllowed = false;
221 	}   
222 	
223 	function enableBonus() onlyOwner {
224 		bonusAllowed = true;
225 	}
226 	
227 	function disableBonus() onlyOwner {
228 		bonusAllowed = false;
229 	}   
230 
231 	function transfer(address _to, uint256 _value) returns (bool success){
232 		require(balances[msg.sender] >= _value	&& _value > 0);
233 		balances[msg.sender] = balances[msg.sender].sub(_value);
234 		balances[_to] = balances[_to].add(_value);
235 		Transfer(msg.sender, _to, _value);
236 		return true;
237 	}
238    
239 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
240 		require(allowed[_from][msg.sender] >= _value && balances[msg.sender] >= _value	&& _value > 0);
241 		balances[_from] = balances[_from].sub(_value);
242 		balances[_to] = balances[_to].add(_value);
243 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244 		Transfer(_from, _to, _value);
245 		return true;
246 	}
247    
248 	function approve(address _spender, uint256 _value) returns (bool success){
249 		allowed[msg.sender][_spender] = _value;
250 		Approval(msg.sender, _spender, _value);
251 		return true;
252 	}
253    
254 	function allowance(address _owner, address _spender) constant returns (uint remaining){
255 		return allowed[_owner][_spender];
256 	}
257 	
258 	function burnAll() onlyOwner public {		
259 		address burner = msg.sender;
260 		uint256 total = balances[burner];
261 		if (total > CREATOR_TOKEN_END) {
262 			total = total.sub(CREATOR_TOKEN_END);
263 			balances[burner] = balances[burner].sub(total);
264 			if (_totalSupply >= total){
265 				_totalSupply = _totalSupply.sub(total);
266 			}
267 			Burn(burner, total);
268 		}
269 	}
270 	
271 	function burn(uint256 _value) onlyOwner public {
272         require(_value > 0);
273         require(_value <= balances[msg.sender]);
274 		_value = _value.mul(10 ** decimals);
275         address burner = msg.sender;
276 		uint t = balances[burner].sub(_value);
277 		require(t >= CREATOR_TOKEN_END);
278         balances[burner] = balances[burner].sub(_value);
279         if (_totalSupply >= _value){
280 			_totalSupply = _totalSupply.sub(_value);
281 		}
282         Burn(burner, _value);
283 	}
284 		
285     function mintToken(uint256 _value) onlyOwner public {
286         require(_value > 0);
287 		_value = _value.mul(10 ** decimals);
288         balances[owner] = balances[owner].add(_value);
289         _totalSupply = _totalSupply.add(_value);
290         Transfer(0, this, _value);
291     }
292 	
293 	function TransferTokens() onlyOwner public {
294 	    for (uint i = 0; i<buyers.length; i++){
295     		balances[buyers[i].to] = balances[buyers[i].to].add(buyers[i].value);
296     		balances[owner] = balances[owner].sub(buyers[i].value);
297 	        Transfer(owner, buyers[i].to, buyers[i].value);
298 	    }
299 	    delete buyers;
300 	}
301 	
302 	event Transfer(address indexed _from, address indexed _to, uint _value);
303 	event Approval(address indexed _owner, address indexed _spender, uint _value);
304 	event Burn(address indexed burner, uint256 value);	   
305 }