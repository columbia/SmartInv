1 pragma solidity ^0.4.24;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract StandardERC20 is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19         if (balances[msg.sender] >= _value && _value > 0) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             emit Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             emit Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43         emit Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
48       return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53     uint256 public totalSupply;
54 }
55 
56 contract NewCurrency is StandardERC20 {
57 
58     //if ether is sent to this address, send it back.
59     function () {
60         revert();
61     }
62 
63     string public name;
64     uint8 public decimals;
65     string public symbol;
66     string public version = 'H0.1';
67 
68     function constuctor() {
69         name = "Global Digital Junction";
70         decimals = 8;
71         symbol = "GDJ";
72         totalSupply = 650 * 10**uint(6) * 10**uint(decimals);
73         balances[msg.sender] = totalSupply;
74     }
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         emit Approval(msg.sender, _spender, _value);
79         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
80         return true;
81     }
82 }