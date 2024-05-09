1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20 {
5 
6     address owner;
7 
8     string public name;
9 
10     string public symbol;
11 
12     uint public decimals;
13 
14     uint public totalSupply;
15 
16     mapping(address => uint) balances;
17 
18     mapping(address => mapping(address => uint)) allowed;
19 
20     event Transfer(address indexed _from, address indexed _to, uint _value);
21 
22     event Approval(address indexed _owner, address indexed _spender, uint _value);
23 
24     function ERC20() public {
25         owner = msg.sender;
26     }
27 
28     function balanceOf(address _owner) public constant returns (uint balance)  {
29         return balances[_owner];
30     }
31 
32     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
33         return allowed[_owner][_spender];
34     }
35 
36     function setup(string _name, string _symbol, uint _totalSupply, uint _decimals) public {
37         require(msg.sender == owner);
38         name = _name;
39         symbol = _symbol;
40         decimals = _decimals;
41         totalSupply = _totalSupply * 10 ** _decimals;
42         balances[msg.sender] = totalSupply;
43         Transfer(address(this), msg.sender, totalSupply);
44     }
45 
46     function transfer(address _to, uint _amount) public returns (bool success)  {
47         require(balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]);
48         balances[msg.sender] -= _amount;
49         balances[_to] += _amount;
50         Transfer(msg.sender, _to, _amount);
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
55         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]);
56         balances[_to] += _amount;
57         balances[_from] -= _amount;
58         allowed[_from][msg.sender] -= _amount;
59         Transfer(_from, _to, _amount);
60         return true;
61     }
62 
63     function approve(address _spender, uint _amount) public returns (bool success) {
64         allowed[msg.sender][_spender] = _amount;
65         Approval(msg.sender, _spender, _amount);
66         return true;
67     }
68 }