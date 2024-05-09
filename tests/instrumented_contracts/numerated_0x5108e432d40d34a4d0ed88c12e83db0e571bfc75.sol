1 pragma solidity ^0.4.4;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 
10  /**
11  * @dev Multiplies two numbers, throws on overflow.
12  */
13  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14    if (a == 0) {
15      return 0;
16    }
17    uint256 c = a * b;
18    assert(c / a == b);
19    return c;
20  }
21 
22  /**
23  * @dev Integer division of two numbers, truncating the quotient.
24  */
25  function div(uint256 a, uint256 b) internal pure returns (uint256) {
26    // assert(b > 0); // Solidity automatically throws when dividing by 0
27    uint256 c = a / b;
28    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29    return c;
30  }
31 
32  /**
33  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34  */
35  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36    assert(b <= a);
37    return a - b;
38  }
39 
40  /**
41  * @dev Adds two numbers, throws on overflow.
42  */
43  function add(uint256 a, uint256 b) internal pure returns (uint256) {
44    uint256 c = a + b;
45    assert(c >= a);
46    return c;
47  }
48 }
49 
50 
51 contract Token {
52 
53     /// @return total amount of tokens
54     function totalSupply() constant returns (uint256 supply) {}
55 
56     /// @param _owner The address from which the balance will be retrieved
57     /// @return The balance
58     function balanceOf(address _owner) constant returns (uint256 balance) {}
59 
60     /// @notice send `_value` token to `_to` from `msg.sender`
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transfer(address _to, uint256 _value) returns (bool success) {}
65 
66     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
67     /// @param _from The address of the sender
68     /// @param _to The address of the recipient
69     /// @param _value The amount of token to be transferred
70     /// @return Whether the transfer was successful or not
71     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
72 
73     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
74     /// @param _spender The address of the account able to transfer the tokens
75     /// @param _value The amount of wei to be approved for transfer
76     /// @return Whether the approval was successful or not
77     function approve(address _spender, uint256 _value) returns (bool success) {}
78 
79     /// @param _owner The address of the account owning tokens
80     /// @param _spender The address of the account able to transfer the tokens
81     /// @return Amount of remaining tokens allowed to spent
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 
87 }
88 
89 contract StandardToken is Token {
90 
91     function transfer(address _to, uint256 _value) returns (bool success) {
92         //Default assumes totalSupply can't be over max (2^256 - 1).
93         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
94         //Replace the if with this one instead.
95         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
96         if (balances[msg.sender] >= _value && _value > 0) {
97             balances[msg.sender] -= _value;
98             balances[_to] += _value;
99             Transfer(msg.sender, _to, _value);
100             return true;
101         } else { return false; }
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
105         //same as above. Replace this line with the following if you want to protect against wrapping uints.
106         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
107         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
108             balances[_to] += _value;
109             balances[_from] -= _value;
110             allowed[_from][msg.sender] -= _value;
111             Transfer(_from, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     function approve(address _spender, uint256 _value) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127       return allowed[_owner][_spender];
128     }
129 
130     mapping (address => uint256) balances;
131     mapping (address => mapping (address => uint256)) allowed;
132     uint256 public totalSupply;
133 }
134 
135 contract CrystalReignShard is StandardToken { // CHANGE THIS. Update the contract name.
136   using SafeMath for uint;
137     /* Public variables of the token */
138 
139     /*
140     NOTE:
141     The following variables are OPTIONAL vanities. One does not have to include them.
142     They allow one to customise the token contract & in no way influences the core functionality.
143     Some wallets/interfaces might not even bother to look at this information.
144     */
145     string public name;                   // Token Name
146     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
147     string public symbol;                 // An identifier: eg SBX, XPR etc..
148     string public version = 'H1.0';
149     uint256 public unitsOneEthCanBuy;
150     uint256 public preSalePrice;
151     uint256 public totalEthInWei;
152     address public fundsWallet;
153     address public dropWallet = 0x88d38F6cb2aF250Ab8f1FA24851ba312b0c48675;
154     address public compWallet = 0xCf794896c1788F799dc141015b3aAae0721e7c27;
155     address public marketingWallet = 0x49cc71a3a8c7D14Bf6a868717C81b248506402D8;
156     uint256 public bonusETH = 0;
157     uint256 public bonusCRS = 0;
158     uint public start = 1519477200;
159     uint public mintCount = 0;
160 
161     // This is a constructor function
162     // which means the following function name has to match the contract name declared above
163     function CrystalReignShard() {
164         balances[msg.sender] = 16400000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
165         balances[dropWallet] = 16400000000000000000000000;
166         balances[compWallet] = 16400000000000000000000000;
167         balances[marketingWallet] = 80000000000000000000000;
168         totalSupply = 50000000;                        // Update total supply (1000 for example) (CHANGE THIS)
169         name = "Crystal Reign Shard";                                   // Set the name for display purposes (CHANGE THIS)
170         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
171         symbol = "CRS";                                             // Set the symbol for display purposes (CHANGE THIS)
172         unitsOneEthCanBuy = 1000;                                      // Set the price of your token for the ICO (CHANGE THIS)
173         preSalePrice = 1300;
174         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
175     }
176 
177     function() payable{
178         totalEthInWei = totalEthInWei + msg.value;
179         uint256 amount = msg.value * unitsOneEthCanBuy;
180         if (now < 1524571200) {
181           amount = msg.value * preSalePrice;
182         }
183         if (balances[fundsWallet] < amount) {
184             msg.sender.transfer(msg.value);
185             return;
186         }
187 
188         balances[fundsWallet] = balances[fundsWallet] - amount;
189         balances[msg.sender] = balances[msg.sender] + amount;
190 
191         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
192 
193         //Transfer ether to fundsWallet
194         fundsWallet.transfer(msg.value);
195     }
196 
197     /* Approves and then calls the receiving contract */
198     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201 
202         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
203         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
204         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
205         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
206         return true;
207     }
208 
209     function mint(){
210       if (now >= start + (5 years * mintCount) && msg.sender == fundsWallet) {
211         balances[dropWallet] += 16400000;
212         mintCount++;
213         totalSupply += 16400000;
214       }
215     }
216 
217       function tileDrop(address[] winners) returns(bool success){
218       if(msg.sender == fundsWallet){
219         uint256 amount = 1000000000000000000000;
220         for(uint winList = 0; winList < winners.length; winList++){
221           winners[winList].transfer(bonusETH.div(64));
222           balances[winners[winList]] = balances[winners[winList]] + amount;
223           bonusETH -= bonusETH.div(64);
224             if (balances[dropWallet] >= amount) {
225             balances[dropWallet] = balances[dropWallet] - amount;
226             balances[winners[winList]] = balances[winners[winList]] + bonusCRS.div(64);
227             bonusCRS -= bonusCRS.div(64);
228               }
229 
230           Transfer(dropWallet, msg.sender, amount); // Broadcast a message to the blockchain
231         }
232 
233         balances[fundsWallet] = balances[fundsWallet] + bonusCRS;
234         bonusCRS = 0;
235 
236         Transfer(fundsWallet, msg.sender, bonusETH); // Broadcast a message to the blockchain
237         //Transfer ether to fundsWallet
238         fundsWallet.transfer(bonusETH);
239         bonusETH = 0;
240         return true;
241         }
242         else{
243         return false;
244         }
245         }
246 
247         function purchaseETH() payable returns(uint t){//
248           bonusETH +=  (msg.value.div(5)).mul(4);
249 
250 
251           Transfer(fundsWallet, msg.sender, (msg.value.div(5))); // Broadcast a message to the blockchain
252           fundsWallet.transfer(msg.value.div(5));
253           return block.timestamp;
254         }
255 
256         function purchaseCRS(uint256 amount) public returns(bool success){//
257           if(balances[msg.sender] >= amount){
258             balances[fundsWallet] = balances[fundsWallet] + amount.div(5);
259             bonusCRS += (amount.div(5)).mul(4);
260             balances[msg.sender] = balances[msg.sender] - amount;
261           }
262 
263 
264           //Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
265 
266           return true;
267           }
268 
269 
270 
271 
272 
273 }