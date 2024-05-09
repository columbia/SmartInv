1 pragma solidity ^0.4.4;
2 
3 contract qorva{
4 	mapping (address => uint256) balances;
5     mapping (address => mapping (address => uint256)) allowed;
6     uint256 public totalSupply = 0;
7     string public name;                   
8     uint8 public decimals;                
9     string public symbol;   
10 	address public owner;
11 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     function safeMul(uint a, uint b) internal returns (uint) {
14         uint c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function safeSub(uint a, uint b) internal returns (uint) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function safeAdd(uint a, uint b) internal returns (uint) {
25         uint c = a + b;
26         assert(c>=a && c>=b);
27         return c;
28     }
29 
30     function assert(bool assertion) internal {
31         if (!assertion) throw;
32     }
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] = safeSub(balances[msg.sender], _value);
36             balances[_to] = safeAdd(balances[_to],_value);
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43             balances[_to] = safeAdd(balances[_to], _value);
44             balances[_from] = safeSub(balances[_from], _value);
45             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
46             Transfer(_from, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54     function approve(address _spender, uint256 _value) returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         Approval(msg.sender, _spender, _value);
57         return true;
58     }
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60         return allowed[_owner][_spender];
61     }
62 	function () payable {
63         throw;
64     }
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
68         return true;
69     }
70 	//token init
71     function qorva(
72         uint256 initialSupply
73     ) public {
74         decimals = 18;   
75         totalSupply = initialSupply * 10 ** uint256(decimals);  
76         balances[msg.sender] = initialSupply * 10 ** uint256(decimals);  
77         owner = msg.sender;
78         name = "QORVA";
79         symbol = "QOR";
80     }
81 }