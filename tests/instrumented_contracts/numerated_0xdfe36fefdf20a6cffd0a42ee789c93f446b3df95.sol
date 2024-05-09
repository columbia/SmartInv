1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function toUINT112(uint256 a) internal constant returns(uint112) {
33     assert(uint112(a) == a);
34     return uint112(a);
35   }
36 
37   function toUINT120(uint256 a) internal constant returns(uint120) {
38     assert(uint120(a) == a);
39     return uint120(a);
40   }
41 
42   function toUINT128(uint256 a) internal constant returns(uint128) {
43     assert(uint128(a) == a);
44     return uint128(a);
45   }
46 }
47 
48 contract HelloToken {
49     using SafeMath for uint256;
50     // Public variables of the token
51     string public constant name    = "Hello Token";  //The Token's name
52     uint8 public constant decimals = 18;               //Number of decimals of the smallest unit
53     string public constant symbol  = "HelloT";            //An identifier    
54     // 18 decimals is the strongly suggested default, avoid changing it
55     
56     // packed to 256bit to save gas usage.
57     struct Supplies {
58         // uint128's max value is about 3e38.
59         // it's enough to present amount of tokens
60         uint128 totalSupply;
61     }
62     
63     Supplies supplies;
64     
65     // Packed to 256bit to save gas usage.    
66     struct Account {
67         // uint112's max value is about 5e33.
68         // it's enough to present amount of tokens
69         uint112 balance;
70     }
71     
72 
73     // This creates an array with all balances
74     mapping (address => Account) public balanceOf;
75 
76     // This generates a public event on the blockchain that will notify clients
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     // This notifies clients about the amount burnt
80     event Burn(address indexed from, uint256 value);
81 
82     /**
83      * Constructor function
84      *
85      * Initializes contract with initial supply tokens to the creator of the contract
86      */
87     function HelloToken() public {
88         supplies.totalSupply = 1*(10**10) * (10 ** 18);  // Update total supply with the decimal amount
89         balanceOf[msg.sender].balance = uint112(supplies.totalSupply);                // Give the creator all initial tokens
90     }
91     
92     // Send back ether sent to me
93     function () {
94         revert();
95     }
96 
97     /**
98      * Internal transfer, only can be called by this contract
99      */
100     function _transfer(address _from, address _to, uint _value) internal {
101         // Prevent transfer to 0x0 address. Use burn() instead
102         require(_to != 0x0);
103         // Check if the sender has enough
104         require(balanceOf[_from].balance >= _value);
105         // Check for overflows
106         require(balanceOf[_to].balance + _value >= balanceOf[_to].balance);
107         // Save this for an assertion in the future
108         uint previousBalances = balanceOf[_from].balance + balanceOf[_to].balance;
109         // Subtract from the sender
110         balanceOf[_from].balance -= uint112(_value);
111         // Add the same to the recipient
112         balanceOf[_to].balance = _value.add(balanceOf[_to].balance).toUINT112();
113         emit Transfer(_from, _to, _value);
114         // Asserts are used to use static analysis to find bugs in your code. They should never fail
115         assert(balanceOf[_from].balance + balanceOf[_to].balance == previousBalances);
116     }
117 
118     /**
119      * Transfer tokens
120      *
121      * Send `_value` tokens to `_to` from your account
122      *
123      * @param _to The address of the recipient
124      * @param _value the amount to send
125      */
126     function transfer(address _to, uint256 _value) public {
127         _transfer(msg.sender, _to, _value);
128     }
129 
130     
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burn(uint256 _value) public returns (bool success) {
139         require(balanceOf[msg.sender].balance >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender].balance -= uint112(_value);            // Subtract from the sender
141         supplies.totalSupply -= uint128(_value);                      // Updates totalSupply
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145     
146     /**
147      * Total Supply
148      *
149      * View Total Supply
150      *
151      * Return Total Supply
152      * 
153      */
154     function totalSupply() public constant returns (uint256 supply){
155         return supplies.totalSupply;
156     }
157 }