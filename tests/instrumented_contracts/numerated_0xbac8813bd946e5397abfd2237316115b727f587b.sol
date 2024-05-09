1 pragma solidity ^0.4.25;
2 
3 contract BasicERC20token {
4 
5     uint256 constant MAX_UINT256 = 2**256 - 1;
6     uint256 public totalSupply;
7     string public name;
8     uint8 public decimals;
9     string public symbol;
10     string public version = 'smartmachine_basic_erc20_token_01';
11     address public creator;
12     uint public init;
13     address public Factory;
14     mapping (address => uint256) balances;
15     mapping (address => mapping (address => uint256)) allowed;
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     constructor() public {}
21 
22     function transfer(address _to, uint256 _value) public returns (bool success) {
23         require(balances[msg.sender] >= _value);
24         balances[msg.sender] -= _value;
25         balances[_to] += _value;
26         emit Transfer(msg.sender, _to, _value);
27         return true;
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
31         uint256 allowance = allowed[_from][msg.sender];
32         require(balances[_from] >= _value && allowance >= _value);
33         balances[_to] += _value;
34         balances[_from] -= _value;
35         if (allowance < MAX_UINT256) {
36             allowed[_from][msg.sender] -= _value;
37         }
38         emit Transfer(_from, _to, _value);
39         return true;
40     }
41 
42     function balanceOf(address _owner) public constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         emit Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
53       return allowed[_owner][_spender];
54     }
55 
56     /* Approves and then calls the receiving contract */
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         emit Approval(msg.sender, _spender, _value);
60         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
61         return true;
62     }
63 
64 
65     function init(
66         uint256 _initialAmount,
67         string _tokenName,
68         uint8 _decimalUnits,
69         string _tokenSymbol,
70         address _owner
71         ) public returns (bool){
72         if(init>0)revert();
73         balances[_owner] = _initialAmount;
74         totalSupply = _initialAmount;
75         name = _tokenName; 
76         decimals = _decimalUnits;
77         symbol = _tokenSymbol;   
78         creator=_owner;
79         Factory=msg.sender;
80         init=1;
81         return true;
82     }
83 
84     function init2(
85         uint256 _initialAmount,
86         string _tokenName,
87         uint8 _decimalUnits,
88         string _tokenSymbol,
89         address _owner,
90         address _freebie
91         ) public returns (bool){
92         if(init>0)revert();
93         FloodNameSys flood= FloodNameSys(address(0x63030f02d4B18acB558750db1Dc9A2F3961531eE));
94         uint256 p=flood.freebiePercentage();
95         if(_initialAmount>1000){
96             balances[_owner] = _initialAmount-((_initialAmount/1000)*p);
97             balances[_freebie] = (_initialAmount/1000)*p;
98         }else{
99             balances[_owner] = _initialAmount;
100         }
101         totalSupply = _initialAmount;
102         name = _tokenName;
103         decimals = _decimalUnits;
104         symbol = _tokenSymbol;   
105         creator=_owner;
106         Factory=msg.sender;
107         init=1;
108         return true;
109     }
110 }
111 
112 contract FloodNameSys{
113 
114 	address public owner;
115 	bool public gift;
116 	uint256 public giftAmount;
117 	address[] public list;
118 	BasicERC20token public flood;
119 	uint256 public cost;
120 	uint256 public freebiePercentage;
121 	uint256 public totalCoins;
122 	uint256 public totalFreeCoins;
123 	mapping(address => address[]) public created;
124 	mapping(address => address[]) public generated;
125 	mapping(address => address) public generator;
126 	mapping(address => bool) public permission;
127 	mapping(string => bool) names;
128 	mapping(string => bool) symbols;
129 	mapping(string => address) namesAddress;
130 	mapping(string => address) symbolsAddress;
131 	mapping(address => string)public tokenNames;
132 	mapping(address => string)public tokenSymbols;
133 
134 
135 	constructor() public{
136 		owner=msg.sender;
137 		permission[msg.sender]=true;
138 	}
139 
140 	function setCost(uint256 c) public{
141        		if(msg.sender!=owner)revert();
142        		cost=c;
143 	}
144 
145 	function setFreePerc(uint256 p) public{
146        		if(msg.sender!=owner)revert();
147        		freebiePercentage=p;
148 	}
149 
150 
151 	function setGiftToken(address _flood)public{
152 		if(msg.sender!=owner)revert();
153 		flood=BasicERC20token(_flood);
154 	}
155 
156 	function enableGift(bool b) public{
157 		if(msg.sender!=owner)revert();
158 		gift=b;
159 	}
160 
161 	function setGiftAmount(uint256 u) public{
162 		if(msg.sender!=owner)revert();
163 	giftAmount=u;
164 	}
165 
166 	function lockName(string _name,string _symbol,bool b) public{
167 		if(!permission[msg.sender])revert();
168 		names[_name]=b;
169 		symbols[_symbol]=b;
170 	}
171 
172 	function deleteToken(address a)public{
173 		if(!permission[msg.sender])revert();
174 		names[tokenNames[a]]=false;
175 		namesAddress[tokenNames[a]]=address(0x0);
176 		tokenNames[a]="";
177 		symbols[tokenSymbols[a]]=false;
178 		symbolsAddress[tokenSymbols[a]]=address(0x0);
179 		tokenSymbols[a]="";
180 	}
181 
182 	function add(address token,address own,string _name,string _symbol,bool free) public returns (bool){
183 		if((!permission[msg.sender])||(names[_name])||(symbols[_symbol]))revert();
184 		if(free){
185 			created[own].push(address(token));
186 			totalFreeCoins++;
187 		}else{
188 			created[own].push(address(token));
189 			list.push(address(token));
190 			names[_name]=true;
191 			tokenNames[token]=_name;
192 			namesAddress[_name]=token;
193 			symbols[_symbol]=true;
194 			tokenSymbols[token]=_symbol;
195 			symbolsAddress[_symbol]=token;
196 			if(gift)flood.transfer(own,giftAmount);
197 		}
198 		generator[token]=msg.sender;
199 		generated[msg.sender].push(token);
200 		totalCoins++;
201 		return true;
202 	}
203 
204 	function setOwner(address o)public{
205 		if(msg.sender!=owner)revert();
206 		owner=o;
207 	}
208 
209 	function setPermission(address a,bool b)public{
210 		if(msg.sender!=owner)revert();
211 		permission[a]=b;
212 	}
213 
214 	function getMyTokens(address own,uint i)public constant returns(address,uint){
215 		return (created[own][i],created[own].length);
216 	}
217 
218 	function getGeneratorTokens(address gen,uint i)public constant returns(address,uint){
219 		return (generated[gen][i],generated[gen].length);
220 	}
221 
222 	function getTokenIndex(uint i)public constant returns(address,uint){
223 		return (list[i],list.length);
224 	}
225 
226 	function getToken(address _token)public constant returns(string,string){
227 		return (tokenNames[_token],tokenSymbols[_token]);
228 	}
229 
230 	function checkName(string _name)public constant returns(bool){return names[_name];}
231 
232 	function checkSymbol(string _symbol)public constant returns(bool){return symbols[_symbol];}
233 
234 	function findName(string _name)public constant returns(address){return namesAddress[_name];}
235 
236 	function findSymbol(string _symbol)public constant returns(address){return symbolsAddress[_symbol];}
237 }
238 
239 
240 contract basic_erc20_token_factory {
241 
242     address public owner;
243     FloodNameSys public nsys;
244     address public wallet;
245 
246     constructor() public{
247       owner=msg.sender;
248     }
249 
250     function setOwner(address a) public{
251        if(msg.sender!=owner)revert();
252        owner=a;
253     }
254     
255     function setWallet(address a) public{
256        if(msg.sender!=owner)revert();
257        wallet=a;
258     }
259 
260 
261     function setNameSys(address l) public{
262         if(msg.sender!=owner)revert();
263         nsys=FloodNameSys(l);
264     }
265 
266 
267     function createToken(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol)public payable{
268         BasicERC20token newToken = new BasicERC20token();
269         uint256 c=nsys.cost();
270         if(msg.value>=c){
271             wallet.transfer(msg.value);
272             if(!newToken.init(_initialAmount, _name, _decimals, _symbol,msg.sender))revert();
273             if(!nsys.add(address(newToken),msg.sender,_name,_symbol,false))revert();
274         }else{
275             if(!newToken.init2(_initialAmount, _name, _decimals, _symbol,msg.sender,wallet))revert();
276             if(!nsys.add(address(newToken),msg.sender,_name,_symbol,true))revert();
277             
278         }
279     }
280 
281 }