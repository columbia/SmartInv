1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) public onlyOwner {
21         if (newOwner != address(0)) {
22             owner = newOwner;
23         }
24     }
25 }
26 
27 contract Extension is Ownable {
28 
29     mapping(address => bool) extensions;
30 
31     function addExtension(address _contract) public onlyOwner {
32         extensions[_contract] = true;
33     }
34 
35     function hasExtension(address _contract) public view returns (bool){
36         return extensions[_contract];
37     }
38 
39     function removeExtension(address _contract) public onlyOwner {
40         delete extensions[_contract];
41     }
42 
43     modifier onlyExtension() {
44         require(extensions[msg.sender] == true);
45         _;
46     }
47 }
48 
49 contract CryptoBotsIdleToken is Ownable, Extension {
50 
51     string public name = "CryptoBots: Idle Token";
52     string public symbol = "CBIT";
53     uint8 public decimals = 2;
54 
55     uint256 public totalSupply;
56 
57     mapping(address => uint256) public balances;
58     mapping(address => mapping(address => uint256)) public allowed;
59 
60     //Event which is triggered to log all transfers to this contract's event log
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     //Event which is triggered whenever an owner approves a new allowance for a spender.
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 
65     function balanceOf(address _owner) public view returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function transfer(address _to, uint256 _value) public returns (bool success) {
70         balances[msg.sender] = safeSub(balances[msg.sender], _value);
71         balances[_to] = safeAdd(balances[_to], _value);
72         emit Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function batchTransfer(address[] _to, uint256 _value) public {
77         balances[msg.sender] = safeSub(balances[msg.sender], safeMul(_to.length, _value));
78 
79         for (uint i = 0; i < _to.length; i++) {
80             balances[_to[i]] += safeAdd(balances[_to[i]], _value);
81             emit Transfer(msg.sender, _to[i], _value);
82         }
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         balances[_to] = safeAdd(balances[_to], _value);
87         balances[_from] = safeSub(balances[_from], _value);
88 
89         if (hasExtension(_to) == false && hasExtension(_from) == false) {
90             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
91         }
92 
93         emit Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address _spender, uint256 _value) public returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
104         return allowed[_owner][_spender];
105     }
106 
107     function withdraw() public onlyOwner {
108         msg.sender.transfer(address(this).balance);
109     }
110 
111     function create(uint _amount) public onlyOwner {
112         balances[msg.sender] = safeAdd(balances[msg.sender], _amount);
113         totalSupply = safeAdd(totalSupply, _amount);
114     }
115 
116     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118             return 0;
119         }
120         uint256 c = a * b;
121         assert(c / a == b);
122         return c;
123     }
124 
125     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         assert(c >= a);
128         return c;
129     }
130 
131     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
132         assert(b <= a);
133         return a - b;
134     }
135 }