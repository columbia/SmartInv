1 pragma solidity ^0.4.16;
2 
3 contract ERC20token{
4     uint256 public totalSupply;
5     string public name;
6     uint8 public decimals;
7     string public symbol;
8     // address public admin;
9     
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12     
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15     
16     function ERC20token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
17         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
18         balances[msg.sender] = totalSupply;
19         name = _tokenName;
20         decimals = _decimalUnits;
21         symbol = _tokenSymbol;
22     }
23 
24     function transfer(address _to, uint256 _value) public returns (bool success) {
25         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
26         require(_to != 0x0);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         Transfer(msg.sender, _to, _value);
30         return true;
31     }
32     
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
35         balances[_to] += _value;
36         balances[_from] -= _value;
37         allowed[_from][msg.sender] -= _value;
38         Transfer(_from, _to, _value);
39         return true;
40     }
41     
42     function balanceOf(address _owner) public constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45     
46     function approve(address _spender, uint256 _value) public returns (bool success)
47     {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52     
53     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
54         return allowed[_owner][_spender];
55     }
56 }