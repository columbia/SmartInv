1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18 ///////////// NEW OWNER FUNCTIONALITY
19 
20     function transferOwnership(address newOwner) public onlyOwner {
21         require(newOwner != address(0) && newOwner != owner);
22         emit OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24     }
25 }
26 
27 ///////////// SAFE MATH FUNCTIONS
28 
29 library SafeMath {
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a * b;
32         assert(a == 0 || c / a == b);
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract UserTokensControl is Ownable {
55     address contractReserve;
56 }
57 
58 
59 ///////////// DECLARE ERC223 BASIC INTERFACE
60 
61 contract ERC223ReceivingContract {
62     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
63         _from;
64         _value;
65         _data;
66     }
67 }
68 
69 contract ERC223 {
70     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
71 }
72 
73 contract ERC20 {
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75 }
76 
77 
78 contract BasicToken is ERC20, ERC223, UserTokensControl {
79     uint256 public totalSupply;
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83 
84 
85   ///////////// TRANSFER ////////////////
86 
87     function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         emit Transfer(msg.sender, _to, _value, _data);
92         return true;
93     }
94 
95     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
99         receiver.tokenFallback(msg.sender, _value, _data);
100         emit Transfer(msg.sender, _to, _value);
101         emit Transfer(msg.sender, _to, _value, _data);
102         return true;
103     }
104 
105     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108         require(_value > 0);
109 
110         uint256 codeLength;
111         assembly {
112             codeLength := extcodesize(_to)
113         }
114     
115         if(codeLength > 0) {
116             return transferToContract(_to, _value, _data);
117         } else {
118             return transferToAddress(_to, _value, _data);
119         }
120     }
121 
122 
123     function transfer(address _to, uint256 _value) public returns (bool) {
124         require(_to != address(0));
125         require(_value <= balances[msg.sender]);
126         require(_value > 0);
127 
128         uint256 codeLength;
129         bytes memory empty;
130         assembly {
131             codeLength := extcodesize(_to)
132         }
133 
134         if(codeLength > 0) {
135             return transferToContract(_to, _value, empty);
136         } else {
137             return transferToAddress(_to, _value, empty);
138         }
139     }
140 
141 
142     function balanceOf(address _address) public constant returns (uint256 balance) {
143         return balances[_address];
144     }
145 }
146 
147 
148 contract StandardToken is BasicToken {
149 
150     mapping (address => mapping (address => uint256)) internal allowed;
151 }
152 
153 contract Airstayz is StandardToken {
154     string public constant name = "AIRSTAYZ";
155     uint public constant decimals = 18;
156     string public constant symbol = "STAY";
157 
158     function Airstayz() public {
159         totalSupply=155000000 *(10**decimals);
160         owner = msg.sender;
161         contractReserve = 0xb5AB0c087b9228D584CD4363E3d000187FE69C51;
162         balances[msg.sender] = 150350000 * (10**decimals);
163         balances[contractReserve] = 4650000 * (10**decimals);
164     }
165 
166     function() public {
167         revert();
168     }
169 }