1 pragma solidity ^0.4.9;
2 contract Token {
3     uint256 public totalSupply;
4     function balanceOf(address _owner) constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
7     function approve(address _spender, uint256 _value) returns (bool success);
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract StandardToken is Token {
13     function transfer(address _to, uint256 _value) returns (bool success) {
14         if (balances[msg.sender] >= _value && _value > 0) {
15             balances[msg.sender] -= _value;
16             balances[_to] += _value;
17             Transfer(msg.sender, _to, _value);
18             return true;
19         } else { return false; }
20     }
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
22         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
23             balances[_to] += _value;
24             balances[_from] -= _value;
25             allowed[_from][msg.sender] -= _value;
26             Transfer(_from, _to, _value);
27             return true;
28         } else { return false; }
29     }
30     function balanceOf(address _owner) constant returns (uint256 balance) {
31         return balances[_owner];
32     }
33     function approve(address _spender, uint256 _value) returns (bool success) {
34         allowed[msg.sender][_spender] = _value;
35         Approval(msg.sender, _spender, _value);
36         return true;
37     }
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
39       return allowed[_owner][_spender];
40     }
41     mapping (address => uint256) balances;
42     mapping (address => mapping (address => uint256)) allowed;
43 }
44 
45 contract BitliquorStandardToken is StandardToken {
46     function () {
47         throw;
48     }
49     string public name;       
50     uint8 public decimals;
51     string public symbol;              
52     string public version = 'H0.1';
53     function BitliquorStandardToken(
54         uint256 _initialAmount,
55         string _tokenName,
56         uint8 _decimalUnits,
57         string _tokenSymbol
58         ) {
59         balances[msg.sender] = _initialAmount;              
60         totalSupply = _initialAmount;                        
61         name = _tokenName;                                   
62         decimals = _decimalUnits;                            
63         symbol = _tokenSymbol;
64     }
65 
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
70         return true;
71     }
72 }