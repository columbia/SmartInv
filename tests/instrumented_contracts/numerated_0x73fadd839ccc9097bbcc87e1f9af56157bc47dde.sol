1 pragma solidity 0.4.24;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract SafeMath {
23     function mul(uint a, uint b) internal pure returns (uint) {
24         uint c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint a, uint b) internal pure returns (uint) {
30         assert(b > 0);
31         uint c = a / b;
32         assert(a == b * c + a % b);
33         return c;
34     }
35 
36     function sub(uint a, uint b) internal pure returns (uint) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint a, uint b) internal pure returns (uint) {
42         uint c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 
49 contract Pausable is Owned {
50     bool public paused = false;
51     event Pause();
52     event Unpause();
53 
54     modifier notPaused {
55         require(!paused);
56         _;
57     }
58 
59     function pause() public onlyOwner {
60         paused = true;
61         emit Pause();
62     }
63 
64     function unpause() public onlyOwner {
65         paused = false;
66         emit Unpause();
67     }
68 }
69 
70 
71 contract EIP20Interface {
72     uint256 public totalSupply;
73 
74     function balanceOf(address _owner) public view returns (uint256 balance);
75     function transfer(address _to, uint256 _value) public returns (bool success);
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
77     function approve(address _spender, uint256 _value) public returns (bool success);
78     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 }
83 
84 
85 contract CDSToken is Owned, SafeMath, Pausable, EIP20Interface {
86     string public name;
87     string public symbol;
88     uint8 public decimals;
89 
90     uint8 public version = 1;
91     
92     mapping (address => uint256) public balances;
93     mapping (address => uint256) public frozen;
94     mapping (address => mapping (address => uint256)) public allowed;
95 
96     event Freeze(address indexed from, uint256 value);
97     event Unfreeze(address indexed from, uint256 value);
98 
99     constructor() public {
100         name = "CodePress Token";
101         symbol = "CDS";
102         decimals = 18;
103         totalSupply = 800000000 * 10 ** uint256(decimals);
104         balances[msg.sender] = totalSupply;
105     }
106 
107     // cds part
108     function freeze(address _addr, uint256 _value) public onlyOwner returns (bool success) {
109         require(balances[_addr] >= _value);
110         require(_value > 0);
111         balances[_addr] = sub(balances[_addr], _value);
112         frozen[_addr] = add(frozen[_addr], _value);
113         emit Freeze(_addr, _value);
114         return true;
115     }
116     
117     function unfreeze(address _addr, uint256 _value) public onlyOwner returns (bool success) {
118         require(frozen[_addr] >= _value);
119         require(_value > 0);
120         frozen[_addr] = sub(frozen[_addr], _value);
121         balances[_addr] = add(balances[_addr], _value);
122         emit Unfreeze(_addr, _value);
123         return true;
124     }
125 
126     function frozenOf(address _owner) public view returns (uint256 balance) {
127         return frozen[_owner];
128     }
129     
130     // erc20 part
131     function balanceOf(address _owner) public view returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     function transfer(address _to, uint256 _value) public notPaused returns (bool success) {
136         require( _to != address(0));
137         require(balances[msg.sender] >= _value);
138         require(balances[_to] + _value >= balances[_to]);
139         balances[msg.sender] -= _value;
140         balances[_to] += _value;
141         emit Transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _value) notPaused public returns (bool success) {
146         require( _to != address(0));
147         require(balances[_from] >= _value);
148         require(balances[_to] + _value >= balances[_to]);
149         require(allowed[_from][msg.sender] >= _value);
150         balances[_to] += _value;
151         balances[_from] -= _value;
152         allowed[_from][msg.sender] -= _value;
153         emit Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     function approve(address _spender, uint256 _value) public notPaused returns (bool success) {
158         require( _spender != address(0));
159         require(_value > 0);
160         require((_value == 0)||(allowed[msg.sender][_spender] == 0));
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
167         return allowed[_owner][_spender];
168     } 
169 }