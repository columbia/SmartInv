1 pragma solidity ^0.4.11;
2 contract ERC20 {
3   uint public totalSupply;
4   function balanceOf(address who) constant returns (uint);
5   function transfer(address to, uint value);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transferFrom(address from, address to, uint value);
9   function approve(address spender, uint value);
10 
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract StandardToken is ERC20 {
16 
17   string public constant name = "testcbs";
18   string public constant symbol = "KKL";
19   uint8 public constant decimals = 18; 
20 
21   mapping (address => mapping (address => uint)) allowed;
22   mapping (address => uint) balances;
23 
24   function transferFrom(address _from, address _to, uint _value) {
25     var _allowance = allowed[_from][msg.sender];
26 
27     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
28     // if (_value > _allowance) throw;
29 
30     balances[_to] +=_value;
31     balances[_from] -= _value;
32     allowed[_from][msg.sender] -= _value;
33     Transfer(_from, _to, _value);
34   }
35 
36   function approve(address _spender, uint _value) {
37     allowed[msg.sender][_spender] = _value;
38     Approval(msg.sender, _spender, _value);
39   }
40 
41   function allowance(address _owner, address _spender) constant returns (uint remaining) {
42     return allowed[_owner][_spender];
43   }
44 
45   function transfer(address _to, uint _value) {
46     balances[msg.sender] -= _value;
47     balances[_to] += _value;
48     Transfer(msg.sender, _to, _value);
49   }
50 
51   function balanceOf(address _owner) constant returns (uint balance) {
52     return balances[_owner];
53   }
54   
55   function StandardToken(){
56   balances[msg.sender] = 1000000;
57 }
58 
59 function mint() payable external {
60   if (msg.value == 0) throw;
61 
62   var numTokens = msg.value * 1000;
63   totalSupply += numTokens;
64 
65   balances[msg.sender] += numTokens;
66 
67   Transfer(0, msg.sender, numTokens);
68 }
69 }