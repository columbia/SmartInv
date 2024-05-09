1 pragma solidity ^0.4.9;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract XToken {
6 
7   string public constant name = "XTOKEN";
8   string public constant symbol = "XTOKEN";
9   uint8 public constant decimals = 18;
10   string public constant version = '0.15';
11   uint256 public constant totalSupply = 1000000000 * 1000000000000000000;
12 
13   address public owner;
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17   event NewOwner(address _newOwner);
18 
19   modifier checkIfToContract(address _to) {
20     if(_to != address(this))  {
21       _;
22     }
23   }
24 
25   mapping (address => uint256) balances;
26   mapping (address => mapping (address => uint256)) allowed;
27 
28   function RoundToken() {
29     owner = msg.sender;
30     balances[owner] = totalSupply;
31   }
32 
33   function replaceOwner(address _newOwner) returns (bool success) {
34     if (msg.sender != owner) throw;
35     owner = _newOwner;
36     NewOwner(_newOwner);
37     return true;
38   }
39 
40   function balanceOf(address _owner) constant returns (uint256 balance) {
41     return balances[_owner];
42   }
43 
44   function transfer(address _to, uint256 _value) checkIfToContract(_to) returns (bool success) {
45     if (balances[msg.sender] >= _value && _value > 0) {
46       balances[msg.sender] -= _value;
47       balances[_to] += _value;
48       Transfer(msg.sender, _to, _value);
49       return true;
50     } else {
51       return false;
52     }
53   }
54 
55   function transferFrom(address _from, address _to, uint256 _value) checkIfToContract(_to) returns (bool success) {
56     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57       balances[_to] += _value;
58       balances[_from] -= _value;
59       allowed[_from][msg.sender] -= _value;
60       Transfer(_from, _to, _value);
61       return true;
62     } else {
63       return false;
64     }
65   }
66 
67   function approve(address _spender, uint256 _value) returns (bool success) {
68     allowed[msg.sender][_spender] = _value;
69     Approval(msg.sender, _spender, _value);
70     return true;
71   }
72 
73   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
74     tokenRecipient spender = tokenRecipient(_spender);
75     if (approve(_spender, _value)) {
76       spender.receiveApproval(msg.sender, _value, this, _extraData);
77       return true;
78     }
79   }
80 
81   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82     return allowed[_owner][_spender];
83   }
84 }