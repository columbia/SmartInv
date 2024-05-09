1 pragma solidity ^0.4.13;
2 
3 contract SpareCurrencyToken {
4   string public constant name = "SpareCurrencyToken";
5   string public constant symbol = "SCT";
6   uint8 public constant decimals = 18;
7   
8   uint256 public totalSupply;
9   mapping(address => uint256) balances;
10   mapping (address => mapping (address => uint256)) allowed;
11 
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14   
15   function SpareCurrencyToken() {
16     balances[msg.sender] = 5100000000000000000000;
17     totalSupply = 5100000000000000000000;
18   }
19 
20   function transfer(address _to, uint256 _amount) returns (bool success) {
21     if (balances[msg.sender] >= _amount 
22       && _amount > 0
23       && balances[_to] + _amount > balances[_to]) {
24         balances[msg.sender] -= _amount;
25         balances[_to] += _amount;
26         return true;
27     } else {
28       return false;
29     }
30 }
31 
32 
33   function balanceOf(address _owner) constant returns (uint256 balance) {
34     return balances[_owner];
35   }
36   
37   function transferFrom(
38        address _from,
39        address _to,
40        uint256 _amount
41    ) returns (bool success) {
42        if (balances[_from] >= _amount
43            && allowed[_from][msg.sender] >= _amount
44            && _amount > 0
45            && balances[_to] + _amount > balances[_to]) {
46            balances[_from] -= _amount;
47            allowed[_from][msg.sender] -= _amount;
48            balances[_to] += _amount;
49            return true;
50       } else {
51            return false;
52        }
53   }
54   
55   function approve(address _spender, uint256 _value) returns (bool) {
56     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
57 
58     allowed[msg.sender][_spender] = _value;
59     Approval(msg.sender, _spender, _value);
60     return true;
61   }
62   
63   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64     return allowed[_owner][_spender];
65   }
66 
67 }