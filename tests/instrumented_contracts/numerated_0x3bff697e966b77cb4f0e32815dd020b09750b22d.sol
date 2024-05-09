1 pragma solidity ^0.5.1;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public view returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract Owned {
15 
16     address public owner;
17 
18     address newOwner = address(0x0);
19 
20     modifier isOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29     event OwnerUpdate(address _prevOwner, address _newOwner);
30 
31     function changeOwner(address _newOwner) public isOwner {
32         require(_newOwner != owner);
33         newOwner = _newOwner;
34     }
35 
36     function acceptOwnership() public {
37         require(msg.sender == newOwner);
38         emit OwnerUpdate(owner, newOwner);
39         owner = newOwner;
40         newOwner = address(0x0);
41     }
42 
43 }
44 
45 contract Controlled is Owned {
46 
47     bool public transferEnable = true;
48 
49     bool public lockFlag = true;
50 
51     constructor() public {
52        setExclude(msg.sender);
53     }
54 
55     mapping(address => bool) public locked;
56 
57     mapping(address => bool) public exclude;
58 
59     function enableTransfer(bool _enable) public isOwner{
60         transferEnable = _enable;
61     }
62 
63     function disableLock(bool _enable) public isOwner returns (bool success){
64         lockFlag = _enable;
65         return true;
66     }
67 
68     function addLock(address _addr) public isOwner returns (bool success){
69         require(_addr != msg.sender);
70         locked[_addr] = true;
71         return true;
72     }
73 
74     function setExclude(address _addr) public isOwner returns (bool success){
75         exclude[_addr] = true;
76         return true;
77     }
78 
79     function removeLock(address _addr) public isOwner returns (bool success){
80         locked[_addr] = false;
81         return true;
82     }
83 
84     modifier transferAllowed(address _addr) {
85         if (!exclude[_addr]) {
86             assert(transferEnable);
87             if(lockFlag){
88                 assert(!locked[_addr]);
89             }
90         }
91         _;
92     }
93 
94     modifier validAddress(address _addr) {
95         assert(address(0x0) != _addr && address(0x0) != msg.sender);
96         _;
97     }
98 }
99 
100 contract StandardToken is Token, Controlled {
101 
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) validAddress(_to) returns (bool success) {
107         require(_value > 0);
108         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
109             balances[msg.sender] -= _value;
110             balances[_to] += _value;
111             emit Transfer(msg.sender, _to, _value);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(msg.sender) validAddress(_to) returns (bool success) {
119         require(_value > 0);
120         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
121             balances[_to] += _value;
122             balances[_from] -= _value;
123             allowed[_from][msg.sender] -= _value;
124             emit Transfer(_from, _to, _value);
125             return true;
126         } else {
127             return false;
128         }
129     }
130 
131     function approve(address _spender, uint256 _value) public returns (bool success) {
132         require(_value > 0);
133         allowed[msg.sender][_spender] = _value;
134         emit Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142     mapping (address => uint256) balances;
143     mapping (address => mapping (address => uint256)) allowed;
144 }
145 
146 contract Currency is StandardToken {
147 
148     string public name;
149     string public symbol;
150     uint8 public decimals = 18;
151 
152     constructor (address _addr, uint256 initialSupply, string memory _tokenName, string memory _tokenSymbol) public {
153         setExclude(_addr);
154         totalSupply = initialSupply * 10 ** uint256(decimals);
155         balances[_addr] = totalSupply;
156         name = _tokenName;
157         symbol = _tokenSymbol;
158     }
159 
160 }