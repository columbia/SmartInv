1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-04
3 */
4 
5 pragma solidity ^0.4.20;
6 // ----------------------------------------------------------------------------------------------
7 // BWF Token by Beowulf Network Limited.
8 // An ERC223 standard
9 //
10 // author: Beowulf Team
11 // Contact: william@beowulfchain.com
12 
13 library SafeMath {
14 
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24 
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29 
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 
35 }
36 
37 contract ERC20 {
38     // Get the total token supply
39     function totalSupply() public constant returns (uint256 _totalSupply);
40  
41     // Get the account balance of another account with address _owner
42     function balanceOf(address _owner) public constant returns (uint256 balance);
43  
44     // Send _value amount of tokens to address _to
45     function transfer(address _to, uint256 _value) public returns (bool success);
46     
47     // transfer _value amount of token approved by address _from
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
49     
50     // approve an address with _value amount of tokens
51     function approve(address _spender, uint256 _value) public returns (bool success);
52 
53     // get remaining token approved by _owner to _spender
54     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
55   
56     // Triggered when tokens are transferred.
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58  
59     // Triggered whenever approve(address _spender, uint256 _value) is called.
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 }
62 
63 contract ERC223 is ERC20{
64     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
65     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
66     event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);
67 }
68 
69 /// contract receiver interface
70 contract ContractReceiver {  
71     function tokenFallback(address _from, uint _value, bytes _data) external;
72 }
73 
74 contract BasicBeowulf is ERC223 {
75     using SafeMath for uint256;
76     
77     uint256 public constant decimals = 5;
78     string public constant symbol = "BWF";
79     string public constant name = "Beowulf";
80     uint256 public _totalSupply = 3 * 10 ** 14; // total supply is 3*10^14 unit, equivalent to 3 billion BWF
81 
82     // Owner of this contract
83     address public owner;
84     address public admin;
85 
86     // tradable
87     bool public tradable = false;
88 
89     // Balances BWF for each account
90     mapping(address => uint256) balances;
91     
92     // Owner of account approves the transfer of an amount to another account
93     mapping(address => mapping (address => uint256)) allowed;
94             
95     /**
96      * Functions with this modifier can only be executed by the owner
97      */
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     modifier isTradable(){
104         require(tradable == true || msg.sender == admin || msg.sender == owner);
105         _;
106     }
107 
108     /// @dev Constructor
109     function BasicBeowulf() 
110     public {
111         owner = msg.sender;
112         balances[owner] = _totalSupply;
113         Transfer(0x0, owner, _totalSupply);
114     }
115     
116     /// @dev Gets totalSupply
117     /// @return Total supply
118     function totalSupply()
119     public 
120     constant 
121     returns (uint256) {
122         return _totalSupply;
123     }
124         
125     /// @dev Gets account's balance
126     /// @param _addr Address of the account
127     /// @return Account balance
128     function balanceOf(address _addr) 
129     public
130     constant 
131     returns (uint256) {
132         return balances[_addr];
133     }
134     
135     
136     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
137     function isContract(address _addr) 
138     private 
139     view 
140     returns (bool is_contract) {
141         uint length;
142         assembly {
143             //retrieve the size of the code on target address, this needs assembly
144             length := extcodesize(_addr)
145         }
146         return (length>0);
147     }
148  
149     /// @dev Transfers the balance from msg.sender to an account
150     /// @param _to Recipient address
151     /// @param _value Transfered amount in unit
152     /// @return Transfer status
153     // Standard function transfer similar to ERC20 transfer with no _data .
154     // Added due to backwards compatibility reasons .
155     function transfer(address _to, uint _value) 
156     public 
157     isTradable
158     returns (bool success) {
159         require(_to != 0x0);
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162 
163         Transfer(msg.sender, _to, _value);
164         return true;
165     }
166     
167     /// @dev Function that is called when a user or another contract wants to transfer funds .
168     /// @param _to Recipient address
169     /// @param _value Transfer amount in unit
170     /// @param _data the data pass to contract reveiver
171     function transfer(
172         address _to, 
173         uint _value, 
174         bytes _data) 
175     public
176     isTradable 
177     returns (bool success) {
178         require(_to != 0x0);
179         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
180         balances[_to] = balanceOf(_to).add(_value);
181         Transfer(msg.sender, _to, _value);
182         if(isContract(_to)) {
183             ContractReceiver receiver = ContractReceiver(_to);
184             receiver.tokenFallback(msg.sender, _value, _data);
185             Transfer(msg.sender, _to, _value, _data);
186         }
187         
188         return true;
189     }
190     
191     /// @dev Function that is called when a user or another contract wants to transfer funds .
192     /// @param _to Recipient address
193     /// @param _value Transfer amount in unit
194     /// @param _data the data pass to contract reveiver
195     /// @param _custom_fallback custom name of fallback function
196     function transfer(
197         address _to, 
198         uint _value, 
199         bytes _data, 
200         string _custom_fallback) 
201     public 
202     isTradable
203     returns (bool success) {
204         require(_to != 0x0);
205         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
206         balances[_to] = balanceOf(_to).add(_value);
207         Transfer(msg.sender, _to, _value);
208 
209         if(isContract(_to)) {
210             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
211             Transfer(msg.sender, _to, _value, _data);
212         }
213         return true;
214     }
215          
216     // Send _value amount of tokens from address _from to address _to
217     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
218     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
219     // fees in sub-currencies; the command should fail unless the _from account has
220     // deliberately authorized the sender of the message via some mechanism; we propose
221     // these standardized APIs for approval:
222     function transferFrom(
223         address _from,
224         address _to,
225         uint256 _value)
226     public
227     isTradable
228     returns (bool success) {
229         require(_to != 0x0);
230         balances[_from] = balances[_from].sub(_value);
231         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232         balances[_to] = balances[_to].add(_value);
233 
234         Transfer(_from, _to, _value);
235         return true;
236     }
237     
238     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
239     // If this function is called again it overwrites the current allowance with _value.
240     function approve(address _spender, uint256 _amount) 
241     public
242     returns (bool success) {
243         allowed[msg.sender][_spender] = _amount;
244         Approval(msg.sender, _spender, _amount);
245         return true;
246     }
247     
248     // get allowance
249     function allowance(address _owner, address _spender) 
250     public
251     constant 
252     returns (uint256 remaining) {
253         return allowed[_owner][_spender];
254     }
255 
256     // withdraw any ERC20 token in this contract to owner
257     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
258         return ERC223(tokenAddress).transfer(owner, tokens);
259     }
260     
261     // @dev allow owner to update admin
262     function updateAdmin(address _admin) 
263     public 
264     onlyOwner{
265         admin = _admin;
266     }
267     
268     // allow people can transfer their token
269     // NOTE: can not turn off
270     function turnOnTradable() 
271     public onlyOwner {
272         tradable = true;
273     }
274 }
275 
276 contract Beowulf is BasicBeowulf {
277 
278 
279     function()
280     public
281     payable {
282         
283     }
284     
285     /// @dev Withdraws Ether in contract (Owner only)
286     /// @return Status of withdrawal
287     function withdraw() onlyOwner 
288     public 
289     returns (bool) {
290         return owner.send(this.balance);
291     }
292 }