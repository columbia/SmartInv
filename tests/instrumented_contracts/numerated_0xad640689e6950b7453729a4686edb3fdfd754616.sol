1 pragma solidity ^0.4.18;
2 
3 interface TransferRecipient {
4 	function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns(bool);
5 }
6 
7 interface ApprovalRecipient {
8 	function approvalFallback(address _from, uint256 _value, bytes _extraData) public returns(bool);
9 }
10 contract ERCToken {
11 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
12 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 	uint256 public  totalSupply;
14 	mapping (address => uint256) public balanceOf;
15 
16 	function allowance(address _owner,address _spender) public view returns(uint256);
17 	function transfer(address _to, uint256 _value) public returns (bool success);
18 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19 	function approve(address _spender, uint256 _value) public  returns (bool success);
20 
21 
22 }
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29   address public owner;
30 
31 
32 
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) onlyOwner public {
52         owner = newOwner;
53   }
54 
55 }
56 pragma solidity ^0.4.18;
57 
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     if (a == 0) {
66       return 0;
67     }
68     uint256 c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 contract CICToken is ERCToken,Ownable {
92 
93     using SafeMath for uint256;
94     string public name;
95     string public symbol;
96     uint8 public decimals=18;
97     mapping (address => bool) public frozenAccount;
98     mapping (address => mapping (address => uint256)) internal allowed;
99     event FrozenFunds(address target, bool frozen);
100 
101 
102   function CICToken(
103         string tokenName,
104         string tokenSymbol
105     ) public {
106         totalSupply = 30e8 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
107         balanceOf[msg.sender] = totalSupply;                   // Give the creator all initial tokens
108         name = tokenName;                                      // Set the name for display purposes
109         symbol = tokenSymbol;
110      }
111     
112 
113    /**
114      * Internal transfer, only can be called by this contract
115      */
116     function _transfer(address _from, address _to, uint _value) internal {
117 
118         // Prevent transfer to 0x0 address. Use burn() instead
119         require(_to != 0x0);
120         // Check if the sender has enough
121         require(balanceOf[_from] >= _value);
122         // Check for overflows
123         require(balanceOf[_to] + _value > balanceOf[_to]);
124         require(!frozenAccount[_from]);
125         // Save this for an assertion in the future
126         uint previousbalanceOf = balanceOf[_from].add(balanceOf[_to]);
127 
128         // Subtract from the sender
129         balanceOf[_from] = balanceOf[_from].sub(_value);
130         // Add the same to the recipient
131         balanceOf[_to] =balanceOf[_to].add(_value);
132         Transfer(_from, _to, _value);
133         // Asserts are used to use static analysis to find bugs in your code. They should never fail
134         assert(balanceOf[_from].add(balanceOf[_to]) == previousbalanceOf);
135     }
136 
137 
138     /**
139      * Transfer tokens
140      *
141      * Send `_value` tokens to `_to` from your account
142      *
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transfer(address _to, uint256 _value) public returns (bool success){
147         _transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151 
152 
153     function transferAndCall(address _to, uint256 _value, bytes _data)
154         public
155         returns (bool success) {
156         _transfer(msg.sender,_to, _value);
157         if(_isContract(_to))
158         {
159             TransferRecipient spender = TransferRecipient(_to);
160             if(!spender.tokenFallback(msg.sender, _value, _data))
161             {
162                 revert();
163             }
164         }
165         return true;
166     }
167 
168 
169     function _isContract(address _addr) private view returns (bool is_contract) {
170       uint length;
171       assembly {
172             //retrieve the size of the code on target address, this needs assembly
173             length := extcodesize(_addr)
174       }
175       return (length>0);
176     }
177 
178     /**
179      * Transfer tokens from other address
180      *
181      * Send `_value` tokens to `_to` on behalf of `_from`
182      *
183      * @param _from The address of the sender
184      * @param _to The address of the recipient
185      * @param _value the amount to send
186      */
187     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
188         require(_value <= allowed[_from][msg.sender]);     // Check allowance
189         allowed[_from][msg.sender]= allowed[_from][msg.sender].sub(_value);
190         _transfer(_from, _to, _value);
191         return true;
192     }
193 
194 
195     function allowance(address _owner,address _spender) public view returns(uint256){
196         return allowed[_owner][_spender];
197 
198     }
199 
200     /**
201     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202     *
203     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204     * @param _spender The address which will spend the funds.
205     * @param _value The amount of tokens to be spent.
206     */
207     function approve(address _spender, uint256 _value) public  returns (bool) {
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213 
214     /**
215      * Set allowance for other address and notify
216      *
217      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
218      *
219      * @param _spender The address authorized to spend
220      * @param _value the max amount they can spend
221      * @param _extraData some extra information to send to the approved contract
222      */
223     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
224         public
225         returns (bool success) {
226 
227         allowed[msg.sender][_spender] = _value;
228         if(_isContract(_spender)){
229             ApprovalRecipient spender = ApprovalRecipient(_spender);
230             if(!spender.approvalFallback(msg.sender, _value, _extraData)){
231                 revert();
232             }
233         }
234         Approval(msg.sender, _spender, _value);
235         return true;
236 
237     }
238 
239 
240     function freezeAccount(address target, bool freeze) onlyOwner public{
241         frozenAccount[target] = freeze;
242         FrozenFunds(target, freeze);
243     }
244 
245 
246 
247 
248 }