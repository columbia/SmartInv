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
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
17 
18 contract TokenERC20 {
19     // Public variables of the token
20     string public name;
21     string public symbol;
22     uint8 public decimals = 18;
23     // 18 decimals is the strongly suggested default, avoid changing it
24     uint256 public totalSupply;
25 
26     // This creates an array with all balances
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29 
30     // This generates a public event on the blockchain that will notify clients
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /**
34      * Constrctor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      */
38     function TokenERC20() public {
39         totalSupply = 10000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = "Talentum";                                   // Set the name for display purposes
42         symbol = "Talent";                               // Set the symbol for display purposes
43     }
44 
45     /**
46      * Internal transfer, only can be called by this contract
47      */
48     function _transfer(address _from, address _to, uint _value) internal {
49         // Prevent transfer to 0x0 address. Use burn() instead
50         require(_to != 0x0);
51         // Check if the sender has enough
52         require(balanceOf[_from] >= _value);
53         // Check for overflows
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55         // Save this for an assertion in the future
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         Transfer(_from, _to, _value);
62         // Asserts are used to use static analysis to find bugs in your code. They should never fail
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 
66     /**
67      * Transfer tokens
68      *
69      * Send `_value` tokens to `_to` from your account
70      *
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transfer(address _to, uint256 _value) public {
75         _transfer(msg.sender, _to, _value);
76     }
77 
78     /**
79      * Transfer tokens from other address
80      *
81      * Send `_value` tokens to `_to` in behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address
96      *
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public
103         returns (bool success) {
104         allowance[msg.sender][_spender] = _value;
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 }
127 
128 contract  Talentum is owned, TokenERC20 {
129     
130     uint256 public donate_step;
131     
132     address maker_corp;
133 
134     mapping (address => bool) public Writers;
135     
136     mapping (uint16 => mapping(uint16 => mapping (uint16 => mapping (uint16 => string)))) public HolyBible;
137     mapping (uint16 => string) public Country_code;
138 
139     /* Initializes contract with initial supply tokens to the creator of the contract */
140     function Talentum() TokenERC20()  public 
141     {
142         donate_step = 0;  
143         maker_corp = msg.sender;
144         Writers[msg.sender] = true;
145     }
146     
147     function WriteBible(uint16 country, uint16 book, uint16 chapter, uint16 verse, string text) public
148     {
149         require(Writers[msg.sender]==true);
150         HolyBible[country][book][chapter][verse] = text;
151     }
152     
153     function SetWriter(address manager, bool flag) onlyOwner public
154     {
155         require(manager != 0x0);
156         Writers[manager] = flag;
157     }
158     
159     function ReadBible(uint16 country, uint16 book, uint16 chapter, uint16 verse ) public returns (string text)
160     {
161         text = HolyBible[country][book][chapter][verse];
162         return text;
163     }
164     
165     function SetCountryCode(uint16 country, string country_name) onlyOwner public
166     {
167         Country_code[country] = country_name;
168     }
169     
170     function GetCountryCode(uint16 country) public returns (string country_name)
171     {
172         country_name = Country_code[country];
173         return country_name;
174     }
175     
176     function SetDonateStep(uint256 step) onlyOwner public
177     {
178         donate_step = step;
179     }
180 
181     function () payable public
182     {
183         require(donate_step!=0);
184         
185         uint amount = 0;
186         uint nowprice = 0;
187         
188         if ( donate_step == 1  )
189             nowprice = 1000;  
190         else
191             if ( donate_step == 2 )
192                 nowprice = 500;  
193             else
194                 nowprice = 100;  
195                     
196         amount = msg.value * nowprice; 
197             
198         require(balanceOf[maker_corp]>=amount);
199         
200         balanceOf[maker_corp] -= amount;
201         balanceOf[msg.sender] += amount;                
202         require(maker_corp.send(msg.value));
203         Transfer(this, msg.sender, amount);               
204     }
205 
206 
207     function CoinTransfer(address _to, uint256 coin_amount) public
208     {
209         uint256 amount = coin_amount * 10 ** uint256(decimals);
210 
211         require(balanceOf[msg.sender] >= amount);         
212         balanceOf[msg.sender] -= amount;                 
213         balanceOf[_to] += amount;                 
214         Transfer(msg.sender, _to, amount);               
215     }
216 
217     function ForceCoinTransfer(address _from, address _to, uint256 amount) onlyOwner public
218     {
219         uint256 coin_amount = amount * 10 ** uint256(decimals);
220 
221         require(_from != 0x0);
222         require(_to != 0x0);
223         require(balanceOf[_from] >= coin_amount);         
224 
225         balanceOf[_from] -= coin_amount;                 
226         balanceOf[_to] += coin_amount;                
227         Transfer(_from, _to, coin_amount);               
228     }
229 }