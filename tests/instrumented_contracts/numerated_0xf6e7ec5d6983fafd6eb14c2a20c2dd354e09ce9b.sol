1 pragma solidity ^0.4.18;
2 
3 
4 contract Token {
5     function balanceOf(address _account) public constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) public returns (bool success);
8 }
9 
10 
11 contract ABC {
12     string public constant symbol = "ABC";
13 
14     string public constant name = "Airdrop Beggars Community";
15 
16     uint public constant decimals = 18;
17 
18     uint public constant totalSupply = 10000000 * 10 ** decimals;
19 
20     address public owner;
21 
22     mapping (address => bool) beggars;
23 
24     mapping (address => uint256) balances;
25 
26     mapping (address => mapping (address => uint256)) allowed;
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29 
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32     function AirdropBeggarsCommunity() public {
33         owner = msg.sender;
34         balances[owner] = totalSupply;
35     }
36 
37     function() public payable {
38         uint reward = totalSupply / 10000;
39         require(balances[owner] >= reward && !beggars[msg.sender]);
40         balances[owner] -= reward;
41         balances[msg.sender] += reward;
42         beggars[msg.sender] = true;
43     }
44 
45     function balanceOf(address _owner) public constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
50         return allowed[_owner][_spender];
51     }
52 
53     function transfer(address _to, uint256 _amount) public returns (bool success) {
54         require(balances[msg.sender] >= _amount && _amount > 0);
55         balances[msg.sender] -= _amount;
56         balances[_to] += _amount;
57         Transfer(msg.sender, _to, _amount);
58         return true;
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
62         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0);
63         balances[_from] -= _amount;
64         allowed[_from][msg.sender] -= _amount;
65         balances[_to] += _amount;
66         Transfer(_from, _to, _amount);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _amount) public returns (bool success) {
71         allowed[msg.sender][_spender] = _amount;
72         Approval(msg.sender, _spender, _amount);
73         return true;
74     }
75 
76     function withdraw(address _token) public returns (bool _status) {
77         require(msg.sender == owner);
78         if (_token == address(0)) {
79             owner.transfer(this.balance);
80         }
81         else {
82             Token ERC20 = Token(_token);
83             ERC20.transfer(owner, ERC20.balanceOf(this));
84         }
85         return true;
86     }
87 }