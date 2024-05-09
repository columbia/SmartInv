1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83 
84     uint256 public totalSupply_;
85 
86     /**
87      * @dev total number of tokens in existence
88      */
89     function totalSupply() public view returns (uint256) {
90         return totalSupply_;
91     }
92 
93     /**
94      * @dev transfer token for a specified address
95      * @param _to The address to transfer to.
96      * @param _value The amount to be transferred.
97      */
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(msg.data.length>=(2*32)+4);
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         emit Transfer (msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111      * @dev Gets the balance of the specified address.
112      * @param _owner The address to query the the balance of.
113      * @return An uint256 representing the amount owned by the passed address.
114      */
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return balances[_owner];
117     }
118 }
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129     mapping (address => mapping (address => uint256)) internal allowed;
130 
131 
132     /**
133      * @dev Transfer tokens from one address to another
134      * @param _from address The address which you want to send tokens from
135      * @param _to address The address which you want to transfer to
136      * @param _value uint256 the amount of tokens to be transferred
137      */
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139         require(_to != address(0));
140         require(_value <= balances[_from]);
141         require(_value <= allowed[_from][msg.sender]);
142 
143         balances[_from] = balances[_from].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         emit Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      *
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param _spender The address which will spend the funds.
158      * @param _value The amount of tokens to be spent.
159      */
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         require(_value==0||allowed[msg.sender][_spender]==0);
162         require(msg.data.length>=(2*32)+4);
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     /**
169      * @dev Function to check the amount of tokens that an owner allowed to a spender.
170      * @param _owner address The address which owns the funds.
171      * @param _spender address The address which will spend the funds.
172      * @return A uint256 specifying the amount of tokens still available for the spender.
173      */
174     function allowance(address _owner, address _spender) public view returns (uint256) {
175         return allowed[_owner][_spender];
176     }
177 
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      *
181      * approve should be called when allowed[_spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * @param _spender The address which will spend the funds.
186      * @param _addedValue The amount of tokens to increase the allowance by.
187      */
188     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 
194     /**
195      * @dev Decrease the amount of tokens that an owner allowed to a spender.
196      *
197      * approve should be called when allowed[_spender] == 0. To decrement
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * @param _spender The address which will spend the funds.
202      * @param _subtractedValue The amount of tokens to decrease the allowance by.
203      */
204     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205         uint oldValue = allowed[msg.sender][_spender];
206         if (_subtractedValue > oldValue) {
207             allowed[msg.sender][_spender] = 0;
208         } else {
209             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210         }
211         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212         return true;
213     }
214 }
215 
216 contract FdcToken is StandardToken {
217     string public name;
218     string public symbol;
219     uint8 public decimals;
220     uint256 public precentDecimal=2;
221     uint256 public companyFundPrecent = 10;   
222     uint256 public codeTeamPrecent =90;
223     address public companyFundAccount;
224     address public codeTeamAccount;
225     uint256 public  companyFundBalance;
226     uint256 public  codeTeamBalance;
227     
228     constructor(string _name, string _symbol, uint8 _decimals, uint256 _initialSupply,address _companyFundAccount,address _codeTeamAccount) public {
229         name = _name;
230         symbol = _symbol;
231         decimals = _decimals;
232         totalSupply_ = _initialSupply;
233         companyFundAccount=_companyFundAccount;
234         codeTeamAccount=_codeTeamAccount;
235         companyFundBalance = totalSupply_.mul(companyFundPrecent).div(10 ** precentDecimal);
236         codeTeamBalance= totalSupply_.mul(codeTeamPrecent).div(10 ** precentDecimal);
237         balances[_companyFundAccount]=companyFundBalance;
238         balances[_codeTeamAccount]=codeTeamBalance;
239         
240     }
241     
242      /**
243      * @dev Transfer token
244      * @param _to the accept token address
245      * @param _value the number of transfer token
246      */
247     function transfer(address _to, uint256 _value) public returns (bool) {
248        return super.transfer(_to, _value);
249     } 
250     
251     /**
252      * @dev Transfer token
253      * @param _from the give token address
254      * @param _to the accept token address
255      * @param _value the number of transfer token
256      */
257     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
258         return super.transferFrom(_from, _to, _value);
259     }
260      
261      /**avoid mis-transfer*/
262      function() public payable{
263          revert();
264      }
265 }