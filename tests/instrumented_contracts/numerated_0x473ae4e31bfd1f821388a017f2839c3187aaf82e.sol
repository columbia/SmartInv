1 /**
2  *  ATMX Ameritoken contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract Ameritoken {
27     string public constant name = 'Ameritoken';                                 // Public variables of the token
28     string public constant symbol = 'ATMX';                                     
29     uint256 public constant decimals = 0;                                       // 0 decimals 
30     string public constant version = 'ATMX-1.1';                                // Public Version
31                                                                                 // Corrected glitch of sending double qty to receiver. 
32                                                                                 // Fix provided by https://ethereum.stackexchange.com/users/19510/smarx
33                                               
34     uint256 private constant totalTokens = 41000000;                            // Fourty One million coins, NO FORK
35                                                                                 // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;                              // (ERC20)
37     mapping (address => mapping (address => uint256)) public allowance;         // (ERC20)
38 
39                                                                                 // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);    
41  
42     function Ameritoken () public {
43         balanceOf[msg.sender] = totalTokens;                                    // Give the creator (Ameritoken, LLC) all initial tokens.
44     }
45 
46   // See ERC20
47     function totalSupply() constant returns (uint256) {                         // Returns the Total of Ameritokens
48         return totalTokens;
49     }
50 
51     function _transfer(address _from, address _to, uint _value) internal {
52         require(_to != 0x0);                                                    // Prevent transfer to 0x0 address. Use burn() instead
53         require(balanceOf[_from] >= _value);                                    // Check if the sender has enough
54         require(balanceOf[_to] + _value > balanceOf[_to]);                      // Check for overflows
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];              // Save this for an assertion in the future
56         balanceOf[_from] -= _value;                                             // Subtract from the sender
57         balanceOf[_to] += _value;                                               // Add the same to the recipient
58         Transfer(_from, _to, _value);
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);          // Asserts are used to use static analysis to find bugs in your code. They should never fail
60     }
61 
62    
63     function transfer(address _to, uint256 _value) public returns (bool) {
64         if (balanceOf[msg.sender] >= _value) {
65             _transfer(msg.sender, _to, _value);
66             return true;
67         }
68         return false;
69     }
70 
71  
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73     if (balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value) {
74       balanceOf[_from] -= _value;
75       allowance[_from][msg.sender] -= _value;
76       balanceOf[_to] += _value;
77       Transfer(_from, _to, _value);
78       return true;
79     }
80     return false;
81   }
82 
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88 
89 
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
91         tokenRecipient spender = tokenRecipient(_spender);
92         if (approve(_spender, _value)) {
93             spender.receiveApproval(msg.sender, _value, this, _extraData);
94             return true;
95         }
96     }
97 }