1 pragma solidity ^0.4.11;
2 contract DYCOIN {
3     
4     uint public constant _totalSupply = 500000000;
5     
6     string public constant symbol = "DYC";
7     string public constant name = "DYCOIN";
8     uint8 public constant decimals = 6;
9     
10     mapping(address => uint256) balances;
11     mapping(address => mapping(address => uint256)) allowed;
12     
13     function DYCOIN() {
14         balances[msg.sender] = _totalSupply;
15     }
16     
17     function totalSupply() constant returns (uint256 totalSupply) {
18         return _totalSupply;
19     }
20 
21     function balanceOf(address _owner) constant returns (uint256 balance) {
22         return balances[_owner]; 
23     }
24     
25     function transfer (address _to, uint256 _value) returns (bool success) {
26         require(	
27             balances[msg.sender] >= _value
28             && _value > 0 
29         );
30         balances[msg.sender] -= _value;
31         balances[_to] += _value;
32         Transfer(msg.sender, _to, _value);
33         return true;
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37         require(
38             allowed[_from][msg.sender] >= _value
39             && balances[_from] >= _value
40             && _value > 0 
41         );
42         balances[_from] -= _value;
43         balances[_to] += _value;
44         allowed [_from][msg.sender] -= _value;
45         Transfer (_from, _to, _value);
46     return true;
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50     allowed[msg.sender][_spender] = _value;
51     Approval(msg.sender, _spender, _value);
52     return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56     return allowed[_owner][_spender];
57     }
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
61 }