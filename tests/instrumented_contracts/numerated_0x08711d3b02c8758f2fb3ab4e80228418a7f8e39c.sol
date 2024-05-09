1 /**
2  * The Edgeless token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  * Additionally tokens can be locked for a defined time interval by token holders.
4  * The owner's share of tokens is locked for the first year and all tokens not
5  * being sold during the crowdsale but 60.000.000 (owner's share + bounty program) are burned.
6  * Author: Julia Altenried
7  * */
8 
9 pragma solidity ^0.4.6;
10 
11 contract SafeMath {
12   //internals
13 
14   function safeMul(uint a, uint b) internal returns (uint) {
15     uint c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function safeSub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) throw;
33   }
34 }
35 
36 contract EdgelessToken is SafeMath {
37     /* Public variables of the token */
38     string public standard = 'ERC20';
39     string public name = 'Edgeless';
40     string public symbol = 'EDG';
41     uint8 public decimals = 0;
42     uint256 public totalSupply;
43     address public owner;
44     /* from this time on tokens may be transfered (after ICO)*/
45     uint256 public startTime = 1490112000;
46     /* tells if tokens have been burned already */
47     bool burned;
48 
49     /* This creates an array with all balances */
50     mapping (address => uint256) public balanceOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52 
53 
54     /* This generates a public event on the blockchain that will notify clients */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 	event Burned(uint amount);
58 
59     /* Initializes contract with initial supply tokens to the creator of the contract */
60     function EdgelessToken() {
61         owner = 0x003230BBE64eccD66f62913679C8966Cf9F41166;
62         balanceOf[owner] = 500000000;              // Give the owner all initial tokens
63         totalSupply = 500000000;                   // Update total supply
64     }
65 
66     /* Send some of your tokens to a given address */
67     function transfer(address _to, uint256 _value) returns (bool success){
68         if (now < startTime) throw; //check if the crowdsale is already over
69         if(msg.sender == owner && now < startTime + 1 years && safeSub(balanceOf[msg.sender],_value) < 50000000) throw; //prevent the owner of spending his share of tokens within the first year
70         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);                     // Subtract from the sender
71         balanceOf[_to] = safeAdd(balanceOf[_to],_value);                            // Add the same to the recipient
72         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
73         return true;
74     }
75 
76     /* Allow another contract or person to spend some tokens in your behalf */
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowance[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83 
84     /* A contract or  person attempts to get the tokens of somebody else.
85     *  This is only allowed if the token holder approved. */
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
87         if (now < startTime && _from!=owner) throw; //check if the crowdsale is already over
88         if(_from == owner && now < startTime + 1 years && safeSub(balanceOf[_from],_value) < 50000000) throw; //prevent the owner of spending his share of tokens within the first year
89         var _allowance = allowance[_from][msg.sender];
90         balanceOf[_from] = safeSub(balanceOf[_from],_value); // Subtract from the sender
91         balanceOf[_to] = safeAdd(balanceOf[_to],_value);     // Add the same to the recipient
92         allowance[_from][msg.sender] = safeSub(_allowance,_value);
93         Transfer(_from, _to, _value);
94         return true;
95     }
96 
97 
98     /* to be called when ICO is closed, burns the remaining tokens but the owners share (50 000 000) and the ones reserved
99     *  for the bounty program (10 000 000).
100     *  anybody may burn the tokens after ICO ended, but only once (in case the owner holds more tokens in the future).
101     *  this ensures that the owner will not posses a majority of the tokens. */
102     function burn(){
103     	//if tokens have not been burned already and the ICO ended
104     	if(!burned && now>startTime){
105     		uint difference = safeSub(balanceOf[owner], 60000000);//checked for overflow above
106     		balanceOf[owner] = 60000000;
107     		totalSupply = safeSub(totalSupply, difference);
108     		burned = true;
109     		Burned(difference);
110     	}
111     }
112 
113 }