1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     
5     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6     function totalSupply() public view returns (uint256 supply);
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 contract SGem is ERC20Interface, SafeMath {
37     
38     string public symbol;
39     string public name;
40     uint public _totalSupply;
41 
42     mapping(address => uint) balances;
43     mapping(address => mapping(address => uint)) allowed;
44 
45 
46     // CONSTRUCTOR =======================
47     
48     function SGem() public {
49         symbol = "SGEM";
50         name = "S-Gem";
51         _totalSupply = 10000000;
52         balances[msg.sender] = _totalSupply;
53         emit Transfer(address(0), msg.sender, _totalSupply);
54     }
55     
56     // SETTER FUNCTIONS ========================
57     
58     function transfer(address _to, uint256 _value) public returns (bool success) {
59         balances[msg.sender] = safeSub(balances[msg.sender], _value);
60         balances[_to] = safeAdd(balances[_to], _value);
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     // can only be used if _from has approved amount for the sender to transfer from
72     // sender can choose to transfer to any address _to
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         balances[_from] = safeSub(balances[_from], _value);
75         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
76         balances[_to] = safeAdd(balances[_to], _value);
77         emit Transfer(_from, _to, _value);
78         return true;
79     }
80     
81     // GETTER FUNCTIONS ========================
82 
83     function totalSupply() public view returns (uint256 supply) {
84         return supply;
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90     
91     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
92         return allowed[_owner][_spender];
93     }
94     
95 }