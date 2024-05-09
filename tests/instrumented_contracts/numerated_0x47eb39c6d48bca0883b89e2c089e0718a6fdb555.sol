1 pragma solidity 0.4.13;
2 
3 
4 contract ERC20Abstract {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46 
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract ERC20Contract is ERC20Abstract {
52 
53     mapping (address => uint256) public balances;
54 
55     mapping (address => mapping (address => uint256)) allowed;
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }
70 }
71 
72 
73 contract ForeignToken {
74     function balanceOf(address _owner) constant returns (uint256);
75 
76     function transfer(address _to, uint256 _value) returns (bool);
77 }
78 
79 contract NeymarTokenEvents {
80     event NeymarHasMintedEvent(uint256 _value);
81     event UserClaimedTokens(address _address, uint256 _tokens);
82 }
83 
84 contract NeymarToken is ERC20Contract, NeymarTokenEvents {
85   
86     address public owner = msg.sender;
87 
88     string public name = "Neymar Token";
89 
90     string public symbol = "NT";
91 
92     uint256 public decimals = 18;
93 
94     uint256 private ethDecimals = 18;
95 
96     // Neymar specific variables
97     uint256[] public tokenMinted;
98 
99     uint256[] private totalSupplies;
100 
101     mapping (address => uint256) private positions;
102     //===========================
103 
104     // ICO Variables
105     bool public purchasingAllowed = true;
106 
107     uint256 public totalContribution = 0;
108 
109     uint256 public totalETHLimit = 400;
110 
111     uint256 public totalTokenDistribution = 222000000;
112 
113     uint256 public ethTokenRatio = totalTokenDistribution / totalETHLimit;
114 
115     uint256 public icoETHContributionLimit = totalETHLimit * 10 ** 18;
116     // ==========================
117 
118     function() payable { 
119         uint256 ethValue = msg.value;
120         address _address = msg.sender;
121         if (!purchasingAllowed) {revert();}
122         if (ethValue == 0) {return;}
123         claimTokensFor(_address);
124         totalContribution += ethValue;
125 
126         uint256 digitsRatio = decimals - ethDecimals;
127         uint256 tokensIssued = (ethValue * 10 ** digitsRatio * ethTokenRatio);
128 
129         totalSupply += tokensIssued;
130         balances[_address] += tokensIssued;
131         Transfer(address(this), _address, tokensIssued);
132 
133         if (totalContribution >= icoETHContributionLimit) {
134             purchasingAllowed = false;
135         }
136      }
137 
138     function neymarHasMinted(uint256 tokensNumber) public returns (bool) {
139         if (msg.sender != owner) {revert();}
140         NeymarHasMintedEvent(tokensNumber);
141         tokensNumber = tokensNumber * 10 ** decimals;
142         tokenMinted.push(tokensNumber);
143         totalSupplies.push(totalSupply);
144         totalSupply += tokensNumber;
145         return true;
146     }
147 
148     function getVirtualBalance(address _address) public constant returns (uint256 virtualBalance){
149         return howManyTokensAreReservedFor(_address) + balanceOf(_address);
150     }
151         
152     function howManyTokensAreReservedForMe() public constant returns (uint256 tokenCount) {
153         return howManyTokensAreReservedFor(msg.sender);
154     }
155 
156     function howManyTokensAreReservedFor(address _address) public constant returns (uint256 tokenCount) {
157         uint256 currentTokenNumbers = balances[_address];
158         if (currentTokenNumbers == 0) {
159             return 0;
160         }
161         
162         uint256 neymarGoals = tokenMinted.length;
163         uint256 currentPosition = positions[_address];
164         uint256 tokenMintedAt = 0;
165         uint256 totalSupplyAt = 0;
166         uint256 tokensWon = 0;
167 
168         while (currentPosition < neymarGoals) {
169             tokenMintedAt = tokenMinted[currentPosition];
170             totalSupplyAt = totalSupplies[currentPosition];
171             tokensWon = tokenMintedAt * currentTokenNumbers / totalSupplyAt;
172             currentTokenNumbers += tokensWon;
173             currentPosition += 1;
174         }
175         return currentTokenNumbers - balances[_address];
176     }
177 
178     function claimMyTokens() public returns (bool success) {
179         return claimTokensFor(msg.sender);
180     }
181 
182     function claimTokensFor(address _address) private returns (bool success) {
183         uint256 currentTokenNumbers = balances[_address];
184         uint256 neymarGoals = tokenMinted.length;
185         if (currentTokenNumbers == 0) {
186             balances[_address] = 0;
187             positions[_address] = neymarGoals;
188             return true;
189         }
190         uint256 tokens = howManyTokensAreReservedFor(_address);
191         balances[_address] += tokens;
192         positions[_address] = neymarGoals;
193         UserClaimedTokens(_address, tokens);       
194         return true;
195     }
196 
197     function transfer(address _to, uint256 _value) public returns (bool success) {
198         if (msg.data.length < (2 * 32) + 4) {revert();}
199         claimTokensFor(msg.sender);
200         claimTokensFor(_to);
201         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
202             balances[msg.sender] -= _value;
203             balances[_to] += _value;
204             Transfer(msg.sender, _to, _value);
205             return true;
206         } else {
207             return false;
208         }
209     }
210 
211     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
212         if (msg.data.length < (3 * 32) + 4) {revert();}
213         claimTokensFor(_from);
214         claimTokensFor(_to);
215         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
216             balances[_to] += _value;
217             balances[_from] -= _value;
218             allowed[_from][msg.sender] -= _value;
219             Transfer(_from, _to, _value);
220             return true;
221         } else {
222             return false;
223         }
224     }
225 
226     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
227         if (msg.sender != owner) {revert();}
228 
229         ForeignToken token = ForeignToken(_tokenContract);
230 
231         uint256 amount = token.balanceOf(address(this));
232         return token.transfer(owner, amount);
233     }
234 
235     function getReadableStats() public constant returns (uint256, uint256, bool) {
236         return (totalContribution / 10 ** decimals, totalSupply / 10 ** decimals, purchasingAllowed);
237     }
238 
239     function getReadableSupply() public constant returns (uint256) {
240         return totalSupply / 10 ** decimals;
241     }
242 
243     function getReadableContribution() public constant returns (uint256) {
244         return totalContribution / 10 ** decimals;
245     }
246 
247     function getTotalGoals() public constant returns (uint256) {
248         return totalSupplies.length;
249     }
250 
251     function getETH() public {
252         if (msg.sender != owner) {revert();}
253         owner.transfer(this.balance);
254     }
255 }