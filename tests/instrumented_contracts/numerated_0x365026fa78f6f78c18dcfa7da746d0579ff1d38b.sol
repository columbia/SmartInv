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
13 contract VCCoin  {
14     function balanceOf(address _owner) constant returns (uint256 balance) {
15         return balances[_owner];
16     }
17 
18     function approve(address _spender, uint256 _value) returns (bool success) {
19         allowed[msg.sender][_spender] = _value;
20         Approval(msg.sender, _spender, _value);
21         return true;
22     }
23 
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
25       return allowed[_owner][_spender];
26     }
27 
28     mapping(address => uint256) balances;
29 
30     mapping (address => mapping (address => uint256)) allowed;
31 
32     string public name = "VC Coin";
33     string public symbol = "VCC";
34     uint public decimals = 18;
35 
36 
37     // Initial founder address (set in constructor)
38     // All deposited ETH will be instantly forwarded to this address.
39     address public founder = 0x0;
40 
41     uint256 public totalVCCoin = 5625000 * 10**decimals;
42 
43     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
44 
45     event AllocateFounderTokens(address indexed sender);
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 
49     //constructor
50     function VCCoin(address founderInput) {
51         founder = founderInput;
52         balances[founder] = totalVCCoin;
53     }
54 
55 
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
68 
69         //Default assumes totalSupply can't be over max (2^256 - 1).
70         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
71         //Replace the if with this one instead.
72         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73         //if (balances[msg.sender] >= _value && _value > 0) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79 
80     }
81     /**
82      * ERC 20 Standard Token interface transfer function
83      *
84      * Prevent transfers until freeze period is over.
85      */
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
87         if (msg.sender != founder) revert();
88 
89         //same as above. Replace this line with the following if you want to protect against wrapping uints.
90         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92             balances[_to] += _value;
93             balances[_from] -= _value;
94             allowed[_from][msg.sender] -= _value;
95             Transfer(_from, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     /**
101      * Do not allow direct deposits.
102      *
103      * All crowdsale depositors must have read the legal agreement.
104      * This is confirmed by having them signing the terms of service on the website.
105      * The give their crowdsale Ethereum source address on the website.
106      * Website signs this address using crowdsale private key (different from founders key).
107      * buy() takes this signature as input and rejects all deposits that do not have
108      * signature you receive after reading terms of service.
109      *
110      */
111     function() {
112         revert();
113     }
114 
115     // only owner can kill
116     function kill() { 
117         if (msg.sender == founder) suicide(founder); 
118     }
119 
120 }