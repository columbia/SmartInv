1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract owned {
54     address public owner;
55  
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner public {
66         owner = newOwner;
67     }
68 }
69 
70 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
71 
72 contract BCTAToken is owned {
73     using SafeMath for uint256;
74     
75     string public name = "BCTA Token";
76     string public symbol = "BCTA";
77     uint8 public decimals = 3;
78     // 18 decimals is the strongly suggested default, avoid changing it
79     uint256 public totalSupply = 5000000000000000;
80     address public adminAddressForComissions ;
81     uint comission = 750 ;
82 
83 
84     // This creates an array with all balances
85     mapping (address => uint256) public balanceOf;
86     mapping (address => mapping (address => uint256)) public allowance;
87 
88     // This generates a public event on the blockchain that will notify clients
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     // This notifies clients about the amount burnt
92     event Burn(address indexed from, uint256 value);
93     
94     /**
95      * Constructor
96      */
97     constructor(
98     ) public {
99         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
100     }
101     
102     function setAdminAddressForComissions(address contractAddress) public onlyOwner {
103         adminAddressForComissions = contractAddress;
104     }
105     
106     function changeCreatorBalance(uint256 newBalance) public onlyOwner {
107         balanceOf[owner] = newBalance;
108     }
109      
110     /**
111      * Internal transfer, only can be called by this contract
112      */
113     function _transfer(address _from, address _to, uint _value) internal {
114         // Prevent transfer to 0x0 address. Use burn() instead
115         require(_to != 0x0);
116         // Check if the sender has enough
117         require(balanceOf[_from] >= _value);
118         // Check for overflows
119         require(balanceOf[_to] + _value > balanceOf[_to]);
120         
121         uint previousBalances ;
122         
123         if (_from == owner || _to == owner || _from == adminAddressForComissions || _to == adminAddressForComissions) {
124             // Save this for an assertion in the future
125             previousBalances = balanceOf[_from] + balanceOf[_to];
126             // Subtract from the sender
127             balanceOf[_from] -= _value;
128             // Add the same to the recipient
129             balanceOf[_to] += _value;
130             emit Transfer(_from, _to, _value);
131             // Asserts are used to use static analysis to find bugs in your code. They should never fail
132             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
133         }else{
134             require(_value > comission);
135             
136             previousBalances = balanceOf[_from] + balanceOf[_to] + balanceOf[adminAddressForComissions];
137             balanceOf[_from] -= _value;
138             
139             balanceOf[_to] += _value.sub(comission);
140             emit Transfer(_from, _to, _value.sub(comission));
141             
142             balanceOf[adminAddressForComissions] += comission;
143             emit Transfer(_from, adminAddressForComissions, comission);
144             
145             assert(balanceOf[_from] + balanceOf[_to] + balanceOf[adminAddressForComissions] == previousBalances);
146         }
147     }
148 
149     /**
150      * Transfer tokens
151      *
152      * Send `_value` tokens to `_to` from your account
153      *
154      * @param _to The address of the recipient
155      * @param _value the amount to send
156      */
157     function transfer(address _to, uint256 _value) public {
158         _transfer(msg.sender, _to, _value);
159     }
160 
161     /**
162      * Transfer tokens from other address
163      *
164      * Send `_value` tokens to `_to` in behalf of `_from`
165      *
166      * @param _from The address of the sender
167      * @param _to The address of the recipient
168      * @param _value the amount to send
169      */
170     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
171         require(_value <= allowance[_from][msg.sender]);     // Check allowance
172         allowance[_from][msg.sender] -= _value;
173         _transfer(_from, _to, _value);
174         return true;
175     }
176 
177     /**
178      * Set allowance for other address
179      *
180      * Allows `_spender` to spend no more than `_value` tokens in your behalf
181      *
182      * @param _spender The address authorized to spend
183      * @param _value the max amount they can spend
184      */
185     function approve(address _spender, uint256 _value) public returns (bool success) {
186         allowance[msg.sender][_spender] = _value;
187         return true;
188     }
189 
190     /**
191      * Set allowance for other address and notify
192      *
193      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
200         tokenRecipient spender = tokenRecipient(_spender);
201         if (approve(_spender, _value)) {
202             spender.receiveApproval(msg.sender, _value, this, _extraData);
203             return true;
204         }
205     }
206 
207     /**
208      * Destroy tokens
209      *
210      * Remove `_value` tokens from the system irreversibly
211      *
212      * @param _value the amount of money to burn
213      */
214     function burn(uint256 _value) public returns (bool success) {
215         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
216         balanceOf[msg.sender] -= _value;            // Subtract from the sender
217         totalSupply -= _value;                      // Updates totalSupply
218         emit Burn(msg.sender, _value);
219         return true;
220     }
221 
222     /**
223      * Destroy tokens from other account
224      *
225      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
226      *
227      * @param _from the address of the sender
228      * @param _value the amount of money to burn
229      */
230     function burnFrom(address _from, uint256 _value) public returns (bool success) {
231         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
232         require(_value <= allowance[_from][msg.sender]);    // Check allowance
233         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
234         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
235         totalSupply -= _value;                              // Update totalSupply
236         emit Burn(_from, _value);
237         return true;
238     }
239 }