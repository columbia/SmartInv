1 pragma solidity ^0.4.23;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         if (a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30     constructor () public {
31         owner = msg.sender;
32     }
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 }
43 contract ERC20Basic {
44     function totalSupply() public view returns (uint256);
45     function balanceOf(address who) public view returns (uint256);
46     function transfer(address to, uint256 value) public returns (bool);
47     
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender) public view returns (uint256);
52     function transferFrom(address from, address to, uint256 value) public returns (bool);
53     function approve(address spender, uint256 value) public returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 contract BasicToken is ERC20Basic, Ownable {
57     using SafeMath for uint256;
58     mapping(address => uint256) balances;
59     uint256 public totalSupply_;
60     uint256 public privatePreSale;
61     uint256 public openPreSale;
62     uint256 public openSale;
63     
64     uint256 public ICOstarttime = 1533128400;
65     uint256 public ICOendtime =   1542204000;
66     //1533128400   //2018.8.1 August 1, 2018
67     //1542204000   //2018.11.14 Nov 14, 2018
68     /**
69     * @dev total number of tokens in existence
70     */
71     function totalSupply() public view returns (uint256) {
72         return totalSupply_;
73     }
74     
75     function ICOactive() public view returns (bool success) {
76        return ICOstarttime < now && now < ICOendtime;
77     }
78     /**
79     * @dev transfer token for a specified address
80     * @param _to The address to transfer to.
81     * @param _value The amount to be transferred.
82     */
83     function transfer(address _to, uint256 _value) public returns (bool) {
84         require(_to != address(0));
85         require(_value <= balances[msg.sender]);
86     if(msg.sender == owner){
87             if(now >= 1533128400 && now < 1534337940){
88                 privatePreSale = privatePreSale.sub(_value);
89             } else if(now >= 1534338000 && now < 1535547600){
90                 openPreSale = openPreSale.sub(_value);
91             }  else if(now > 1536152400 && now < 1542204000){ 
92                 openSale = openSale.sub(_value);
93             } 
94         }
95         
96         // SafeMath.sub will throw if there is not enough balance.
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         emit Transfer(msg.sender, _to, _value);
100         return true;
101     }
102     /**
103     * @dev Gets the balance of the specified address.
104     * @param _owner The address to query the the balance of.
105     * @return An uint256 representing the amount owned by the passed address.
106     */
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 }
111 contract StandardToken is ERC20, BasicToken {
112     mapping(address => mapping(address => uint256)) internal allowed;
113     
114     mapping (address => bool) public frozenAccount;
115     
116     event FrozenFunds(address target, bool frozen);
117        
118     function freezeAccount(address target, bool freeze) onlyOwner public {
119         frozenAccount[target] = freeze;
120         emit FrozenFunds(target, freeze);
121     }
122     /**
123      * @dev Transfer tokens from one address to another
124      * @param _from address The address which you want to send tokens from
125      * @param _to address The address which you want to transfer to
126      * @param _value uint256 the amount of tokens to be transferred
127      */
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132         require (!ICOactive());
133         require(!frozenAccount[_from]);                     // Check if sender is frozen
134         require(!frozenAccount[_to]);                       // Check if recipient is frozen
135     
136         balances[_from] = balances[_from].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139         emit Transfer(_from, _to, _value);
140         return true;
141     }
142     /**
143      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144      *
145      * Beware that changing an allowance with this method brings the risk that someone may use both the old
146      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      * @param _spender The address which will spend the funds.
150      * @param _value The amount of tokens to be spent.
151      */
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157     /**
158      * @dev Function to check the amount of tokens that an owner allowed to a spender.
159      * @param _owner address The address which owns the funds.
160      * @param _spender address The address which will spend the funds.
161      * @return A uint256 specifying the amount of tokens still available for the spender.
162      */
163     function allowance(address _owner, address _spender) public view returns (uint256) {
164         return allowed[_owner][_spender];
165     }
166     /**
167      * @dev Increase the amount of tokens that an owner allowed to a spender.
168      *
169      * approve should be called when allowed[_spender] == 0. To increment
170      * allowed value is better to use this function to avoid 2 calls (and wait until
171      * the first transaction is mined)
172      * From MonolithDAO Token.sol
173      * @param _spender The address which will spend the funds.
174      * @param _addedValue The amount of tokens to increase the allowance by.
175      */
176     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179         return true;
180     }
181     /**
182      * @dev Decrease the amount of tokens that an owner allowed to a spender.
183      *
184      * approve should be called when allowed[_spender] == 0. To decrement
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * @param _spender The address which will spend the funds.
189      * @param _subtractedValue The amount of tokens to decrease the allowance by.
190      */
191     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192         uint oldValue = allowed[msg.sender][_spender];
193         if (_subtractedValue > oldValue) {
194             allowed[msg.sender][_spender] = 0;
195         } else {
196             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197         }
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 }
202 contract BurnableToken is BasicToken {
203     event Burn(address indexed burner, uint256 value);
204     /**
205      * @dev Burns a specific amount of tokens.
206      * @param _value The amount of token to be burned.
207      */
208     function burn(uint256 _value) public {
209         require(_value <= balances[msg.sender]);
210         // no need to require value <= totalSupply, since that would imply the
211         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
212         address burner = msg.sender;
213         balances[burner] = balances[burner].sub(_value);
214         totalSupply_ = totalSupply_.sub(_value);
215         emit Burn(burner, _value);
216     }
217 }
218 contract BDTToken is StandardToken, BurnableToken {
219     string public constant name = "BDT Token";
220     string public constant symbol = "BDT";
221     uint8 public constant decimals = 18;
222     
223     // Total Supply: 1 Billion
224     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
225     constructor () public {
226         totalSupply_ = INITIAL_SUPPLY;
227         balances[msg.sender] = INITIAL_SUPPLY;
228         privatePreSale = 60000000 * (10 ** uint256(decimals));
229         openPreSale = 60000000 * (10 ** uint256(decimals));
230         openSale = 630000000 * (10 ** uint256(decimals));
231         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
232     }
233 }