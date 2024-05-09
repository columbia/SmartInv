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
28 contract DroplexToken is SafeMath {
29     /* Public variables of the token */
30     string public standard = 'ERC20';
31     string public name = 'Droplex Token';
32     string public symbol = 'DROP';
33     uint8 public decimals = 0;
34     uint256 public totalSupply = 30000000;
35     address public owner = 0xaBE3d12e5518BF8266bB91B56913962ce1F77CF4;
36     /* from this time on tokens may be transfered (after ICO)*/
37 
38     /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41 
42 
43     /* This generates a public event on the blockchain that will notify clients */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 
47     /* Initializes contract with initial supply tokens to the creator of the contract */
48     function DroplexToken() {
49         owner = 0xaBE3d12e5518BF8266bB91B56913962ce1F77CF4;
50         balanceOf[owner] = 30000000;              // Give the owner all initial tokens
51         totalSupply = 30000000;                   // Update total supply
52     }
53 
54     /* Send some of your tokens to a given address */
55     function transfer(address _to, uint256 _value) returns (bool success){
56         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);                     // Subtract from the sender
57         balanceOf[_to] = safeAdd(balanceOf[_to],_value);                            // Add the same to the recipient
58         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
59         return true;
60     }
61 
62     /* Allow another contract or person to spend some tokens in your behalf */
63     function approve(address _spender, uint256 _value) returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69 
70     /* A contract or  person attempts to get the tokens of somebody else.
71     *  This is only allowed if the token holder approved. */
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
73         var _allowance = allowance[_from][msg.sender];
74         balanceOf[_from] = safeSub(balanceOf[_from],_value); // Subtract from the sender
75         balanceOf[_to] = safeAdd(balanceOf[_to],_value);     // Add the same to the recipient
76         allowance[_from][msg.sender] = safeSub(_allowance,_value);
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81 }