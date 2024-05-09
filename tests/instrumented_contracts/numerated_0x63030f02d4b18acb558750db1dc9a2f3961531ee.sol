1 pragma solidity ^0.4.25;
2 
3 contract FloodToken {
4 
5     uint256 constant MAX_UINT256 = 2**256 - 1;
6     uint256 public totalSupply;
7     string public name;
8     uint8 public decimals;
9     string public symbol;
10     string public version = 'FLOOD0.1';
11     address public creator;
12     bool public burnt;
13     uint public init;
14     address public Factory;
15     mapping (address => uint256) balances;
16     mapping (address => mapping (address => uint256)) allowed;
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21     constructor() public {}
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require(balances[msg.sender] >= _value);
25         balances[msg.sender] -= _value;
26         balances[_to] += _value;
27         emit Transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
32         uint256 allowance = allowed[_from][msg.sender];
33         require(balances[_from] >= _value && allowance >= _value);
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         if (allowance < MAX_UINT256) {
37             allowed[_from][msg.sender] -= _value;
38         }
39         emit Transfer(_from, _to, _value);
40         return true;
41     }
42 
43     function balanceOf(address _owner) public constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) public returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         emit Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     function burn(uint _amount) public returns (uint256 remaining) {
58     	if(balances[msg.sender]>=_amount){
59     		if(totalSupply>=_amount){
60     			transfer(address(0x0), _amount);
61     			balances[address(0x0)]-=_amount;
62     			totalSupply-=_amount;
63     		}
64     	}
65         return balances[msg.sender];
66     }
67 
68     /* Approves and then calls the receiving contract */
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
73         return true;
74     }
75 
76 
77     function init(
78         uint256 _initialAmount,
79         string _tokenName,
80         uint8 _decimalUnits,
81         string _tokenSymbol,
82         address _owner
83         ) public returns (bool){
84         if(init>0)revert();
85         balances[_owner] = _initialAmount;
86         totalSupply = _initialAmount;
87         name = _tokenName; 
88         decimals = _decimalUnits;
89         symbol = _tokenSymbol;   
90         creator=_owner;
91         Factory=msg.sender;
92         burnt=false;
93         init=1;
94         return true;
95     }
96 
97     function init2(
98         uint256 _initialAmount,
99         string _tokenName,
100         uint8 _decimalUnits,
101         string _tokenSymbol,
102         address _owner,
103         address _freebie
104         ) public returns (bool){
105         if(init>0)revert();
106         FloodNameSys flood= FloodNameSys(msg.sender);
107         balances[_owner] = _initialAmount-((_initialAmount/1000)*flood.freebiePercentage());
108         balances[_freebie] = (_initialAmount/1000)*flood.freebiePercentage();
109         totalSupply = _initialAmount;
110         name = _tokenName;
111         decimals = _decimalUnits;
112         symbol = _tokenSymbol;   
113         creator=_owner;
114         Factory=msg.sender;
115         burnt=false;
116         init=1;
117         return true;
118     }
119 }
120 
121 contract FloodNameSys{
122 
123 	address public owner;
124 	bool public gift;
125 	uint256 public giftAmount;
126 	address[] public list;
127 	FloodToken public flood;
128 	uint256 public cost;
129 	uint256 public freebiePercentage;
130 	uint256 public totalCoins;
131 	uint256 public totalFreeCoins;
132 	mapping(address => address[]) public created;
133 	mapping(address => address[]) public generated;
134 	mapping(address => address) public generator;
135 	mapping(address => bool) public permission;
136 	mapping(string => bool) names;
137 	mapping(string => bool) symbols;
138 	mapping(string => address) namesAddress;
139 	mapping(string => address) symbolsAddress;
140 	mapping(address => string)public tokenNames;
141 	mapping(address => string)public tokenSymbols;
142 
143 
144 	constructor() public{
145 		owner=msg.sender;
146 		permission[msg.sender]=true;
147 	}
148 
149 	function setCost(uint256 c) public{
150        		if(msg.sender!=owner)revert();
151        		cost=c;
152 	}
153 
154 	function setFreePerc(uint256 p) public{
155        		if(msg.sender!=owner)revert();
156        		freebiePercentage=p;
157 	}
158 
159 
160 	function setGiftToken(address _flood)public{
161 		if(msg.sender!=owner)revert();
162 		flood=FloodToken(_flood);
163 	}
164 
165 	function enableGift(bool b) public{
166 		if(msg.sender!=owner)revert();
167 		gift=b;
168 	}
169 
170 	function setGiftAmount(uint256 u) public{
171 		if(msg.sender!=owner)revert();
172 	giftAmount=u;
173 	}
174 
175 	function lockName(string _name,string _symbol,bool b) public{
176 		if(!permission[msg.sender])revert();
177 		names[_name]=b;
178 		symbols[_symbol]=b;
179 	}
180 
181 	function deleteToken(address a)public{
182 		if(!permission[msg.sender])revert();
183 		names[tokenNames[a]]=false;
184 		namesAddress[tokenNames[a]]=address(0x0);
185 		tokenNames[a]="";
186 		symbols[tokenSymbols[a]]=false;
187 		symbolsAddress[tokenSymbols[a]]=address(0x0);
188 		tokenSymbols[a]="";
189 	}
190 
191 	function add(address token,address own,string _name,string _symbol,bool free) public returns (bool){
192 		if((!permission[msg.sender])||(names[_name])||(symbols[_symbol]))revert();
193 		if(free){
194 			created[own].push(address(token));
195 			totalFreeCoins++;
196 		}else{
197 			created[own].push(address(token));
198 			list.push(address(token));
199 			names[_name]=true;
200 			tokenNames[token]=_name;
201 			namesAddress[_name]=token;
202 			symbols[_symbol]=true;
203 			tokenSymbols[token]=_symbol;
204 			symbolsAddress[_symbol]=token;
205 			if(gift)flood.transfer(own,giftAmount);
206 		}
207 		generator[token]=msg.sender;
208 		generated[msg.sender].push(token);
209 		totalCoins++;
210 		return true;
211 	}
212 
213 	function setOwner(address o)public{
214 		if(msg.sender!=owner)revert();
215 		owner=o;
216 	}
217 
218 	function setPermission(address a,bool b)public{
219 		if(msg.sender!=owner)revert();
220 		permission[a]=b;
221 	}
222 
223 	function getMyTokens(address own,uint i)public constant returns(address,uint){
224 		return (created[own][i],created[own].length);
225 	}
226 
227 	function getGeneratorTokens(address gen,uint i)public constant returns(address,uint){
228 		return (generated[gen][i],generated[gen].length);
229 	}
230 
231 	function getTokenIndex(uint i)public constant returns(address,uint){
232 		return (list[i],list.length);
233 	}
234 
235 	function getToken(address _token)public constant returns(string,string){
236 		return (tokenNames[_token],tokenSymbols[_token]);
237 	}
238 
239 	function checkName(string _name)public constant returns(bool){return names[_name];}
240 
241 	function checkSymbol(string _symbol)public constant returns(bool){return symbols[_symbol];}
242 
243 	function findName(string _name)public constant returns(address){return namesAddress[_name];}
244 
245 	function findSymbol(string _symbol)public constant returns(address){return symbolsAddress[_symbol];}
246 }
247 
248 
249 contract BasicStandardTokenFactory {
250 
251     address public owner;
252     FloodNameSys public nsys;
253     address public wallet;
254 
255     constructor() public{
256       owner=msg.sender;
257     }
258 
259     function setOwner(address a) public{
260        if(msg.sender!=owner)revert();
261        owner=a;
262     }
263     
264     function setWallet(address a) public{
265        if(msg.sender!=owner)revert();
266        wallet=a;
267     }
268 
269 
270     function setNameSys(address l) public{
271         if(msg.sender!=owner)revert();
272         nsys=FloodNameSys(l);
273     }
274 
275 
276     function createToken(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol)public payable{
277         FloodToken newToken = new FloodToken();
278         if(msg.value>=nsys.cost()){
279             wallet.transfer(msg.value);
280             if(!newToken.init(_initialAmount, _name, _decimals, _symbol,msg.sender))revert();
281             if(!nsys.add(address(newToken),msg.sender,_name,_symbol,false))revert();
282         }else{
283             if(!newToken.init2(_initialAmount, _name, _decimals, _symbol,msg.sender,wallet))revert();
284             if(!nsys.add(address(newToken),msg.sender,_name,_symbol,true))revert();
285             
286         }
287     }
288 
289 }