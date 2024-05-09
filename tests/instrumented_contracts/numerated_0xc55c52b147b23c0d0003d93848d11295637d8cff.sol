1 pragma solidity ^0.4.24;
2 /**
3  * Math operations with safety checks
4  */
5 library SafeMath {
6   function mul(uint a, uint b) internal pure returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint a, uint b) internal pure returns (uint) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal pure returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal pure returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal pure  returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46   
47 }
48 contract ERC20Interface {
49     function totalSupply() public view returns (uint supply);
50     function balanceOf( address owner ) public view returns (uint value);
51     function allowance( address owner, address spender ) public view returns (uint _allowance);
52 
53     function transfer( address to, uint value) public returns (bool success);
54     function transferFrom( address from, address to, uint value) public returns (bool success);
55     function approve( address spender, uint value ) public returns (bool success);
56 
57     event Transfer( address indexed from, address indexed to, uint value);
58     event Approval( address indexed owner, address indexed spender, uint value);
59 }
60 
61 contract StandardAuth is ERC20Interface {
62     address      public  owner;
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     function setOwner(address _newOwner) public onlyOwner{
69         owner = _newOwner;
70     }
71 
72     modifier onlyOwner() {
73       require(msg.sender == owner);
74       _;
75     }
76 }
77 
78 contract StandardStop is StandardAuth {
79 
80     bool public stopped;
81 
82     modifier stoppable {
83         assert (!stopped);
84         _;
85     }
86     function stop() public onlyOwner {
87         stopped = true;
88     }
89     function start() public onlyOwner {
90         stopped = false;
91     }
92 
93 }
94 
95 contract StandardToken is StandardStop {
96     using SafeMath for uint;
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping (address => uint256)) allowed;
100     mapping(address => bool) optionPoolMembers;
101     mapping(address => uint) optionPoolMemberApproveTotal;
102     string public name;
103     string public symbol;
104     uint8 public decimals = 9;
105     uint256 public totalSupply;
106     uint256 public optionPoolLockTotal = 300000000;
107     uint [2][7] public optionPoolMembersUnlockPlans = [
108         [1596211200,15],    //2020-08-01 00:00:00 unlock 15%
109         [1612108800,30],    //2021-02-01 00:00:00 unlock 30%
110         [1627747200,45],    //2021-08-01 00:00:00 unlock 45%
111         [1643644800,60],    //2022-02-01 00:00:00 unlock 60%
112         [1659283200,75],    //2022-08-01 00:00:00 unlock 75%
113         [1675180800,90],    //2023-02-01 00:00:00 unlock 90%
114         [1690819200,100]    //2023-08-01 00:00:00 unlock 100%
115     ];
116     
117     constructor(uint256 _initialAmount, string _tokenName, string _tokenSymbol) public  {
118         balances[msg.sender] = _initialAmount;               
119         totalSupply = _initialAmount;                        
120         name = _tokenName;                                   
121         symbol = _tokenSymbol;
122         optionPoolMembers[0x11aCaBea71b42481672514071666cDA03b3fCfb8] = true;
123         optionPoolMembers[0x41217b46F813b685dB48FFafBd699f47BF6b87Bd] = true;
124         optionPoolMembers[0xaE6649B718A1bC54630C1707ddb8c0Ff7e635f5A] = true;
125         optionPoolMembers[0x9E64828c4e3344001908AdF1Bd546517708a649f] = true;
126     }
127 
128     modifier verifyTheLock(uint _value) {
129         if(optionPoolMembers[msg.sender] == true) {
130             if(balances[msg.sender] - optionPoolMemberApproveTotal[msg.sender] - _value < optionPoolMembersLockTotalOf(msg.sender)) {
131                 revert();
132             } else {
133                 _;
134             }
135         } else {
136             _;
137         }
138     }
139     
140     // Function to access name of token .
141     function name() public view returns (string _name) {
142         return name;
143     }
144     // Function to access symbol of token .
145     function symbol() public view returns (string _symbol) {
146         return symbol;
147     }
148     // Function to access decimals of token .
149     function decimals() public view returns (uint8 _decimals) {
150         return decimals;
151     }
152     // Function to access total supply of tokens .
153     function totalSupply() public view returns (uint _totalSupply) {
154         return totalSupply;
155     }
156     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
157         return allowed[_owner][_spender];
158     }
159     function balanceOf(address _owner) public view returns (uint balance) {
160         return balances[_owner];
161     }
162     function verifyOptionPoolMembers(address _add) public view returns (bool _verifyResults) {
163         return optionPoolMembers[_add];
164     }
165     
166     function optionPoolMembersLockTotalOf(address _memAdd) public view returns (uint _optionPoolMembersLockTotal) {
167         if(optionPoolMembers[_memAdd] != true){
168             return 0;
169         }
170         
171         uint unlockPercent = 0;
172         
173         for (uint8 i = 0; i < optionPoolMembersUnlockPlans.length; i++) {
174             if(now >= optionPoolMembersUnlockPlans[i][0]) {
175                 unlockPercent = optionPoolMembersUnlockPlans[i][1];
176             } else {
177                 break;
178             }
179         }
180         
181         return optionPoolLockTotal * (100 - unlockPercent) / 100;
182     }
183     
184     function transfer(address _to, uint _value) public stoppable verifyTheLock(_value) returns (bool success) {
185         assert(_value > 0);
186         assert(balances[msg.sender] >= _value);
187         assert(msg.sender != _to);
188         
189         balances[msg.sender] = balances[msg.sender].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         
192         emit Transfer(msg.sender, _to, _value);
193 
194         return true;
195     }
196 
197     function transferFrom(address _from, address _to, uint256 _value) public stoppable returns (bool success) {
198         assert(balances[_from] >= _value);
199         assert(allowed[_from][msg.sender] >= _value);
200 
201         if(optionPoolMembers[_from] == true) {
202             optionPoolMemberApproveTotal[_from] = optionPoolMemberApproveTotal[_from].sub(_value);
203         }
204         
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206         balances[_from] = balances[_from].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208         emit Transfer(_from, _to, _value);
209 
210         return true;
211         
212     }
213 
214     function approve(address _spender, uint256 _value) public stoppable verifyTheLock(_value) returns (bool success) {
215         assert(_value > 0);
216         assert(msg.sender != _spender);
217         
218         if(optionPoolMembers[msg.sender] == true) {
219             
220             if(allowed[msg.sender][_spender] > 0){
221                 optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].sub(allowed[msg.sender][_spender]);
222             }
223             
224             optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].add(_value);
225         }
226         
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         
230         return true;
231     }
232 
233 }