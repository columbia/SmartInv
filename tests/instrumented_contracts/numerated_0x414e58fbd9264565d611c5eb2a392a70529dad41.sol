1 pragma solidity ^0.4.0;
2 
3 contract Token {
4     uint256 public totalSupply;
5     
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
9     
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     
12     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
13     
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract CoinEGGToken is Token {
19     string public name;
20     uint8 public decimals;
21     string public symbol;
22     
23     constructor() public {
24         totalSupply = 10000000000*(10**18);
25         balances[msg.sender] = totalSupply;
26         
27         name = "CoinEGGToken";
28         decimals = 18;
29         symbol = "ET";
30     }
31     
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
34         require(_to != 0x0);
35         balances[msg.sender] -= _value;
36         balances[_to] += _value;
37         emit Transfer(msg.sender, _to, _value);
38         return true;
39     }
40     
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
43         balances[_to] += _value;
44         balances[_from] -= _value;
45         allowed[_from][msg.sender] -= _value;
46         emit Transfer(_from, _to, _value);
47         return true;
48     }
49     
50     function balanceOf(address _owner) public constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53     
54     function approve(address _spender, uint256 _value) public returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59     
60     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
61         return allowed[_owner][_spender];
62     }
63     
64     mapping (address => uint256) balances;
65     mapping (address => mapping(address => uint256)) allowed;
66 }