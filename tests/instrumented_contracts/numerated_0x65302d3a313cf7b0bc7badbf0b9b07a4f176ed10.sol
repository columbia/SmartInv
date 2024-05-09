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
92         if (balances[msg.sender] >= _value && _value > 0) {
93             balances[msg.sender] -= _value;
94             balances[_to] += _value;
95             Transfer(msg.sender, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
102             balances[_to] += _value;
103             balances[_from] -= _value;
104             allowed[_from][msg.sender] -= _value;
105             Transfer(_from, _to, _value);
106             return true;
107         } else { return false; }
108     }
109 
110     function balanceOf(address _owner) constant returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114     function approve(address _spender, uint256 _value) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121       return allowed[_owner][_spender];
122     }
123 
124     mapping (address => uint256) balances;
125     mapping (address => mapping (address => uint256)) allowed;
126     uint256 public totalSupply;
127 }
128 
129 contract CrystalReignShard is StandardToken {
130   using SafeMath for uint;
131 
132     string public name; 
133     uint8 public decimals;            
134     string public symbol; 
135     string public version = 'H1.0';
136     uint256 public unitsOneEthCanBuy;
137     uint256 public preSalePrice;
138     uint256 public preAlphaPrice;
139     uint256 public totalEthInWei;
140     address public fundsWallet;
141     address public dropWallet = 0x88d38F6cb2aF250Ab8f1FA24851ba312b0c48675;
142     address public compWallet = 0xCf794896c1788F799dc141015b3aAae0721e7c27;
143     address public marketingWallet = 0x49cc71a3a8c7D14Bf6a868717C81b248506402D8;
144     uint256 public bonusETH = 0;
145     uint256 public bonusCRS = 0;
146     uint public start = 1519477200;
147     uint public mintCount = 0;
148 
149 
150     function CrystalReignShard() {
151         balances[msg.sender] = 16400000000000000000000000;
152         balances[dropWallet] = 16400000000000000000000000;
153         balances[compWallet] = 16400000000000000000000000;
154         balances[marketingWallet] = 80000000000000000000000;
155         totalSupply = 50000000000000000000000000;                        
156         name = "Crystal Reign Shard";                                  
157         decimals = 18;                                              
158         symbol = "CRS";                                           
159         unitsOneEthCanBuy = 1000;                                      
160         preSalePrice = 2000;
161         preAlphaPrice = 1300;
162         fundsWallet = msg.sender;                         
163     }
164 
165     function() payable{
166         totalEthInWei = totalEthInWei + msg.value;
167         uint256 amount = msg.value * unitsOneEthCanBuy;
168         if (now < 1521028800){
169             amount = msg.value * preSalePrice;
170         }
171         else if (now < 1524571200) {
172           amount = msg.value * preAlphaPrice;
173         }
174         if (balances[fundsWallet] < amount) {
175             msg.sender.transfer(msg.value);
176             return;
177         }
178 
179         balances[fundsWallet] = balances[fundsWallet] - amount;
180         balances[msg.sender] = balances[msg.sender] + amount;
181 
182         Transfer(fundsWallet, msg.sender, amount);
183 
184         fundsWallet.transfer(msg.value);
185     }
186 
187     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
188         allowed[msg.sender][_spender] = _value;
189         Approval(msg.sender, _spender, _value);
190         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
191         return true;
192     }
193 
194     function mint(){
195       if (now >= start + (5 years * mintCount) && msg.sender == fundsWallet) {
196         balances[dropWallet] += 16400000000000000000000000;
197         mintCount++;
198         totalSupply += 16400000000000000000000000;
199       }
200     }
201 
202       function tileDrop(address[] winners) returns(bool success){
203       if(msg.sender == fundsWallet){
204         uint256 amount = 1000000000000000000000;
205         for(uint winList = 0; winList < winners.length; winList++){
206           winners[winList].transfer(bonusETH.div(64));
207           balances[winners[winList]] = balances[winners[winList]] + amount;
208           bonusETH -= bonusETH.div(64);
209             if (balances[dropWallet] >= amount) {
210             balances[dropWallet] = balances[dropWallet] - amount;
211             balances[winners[winList]] = balances[winners[winList]] + bonusCRS.div(64);
212             bonusCRS -= bonusCRS.div(64);
213               }
214 
215           Transfer(dropWallet, msg.sender, amount); // Broadcast a message to the blockchain
216         }
217 
218         balances[fundsWallet] = balances[fundsWallet] + bonusCRS;
219         bonusCRS = 0;
220         Transfer(fundsWallet, msg.sender, bonusETH); // Broadcast a message to the blockchain
221         fundsWallet.transfer(bonusETH);
222         bonusETH = 0;
223         return true;
224         }
225         else{
226         return false;
227         }
228         }
229 
230         function purchaseETH() payable returns(bool success){
231           bonusETH +=  (msg.value.div(5)).mul(4);
232           Transfer(fundsWallet, msg.sender, (msg.value.div(5)));
233           fundsWallet.transfer(msg.value.div(5));
234           return true;
235         }
236 
237         function purchaseCRS(uint256 amount) public returns(bool success){//
238           if(balances[msg.sender] >= amount){
239             balances[fundsWallet] = balances[fundsWallet] + amount.div(5);
240             bonusCRS += (amount.div(5)).mul(4);
241             balances[msg.sender] = balances[msg.sender] - amount;
242           }
243 
244           return true;
245           }
246 
247 
248 
249 
250 
251 }