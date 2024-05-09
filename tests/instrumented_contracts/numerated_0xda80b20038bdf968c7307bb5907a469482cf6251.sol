1 pragma solidity ^0.4.21;
2 
3 library SafeMath
4 {
5     function mul(uint a, uint b) internal returns (uint)
6     {
7         uint c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint a, uint b) internal returns (uint)
13     {
14 assert(b > 0);       
15         uint c = a / b;
16         return c;
17     }
18 
19     function sub(uint a, uint b) internal returns (uint)
20     {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal returns (uint)
26     {
27         uint c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     function max64(uint64 a, uint64 b) internal constant returns (uint64)
33     {
34         return a >= b ? a : b;
35     }
36 
37     function min64(uint64 a, uint64 b) internal constant returns (uint64)
38     {
39         return a < b ? a : b;
40     }
41 
42     function max256(uint256 a, uint256 b) internal constant returns (uint256)
43     {
44         return a >= b ? a : b;
45     }
46 
47     function min256(uint256 a, uint256 b) internal constant returns (uint256)
48     {
49         return a < b ? a : b;
50     }
51 
52     function assert(bool assertion) internal
53     {
54         if (!assertion)
55         {
56             throw;
57         }
58     }
59 }
60 
61 contract ERC20Basic
62 {
63     uint public totalSupply;
64     function balanceOf(address who) constant returns (uint);
65     function transfer(address to, uint value);
66     event Transfer(address indexed from, address indexed to, uint value);
67 }
68 
69 contract ERC20 is ERC20Basic
70 {
71     function allowance(address owner, address spender) constant returns (uint);
72     function transferFrom(address from, address to, uint value);
73     function approve(address spender, uint value);
74     event Approval(address indexed owner, address indexed spender, uint value);
75 }
76 
77 contract BasicToken is ERC20Basic
78 {
79     using SafeMath for uint;
80     mapping(address => uint) balances;
81 
82     modifier onlyPayloadSize(uint size)
83     {
84         if(msg.data.length < size + 4)
85         {
86             throw;
87         }
88         _;
89     }
90 
91     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)
92     {
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96     }
97 
98     function balanceOf(address _owner) constant returns (uint balance)
99     {
100         return balances[_owner];
101     }
102 }
103 
104 contract StandardToken is BasicToken, ERC20
105 {
106     mapping (address => mapping (address => uint)) allowed;
107 
108     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)
109     {
110         uint _allowance = allowed[_from][msg.sender];
111         balances[_to] = balances[_to].add(_value);
112         balances[_from] = balances[_from].sub(_value);
113         allowed[_from][msg.sender] = _allowance.sub(_value);
114         Transfer(_from, _to, _value);
115     }
116 
117     function approve(address _spender, uint _value)
118     {
119 
120         
121         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124     }
125 
126     function allowance(address _owner, address _spender) constant returns (uint remaining)
127     {
128         return allowed[_owner][_spender];
129     }
130 }
131 
132 contract BrokerNekoNetwork is StandardToken
133 {
134     string public name = "BrokerNekoNetwork";
135     string public symbol = "BNN";
136     uint public decimals = 8 ;
137 
138    
139     uint public INITIAL_SUPPLY =  1680000000000000000;
140 
141 
142     
143     uint public constant ALLOCATION_LOCK_END_TIMESTAMP = 1559347200;
144 
145     address public constant BNN = 0xF009D60DF560F10E94f2ee397Fcb57d00130704C;
146     uint public constant    BNN_ALLOCATION = 1000000000000000000; 
147 
148    
149     function BrokerNekoNetwork()
150     {
151         
152         totalSupply = INITIAL_SUPPLY;
153 
154        
155         balances[msg.sender] = totalSupply;
156 
157        
158         balances[msg.sender] -= BNN_ALLOCATION;
159        
160 
161         balances[BNN]   = BNN_ALLOCATION;
162       
163     }
164 
165     function isAllocationLocked(address _spender) constant returns (bool)
166     {
167         return inAllocationLockPeriod() && isTeamMember(_spender);
168     }
169 
170     function inAllocationLockPeriod() constant returns (bool)
171     {
172         return (block.timestamp < ALLOCATION_LOCK_END_TIMESTAMP);
173     }
174 
175     function isTeamMember(address _spender) constant returns (bool)
176     {
177         return _spender == BNN  ;
178     }
179 
180         function approve(address spender, uint tokens)
181     {
182         if (isAllocationLocked(spender))
183         {
184             throw;
185         }
186         else
187         {
188             super.approve(spender, tokens);
189         }
190     }
191 
192     function transfer(address to, uint tokens) onlyPayloadSize(2 * 32)
193     {
194         if (isAllocationLocked(to))
195         {
196             throw;
197         }
198         else
199         {
200             super.transfer(to, tokens);
201         }
202     }
203 
204     function transferFrom(address from, address to, uint tokens) onlyPayloadSize(3 * 32)
205     {
206         if (isAllocationLocked(from) || isAllocationLocked(to))
207         {
208             throw;
209         }
210         else
211         {
212             super.transferFrom(from, to, tokens);
213         }
214     }
215 }