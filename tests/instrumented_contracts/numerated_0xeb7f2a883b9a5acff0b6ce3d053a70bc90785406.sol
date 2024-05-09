1 pragma solidity ^0.4.16;
2 
3 contract Token{
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns
9     (bool success);
10 
11     function approve(address _spender, uint256 _value) public returns (bool success);
12 
13     function allowance(address _owner, address _spender) public view returns
14     (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256
18     _value);
19 }
20 
21 contract TokenERC20 is Token {
22 
23     string public name;
24     uint8 public decimals;
25     string public symbol;
26 
27     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
28         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
29         balances[msg.sender] = totalSupply;
30 
31         name = _tokenName;
32         decimals = _decimalUnits;
33         symbol = _tokenSymbol;
34     }
35 
36     function transfer(address _to, uint256 _value) public returns (bool success) {
37         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
38         require(_to != 0x0);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         emit Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns
47     (bool success) {
48         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
49         balances[_to] += _value;
50         balances[_from] -= _value;
51         allowed[_from][msg.sender] -= _value;
52         emit Transfer(_from, _to, _value);
53         return true;
54     }
55     function balanceOf(address _owner) public view returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59 
60     function approve(address _spender, uint256 _value) public returns (bool success)
61     {
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }