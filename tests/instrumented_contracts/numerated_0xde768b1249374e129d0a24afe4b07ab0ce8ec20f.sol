1 //Copyright (C) 2017-2019 Unimos Foundation. All rights reserved.
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
75     function transfer(address _to, uint256 _value) public returns (bool success) {
76         _transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Transfer tokens from other address
82      *
83      * Send `_value` tokens to `_to` in behalf of `_from`
84      *
85      * @param _from The address of the sender
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender]);
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Set allowance for other address
98      *
99      * Allows `_spender` to spend no more than `_value` tokens in your behalf
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      * @param _extraData some extra information to send to the approved contract
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129     /**
130      * Destroy tokens
131      *
132      * Remove `_value` tokens from the system irreversibly
133      *
134      * @param _value the amount of money to burn
135      */
136     function burn(uint256 _value) public returns (bool success) {
137         require(balanceOf[msg.sender] >= _value);
138         balanceOf[msg.sender] -= _value;
139         totalSupply -= _value;
140         Burn(msg.sender, _value);
141         return true;
142     }
143 
144     /**
145      * Destroy tokens from other account
146      *
147      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
148      *
149      * @param _from the address of the sender
150      * @param _value the amount of money to burn
151      */
152     function burnFrom(address _from, uint256 _value) public returns (bool success) {
153         require(balanceOf[_from] >= _value);
154         require(_value <= allowance[_from][msg.sender]);
155         balanceOf[_from] -= _value;
156         allowance[_from][msg.sender] -= _value;
157         totalSupply -= _value;
158         Burn(_from, _value);
159         return true;
160     }
161 }
162 
163 /******************************************/
164 /*              UTOM STARTS HERE          */
165 /******************************************/
166 
167 contract UTOM is owned, TokenERC20 {
168 
169     uint256 public sellPrice;
170     uint256 public buyPrice;
171 
172     mapping (address => bool) public frozenAccount;
173 
174     /* This generates a public event on the blockchain that will notify clients */
175     event FrozenFunds(address target, bool frozen);
176 
177     /* Initializes contract with initial supply tokens to the creator of the contract */
178     function UTOM() TokenERC20(100000000, "UTOM", "UTOM") public {}
179 
180     /* Internal transfer, only can be called by this contract */
181     function _transfer(address _from, address _to, uint _value) internal {
182         require (_to != 0x0);
183         require (balanceOf[_from] >= _value);
184         require (balanceOf[_to] + _value > balanceOf[_to]);
185         require(!frozenAccount[_from]);
186         require(!frozenAccount[_to]);
187         balanceOf[_from] -= _value;
188         balanceOf[_to] += _value;
189         Transfer(_from, _to, _value);
190     }
191 
192     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
193     /// @param target Address to be frozen
194     /// @param freeze either to freeze it or not
195     function freezeAccount(address target, bool freeze) onlyOwner public {
196         frozenAccount[target] = freeze;
197         FrozenFunds(target, freeze);
198     }
199 }