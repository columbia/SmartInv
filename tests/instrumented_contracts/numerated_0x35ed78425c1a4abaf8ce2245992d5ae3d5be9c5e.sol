1 pragma solidity ^0.4.21;
2 
3 contract SafeMath {
4     function safeSub(uint a, uint b) pure internal returns (uint) {
5         assert(b <= a);
6         return a - b;
7     }
8 
9     function safeAdd(uint a, uint b) pure internal returns (uint) {
10         uint c = a + b;
11         assert(c >= a && c >= b);
12         return c;
13     }
14 }
15 
16 
17 contract ERC20 {
18     uint public totalSupply;
19     function balanceOf(address who) public constant returns (uint);
20     function allowance(address owner, address spender) public constant returns (uint);
21     function transfer(address toAddress, uint value) public returns (bool ok);
22     function transferFrom(address fromAddress, address toAddress, uint value) public returns (bool ok);
23     function approve(address spender, uint value) public returns (bool ok);
24     event Transfer(address indexed fromAddress, address indexed toAddress, uint value);
25     event Approval(address indexed owner, address indexed spender, uint value);
26 }
27 
28 
29 contract StandardToken is ERC20, SafeMath {
30     mapping (address => uint) balances;
31     mapping (address => mapping (address => uint)) allowed;
32 
33     function transfer(address _to, uint _value) public returns (bool success) {
34         balances[msg.sender] = safeSub(balances[msg.sender], _value);
35         balances[_to] = safeAdd(balances[_to], _value);
36         Transfer(msg.sender, _to, _value);
37         return true;
38     }
39 
40     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
41         var _allowance = allowed[_from][msg.sender];
42 
43         balances[_to] = safeAdd(balances[_to], _value);
44         balances[_from] = safeSub(balances[_from], _value);
45         allowed[_from][msg.sender] = safeSub(_allowance, _value);
46         Transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function balanceOf(address _owner) public constant returns (uint balance) {
51         return balances[_owner];
52     }
53 
54     function approve(address _spender, uint _value) public returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
61         return allowed[_owner][_spender];
62     }
63 
64 }
65 
66 
67 contract HBOToken is StandardToken {
68     string public name = "hope bank";
69     string public symbol = "HBO";
70     uint public decimals = 18;
71     uint public totalSupply = 2100 * 1000 * 1000 ether;
72 
73     function HBOToken() public {
74         balances[msg.sender] = totalSupply;
75     }
76 }