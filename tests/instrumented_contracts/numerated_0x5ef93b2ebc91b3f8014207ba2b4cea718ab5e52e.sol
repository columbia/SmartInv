1 pragma solidity ^0.4.13;
2 
3 contract ERC20Interface {
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
14 contract TLTContract is ERC20Interface {
15     string public constant symbol = "TLT";
16     string public constant name = "TradeLightning";
17     uint8 public constant decimals = 8;
18     address public owner;
19 
20     uint256 _totalSupply = 100000000000000000;
21     mapping(address => uint256) balances;
22     mapping(address => mapping (address => uint256)) allowed;
23 
24     function TLTContract() {
25         owner = msg.sender;
26         balances[owner] = _totalSupply;
27     }
28 
29     function totalSupply() constant returns (uint256 totalSupply) {
30         return _totalSupply;
31     }
32 
33     function balanceOf(address _owner) constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36 
37     function transfer(address _to, uint256 _amount) returns (bool success) {
38         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
39             balances[msg.sender] -= _amount;
40             balances[_to] += _amount;
41             Transfer(msg.sender, _to, _amount);
42             return true;
43         } else {
44             return false;
45         }
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
49         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
50             balances[_from] -= _amount;
51             allowed[_from][msg.sender] -= _amount;
52             balances[_to] += _amount;
53             Transfer(_from, _to, _amount);
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function approve(address _spender, uint256 _amount) returns (bool success) {
61         allowed[msg.sender][_spender] = _amount;
62         Approval(msg.sender, _spender, _amount);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];
68     }
69 }