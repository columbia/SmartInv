1 pragma solidity ^0.4.23;
2 
3 library SafeMath
4 {
5     function add(uint256 a, uint256 b) internal pure returns (uint256)
6     {
7         uint256 c = a+b;
8         assert (c>=a);
9         return c;
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256)
12     {
13         assert(a>=b);
14         return (a-b);
15     }
16     function mul(uint256 a,uint256 b)internal pure returns (uint256)
17     {
18         if (a==0)
19         {
20         return 0;
21         }
22         uint256 c = a*b;
23         assert ((c/a)==b);
24         return c;
25     }
26     function div(uint256 a,uint256 b)internal pure returns (uint256)
27     {
28         return a/b;
29     }
30 }
31 
32 contract ERC20
33 {
34     function allowance(address owner, address spender) public view returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37     function totalSupply() public view returns (uint256);
38     function balanceOf(address who) public view returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract Owned
45 {
46     address public owner;
47 
48     constructor() internal
49     {
50         owner = msg.sender;
51     }
52     modifier onlyowner()
53     {
54         require(msg.sender==owner);
55         _;
56     }
57 }
58 
59 contract pausable is Owned
60 {
61     event Pause();
62     event Unpause();
63     bool public pause = false;
64 
65     modifier whenNotPaused()
66     {
67         require(!pause);
68         _;
69     }
70     modifier whenPaused()
71     {
72         require(pause);
73         _;
74     }
75     function pause() onlyowner whenNotPaused public
76     {
77         pause = true;
78         emit Pause();
79     }
80     function unpause() onlyowner whenPaused public
81     {
82         pause = false;
83         emit Unpause();
84     }
85 }
86 
87 contract TokenControl is ERC20,pausable
88 {
89     using SafeMath for uint256;
90     mapping (address =>uint256) internal balances;
91     mapping (address => mapping(address =>uint256)) internal allowed;
92     uint256 totaltoken;
93 
94     function totalSupply() public view returns (uint256)
95     {
96         return totaltoken;
97     }
98     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)
99     {
100         require(_to!=address(0));
101         require(_value <= balances[msg.sender]);
102 
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         emit Transfer(msg.sender, _to, _value);
106         return true;
107     }
108     function balanceOf(address _owner) public view returns (uint256 balance)
109     {
110         return balances[_owner];
111     }
112     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused  returns (bool)
113     {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         emit Transfer(_from, _to, _value);
122         return true;
123     }
124     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool)
125     {
126         allowed[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128         return true;
129     }
130     function allowance(address _owner, address _spender) public view returns (uint256)
131     {
132         return allowed[_owner][_spender];
133     }
134     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool)
135     {
136         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138         return true;
139     }
140     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool)
141     {
142         uint256 oldValue = allowed[msg.sender][_spender];
143         if (_subtractedValue > oldValue)
144         {
145             allowed[msg.sender][_spender] = 0;
146         }
147         else
148         {
149             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150         }
151         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153     }
154 }
155 
156 contract claimable is Owned
157 {
158     address public pendingOwner;
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     modifier onlyPendingOwner()
162     {
163         require(msg.sender == pendingOwner);
164         _;
165     }
166     function transferOwnership(address newOwner) onlyowner public
167     {
168         pendingOwner = newOwner;
169     }
170     function claimOwnership() onlyPendingOwner public
171     {
172         emit OwnershipTransferred(owner, pendingOwner);
173         owner = pendingOwner;
174         pendingOwner = address(0);
175     }
176 }
177 
178 //////////////////////////////////token Start////////////////////////////////////////////
179 contract RT is TokenControl,claimable
180 {
181     using SafeMath for uint256;
182     string public constant name    = "RecuToken";
183     string public constant symbol  = "RT";
184     uint256 public decimals = 18;
185     uint256 totalsupply =  500000000*(10**decimals);
186 
187     address public vault;
188 
189     //contract initial
190     constructor () public
191     {
192         balances[msg.sender] = totalsupply;
193         totaltoken = totalsupply;
194         vault = msg.sender;
195     }
196 
197     //set sell agent
198 
199     address public salesAgent;
200     address internal pendingAgent;
201 
202     event SetSalesAgent(address indexed previousSalesAgent, address indexed newSalesAgent);
203     event RemovedSalesAgent(address indexed currentSalesAgent);
204 
205     // set salesAgent
206     function setSalesAgent(address newSalesAgent) onlyowner public
207     {
208         pendingAgent = newSalesAgent;
209     }
210 
211     function claimSalesAgent() public
212     {
213         require(msg.sender==pendingAgent);
214         emit SetSalesAgent(salesAgent, pendingAgent);
215         salesAgent = pendingAgent;
216         pendingAgent = address(0);
217     }
218 
219     // Remove salesagent
220     function removedSalesAgent() onlyowner public
221     {
222         emit RemovedSalesAgent(salesAgent);
223         salesAgent = address(0);
224     }
225 
226     // Transfer tokens from salesAgent to account
227     function transferTokensFromVault(address toAddress, uint256 tokensAmount) public
228     {
229         require(salesAgent == msg.sender);
230         require(balances[vault]>=tokensAmount);
231         balances[vault] = balances[vault].sub(tokensAmount);
232         balances[toAddress] = balances[toAddress].add(tokensAmount);
233         emit Transfer(vault, toAddress, tokensAmount);
234     }
235 }