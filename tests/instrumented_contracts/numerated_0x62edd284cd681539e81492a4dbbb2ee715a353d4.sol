1 /*@describle Equity tokens for SumSwap super nodes*/
2 
3 /*@title Sumswap Crown Token*/
4 
5 /*@author sumswap <service@sumswap.org>*/
6 
7 /*@website https://www.sumswap.org*/
8 
9 pragma solidity ^0.4.9;
10 
11 contract SafeMath {
12     function safeSub(uint a, uint b) pure internal returns (uint) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function safeAdd(uint a, uint b) pure internal returns (uint) {
18         uint c = a + b;
19         assert(c >= a && c >= b);
20         return c;
21     }
22 }
23 
24 contract ERC20 {
25     uint public totalSupply;
26     function balanceOf(address who) public constant returns (uint);
27     function allowance(address owner, address spender) public constant returns (uint);
28     function transfer(address toAddress, uint value) public returns (bool ok);
29     function transferFrom(address fromAddress, address toAddress, uint value) public returns (bool ok);
30     function approve(address spender, uint value) public returns (bool ok);
31     event Transfer(address indexed fromAddress, address indexed toAddress, uint value);
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Burn(address indexed from, uint256 value);
34 }
35 
36 
37 contract StandardToken is ERC20, SafeMath {
38     mapping (address => uint) balances;
39     mapping (address => mapping (address => uint)) allowed;
40 
41     function transfer(address _to, uint _value) public returns (bool success) {
42         balances[msg.sender] = safeSub(balances[msg.sender], _value);
43         balances[_to] = safeAdd(balances[_to], _value);
44         Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
49         var _allowance = allowed[_from][msg.sender];
50 
51         balances[_to] = safeAdd(balances[_to], _value);
52         balances[_from] = safeSub(balances[_from], _value);
53         allowed[_from][msg.sender] = safeSub(_allowance, _value);
54         Transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function balanceOf(address _owner) public constant returns (uint balance) {
59         return balances[_owner];
60     }
61 
62     function approve(address _spender, uint _value) public returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
69         return allowed[_owner][_spender];
70     }
71 
72     function burn(uint256 _value) public returns (bool success)
73     {
74         require(balances[msg.sender] >= _value);
75         balances[msg.sender] -= _value;
76         totalSupply -= _value;
77         Burn(msg.sender, _value);
78         return true;
79     }
80 }
81 
82 contract SumSwapCrown is StandardToken 
83 {
84     string public name = "SumSwapCrown";
85     string public symbol = "SCROWN";
86     uint public decimals = 18;
87     uint public totalSupply = 400*10**18;
88     function SumSwapCrown() public 
89     {
90         balances[msg.sender] = totalSupply;
91     }
92 }