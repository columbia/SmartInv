1 pragma solidity ^0.4.25;
2 
3 contract BurnableToken {
4 
5     uint256 constant MAX_UINT256 = 2**256 - 1;
6     uint256 public totalSupply;
7     string public name;
8     uint8 public decimals;
9     string public symbol;
10     string public version = 'FLOOD-BURNABLE-0.3';
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
56     function burn(uint _amount) public returns (uint256 remaining) {
57     	if(balances[msg.sender]>=_amount){
58     		if(totalSupply>=_amount){
59     			transfer(address(0x0), _amount);
60     			balances[address(0x0)]-=_amount;
61     			totalSupply-=_amount;
62     		}
63     	}
64         return balances[msg.sender];
65     }
66 
67     /* Approves and then calls the receiving contract */
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
72         return true;
73     }
74 
75 
76     function init(
77         uint256 _initialAmount,
78         string _tokenName,
79         uint8 _decimalUnits,
80         string _tokenSymbol,
81         address _owner
82         ) public returns (bool){
83         if(init>0)revert();
84         balances[_owner] = _initialAmount;
85         totalSupply = _initialAmount;
86         name = _tokenName; 
87         decimals = _decimalUnits;
88         symbol = _tokenSymbol;   
89         creator=_owner;
90         Factory=msg.sender;
91         init=1;
92         return true;
93     }
94 
95     function init2(
96         uint256 _initialAmount,
97         string _tokenName,
98         uint8 _decimalUnits,
99         string _tokenSymbol,
100         address _owner,
101         address _freebie
102         ) public returns (bool){
103         if(init>0)revert();
104         FloodNameSys flood= FloodNameSys(address(0x63030f02d4B18acB558750db1Dc9A2F3961531eE));
105         uint256 p=flood.freebiePercentage();
106         if(_initialAmount>1000){
107             balances[_owner] = _initialAmount-((_initialAmount/1000)*p);
108             balances[_freebie] = (_initialAmount/1000)*p;
109         }else{
110             balances[_owner] = _initialAmount;
111         }
112         totalSupply = _initialAmount;
113         name = _tokenName;
114         decimals = _decimalUnits;
115         symbol = _tokenSymbol;   
116         creator=_owner;
117         Factory=msg.sender;
118         init=1;
119         return true;
120     }
121 }
122 
123 contract FloodNameSys{
124 
125 	address public owner;
126 	bool public gift;
127 	uint256 public giftAmount;
128 	address[] public list;
129 	BurnableToken public flood;
130 	uint256 public cost;
131 	uint256 public freebiePercentage;
132 	uint256 public totalCoins;
133 	uint256 public totalFreeCoins;
134 	mapping(address => address[]) public created;
135 	mapping(address => address[]) public generated;
136 	mapping(address => address) public generator;
137 	mapping(address => bool) public permission;
138 	mapping(string => bool) names;
139 	mapping(string => bool) symbols;
140 	mapping(string => address) namesAddress;
141 	mapping(string => address) symbolsAddress;
142 	mapping(address => string)public tokenNames;
143 	mapping(address => string)public tokenSymbols;
144 
145 
146 	constructor() public{
147 		owner=msg.sender;
148 		permission[msg.sender]=true;
149 	}
150 
151 	function setCost(uint256 c) public{
152        		if(msg.sender!=owner)revert();
153        		cost=c;
154 	}
155 
156 	function setFreePerc(uint256 p) public{
157        		if(msg.sender!=owner)revert();
158        		freebiePercentage=p;
159 	}
160 
161 
162 	function setGiftToken(address _flood)public{
163 		if(msg.sender!=owner)revert();
164 		flood=BurnableToken(_flood);
165 	}
166 
167 	function enableGift(bool b) public{
168 		if(msg.sender!=owner)revert();
169 		gift=b;
170 	}
171 
172 	function setGiftAmount(uint256 u) public{
173 		if(msg.sender!=owner)revert();
174 	giftAmount=u;
175 	}
176 
177 	function lockName(string _name,string _symbol,bool b) public{
178 		if(!permission[msg.sender])revert();
179 		names[_name]=b;
180 		symbols[_symbol]=b;
181 	}
182 
183 	function deleteToken(address a)public{
184 		if(!permission[msg.sender])revert();
185 		names[tokenNames[a]]=false;
186 		namesAddress[tokenNames[a]]=address(0x0);
187 		tokenNames[a]="";
188 		symbols[tokenSymbols[a]]=false;
189 		symbolsAddress[tokenSymbols[a]]=address(0x0);
190 		tokenSymbols[a]="";
191 	}
192 
193 	function add(address token,address own,string _name,string _symbol,bool free) public returns (bool){
194 		if((!permission[msg.sender])||(names[_name])||(symbols[_symbol]))revert();
195 		if(free){
196 			created[own].push(address(token));
197 			totalFreeCoins++;
198 		}else{
199 			created[own].push(address(token));
200 			list.push(address(token));
201 			names[_name]=true;
202 			tokenNames[token]=_name;
203 			namesAddress[_name]=token;
204 			symbols[_symbol]=true;
205 			tokenSymbols[token]=_symbol;
206 			symbolsAddress[_symbol]=token;
207 			if(gift)flood.transfer(own,giftAmount);
208 		}
209 		generator[token]=msg.sender;
210 		generated[msg.sender].push(token);
211 		totalCoins++;
212 		return true;
213 	}
214 
215 	function setOwner(address o)public{
216 		if(msg.sender!=owner)revert();
217 		owner=o;
218 	}
219 
220 	function setPermission(address a,bool b)public{
221 		if(msg.sender!=owner)revert();
222 		permission[a]=b;
223 	}
224 
225 	function getMyTokens(address own,uint i)public constant returns(address,uint){
226 		return (created[own][i],created[own].length);
227 	}
228 
229 	function getGeneratorTokens(address gen,uint i)public constant returns(address,uint){
230 		return (generated[gen][i],generated[gen].length);
231 	}
232 
233 	function getTokenIndex(uint i)public constant returns(address,uint){
234 		return (list[i],list.length);
235 	}
236 
237 	function getToken(address _token)public constant returns(string,string){
238 		return (tokenNames[_token],tokenSymbols[_token]);
239 	}
240 
241 	function checkName(string _name)public constant returns(bool){return names[_name];}
242 
243 	function checkSymbol(string _symbol)public constant returns(bool){return symbols[_symbol];}
244 
245 	function findName(string _name)public constant returns(address){return namesAddress[_name];}
246 
247 	function findSymbol(string _symbol)public constant returns(address){return symbolsAddress[_symbol];}
248 }
249 
250 
251 contract BurnableStandardTokenFactory {
252 
253     address public owner;
254     FloodNameSys public nsys;
255     address public wallet;
256 
257     constructor() public{
258       owner=msg.sender;
259     }
260 
261     function setOwner(address a) public{
262        if(msg.sender!=owner)revert();
263        owner=a;
264     }
265     
266     function setWallet(address a) public{
267        if(msg.sender!=owner)revert();
268        wallet=a;
269     }
270 
271 
272     function setNameSys(address l) public{
273         if(msg.sender!=owner)revert();
274         nsys=FloodNameSys(l);
275     }
276 
277 
278     function createToken(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol)public payable{
279         BurnableToken newToken = new BurnableToken();
280         uint256 c=nsys.cost();
281         if(msg.value>=c){
282             wallet.transfer(msg.value);
283             if(!newToken.init(_initialAmount, _name, _decimals, _symbol,msg.sender))revert();
284             if(!nsys.add(address(newToken),msg.sender,_name,_symbol,false))revert();
285         }else{
286             if(!newToken.init2(_initialAmount, _name, _decimals, _symbol,msg.sender,wallet))revert();
287             if(!nsys.add(address(newToken),msg.sender,_name,_symbol,true))revert();
288             
289         }
290     }
291 
292 }