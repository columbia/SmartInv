1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 }
44 
45 contract ERC20Token {
46 
47     /// @return total amount of tokens
48     function totalSupply() constant returns (uint256) {}
49 
50     /// @return The balance
51     function balanceOf(address) constant returns (uint256) {}
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     function transfer(address, uint256) returns (bool) {}
55 
56     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
57     function transferFrom(address, address, uint256) returns (bool) {}
58 
59     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
60     function approve(address, uint256) returns (bool) {}
61 
62     function allowance(address, address) constant returns (uint256) {}
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 
69 contract StandardToken is ERC20Token {
70 
71     function transfer(address _to, uint256 _value) returns (bool success) {
72         //Default assumes totalSupply can't be over max (2^256 - 1).
73         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
74         //Replace the if with this one instead.
75         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76         if (balances[msg.sender] >= _value && _value > 0) {
77             balances[msg.sender] -= _value;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             return true;
81         } else { return false; 
82                 revert();}
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86         //same as above. Replace this line with the following if you want to protect against wrapping uints.
87         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
88         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
89             balances[_to] += _value;
90             balances[_from] -= _value;
91             allowed[_from][msg.sender] -= _value;
92             Transfer(_from, _to, _value);
93             return true;
94         } else { return false; }
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
108       return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113     uint256 public totalSupply;
114 }
115 
116 
117 contract VeganCoin is StandardToken {
118 
119     string public name;                   
120     uint8 public decimals;                
121     string public symbol;                 
122 
123     function VeganCoin(){
124 
125         balances[msg.sender] = 50000000000000000000000;               // Give the creator all initial tokens
126         totalSupply = 50000000000000000000000;                        // Update total supply
127         name = "Vegan Coin";                                   // Set the name for display purposes
128         decimals = 18;                            // Amount of decimals for display purposes
129         symbol = "VGN";                               // Set the symbol for display purposes
130 
131     }
132 
133     function fundContract() payable returns(bool success) {
134         return true;
135     }
136 }