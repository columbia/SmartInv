1 /**
2  * The D-WALLET token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  * Additionally tokens can be locked for a defined time interval by token holders.
4  * Except  1,024,000,000 tokens (D-WALLET Frozen Vault + Bounty) all unsold tokens will be burned.
5  * Author: D-WALLET TEAM
6  * */
7 
8 pragma solidity ^0.4.6;
9 
10 contract SafeMath {
11   //internals
12 
13   function safeMul(uint a, uint b) internal returns (uint) {
14     uint c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function safeSub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 }
30 
31 contract DWalletToken is SafeMath {
32 
33     /* Public variables of the token */
34     string public standard = 'ERC20';
35     string public name = 'D-WALLET TOKEN';
36     string public symbol = 'DWT';
37     uint8 public decimals = 0;
38     uint256 public totalSupply;
39     address public owner;
40     /* ICO Start time 26 August, 2017 13:00:00 GMT*/
41     uint256 public startTime = 1503752400;
42 	/* ICO Start time 25 October, 2017 17:00:00 GMT*/
43 	uint256 public endTime = 1508950800;
44     /* tells if tokens have been burned already */
45     bool burned;
46 
47     /* Create an array with all balances so that blockchain will know */
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51 
52     /* Generate a public event on the blockchain to notify clients */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 	event Burned(uint amount);
56 	  // fallback function
57     function () payable {
58      owner.transfer(msg.value);
59    }
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     function DWalletToken() {
63         owner = 0x1C46b45a7d6d28E27A755448e68c03248aefd18b;
64         balanceOf[owner] = 10000000000;              // Give the owner all initial tokens
65         totalSupply = 10000000000;                   // Update initial total supply
66     }
67 
68     /* function to send tokens to a given address */
69     function transfer(address _to, uint256 _value) returns (bool success){
70         require (now < startTime); //check if the crowdsale is already over
71         require(msg.sender == owner && now < startTime + 1 years && safeSub(balanceOf[msg.sender],_value) < 1000000000); //prevent the owner of spending his share of tokens within the first year 
72         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);                     // Subtract from the sender
73         balanceOf[_to] = safeAdd(balanceOf[_to],_value);                            // Add the same to the recipient
74         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
75         return true;
76     }
77 
78     /* Function to allow spender to spend token on owners behalf */
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowance[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85 
86     /* Transferfrom function*/
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         require (now < startTime && _from!=owner); //check if the crowdsale is already over 
89         require(_from == owner && now < startTime + 1 years && safeSub(balanceOf[_from],_value) < 1000000000);
90         var _allowance = allowance[_from][msg.sender];
91         balanceOf[_from] = safeSub(balanceOf[_from],_value); // Subtract from the sender
92         balanceOf[_to] = safeAdd(balanceOf[_to],_value);     // Add the same to the recipient
93         allowance[_from][msg.sender] = safeSub(_allowance,_value);
94         Transfer(_from, _to, _value);
95         return true;
96     }
97 
98 
99     /* To be called when ICO is closed, burns the remaining tokens but the D-WALLET FREEZE VAULT (1000000000) and the ones reserved
100     *  for the bounty program (24000000).
101     *  anybody may burn the tokens after ICO ended, but only once (in case the owner holds more tokens in the future).
102     *  this ensures that the owner will not posses a majority of the tokens. */
103     function burn(){
104     	//if tokens have not been burned already and the ICO ended
105     	if(!burned && now>endTime){
106     		uint difference = safeSub(balanceOf[owner], 1024000000);//checked for overflow above
107     		balanceOf[owner] = 1024000000;
108     		totalSupply = safeSub(totalSupply, difference);
109     		burned = true;
110     		Burned(difference);
111     	}
112     }
113 
114 }