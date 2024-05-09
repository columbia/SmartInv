1 pragma solidity ^0.4.21;
2 contract EIP20Interface {
3 uint256 public totalSupply;
4 function balanceOf(address _owner) public view returns (uint256 balance);
5 function transfer(address _to, uint256 _value) public returns (bool success);
6 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7 function approve(address _spender, uint256 _value) public returns (bool success);
8 function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9 event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract TheZetcToken is EIP20Interface {
13 uint256 constant private MAX_UINT256 = 2**256 - 1;
14 mapping (address => uint256) public balances;
15 mapping (address => mapping (address => uint256)) public allowed;
16 string public name;
17 uint8 public decimals;
18 string public symbol;
19 function TheZetcToken(
20 uint256 _initialAmount,
21 string _tokenName,
22 uint8 _decimalUnits,
23 string _tokenSymbol
24 ) public {
25 balances[msg.sender] = _initialAmount;
26 totalSupply = _initialAmount;
27 name = _tokenName;
28 decimals = _decimalUnits;
29 symbol = _tokenSymbol;
30 }
31 function transfer(address _to, uint256 _value) public returns (bool success) {
32 require(balances[msg.sender] >= _value);
33 balances[msg.sender] -= _value;
34 balances[_to] += _value;
35 emit Transfer(msg.sender, _to, _value);
36 return true;
37 }
38 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
39 uint256 allowance = allowed[_from][msg.sender];
40 require(balances[_from] >= _value && allowance >= _value);
41 balances[_to] += _value;
42 balances[_from] -= _value;
43 if (allowance < MAX_UINT256) {
44 allowed[_from][msg.sender] -= _value;
45 }
46 emit Transfer(_from, _to, _value);
47 return true;
48 }
49 function balanceOf(address _owner) public view returns (uint256 balance) {
50 return balances[_owner];
51 }
52 function approve(address _spender, uint256 _value) public returns (bool success) {
53 allowed[msg.sender][_spender] = _value;
54 emit Approval(msg.sender, _spender, _value);
55 return true;
56 }
57 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
58 return allowed[_owner][_spender];
59 }
60 }