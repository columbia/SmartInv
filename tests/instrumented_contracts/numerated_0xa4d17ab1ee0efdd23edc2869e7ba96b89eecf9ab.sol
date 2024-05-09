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
13 contract TRUEToken  {
14     string public constant name = "TRUE Token";
15     string public constant symbol = "TRUE";
16     uint public constant decimals = 18;
17     uint256 _totalSupply    = 100000000 * 10**decimals;
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
42     address public founder = 0x0;
43 
44     uint256 public distributed = 0;
45 
46     event AllocateFounderTokens(address indexed sender);
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 
50     //constructor
51     function TRUEToken(address _founder) {
52         founder = _founder;
53     }
54 
55     function setStartTime(uint _startTime) {
56         if (msg.sender!=founder) revert();
57         baseStartTime = _startTime;
58     }
59 
60     /**
61      * Distribute tokens out.
62      *
63      * Security review
64      *
65      * Applicable tests:
66      *
67      *
68      */
69     function distribute(uint256 _amount, address _to) {
70         if (msg.sender!=founder) revert();
71         if (distributed + _amount > _totalSupply) revert();
72 
73         distributed += _amount;
74 
75         balances[_to] += _amount;
76         Transfer(this, _to, _amount);
77     }
78 
79 
80 
81     /**
82      * ERC 20 Standard Token interface transfer function
83      *
84      * Prevent transfers until freeze period is over.
85      *
86      * Applicable tests:
87      *
88      * - Test restricted early transfer
89      * - Test transfer after restricted period
90      */
91     function transfer(address _to, uint256 _value) returns (bool success) {
92         if (now < baseStartTime) revert();
93 
94         //Default assumes totalSupply can't be over max (2^256 - 1).
95         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
96         //Replace the if with this one instead.
97         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
98             balances[msg.sender] -= _value;
99             balances[_to] += _value;
100             Transfer(msg.sender, _to, _value);
101             return true;
102         } else {
103             return false;
104         }
105     }
106 
107     /**
108      * Change founder address (where ICO ETH is being forwarded).
109      *
110      * Applicable tests:
111      *
112      * - Test founder change by hacker
113      * - Test founder change
114      * - Test founder token allocation twice
115      */
116     function changeFounder(address newFounder) {
117         if (msg.sender!=founder) revert();
118         founder = newFounder;
119     }
120 
121     /**
122      * ERC 20 Standard Token interface transfer function
123      *
124      * Prevent transfers until freeze period is over.
125      */
126     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
127         if (msg.sender != founder) revert();
128 
129         //same as above. Replace this line with the following if you want to protect against wrapping uints.
130         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
131 
132             balances[_to] += _value;
133             balances[_from] -= _value;
134             allowed[_from][msg.sender] -= _value;
135             Transfer(_from, _to, _value);
136             return true;
137         } else { return false; }
138     }
139 
140     // forward all eth to founder
141     function() payable {
142         if (!founder.call.value(msg.value)()) revert(); 
143     }
144 
145     // only owner can kill
146     function kill() { 
147         if (msg.sender == founder) {
148             suicide(founder); 
149         }
150     }
151 
152 }