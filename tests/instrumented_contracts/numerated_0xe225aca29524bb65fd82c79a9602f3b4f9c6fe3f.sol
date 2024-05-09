1 pragma solidity ^ 0.4.4;
2 
3 /*
4 This is the smart contract for the ERC 20 standard Tratok token.
5 During the development of the smart contract, active attention was paid to make the contract as simple as possible.
6 As the majority of functions are simple addition and subtraction of existing balances, we have been able to make the contract very lightweight.
7 This has the added advantage of reducing gas costs and ensuring that transaction fees remain low.
8 The smart contract has been made publically available, keeping with the team's philosophy of transparency.
9 This is an update on the second generation smart contract which can be found at 0x0cbc9b02b8628ae08688b5cc8134dc09e36c443b.
10 The contract has been updated to match a change in project philosophy and enhance distribution and widespread adoption of the token via free airdrops.
11 Further enhancements have been made for this third-generation:
12 A.) Enhanced anti-fraud measures.
13 B.) A Contingency plan to ensure that in the event of an exchange being compromised, that there is a facility to prevent the damage hurting the Tratok ecosystem.
14 C.) More efficient gas usage (e.g. Use of External instead of public).
15 
16 
17 @version "1.2"
18 @developer "Tratok Team"
19 @date "25 June 2019"
20 @thoughts "307 lines that will change the travel and tourism industry! Good luck!"
21 */
22 
23 /*
24  * Use of the SafeMath Library prevents malicious input. For security consideration, the
25  * smart contract makes use of .add() and .sub() rather than += and -=
26  */
27 
28 library SafeMath {
29     
30 //Ensures that b is greater than a to handle negatives.
31     function sub(uint256 a, uint256 b) internal returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     //Ensure that the sum of two values is greater than the initial value.
37     function add(uint256 a, uint256 b) internal returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 /*
45  * ERC20 Standard will be used
46  * see https://github.com/ethereum/EIPs/issues/20
47  */
48 
49 contract ERC20 {
50     //the total supply of tokens 
51     uint public totalSupply;
52 
53     //@return Returns the total amount of Tratok tokens in existence. The amount remains capped at the pre-created 100 Billion.  
54     function totalSupply() constant returns(uint256 supply){}
55 
56     /* 
57       @param _owner The address of the wallet which needs to be queried for the amount of Tratok held. 
58       @return Returns the balance of Tratok tokens for the relevant address.
59       */
60     function balanceOf(address who) constant returns(uint);
61 
62     /* 
63        The transfer function which takes the address of the recipient and the amount of Tratok needed to be sent and complete the transfer
64        @param _to The address of the recipient (usually a "service provider") who will receive the Tratok.
65        @param _value The amount of Tratok that needs to be transferred.
66        @return Returns a boolean value to verify the transaction has succeeded or failed.
67       */
68     function transfer(address to, uint value) returns(bool ok);
69 
70     /*
71        This function will, conditional of being approved by the holder, send a determined amount of tokens to a specified address
72        @param _from The address of the Tratok sender.
73        @param _to The address of the Tratok recipient.
74        @param _value The volume (amount of Tratok which will be sent).
75        @return Returns a boolean value to verify the transaction has succeeded or failed.
76       */
77     function transferFrom(address from, address to, uint value) returns(bool ok);
78 
79     /*
80       This function approves the transaction and costs
81       @param _spender The address of the account which is able to transfer the tokens
82       @param _value The amount of wei to be approved for transfer
83       @return Whether the approval was successful or not
84      */
85     function approve(address spender, uint value) returns(bool ok);
86 
87     /*
88     This function determines how many Tratok remain and how many can be spent.
89      @param _owner The address of the account owning the Tratok tokens
90      @param _spender The address of the account which is authorized to spend the Tratok tokens
91      @return Amount of Tratok tokens which remain available and therefore, which can be spent
92     */
93     function allowance(address owner, address spender) constant returns(uint);
94 
95 
96     event Transfer(address indexed from, address indexed to, uint value);
97     event Approval(address indexed owner, address indexed spender, uint value);
98 
99 }
100 
101 /*
102  *This is a basic contract held by one owner and prevents function execution if attempts to run are made by anyone other than the owner of the contract
103  */
104 
105 contract Ownable {
106     address public owner;
107 
108     function Ownable() {
109         owner = msg.sender;
110     }
111 
112     modifier onlyOwner() {
113         if (msg.sender != owner) {
114             revert();
115         }
116         _;
117     }
118 
119     function transferOwnership(address newOwner) onlyOwner {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124     
125     function owner() public view returns (address) {
126         return owner;
127     }
128 
129 }
130 
131 
132 contract StandardToken is ERC20, Ownable {
133 
134 event FrozenAccount(address indexed _target);
135 event UnfrozenAccount(address indexed _target);    
136 
137 using SafeMath for uint256;
138     function transfer(address _to, uint256 _value) returns(bool success) {
139         require(!frozenAccounts[msg.sender]);
140         if (balances[msg.sender] >= _value && _value > 0) {
141             balances[msg.sender] = balances[msg.sender].sub(_value);
142             balances[_to] = balances[_to].add(_value);
143             Transfer(msg.sender, _to, _value);
144             return true;
145         } else {
146             return false;
147         }
148     }
149 
150     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
151         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
152             balances[_to] = balances[_to].add(_value);
153             balances[_from] = balances[_from].sub(_value);
154             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155             Transfer(_from, _to, _value);
156             return true;
157         } else {
158             return false;
159         }
160     }
161      
162     function balanceOf(address _owner) constant returns(uint256 balance) {
163         return balances[_owner];
164     }
165 
166     function approve(address _spender, uint256 _value) returns(bool success) {
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
173         return allowed[_owner][_spender];
174     }
175     
176     
177      /*
178 This function determines distributes tratok to multiple addresses and is designed for the airdrop.
179      @param _destinations The address of the accounts which will be sent Tratok tokens.
180      @param _values The amount of the Tratok tokens to be sent.
181      @return The number of loop cycles
182      */        
183     
184     function airDropTratok(address[] _destinations, uint256[] _values) external onlyOwner
185     returns (uint256) {
186         uint256 i = 0;
187         while (i < _destinations.length) {
188            transfer(_destinations[i], _values[i]);
189            i += 1;
190         }
191         return(i);
192     }
193 
194     /*
195 This function determines distributes tratok to multiple addresses and is designed for the ecosystem. It is the same as the airDropTratok method but differs in that it can be run by all accounts, not just the Owner account.
196 
197      @param _destinations The address of the accounts which will be sent Tratok tokens.
198      @param _values The amount of the Tratok tokens to be sent.
199      @return The number of loop cycles
200      */        
201     
202     function distributeTratok(address[] _destinations, uint256[] _values)
203     returns (uint256) {
204         uint256 i = 0;
205         while (i < _destinations.length) {
206            transfer(_destinations[i], _values[i]);
207            i += 1;
208         }
209         return(i);
210     }
211     
212        /*
213 This function locks the account  from sending Tratok. This measure is taken to prevent fraud and to recover Tratok in the event that an exchange is hacked.
214      @param _target The address of the accounts which will be locked.
215      @return The number of loop cycles
216      */    
217      
218    function lockAccountFromSendingTratok(address _target) external onlyOwner returns(bool){
219    
220    	//Ensure that the target address is not left blank to prevent errors.
221    	  require(_target != address(0));
222 	//ensure the account is not already frozen.	  
223       require(!frozenAccounts[_target]);
224       frozenAccounts[_target] = true;
225       emit FrozenAccount(_target);
226       return true;
227   }
228     
229     /*
230 This function unlocks accounts tratok to allow them to send Tratok.
231      @param _target The address of the accounts which will be sent Tratok tokens.
232      @return The number of loop cycles
233      */    
234       function unlockAccountFromSendingTratok(address _target) external onlyOwner returns(bool){
235       require(_target != address(0));
236       require(frozenAccounts[_target]);
237       delete frozenAccounts[_target];
238       emit UnfrozenAccount(_target);
239       return true;
240   }
241      
242     /*
243 This function is an emergency failsafe that allows Tratok to be reclaimed in the event of an exchange or partner hack. This contingency is meant as a last resort to protect the integrity of the ecosystem in the event of a security breach. It can only be executed by the holder of the custodian keys.
244      @param _from The address of the Tratok tokens will be seized.
245 	 @param _to The address where the Tratok tokens will be sent.
246      @param _value The amount of Tratok tokens that will be transferred.
247      */    
248        
249      function confiscate(address _from, address _to, uint256 _value) external onlyOwner{
250      	balances[_to] = balances[_to].add(_value);
251         balances[_from] = balances[_from].sub(_value);
252         return (Transfer(_from, _to, _value));
253 }     
254     
255 
256     mapping(address => uint256) balances;
257     mapping(address => mapping(address => uint256)) allowed;
258     mapping(address => bool) internal frozenAccounts;
259     
260     uint256 public totalSupply;
261 }
262 
263 contract Tratok is StandardToken {
264 
265     function() {
266         revert();
267         
268     }
269 
270     /* 
271      * The public variables of the token. Including the name, the symbol and the number of decimals.
272      */
273     string public name;
274     uint8 public decimals;
275     string public symbol;
276     string public version = 'H1.0';
277 
278     /*
279      * Declaring the customized details of the token. The token will be called Tratok, with a total supply of 100 billion tokens.
280      * It will feature five decimal places and have the symbol TRAT.
281      */
282 
283     function Tratok() {
284 
285         //we will create 100 Billion utility tokens and send them to the creating wallet.
286         balances[msg.sender] = 10000000000000000;
287         totalSupply = 10000000000000000;
288         name = "Tratok";
289         decimals = 5;
290         symbol = "TRAT";
291     }
292 
293     /*
294      *Approve and enact the contract.
295      *
296      */
297     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success) {
298         allowed[msg.sender][_spender] = _value;
299         Approval(msg.sender, _spender, _value);
300 
301         //If the call fails, result to "vanilla" approval.
302         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
303             revert();
304         }
305         return true;
306     }
307 }