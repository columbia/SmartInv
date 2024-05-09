1 /**
2  * PANDO token 
3  * 
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.5.9;
9 
10 library SafeMath
11 {
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
43 contract OwnerHelper
44 {
45   	address public owner;
46 
47   	event ChangeOwner(address indexed _from, address indexed _to);
48 
49   	modifier onlyOwner
50 	{
51 		require(msg.sender == owner);
52 		_;
53   	}
54   	
55   	constructor() public
56 	{
57 		owner = msg.sender;
58   	}
59   	
60   	function transferOwnership(address _to) onlyOwner public
61   	{
62     	require(_to != owner);
63     	require(_to != address(0x0));
64 
65         address from = owner;
66       	owner = _to;
67   	    
68       	emit ChangeOwner(from, _to);
69   	}
70 }
71 
72 
73 contract ERC20Interface
74 {
75     event Transfer( address indexed _from, address indexed _to, uint _value);
76     event Approval( address indexed _owner, address indexed _spender, uint _value);
77     
78     function totalSupply() view public returns (uint _supply);
79     function balanceOf( address _who ) public view returns (uint _value);
80     function transfer( address _to, uint _value) public returns (bool _success);
81     function approve( address _spender, uint _value ) public returns (bool _success);
82     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
83     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
84 }
85 
86 contract PandoToken is ERC20Interface, OwnerHelper
87 {
88     using SafeMath for uint;
89     
90     string public name;
91     uint public decimals;
92     string public symbol;
93 
94     // Founder
95     address private founder;
96     
97     // Total
98     uint public totalTokenSupply;
99     uint public burnTokenSupply;
100 
101     mapping (address => uint) public balances;
102     mapping (address => mapping ( address => uint )) public approvals;
103     mapping (address => bool) private blackAddress; // unLock : false, Lock : true
104     
105     bool public tokenLock = false;
106 
107     // Token Total
108     uint constant private E18 = 1000000000000000000;
109 
110     event Burn(address indexed _from, uint _tokens);
111     event TokenUnlock(address indexed _to, uint _tokens);
112 
113     constructor(string memory _name, string memory _symbol, address _founder, uint _totalTokenSupply) public {
114         name        = _name;
115         decimals    = 18;
116         symbol      = _symbol;
117 
118         founder = _founder;
119         totalTokenSupply  = _totalTokenSupply * E18;
120         burnTokenSupply     = 0;
121 
122         balances[founder] = totalTokenSupply;
123         emit Transfer(address(0), founder, totalTokenSupply);
124     }
125 
126     // ERC - 20 Interface -----
127     modifier notLocked {
128         require(isTransferable() == true);
129         _;
130     }
131 
132     function lock(address who) onlyOwner public {
133         
134         blackAddress[who] = true;
135     }
136     
137     function unlock(address who) onlyOwner public {
138         
139         blackAddress[who] = false;
140     }
141     
142     function isLocked(address who) public view returns(bool) {
143         
144         return blackAddress[who];
145     }
146 
147     function totalSupply() view public returns (uint) 
148     {
149         return totalTokenSupply;
150     }
151     
152     function balanceOf(address _who) view public returns (uint) 
153     {
154         return balances[_who];
155     }
156     
157     function transfer(address _to, uint _value) notLocked public returns (bool) 
158     {
159         require(balances[msg.sender] >= _value);
160         
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         
164         emit Transfer(msg.sender, _to, _value);
165         
166         return true;
167     }
168     
169     function approve(address _spender, uint _value) notLocked public returns (bool)
170     {
171         require(balances[msg.sender] >= _value);
172         
173         approvals[msg.sender][_spender] = _value;
174         
175         emit Approval(msg.sender, _spender, _value);
176         
177         return true; 
178     }
179     
180     function allowance(address _owner, address _spender) view public returns (uint) 
181     {
182         return approvals[_owner][_spender];
183     }
184 
185     function transferFrom(address _from, address _to, uint _value) notLocked public returns (bool) 
186     {
187         require(balances[_from] >= _value);
188         require(approvals[_from][msg.sender] >= _value);
189         
190         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
191         balances[_from] = balances[_from].sub(_value);
192         balances[_to]  = balances[_to].add(_value);
193         
194         emit Transfer(_from, _to, _value);
195         
196         return true;
197     }
198     
199     // Lock Function -----
200     
201     function isTransferable() private view returns (bool)
202     {
203         if(tokenLock == false) {
204 
205             if (blackAddress[msg.sender]) // true is Locked
206             {
207                 return false;
208             } else {
209                 return true;
210             }
211         }
212         else if(msg.sender == owner)
213         {
214             return true;
215         }
216         
217         return false;
218     }
219     
220     function setTokenUnlock() onlyOwner public
221     {
222         require(tokenLock == true);
223         
224         tokenLock = false;
225     }
226     
227     function setTokenLock() onlyOwner public
228     {
229         require(tokenLock == false);
230         
231         tokenLock = true;
232     }
233 
234     function withdrawTokens(address _contract, uint _value) onlyOwner public
235     {
236 
237         if(_contract == address(0x0))
238         {
239             uint eth = _value.mul(10 ** decimals);
240             msg.sender.transfer(eth);
241         }
242         else
243         {
244             uint tokens = _value.mul(10 ** decimals);
245             ERC20Interface(_contract).transfer(msg.sender, tokens);
246             
247             emit Transfer(address(0x0), msg.sender, tokens);
248         }
249     }
250 
251     function burnToken(uint _value) onlyOwner public
252     {
253         uint tokens = _value.mul(10 ** decimals);
254         
255         require(balances[msg.sender] >= tokens);
256         
257         balances[msg.sender] = balances[msg.sender].sub(tokens);
258         
259         burnTokenSupply = burnTokenSupply.add(tokens);
260         totalTokenSupply = totalTokenSupply.sub(tokens);
261         
262         emit Burn(msg.sender, tokens);
263     }    
264     
265     function close() onlyOwner public
266     {
267         selfdestruct(msg.sender);
268     }
269     
270 }