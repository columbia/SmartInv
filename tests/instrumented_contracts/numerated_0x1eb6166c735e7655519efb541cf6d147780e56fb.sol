1 pragma solidity ^0.4.25;
2 
3 contract KKLLCOIN {
4 
5     uint256 public totalSupply;
6 
7     mapping (address => uint256) public balances;
8     mapping (address => mapping (address => uint256)) public allowed;
9 
10     string public name;
11     uint8 public decimals;
12     string public symbol;
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17     constructor(
18         uint256 _initialAmount,
19         string _tokenName,
20         uint8 _decimalUnits,
21         string _tokenSymbol
22     ) public {
23         balances[msg.sender] = _initialAmount;
24         totalSupply = _initialAmount;
25         name = _tokenName;
26         decimals = _decimalUnits;
27         symbol = _tokenSymbol;
28     }
29 
30     function transfer(address _to, uint256 _value) public returns (bool success) {
31         require(balances[msg.sender] >= _value);
32         balances[msg.sender] -= _value;
33         balances[_to] += _value;
34         emit Transfer(msg.sender, _to, _value);
35         return true;
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
39         uint256 allowance = allowed[_from][msg.sender];
40         require(balances[_from] >= _value && allowance >= _value);
41         balances[_to] += _value;
42         balances[_from] -= _value;
43         allowed[_from][msg.sender] -= _value;
44         emit Transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function balanceOf(address _owner) public view returns (uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function approve(address _spender, uint256 _value) public returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         emit Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
59         return allowed[_owner][_spender];
60     }
61 }