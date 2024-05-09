1 pragma solidity ^0.4.4;
2 
3 contract TPP2018TOKEN  {
4     
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     
7 	function transfer(address _to, uint256 _value)public returns (bool success) {
8         if (balances[msg.sender] >= _value && _value > 0) {
9             balances[msg.sender] -= _value;
10             balances[_to] += _value;
11             Transfer(msg.sender, _to, _value);
12             return true;
13         } else { return false; }
14     }
15 
16     function  transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
17         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
18             balances[_to] += _value;
19             balances[_from] -= _value;
20             allowed[_from][msg.sender] -= _value;
21             Transfer(_from, _to, _value);
22             return true;
23         } else { return false; }
24     }
25 
26     function balanceOf(address _owner) constant public returns (uint256 balance) {
27         return balances[_owner];
28     }
29 
30     mapping (address => uint256) balances;
31     mapping (address => mapping (address => uint256)) allowed;
32     uint256 public totalSupply;
33 
34     function () {
35         
36         throw;
37     }
38 
39     string public name;                  
40     uint8 public decimals;               
41     string public symbol;                
42     string public version = 'H1.0';       
43 
44     function TPP2018TOKEN () public{
45         balances[msg.sender] = 8600000000;               // Give the creator all initial tokens 
46         totalSupply = 8600000000;  
47         name = "TPP TOKEN";      
48         decimals = 2;           
49         symbol = "TPPT"; 
50     }
51 }