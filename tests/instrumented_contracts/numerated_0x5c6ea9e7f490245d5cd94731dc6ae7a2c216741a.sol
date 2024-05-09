1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10 	
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract NumbalwarToken is ERC20Interface {
16     string public name = "Numbalwar Building Token";
17     uint8 public decimals = 18;
18     string public symbol = "NBT";
19 	
20     function NumbalwarToken (
21         uint256 _initialAmount
22         ) public {
23         balances[msg.sender] = _initialAmount;
24         totalSupply = _initialAmount;
25     }
26     
27     function transfer(address _to, uint256 _value) public returns (bool success) {
28         if (balances[msg.sender] >= _value && _value > 0) {
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31             Transfer(msg.sender, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
38             balances[_to] += _value;
39             balances[_from] -= _value;
40             allowed[_from][msg.sender] -= _value;
41             Transfer(_from, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function balanceOf(address _owner) public constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50     function approve(address _spender, uint256 _value) public returns (bool success) {
51         allowed[msg.sender][_spender] = _value;
52         Approval(msg.sender, _spender, _value);
53         return true;
54     }
55 
56     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
57       return allowed[_owner][_spender];
58     }
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62 }