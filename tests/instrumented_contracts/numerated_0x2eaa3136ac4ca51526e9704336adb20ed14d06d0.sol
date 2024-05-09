1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 pragma solidity ^0.4.11;
7 
8 /**
9  * ERC 20 token
10  *
11  * https://github.com/ethereum/EIPs/issues/20
12  */
13 contract RCCCToken  {
14     string public constant name = "RCCC Token";
15     string public constant symbol = "RCCC";
16     uint public constant decimals = 18;
17     uint256 _totalSupply    = 500000000 * 10**decimals;
18 
19     function totalSupply() constant returns (uint256 supply) {
20         return _totalSupply;
21     }
22 
23     function balanceOf(address _owner) constant returns (uint256 balance) {
24         return balances[_owner];
25     }
26 
27     function approve(address _spender, uint256 _value) returns (bool success) {
28         allowed[msg.sender][_spender] = _value;
29         Approval(msg.sender, _spender, _value);
30         return true;
31     }
32 
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
34       return allowed[_owner][_spender];
35     }
36 
37     mapping(address => uint256) balances; //list of balance of each address
38     mapping(address => mapping (address => uint256)) allowed;
39 
40     uint public baseStartTime; //All other time spots are calculated based on this time spot.
41 
42     address public founder = 0x5e06E608959D68Cf33584BEa9bF6e5CF3975EDe4;
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     //constructor
48     function RCCCToken() {
49         balances[founder] = _totalSupply;
50     }
51 
52     function setStartTime(uint _startTime) {
53         if (msg.sender!=founder) revert();
54         baseStartTime = _startTime;
55     }
56 
57     /**
58      * ERC 20 Standard Token interface transfer function
59      *
60      * Prevent transfers until freeze period is over.
61      *
62      * Applicable tests:
63      *
64      * - Test restricted early transfer
65      * - Test transfer after restricted period
66      */
67     function transfer(address _to, uint256 _value) returns (bool success) {
68         if (now < baseStartTime) revert();
69 
70         //Default assumes totalSupply can't be over max (2^256 - 1).
71         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
72         //Replace the if with this one instead.
73         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else {
79             return false;
80         }
81     }
82 
83     /**
84      * Change founder address (where ICO ETH is being forwarded).
85      *
86      * Applicable tests:
87      *
88      * - Test founder change by hacker
89      * - Test founder change
90      * - Test founder token allocation twice
91      */
92     function changeFounder(address newFounder) {
93         if (msg.sender!=founder) revert();
94         founder = newFounder;
95     }
96 
97     /**
98      * ERC 20 Standard Token interface transfer function
99      *
100      * Prevent transfers until freeze period is over.
101      */
102     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
103         if (msg.sender != founder) revert();
104 
105         //same as above. Replace this line with the following if you want to protect against wrapping uints.
106         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
107 
108             balances[_to] += _value;
109             balances[_from] -= _value;
110             allowed[_from][msg.sender] -= _value;
111             Transfer(_from, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     // forward all eth to founder
117     function() payable {
118         if (!founder.call.value(msg.value)()) revert(); 
119     }
120 
121     // only owner can kill
122     function kill() { 
123         if (msg.sender == founder) {
124             suicide(founder); 
125         }
126     }
127 
128 }