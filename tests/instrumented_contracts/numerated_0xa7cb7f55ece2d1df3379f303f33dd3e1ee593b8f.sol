1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     require(b <= a);
6     return a - b;
7   }
8 }
9 
10 contract Ownable {
11 
12   /**
13    * @dev set `owner` of the contract to the sender
14    */
15   address public owner = msg.sender;
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] += _value;
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] += _value;
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150   
151 }
152 
153 /**
154  * @title Mintable token
155  * @dev Simple ERC20 Token example, with mintable token creation
156  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
157  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
158  */
159 contract MintableToken is StandardToken, Ownable {
160   event Mint(address indexed to, uint256 amount);
161   event Burn(address indexed burner, uint value);
162   event MintFinished();
163 
164   bool public mintingFinished = false;
165 
166 
167   modifier canMint() {
168     require(!mintingFinished);
169     _;
170   }
171 
172   /**
173    * @dev Function to mint tokens
174    * @param _to The address that will receive the minted tokens.
175    * @param _amount The amount of tokens to mint.
176    * @return A boolean that indicates if the operation was successful.
177    */
178   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
179     totalSupply += _amount;
180     balances[_to] += _amount;
181     Mint(_to, _amount);
182     Transfer(address(0), _to, _amount);
183     return true;
184   }
185 
186   /**
187    * @dev Function to burn tokens
188    * @param _addr The address that will have _amount of tokens burned.
189    * @param _amount The amount of tokens to burn.
190    */
191   function burn(address _addr, uint _amount) onlyOwner public {
192     require(_amount > 0 && balances[_addr] >= _amount && totalSupply >= _amount);
193     balances[_addr] -= _amount;
194     totalSupply -= _amount;
195     Burn(_addr, _amount);
196     Transfer(_addr, address(0), _amount);
197   }
198 
199   /**
200    * @dev Function to stop minting new tokens.
201    * @return True if the operation was successful.
202    */
203   function finishMinting() onlyOwner canMint public returns (bool) {
204     mintingFinished = true;
205     MintFinished();
206     return true;
207   }
208 }
209 
210 contract WealthBuilderToken is MintableToken {
211     
212     string public name = "Wealth Builder Token";
213     
214     string public symbol = "WBT";
215     
216     uint32 public decimals = 18;
217 
218     /**
219      *  how many {tokens*10^(-18)} get per 1wei
220      */
221     uint public rate = 10**7;
222     /**
223      *  multiplicator for rate
224      */
225     uint public mrate = 10**7;
226 
227     function setRate(uint _rate) onlyOwner public {
228         rate = _rate;
229     }
230     
231 }