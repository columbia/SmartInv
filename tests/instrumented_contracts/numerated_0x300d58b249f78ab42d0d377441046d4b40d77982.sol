1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract StandardToken {
33     using SafeMath for uint256;
34 
35     uint256 totalSupply_;
36 
37     mapping(address => uint256) balances;
38     mapping (address => mapping (address => uint256)) internal allowed;
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 
43     function totalSupply() public view returns (uint256) {
44         return totalSupply_;
45     }
46 
47     function transfer(address _to, uint256 _value) public returns (bool) {
48         require(_to != address(0));
49         require(_value <= balances[msg.sender]);
50 
51         // SafeMath.sub will throw if there is not enough balance.
52         balances[msg.sender] = balances[msg.sender].sub(_value);
53         balances[_to] = balances[_to].add(_value);
54         Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function balanceOf(address _owner) public view returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
63         require(_to != address(0));
64         require(_value <= balances[_from]);
65         require(_value <= allowed[_from][msg.sender]);
66 
67         balances[_from] = balances[_from].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
70         Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public returns (bool) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) public view returns (uint256) {
81         return allowed[_owner][_spender];
82     }
83 
84     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
85         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
86         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
87         return true;
88     }
89 
90     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
91         uint oldValue = allowed[msg.sender][_spender];
92         if (_subtractedValue > oldValue) {
93             allowed[msg.sender][_spender] = 0;
94         } else {
95             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
96         }
97         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98         return true;
99     }
100 }
101 
102 contract Ownable {
103     address public owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     function Ownable() public {
108         owner = msg.sender;
109     }
110 
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115 
116     function transferOwnership(address newOwner) public onlyOwner {
117         require(newOwner != address(0));
118         OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120     }
121 }
122 
123 contract HotPotToken is Ownable, StandardToken {
124     string public name    = "HotPotChain";
125     string public symbol  = "HPC";
126     uint8 public decimals = 3;
127 
128     // 21 million in initial supply
129     uint256 public totalSupply = 21000000 * (10 ** uint256(decimals));
130     uint256 public totalAirDrop = 1000000 * (10 ** uint256(decimals));
131     uint256 public totalRemaining = totalSupply.sub(totalAirDrop);
132     uint256 public airDropNumber = 1314520;
133     
134     bool public distributionFinished = false;
135     
136     mapping (address => bool) public blacklist;
137 
138     modifier canDistribute() {
139         require(!distributionFinished);
140         _;
141     }
142     
143     modifier onlyWhitelist() {
144         require(blacklist[msg.sender] == false);
145         _;
146     }
147 
148     function HotPotToken() public {
149         balances[msg.sender] = totalRemaining;
150     }
151 
152     function distribute(address _to, uint256 _amount) canDistribute private returns (bool) {
153         totalAirDrop = totalAirDrop.sub(_amount);
154         balances[_to] = balances[_to].add(_amount);
155         Transfer(address(0), _to, _amount);
156 
157         if (totalAirDrop < airDropNumber) {
158             distributionFinished = true;
159         }
160 
161         return true;
162     }
163     
164     function () external payable {
165         airDropTokens();
166     }
167     
168     function airDropTokens() payable canDistribute onlyWhitelist public {
169         
170         if (airDropNumber > totalRemaining) {
171             airDropNumber = totalRemaining;
172         }
173         
174         require(airDropNumber <= totalRemaining);
175         
176         address investor = msg.sender;
177         uint256 toGive = airDropNumber;
178         
179         distribute(investor, toGive);
180         
181         if (toGive > 0) {
182             blacklist[investor] = true;
183         }
184 
185         if (totalAirDrop < airDropNumber) {
186             distributionFinished = true;
187         }
188     }
189 
190     function balanceOf(address _owner) public view returns (uint256 balance) {
191         return balances[_owner];
192     }
193 }