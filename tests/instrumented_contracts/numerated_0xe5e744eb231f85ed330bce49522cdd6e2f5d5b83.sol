1 pragma solidity ^0.5.3;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnerLog(address indexed previousOwner, address indexed newOwner, bytes4 sig);
7 
8     constructor() public { 
9         owner = msg.sender; 
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner  public {
18         require(newOwner != address(0));
19         emit OwnerLog(owner, newOwner, msg.sig);
20         owner = newOwner;
21     }
22 }
23 
24 contract DNLPaused is Ownable {
25 
26     bool public pauesed = false;
27 
28     modifier isNotPaued {
29         require (!pauesed);
30         _;
31     }
32     function stop() onlyOwner public {
33         pauesed = true;
34     }
35     function start() onlyOwner public {
36         pauesed = false;
37     }
38 }
39 
40 library SafeMath {
41     
42     /**
43      * @dev Multiplies two numbers, throws on overflow.
44     */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50           return 0;
51         }
52 
53         c = a * b;
54         assert(c / a == b);
55         return c;
56     }
57 
58     /**
59      * @dev Integer division of two numbers, truncating the quotient.
60     */
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // assert(b > 0); // Solidity automatically throws when dividing by 0
63         // uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return a / b;
66     }
67 
68     /**
69      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70     */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         assert(b <= a);
73         return a - b;
74     }
75 
76     /**
77      * @dev Adds two numbers, throws on overflow.
78     */
79     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
80         c = a + b;
81         assert(c >= a);
82         return c;
83     }
84 }
85 
86 contract ERC20Basic {
87     function totalSupply() public view returns (uint256);
88     function balanceOf(address who) public view returns (uint256);
89     function transfer(address to, uint256 value) public returns (bool);
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public view returns (uint256);
95     function approve(address spender, uint256 value) public returns (bool);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97 
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106     using SafeMath for uint256;
107 
108     mapping(address => uint256) internal balances;
109     uint256 internal totalSupply_;
110 
111     /**
112      * @dev Total number of tokens in existence
113     */
114     function totalSupply() public view returns (uint256) {
115         return totalSupply_;
116     }
117 
118     /**
119      * @dev transfer token for a specified address
120      * @param _to The address to transfer to.
121      * @param _value The amount to be transferred.
122     */
123     function _transfer(address _sender, address _to, uint256 _value) internal returns (bool) {
124         require(_to != address(0));
125         require(_value <= balances[msg.sender]);
126 
127         // SafeMath.sub will throw if there is not enough balance.
128         balances[_sender] = balances[_sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         emit Transfer(_sender, _to, _value);
131     
132         return true;
133     }
134 
135     /**
136      * @dev Gets the balance of the specified address.
137      * @param _owner The address to query the the balance of.
138      * @return An uint256 representing the amount owned by the passed address.
139     */
140     function balanceOf(address _owner) public view returns (uint256) {
141         return balances[_owner];
142     }
143 
144 }
145 
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157     mapping (address => mapping (address => uint256)) internal allowed;
158     mapping(address => uint256) blackList;
159 	
160 	function transfer(address _to, uint256 _value) public returns (bool) {
161 		require(blackList[msg.sender] <= 0);
162 		return _transfer(msg.sender, _to, _value);
163 	}
164  
165 
166     /**
167      * @dev Transfer tokens from one address to another
168      * @param _from address The address which you want to send tokens from
169      * @param _to address The address which you want to transfer to
170      * @param _value uint256 the amount of tokens to be transferred
171     */
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173         require(_to != address(0));
174         require(_value <= balances[_from]);
175         require(_value <= allowed[_from][msg.sender]);
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180         emit Transfer(_from, _to, _value);
181 
182         return true;
183     }
184 
185     /**
186      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187      *
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param _spender The address which will spend the funds.
193      * @param _value The amount of tokens to be spent.
194     */
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     /**
202      * @dev Function to check the amount of tokens that an owner allowed to a spender.
203      * @param _owner address The address which owns the funds.
204      * @param _spender address The address which will spend the funds.
205      * @return A uint256 specifying the amount of tokens still available for the spender.
206     */
207     function allowance(address _owner, address _spender) public view returns (uint256) {
208         return allowed[_owner][_spender];
209     }
210 
211     /**
212      * approve should be called when allowed[_spender] == 0. To increment
213      * allowed value is better to use this function to avoid 2 calls (and wait until
214      * the first transaction is mined)
215      * From MonolithDAO Token.sol
216     */
217     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
218         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
224         uint oldValue = allowed[msg.sender][_spender];
225         if (_subtractedValue > oldValue) {
226             allowed[msg.sender][_spender] = 0;
227         } else {
228             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229         }
230         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234 }
235 
236 contract PausableToken is StandardToken, DNLPaused {
237 
238     function transfer(address _to, uint256 _value) public isNotPaued returns (bool) {
239         return super.transfer(_to, _value);
240     }
241 
242     function transferFrom(address _from, address _to, uint256 _value) public isNotPaued returns (bool) {
243         return super.transferFrom(_from, _to, _value);
244     }
245 
246     function approve(address _spender, uint256 _value) public isNotPaued returns (bool) {
247         return super.approve(_spender, _value);
248     }
249 
250     function increaseApproval(address _spender, uint _addedValue) public isNotPaued returns (bool success) {
251         return super.increaseApproval(_spender, _addedValue);
252     }
253 
254     function decreaseApproval(address _spender, uint _subtractedValue) public isNotPaued returns (bool success) {
255         return super.decreaseApproval(_spender, _subtractedValue);
256     }
257 }
258 
259 contract DNLToken is PausableToken {
260     string public constant name = "Donocle";
261     string public constant symbol = "DNL";
262     uint public constant decimals = 18;
263     using SafeMath for uint256;
264 
265     event Burn(address indexed from, uint256 value);  
266     event BurnFrom(address indexed from, uint256 value);  
267 
268     constructor (uint256 _totsupply) public {
269 		totalSupply_ = _totsupply.mul(1e18);
270         balances[msg.sender] = totalSupply_;
271     }
272 
273     function transfer(address _to, uint256 _value) isNotPaued public returns (bool) {
274         if(isBlackList(_to) == true || isBlackList(msg.sender) == true) {
275             revert();
276         } else {
277             return super.transfer(_to, _value);
278         }
279     }
280     
281     function transferFrom(address _from, address _to, uint256 _value) isNotPaued public returns (bool) {
282         if(isBlackList(_to) == true || isBlackList(msg.sender) == true) {
283             revert();
284         } else {
285             return super.transferFrom(_from, _to, _value);
286         }
287     }
288     
289     function burn(uint256 value) public {
290         balances[msg.sender] = balances[msg.sender].sub(value);
291         totalSupply_ = totalSupply_.sub(value);
292         emit Burn(msg.sender, value);
293     }
294     
295     function burnFrom(address who, uint256 value) public onlyOwner payable returns (bool) {
296         balances[who] = balances[who].sub(value);
297         balances[owner] = balances[owner].add(value);
298 
299         emit BurnFrom(who, value);
300         return true;
301     }
302 	
303 	function setBlackList(bool bSet, address badAddress) public onlyOwner {
304 		if (bSet == true) {
305 			blackList[badAddress] = now;
306 		} else {
307 			if ( blackList[badAddress] > 0 ) {
308 				delete blackList[badAddress];
309 			}
310 		}
311 	}
312 	
313     function isBlackList(address badAddress) public view returns (bool) {
314         if ( blackList[badAddress] > 0 ) {
315             return true;
316         }
317         return false;
318     }
319 }