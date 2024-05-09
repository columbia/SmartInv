1 pragma solidity ^0.4.16;
2 contract Token {
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract StandardToken is Token {
13 function transfer(address _to, uint256 _value) returns (bool success) {
14         if (balances[msg.sender] >= _value && _value > 0) {
15             balances[msg.sender] -= _value;
16             balances[_to] += _value;
17             Transfer(msg.sender, _to, _value);
18             return true;
19         } else { return false; }
20     }
21 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
22         //same as above. Replace this line with the following if you want to protect against wrapping uints.
23         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
24         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 function balanceOf(address _owner) constant returns (uint256 balance) {
33         return balances[_owner];
34     }
35 function approve(address _spender, uint256 _value) returns (bool success) {
36         allowed[msg.sender][_spender] = _value;
37         Approval(msg.sender, _spender, _value);
38         return true;
39     }
40 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
41         return allowed[_owner][_spender];
42     }
43 mapping (address => uint256) balances;
44     mapping (address => mapping (address => uint256)) allowed;
45     uint256 public totalSupply;
46 }
47 contract eForecastGambleToken is StandardToken {
48 function () {
49         //if ether is sent to this address, send it back.
50         throw;
51     }
52 string public name;                 
53     uint8 public decimals;
54     string public symbol; 
55     string public version = 'H1.0';
56 function eForecastGambleToken(
57         ) {
58         balances[msg.sender] = 30000000000;
59         totalSupply = 30000000000;
60         name = "eForecastGambleToken";
61         decimals = 3;
62         symbol = "eFGT";
63     }
64 function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67 if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
68         return true;
69     }
70 }