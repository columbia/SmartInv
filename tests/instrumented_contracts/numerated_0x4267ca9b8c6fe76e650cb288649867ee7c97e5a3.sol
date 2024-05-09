1 pragma solidity ^0.4.25;
2 
3 
4 contract EVERCOIN {
5 
6     uint256 public totalSupply;
7 
8     mapping (address => uint256) public balances;
9     mapping (address => mapping (address => uint256)) public allowed;
10 
11     string public name;
12     uint8 public decimals;
13     string public symbol;
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17      // 100000000000000000,"ever",8,"EVERCOIN"
18     constructor(
19         uint256 _initialAmount,
20         string _tokenName,
21         uint8 _decimalUnits,
22         string _tokenSymbol
23     ) public {
24         balances[msg.sender] = _initialAmount;
25         totalSupply = _initialAmount;
26         name = _tokenName;
27         decimals = _decimalUnits;
28         symbol = _tokenSymbol;
29     }
30 
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32         require(balances[msg.sender] >= _value);
33         balances[msg.sender] -= _value;
34         balances[_to] += _value;
35         emit Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
40         uint256 allowance = allowed[_from][msg.sender];
41         require(balances[_from] >= _value && allowance >= _value);
42         balances[_to] += _value;
43         balances[_from] -= _value;
44         allowed[_from][msg.sender] -= _value;
45         emit Transfer(_from, _to, _value);
46         return true;
47     }
48 
49     function balanceOf(address _owner) public view returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) public returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         emit Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
60         return allowed[_owner][_spender];
61     }
62 }