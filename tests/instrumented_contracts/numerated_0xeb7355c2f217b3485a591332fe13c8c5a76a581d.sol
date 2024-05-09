1 pragma solidity ^0.5.0;
2 
3 contract Token {
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
9 
10     function approve(address _spender, uint256 _value) public returns (bool success);
11 
12     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract JubiToken is Token {
19     string public name;
20     uint8 public decimals;
21     string public symbol;
22 
23     constructor() public {
24         totalSupply = 1000000000*(10**18);
25         balances[msg.sender] = totalSupply;
26 
27         name = "Jubi Token";
28         decimals = 18;
29         symbol = "JT";
30     }
31 
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
34         require(_to != address(0x0));
35         
36         balances[msg.sender] -= _value;
37         balances[_to] += _value;
38         emit Transfer(msg.sender, _to, _value);
39         return true;
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
44         balances[_to] += _value;
45         balances[_from] -= _value;
46         allowed[_from][msg.sender] -= _value;
47         emit Transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function balanceOf(address _owner) public view returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint256 _value) public returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         emit Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping(address => uint256)) allowed;
67 }