1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Base {
30     modifier only(address allowed) {
31         require(msg.sender == allowed);
32         _;
33     }
34 }
35 
36 contract Owned is Base {
37 
38     address public owner;
39     address newOwner;
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     function transferOwnership(address _newOwner) only(owner) public {
46         newOwner = _newOwner;
47     }
48 
49     function acceptOwnership() only(newOwner) public {
50         OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56 }
57 
58 contract ERC20 is Owned {
59     using SafeMath for uint;
60 
61     event Transfer(address indexed _from, address indexed _to, uint _value);
62     event Approval(address indexed _owner, address indexed _spender, uint _value);
63 
64     function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {
65         require(_to != address(0));
66         require(_value <= balances[msg.sender]);
67     
68         // SafeMath.sub will throw if there is not enough balance.
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {
76         require(_to != address(0));
77         require(_value <= balances[_from]);
78         require(_value <= allowed[_from][msg.sender]);
79     
80         balances[_from] = balances[_from].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) constant public returns (uint balance) {
88         return balances[_owner];
89     }
90 
91     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {
92         if(allowed[msg.sender][_spender] == _currentValue){
93             allowed[msg.sender][_spender] = _value;
94             Approval(msg.sender, _spender, _value);
95             return true;
96         } else {
97             return false;
98         }
99     }
100 
101     function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
108         return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint) balances;
112     mapping (address => mapping (address => uint)) allowed;
113 
114     uint public totalSupply;
115     bool    public isStarted = false;
116 
117     modifier isStartedOnly() {
118         require(isStarted);
119         _;
120     }
121 
122 }
123 
124 contract JOT is ERC20 {
125     using SafeMath for uint;
126 
127     string public name = "Jury.Online Token";
128     string public symbol = "JOT";
129     uint8 public decimals = 18;
130 
131     modifier isNotStartedOnly() {
132         require(!isStarted);
133         _;
134     }
135 
136     function getTotalSupply()
137     public
138     constant
139     returns(uint)
140     {
141         return totalSupply;
142     }
143 
144     function start()
145     public
146     only(owner)
147     isNotStartedOnly
148     {
149         isStarted = true;
150     }
151 
152     //================= Crowdsale Only =================
153     function mint(address _to, uint _amount) public
154     only(owner)
155     isNotStartedOnly
156     returns(bool)
157     {
158         totalSupply = totalSupply.add(_amount);
159         balances[_to] = balances[_to].add(_amount);
160         Transfer(msg.sender, _to, _amount);
161         return true;
162     }
163 
164 
165     function multimint(address[] dests, uint[] values) public
166     only(owner)
167     isNotStartedOnly
168     returns (uint) {
169         uint i = 0;
170         while (i < dests.length) {
171            mint(dests[i], values[i]);
172            i += 1;
173         }
174         return(i);
175     }
176 }