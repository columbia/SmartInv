1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6 **/
7 
8 library SafeMathLib{
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38 **/
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46     * account.
47     */
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     /**
53     * @dev Throws if called by any account other than the owner.
54     */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) onlyOwner public {
65         require(newOwner != address(0));
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 }
70 
71 contract APM is Ownable {
72     using SafeMathLib for uint256;
73     string public name;
74     string public symbol;
75     uint256 public totalSupply;
76     
77     // Balances for each account
78     mapping(address => uint256) balances;
79 
80     // Owner of account approves the transfer of an amount to another account
81     mapping(address => mapping (address => uint256)) allowed;
82     
83     event Transfer(address indexed from, address indexed to, uint tokens);
84     event Approval(address indexed from, address indexed spender, uint tokens);
85     
86     constructor(uint256 tokenSupply, string tokenName, string tokenSymbol) public {
87         totalSupply = tokenSupply; 
88         balances[msg.sender] = totalSupply;  
89         name = tokenName;                                 
90         symbol = tokenSymbol;                           
91     }
92 
93     /** ****************************** Internal ******************************** **/ 
94         /**
95          * @dev Internal transfer for all functions that transfer.
96          * @param _from The address that is transferring coins.
97          * @param _to The receiving address of the coins.
98          * @param _amount The amount of coins being transferred.
99         **/
100 
101         function _transfer(address _from, address _to, uint256 _amount) internal returns (bool success)
102         {
103             require (_to != address(0));
104             require(balances[_from] >= _amount);
105             
106             balances[_from] = balances[_from].sub(_amount);
107             balances[_to] = balances[_to].add(_amount);
108             
109             emit Transfer(_from, _to, _amount);
110             return true;
111         }
112         
113         /**
114          * @dev Internal approve for all functions that require an approve.
115          * @param _owner The owner who is allowing spender to use their balance.
116          * @param _spender The wallet approved to spend tokens.
117          * @param _amount The amount of tokens approved to spend.
118         **/
119         function _approve(address _owner, address _spender, uint256 _amount) internal returns (bool success)
120         {
121             allowed[_owner][_spender] = _amount;
122             emit Approval(_owner, _spender, _amount);
123             return true;
124         }
125         
126         /**
127          * @dev Increases the allowed by "_amount" for "_spender" from "owner"
128          * @param _owner The address that tokens may be transferred from.
129          * @param _spender The address that may transfer these tokens.
130          * @param _amount The amount of tokens to transfer.
131         **/
132         function _increaseApproval(address _owner, address _spender, uint256 _amount) internal returns (bool success)
133         {
134             allowed[_owner][_spender] = allowed[_owner][_spender].add(_amount);
135             emit Approval(_owner, _spender, allowed[_owner][_spender]);
136             return true;
137         }
138         
139         /**
140          * @dev Decreases the allowed by "_amount" for "_spender" from "_owner"
141          * @param _owner The owner of the tokens to decrease allowed for.
142          * @param _spender The spender whose allowed will decrease.
143          * @param _amount The amount of tokens to decrease allowed by.
144         **/
145         function _decreaseApproval(address _owner, address _spender, uint256 _amount) internal returns (bool success)
146         {
147             if (allowed[_owner][_spender] <= _amount) allowed[_owner][_spender] = 0;
148             else allowed[_owner][_spender] = allowed[_owner][_spender].sub(_amount);
149             
150             emit Approval(_owner, _spender, allowed[_owner][_spender]);
151             return true;
152         }
153     /** ****************************** End Internal ******************************** **/
154  
155 
156     /** ******************************** ERC20 ********************************* **/
157         /**
158          * @dev Transfers coins from one address to another.
159          * @param _to The recipient of the transfer amount.
160          * @param _amount The amount of tokens to transfer.
161         **/
162         function transfer(address _to, uint256 _amount) public returns (bool success)
163         {
164             require(_transfer(msg.sender, _to, _amount));
165             return true;
166         }
167         
168         /**
169          * @dev An allowed address can transfer tokens from another's address.
170          * @param _from The owner of the tokens to be transferred.
171          * @param _to The address to which the tokens will be transferred.
172          * @param _amount The amount of tokens to be transferred.
173         **/
174         function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
175         {
176             require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
177 
178             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
179             
180             require(_transfer(_from, _to, _amount));
181             return true;
182         }
183         
184         /**
185          * @dev Approves a wallet to transfer tokens on one's behalf.
186          * @param _spender The wallet approved to spend tokens.
187          * @param _amount The amount of tokens approved to spend.
188         **/
189         function approve(address _spender, uint256 _amount) public returns (bool success)
190         {
191             require(_approve(msg.sender, _spender, _amount));
192             return true;
193         }
194         
195         /**
196          * @dev Increases the allowed amount for spender from msg.sender.
197          * @param _spender The address to increase allowed amount for.
198          * @param _amount The amount of tokens to increase allowed amount by.
199         **/
200         function increaseApproval(address _spender, uint256 _amount) public returns (bool success)
201         {
202             require(_increaseApproval(msg.sender, _spender, _amount));
203             return true;
204         }
205         
206         /**
207          * @dev Decreases the allowed amount for spender from msg.sender.
208          * @param _spender The address to decrease allowed amount for.
209          * @param _amount The amount of tokens to decrease allowed amount by.
210         **/
211         function decreaseApproval(address _spender, uint256 _amount) public returns (bool success)
212         {
213             require(_decreaseApproval(msg.sender, _spender, _amount));
214             return true;
215         }
216     /** ******************************** End ERC20 ********************************* **/
217     
218 
219     /** ******************************** Avior Plus Miles ********************** **/
220         function transferDelegate(address _from, address _to, uint256 _amount, uint256 _fee) public onlyOwner returns (bool success) 
221         {
222             require(balances[_from] >= _amount + _fee);
223             require(_transfer(_from, _to, _amount));
224             require(_transfer(_from, msg.sender, _fee));
225             return true;
226         }
227     /** ******************************** END Avior Plus Miles ********************** **/
228 
229     
230     /** ****************************** Constants ******************************* **/
231     
232         /**
233          * @dev Return total supply of token.
234         **/
235         function totalSupply() external view returns (uint256)
236         {
237             return totalSupply;
238         }
239 
240         /**
241          * @dev Return balance of a certain address.
242          * @param _owner The address whose balance we want to check.
243         **/
244         function balanceOf(address _owner) external view returns (uint256) 
245         {
246             return balances[_owner];
247         }
248         
249         function notRedeemed() external view returns (uint256) 
250         {
251             return totalSupply - balances[owner];
252         }
253         
254         /**
255          * @dev Allowed amount for a user to spend of another's tokens.
256          * @param _owner The owner of the tokens approved to spend.
257          * @param _spender The address of the user allowed to spend the tokens.
258         **/
259         function allowance(address _owner, address _spender) external view returns (uint256) 
260         {
261             return allowed[_owner][_spender];
262         }
263     /** ****************************** END Constants ******************************* **/
264 }