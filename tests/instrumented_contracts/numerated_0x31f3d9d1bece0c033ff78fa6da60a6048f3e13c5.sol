1 pragma solidity ^0.4.18;
2 
3 /* -------------------------------------------------------------------------------- */
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) 
7   {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) 
14   {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
22   {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) 
28   {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34 }
35 
36 /* -------------------------------------------------------------------------------- */
37 
38 /**
39  * @title Ownable
40  */
41 contract Ownable 
42 {
43   address public owner;
44 
45   event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);
46 	
47 	function Ownable() public
48   {
49     owner = msg.sender;
50   }
51 
52   modifier onlyOwner() 
53   {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   function changeOwner(address _newOwner) onlyOwner public 
59   {
60     require(_newOwner != address(0));
61     
62     address oldOwner = owner;
63     if (oldOwner != _newOwner)
64     {
65     	owner = _newOwner;
66     	
67     	OwnerChanged(oldOwner, _newOwner);
68     }
69   }
70 
71 }
72 
73 /* -------------------------------------------------------------------------------- */
74 
75 /**
76  * @title Manageable
77  */
78 contract Manageable is Ownable
79 {
80 	address public manager;
81 	
82 	event ManagerChanged(address indexed _oldManager, address _newManager);
83 	
84 	function Manageable() public
85 	{
86 		manager = msg.sender;
87 	}
88 	
89 	modifier onlyManager()
90 	{
91 		require(msg.sender == manager);
92 		_;
93 	}
94 	
95 	modifier onlyOwnerOrManager() 
96 	{
97 		require(msg.sender == owner || msg.sender == manager);
98 		_;
99 	}
100 	
101 	function changeManager(address _newManager) onlyOwner public 
102 	{
103 		require(_newManager != address(0));
104 		
105 		address oldManager = manager;
106 		if (oldManager != _newManager)
107 		{
108 			manager = _newManager;
109 			
110 			ManagerChanged(oldManager, _newManager);
111 		}
112 	}
113 	
114 }
115 
116 /* -------------------------------------------------------------------------------- */
117 
118 /**
119  * @title EBCoinToken
120  */
121 contract EBCoinToken is Manageable
122 {
123   using SafeMath for uint256;
124 
125   string public constant name     = "EBCoin";
126   string public constant symbol   = "EBC";
127   uint8  public constant decimals = 18;
128   
129   uint256 public totalSupply;
130   mapping(address => uint256) balances;
131   mapping (address => mapping (address => uint256)) internal allowed;
132   mapping (address => uint256) public releaseTime;
133   bool public released;
134 
135   event Transfer(address indexed _from, address indexed _to, uint256 _value);
136   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
137   event Mint(address indexed _to, uint256 _value);
138   event Burn(address indexed _from, uint256 _value);
139   event ReleaseTimeChanged(address indexed _owner, uint256 _oldReleaseTime, uint256 _newReleaseTime);
140   event ReleasedChanged(bool _oldReleased, bool _newReleased);
141 
142   modifier canTransfer(address _from)
143   {
144   	if (releaseTime[_from] == 0)
145   	{
146   		require(released);
147   	}
148   	else
149   	{
150   		require(releaseTime[_from] <= now);
151   	}
152   	_;
153   }
154 
155   function balanceOf(address _owner) public constant returns (uint256)
156   {
157     return balances[_owner];
158   }
159 
160   function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool) 
161   {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     
168     Transfer(msg.sender, _to, _value);
169     
170     return true;
171   }
172 
173   function allowance(address _owner, address _spender) public constant returns (uint256) 
174   {
175     return allowed[_owner][_spender];
176   }
177   
178   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) 
179   {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     
188     Transfer(_from, _to, _value);
189     
190     return true;
191   }
192   
193  	function approve(address _spender, uint256 _value) public returns (bool) 
194  	{
195     allowed[msg.sender][_spender] = _value;
196     
197     Approval(msg.sender, _spender, _value);
198     
199     return true;
200   }
201 
202   function mint(address _to, uint256 _value, uint256 _releaseTime) onlyOwnerOrManager public returns (bool) 
203   {
204   	require(_to != address(0));
205   	
206     totalSupply = totalSupply.add(_value);
207     balances[_to] = balances[_to].add(_value);
208     
209     Mint(_to, _value);
210     Transfer(0x0, _to, _value);
211     
212     setReleaseTime(_to, _releaseTime);
213     
214     return true;
215   }
216   
217   function burn(address _from, uint256 _value) onlyOwnerOrManager public returns (bool)
218   {
219     require(_from != address(0));
220     require(_value <= balances[_from]);
221     
222     balances[_from] = balances[_from].sub(_value);
223     totalSupply = totalSupply.sub(_value);
224     
225     Burn(_from, _value);
226     
227   	return true;
228   }
229 
230   function setReleaseTime(address _owner, uint256 _newReleaseTime) onlyOwnerOrManager public returns (bool)
231   {
232     require(_owner != address(0));
233     
234   	uint256 oldReleaseTime = releaseTime[_owner];
235   	if (oldReleaseTime != _newReleaseTime)
236   	{
237   		releaseTime[_owner] = _newReleaseTime;
238     
239     	ReleaseTimeChanged(_owner, oldReleaseTime, _newReleaseTime);
240     	
241     	return true;
242     }
243     
244     return false;
245   }
246   
247   function setReleased(bool _newReleased) onlyOwnerOrManager public returns (bool)
248   {
249   	bool oldReleased = released;
250   	if (oldReleased != _newReleased)
251   	{
252   		released = _newReleased;
253   	
254   		ReleasedChanged(oldReleased, _newReleased);
255   		
256   		return true;
257   	}
258   	
259   	return false;
260   }
261   
262 }
263 
264 /* -------------------------------------------------------------------------------- */