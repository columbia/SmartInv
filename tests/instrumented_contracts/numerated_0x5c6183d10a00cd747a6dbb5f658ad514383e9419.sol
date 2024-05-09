1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15 	bool public disabled = false;
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (disabled != true && balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (disabled != true && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33     function balanceOf(address _owner) constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36     function approve(address _spender, uint256 _value) returns (bool success) {
37         allowed[msg.sender][_spender] = _value;
38         Approval(msg.sender, _spender, _value);
39         return true;
40     }
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
42       return allowed[_owner][_spender];
43     }
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46 }
47 
48 contract NexxusToken is StandardToken {
49 
50     function () {throw;}
51 
52     string public name = "Nexxus";
53     uint8 public decimals = 8;
54     string public symbol = "NXX";
55     address public owner;
56 
57     function NexxusToken() {
58         totalSupply = 31500000000000000;
59         owner = msg.sender;
60         balances[owner] = totalSupply;
61     }
62     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
66         return true;
67     }
68 	function mintToken(uint256 _amount) {
69         if (msg.sender == owner) {
70     		totalSupply += _amount;
71             balances[owner] += _amount;
72     		Transfer(0, owner, _amount);
73         }
74 	}
75 	function disableToken(bool _disable) { 
76         if (msg.sender == owner)
77 			disabled = _disable;
78     }
79 }