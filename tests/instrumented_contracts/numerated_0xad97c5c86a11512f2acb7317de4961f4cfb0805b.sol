1 pragma solidity ^0.4.16;
2 
3 contract Token {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) constant public returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 
13     function approve(address _spender, uint256 _value) public returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract StandardToken is Token {
22 
23     mapping (address => uint256) balances;
24     mapping (address => mapping (address => uint256)) allowed;
25 
26 
27     function transfer(address _to, uint256 _value) public returns (bool success) {
28         require(_to != address(0));
29         require(_value <= balances[msg.sender]);
30         require(balances[_to] + _value > balances[_to]);
31         balances[msg.sender] -= _value;
32         balances[_to] += _value;
33         emit Transfer(msg.sender, _to, _value);
34         return true;
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_to != address(0));
39         require(_value <= balances[_from]);
40         require(_value <= allowed[_from][msg.sender]);
41         require(balances[_to] + _value > balances[_to]);
42         balances[_to] += _value;
43         balances[_from] -= _value;
44         allowed[_from][msg.sender] -= _value;
45         emit Transfer(_from, _to, _value);
46         return true;
47     }
48 
49     function balanceOf(address _owner) constant public returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) public returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         emit Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
60         return allowed[_owner][_spender];
61     }
62 }
63 
64 contract lvbaoshi is StandardToken {
65 
66     function () public {
67         revert();
68     }
69 
70 
71     string public name = "lvbaoshi";
72 
73     uint8 public decimals = 18;
74     uint256 private supplyDecimals = 1 * 10 ** uint256(decimals);
75 
76     string public symbol = "LBS";
77 
78     string public version = 'v0.1';
79 
80     address public founder;
81 
82 
83     constructor  (uint256 supply) public {
84         founder = msg.sender;
85         totalSupply = supply * supplyDecimals;
86         balances[founder] = totalSupply;
87     }
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         emit Approval(msg.sender, _spender, _value);
92         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
93         return true;
94     }
95 
96     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         if(!_spender.call(_extraData)) { revert(); }
100         return true;
101     }
102 
103     function addTotalSupplyAmount(uint256 supply) payable public {
104       totalSupply += supply * supplyDecimals;
105       balances[founder] += supply * supplyDecimals;
106     }
107 }