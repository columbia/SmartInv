1 pragma solidity ^0.4.8;
2 contract BOBOToken {
3 
4   event Transfer(address indexed _from, address indexed _to, uint256 _value);
5   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
6 
7 
8   mapping( address => uint ) _balances;
9   mapping( address => mapping( address => uint ) ) _approvals;
10   uint256 public totalSupply=21000000;
11   string public name="BOBOToken";
12   uint8 public decimals=8;                
13   string public symbol="BOBO";   
14 
15   function BOBOToken() {
16         _balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
17   }
18 
19   function balanceOf( address _owner ) constant returns (uint balanbce) {
20     return _balances[_owner];
21   }
22 
23   function transfer( address _to, uint _value) returns (bool success) {
24     if ( _balances[msg.sender] < _value ) {
25       revert();
26     }
27     if ( !safeToAdd(_balances[_to], _value) ) {
28       revert();
29     }
30     _balances[msg.sender] -= _value;
31     _balances[_to] += _value;
32     Transfer(msg.sender, _to, _value);
33     return true;
34   }
35   function transferFrom( address _from, address _to, uint _value) returns (bool success) {
36     // if you don't have enough balance, throw
37     if ( _balances[_from] < _value ) {
38       revert();
39     }
40     // if you don't have approval, throw
41     if ( _approvals[_from][msg.sender] < _value ) {
42       revert();
43     }
44     if ( !safeToAdd(_balances[_to], _value) ) {
45       revert();
46     }
47     // transfer and return true
48     _approvals[_from][msg.sender] -= _value;
49     _balances[_from] -= _value;
50     _balances[_to] += _value;
51     Transfer(_from, _to, _value);
52     return true;
53   }
54   function approve(address _spender, uint _value) returns (bool success) {
55     // TODO: should increase instead
56     _approvals[msg.sender][_spender] = _value;
57     Approval(msg.sender, _spender, _value);
58     return true;
59   }
60   function allowance(address _owner, address _spender) constant returns (uint remaining) {
61     return _approvals[_owner][_spender];
62   }
63   function safeToAdd(uint a, uint b) internal returns (bool) {
64     return (a + b >= a);
65   }
66 }