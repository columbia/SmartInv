1 //Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
2 
3 pragma solidity ^0.4.19;
4 
5 contract owned {
6     address public owner;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
23 
24 contract TokenERC20 {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     uint256 public totalSupply;
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function TokenERC20(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);
48         balanceOf[msg.sender] = totalSupply;
49         name = tokenName;
50         symbol = tokenSymbol;
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         require(_to != 0x0);
58         require(balanceOf[_from] >= _value);
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         balanceOf[_from] -= _value;
62         balanceOf[_to] += _value;
63         Transfer(_from, _to, _value);
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public {
76         _transfer(msg.sender, _to, _value);
77     }
78 
79     /**
80      * Transfer tokens from other address
81      *
82      * Send `_value` tokens to `_to` in behalf of `_from`
83      *
84      * @param _from The address of the sender
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
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
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         public
120         returns (bool success) {
121         tokenRecipient spender = tokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 
128     /**
129      * Destroy tokens
130      *
131      * Remove `_value` tokens from the system irreversibly
132      *
133      * @param _value the amount of money to burn
134      */
135     function burn(uint256 _value) public returns (bool success) {
136         require(balanceOf[msg.sender] >= _value);
137         balanceOf[msg.sender] -= _value;
138         totalSupply -= _value;
139         Burn(msg.sender, _value);
140         return true;
141     }
142 
143     /**
144      * Destroy tokens from other account
145      *
146      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
147      *
148      * @param _from the address of the sender
149      * @param _value the amount of money to burn
150      */
151     function burnFrom(address _from, uint256 _value) public returns (bool success) {
152         require(balanceOf[_from] >= _value);
153         require(_value <= allowance[_from][msg.sender]);
154         balanceOf[_from] -= _value;
155         allowance[_from][msg.sender] -= _value;
156         totalSupply -= _value;
157         Burn(_from, _value);
158         return true;
159     }
160 }
161 
162 /******************************************/
163 /*          HASHCOIN STARTS HERE          */
164 /******************************************/
165 
166 contract HashCoin is owned, TokenERC20 {
167 
168     uint256 public sellPrice;
169     uint256 public buyPrice;
170 
171     mapping (address => bool) public frozenAccount;
172 
173     /* This generates a public event on the blockchain that will notify clients */
174     event FrozenFunds(address target, bool frozen);
175 
176     /* Initializes contract with initial supply tokens to the creator of the contract */
177     function HashCoin(
178         uint256 initialSupply,
179         string tokenName,
180         string tokenSymbol
181     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
182 
183     /* Internal transfer, only can be called by this contract */
184     function _transfer(address _from, address _to, uint _value) internal {
185         require (_to != 0x0);
186         require (balanceOf[_from] >= _value);
187         require (balanceOf[_to] + _value > balanceOf[_to]);
188         require(!frozenAccount[_from]);
189         require(!frozenAccount[_to]);
190         balanceOf[_from] -= _value;
191         balanceOf[_to] += _value;
192         Transfer(_from, _to, _value);
193     }
194 
195     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
196     /// @param target Address to be frozen
197     /// @param freeze either to freeze it or not
198     function freezeAccount(address target, bool freeze) onlyOwner public {
199         frozenAccount[target] = freeze;
200         FrozenFunds(target, freeze);
201     }
202 
203     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
204     /// @param newSellPrice Price the users can sell to the contract
205     /// @param newBuyPrice Price users can buy from the contract
206     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
207         sellPrice = newSellPrice;
208         buyPrice = newBuyPrice;
209     }
210 
211     /// @notice Buy tokens from contract by sending ether
212     function buy() payable public {
213         uint amount = msg.value / buyPrice;
214         _transfer(this, msg.sender, amount);
215     }
216 
217     /// @notice Sell `amount` tokens to contract
218     /// @param amount amount of tokens to be sold
219     function sell(uint256 amount) public {
220         require(this.balance >= amount * sellPrice);
221         _transfer(msg.sender, this, amount);
222         msg.sender.transfer(amount * sellPrice);
223     }
224 }