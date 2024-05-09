1 // Abstract contract for the full ERC 20 Token standard
2 //@ create by JTU David.Wang
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
37         
38         if (balances[msg.sender] >= _value && _value > 0) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value  && _value > 0) {
48             balances[_to] += _value;
49             balances[_from] -= _value;
50             allowed[_from][msg.sender] -= _value;
51             Transfer(_from, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60     function approve(address _spender, uint256 _value) returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67       return allowed[_owner][_spender];
68     }
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }
73 
74 contract JTU is StandardToken {
75 
76     /* Public variables of the token */
77     /*
78     NOTE:
79     The following variables are OPTIONAL vanities. One does not have to include them.
80     They allow one to customise the token contract & in no way influences the core functionality.
81     Some wallets/interfaces might not even bother to look at this information.
82     */
83     string public name;                   //fancy name: eg Simon Bucks
84     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
85     string public symbol;                 //An identifier: eg SBX
86     string public version = "P0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
87 
88     function JTU() {
89         balances[msg.sender] = 50000000000000000;                // Give the creator all initial tokens
90         totalSupply = 50000000000000000;                        // Update total supply
91         name = "JTU alumni association";                // Set the name for display purposes
92         decimals = 6;                                 // Amount of decimals for display purposes
93         symbol = "JTU";                               // Set the symbol for display purposes
94     }
95 
96 }