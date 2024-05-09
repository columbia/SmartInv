1 pragma solidity ^0.4.16;
2 
3 contract ERC20token{
4     uint256 public totalSupply;
5     string public name;
6     uint8 public decimals;
7     string public symbol;
8     
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11     
12     mapping (address => uint256) balances;
13     mapping (address => mapping (address => uint256)) allowed;
14     
15     function ERC20token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
16         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
17         balances[msg.sender] = totalSupply;
18         name = _tokenName;
19         decimals = _decimalUnits;
20         symbol = _tokenSymbol;
21     }
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
25         require(_to != 0x0);
26         balances[msg.sender] -= _value;
27         balances[_to] += _value;
28         Transfer(msg.sender, _to, _value);
29         return true;
30     }
31     
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
33         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         allowed[_from][msg.sender] -= _value;
37         Transfer(_from, _to, _value);
38         return true;
39     }
40     
41     function balanceOf(address _owner) public constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44     
45     function approve(address _spender, uint256 _value) public returns (bool success)
46     {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51     
52     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
53         return allowed[_owner][_spender];
54     }
55 }