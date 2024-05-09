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
48 contract Pausable is Owned {
49     bool public paused = false;
50     event Pause();
51     event Unpause();
52 
53     modifier notPaused {
54         require(!paused);
55         _;
56     }
57 
58     function pause() public onlyOwner {
59         paused = true;
60         emit Pause();
61     }
62 
63     function unpause() public onlyOwner {
64         paused = false;
65         emit Unpause();
66     }
67 }
68 
69 contract EIP20Interface {
70     function totalSupply() public view returns (uint256);
71     function balanceOf(address _owner) public view returns (uint256 balance);
72     function transfer(address _to, uint256 _value) public returns (bool success);
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
74     function approve(address _spender, uint256 _value) public returns (bool success);
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 
82 contract Adet is Owned, SafeMath, Pausable, EIP20Interface {
83     uint256 private totalSupply_;
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87     
88     mapping (address => uint256) public balances;
89     mapping (address => uint256) public frozen;
90     mapping (address => mapping (address => uint256)) public allowed;
91 
92     event Freeze(address indexed from, uint256 value);
93     event Unfreeze(address indexed from, uint256 value);
94     event Burned(address indexed from, uint256 value);
95 
96     constructor() public {
97         name = "Australia Digital Econmoy";
98         symbol = "ADET";
99         decimals = 6;
100         totalSupply_ = 2800000000 * 10 ** uint256(decimals);
101         balances[msg.sender] = totalSupply_;
102     }
103 
104     // burn
105     function burn(address _addr, uint256 _amount) onlyOwner public returns (bool success) {
106         require(_addr != 0);
107         require(_amount <= balances[_addr]);
108 
109         totalSupply_ = sub(totalSupply_, _amount);
110         balances[_addr] = sub(balances[_addr], _amount);
111         emit Transfer(_addr, address(0), _amount);
112         emit Burned(_addr, _amount);
113         return true;
114     }
115 
116     // freeze part
117     function freeze(address _addr, uint256 _value) public onlyOwner returns (bool success) {
118         require(balances[_addr] >= _value);
119         require(_value > 0);
120         balances[_addr] = sub(balances[_addr], _value);
121         frozen[_addr] = add(frozen[_addr], _value);
122         emit Freeze(_addr, _value);
123         return true;
124     }
125     
126     function unfreeze(address _addr, uint256 _value) public onlyOwner returns (bool success) {
127         require(frozen[_addr] >= _value);
128         require(_value > 0);
129         frozen[_addr] = sub(frozen[_addr], _value);
130         balances[_addr] = add(balances[_addr], _value);
131         emit Unfreeze(_addr, _value);
132         return true;
133     }
134 
135     function frozenOf(address _addr) public view returns (uint256 balance) {
136         return frozen[_addr];
137     }
138     
139     // erc20 part
140     function totalSupply() public view returns (uint256) {
141         return totalSupply_;
142     }
143 
144     function balanceOf(address _addr) public view returns (uint256 balance) {
145         return balances[_addr];
146     }
147 
148     function transfer(address _to, uint256 _value) public notPaused returns (bool success) {
149         require(balances[msg.sender] >= _value);
150         require(balances[_to] + _value >= balances[_to]);
151         balances[msg.sender] -= _value;
152         balances[_to] += _value;
153         emit Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     function transferFrom(address _from, address _to, uint256 _value) public notPaused returns (bool success) {
158         require(balances[_from] >= _value);
159         require(balances[_to] + _value >= balances[_to]);
160         require(allowed[_from][msg.sender] >= _value);
161         balances[_to] += _value;
162         balances[_from] -= _value;
163         allowed[_from][msg.sender] -= _value;
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     function approve(address _spender, uint256 _value) public notPaused returns (bool success) {
169         require(_value > 0);
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
176         return allowed[_owner][_spender];
177     } 
178 }