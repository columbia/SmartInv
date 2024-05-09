1 pragma solidity ^0.4.16;
2 
3 contract Token {
4 
5     uint256 public totalSupply;
6 
7 
8     function balanceOf(address _owner) constant public returns (uint256 balance);
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11     function approve(address _spender, uint256 _value) public returns (bool success);
12     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract StandardToken is Token {
19 
20     mapping (address => uint256) balances;
21     mapping (address => mapping (address => uint256)) allowed;
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require(_to != address(0));
25         require(_value <= balances[msg.sender]);
26         require(balances[_to] + _value > balances[_to]);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         emit Transfer(msg.sender, _to, _value);
30         return true;
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34         require(_to != address(0));
35         require(_value <= balances[_from]);
36         require(_value <= allowed[_from][msg.sender]);
37         require(balances[_to] + _value > balances[_to]);
38         balances[_to] += _value;
39         balances[_from] -= _value;
40         allowed[_from][msg.sender] -= _value;
41         emit Transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function balanceOf(address _owner) constant public returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         emit Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }
58 }
59 
60 contract lvdongli is StandardToken {
61 
62     function () public {
63         revert();
64     }
65 
66     string public name = "lvdongli";
67     uint8 public decimals = 18;
68     uint256 private supplyDecimals = 1 * 10 ** uint256(decimals);
69     string public symbol = "LDL";
70     string public version = 'v0.1';
71     address public founder;
72     constructor  (uint256 supply) public {
73         founder = msg.sender;
74         totalSupply = supply * supplyDecimals;
75         balances[founder] = totalSupply;
76     }
77 
78     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         emit Approval(msg.sender, _spender, _value);
81         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
82         return true;
83     }
84 
85     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         emit Approval(msg.sender, _spender, _value);
88         if(!_spender.call(_extraData)) { revert(); }
89         return true;
90     }
91 }