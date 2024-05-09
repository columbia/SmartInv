1 pragma solidity ^0.4.19;
2 
3 
4 contract BitcoinQuick {
5 
6     string public constant name = "Bitcoin Quick";
7 
8     string public constant symbol = "BTCQ";
9 
10     uint public constant decimals = 8;
11 
12     uint public constant totalSupply = 8500000 * 10 ** decimals;
13 
14     mapping(address => uint) balances;
15 
16     mapping(address => mapping(address => uint)) allowed;
17 
18     event Transfer(address indexed _from, address indexed _to, uint _value);
19 
20     event Approval(address indexed _owner, address indexed _spender, uint _value);
21 
22     function BitcoinQuick() public {
23         balances[msg.sender] = totalSupply;
24         Transfer(address(this), msg.sender, totalSupply);
25     }
26 
27     function balanceOf(address _owner) public constant returns (uint balance)  {
28         return balances[_owner];
29     }
30 
31     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
32         return allowed[_owner][_spender];
33     }
34 
35     function transfer(address _to, uint _amount) public returns (bool success)  {
36         require(balances[msg.sender] >= _amount && _amount > 0);
37         balances[msg.sender] -= _amount;
38         balances[_to] += _amount;
39         Transfer(msg.sender, _to, _amount);
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
44         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0);
45         balances[_to] += _amount;
46         balances[_from] -= _amount;
47         allowed[_from][msg.sender] -= _amount;
48         Transfer(_from, _to, _amount);
49         return true;
50     }
51 
52     function approve(address _spender, uint _amount) public returns (bool success) {
53         allowed[msg.sender][_spender] = _amount;
54         Approval(msg.sender, _spender, _amount);
55         return true;
56     }
57 }