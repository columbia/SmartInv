1 /**
2  *Submitted for verification at Etherscan.io on 2018-05-14
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 contract SafeMath {
8     function safeSub(uint a, uint b) pure internal returns (uint) {
9         assert(b <= a);
10         return a - b;
11     }
12 
13     function safeAdd(uint a, uint b) pure internal returns (uint) {
14         uint c = a + b;
15         assert(c >= a && c >= b);
16         return c;
17     }
18 }
19 
20 
21 contract ERC20 {
22     uint public totalSupply;
23     function balanceOf(address who) public constant returns (uint);
24     function allowance(address owner, address spender) public constant returns (uint);
25     function transfer(address toAddress, uint value) public returns (bool ok);
26     function transferFrom(address fromAddress, address toAddress, uint value) public returns (bool ok);
27     function approve(address spender, uint value) public returns (bool ok);
28     event Transfer(address indexed fromAddress, address indexed toAddress, uint value);
29     event Approval(address indexed owner, address indexed spender, uint value);
30 }
31 
32 
33 contract StandardToken is ERC20, SafeMath {
34     mapping (address => uint) balances;
35     mapping (address => mapping (address => uint)) allowed;
36 
37     function transfer(address _to, uint _value) public returns (bool success) {
38         balances[msg.sender] = safeSub(balances[msg.sender], _value);
39         balances[_to] = safeAdd(balances[_to], _value);
40         Transfer(msg.sender, _to, _value);
41         return true;
42     }
43 
44     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
45         var _allowance = allowed[_from][msg.sender];
46 
47         balances[_to] = safeAdd(balances[_to], _value);
48         balances[_from] = safeSub(balances[_from], _value);
49         allowed[_from][msg.sender] = safeSub(_allowance, _value);
50         Transfer(_from, _to, _value);
51         return true;
52     }
53 
54     function balanceOf(address _owner) public constant returns (uint balance) {
55         return balances[_owner];
56     }
57 
58     function approve(address _spender, uint _value) public returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
65         return allowed[_owner][_spender];
66     }
67 
68 }
69 
70 
71 contract YelleToken is StandardToken {
72     string public name = "YelleToken";
73     string public symbol = "YLL";
74     uint public decimals = 18;
75     uint public totalSupply = 500 * 1000 * 1000 ether;
76 
77     function YelleToken() public {
78         balances[msg.sender] = totalSupply;
79     }
80 }