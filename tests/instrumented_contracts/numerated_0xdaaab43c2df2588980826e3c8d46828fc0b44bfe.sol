1 pragma solidity ^ 0.4 .4;
2 
3 /*
4 This is the smart contract for the ERC 20 standard Tratok token.
5 During development of the smart contract, active attention was paid to make the contract as simple as possible.
6 As the majority of functions are simple addition and subtraction of existing balances, we have been able to make the contract very lightweight.
7 This has the added advantage of reducing gas costs and ensuring that transaction fees remain low.
8 The smart contract has been made publically available, keeping with the team's philosophy of transparency.
9 
10 @version "1.0"
11 @developer "Tratok Team"
12 @date "12 February 2017"
13 @thoughts "207 lines that can change the travel and tourism industry!. Good luck!"
14 */
15 
16 /*
17  * Use of the SafeMath Library prevents malicious input. For security consideration, the
18  * smart contaract makes use of .add() and .sub() rather than += and -=
19  */
20 
21 library SafeMath {
22     
23 	//Ensures that b is greater than a to handle negatives.
24     function sub(uint256 a, uint256 b) internal returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     //Ensures that the sum of two values is greater than the intial value.
30     function add(uint256 a, uint256 b) internal returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 /*
38  * ERC20 Standard will be used
39  * see https://github.com/ethereum/EIPs/issues/20
40  */
41 
42 contract ERC20 {
43     //the total supply of tokens	
44     uint public totalSupply;
45 
46     //@return Returns the total amount of Tratok tokens in existence. The amount remains capped at the pre-created 100 Billion.  
47     function totalSupply() constant returns(uint256 supply){}
48 
49     /* 
50       @param _owner The address of the wallet which needs to be queried for the amount of Tratok held. 
51       @return Returns the balance of Tratok tokens for the relevant address.
52       */
53     function balanceOf(address who) constant returns(uint);
54 
55     /*	
56        The transfer function which takes the address of the recipient and the amount of Tratok needed to be sent and complete the transfer
57        @param _to The address of the recipient (usually a "service provider") who will receive the Tratok.
58        @param _value The amount of Tratok that needs to be transferred.
59        @return Returns a boolean value to verify the transaction has succeeded or failed.
60       */
61     function transfer(address to, uint value) returns(bool ok);
62 
63     /*
64        This function will, conditional of being approved by the holder, send a determined amount of tokens to a specified address
65        @param _from The address of the Tratok sender.
66        @param _to The address of the Tratok recipient.
67        @param _value The volume (amount of Tratok which will be sent).
68        @return Returns a boolean value to verify the transaction has succeeded or failed.
69       */
70     function transferFrom(address from, address to, uint value) returns(bool ok);
71 
72     /*
73       This function approves the transaction and costs
74       @param _spender The address of the account which is able to transfer the tokens
75       @param _value The amount of wei to be approved for transfer
76       @return Whether the approval was successful or not
77      */
78     function approve(address spender, uint value) returns(bool ok);
79 
80     /*
81     This function determines how many Tratok remain and how many can be spent.
82      @param _owner The address of the account owning the Tratok tokens
83      @param _spender The address of the account which is authorized to spend the Tratok tokens
84      @return Amount of Tratok tokens which remain available and therefore, which can be spent
85     */
86     function allowance(address owner, address spender) constant returns(uint);
87 
88 
89     event Transfer(address indexed from, address indexed to, uint value);
90     event Approval(address indexed owner, address indexed spender, uint value);
91 
92 }
93 
94 /*
95  *This is a basic contract held by one owner and prevents function execution if attempts to run are made by anyone other than the owner of the contract
96  */
97 
98 contract Ownable {
99     address public owner;
100 
101     function Ownable() {
102         owner = msg.sender;
103     }
104 
105     modifier onlyOwner() {
106         if (msg.sender != owner) {
107             throw;
108         }
109         _;
110     }
111 
112     function transferOwnership(address newOwner) onlyOwner {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117 
118 }
119 
120 contract StandardToken is ERC20, Ownable {
121 	using SafeMath for uint256;
122     function transfer(address _to, uint256 _value) returns(bool success) {
123         if (balances[msg.sender] >= _value && _value > 0) {
124             balances[msg.sender] = balances[msg.sender].sub(_value);
125             balances[_to] = balances[_to].add(_value);
126             Transfer(msg.sender, _to, _value);
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
134         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
135             balances[_to] = balances[_to].add(_value);
136             balances[_from] = balances[_from].sub(_value);
137             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138             Transfer(_from, _to, _value);
139             return true;
140         } else {
141             return false;
142         }
143     }
144 
145     function balanceOf(address _owner) constant returns(uint256 balance) {
146         return balances[_owner];
147     }
148 
149     function approve(address _spender, uint256 _value) returns(bool success) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
156         return allowed[_owner][_spender];
157     }
158 
159     mapping(address => uint256) balances;
160     mapping(address => mapping(address => uint256)) allowed;
161     uint256 public totalSupply;
162 }
163 
164 contract Tratok is StandardToken {
165 
166     function() {
167         throw;
168     }
169 
170     /* 
171      * The public variables of the token. Inclduing the name, the symbol and the number of decimals.
172      */
173     string public name;
174     uint8 public decimals;
175     string public symbol;
176     string public version = 'H1.0';
177 
178     /*
179      * Declaring the customized details of the token. The token will be called Tratok, with a total supply of 100 billion tokens.
180      * It will feature five decimal places and have the symbol TRAT.
181      */
182 
183     function Tratok() {
184 
185         //we will create 100 Billion Coins and send them to the creating wallet.
186         balances[msg.sender] = 10000000000000000;
187         totalSupply = 10000000000000000;
188         name = "Tratok";
189         decimals = 5;
190         symbol = "TRAT";
191     }
192 
193     /*
194      *Approve and enact the contract.
195      *
196      */
197     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success) {
198         allowed[msg.sender][_spender] = _value;
199         Approval(msg.sender, _spender, _value);
200 
201         //If the call fails, result to "vanilla" approval.
202         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
203             throw;
204         }
205         return true;
206     }
207 }