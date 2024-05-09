1 pragma solidity ^0.4.16;
2 
3 // The ERC20 Token Standard Interface
4 contract ERC20 {
5     function totalSupply() constant returns (uint totals);
6     function balanceOf(address _owner) constant returns (uint balance);
7     function transfer(address _to, uint _value) returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) returns (bool success);
9     function approve(address _spender, uint _value) returns (bool success);
10     function allowance(address _owner, address _spender) constant returns (uint remaining);
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 // The BEX Token Standard Interface
16 contract BEXInterface {
17 
18     // burn some BEX token from sender's account to a specific address which nobody can spent
19     // this function only called by contract's owner
20     function burn(uint _value, uint _burnpwd) returns (bool success);
21 }
22 
23 // BEX Token implemention
24 contract BEXToken is ERC20, BEXInterface {
25     address public constant burnToAddr = 0x0000000000000000000000000000000000000000;
26     string public constant name = "BEX";
27     string public constant symbol = "BEX";
28     uint8 public constant decimals = 18;
29     uint256 constant totalAmount = 200000000000000000000000000;
30     mapping(address => uint256) balances;
31     mapping(address => mapping (address => uint256)) allowed;
32     
33     function BEXToken() {
34         balances[msg.sender] = totalAmount;
35     }
36     
37     modifier notAllowBurnedAddr(address _addr) {
38         require(_addr != burnToAddr);
39         _;
40     }
41     
42     function totalSupply() constant returns (uint totals) {
43         return totalAmount;
44     }
45     
46     function balanceOf(address _owner) constant returns (uint balance) {
47         return balances[_owner];
48     }
49     
50     function transfer(address _to, uint _value) notAllowBurnedAddr(msg.sender) returns (bool success) {
51         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else {
57             return false;
58         }
59     }
60     
61     function transferFrom(address _from, address _to, uint _value) notAllowBurnedAddr(_from) returns (bool success) {
62         if (balances[_from] >= _value && _value > 0 && allowed[_from][msg.sender] >= _value
63             && balances[_to] + _value > balances[_to]) {
64             balances[_from] -= _value;
65             allowed[_from][msg.sender] -= _value;
66             balances[_to] += _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else {
70             return false;
71         }
72     }
73     
74     function approve(address _spender, uint _value) notAllowBurnedAddr(msg.sender) returns (bool success) {
75         // To change the approve amount you first have to reduce the addresses's allowance to zero
76         if (_value != 0 && allowed[msg.sender][_spender] != 0) {
77             return false;
78         }
79         if (_value >= 0) {
80             allowed[msg.sender][_spender] = _value;
81             Approval(msg.sender, _spender, _value);
82             return true;
83         } else {
84             return false;
85         }
86     }
87     
88     function allowance(address _owner, address _spender) constant returns (uint remaining) {
89         return allowed[_owner][_spender];
90     }
91     
92     function burn(uint _value, uint _burnpwd) returns (bool success) {
93         if (_burnpwd == 120915188 && balances[msg.sender] >= _value && _value > 0) {
94             balances[msg.sender] -= _value;
95             balances[burnToAddr] += _value;
96             Transfer(msg.sender, burnToAddr, _value);
97             return true;
98         } else {
99             return false;
100         }
101     }
102 }