1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract AzurionToken is owned {
23     mapping (address => uint256) public balanceOf;
24     mapping (address => bool) public frozenAccount;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     uint256 public totalSupply;
28     string public constant name = "Azurion";
29     string public constant symbol = "AZU";
30     uint8 public constant decimals = 18;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Burn(address indexed from, uint256 value);
34     event FrozenFunds(address target, bool frozen);
35 
36     function AzurionToken(uint256 initialSupply, address centralMinter) {
37         if(centralMinter != 0 ) owner = centralMinter;
38         balanceOf[msg.sender] = initialSupply;
39         totalSupply = initialSupply;
40     }
41 
42     /* Internal transfer, only can be called by this contract */
43     function _transfer(address _from, address _to, uint _value) internal {
44         require (_to != 0x0);                               
45         require (balanceOf[_from] > _value);                
46         require (balanceOf[_to] + _value > balanceOf[_to]); 
47         require(!frozenAccount[_from]);                     
48         require(!frozenAccount[_to]);                       
49         balanceOf[_from] -= _value;                         
50         balanceOf[_to] += _value;                           
51         Transfer(_from, _to, _value);
52     }
53 
54     /**
55     * Transfer tokens
56     *
57     * Send `_value` tokens to `_to` from your account
58     *
59     * @param _to The address of the recipient
60     * @param _value the amount to send
61     */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     /**
67      * Transfer tokens from other address
68      *
69      * Send `_value` tokens to `_to` in behalf of `_from`
70      *
71      * @param _from The address of the sender
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
83         balanceOf[target] += mintedAmount;
84         totalSupply += mintedAmount;
85         Transfer(0, owner, mintedAmount);
86         Transfer(owner, target, mintedAmount);
87     }
88 
89     /// @param target Address to be frozen
90     /// @param freeze either to freeze it or not
91     function freezeAccount(address target, bool freeze) onlyOwner public {
92         frozenAccount[target] = freeze;
93         FrozenFunds(target, freeze);
94     }
95 
96     /**
97    * Set allowance for other address
98    *
99    * Allows `_spender` to spend no more than `_value` tokens in your behalf
100    *
101    * @param _spender The address authorized to spend
102    * @param _value the max amount they can spend
103    */
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address and notify
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      * @param _extraData some extra information to send to the approved contract
117      */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 
126     /**
127       * Destroy tokens
128       *
129       * Remove `_value` tokens from the system irreversibly
130       *
131       * @param _value the amount of money to burn
132       */
133     function burn(uint256 _value) onlyOwner public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
135         balanceOf[msg.sender] -= _value;            // Subtract from the sender
136         totalSupply -= _value;                      // Updates totalSupply
137         Burn(msg.sender, _value);
138         return true;
139     }
140 
141     /**
142      * Destroy tokens from other ccount
143      *
144      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145      *
146      * @param _from the address of the sender
147      * @param _value the amount of money to burn
148      */
149     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
150         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
151         require(_value <= allowance[_from][msg.sender]);    // Check allowance
152         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
153         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         Burn(_from, _value);
156         return true;
157     }
158 
159     function () {
160         revert();
161     }
162 }