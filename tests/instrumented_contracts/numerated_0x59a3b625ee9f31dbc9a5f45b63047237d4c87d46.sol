1 pragma solidity ^0.4.11; 
2 
3 
4 
5 
6 contract VagCoin  {
7     
8     uint public constant _totalSupply = 50000000;
9     
10     string public constant symbol ="VAG";
11     string public constant name ="VagCoin";
12     uint8 public constant decimals =0;
13     
14         
15     mapping(address => uint256) balances;
16     mapping(address => mapping(address => uint256)) allowed;
17     
18     
19         
20         
21     function Vag() {
22         balances[msg.sender] = _totalSupply;
23     }
24     function totalSupply() constant returns (uint256 totalSupply) {
25         return _totalSupply;
26     }
27     
28     function balanceOf(address _owner) constant returns (uint256 balance) {
29         return balances[_owner];
30         
31         
32     }
33     
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         require(
36             balances[msg.sender] >= _value
37             && _value > 0);
38         balances[msg.sender] -= _value;
39         balances[_to] += _value;
40         Transfer(msg.sender, _to,  _value);
41         return true;
42         
43         }
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46         require (
47              allowed[_from][msg.sender] >= _value
48              && balances [_from] >= _value
49              && _value >0
50              );
51              balances[_from] -= _value;
52              balances[_to] += _value;
53              allowed[_from][msg.sender] -= _value;
54              Transfer(_from, _to, _value);
55              return true;
56              
57     }
58     function approve(address _spender, uint256 _value) returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
64 {
65     return allowed[_owner][_spender];
66     
67 }    
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     
71 }