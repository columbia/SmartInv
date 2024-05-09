1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function transfer(address _to, uint256 _value) public returns (bool success) {
6         if (balances[msg.sender] >= _value && _value > 0) {
7             balances[msg.sender] -= _value;
8             balances[_to] += _value;
9             emit Transfer(msg.sender, _to, _value);
10             return true;
11         }else{
12             return false;
13         }
14     }
15 
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
17         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
18             balances[_to] += _value;
19             balances[_from] -= _value;
20             allowed[_from][msg.sender] -= _value;
21             emit Transfer(_from, _to, _value);
22             return true;
23         }else{
24             return false;
25         }
26     }
27 
28     function balanceOf(address _owner) public view returns (uint256 balance) {
29         return balances[_owner];
30     }
31 
32     function approve(address _spender, uint256 _value) public returns (bool success) {
33         allowed[msg.sender][_spender] = _value;
34         emit Approval(msg.sender, _spender, _value);
35         return true;
36     }
37 
38     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
39         return allowed[_owner][_spender];
40     }
41 
42     mapping (address => uint256) balances;
43     mapping (address => mapping (address => uint256)) allowed;
44     uint256 public totalSupply;
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract Brain is Token {
51 
52     function () public {
53         require(false);
54     }
55 
56     string public name;
57     uint8 public decimals;
58     string public symbol;
59     string public version = "H1.0";
60 
61 
62     constructor () public {
63         balances[msg.sender] = 14000000000000000000000000000;
64         totalSupply = 14000000000000000000000000000;
65         name = "BTX Baby";
66         decimals = 18;
67         symbol = "BTX";
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         emit Approval(msg.sender, _spender, _value);
73 
74         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
75             require(false);
76         }
77         return true;
78     }
79 }