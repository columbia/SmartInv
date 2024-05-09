1 pragma solidity 0.4.19;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     function Owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12       require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address _newOwner) public onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 
22 // ERC20 Short Address Attack fix
23 contract InputValidator {
24     modifier safeArguments(uint _numArgs) {
25         assert(msg.data.length == _numArgs * 32 + 4);
26         _;
27     }
28 }
29 
30 
31 contract ERC20 {
32     function totalSupply() constant returns (uint totalSupply);
33     function balanceOf(address _owner) constant returns (uint balance);
34     function transfer(address _to, uint _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) returns (bool success);
36     function approve(address _spender, uint _value) returns (bool success);
37     function allowance(address _owner, address _spender) constant returns (uint remaining);
38 
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41 }
42 
43 
44 contract EngravedCoin is ERC20, InputValidator, Owned {
45     string public name = "Engraved Coin";
46     string public symbol = "XEG";
47     uint8 public decimals = 18;
48 
49     // Token state
50     uint internal currentTotalSupply;
51 
52     // Token balances
53     mapping (address => uint) internal balances;
54 
55     // Token allowances
56     mapping (address => mapping (address => uint)) internal allowed;
57 
58     function EngravedCoin() public {
59         owner = msg.sender;
60         balances[msg.sender] = 0;
61         currentTotalSupply = 0;
62     }
63 
64     function () public payable {
65         revert();
66     }
67 
68     function totalSupply() public constant returns (uint) {
69         return currentTotalSupply;
70     }
71 
72     function balanceOf(address _owner) public constant returns (uint) {
73         return balances[_owner];
74     }
75 
76     function transfer(address _to, uint _value) public safeArguments(2) returns (bool) {
77         require(balances[msg.sender] >= _value);
78         require(balances[_to] + _value >= balances[_to]);
79 
80         balances[msg.sender] -= _value;
81         balances[_to] += _value;
82 
83         Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function transferFrom(address _from, address _to, uint _value) public safeArguments(3) returns (bool) {
88         require(balances[_from] >= _value);
89         require(balances[_to] + _value >= balances[_to]);
90         require(_value <= allowed[_from][msg.sender]);
91 
92         balances[_to] += _value;
93         balances[_from] -= _value;
94 
95         allowed[_from][msg.sender] -= _value;
96 
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint _value) public safeArguments(2) returns (bool) {
102         allowed[msg.sender][_spender] = _value;
103 
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public constant returns (uint) {
109         return allowed[_owner][_spender];
110     }
111 
112     function issue(address _to, uint _value) public onlyOwner safeArguments(2) returns (bool) {
113         require(balances[_to] + _value > balances[_to]);
114 
115         balances[_to] += _value;
116         currentTotalSupply += _value;
117 
118         Transfer(0, this, _value);
119         Transfer(this, _to, _value);
120 
121         return true;
122     }
123 
124 }