1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract Token {
23     /// @return total amount of tokens
24     function totalSupply() public constant returns (uint256 supply) {}
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) public constant returns (uint256 balance) {}
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value) public returns (bool success) {}
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
42 
43     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of wei to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) public returns (bool success) {}
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 
57     event Burn(address indexed from, uint256 value);
58 }
59 
60 
61 contract StandardToken is Token, SafeMath {
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 
66     function transfer(address to, uint tokens) public returns (bool success) {
67         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
68         balances[to] = safeAdd(balances[to], tokens);
69 
70         emit Transfer(msg.sender, to, tokens);
71 
72         return true;
73     }
74 
75     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
76         balances[from] = safeSub(balances[from], tokens);
77         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
78         balances[to] = safeAdd(balances[to], tokens);
79 
80         emit Transfer(from, to, tokens);
81 
82         return true;
83     }
84 
85     function balanceOf(address tokenOwner) public constant returns (uint balance) {
86         return balances[tokenOwner];
87     }
88 
89     function approve(address spender, uint tokens) public returns (bool success) {
90         allowed[msg.sender][spender] = tokens;
91 
92         emit Approval(msg.sender, spender, tokens);
93 
94         return true;
95     }
96 
97     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
98         return allowed[tokenOwner][spender];
99     }
100 
101 
102     function burn(uint256 _value) public returns (bool success) {
103         require(balances[msg.sender] >= _value);                         // Check if the sender has enough
104         balances[msg.sender] = safeSub(balances[msg.sender], _value);    // Subtract from the sender
105         totalSupply = safeSub(totalSupply,_value);                       // Updates totalSupply
106 
107         emit Burn(msg.sender, _value);
108 
109         return true;
110     }
111 
112     /**
113      * Destroy tokens from other account
114      *
115      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
116      *
117      * @param _from the address of the sender
118      * @param _value the amount of money to burn
119      */
120     function burnFrom(address _from, uint256 _value) public returns (bool success) {
121         require(balances[_from] >= _value);                                        // Check if the targeted balance is enough
122         require(_value <= allowed[_from][msg.sender]);                             // Check allowance
123         balances[_from] = safeSub(balances[_from],_value);                         // Subtract from the targeted balance
124         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);   // Subtract from the sender's allowance
125         totalSupply = safeSub(totalSupply,_value);                                 // Update totalSupply
126         emit    Burn(_from, _value);
127         return true;
128     }
129 }
130 
131 contract CryptonCoin is StandardToken {
132     string public name;
133     uint8 public decimals;
134     string public symbol;
135     string public version = 'H1.0';
136     address public fundsWallet;
137     address public contractAddress;
138 
139     uint256 public preIcoSupply;
140     uint256 public preIcoTotalSupply;
141 
142     uint256 public IcoSupply;
143     uint256 public IcoTotalSupply;
144 
145     uint256 public maxSupply;
146     uint256 public totalSupply;
147 
148     uint256 public unitsOneEthCanBuy;
149     uint256 public totalEthInWei;
150 
151     bool public ico_finish;
152     bool public token_was_created;
153 
154     uint256 public preIcoFinishTimestamp;
155     uint256 public fundingEndTime;
156     uint256 public finalTokensIssueTime;
157 
158     function CryptonCoin() public {
159         fundsWallet = msg.sender;
160 
161         name = "CRYPTON";
162         symbol = "CRN";
163         decimals = 18;
164 
165         balances[fundsWallet] = 0;
166         totalSupply       = 0;
167         preIcoTotalSupply = 14400000000000000000000000;
168         IcoTotalSupply    = 36000000000000000000000000;
169         maxSupply         = 72000000000000000000000000;
170         unitsOneEthCanBuy = 377;
171 
172         preIcoFinishTimestamp = 1524785992; // Thu Apr 26 23:39:52 UTC 2018
173         fundingEndTime        = 1528587592; // Sat Jun  9 23:39:52 UTC 2018
174         finalTokensIssueTime  = 1577921992; // Wed Jan  1 23:39:52 UTC 2020
175 
176         contractAddress = address(this);
177     }
178 
179     function() public payable {
180         require(!ico_finish);
181         require(block.timestamp < fundingEndTime);
182         require(msg.value != 0);
183 
184         totalEthInWei = totalEthInWei + msg.value;
185         uint256  amount = 0;
186         uint256 tokenPrice = unitsOneEthCanBuy;
187 
188         if (block.timestamp < preIcoFinishTimestamp) {
189             require(msg.value * tokenPrice * 13 / 10 <= (preIcoTotalSupply - preIcoSupply));
190 
191             tokenPrice = safeMul(tokenPrice,13);
192             tokenPrice = safeDiv(tokenPrice,10);
193 
194             amount = safeMul(msg.value,tokenPrice);
195             preIcoSupply = safeAdd(preIcoSupply,amount);
196 
197             balances[msg.sender] = safeAdd(balances[msg.sender],amount);
198             totalSupply = safeAdd(totalSupply,amount);
199 
200             emit Transfer(contractAddress, msg.sender, amount);
201         } else {
202             require(msg.value * tokenPrice <= (IcoTotalSupply - IcoSupply));
203 
204             amount = safeMul(msg.value,tokenPrice);
205             IcoSupply = safeAdd(IcoSupply,amount);
206             balances[msg.sender] = safeAdd(balances[msg.sender],amount);
207             totalSupply = safeAdd(totalSupply,amount);
208 
209             emit Transfer(contractAddress, msg.sender, amount);
210         }
211     }
212 
213     function withdraw() public {
214             require(msg.sender == fundsWallet);
215             fundsWallet.transfer(contractAddress.balance);
216 
217     }
218 
219     function createTokensForCrypton() public returns (bool success) {
220         require(ico_finish);
221         require(!token_was_created);
222 
223         if (block.timestamp > finalTokensIssueTime) {
224             uint256 amount = safeAdd(preIcoSupply, IcoSupply);
225             amount = safeMul(amount,3);
226             amount = safeDiv(amount,10);
227 
228             balances[fundsWallet] = safeAdd(balances[fundsWallet],amount);
229             totalSupply = safeAdd(totalSupply,amount);
230             emit Transfer(contractAddress, fundsWallet, amount);
231             token_was_created = true;
232             return true;
233         }
234     }
235 
236     function stopIco() public returns (bool success) {
237         if (block.timestamp > fundingEndTime) {
238             ico_finish = true;
239             return true;
240         }
241     }
242 
243     function setTokenPrice(uint256 _value) public returns (bool success) {
244         require(msg.sender == fundsWallet);
245         require(_value < 1500);
246         unitsOneEthCanBuy = _value;
247         return true;
248     }
249 }
250 //Based on the source from hashnode.com
251 //CREATED BY MICHAŁ MICHALSKI @YSZTY with CRYPTON.VC