1 pragma solidity ^0.4.21;
2 
3 contract ERC223ReceivingContract {
4     function tokenFallback(address _from, uint _value, bytes _data) public;
5 }
6 
7 interface ERC20 {
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 interface ERC223 {
18     function transfer(address to, uint value, bytes data) public;
19     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
20 }
21 
22 
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 contract StandardToken is ERC20, ERC223 {
55     using SafeMath for uint;
56 
57     string internal _name;
58     string internal _symbol;
59     uint8 internal _decimals;
60     uint256 internal _totalSupply;
61 
62     mapping (address => uint256) internal balances;
63     mapping (address => mapping (address => uint256)) internal allowed;
64 
65     function StandardToken() public {
66         _name = "RBToken";                                   // Set the name for display purposes
67         _decimals = 18;                            // Amount of decimals for display purposes
68         _symbol = "RBT";                               // Set the symbol for display purposes
69         _totalSupply = 1000000000000000000000000000;                        // Update total supply (100000 for example)
70         balances[msg.sender] = 1000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
71     }
72 
73     function name()
74     public
75     view
76     returns (string) {
77         return _name;
78     }
79 
80     function symbol()
81     public
82     view
83     returns (string) {
84         return _symbol;
85     }
86 
87     function decimals()
88     public
89     view
90     returns (uint8) {
91         return _decimals;
92     }
93 
94     function totalSupply()
95     public
96     view
97     returns (uint256) {
98         return _totalSupply;
99     }
100 
101     function transfer(address _to, uint256 _value) public returns (bool) {
102         require(_to != address(0));
103         require(_value <= balances[msg.sender]);
104         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
105         balances[_to] = SafeMath.add(balances[_to], _value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     function transfer(address _to, uint _value, bytes _data) public {
111         require(_value > 0 );
112         if(isContract(_to)) {
113             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
114             receiver.tokenFallback(msg.sender, _value, _data);
115         }
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         Transfer(msg.sender, _to, _value, _data);
119     }
120 
121     function isContract(address _addr) private returns (bool is_contract) {
122         uint length;
123         assembly {
124         //retrieve the size of the code on target address, this needs assembly
125             length := extcodesize(_addr)
126         }
127         return (length>0);
128     }
129 
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = SafeMath.sub(balances[_from], _value);
140         balances[_to] = SafeMath.add(balances[_to], _value);
141         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
142         Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function allowance(address _owner, address _spender) public view returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
158         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
163         uint oldValue = allowed[msg.sender][_spender];
164         if (_subtractedValue > oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         } else {
167             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
168         }
169         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 }