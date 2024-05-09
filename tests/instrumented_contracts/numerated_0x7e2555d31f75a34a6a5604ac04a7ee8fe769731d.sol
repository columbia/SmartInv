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
16     balances[msg.sender] = 51000000000000000000000000;
17     totalSupply = 51000000000000000000000000;
18   }
19 
20   function transfer(address _to, uint256 _amount) returns (bool success) {
21     if (balances[msg.sender] >= _amount 
22       && _amount > 0
23       && balances[_to] + _amount > balances[_to]) {
24         balances[msg.sender] -= _amount;
25         balances[_to] += _amount;
26         Transfer(msg.sender, _to, _amount);
27         return true;
28     } else {
29       return false;
30     }
31 }
32 
33 
34   function balanceOf(address _owner) constant returns (uint256 balance) {
35     return balances[_owner];
36   }
37   
38   function transferFrom(
39        address _from,
40        address _to,
41        uint256 _amount
42    ) returns (bool success) {
43        if (balances[_from] >= _amount
44            && allowed[_from][msg.sender] >= _amount
45            && _amount > 0
46            && balances[_to] + _amount > balances[_to]) {
47            balances[_from] -= _amount;
48            allowed[_from][msg.sender] -= _amount;
49            balances[_to] += _amount;
50            Transfer(_from, _to, _amount);
51            return true;
52       } else {
53            return false;
54        }
55   }
56   
57   function approve(address _spender, uint256 _value) returns (bool) {
58     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
59 
60     allowed[msg.sender][_spender] = _value;
61     Approval(msg.sender, _spender, _value);
62     return true;
63   }
64   
65   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
66     return allowed[_owner][_spender];
67   }
68 
69 }