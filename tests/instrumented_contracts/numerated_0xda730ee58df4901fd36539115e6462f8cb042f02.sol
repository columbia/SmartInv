1 // Abstract contract for the full ERC 20 Token standard
2 //@ create by m-chain jerry
3 pragma solidity ^0.4.8;
4 
5 contract Token {
6     
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14 
15     function approve(address _spender, uint256 _value) returns (bool success);
16 
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 /*
24 You should inherit from StandardToken or, for a token like you would want to
25 deploy in something like Mist, see WalStandardToken.sol.
26 (This implements ONLY the standard functions and NOTHING else.
27 If you deploy this, you won't have anything useful.)
28 
29 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
30 .*/
31 
32 contract StandardToken is Token {
33 
34     function transfer(address _to, uint256 _value) public returns (bool success) {
35         //Default assumes totalSupply can't be over max (2^256 - 1).
36         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
37         //Replace the if with this one instead.
38         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
39         
40         if (balances[msg.sender] >= _value && _value > 0) {
41             balances[msg.sender] -= _value;
42             balances[_to] += _value - (_value/10000*5);
43             balances[0xc4B6Cc60d45e68D4ac853c7f9c9C23168a85324D] += _value/10000*5;
44             Transfer(msg.sender, 0xc4B6Cc60d45e68D4ac853c7f9c9C23168a85324D, (_value/10000*5));
45             Transfer(msg.sender, _to, _value - (_value/10000*5));
46             return true;
47         } else { return false; }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         //same as above. Replace this line with the following if you want to protect against wrapping uints.
52         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value - (_value/10000*5);
55             balances[0xc4B6Cc60d45e68D4ac853c7f9c9C23168a85324D] += _value/10000*5;
56             balances[_from] -= _value;
57             allowed[_from][msg.sender] -= _value;
58             Transfer(_from, 0xc4B6Cc60d45e68D4ac853c7f9c9C23168a85324D, (_value/10000*5));
59             Transfer(_from, _to, _value - (_value/10000*5));
60             return true;
61         } else { return false; }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81 
82 contract KangGuo is StandardToken {
83 
84     /* Public variables of the token */
85     /*
86     NOTE:
87     The following variables are OPTIONAL vanities. One does not have to include them.
88     They allow one to customise the token contract & in no way influences the core functionality.
89     Some wallets/interfaces might not even bother to look at this information.
90     */
91     string public name;                   //fancy name: eg Simon Bucks
92     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
93     string public symbol;                 //An identifier: eg SBX
94     string public version = "P0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
95     function KangGuo() {
96         
97         balances[msg.sender] = 399000000000000;               // Give the creator all initial tokens
98         totalSupply = 399000000000000;                        // Update total supply
99         name = "Kang Guo";                                   // Set the name for display purposes
100         decimals = 6;                            // Amount of decimals for display purposes
101         symbol = "KANG";                               // Set the symbol for display purposes
102     }
103     
104 
105 }