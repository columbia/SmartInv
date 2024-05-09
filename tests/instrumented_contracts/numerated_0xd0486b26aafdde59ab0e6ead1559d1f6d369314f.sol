1 pragma solidity ^0.4.7;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) pure internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) pure internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) pure internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 }
21 
22 contract ERC20 {
23   uint public totalSupply;
24   function balanceOf(address who) public constant returns (uint);
25   function allowance(address owner, address spender) public constant returns (uint);
26 
27   function transfer(address to, uint value) public returns (bool ok);
28   function transferFrom(address from, address to, uint value) public returns (bool ok);
29   function approve(address spender, uint value) public returns (bool ok);
30   event Transfer(address indexed from, address indexed to, uint value);
31   event Approval(address indexed owner, address indexed spender, uint value);
32 }
33 
34 contract StandardToken is ERC20, SafeMath {
35   mapping (address => uint) balances;
36   mapping (address => mapping (address => uint)) allowed;
37 
38   function transfer(address _to, uint _value) public returns (bool success) {
39     // This test is implied by safeSub()
40     // if (balances[msg.sender] < _value) { throw; }
41     balances[msg.sender] = safeSub(balances[msg.sender], _value);
42     balances[_to] = safeAdd(balances[_to], _value);
43     emit Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 
47   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
48     uint _allowance = allowed[_from][msg.sender];
49 
50     // These tests are implied by safeSub()
51     // if (balances[_from] < _value) { throw; }
52     // if (_allowance < _value) { throw; }
53     balances[_to] = safeAdd(balances[_to], _value);
54     balances[_from] = safeSub(balances[_from], _value);
55     allowed[_from][msg.sender] = safeSub(_allowance, _value);
56     emit Transfer(_from, _to, _value);
57     return true;
58   }
59 
60   function balanceOf(address _owner) public constant returns (uint balance) {
61     return balances[_owner];
62   }
63 
64   function approve(address _spender, uint _value) public returns (bool success) {
65     allowed[msg.sender][_spender] = _value;
66     emit Approval(msg.sender, _spender, _value);
67     return true;
68   }
69 
70   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
71     return allowed[_owner][_spender];
72   }
73 }
74 
75 contract MDOT is StandardToken {
76     /*
77     NOTE:
78     The following variables are OPTIONAL vanities. One does not have to include them.
79     They allow one to customise the token contract & in no way influences the core functionality.
80     Some wallets/interfaces might not even bother to look at this information.
81     */
82     string public name = "Maolulu Polkadot";   // Fancy name: eg: Maolulu Polkadot
83     string public symbol = "MDOT"; // An identifier: eg MDOT
84     uint public decimals = 8;      // Unit precision
85 
86     constructor() public {
87         totalSupply = 5000000000000;       // Set the total supply (in base units)
88         balances[0xbfC729007CE9CBBE54132Fb9BFa097D80AAC791C] = 5000000000000;    // Initially assign the entire supply to the specified account
89     }
90 }