1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5     function Ownable() {
6         owner = msg.sender;
7     }
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner {
13         if (newOwner != address(0)) owner = newOwner;
14     }
15 }
16 
17 contract SafeMath {
18     function safeSub(uint a, uint b) internal returns (uint) {
19         sAssert(b <= a);
20         return a - b;
21     }
22     function safeAdd(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         sAssert(c>=a && c>=b);
25         return c;
26     }
27     function sAssert(bool assertion) internal {
28         if (!assertion) {
29             revert();
30         }
31     }
32 }
33 
34 contract ERC20 {
35     uint public totalSupply;
36     function balanceOf(address who) constant returns (uint);
37     function allowance(address owner, address spender) constant returns (uint);
38     function transfer(address to, uint value) returns (bool ok);
39     function transferFrom(address from, address to, uint value) returns (bool ok);
40     function approve(address spender, uint value) returns (bool ok);
41     event Approval(address indexed owner, address indexed spender, uint value);
42     event Transfer(address indexed from, address indexed to, uint value);
43 }
44 
45 contract StandardToken is ERC20, SafeMath {
46     mapping(address => uint) balances;
47     mapping (address => mapping (address => uint)) allowed;
48     function balanceOf(address _owner) constant returns (uint balance) {
49         return balances[_owner];
50     }
51     function approve(address _spender, uint _value) returns (bool success) {
52         // require((_value == 0) || (allowed[msg.sender][_spender] == 0));
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57     function transfer(address _to, uint _value) returns (bool success) {
58         balances[msg.sender] = safeSub(balances[msg.sender], _value);
59         balances[_to] = safeAdd(balances[_to], _value);
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
64         var _allowance = allowed[_from][msg.sender];
65 
66         balances[_to] = safeAdd(balances[_to], _value);
67         balances[_from] = safeSub(balances[_from], _value);
68         allowed[_from][msg.sender] = safeSub(_allowance, _value);
69         Transfer(_from, _to, _value);
70         return true;
71     }
72     function allowance(address _owner, address _spender) constant returns (uint remaining) {
73         return allowed[_owner][_spender];
74     }
75 }
76 
77 contract TonCoin is Ownable, StandardToken {
78     string public name = "TON Coin";
79     string public symbol = "TON";
80     uint public decimals = 18;
81     uint public totalSupply = 3 * (10**9) * (10**18);
82     function TonCoin() {
83         balances[msg.sender] = totalSupply;
84     }
85     function () {// Don't accept ethers - no payable modifier
86     }
87     function transferOwnership(address _newOwner) onlyOwner {
88         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
89         balances[owner] = 0;
90         Ownable.transferOwnership(_newOwner);
91     }
92     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success)
93     {
94         return ERC20(tokenAddress).transfer(owner, amount);
95     }
96 }