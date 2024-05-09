1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath{
5   	function mul(uint256 a, uint256 b) internal pure returns (uint256)
6     	{
7 		uint256 c = a * b;
8 		assert(a == 0 || c / a == b);
9 
10 		return c;
11   	}
12 
13   	function div(uint256 a, uint256 b) internal pure returns (uint256)
14 	{
15 		uint256 c = a / b;
16 
17 		return c;
18   	}
19 
20   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
21 	{
22 		assert(b <= a);
23 
24 		return a - b;
25   	}
26 
27   	function add(uint256 a, uint256 b) internal pure returns (uint256)
28 	{
29 		uint256 c = a + b;
30 		assert(c >= a);
31 
32 		return c;
33   	}
34 }
35 
36 contract Ownable
37 {
38   	address public Owner_master;
39   	address public Owner_creator;
40   	address public Owner_manager;
41 
42   	event ChangeOwner_master(address indexed _from, address indexed _to);
43   	event ChangeOwner_creator(address indexed _from, address indexed _to);
44   	event ChangeOwner_manager(address indexed _from, address indexed _to);
45 
46   	modifier onlyOwner_master{ 
47           require(msg.sender == Owner_master);	_; 	}
48   	modifier onlyOwner_creator{ 
49           require(msg.sender == Owner_creator); _; }
50   	modifier onlyOwner_manager{ 
51           require(msg.sender == Owner_manager); _; }
52   	constructor() public { 
53           Owner_master = msg.sender; }
54   	
55     
56     
57     
58     
59     
60     function transferOwnership_master(address _to) onlyOwner_master public{
61         	require(_to != Owner_master);
62         	require(_to != Owner_creator);
63         	require(_to != Owner_manager);
64         	require(_to != address(0x0));
65 
66 		address from = Owner_master;
67   	    	Owner_master = _to;
68   	    
69   	    	emit ChangeOwner_master(from, _to);}
70 
71   	function transferOwner_creator(address _to) onlyOwner_master public{
72 	        require(_to != Owner_master);
73         	require(_to != Owner_creator);
74         	require(_to != Owner_manager);
75 	        require(_to != address(0x0));
76 
77 		address from = Owner_creator;        
78 	    	Owner_creator = _to;
79         
80     		emit ChangeOwner_creator(from, _to);}
81 
82   	function transferOwner_manager(address _to) onlyOwner_master public{
83 	        require(_to != Owner_master);
84 	        require(_to != Owner_creator);
85         	require(_to != Owner_manager);
86 	        require(_to != address(0x0));
87         	
88 		address from = Owner_manager;
89     		Owner_manager = _to;
90         
91 	    	emit ChangeOwner_manager(from, _to);}
92 }
93 
94 contract Helper
95 {
96     event Transfer( address indexed _from, address indexed _to, uint _value);
97     event Approval( address indexed _owner, address indexed _spender, uint _value);
98     
99     function totalSupply() view public returns (uint _supply);
100     function balanceOf( address _who ) public view returns (uint _value);
101     function transfer( address _to, uint _value) public returns (bool _success);
102     function approve( address _spender, uint _value ) public returns (bool _success);
103     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
104     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
105 }
106 
107 contract SBtesting is Helper, Ownable
108 {
109     using SafeMath for uint;
110     
111     string public name;
112     string public symbol;
113     uint public decimals;
114     
115     uint constant private zeroAfterDecimal = 10**18;
116     
117     uint constant public maxSupply             = 2500000 * zeroAfterDecimal;
118     
119     uint constant public maxSupply_SeedBlock        =   2500000 * zeroAfterDecimal;
120 
121     
122     uint public issueToken_Total;
123     
124     uint public issueToken_SeedBlock;
125     
126     uint public burnTokenAmount;
127     
128     mapping (address => uint) public balances;
129     mapping (address => mapping ( address => uint )) public approvals;
130 
131     bool public tokenLock = true;
132     bool public saleTime = true;
133     uint public endSaleTime = 0;
134     
135     event Burn(address indexed _from, uint _value);
136     
137     event Issue_SeedBlock(address indexed _to, uint _tokens);
138     
139     event TokenUnLock(address indexed _to, uint _tokens);
140 
141     
142     constructor() public
143     {
144         name        = "SBtesting";
145         decimals    = 18;
146         symbol      = "SBtest";
147         
148         issueToken_Total      = 0;
149         
150         issueToken_SeedBlock     = 0;
151 
152         
153         require(maxSupply == maxSupply_SeedBlock);
154 
155     }
156     
157     // ERC - 20 Interface -----
158 
159     function totalSupply() view public returns (uint) {
160         return issueToken_Total;}
161     
162     function balanceOf(address _who) view public returns (uint) {
163         uint balance = balances[_who];
164         
165         return balance;}
166     
167     function transfer(address _to, uint _value) public returns (bool) {
168         require(isTransferable() == true);
169         require(balances[msg.sender] >= _value);
170         
171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         
174         emit Transfer(msg.sender, _to, _value);
175         
176         return true;}
177     
178     function approve(address _spender, uint _value) public returns (bool){
179         require(isTransferable() == true);
180         require(balances[msg.sender] >= _value);
181         
182         approvals[msg.sender][_spender] = _value;
183         
184         emit Approval(msg.sender, _spender, _value);
185         
186         return true; }
187     
188     function allowance(address _owner, address _spender) view public returns (uint) {
189         return approvals[_owner][_spender];}
190 
191     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
192         require(isTransferable() == true);
193         require(balances[_from] >= _value);
194         require(approvals[_from][msg.sender] >= _value);
195         
196         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to]  = balances[_to].add(_value);
199         
200         emit Transfer(_from, _to, _value);
201         
202         return true;}
203     
204     // -----
205     
206     // Issue Function -----
207 
208 
209     function issue_noVesting_Public(address _to, uint _value) onlyOwner_creator public
210     {
211         uint tokens = _value * zeroAfterDecimal;
212         require(maxSupply_SeedBlock >= issueToken_SeedBlock.add(tokens));
213         
214         balances[_to] = balances[_to].add(tokens);
215         
216         issueToken_Total = issueToken_Total.add(tokens);
217         issueToken_SeedBlock = issueToken_SeedBlock.add(tokens);
218         
219         emit Issue_SeedBlock(_to, tokens);
220     }    
221     
222        // Lock Function -----
223     
224     function isTransferable() private view returns (bool)
225     {
226         if(tokenLock == false)
227         {
228             return true;
229         }
230         else if(msg.sender == Owner_manager)
231         {
232             return true;
233         }
234         
235         return false;
236     }
237     
238     function setTokenUnlock() onlyOwner_manager public
239     {
240         require(tokenLock == true);
241         require(saleTime == false);
242         
243         tokenLock = false;
244     }
245     
246     function setTokenLock() onlyOwner_manager public
247     {
248         require(tokenLock == false);
249         
250         tokenLock = true;
251     }
252     
253     // -----
254     
255     // ETC / Burn Function -----
256     
257     function () payable external
258     {
259         revert();
260     }
261     
262     function endSale() onlyOwner_manager public
263     {
264         require(saleTime == true);
265         
266         saleTime = false;
267         
268         uint time = now;
269         
270         endSaleTime = time;
271         
272     }
273     
274     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner_manager public
275     {
276 
277         if(_contract == address(0x0))
278         {
279             uint eth = _value.mul(10 ** _decimals);
280             msg.sender.transfer(eth);
281         }
282         else
283         {
284             uint tokens = _value.mul(10 ** _decimals);
285             Helper(_contract).transfer(msg.sender, tokens);
286             
287             emit Transfer(address(0x0), msg.sender, tokens);
288         }
289     }
290     
291     function burnToken(uint _value) onlyOwner_manager public
292     {
293         uint tokens = _value * zeroAfterDecimal;
294         
295         require(balances[msg.sender] >= tokens);
296         
297         balances[msg.sender] = balances[msg.sender].sub(tokens);
298         
299         burnTokenAmount = burnTokenAmount.add(tokens);
300         issueToken_Total = issueToken_Total.sub(tokens);
301         
302         emit Burn(msg.sender, tokens);
303     }
304     
305     function close() onlyOwner_master public
306     {
307         selfdestruct(msg.sender);
308     }
309     
310     // -----
311 }