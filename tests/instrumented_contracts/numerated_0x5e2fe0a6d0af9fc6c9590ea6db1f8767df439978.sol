1 pragma solidity ^0.5.7;
2 //LNSB token can be swapped with LNX when LNX ends its sale. 
3 //LNSB token has 1:1 ratio with LNX token
4 //total number of LNSB is 2,625,000 = 2,500,000(regular sale amount) + 125,000(bonus sale amount)
5 //LNSB token is bound to transaction hash ( 0x15c8982c85033ef01fe55abefd5f5544b9960777ffd80d178bf9839cfccc814c ) and transaction hash (0x52f28919791119b2a9fcef828618f4e9df3302ae596f997902503d47ef940cd7 )
6 //transfer of regular sale amount = 0x15c8982c85033ef01fe55abefd5f5544b9960777ffd80d178bf9839cfccc814c
7 //transfer of bonus sale amount = 0x52f28919791119b2a9fcef828618f4e9df3302ae596f997902503d47ef940cd7
8 //bound LNX token is owned by seedblock( 0xbCaA9Fb04aBBCD5C39f7681028bdbd597E0d12fD ) until LINIX ends its sale. 
9 //if "Owner_master" of LNSB token is not equal to "Owner_master" of LNX token, the certain token cannot be swapped with LNX token.
10 
11 library SafeMath{
12   	function mul(uint256 a, uint256 b) internal pure returns (uint256)
13     	{
14 		uint256 c = a * b;
15 		assert(a == 0 || c / a == b);
16 
17 		return c;
18   	}
19 
20   	function div(uint256 a, uint256 b) internal pure returns (uint256)
21 	{
22 		uint256 c = a / b;
23 
24 		return c;
25   	}
26 
27   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
28 	{
29 		assert(b <= a);
30 
31 		return a - b;
32   	}
33 
34   	function add(uint256 a, uint256 b) internal pure returns (uint256)
35 	{
36 		uint256 c = a + b;
37 		assert(c >= a);
38 
39 		return c;
40   	}
41 }
42 
43 contract Ownable
44 {
45   	address public Owner_master;
46   	address public Owner_creator;
47   	address public Owner_manager;
48 
49   	event ChangeOwner_master(address indexed _from, address indexed _to);
50   	event ChangeOwner_creator(address indexed _from, address indexed _to);
51   	event ChangeOwner_manager(address indexed _from, address indexed _to);
52 
53   	modifier onlyOwner_master{ 
54           require(msg.sender == Owner_master);	_; 	}
55   	modifier onlyOwner_creator{ 
56           require(msg.sender == Owner_creator); _; }
57   	modifier onlyOwner_manager{ 
58           require(msg.sender == Owner_manager); _; }
59   	constructor() public { 
60           Owner_master = msg.sender; }
61   	
62     
63     
64     
65     
66     
67     function transferOwnership_master(address _to) onlyOwner_master public{
68         	require(_to != Owner_master);
69         	require(_to != Owner_creator);
70         	require(_to != Owner_manager);
71         	require(_to != address(0x0));
72 
73 		address from = Owner_master;
74   	    	Owner_master = _to;
75   	    
76   	    	emit ChangeOwner_master(from, _to);}
77 
78   	function transferOwner_creator(address _to) onlyOwner_master public{
79 	        require(_to != Owner_master);
80         	require(_to != Owner_creator);
81         	require(_to != Owner_manager);
82 	        require(_to != address(0x0));
83 
84 		address from = Owner_creator;        
85 	    	Owner_creator = _to;
86         
87     		emit ChangeOwner_creator(from, _to);}
88 
89   	function transferOwner_manager(address _to) onlyOwner_master public{
90 	        require(_to != Owner_master);
91 	        require(_to != Owner_creator);
92         	require(_to != Owner_manager);
93 	        require(_to != address(0x0));
94         	
95 		address from = Owner_manager;
96     		Owner_manager = _to;
97         
98 	    	emit ChangeOwner_manager(from, _to);}
99 }
100 
101 contract Helper
102 {
103     event Transfer( address indexed _from, address indexed _to, uint _value);
104     event Approval( address indexed _owner, address indexed _spender, uint _value);
105     
106     function totalSupply() view public returns (uint _supply);
107     function balanceOf( address _who ) public view returns (uint _value);
108     function transfer( address _to, uint _value) public returns (bool _success);
109     function approve( address _spender, uint _value ) public returns (bool _success);
110     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
111     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
112 }
113 
114 contract LINIX_Seedblock is Helper, Ownable
115 {
116     using SafeMath for uint;
117     
118     string public name;
119     string public symbol;
120     uint public decimals;
121     
122     uint constant private zeroAfterDecimal = 10**18;
123     
124     uint constant public maxSupply             = 2625000 * zeroAfterDecimal;
125     
126     uint constant public maxSupply_SeedBlock        =   2625000 * zeroAfterDecimal;
127 
128     
129     uint public issueToken_Total;
130     
131     uint public issueToken_SeedBlock;
132     
133     uint public burnTokenAmount;
134     
135     mapping (address => uint) public balances;
136     mapping (address => mapping ( address => uint )) public approvals;
137 
138     bool public tokenLock = true;
139     bool public saleTime = true;
140     uint public endSaleTime = 0;
141     
142     event Burn(address indexed _from, uint _value);
143     
144     event Issue_SeedBlock(address indexed _to, uint _tokens);
145     
146     event TokenUnLock(address indexed _to, uint _tokens);
147 
148     
149     constructor() public
150     {
151         name        = "LNXSB";
152         decimals    = 18;
153         symbol      = "LNSB";
154         
155         issueToken_Total      = 0;
156         
157         issueToken_SeedBlock     = 0;
158 
159         
160         require(maxSupply == maxSupply_SeedBlock);
161 
162     }
163     
164     // ERC - 20 Interface -----
165 
166     function totalSupply() view public returns (uint) {
167         return issueToken_Total;}
168     
169     function balanceOf(address _who) view public returns (uint) {
170         uint balance = balances[_who];
171         
172         return balance;}
173     
174     function transfer(address _to, uint _value) public returns (bool) {
175         require(isTransferable() == true);
176         require(balances[msg.sender] >= _value);
177         
178         balances[msg.sender] = balances[msg.sender].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         
181         emit Transfer(msg.sender, _to, _value);
182         
183         return true;}
184     
185     function approve(address _spender, uint _value) public returns (bool){
186         require(isTransferable() == true);
187         require(balances[msg.sender] >= _value);
188         
189         approvals[msg.sender][_spender] = _value;
190         
191         emit Approval(msg.sender, _spender, _value);
192         
193         return true; }
194     
195     function allowance(address _owner, address _spender) view public returns (uint) {
196         return approvals[_owner][_spender];}
197 
198     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
199         require(isTransferable() == true);
200         require(balances[_from] >= _value);
201         require(approvals[_from][msg.sender] >= _value);
202         
203         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to]  = balances[_to].add(_value);
206         
207         emit Transfer(_from, _to, _value);
208         
209         return true;}
210     
211     // -----
212     
213     // Issue Function -----
214 
215 
216     function issue_noVesting_Public(address _to, uint _value) onlyOwner_creator public
217     {
218         uint tokens = _value * zeroAfterDecimal;
219         require(maxSupply_SeedBlock >= issueToken_SeedBlock.add(tokens));
220         
221         balances[_to] = balances[_to].add(tokens);
222         
223         issueToken_Total = issueToken_Total.add(tokens);
224         issueToken_SeedBlock = issueToken_SeedBlock.add(tokens);
225         
226         emit Issue_SeedBlock(_to, tokens);
227     }    
228     
229        // Lock Function -----
230     
231     function isTransferable() private view returns (bool)
232     {
233         if(tokenLock == false)
234         {
235             return true;
236         }
237         else if(msg.sender == Owner_manager)
238         {
239             return true;
240         }
241         
242         return false;
243     }
244     
245     function setTokenUnlock() onlyOwner_manager public
246     {
247         require(tokenLock == true);
248         require(saleTime == false);
249         
250         tokenLock = false;
251     }
252     
253     function setTokenLock() onlyOwner_manager public
254     {
255         require(tokenLock == false);
256         
257         tokenLock = true;
258     }
259     
260     // -----
261     
262     // ETC / Burn Function -----
263     
264     function () payable external
265     {
266         revert();
267     }
268     
269     function endSale() onlyOwner_manager public
270     {
271         require(saleTime == true);
272         
273         saleTime = false;
274         
275         uint time = now;
276         
277         endSaleTime = time;
278         
279     }
280     
281     function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner_manager public
282     {
283 
284         if(_contract == address(0x0))
285         {
286             uint eth = _value.mul(10 ** _decimals);
287             msg.sender.transfer(eth);
288         }
289         else
290         {
291             uint tokens = _value.mul(10 ** _decimals);
292             Helper(_contract).transfer(msg.sender, tokens);
293             
294             emit Transfer(address(0x0), msg.sender, tokens);
295         }
296     }
297     
298     function burnToken(uint _value) onlyOwner_manager public
299     {
300         uint tokens = _value * zeroAfterDecimal;
301         
302         require(balances[msg.sender] >= tokens);
303         
304         balances[msg.sender] = balances[msg.sender].sub(tokens);
305         
306         burnTokenAmount = burnTokenAmount.add(tokens);
307         issueToken_Total = issueToken_Total.sub(tokens);
308         
309         emit Burn(msg.sender, tokens);
310     }
311     
312     function close() onlyOwner_master public
313     {
314         selfdestruct(msg.sender);
315     }
316     
317     // -----
318 }