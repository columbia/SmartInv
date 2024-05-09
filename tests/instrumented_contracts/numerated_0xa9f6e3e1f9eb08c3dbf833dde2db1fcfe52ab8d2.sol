1 pragma solidity ^0.4.11;
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
78 contract StandardToken is StandardAuth {
79     using SafeMath for uint;
80 
81     mapping(address => uint) balances;
82     mapping(address => mapping (address => uint256)) allowed;
83     mapping(address => bool) optionPoolMembers;
84     mapping(address => uint) optionPoolMemberApproveTotal;
85     string public name;
86     string public symbol;
87     uint8 public decimals = 9;
88     uint256 public totalSupply;
89     uint256 public optionPoolLockTotal = 500000000;
90     uint [2][7] public optionPoolMembersUnlockPlans = [
91         [1596211200,15],    //2020-08-01 00:00:00 unlock 15%
92         [1612108800,30],    //2021-02-01 00:00:00 unlock 30%
93         [1627747200,45],    //2021-08-01 00:00:00 unlock 45%
94         [1643644800,60],    //2022-02-01 00:00:00 unlock 60%
95         [1659283200,75],    //2022-08-01 00:00:00 unlock 75%
96         [1675180800,90],    //2023-02-01 00:00:00 unlock 90%
97         [1690819200,100]    //2023-08-01 00:00:00 unlock 100%
98     ];
99     
100     constructor(uint256 _initialAmount, string _tokenName, string _tokenSymbol) public  {
101         balances[msg.sender] = _initialAmount;               
102         totalSupply = _initialAmount;                        
103         name = _tokenName;                                   
104         symbol = _tokenSymbol;
105         optionPoolMembers[0x36b4F89608B5a5d5bd675b13a9d1075eCb64C2B5] = true;
106         optionPoolMembers[0xDdcEb1A0c975Da8f0E0c457e06D6eBfb175570A7] = true;
107         optionPoolMembers[0x46b6bA8ff5b91FF6B76964e143f3573767a20c1C] = true;
108         optionPoolMembers[0xBF95141188dB8FDeFe85Ce2412407A9266d96dA3] = true;
109     }
110 
111     modifier verifyTheLock(uint _value) {
112         if(optionPoolMembers[msg.sender] == true) {
113             if(balances[msg.sender] - optionPoolMemberApproveTotal[msg.sender] - _value < optionPoolMembersLockTotalOf(msg.sender)) {
114                 revert();
115             } else {
116                 _;
117             }
118         } else {
119             _;
120         }
121     }
122     
123     // Function to access name of token .
124     function name() public view returns (string _name) {
125         return name;
126     }
127     // Function to access symbol of token .
128     function symbol() public view returns (string _symbol) {
129         return symbol;
130     }
131     // Function to access decimals of token .
132     function decimals() public view returns (uint8 _decimals) {
133         return decimals;
134     }
135     // Function to access total supply of tokens .
136     function totalSupply() public view returns (uint _totalSupply) {
137         return totalSupply;
138     }
139     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
140         return allowed[_owner][_spender];
141     }
142     function balanceOf(address _owner) public view returns (uint balance) {
143         return balances[_owner];
144     }
145     function verifyOptionPoolMembers(address _add) public view returns (bool _verifyResults) {
146         return optionPoolMembers[_add];
147     }
148     
149     function optionPoolMembersLockTotalOf(address _memAdd) public view returns (uint _optionPoolMembersLockTotal) {
150         if(optionPoolMembers[_memAdd] != true){
151             return 0;
152         }
153         
154         uint unlockPercent = 0;
155         
156         for (uint8 i = 0; i < optionPoolMembersUnlockPlans.length; i++) {
157             if(now >= optionPoolMembersUnlockPlans[i][0]) {
158                 unlockPercent = optionPoolMembersUnlockPlans[i][1];
159             } else {
160                 break;
161             }
162         }
163         
164         return optionPoolLockTotal * (100 - unlockPercent) / 100;
165     }
166     
167     function transfer(address _to, uint _value) public verifyTheLock(_value) returns (bool success) {
168         assert(_value > 0);
169         assert(balances[msg.sender] >= _value);
170         assert(msg.sender != _to);
171         
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         
175         emit Transfer(msg.sender, _to, _value);
176 
177         return true;
178     }
179 
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
181         assert(balances[_from] >= _value);
182         assert(allowed[_from][msg.sender] >= _value);
183 
184         if(optionPoolMembers[_from] == true) {
185             optionPoolMemberApproveTotal[_from] = optionPoolMemberApproveTotal[_from].sub(_value);
186         }
187         
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         emit Transfer(_from, _to, _value);
192 
193         return true;
194         
195     }
196 
197     function approve(address _spender, uint256 _value) public verifyTheLock(_value) returns (bool success) {
198         assert(_value > 0);
199         assert(msg.sender != _spender);
200         
201         if(optionPoolMembers[msg.sender] == true) {
202             
203             if(allowed[msg.sender][_spender] > 0){
204                 optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].sub(allowed[msg.sender][_spender]);
205             }
206             
207             optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].add(_value);
208         }
209         
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         
213         return true;
214     }
215 
216 }