1 pragma solidity ^0.4.24;
2 /*
3  * ERC20 interface
4  * see https://github.com/ethereum/EIPs/issues/20
5  */
6 contract ERC20 {
7   uint public totalSupply;
8   function balanceOf(address who) constant returns (uint);
9   function transfer(address to, uint value);
10   function allowance(address owner, address spender) constant returns (uint);
11 
12   function transferFrom(address from, address to, uint value);
13   function approve(address spender, uint value);
14 
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 contract SXDT is ERC20 {
20 
21   string public constant name = "Spectre.ai D-Token";
22   string public constant symbol = "SXDT";
23   uint8 public constant decimals = 18; 
24 
25   mapping (address => mapping (address => uint)) allowed;
26   mapping (address => uint) balances;
27 
28   function transferFrom(address _from, address _to, uint _value) {
29     var _allowance = allowed[_from][msg.sender];
30 
31     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
32     // if (_value > _allowance) throw;
33 
34     balances[_to] +=_value;
35     balances[_from] -= _value;
36     allowed[_from][msg.sender] -= _value;
37     Transfer(_from, _to, _value);
38   }
39 
40   function approve(address _spender, uint _value) {
41     allowed[msg.sender][_spender] = _value;
42     Approval(msg.sender, _spender, _value);
43   }
44 
45   function allowance(address _owner, address _spender) constant returns (uint remaining) {
46     return allowed[_owner][_spender];
47   }
48 
49   function transfer(address _to, uint _value) {
50     balances[msg.sender] -= _value;
51     balances[_to] += _value;
52     Transfer(msg.sender, _to, _value);
53   }
54 
55   function balanceOf(address _owner) constant returns (uint balance) {
56     return balances[_owner];
57   }
58   
59   function StandardToken(){
60   balances[msg.sender] = 100000000000000000000000000;
61 }
62 }