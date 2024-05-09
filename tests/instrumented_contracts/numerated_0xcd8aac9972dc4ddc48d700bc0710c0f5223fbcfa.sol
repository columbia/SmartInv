1 pragma solidity ^0.4.13;
2 
3 contract ERC20Interface {
4   function totalSupply() constant returns (uint256 supply);
5   function balanceOf(address _owner) constant returns (uint256 balance);
6   function transfer(address _to, uint256 _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8   function approve(address _spender, uint256 _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10   event Transfer(address indexed _from, address indexed _to, uint256 _value);
11   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract VjuCoin is ERC20Interface {
15   string public constant symbol = "VJU";
16   string public constant name = "VjuCoin";
17   uint8 public constant decimals = 0;
18   uint256 _totalSupply = 100000000;
19   address public owner;
20   mapping(address => uint256) balances;
21   mapping(address => mapping (address => uint256)) allowed;
22   modifier onlyOwner() {
23     if (msg.sender != owner) {revert();}
24     _;
25   }
26   
27   function VjuCoin() {
28     owner = msg.sender;
29     balances[owner] = _totalSupply;
30   }
31    
32   function totalSupply() constant returns (uint256 supply) {
33     supply = _totalSupply;
34   }
35    
36   function balanceOf(address _owner) constant returns (uint256 balance) {
37     return balances[_owner];
38   }
39    
40   function transfer(address _to, uint256 _amount) returns (bool success) {
41     if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
42       balances[msg.sender] -= _amount;
43       balances[_to] += _amount;
44       Transfer(msg.sender, _to, _amount);
45       return true;
46     } else {return false;}
47   }
48    
49   function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {
50     if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
51       balances[_from] -= _amount;
52        allowed[_from][msg.sender] -= _amount;
53        balances[_to] += _amount;
54        Transfer(_from, _to, _amount);
55        return true;
56     } else {return false;}
57   }
58   
59   function approve(address _spender, uint256 _amount) returns (bool success) {
60     allowed[msg.sender][_spender] = _amount;
61     Approval(msg.sender, _spender, _amount);
62     return true;
63   }
64   
65   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
66     return allowed[_owner][_spender];
67   }
68 
69   function () {
70     revert();
71   }
72    
73 }