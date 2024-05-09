1 pragma solidity ^0.4.18;
2 
3 interface IERC20 {
4 	function TotalSupply() constant returns (uint totalSupply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 
15 /**
16 * @title SafeMath
17 * @dev Math operations with safety checks that throw on error
18 */
19 library SafeMath {
20 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21 		uint256 c = a * b;
22 		assert(a == 0 || c / a == b);
23 		return c;
24 	}
25 
26 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
27 		// assert(b > 0); // Solidity automatically throws when dividing by 0
28 		uint256 c = a / b;
29 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 		return c;
31 	}
32 
33 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34 		assert(b <= a);
35 		return a - b;
36 	}
37 
38 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
39 		uint256 c = a + b;
40 		assert(c >= a);
41 		return c;
42 	}
43 }
44 
45 
46 
47 contract PosteCoin is IERC20{
48 	using SafeMath for uint256;
49 
50 	uint256 public _totalSupply = 0;
51 
52 	bool public purchasingAllowed = true;
53 	bool public bonusAllowed = true;	
54 
55 	string public symbol = "PTC";//Simbolo del token es. ETH
56 	string public constant name = "PosteCoin"; //Nome del token es. Ethereum
57 	uint256 public constant decimals = 18; //Numero di decimali del token, il bitcoin ne ha 8, ethereum 18
58 
59 	uint256 public CREATOR_TOKEN = 15000000 * 10**decimals; //Numero massimo di token da emettere 
60 	uint256 public CREATOR_TOKEN_END = 1200000 * 10**decimals;	//numero di token rimanenti al creatore 
61 	uint256 public constant RATE = 500; //Quanti token inviare per ogni ether ricevuto
62 	uint constant LENGHT_BONUS = 1 * 5 minutes;	//durata periodo bonus
63 	uint constant PERC_BONUS = 50; //Percentuale token bonus
64 	uint constant LENGHT_BONUS2 = 1 * 3 minutes;	//durata periodo bonus
65 	uint constant PERC_BONUS2 = 20; //Percentuale token bonus
66 	uint constant LENGHT_BONUS3 = 1 * 2 minutes;	//durata periodo bonus
67 	uint constant PERC_BONUS3 = 10; //Percentuale token bonus
68 	uint constant LENGHT_BONUS4 = 1 * 2 minutes;	//durata periodo bonus
69 	uint constant PERC_BONUS4 = 5; //Percentuale token bonus
70 		
71 	address public owner;
72 
73 	mapping(address => uint256) balances;
74 	mapping(address => mapping(address => uint256)) allowed;
75 
76 	uint start;
77 	uint end;
78 	uint end2;
79 	uint end3;
80 	uint end4;
81 	
82 	//Funzione che permette di ricevere token solo specificando l'indirizzo
83 	function() payable{
84 		require(purchasingAllowed);		
85 		createTokens();
86 	}
87    
88 	//Salviamo l'indirizzo del creatore del contratto per inviare gli ether ricevuti
89 	function PosteCoin(){
90 		owner = msg.sender;
91 		balances[msg.sender] = CREATOR_TOKEN;
92 		start = now;
93 		end = now.add(LENGHT_BONUS);	//fine periodo bonus
94 		end2 = end.add(LENGHT_BONUS2);	//fine periodo bonus
95 		end3 = end2.add(LENGHT_BONUS3);	//fine periodo bonus
96 		end4 = end3.add(LENGHT_BONUS4);	//fine periodo bonus
97 	}
98    
99 	//Creazione dei token
100 	function createTokens() payable{
101 		require(msg.value >= 0);
102 		uint256 tokens = msg.value.mul(10 ** decimals);
103 		tokens = tokens.mul(RATE);
104 		tokens = tokens.div(10 ** 18);
105 		if (bonusAllowed)
106 		{
107 			if (now >= start && now < end)
108 			{
109 			tokens += tokens.mul(PERC_BONUS).div(100);
110 			}
111 			if (now >= end && now < end2)
112 			{
113 			tokens += tokens.mul(PERC_BONUS2).div(100);
114 			}
115 			if (now >= end2 && now < end3)
116 			{
117 			tokens += tokens.mul(PERC_BONUS3).div(100);
118 			}
119 			if (now >= end3 && now < end4)
120 			{
121 			tokens += tokens.mul(PERC_BONUS4).div(100);
122 			}
123 		}
124 		uint256 sum2 = balances[owner].sub(tokens);		
125 		require(sum2 >= CREATOR_TOKEN_END);
126 		uint256 sum = _totalSupply.add(tokens);		
127 		balances[msg.sender] = balances[msg.sender].add(tokens);
128 		balances[owner] = balances[owner].sub(tokens);
129 		_totalSupply = sum;
130 		owner.transfer(msg.value);
131 		Transfer(owner, msg.sender, tokens);
132 	}
133    
134 	//Ritorna il numero totale di token
135 	function TotalSupply() constant returns (uint totalSupply){
136 		return _totalSupply;
137 	}
138    
139 	//Ritorna il bilancio dell'utente di un indirizzo
140 	function balanceOf(address _owner) constant returns (uint balance){
141 		return balances[_owner];
142 	}
143 	
144 	//Abilita l'acquisto di token
145 	function enablePurchasing() {
146 		require(msg.sender == owner); 
147 		purchasingAllowed = true;
148 	}
149 	
150 	//Disabilita l'acquisto di token
151 	function disablePurchasing() {
152 		require(msg.sender == owner);
153 		purchasingAllowed = false;
154 	}   
155 	
156 	//Abilita la distribuzione di bonus
157 	function enableBonus() {
158 		require(msg.sender == owner); 
159 		bonusAllowed = true;
160 	}
161 	
162 	//Disabilita la distribuzione di bonus
163 	function disableBonus() {
164 		require(msg.sender == owner);
165 		bonusAllowed = false;
166 	}   
167 
168 	//Per inviare i Token
169 	function transfer(address _to, uint256 _value) returns (bool success){
170 		require(balances[msg.sender] >= _value	&& _value > 0);
171 		balances[msg.sender] = balances[msg.sender].sub(_value);
172 		balances[_to] = balances[_to].add(_value);
173 		Transfer(msg.sender, _to, _value);
174 		return true;
175 	}
176    
177 	//Invio dei token con delega
178 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
179 		require(allowed[_from][msg.sender] >= _value && balances[msg.sender] >= _value	&& _value > 0);
180 		balances[_from] = balances[_from].sub(_value);
181 		balances[_to] = balances[_to].add(_value);
182 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183 		Transfer(_from, _to, _value);
184 		return true;
185 	}
186    
187 	//Delegare qualcuno all'invio di token
188 	function approve(address _spender, uint256 _value) returns (bool success){
189 		allowed[msg.sender][_spender] = _value;
190 		Approval(msg.sender, _spender, _value);
191 		return true;
192 	}
193    
194 	//Ritorna il numero di token che un delegato può ancora inviare
195 	function allowance(address _owner, address _spender) constant returns (uint remaining){
196 		return allowed[_owner][_spender];
197 	}
198 	
199 	//brucia tutti i token rimanenti
200 	function burnAll() public {		
201 		require(msg.sender == owner);
202 		address burner = msg.sender;
203 		uint256 total = balances[burner];
204 		if (total > CREATOR_TOKEN_END) {
205 			total = total.sub(CREATOR_TOKEN_END);
206 			balances[burner] = balances[burner].sub(total);
207 			if (_totalSupply >= total){
208 				_totalSupply = _totalSupply.sub(total);
209 			}
210 			Burn(burner, total);
211 		}
212 	}
213 	
214 	//brucia la quantita' _value di token
215 	function burn(uint256 _value) public {
216 		require(msg.sender == owner);
217         require(_value > 0);
218         require(_value <= balances[msg.sender]);
219 		_value = _value.mul(10 ** decimals);
220         address burner = msg.sender;
221 		uint t = balances[burner].sub(_value);
222 		require(t >= CREATOR_TOKEN_END);
223         balances[burner] = balances[burner].sub(_value);
224         if (_totalSupply >= _value){
225 			_totalSupply = _totalSupply.sub(_value);
226 		}
227         Burn(burner, _value);
228 	}
229 	
230 	event Transfer(address indexed _from, address indexed _to, uint _value);
231 	event Approval(address indexed _owner, address indexed _spender, uint _value);
232 	event Burn(address indexed burner, uint256 value);	   
233 }