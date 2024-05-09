1 pragma solidity ^0.4.21;
2 
3 //SAFEMATHLIBRARY
4 //mmp
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 contract owned {
53     address public owner;
54 
55     function owned() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address newOwner) onlyOwner public {
65         owner = newOwner;
66     }
67 }
68 
69 
70 
71 
72  
73 contract RECFToken is owned {
74     
75     using SafeMath for uint256;
76     
77     // Public variables of the token
78     string public constant name = "RealEstateCryptoFund";
79     string public constant symbol = "RECF";
80     // 18 decimals is the strongly suggested default, avoid changing it
81     uint8 public constant decimals = 18;
82 
83     uint256 public totalSupply;
84 
85     // This creates an array with all balanceOf
86     mapping (address => uint256) public balanceOf;
87     mapping (address => mapping (address => uint256)) public allowance;
88     
89     
90     event Mint(address indexed to, uint256 amount);
91     event MintFinished();
92     bool public mintingFinished = false;
93 
94     modifier canMint() {
95     require(!mintingFinished);
96     _;
97     }
98 
99     // This generates a public event on the blockchain that will notify clients
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     // This notifies clients about the amount burnt
103     event Burn(address indexed from, uint256 value);
104 
105     /**
106      * Constrctor function
107      *
108      * Initializes contract with initial supply tokens to the creator of the contract
109      */
110     function RECFToken(
111         uint256 initialSupply
112     ) public {
113         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
114         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
115         
116     }
117 
118        /**
119     * @dev transfer token for a specified address
120     * @param _to The address to transfer to.
121     * @param _value The amount to be transferred.
122     */
123 function transfer(address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balanceOf[msg.sender]);
126     // SafeMath.sub will throw if there is not enough balance.
127     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
128     balanceOf[_to] = balanceOf[_to].add(_value);
129     emit Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balanceOf[_from]);
142     require(_value <= allowance[_from][msg.sender]);
143 
144     balanceOf[_from] = balanceOf[_from].sub(_value);
145     balanceOf[_to] = balanceOf[_to].add(_value);
146     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149     }
150 
151 
152 /* Internal transfer, only can be called by this contract */
153 function _transfer(address _from, address _to, uint _value) internal {
154         require(_to != address(0));                                // Prevent transfer to 0x0 address. Use burn() instead
155         require (balanceOf[_from] >= _value);                      // Check if the sender has enough
156         require (balanceOf[_to].add(_value) >= balanceOf[_to]);    // Check for overflows
157         balanceOf[_from] = balanceOf[_from].sub(_value);             // Subtract from the sender
158         balanceOf[_to] = balanceOf[_to].add(_value);               // Add the same to the recipient
159         emit Transfer(_from, _to, _value);
160     }
161 
162     /**
163 * @dev Function to mint tokens
164 * @param _to The address that will receive the minted tokens.
165 * @param _amount The amount of tokens to mint.
166 * @return A boolean that indicates if the operation was successful.
167 */
168 function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
169     totalSupply = totalSupply.add(_amount);
170     balanceOf[_to] = balanceOf[_to].add(_amount);
171     emit Mint(_to, _amount);
172     emit Transfer(address(0), _to, _amount);
173     return true;
174     }
175 
176     /**
177     * @dev Function to stop minting new tokens.
178     * @return True if the operation was successful.
179     */
180 function finishMinting() onlyOwner canMint public returns (bool) {
181     mintingFinished = true;
182     emit MintFinished();
183     return true;
184     }  
185 
186     
187    /**
188    * @dev Burns a specific amount of tokens.
189    * @param _value The amount of token to be burned.
190    */
191 function burn(uint256 _value) onlyOwner public {
192     require(_value <= balanceOf[msg.sender]);
193     // no need to require value <= totalSupply, since that would imply the
194     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
195 
196     address burner = msg.sender;
197     balanceOf[burner] = balanceOf[burner].sub(_value);
198     totalSupply = totalSupply.sub(_value);
199     emit Burn(burner, _value);
200     emit Transfer(burner, address(0), _value);
201   }
202 
203 
204 /**
205      * Destroy tokens from other account
206      *
207      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
208      *
209      * @param _from the address of the sender
210      * @param _value the amount of money to burn
211       
212      */
213 function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
214         require(balanceOf[_from] >= _value);                                                // Check if the targeted balance is enough
215         require(_value <= allowance[_from][msg.sender]);                                    // Check allowance
216         balanceOf[_from] = balanceOf[_from].sub(_value);                                   // Subtract from the targeted balance
217         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
218         totalSupply = totalSupply.sub(_value);                                                // Update totalSupply
219         emit Burn(_from, _value);
220         return true;
221         }
222 
223 
224 
225 }