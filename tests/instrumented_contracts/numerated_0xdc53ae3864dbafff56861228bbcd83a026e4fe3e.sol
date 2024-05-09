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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 interface tokenRecipient {
51     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
52     function tokenFallback(address _sender, uint256 _value, bytes _extraData) external returns(bool);
53 }
54 
55 contract EnzymToken {
56     using SafeMath for uint256;
57     // Public variables of the token
58     string public name;
59     string public symbol;
60     uint8 public decimals = 18;
61     uint256 public totalSupply;
62 
63     // This creates an array with all balances
64     mapping (address => uint256) public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowance;
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69     event Burn(address indexed from, uint256 value);
70 
71 
72     constructor(
73         uint256 initialSupply,
74         string tokenName,
75         string tokenSymbol
76     ) public {
77         totalSupply = initialSupply.mul(10 ** uint256(decimals));
78         balanceOf[msg.sender] = totalSupply;
79         name = tokenName;
80         symbol = tokenSymbol;
81     }
82 
83     function _transfer(address _from, address _to, uint _value) internal {
84         require(_to != 0x0);
85         require(balanceOf[_from] >= _value);
86 
87         balanceOf[_from] = balanceOf[_from].sub(_value);
88         balanceOf[_to] = balanceOf[_to].add(_value);
89         emit Transfer(_from, _to, _value);
90     }
91 
92     /**
93      * Transfer tokens
94      *
95      * Send `_value` tokens to `_to` from your account
96      *
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transfer(address _to, uint256 _value)
101     public returns (bool success) {
102         _transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Transfer tokens from other address
108      *
109      * Send `_value` tokens to `_to` on behalf of `_from`
110      *
111      * @param _from The address of the sender
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
116         require(_value <= allowance[_from][msg.sender]);     // Check allowance
117         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
118         _transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address
124      *
125      * Allows `_spender` to spend no more than `_value` tokens on your behalf
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      */
130     function approve(address _spender, uint256 _value)
131     public returns (bool success) {
132         allowance[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * Increase allowance for other address
139      *
140      * Allows `_spender` to spend additionnal `_addedValue` tokens on your behalf
141      *
142      * @param _spender The address authorized to spend
143      * @param _addedValue the additionnal amount they can spend
144      */
145     function increaseApproval(address _spender, uint256 _addedValue)
146     public returns (bool success) {
147         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
148         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
149         return true;
150     }
151 
152     /**
153      * Decrease allowance for other address
154      *
155      * Allows `_spender` to spend `_subtractedValue` less tokens on your behalf
156      *
157      * @param _spender The address authorized to spend
158      * @param _subtractedValue the amount they cannot spend anymore
159      */
160     function decreaseApproval(address _spender, uint256 _subtractedValue)
161     public returns (bool success) {
162         uint256 currentValue = allowance[msg.sender][_spender];
163         if(_subtractedValue > currentValue) {
164             allowance[msg.sender][_spender] = 0;
165         } else {
166             allowance[msg.sender][_spender] = currentValue.sub(_subtractedValue);
167         }
168         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
169         return true;
170     }
171 
172     /**
173      * Set allowance for other address and call spender
174      *
175      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
176      *
177      * @param _spender The address authorized to spend
178      * @param _value the max amount they can spend
179      * @param _extraData some extra information to send to the approved contract
180      */
181     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
182     public returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             spender.receiveApproval(msg.sender, _value, this, _extraData);
186             return true;
187         }
188     }
189 
190     /**
191      * Transfer tokens and call spender
192      *
193      * Transfer `_value` tokens to `_spender` on your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function transferAndCall(address _spender, uint256 _value, bytes _extraData)
200     public {
201         //if (isContract(_spender) && msg.sender != _spender) return contractFallback(_from, _to, _value, _data);
202         transfer(_spender, _value);
203         require(
204             tokenRecipient(_spender).tokenFallback(msg.sender, _value, _extraData)
205         );
206     }
207 
208     /**
209      * Destroy tokens
210      *
211      * Remove `_value` tokens from the system irreversibly
212      *
213      * @param _value the amount of money to burn
214      */
215     function burn(uint256 _value) public returns (bool success) {
216         require(balanceOf[msg.sender] >= _value);
217         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
218         totalSupply = totalSupply.sub(_value);
219         emit Burn(msg.sender, _value);
220         return true;
221     }
222 
223     /**
224      * Destroy tokens from other account
225      *
226      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
227      *
228      * @param _from the address of the sender
229      * @param _value the amount of money to burn
230      */
231     function burnFrom(address _from, uint256 _value) public returns (bool success) {
232         require(balanceOf[_from] >= _value);
233         require(_value <= allowance[_from][msg.sender]);
234         balanceOf[_from] = balanceOf[_from].sub(_value);
235         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
236         totalSupply = totalSupply.sub(_value);
237         emit Burn(_from, _value);
238         return true;
239     }
240 }