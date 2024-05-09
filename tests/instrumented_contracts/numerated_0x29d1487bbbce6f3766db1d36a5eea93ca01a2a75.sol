1 pragma solidity ^0.4.19;
2 
3 contract ChiPhiCoin {
4 
5     address owner;
6     uint _totalSupply = 310000;
7     
8     mapping (address => uint) balances;
9     mapping (address => mapping(address => uint)) allowed;
10     
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13     
14     string public constant name = "ChiPhi Coin";
15     string public constant symbol = "XPM";
16     uint8 public constant decimals = 18;
17     
18     function ChiPhiCoin() public {
19         owner = msg.sender;
20         balances[owner] = 310000;
21     }
22     
23     function totalSupply() public constant returns (uint256 tSupply) {
24         return _totalSupply;
25      }
26     
27     function balanceOf(address _owner) public constant returns (uint) {
28         return balances[_owner];
29     }
30     
31     function transfer(address _to, uint _amount) public returns (bool success) {
32         if (balances[msg.sender] >= _amount
33             && _amount > 0
34             && balances[_to] + _amount > balances[_to]) {
35                 balances[msg.sender] -= _amount;
36                 balances[_to] += _amount;
37                 Transfer(msg.sender, _to, _amount);
38                 return true;
39         }
40         else {
41             return false;
42         }
43     }
44     
45     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
46         if (balances[_from] >= _amount
47             && allowed[_from][msg.sender] >= _amount
48             && _amount > 0
49             && balances[_to] + _amount > balances[_to]) {
50             balances[_from] -= _amount;
51             balances[_to] += _amount;
52             Transfer(_from, _to, _amount);
53             return true;
54         }
55         else {
56             return false;
57         }
58     }
59     
60     function approve(address _spender, uint _amount) public returns (bool success) {
61         allowed[msg.sender][_spender] = _amount;
62         Approval(msg.sender, _spender, _amount);
63         return true;
64     }
65     
66     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
67          return allowed[_owner][_spender];
68      }
69 }