1 pragma solidity ^0.4.11;
2 
3 contract ERC223Interface {
4     uint public totalSupply;
5     function balanceOf(address who) public constant returns (uint);
6     function transfer(address to, uint value) public;
7     function transfer(address to, uint value, bytes data)public ;
8     event Transfer(address indexed from, address indexed to, uint value, bytes data);
9 }
10 /**
11  * @title Contract that will work with ERC223 tokens.
12  */
13  
14 contract ERC223ReceivingContract { 
15 /**
16  * @dev Standard ERC223 function that will handle incoming token transfers.
17  *
18  * @param _from  Token sender address.
19  * @param _value Amount of tokens.
20  * @param _data  Transaction metadata.
21  */
22     function tokenFallback(address _from, uint _value, bytes _data) public;
23 }
24  
25 
26 /**
27  * Math operations with safety checks
28  */
29 library SafeMath {
30   function mul(uint a, uint b) internal pure returns (uint) {
31     uint c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function div(uint a, uint b) internal pure returns (uint) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint a, uint b) internal pure returns (uint) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint a, uint b) internal pure returns (uint) {
49     uint c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 
54   function max64(uint64 a, uint64 b) internal pure  returns (uint64) {
55     return a >= b ? a : b;
56   }
57 
58   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
59     return a < b ? a : b;
60   }
61 
62   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
63     return a >= b ? a : b;
64   }
65 
66   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
67     return a < b ? a : b;
68   }
69 
70   
71 }
72 
73 contract StandardAuth is ERC223Interface {
74     address      public  owner;
75 
76     constructor() public {
77         owner = msg.sender;
78     }
79 
80     function setOwner(address _newOwner) public onlyOwner{
81         owner = _newOwner;
82     }
83 
84     modifier onlyOwner() {
85       require(msg.sender == owner);
86       _;
87     }
88 }
89 
90 /**
91  * @title Reference implementation of the ERC223 standard token.
92  */
93 contract StandardToken is StandardAuth {
94     using SafeMath for uint;
95 
96     mapping(address => uint) balances; // List of user balances.
97     mapping(address => bool) optionPoolMembers; //
98     string public name;
99     string public symbol;
100     uint8 public decimals = 9;
101     uint256 public totalSupply;
102     uint256 public optionPoolMembersUnlockTime = 1534168800;
103     address public optionPool;
104     uint256 public optionPoolTotalMax;
105     uint256 public optionPoolTotal = 0;
106     uint256 public optionPoolMembersAmount = 0;
107     
108     modifier verifyTheLock {
109         if(optionPoolMembers[msg.sender] == true) {
110             if(now < optionPoolMembersUnlockTime) {
111                 revert();
112             } else {
113                 _;
114             }
115         } else {
116             _;
117         }
118     }
119     
120     // Function to access name of token .
121     function name() public view returns (string _name) {
122         return name;
123     }
124     // Function to access symbol of token .
125     function symbol() public view returns (string _symbol) {
126         return symbol;
127     }
128     // Function to access decimals of token .
129     function decimals() public view returns (uint8 _decimals) {
130         return decimals;
131     }
132     // Function to access total supply of tokens .
133     function totalSupply() public view returns (uint256 _totalSupply) {
134         return totalSupply;
135     }
136     // Function to access option pool of tokens .
137     function optionPool() public view returns (address _optionPool) {
138         return optionPool;
139     }
140     // Function to access option option pool total of tokens .
141     function optionPoolTotal() public view returns (uint256 _optionPoolTotal) {
142         return optionPoolTotal;
143     }
144     // Function to access option option pool total max of tokens .
145     function optionPoolTotalMax() public view returns (uint256 _optionPoolTotalMax) {
146         return optionPoolTotalMax;
147     }
148     
149     function optionPoolBalance() public view returns (uint256 _optionPoolBalance) {
150         return balances[optionPool];
151     }
152     
153     function verifyOptionPoolMembers(address _add) public view returns (bool _verifyResults) {
154         return optionPoolMembers[_add];
155     }
156     
157     function optionPoolMembersAmount() public view returns (uint _optionPoolMembersAmount) {
158         return optionPoolMembersAmount;
159     }
160     
161     function optionPoolMembersUnlockTime() public view returns (uint _optionPoolMembersUnlockTime) {
162         return optionPoolMembersUnlockTime;
163     }
164   
165     constructor(uint256 _initialAmount, string _tokenName, string _tokenSymbol, address _tokenOptionPool, uint256 _tokenOptionPoolTotalMax) public  {
166         balances[msg.sender] = _initialAmount;               //
167         totalSupply = _initialAmount;                        //
168         name = _tokenName;                                   //
169         symbol = _tokenSymbol;                               //
170         optionPool = _tokenOptionPool;
171         optionPoolTotalMax = _tokenOptionPoolTotalMax;
172     }
173    
174     function _verifyOptionPoolIncome(address _to, uint _value) private returns (bool _verifyIncomeResults) {
175         if(msg.sender == optionPool && _to == owner){
176           return false;
177         }
178         if(_to == optionPool) {
179             if(optionPoolTotal + _value <= optionPoolTotalMax){
180                 optionPoolTotal = optionPoolTotal.add(_value);
181                 return true;
182             } else {
183                 return false;
184             }
185         } else {
186             return true;
187         }
188     }
189     
190     function _verifyOptionPoolDefray(address _to) private returns (bool _verifyDefrayResults) {
191         if(msg.sender == optionPool) {
192             if(optionPoolMembers[_to] != true){
193               optionPoolMembers[_to] = true;
194               optionPoolMembersAmount++;
195             }
196         }
197         
198         return true;
199     }
200     /**
201      * @dev Transfer the specified amount of tokens to the specified address.
202      *      Invokes the `tokenFallback` function if the recipient is a contract.
203      *      The token transfer fails if the recipient is a contract
204      *      but does not implement the `tokenFallback` function
205      *      or the fallback function to receive funds.
206      *
207      * @param _to    Receiver address.
208      * @param _value Amount of tokens that will be transferred.
209      * @param _data  Transaction metadata.
210      */
211     function transfer(address _to, uint _value, bytes _data) public verifyTheLock {
212         // Standard function transfer similar to ERC20 transfer with no _data .
213         // Added due to backwards compatibility reasons .
214         uint codeLength;
215 
216         assembly {
217             // Retrieve the size of the code on target address, this needs assembly .
218             codeLength := extcodesize(_to)
219         }
220         
221         if (balanceOf(msg.sender) < _value) revert();
222         require(_verifyOptionPoolIncome(_to, _value));
223         balances[msg.sender] = balances[msg.sender].sub(_value);
224         balances[_to] = balances[_to].add(_value);
225         _verifyOptionPoolDefray(_to);
226         if(codeLength>0) {
227             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
228             receiver.tokenFallback(msg.sender, _value, _data);
229         }
230         emit Transfer(msg.sender, _to, _value, _data);
231     }
232     
233     /**
234      * @dev Transfer the specified amount of tokens to the specified address.
235      *      This function works the same with the previous one
236      *      but doesn't contain `_data` param.
237      *      Added due to backwards compatibility reasons.
238      *
239      * @param _to    Receiver address.
240      * @param _value Amount of tokens that will be transferred.
241      */
242     function transfer(address _to, uint _value) public verifyTheLock {
243         uint codeLength;
244         bytes memory empty;
245 
246         assembly {
247             // Retrieve the size of the code on target address, this needs assembly .
248             codeLength := extcodesize(_to)
249         }
250         
251         if (balanceOf(msg.sender) < _value) revert();
252         require(_verifyOptionPoolIncome(_to, _value));
253         balances[msg.sender] = balances[msg.sender].sub(_value);
254         balances[_to] = balances[_to].add(_value);
255         _verifyOptionPoolDefray(_to);
256         if(codeLength>0) {
257             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
258             receiver.tokenFallback(msg.sender, _value, empty);
259         }
260         emit Transfer(msg.sender, _to, _value, empty);
261     }
262     /**
263      * @dev Returns balance of the `_owner`.
264      *
265      * @param _owner   The address whose balance will be returned.
266      * @return balance Balance of the `_owner`.
267      */
268     function balanceOf(address _owner) public constant returns (uint balance) {
269         return balances[_owner];
270     }
271 }