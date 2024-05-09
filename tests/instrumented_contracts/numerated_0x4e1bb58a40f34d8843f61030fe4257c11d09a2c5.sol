1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath
5 {
6     function add(uint256 a, uint256 b) internal pure returns (uint256)
7     {
8         uint256 c = a+b;
9         assert (c>=a);
10         return c;
11     }
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
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   function totalSupply() public view returns (uint256);
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract Owned
48 {
49     address public owner;
50 
51     constructor() internal
52      {
53          owner = msg.sender;
54      }
55 
56      modifier onlyowner()
57      {
58          require(msg.sender==owner);
59          _;
60      }
61 
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
91 
92 }
93 
94 contract TokenControl is ERC20,pausable
95 {
96     using SafeMath for uint256;
97     mapping (address =>uint256) internal balances;
98     mapping (address => mapping(address =>uint256)) internal allowed;
99     uint256 totaltoken;
100 
101 
102     function totalSupply() public view returns (uint256)
103     {
104         return totaltoken;
105     }
106 
107     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)
108     {
109         require(_to!=address(0));
110         require(_value <= balances[msg.sender]);
111 
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         emit Transfer(msg.sender, _to, _value);
115         return true;
116     }
117     function balanceOf(address _owner) public view returns (uint256 balance)
118     {
119         return balances[_owner];
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused  returns (bool)
123     {
124         require(_to != address(0));
125         require(_value <= balances[_from]);
126         require(_value <= allowed[_from][msg.sender]);
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         emit Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool)
136     {
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public view returns (uint256)
143     {
144         return allowed[_owner][_spender];
145     }
146 
147     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool)
148     {
149         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
150         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 
154     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool)
155     {
156         uint256 oldValue = allowed[msg.sender][_spender];
157         if (_subtractedValue > oldValue)
158         {
159             allowed[msg.sender][_spender] = 0;
160         }
161         else
162         {
163             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164         }
165         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166         return true;
167     }
168 }
169 
170 contract claimable is Owned
171 {
172     address public pendingOwner;
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     modifier onlyPendingOwner()
176     {
177         require(msg.sender == pendingOwner);
178         _;
179     }
180 
181      function transferOwnership(address newOwner) onlyowner public
182     {
183         pendingOwner = newOwner;
184     }
185 
186     function claimOwnership() onlyPendingOwner public
187     {
188         emit OwnershipTransferred(owner, pendingOwner);
189         owner = pendingOwner;
190         pendingOwner = address(0);
191     }
192 
193 }
194 
195 
196 contract TTT is TokenControl,claimable
197 {
198     using SafeMath for uint256;
199     string public constant name    = "Tui Tui Token";
200     string public constant symbol  = "TTT";
201     uint256 public decimals = 18;
202     uint256 totalsupply =  3000000000*(10**decimals);
203 
204 
205 
206     //contract initial
207     constructor () public
208     {
209         balances[0xEAc1b04cBdd484244fC0dB0A8BEdA6212fFb32b1] = totalsupply;
210         totaltoken = totalsupply;
211 
212     }
213 
214 
215 
216 
217 }