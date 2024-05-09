1 pragma solidity ^0.4.6;
2  
3 contract SafeMath {
4   //internals
5  
6   function safeMul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11  
12   function safeSub(uint a, uint b) internal returns (uint) {
13     assert(b <= a);
14     return a - b;
15   }
16  
17   function safeAdd(uint a, uint b) internal returns (uint) {
18     uint c = a + b;
19     assert(c>=a && c>=b);
20     return c;
21   }
22  
23   function assert(bool assertion) internal {
24     if (!assertion) throw;
25   }
26 }
27  
28 contract VOISE is SafeMath {
29     /* Public variables of the token */
30     string public standard = 'ERC20';
31     string public name = 'VOISE';
32     string public symbol = 'VSM';
33     uint8 public decimals = 0;
34     uint256 public totalSupply;
35     address public owner;
36     uint256 public startTime = 1492560000;
37     /* tells if tokens have been burned already */
38     bool burned;
39  
40     /* This creates an array with all the balances */
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43  
44  
45     /* This generates a public event on the blockchain that will notify all clients */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48     event Burned(uint amount);
49  
50     /* Initializes contract with initial supply tokens and gives them to the voise team adress */
51     function VOISE() {
52         
53         owner = 0xbB93222C54f72ae99b2539a44093f2ED62533EBE;
54         
55         balanceOf[owner] = 100000000;              // All of them are stored in the voise team adress until they are bought
56         totalSupply = 100000000;                   // total supply of tokens
57     }
58  
59     /* Send some of your tokens to a given address (Press bounties) */
60     function transfer(address _to, uint256 _value) returns (bool success){
61         if (now < startTime) throw; //check if the crowdsale is already over
62         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);                     // Subtract from the sender
63         balanceOf[_to] = safeAdd(balanceOf[_to],_value);                            // Add the same to the recipient
64         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
65         return true;
66     }
67  
68     /* Allow another contract or person to spend some tokens in your behalf */
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74  
75  
76     /* A contract or  person attempts to get the tokens of somebody else. */
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         if (now < startTime && _from!=owner) throw; //check if the crowdsale is already over
79         var _allowance = allowance[_from][msg.sender];
80         balanceOf[_from] = safeSub(balanceOf[_from],_value); // Subtract from the sender
81         balanceOf[_to] = safeAdd(balanceOf[_to],_value);     // Add the same to the recipient
82         allowance[_from][msg.sender] = safeSub(_allowance,_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86  
87  
88     /* to be called when ICO is closed, burns the remaining tokens.
89     *  for the bounty program (3%).
90     *  for  team (5%)  */
91     
92     function burn(){
93         //if tokens have not been burned already and the ICO ended, burn them
94         if(!burned && now>startTime){
95             uint difference = safeSub(balanceOf[owner], 8000000);
96             balanceOf[owner] = 8000000;
97             totalSupply = safeSub(totalSupply, difference);
98             burned = true;
99             Burned(difference);
100         }
101     }
102  
103 }