1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract TokenERC20 {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // Triggered when tokens are transferred.
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     // Triggered when spending allowance is set.
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21     /**
22      * Constructor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol) internal {
27         totalSupply = _initialSupply * 10 ** uint256(decimals);
28         balanceOf[msg.sender] = totalSupply;
29         name = _tokenName;
30         symbol = _tokenSymbol;
31     }
32 
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         require(_to != 0x0);
38 
39         require(balanceOf[_from] >= _value);
40         require(balanceOf[_to] + _value > balanceOf[_to]);
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42 
43         // Perform the transfer
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
47         Transfer(_from, _to, _value);
48     }
49 
50     /**
51      * Transfer tokens
52      *
53      * Send `_value` tokens to `_to` from your account
54      *
55      * @param _to The address of the recipient
56      * @param _value the amount to send
57      */
58     function transfer(address _to, uint256 _value) public returns (bool success) {
59         _transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` in behalf of `_from`
67      *
68      * @param _from The address of the sender
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);
74 
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Set allowance for other address
82      *
83      * Allows `_spender` to spend no more than `_value` tokens in your behalf
84      *
85      * @param _spender The address authorized to spend
86      * @param _value the max amount they can spend
87      */
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         require(_spender != 0x0);
90 
91         allowance[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     /**
97      * Set allowance for other address and notify
98      *
99      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      * @param _extraData some extra information to send to the approved contract
104      */
105     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
106         tokenRecipient spender = tokenRecipient(_spender);
107         if (!approve(_spender, _value)) {
108             return false;
109         }
110 
111         spender.receiveApproval(msg.sender, _value, this, _extraData);
112         return true;
113     }
114 }
115 
116 contract Owned {
117     address public owner;
118 
119     function Owned() internal {
120         owner = msg.sender;
121     }
122 
123     modifier onlyOwner {
124         require(msg.sender == owner);
125         _;
126     }
127 
128     function transferOwnership(address _newOwner) onlyOwner public {
129         owner = _newOwner;
130     }
131 }
132 
133 contract WMCToken is Owned, TokenERC20 {
134     address public clearing;
135 
136     mapping (address => bool) public frozenAccount;
137 
138     // Triggered when account freeze status changes.
139     event FrozenFunds(address target, bool frozen);
140 
141     // Triggered when tokens are burnt.
142     event Burn(address indexed from, uint256 value);
143 
144     function WMCToken() TokenERC20(20000000, "Weekend Millionaires Club Token", "WMC") public {
145         clearing = 0x0;
146     }
147 
148     function freezeAccount(address _target, bool _freeze) onlyOwner public {
149         require(_target != 0x0);
150 
151         frozenAccount[_target] = _freeze;
152         FrozenFunds(_target, _freeze);
153     }
154 
155     function transferClearingFunction(address _clearing) onlyOwner public {
156         clearing = _clearing;
157     }
158 
159     /**
160      * Internal transfer, only can be called by this contract
161      */
162     function _transfer(address _from, address _to, uint _value) internal {
163         require (clearing == 0x0 || clearing == _from || clearing == _to);
164 
165         require(!frozenAccount[_from]);
166         require(!frozenAccount[_to]);
167 
168         super._transfer(_from, _to, _value);
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) onlyOwner public returns (bool success) {
179         require(balanceOf[msg.sender] >= _value);
180 
181         balanceOf[msg.sender] -= _value;
182         totalSupply -= _value;
183         Burn(msg.sender, _value);
184         return true;
185     }
186 
187     /**
188      * Destroy tokens from other account
189      *
190      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
191      *
192      * @param _from the address of the sender
193      * @param _value the amount of money to burn
194      */
195     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
196         require(balanceOf[_from] >= _value);
197         require(_value <= allowance[_from][msg.sender]);
198 
199         balanceOf[_from] -= _value;
200         allowance[_from][msg.sender] -= _value;
201         totalSupply -= _value;
202         Burn(_from, _value);
203         return true;
204     }
205 }