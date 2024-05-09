1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 interface token {
8     function transfer(address receiver, uint amount) public;
9 }
10 
11 contract TokenERC20 is token {
12     // Public variables of the token
13     string public name;
14     string public symbol;
15     uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
16     uint256 public totalSupply;
17 
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     // Notifies clients about token transfers
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     // Notifies clients about spending approval
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29 
30     /**
31      * Constructor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     function TokenERC20(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44     }
45 
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value);
54         // Check for overflows
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         // Save this for an assertion in the future
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
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
89         require(_value <= allowance[_from][msg.sender]);     // Check allowance
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
105         require(_spender != 0x0);
106         allowance[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address and notify
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      * @param _extraData some extra information to send to the approved contract
119      */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
121         public
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, this, _extraData);
126             return true;
127         }
128     }
129 }
130 
131 contract owned {
132     address public owner;
133 
134     function owned() public {
135         owner = msg.sender;
136     }
137 
138     modifier onlyOwner {
139         require(msg.sender == owner);
140         _;
141     }
142 
143     function transferOwnership(address newOwner) onlyOwner public {
144         owner = newOwner;
145     }
146 }
147 
148 
149 
150 
151 contract Presale is owned {
152     address public operations;
153 
154     TokenERC20 public myToken;
155     uint256 public distributionSupply;
156     uint256 public priceOfToken;
157     uint256 factor;
158     uint public startBlock;
159     uint public endBlock;
160 
161     uint256 defaultAuthorizedETH;
162     mapping (address => uint256) public authorizedETH;
163 
164     uint256 public distributionRealized;
165     mapping (address => uint256) public realizedETH;
166     mapping (address => uint256) public realizedTokenBalance;
167 
168     /**
169      * Constructor function
170      *
171      * Initializes the presale
172      *
173      */
174     function Presale() public {
175         operations = 0x249aAb680bAF7ed84e0ebE55cD078650A17162Ca;
176         myToken = TokenERC20(0xeaAa3585ffDCc973a22929D09179dC06D517b84d);
177         uint256 decimals = uint256(myToken.decimals());
178         distributionSupply = 10 ** decimals * 600000;
179         priceOfToken = 3980891719745222;
180         startBlock = 4909000;
181         endBlock   = 4966700;
182         defaultAuthorizedETH = 8 ether;
183         factor = 10 ** decimals * 3 / 2;
184     }
185 
186     modifier onlyOperations {
187         require(msg.sender == operations);
188         _;
189     }
190 
191     function transferOperationsFunction(address _operations) onlyOwner public {
192         operations = _operations;
193     }
194 
195     function authorizeAmount(address _account, uint32 _valueETH) onlyOperations public {
196         authorizedETH[_account] = uint256(_valueETH) * 1 ether;
197     }
198 
199     /**
200      * Fallback function
201      *
202      * The function without name is the default function that is called whenever anyone sends funds to a contract
203      */
204     function () payable public {
205         if (msg.sender != owner)
206         {
207             require(startBlock <= block.number && block.number <= endBlock);
208 
209             uint256 senderAuthorizedETH = authorizedETH[msg.sender];
210             uint256 effectiveAuthorizedETH = (senderAuthorizedETH > 0)? senderAuthorizedETH: defaultAuthorizedETH;
211             require(msg.value + realizedETH[msg.sender] <= effectiveAuthorizedETH);
212 
213             uint256 amountETH = msg.value;
214             uint256 amountToken = amountETH / priceOfToken * factor;
215             distributionRealized += amountToken;
216             realizedETH[msg.sender] += amountETH;
217             require(distributionRealized <= distributionSupply);
218 
219             if (senderAuthorizedETH > 0)
220             {
221                 myToken.transfer(msg.sender, amountToken);
222             }
223             else
224             {
225                 realizedTokenBalance[msg.sender] += amountToken;
226             }
227         }
228     }
229 
230     function transferBalance(address _account) onlyOperations public {
231         uint256 amountToken = realizedTokenBalance[_account];
232 	if (amountToken > 0)
233         {
234             realizedTokenBalance[_account] = 0;
235             myToken.transfer(_account, amountToken);
236         }
237     }
238 
239     function retrieveToken() onlyOwner public {
240         myToken.transfer(owner, myToken.balanceOf(this));
241     }
242 
243     function retrieveETH(uint256 _amount) onlyOwner public {
244         owner.transfer(_amount);
245     }
246 
247     function setBlocks(uint _startBlock, uint _endBlock) onlyOwner public {
248         require (_endBlock > _startBlock);
249         startBlock = _startBlock;
250         endBlock = _endBlock;
251     }
252 
253     function setPrice(uint256 _priceOfToken) onlyOwner public {
254         require (_priceOfToken > 0);
255         priceOfToken = _priceOfToken;
256     }
257 }