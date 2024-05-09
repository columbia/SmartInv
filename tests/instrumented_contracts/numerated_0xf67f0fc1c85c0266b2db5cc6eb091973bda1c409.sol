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
11     
12     function sub(uint256 a, uint256 b) internal pure returns (uint256)
13     {
14         assert(a>=b);
15         return (a-b);
16     }
17 
18     function mul(uint256 a,uint256 b)internal pure returns (uint256)
19     {
20         if (a==0)
21         {
22         return 0;
23         }
24         uint256 c = a*b;
25         assert ((c/a)==b);
26         return c;
27     }
28 
29     function div(uint256 a,uint256 b)internal pure returns (uint256)
30     {
31         return a/b;
32     }
33 }
34 
35 contract ERC20
36 {
37     function allowance(address owner, address spender) public view returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40     function totalSupply() public view returns (uint256);
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45     event Burn(address indexed from, uint256 value);  //减去用户余额事件
46 }
47 
48 contract Owned
49 {
50     address public owner;
51 
52     constructor() internal
53     {
54         owner = msg.sender;
55     }
56 
57     modifier onlyowner()
58     {
59         require(msg.sender==owner);
60         _;
61     }
62 }
63 
64 contract pausable is Owned
65 {
66     event Pause();
67     event Unpause();
68     bool public pause = false;
69 
70     modifier whenNotPaused()
71     {
72         require(!pause);
73         _;
74     }
75     modifier whenPaused()
76     {
77         require(pause);
78         _;
79     }
80 
81     function pause() onlyowner whenNotPaused public
82     {
83         pause = true;
84         emit Pause();
85     }
86     function unpause() onlyowner whenPaused public
87     {
88         pause = false;
89         emit Unpause();
90     }
91 }
92 
93 contract TokenControl is ERC20,pausable
94 {
95     using SafeMath for uint256;
96     mapping (address =>uint256) internal balances;
97     mapping (address => mapping(address =>uint256)) internal allowed;
98     uint256 totaltoken;
99 
100     function totalSupply() public view returns (uint256)
101     {
102         return totaltoken;
103     }
104 
105     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)
106     {
107         require(_to!=address(0));
108         require(_value <= balances[msg.sender]);
109 
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         emit Transfer(msg.sender, _to, _value);
113         return true;
114     }
115     
116     function balanceOf(address _owner) public view returns (uint256 balance)
117     {
118         return balances[_owner];
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused  returns (bool)
122     {
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         emit Transfer(_from, _to, _value);
131         return true;
132     }
133 
134     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool)
135     {
136         allowed[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     function allowance(address _owner, address _spender) public view returns (uint256)
142     {
143         return allowed[_owner][_spender];
144     }
145 
146     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool)
147     {
148         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
149         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151     }
152 
153     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool)
154     {
155         uint256 oldValue = allowed[msg.sender][_spender];
156         if (_subtractedValue > oldValue)
157         {
158             allowed[msg.sender][_spender] = 0;
159         }
160         else
161         {
162             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163         }
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167     
168     function burn(uint256 tokens) public returns (bool) 
169     {
170         // 檢查夠不夠燒
171         require(tokens <= balances[msg.sender]);
172         // 減少 total supply
173         totaltoken = totaltoken.sub(tokens);
174         // 減少 msg.sender balance
175         balances[msg.sender] = balances[msg.sender].sub(tokens);
176         
177         emit Burn(msg.sender, tokens);
178         emit Transfer(msg.sender, address(0), tokens);
179         return true;
180     }
181 }
182 
183 contract claimable is Owned
184 {
185     address public pendingOwner;
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     modifier onlyPendingOwner()
189     {
190         require(msg.sender == pendingOwner);
191         _;
192     }
193 
194      function transferOwnership(address newOwner) onlyowner public
195     {
196         pendingOwner = newOwner;
197     }
198 
199     function claimOwnership() onlyPendingOwner public
200     {
201         emit OwnershipTransferred(owner, pendingOwner);
202         owner = pendingOwner;
203         pendingOwner = address(0);
204     }
205 }
206 
207 contract SAS is TokenControl,claimable
208 {
209     using SafeMath for uint256;
210     string public constant name    = "SMASH";
211     string public constant symbol  = "SAS";
212     uint256 public decimals = 18;
213     uint256 totalsupply =  1618033988*(10**decimals);
214 
215     //contract initial
216     constructor () public
217     {
218         balances[0x9aAEDDc1adfD6C4048bFA67944C59818d6bA3E23] = totalsupply;
219         totaltoken = totalsupply;
220     }
221 }