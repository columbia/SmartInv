1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ISTCoin.sol
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 contract Ownable {
31     address public owner;
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33     constructor () public {
34         owner = msg.sender;
35     }
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 contract ERC20Basic {
47     function totalSupply() public view returns (uint256);
48     function balanceOf(address who) public view returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public view returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 contract BasicToken is ERC20Basic, Ownable {
61     using SafeMath for uint256;
62     mapping(address => uint256) balances;
63     uint256 public totalSupply_;
64     uint256 public privatePreSale;
65     uint256 public openPreSale;
66     uint256 public openSale;
67 
68     uint256 public ICOstarttime = 1533128400;
69     uint256 public ICOendtime =   1542204000;
70     //1533128400   //2018.8.1 August 1, 2018
71     //1542204000   //2018.11.14 Nov 14, 2018
72     /**
73     * @dev total number of tokens in existence
74     */
75     function totalSupply() public view returns (uint256) {
76         return totalSupply_;
77     }
78 
79     function ICOactive() public view returns (bool success) {
80        return ICOstarttime < now && now < ICOendtime;
81     }
82     /**
83     * @dev transfer token for a specified address
84     * @param _to The address to transfer to.
85     * @param _value The amount to be transferred.
86     */
87     function transfer(address _to, uint256 _value) public returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[msg.sender]);
90     if(msg.sender == owner){
91             if(now >= 1533128400 && now < 1534337940){
92                 privatePreSale = privatePreSale.sub(_value);
93             } else if(now >= 1534338000 && now < 1535547600){
94                 openPreSale = openPreSale.sub(_value);
95             }  else if(now > 1536152400 && now < 1542204000){
96                 openSale = openSale.sub(_value);
97             }
98         }
99 
100         // SafeMath.sub will throw if there is not enough balance.
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value);
104         return true;
105     }
106     /**
107     * @dev Gets the balance of the specified address.
108     * @param _owner The address to query the the balance of.
109     * @return An uint256 representing the amount owned by the passed address.
110     */
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balances[_owner];
113     }
114 }
115 contract StandardToken is ERC20, BasicToken {
116     mapping(address => mapping(address => uint256)) internal allowed;
117 
118     mapping (address => bool) public frozenAccount;
119 
120     event FrozenFunds(address target, bool frozen);
121 
122     function freezeAccount(address target, bool freeze) onlyOwner public {
123         frozenAccount[target] = freeze;
124         emit FrozenFunds(target, freeze);
125     }
126     /**
127      * @dev Transfer tokens from one address to another
128      * @param _from address The address which you want to send tokens from
129      * @param _to address The address which you want to transfer to
130      * @param _value uint256 the amount of tokens to be transferred
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[_from]);
135         require(_value <= allowed[_from][msg.sender]);
136         require (!ICOactive());
137         require(!frozenAccount[_from]);                     // Check if sender is frozen
138        require(!frozenAccount[_to]);                       // Check if recipient is frozen
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         emit Transfer(_from, _to, _value);
144         return true;
145     }
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161     /**
162      * @dev Function to check the amount of tokens that an owner allowed to a spender.
163      * @param _owner address The address which owns the funds.
164      * @param _spender address The address which will spend the funds.
165      * @return A uint256 specifying the amount of tokens still available for the spender.
166      */
167     function allowance(address _owner, address _spender) public view returns (uint256) {
168         return allowed[_owner][_spender];
169     }
170     /**
171      * @dev Increase the amount of tokens that an owner allowed to a spender.
172      *
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      * @param _spender The address which will spend the funds.
178      * @param _addedValue The amount of tokens to increase the allowance by.
179      */
180     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185     /**
186      * @dev Decrease the amount of tokens that an owner allowed to a spender.
187      *
188      * approve should be called when allowed[_spender] == 0. To decrement
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * @param _spender The address which will spend the funds.
193      * @param _subtractedValue The amount of tokens to decrease the allowance by.
194      */
195     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
196         uint oldValue = allowed[msg.sender][_spender];
197         if (_subtractedValue > oldValue) {
198             allowed[msg.sender][_spender] = 0;
199         } else {
200             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201         }
202         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 }
206 contract BurnableToken is BasicToken {
207     event Burn(address indexed burner, uint256 value);
208     /**
209      * @dev Burns a specific amount of tokens.
210      * @param _value The amount of token to be burned.
211      */
212     function burn(uint256 _value) public {
213         require(_value <= balances[msg.sender]);
214         // no need to require value <= totalSupply, since that would imply the
215         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
216         address burner = msg.sender;
217         balances[burner] = balances[burner].sub(_value);
218         totalSupply_ = totalSupply_.sub(_value);
219         emit Burn(burner, _value);
220     }
221 }
222 
223 contract ISTCoin is StandardToken, BurnableToken {
224     string public constant name = "ISTCoin";
225     string public constant symbol = "IST";
226     uint8 public constant decimals = 8;
227 
228     // Total Supply: 1 Billion
229     uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
230     constructor () public {
231         totalSupply_ = INITIAL_SUPPLY;
232         balances[msg.sender] = INITIAL_SUPPLY;
233         privatePreSale = 60000000 * (10 ** uint256(decimals));
234         openPreSale = 60000000 * (10 ** uint256(decimals));
235         openSale = 630000000 * (10 ** uint256(decimals));
236         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
237     }
238 }