1 pragma solidity ^0.4.15;
2 
3 /*
4 
5     CJX.io - ERC20 Token
6     
7 */
8 
9 contract ERC20 {
10     uint256 public totalSupply;
11     function balanceOf(address _owner) constant returns (uint256 balance);
12     function transfer(address _to, uint256 _value) returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14     function approve(address _spender, uint256 _value) returns (bool success);
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract Token is ERC20 {
22 
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         require(balances[msg.sender] >= _value);
25         balances[msg.sender] -= _value;
26         balances[_to] += _value;
27         Transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
33         balances[_to] += _value;
34         balances[_from] -= _value;
35         allowed[_from][msg.sender] -= _value;
36         Transfer(_from, _to, _value);
37         return true;
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56 }
57 
58 
59 contract CJXToken is Token {
60 
61     string public name;
62     uint8 public decimals;
63     string public symbol;
64     string public version = 'CJX0.1';
65 
66     function CJXToken() {
67         balances[msg.sender] = 1000000000000000000000000;
68         totalSupply = 1000000000000000000000000;
69         name = "CJX COIN";
70         decimals = 18;
71         symbol = "CJX";
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
78         return true;
79     }
80 }