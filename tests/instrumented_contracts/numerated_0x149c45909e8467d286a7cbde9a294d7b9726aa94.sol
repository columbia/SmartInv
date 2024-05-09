1 pragma solidity ^0.4.11;
2 
3 
4 contract ECNcoin {
5     
6     uint public constant _totalsupply = 33333333;
7     
8     string public constant symbol = "ECNC";
9     string public constant name = "ECN coin";
10     uint8 public constant desimls = 8;
11     
12     mapping(address => uint256) balances;
13     mapping(address => mapping(address => uint256)) allowed;
14     
15     function ECNcoin(){
16         balances[msg.sender] = _totalsupply;
17     }
18     
19     function totalSupply() constant returns (uint256 _totalSupply) {
20         return _totalsupply;
21     }
22     
23     function balanceOf(address _owner) constant returns (uint256 balance) {
24         return balances[_owner];
25     }
26     
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         require(
29             balances[msg.sender] >= _value
30             && _value > 0
31         );
32         balances[msg.sender] -= _value;
33         balances[_to] += _value;
34         Transfer(msg.sender, _to, _value);
35         return true;
36     }
37     
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
39         require(
40             allowed[_from][msg.sender] >= _value
41             && balances[_from] >= _value
42             && _value > 0
43         );
44         balances[_from] -= _value;
45         balances[_to] += _value;
46         allowed[_from][msg.sender] -= _value;
47         Transfer(_from, _to, _value);
48         return true;
49     }
50     
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56     
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58         return allowed[_owner][_spender];
59     }
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }