1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 }
15 
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() public {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 contract ERC20 {
54     function totalSupply() public constant returns (uint supply);
55     function balanceOf( address owner ) public constant returns (uint value);
56     function allowance( address owner, address spender ) public constant returns (uint _allowance);
57 
58     function transfer( address to, uint value) public returns (bool ok);
59     function transferFrom( address from, address to, uint value) public returns (bool ok);
60     function approve( address spender, uint value ) public returns (bool ok);
61 
62     event Transfer( address indexed from, address indexed to, uint value);
63     event Approval( address indexed owner, address indexed spender, uint value);
64 }
65 
66 contract Token is ERC20 {
67 
68   using SafeMath for uint256;
69 
70   uint256                                             supply;
71   mapping(address => uint256)                         balances;
72   mapping (address => mapping (address => uint256))   approvals;
73 
74   function balanceOf(address owner) public constant returns (uint256 balance) {
75     return balances[owner];
76   }
77 
78   function allowance(address owner, address spender) public constant returns (uint256) {
79     return approvals[owner][spender];
80   }
81 
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85     require(balances[_to] < balances[_to].add(_value));
86 
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function transferFrom(address from, address to, uint256 value) public returns (bool) {
94 
95         assert(balances[from] >= value);
96         assert(approvals[from][msg.sender] >= value);
97         
98         approvals[from][msg.sender] = approvals[from][msg.sender].sub(value);
99         balances[from] = balances[from].sub(value);
100         balances[to] = balances[to].add(value);
101         
102         Transfer(from, to, value);
103         
104         return true;
105   }
106 
107   function approve(address spender, uint256 value) public returns (bool) {
108         approvals[msg.sender][spender] = value;
109         Approval(msg.sender, spender, value);
110         return true;
111   }
112 
113   function totalSupply() public constant returns (uint) {
114     return supply;
115   }
116 
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 contract CybereitsToken is Token, Ownable {
121     string public name = "Cybereits Token";
122     string public symbol = "CRE";
123     uint public decimals;
124 
125     address public teamLockAddr;
126 
127     function CybereitsToken(
128       uint256 total,
129       uint256 _decimals, 
130       uint256 _teamLockPercent,
131       address _teamAddr1,
132       address _teamAddr2,
133       address _teamAddr3,
134       address _teamAddr4,
135       address _teamAddr5,
136       address _teamAddr6
137     ) public
138     {
139         decimals = _decimals;
140         var multiplier = 10 ** decimals;
141         supply = total * multiplier;
142         var teamLockAmount = _teamLockPercent * supply / 100;
143         teamLockAddr = new CybereitsTeamLock(
144           teamLockAmount,
145           _teamAddr1,
146           _teamAddr2,
147           _teamAddr3,
148           _teamAddr4,
149           _teamAddr5,
150           _teamAddr6
151         );
152         balances[teamLockAddr] = teamLockAmount;
153         balances[msg.sender] = supply - teamLockAmount;
154     }
155 }
156 
157 contract CybereitsTeamLock {
158 
159     event Unlock(address from, uint amount);
160 
161     mapping (address => uint256) allocations;
162     mapping (address => uint256) frozen;
163 
164     CybereitsToken cre;
165 
166     function CybereitsTeamLock(
167       uint256 lockAmount,
168       address _teamAddr1,
169       address _teamAddr2,
170       address _teamAddr3,
171       address _teamAddr4,
172       address _teamAddr5,
173       address _teamAddr6
174     ) public
175     {
176         cre = CybereitsToken(msg.sender);
177         allocations[_teamAddr1] = lockAmount / 6;
178         frozen[_teamAddr1] = now + 6 * 30 days;
179         allocations[_teamAddr2] = lockAmount / 6;
180         frozen[_teamAddr2] = now + 12 * 30 days;
181         allocations[_teamAddr3] = lockAmount / 6;
182         frozen[_teamAddr3] = now + 18 * 30 days;
183         allocations[_teamAddr4] = lockAmount / 6;
184         frozen[_teamAddr4] = now + 24 * 30 days;
185         allocations[_teamAddr5] = lockAmount / 6;
186         frozen[_teamAddr5] = now + 30 * 30 days;
187         allocations[_teamAddr6] = lockAmount / 6;
188         frozen[_teamAddr6] = now + 36 * 30 days;
189     }
190 
191     function unlock(address unlockAddr) external returns (bool) {
192         require(allocations[unlockAddr] != 0);
193         require(now >= frozen[unlockAddr]);
194 
195         var amount = allocations[unlockAddr];
196         assert(cre.transfer(unlockAddr, amount));
197         allocations[unlockAddr] = 0;
198         Unlock(unlockAddr, amount);
199         return true;
200     }
201 }