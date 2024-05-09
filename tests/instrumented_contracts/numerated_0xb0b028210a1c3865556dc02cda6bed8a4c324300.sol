1 pragma solidity ^0.4.16;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns   
8     (bool success);
9 
10     function approve(address _spender, uint256 _value) public returns (bool success);
11 
12     function allowance(address _owner, address _spender) public constant returns 
13     (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 
17     _value);
18 }
19 
20 contract LDXCToken is Token {
21 
22     string public constant name = "Little Dragon Xia Coin";                   
23     uint8 public constant decimals = 2; 
24     string public constant symbol = "LDXC";
25 
26     function LDXCToken(uint256 _initialAmount) public {
27         totalSupply = _initialAmount * 10 ** uint256(decimals); 
28         balances[msg.sender] = totalSupply;
29     }
30 
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
33         require(_to != 0x0);
34         balances[msg.sender] -= _value;
35         balances[_to] += _value;
36         Transfer(msg.sender, _to, _value);
37         return true;
38     }
39 
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns 
42     (bool success) {
43         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
44         balances[_to] += _value;
45         balances[_from] -= _value; 
46         allowed[_from][msg.sender] -= _value;
47         Transfer(_from, _to, _value);
48         return true;
49     }
50     function balanceOf(address _owner) public constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54     function approve(address _spender, uint256 _value) public returns (bool success)   
55     { 
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66 }