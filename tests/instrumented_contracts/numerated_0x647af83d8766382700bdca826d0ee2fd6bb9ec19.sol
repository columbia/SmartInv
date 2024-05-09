1 pragma solidity ^0.4.11;
2 
3 interface IERC20  {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract AlgeriaToken is IERC20 {
15     
16     uint public constant _totalSupply= 10000000000;
17     
18     string public constant symbol= "☺ DZT";
19     string public constant name= "Algeria Token";
20     uint8 public constant decimals = 3;
21     mapping(address => uint256) balances;
22     mapping(address => mapping(address => uint256)) allowed;
23     function AlgeriaToken() {
24         balances[msg.sender] = _totalSupply;
25     }
26     
27     function totalSupply() constant returns (uint256 totalSupply){
28         return _totalSupply;
29     }
30     
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];
33     }
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         require(
36             balances[msg.sender] >= _value
37             && _value > 0
38             );
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         Transfer(msg.sender, _to, _value);
42         return true;
43     }
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         require(
46             allowed[_from][msg.sender] >= _value
47             && balances[_from] >= _value
48             && _value > 0
49             );
50         balances[_from] -= _value;
51         balances[_to] += _value;
52         allowed[_from][msg.sender] -= _value;
53         Transfer(_from, _to, _value);
54         return true;
55     }
56     
57     function approve(address _spender, uint256 _value) returns (bool success){
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63         return allowed[_owner][_spender];   
64          }
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     
68 }