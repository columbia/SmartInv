1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16 
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a / b;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract BasicToken is ERC20Basic {
39     using SafeMath for uint256;
40 
41     mapping(address => uint256) balances;
42 
43     uint256 totalSupply_;
44 
45     function totalSupply() public view returns (uint256) {
46         return totalSupply_;
47     }
48 
49     function transfer(address _to, uint256 _value) public returns (bool) {
50         require(_to != address(0));
51         require(_value <= balances[msg.sender]);
52 
53         balances[msg.sender] = balances[msg.sender].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         emit Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function balanceOf(address _owner) public view returns (uint256) {
60         return balances[_owner];
61     }
62 
63 }
64 
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender)
67     public view returns (uint256);
68 
69     function transferFrom(address from, address to, uint256 value)
70     public returns (bool);
71 
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(
74         address indexed owner,
75         address indexed spender,
76         uint256 value
77     );
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82     mapping (address => mapping (address => uint256)) internal allowed;
83 
84     function transferFrom(
85         address _from,
86         address _to,
87         uint256 _value
88     )
89     public
90     returns (bool)
91     {
92         require(_to != address(0));
93         require(_value <= balances[_from]);
94         require(_value <= allowed[_from][msg.sender]);
95 
96         balances[_from] = balances[_from].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool) {
104         allowed[msg.sender][_spender] = _value;
105         emit Approval(msg.sender, _spender, _value);
106         return true;
107     }
108 
109     function allowance(
110         address _owner,
111         address _spender
112     )
113     public
114     view
115     returns (uint256)
116     {
117         return allowed[_owner][_spender];
118     }
119 
120     function increaseApproval(
121         address _spender,
122         uint256 _addedValue
123     )
124     public
125     returns (bool)
126     {
127         allowed[msg.sender][_spender] = (
128         allowed[msg.sender][_spender].add(_addedValue));
129         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130         return true;
131     }
132 
133     function decreaseApproval(
134         address _spender,
135         uint256 _subtractedValue
136     )
137     public
138     returns (bool)
139     {
140         uint256 oldValue = allowed[msg.sender][_spender];
141         if (_subtractedValue > oldValue) {
142             allowed[msg.sender][_spender] = 0;
143         } else {
144             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145         }
146         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 
150 }
151 
152 
153 contract Ownable {
154     address public owner;
155 
156     event OwnershipRenounced(address indexed previousOwner);
157     event OwnershipTransferred(
158         address indexed previousOwner,
159         address indexed newOwner
160     );
161 
162     constructor() public {
163         owner = msg.sender;
164     }
165 
166     modifier onlyOwner() {
167         require(msg.sender == owner);
168         _;
169     }
170 
171     function renounceOwnership() public onlyOwner {
172         emit OwnershipRenounced(owner);
173         owner = address(0);
174     }
175 
176     function transferOwnership(address _newOwner) public onlyOwner {
177         _transferOwnership(_newOwner);
178     }
179 
180     function _transferOwnership(address _newOwner) internal {
181         require(_newOwner != address(0));
182         emit OwnershipTransferred(owner, _newOwner);
183         owner = _newOwner;
184     }
185 }
186 
187 contract OasisBeautySuperToken is StandardToken, Ownable{
188 
189     string public name;
190     string public symbol;
191     uint public decimals;
192     constructor() public{
193         name = 'Oasis Beauty Super Token';
194         symbol = 'OBST';
195         decimals = 5;
196         totalSupply_ = 210000000 * 10 **uint(decimals);
197         balances[msg.sender] = totalSupply_;
198     }
199 
200 }