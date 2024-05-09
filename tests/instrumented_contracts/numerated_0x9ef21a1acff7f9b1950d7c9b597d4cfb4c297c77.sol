1 pragma solidity ^0.4.11;
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
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract doccoin is owned {
23     // Public variables of the token
24     string public name = "DocCoin";
25     string public symbol = "Doc";
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply = 200000000000000000000000000;
29     address public crowdsaleContract;
30 
31     uint sendingBanPeriod = 1520726400;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42     
43     modifier canSend() {
44         require ( msg.sender == owner ||  now > sendingBanPeriod || msg.sender == crowdsaleContract);
45         _;
46     }
47     
48     /**
49      * Constrctor function
50      */
51     function doccoin(
52     ) public {
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54     }
55     
56     function setCrowdsaleContract(address contractAddress) onlyOwner {
57         crowdsaleContract = contractAddress;
58     }
59      
60     /// @notice Create `mintedAmount` tokens and send it to `target`
61     /// @param target Address to receive the tokens
62     /// @param mintedAmount the amount of tokens it will receive
63     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
64         balanceOf[target] += mintedAmount;
65         totalSupply += mintedAmount;
66         Transfer(0, this, mintedAmount);
67         Transfer(this, target, mintedAmount);
68     }
69 
70     /**
71      * Internal transfer, only can be called by this contract
72      */
73     function _transfer(address _from, address _to, uint _value) internal {
74         // Prevent transfer to 0x0 address. Use burn() instead
75         require(_to != 0x0);
76         // Check if the sender has enough
77         require(balanceOf[_from] >= _value);
78         // Check for overflows
79         require(balanceOf[_to] + _value > balanceOf[_to]);
80         // Save this for an assertion in the future
81         uint previousBalances = balanceOf[_from] + balanceOf[_to];
82         // Subtract from the sender
83         balanceOf[_from] -= _value;
84         // Add the same to the recipient
85         balanceOf[_to] += _value;
86         Transfer(_from, _to, _value);
87         // Asserts are used to use static analysis to find bugs in your code. They should never fail
88         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89     }
90 
91     /**
92      * Transfer tokens
93      *
94      * Send `_value` tokens to `_to` from your account
95      *
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transfer(address _to, uint256 _value) public canSend {
100         _transfer(msg.sender, _to, _value);
101     }
102 
103     /**
104      * Transfer tokens from other address
105      *
106      * Send `_value` tokens to `_to` in behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public canSend returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address
121      *
122      * Allows `_spender` to spend no more than `_value` tokens in your behalf
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      */
127     function approve(address _spender, uint256 _value) public
128         returns (bool success) {
129         allowance[msg.sender][_spender] = _value;
130         return true;
131     }
132 
133     /**
134      * Set allowance for other address and notify
135      *
136      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      * @param _extraData some extra information to send to the approved contract
141      */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
143         public
144         returns (bool success) {
145         tokenRecipient spender = tokenRecipient(_spender);
146         if (approve(_spender, _value)) {
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150     }
151 
152     /**
153      * Destroy tokens
154      *
155      * Remove `_value` tokens from the system irreversibly
156      *
157      * @param _value the amount of money to burn
158      */
159     function burn(uint256 _value) public returns (bool success) {
160         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
161         balanceOf[msg.sender] -= _value;            // Subtract from the sender
162         totalSupply -= _value;                      // Updates totalSupply
163         Burn(msg.sender, _value);
164         return true;
165     }
166 
167     /**
168      * Destroy tokens from other account
169      *
170      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
171      *
172      * @param _from the address of the sender
173      * @param _value the amount of money to burn
174      */
175     function burnFrom(address _from, uint256 _value) public returns (bool success) {
176         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
177         require(_value <= allowance[_from][msg.sender]);    // Check allowance
178         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
179         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
180         totalSupply -= _value;                              // Update totalSupply
181         Burn(_from, _value);
182         return true;
183     }
184 }
185 
186 
187 contract DoccoinPreICO is owned {
188     
189     address public wallet1 = address(0x0028D118C0c892e5afaF6C10d79D3922bC76840B);
190     address public wallet2 = address(0xd7df9e4f97a7bdbff9799e29b9689515af2da3a6);
191     
192     uint public fundingGoal;
193     uint public amountRaised;
194     uint public beginTime = 1516838400;
195     uint public endTime = 1517529600;
196     uint public price = 100 szabo;
197     doccoin public tokenReward;
198 
199     event FundTransfer(address backer, uint amount, bool isContribution);
200 
201     /**
202      * Constrctor function
203      *
204      * Setup the owner
205      */
206     function DoccoinPreICO(
207         doccoin addressOfTokenUsedAsReward
208     ) {
209         tokenReward = addressOfTokenUsedAsReward;
210     }
211     
212     // withdraw tokens from contract
213     function withdrawTokens() onlyOwner {
214         tokenReward.transfer(msg.sender, tokenReward.balanceOf(this));
215         FundTransfer(msg.sender, tokenReward.balanceOf(this), false);
216     }
217     
218     // low level token purchase function
219     function buyTokens(address beneficiary) payable {
220         require(msg.value >= 200 finney);
221         uint amount = msg.value;
222         amountRaised += amount;
223         tokenReward.transfer(beneficiary, amount*1000000000000000000/price);
224         FundTransfer(beneficiary, amount, true);
225         wallet1.transfer(msg.value*90/100);
226         wallet2.transfer(msg.value*10/100);
227         
228     }
229 
230     /**
231      * Fallback function
232      *
233      * The function without name is the default function that is called whenever anyone sends funds to a contract
234      */
235     function () payable onlyCrowdsalePeriod {
236         buyTokens(msg.sender);
237     }
238 
239     modifier onlyCrowdsalePeriod() { 
240         require ( now >= beginTime && now <= endTime ) ;
241         _; 
242     }
243 
244     
245 
246 }