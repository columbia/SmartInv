1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-27
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 
9 library SafeMath {
10     
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a / b;
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract LeeeMallToken {
38     using SafeMath for uint;
39     string public name = "LeeeMall";
40     string public symbol = "LEEE";
41     uint8 public decimals = 18;
42     uint256 public totalSupply = 1*1000*1000*1000*10*10**uint256(decimals);
43 
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 
51     event Burn(address indexed from, uint256 value);
52 
53     /**
54      * Constrctor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     function LeeeMallToken(
59     ) public {
60         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         require(_to != 0x0);
68 
69         require(balanceOf[_from] >= _value);
70         
71         require(balanceOf[_to].add(_value) > balanceOf[_to]);
72         
73         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
74         
75         balanceOf[_from] = balanceOf[_from].sub(_value);
76         
77         balanceOf[_to] = balanceOf[_to].add(_value);
78         Transfer(_from, _to, _value);
79         
80         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address and notify
129      *
130      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      * @param _extraData some extra information to send to the approved contract
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
137         public
138         returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, this, _extraData);
142             return true;
143         }
144     }
145 
146     /**
147      * Destroy tokens
148      *
149      * Remove `_value` tokens from the system irreversibly
150      *
151      * @param _value the amount of money to burn
152      */
153     function burn(uint256 _value) public returns (bool success) {
154         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
155         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
156         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
157         Burn(msg.sender, _value);
158         return true;
159     }
160 
161     /**
162      * Destroy tokens from other account
163      *
164      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
165      *
166      * @param _from the address of the senderT
167      * @param _value the amount of money to burn
168      */
169     function burnFrom(address _from, uint256 _value) public returns (bool success) {
170         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
171         require(_value <= allowance[_from][msg.sender]);    // Check allowance
172         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
173         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
174         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
175         Burn(_from, _value);
176         return true;
177     }
178 }