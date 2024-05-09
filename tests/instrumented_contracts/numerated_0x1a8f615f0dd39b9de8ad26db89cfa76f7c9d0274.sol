1 pragma solidity ^0.4.18;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         assert(a == b * c);
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a - b;
24         assert(b <= a);
25         assert(a == c + b);
26         return c;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         assert(a == c - b);
33         return c;
34     }
35 }
36 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
37 
38 contract UTOToken {
39     // Public variables of the token
40     string public name="UTour";
41     string public symbol="UTO";
42     uint8 public decimals = 18;
43     // 18 decimals is the strongly suggested default, avoid changing it
44     uint256 public totalSupply=3 * 10 ** 26;
45 
46     // This creates an array with all balances
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53     // This notifies clients about the amount burnt
54     event Burn(address indexed from, uint256 value);
55 
56     /**
57      * Constructor function
58      *
59      * Initializes contract with initial supply tokens to the creator of the contract
60      */
61     // function UTOToken() public {
62     constructor () public {
63         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
64     }
65 
66     /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70        // Prevent transfer to 0x0 address. Use burn() instead
71         require(_to != 0x0);
72         // Subtract from the sender
73         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
74         // Add the same to the recipient
75         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
76         emit Transfer(_from, _to, _value);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public returns (bool success) {
88         _transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     /**
93      * Transfer tokens from other address
94      *
95      * Send `_value` tokens to `_to` on behalf of `_from`
96      *
97      * @param _from The address of the sender
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {   
102         // Check allowance
103         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address
110      *
111      * Allows `_spender` to spend no more than `_value` tokens on your behalf
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      */
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
140         allowance[msg.sender][_spender] = SafeMath.add(allowance[msg.sender][_spender], _addedValue);
141         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
142         return true;
143     } 
144 
145     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
146         uint oldValue = allowance[msg.sender][_spender];
147         if (_subtractedValue > oldValue) {
148             allowance[msg.sender][_spender] = 0;
149         } else {
150             allowance[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
151         }
152         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens
158      *
159      * Remove `_value` tokens from the system irreversibly
160      *
161      * @param _value the amount of money to burn
162      */
163     function burn(uint256 _value) public returns (bool success) { 
164         // Subtract from the sender 
165         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value); 
166         // Updates totalSupply         
167         totalSupply = SafeMath.sub(totalSupply, _value);                    
168         emit Burn(msg.sender, _value);
169         return true;
170     }
171 
172     /**
173      * Destroy tokens from other account
174      *
175      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
176      *
177      * @param _from the address of the sender
178      * @param _value the amount of money to burn
179      */
180     function burnFrom(address _from, uint256 _value) public returns (bool success) {  
181         // Subtract from the targeted balance
182         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);  
183         // Subtract from the sender's allowance
184         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
185         // Update totalSupply         
186         totalSupply = SafeMath.sub(totalSupply, _value);                           
187         emit Burn(_from, _value);
188         return true;
189     }
190 }