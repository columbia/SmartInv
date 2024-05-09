1 pragma solidity ^0.4.19;
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
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         require(_to != address(0));
28         require(_value <= balances[msg.sender]);
29         require(balances[_to] + _value > balances[_to]);
30         balances[msg.sender] -= _value;
31         balances[_to] += _value;
32         Transfer(msg.sender, _to, _value);
33         return true;
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         require(_to != address(0));
38         require(_value <= balances[_from]);
39         require(_value <= allowed[_from][msg.sender]);
40         require(balances[_to] + _value > balances[_to]);
41         balances[_to] += _value;
42         balances[_from] -= _value;
43         allowed[_from][msg.sender] -= _value;
44         Transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function balanceOf(address _owner) constant public returns (uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function approve(address _spender, uint256 _value) public returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
59         return allowed[_owner][_spender];
60     }
61 }
62 
63 contract CryptoStrategies is StandardToken {
64 
65     function () public {
66         revert();
67     }
68 
69     string public name = "CryptoStrategies";
70     uint8 public decimals = 18;
71     uint256 private supplyDecimals = 1 * 10 ** uint256(decimals);
72     string public symbol = "CS";
73     string public version = 'v0.1';
74     address public founder;
75 
76     function CryptoStrategies() public {
77         founder = msg.sender;
78         totalSupply = 100000000000 * supplyDecimals;
79         balances[founder] = totalSupply;
80     }
81 
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
86         return true;
87     }
88 
89     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         if(!_spender.call(_extraData)) { revert(); }
93         return true;
94     }
95 }