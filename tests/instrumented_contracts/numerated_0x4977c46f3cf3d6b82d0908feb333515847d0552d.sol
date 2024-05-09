1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         require(newOwner != 0x0);
17         owner = newOwner;
18     }
19 }
20 
21 /**
22  * Math operations with safety checks
23  */
24 contract SafeMath {
25   function mul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function sub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49 
50     }
51   
52 
53 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
54 
55 contract TokenPAD is owned, SafeMath {
56     // Public variables of the token
57     string public name = "Platform for Air Drops";
58     string public symbol = "PAD";
59     uint8 public decimals = 18;
60     uint256 public totalSupply = 15000000000000000000000000;
61     
62    
63     mapping (address => uint256) public balanceOf;
64     mapping (address => mapping (address => uint256)) public allowance;
65 
66     
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     // This notifies clients about the amount burnt
70     event Burn(address indexed from, uint256 value);
71 
72     /**
73      * Constrctor function
74      *
75      * Initializes contract with initial supply tokens to the creator of the contract
76      */
77     function TokenPAD(
78       
79     ) public {
80        
81          balanceOf[msg.sender] = totalSupply;                 
82 
83     }
84 
85     /**
86      * Internal transfer, only can be called by this contract
87      */
88     function _transfer(address _from, address _to, uint _value) internal {
89          // Prevent transfer to 0x0 address. Use burn() instead
90         require(_to != 0x0);
91         // Check if the sender has enough
92         require(balanceOf[_from] >= _value);
93         // Check for overflows
94         require(add(balanceOf[_to],_value) > balanceOf[_to]);
95         // Save this for an assertion in the future
96         uint previousBalances = add(balanceOf[_from], balanceOf[_to]);
97         // Subtract from the sender
98         balanceOf[_from] = sub(balanceOf[_from],_value);
99         // Add the same to the recipient
100         balanceOf[_to] =add(balanceOf[_to],_value);
101         Transfer(_from, _to, _value);
102         // Asserts are used to use static analysis to find bugs in code. 
103         assert(add(balanceOf[_from],balanceOf[_to]) == previousBalances);
104     }
105 
106     /**
107      * Transfer tokens
108      *
109      * Send `_value` tokens to `_to` from your account
110      *
111      * @param _to The address of the recipient
112      * @param _value the amount to send
113      */
114     function transfer(address _to, uint _value) public {
115         _transfer(msg.sender, _to, _value);
116     }
117 
118     /**
119      * Transfer tokens from other address
120      *
121      * Send `_value` tokens to `_to` in behalf of `_from`
122      *
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value the amount to send
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128          require(_value <= allowance[_from][msg.sender]);     // Check allowance
129         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender],_value);
130         _transfer(_from, _to, _value);
131         return true;
132     }
133 
134     /**
135      * Set allowance for other address
136      *
137      * Allows `_spender` to spend no more than `_value` tokens in your behalf
138      *
139      * @param _spender The address authorized to spend
140      * @param _value the max amount they can spend
141      */
142     function approve(address _spender, uint256 _value) public
143         returns (bool success) {
144         allowance[msg.sender][_spender] = _value;
145         return true;
146     }
147 
148     /**
149      * Set allowance for other address and notify
150      *
151      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
152      *
153      * @param _spender The address authorized to spend
154      * @param _value the max amount they can spend
155      * @param _extraData some extra information to send to the approved contract
156      */
157     function approveAndCall(address _spender, uint256 _value, bytes _extraData) onlyOwner
158         public
159         returns (bool success) {
160         tokenRecipient spender = tokenRecipient(_spender);
161         if (approve(_spender, _value)) {
162             spender.receiveApproval(msg.sender, _value, this, _extraData);
163             return true;
164         }
165     }
166 
167     /**
168      * Destroy tokens
169      *
170      * Remove `_value` tokens from the system irreversibly
171      *
172      * @param _value the amount of money to burn
173      */
174     function burn(uint256 _value) onlyOwner public returns (bool success) {
175         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
176         balanceOf[msg.sender] = sub( balanceOf[msg.sender],_value);            // Subtract from the sender
177         totalSupply =sub(totalSupply,_value);                      // Updates totalSupply
178         Burn(msg.sender, _value);
179         return true;
180     }
181 }