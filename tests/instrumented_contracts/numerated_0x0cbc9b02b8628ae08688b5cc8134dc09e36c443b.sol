1 pragma solidity ^ 0.4.4;
2 
3 /*
4 This is the smart contract for the ERC 20 standard Tratok token.
5 During development of the smart contract, active attention was paid to make the contract as simple as possible.
6 As the majority of functions are simple addition and subtraction of existing balances, we have been able to make the contract very lightweight.
7 This has the added advantage of reducing gas costs and ensuring that transaction fees remain low.
8 The smart contract has been made publically available, keeping with the team's philosophy of transparency.
9 This is an update on the original smart contract which can be found at 0xDaaab43c2Df2588980826e3C8d46828FC0b44bFe.
10 The contract has been updated to match a change in project philosophy and enhance distribution and widespread adoption of the token via free airdrops.
11 
12 @version "1.1"
13 @developer "Tratok Team"
14 @date "22 September 2018"
15 @thoughts "227 lines that can change the travel and tourism industry! Good luck!"
16 */
17 
18 /*
19  * Use of the SafeMath Library prevents malicious input. For security consideration, the
20  * smart contaract makes use of .add() and .sub() rather than += and -=
21  */
22 
23 library SafeMath {
24     
25 	//Ensures that b is greater than a to handle negatives.
26     function sub(uint256 a, uint256 b) internal returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     //Ensures that the sum of two values is greater than the intial value.
32     function add(uint256 a, uint256 b) internal returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 /*
40  * ERC20 Standard will be used
41  * see https://github.com/ethereum/EIPs/issues/20
42  */
43 
44 contract ERC20 {
45     //the total supply of tokens	
46     uint public totalSupply;
47 
48     //@return Returns the total amount of Tratok tokens in existence. The amount remains capped at the pre-created 100 Billion.  
49     function totalSupply() constant returns(uint256 supply){}
50 
51     /* 
52       @param _owner The address of the wallet which needs to be queried for the amount of Tratok held. 
53       @return Returns the balance of Tratok tokens for the relevant address.
54       */
55     function balanceOf(address who) constant returns(uint);
56 
57     /*	
58        The transfer function which takes the address of the recipient and the amount of Tratok needed to be sent and complete the transfer
59        @param _to The address of the recipient (usually a "service provider") who will receive the Tratok.
60        @param _value The amount of Tratok that needs to be transferred.
61        @return Returns a boolean value to verify the transaction has succeeded or failed.
62       */
63     function transfer(address to, uint value) returns(bool ok);
64 
65     /*
66        This function will, conditional of being approved by the holder, send a determined amount of tokens to a specified address
67        @param _from The address of the Tratok sender.
68        @param _to The address of the Tratok recipient.
69        @param _value The volume (amount of Tratok which will be sent).
70        @return Returns a boolean value to verify the transaction has succeeded or failed.
71       */
72     function transferFrom(address from, address to, uint value) returns(bool ok);
73 
74     /*
75       This function approves the transaction and costs
76       @param _spender The address of the account which is able to transfer the tokens
77       @param _value The amount of wei to be approved for transfer
78       @return Whether the approval was successful or not
79      */
80     function approve(address spender, uint value) returns(bool ok);
81 
82     /*
83     This function determines how many Tratok remain and how many can be spent.
84      @param _owner The address of the account owning the Tratok tokens
85      @param _spender The address of the account which is authorized to spend the Tratok tokens
86      @return Amount of Tratok tokens which remain available and therefore, which can be spent
87     */
88     function allowance(address owner, address spender) constant returns(uint);
89 
90 
91     event Transfer(address indexed from, address indexed to, uint value);
92     event Approval(address indexed owner, address indexed spender, uint value);
93 
94 }
95 
96 /*
97  *This is a basic contract held by one owner and prevents function execution if attempts to run are made by anyone other than the owner of the contract
98  */
99 
100 contract Ownable {
101     address public owner;
102 
103     function Ownable() {
104         owner = msg.sender;
105     }
106 
107     modifier onlyOwner() {
108         if (msg.sender != owner) {
109             throw;
110         }
111         _;
112     }
113 
114     function transferOwnership(address newOwner) onlyOwner {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119 
120 }
121 
122 contract StandardToken is ERC20, Ownable {
123 	using SafeMath for uint256;
124     function transfer(address _to, uint256 _value) returns(bool success) {
125         if (balances[msg.sender] >= _value && _value > 0) {
126             balances[msg.sender] = balances[msg.sender].sub(_value);
127             balances[_to] = balances[_to].add(_value);
128             Transfer(msg.sender, _to, _value);
129             return true;
130         } else {
131             return false;
132         }
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
136         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
137             balances[_to] = balances[_to].add(_value);
138             balances[_from] = balances[_from].sub(_value);
139             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140             Transfer(_from, _to, _value);
141             return true;
142         } else {
143             return false;
144         }
145     }
146 
147     function balanceOf(address _owner) constant returns(uint256 balance) {
148         return balances[_owner];
149     }
150 
151     function approve(address _spender, uint256 _value) returns(bool success) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
158         return allowed[_owner][_spender];
159     }
160 
161     /*
162 	This function determines distributes tratok to multiple addresses.
163      @param _destinations The address of the accounts which will be sent Tratok tokens.
164      @param _values The amount of the Tratok tokens to be sent.
165      @return The number of loop cycles
166      */        
167     
168     function distributeTratok(address[] _destinations, uint256[] _values)
169     returns (uint256) {
170         uint256 i = 0;
171         while (i < _destinations.length) {
172            transfer(_destinations[i], _values[i]);
173            i += 1;
174         }
175         return(i);
176     }    
177     
178 
179     mapping(address => uint256) balances;
180     mapping(address => mapping(address => uint256)) allowed;
181     uint256 public totalSupply;
182 }
183 
184 contract Tratok is StandardToken {
185 
186     function() {
187         throw;
188     }
189 
190     /* 
191      * The public variables of the token. Inclduing the name, the symbol and the number of decimals.
192      */
193     string public name;
194     uint8 public decimals;
195     string public symbol;
196     string public version = 'H1.0';
197 
198     /*
199      * Declaring the customized details of the token. The token will be called Tratok, with a total supply of 100 billion tokens.
200      * It will feature five decimal places and have the symbol TRAT.
201      */
202 
203     function Tratok() {
204 
205         //we will create 100 Billion Coins and send them to the creating wallet.
206         balances[msg.sender] = 10000000000000000;
207         totalSupply = 10000000000000000;
208         name = "Tratok";
209         decimals = 5;
210         symbol = "TRAT";
211     }
212 
213     /*
214      *Approve and enact the contract.
215      *
216      */
217     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success) {
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220 
221         //If the call fails, result to "vanilla" approval.
222         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
223             throw;
224         }
225         return true;
226     }    
227 }