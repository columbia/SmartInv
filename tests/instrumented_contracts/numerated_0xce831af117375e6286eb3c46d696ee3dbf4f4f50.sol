1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract FullERC20 {
33   event Transfer(address indexed from, address indexed to, uint256 value);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35   
36   uint256 public totalSupply;
37   uint8 public decimals;
38 
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44 }
45 
46 contract BalanceHistoryToken is FullERC20 {
47   function balanceOfAtBlock(address who, uint256 blockNumber) public view returns (uint256);
48 }
49 
50 contract ProfitSharingToken is BalanceHistoryToken {
51   using SafeMath for uint256;
52 
53   string public name = "Fairgrounds";
54   string public symbol = "FGD";
55   uint8 public decimals = 2;
56   uint256 public constant INITIAL_SUPPLY = 10000000000; // 100M
57 
58   struct Snapshot {
59     uint192 block; // Still millions of years
60     uint64 balance; // > total supply
61   }
62 
63   mapping(address => Snapshot[]) public snapshots;
64   mapping (address => mapping (address => uint256)) internal allowed;
65 
66   event Burn(address indexed burner, uint256 value);
67 
68 
69   function ProfitSharingToken() public {
70       totalSupply = INITIAL_SUPPLY;
71       updateBalance(msg.sender, INITIAL_SUPPLY);
72   }
73 
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amount of tokens to be transferred
79    */
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balanceOf(_from));
83     require(_value <= allowed[_from][msg.sender]);
84 
85     updateBalance(_from, balanceOf(_from).sub(_value));
86     updateBalance(_to, balanceOf(_to).add(_value));
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     Transfer(_from, _to, _value);
89 
90     return true;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balanceOf(msg.sender));
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     updateBalance(msg.sender, balanceOf(msg.sender).sub(_value));
104     updateBalance(_to, balanceOf(_to).add(_value));
105     Transfer(msg.sender, _to, _value);
106 
107     return true;
108   }
109 
110   function balanceOfAtBlock(address who, uint256 blockNumber) public view returns (uint256) {
111     Snapshot[] storage snapshotHistory = snapshots[who];
112     if (snapshotHistory.length == 0 || blockNumber < snapshotHistory[0].block) {
113       return 0;
114     }
115 
116     // Check the last transfer value first
117     if (blockNumber >= snapshotHistory[snapshotHistory.length-1].block) {
118         return snapshotHistory[snapshotHistory.length-1].balance;
119     }
120 
121     // Search the snapshots until the value is found.
122     uint min = 0;
123     uint max = snapshotHistory.length-1;
124     while (max > min) {
125         uint mid = (max + min + 1) / 2;
126         if (snapshotHistory[mid].block <= blockNumber) {
127             min = mid;
128         } else {
129             max = mid-1;
130         }
131     }
132 
133     return snapshotHistory[min].balance;
134   }
135 
136   /// @dev Updates the balance to the provided value
137   function updateBalance(address who, uint value) internal {
138     snapshots[who].push(Snapshot(uint192(block.number), uint56(value)));
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     uint length = snapshots[_owner].length;
148     if (length == 0) {
149       return 0;
150     }
151 
152     return snapshots[_owner][length - 1].balance;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   /**
205   * @dev Burns a specific amount of tokens.
206   * @param _value The amount of token to be burned.
207   */
208   function burn(uint256 _value) public {
209     require(_value > 0);
210     require(_value <= balanceOf(msg.sender));
211     // no need to require value <= totalSupply, since that would imply the
212     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
213 
214     address burner = msg.sender;
215     updateBalance(burner, balanceOf(burner).sub(_value));
216     totalSupply = totalSupply.sub(_value);
217     Burn(burner, _value);
218   }
219 }